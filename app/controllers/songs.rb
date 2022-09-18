# -*- coding: utf-8 -*-
require 'uri'

TScore::App.controllers :songs do
  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get "/example" do
  #   "Hello world!"
  # end

  get :index do
    @my_songs = Song.where(:account_id => current_account.id).order('title asc')
    @public_songs = Song.publics.order('title asc')
    render 'songs/index'
  end

  get :show, :with => :id do
    @song = Song.find(params[:id])
    render 'songs/show'
  end

  get :show_extra, :with => :id do
    @song = Song.find(params[:id])
    render 'songs/show_extra'
  end

  get :new do
    @song = Song.new
    @song.tempo = 100
    render 'songs/new'
  end

  post :create do
    @song = Song.new(params[:song])
    @song.account = current_account
    if @song.save
      flash[:notice] = '曲が作成されました'
      redirect url(:songs, :show, :id => @song.id)
    else
      render 'songs/new'
    end
  end

  get :edit, :with => :id do
    @song = Song.find(params[:id])
    render 'songs/edit'
  end

  put :update, :with => :id do
    @song = Song.find(params[:id])
    unless @song.account == current_account || current_account.role == 'admin'
      flash[:error] = '編集する権限がありません'
      render 'songs/edit'
    end
    if @song.update(params[:song])
      flash[:notice] = '曲が更新されました。'
      redirect url(:songs, :show, :id => @song.id)
    else
      render 'songs/edit'
    end
  end

  delete :destroy, :with => :id do
    @song = Song.find(params[:id])
    unless @song
      flush[:warning] = '曲が存在しません'
      halt 404
    end
    title = @song.title
    unless @song.account == current_account || current_account.role == 'admin'
      flash[:error] = '削除する権限がありません'
      redirect url(:songs, :show_extra, :id => @song.id)
    end
    if @song.tracks.size > 0
      flash[:error] = '最初にトラックをすべて削除してください'
      redirect url(:songs, :show_extra, :id => @song.id)
    end
    if @song.destroy
      flash[:notice] = "曲 #{title} が削除されました。"
      redirect url(:songs, :index)
    else
      flash[:notice] = '削除が失敗しました'
      redirect url(:songs, :show_extra, :id => @song.id)
    end
  end

  get :play_data_midi, :map => '/songs/play/:id.mid' do
    song = Song.find(params[:id])
    body = MidiConverter.new.convert(song)
    [200,
     {'Content-Type' => 'audio/midi',
       'Content-Disposition' => "attachment; filename*=UTF-8''#{URI::escape(song.title)}.mid",
       'Accept-Ranges' => 'bytes'},
     body]
  end

  get :play_data_mp3, :map => '/songs/play/:id.mp3' do
    song = Song.find(params[:id])
    tns = params[:tracks].split(',').map(&:to_i) rescue nil
    tracks = tns == nil ? nil : song.tracks.select {|t| tns.include?(t.track_number) }
    body = MidiConverter.new.render_to_mp3(song, tracks)
    [200,
     {'Content-Type' => 'audio/mp3',
       'Content-Disposition' => "attachment; filename*=UTF-8''#{URI.encode_www_form_component(song.title)}.mp3",
       'Accept-Ranges' => 'bytes',
       'Expires' => (Time.now + 5).rfc822 },
     body]
  end

  get :play, :with => :id do
    @song = Song.find(params[:id])
    render 'songs/play'
  end

  get :show_all do
    @hash = {}
    Account.all.each do |a|
      songs = Song.where(:account_id => a.id).order('title asc')
      @hash[a.name] = songs
    end
    render 'songs/show_all'
  end
end
