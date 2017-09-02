# -*- coding: utf-8 -*-
require 'uri'

TScore.controllers :songs do
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
    if @song.update_attributes(params[:song])
      flash[:notice] = '曲が更新されました。'
      redirect url(:songs, :show, :id => @song.id)
    else
      render 'songs/edit'
    end
  end

  get :play_data, :map => '/songs/play/:id.mid' do
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
    body = MidiConverter.new.render_to_mp3(song)
    [200,
     {'Content-Type' => 'audio/mp3',
       'Content-Disposition' => "attachment; filename*=UTF-8''#{URI::escape(song.title)}.mp3",
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
