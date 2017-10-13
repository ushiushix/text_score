# -*- coding: utf-8 -*-
TScore::App.controllers :tracks do
  get :new, :map => '/tracks/new/:song_id' do
    @track = Track.new
    if params[:mode] == 'drum'
      @track.name = 'Drum'
      @track.track_number = Track::SPECIAL_CHANNELS[:drum]
    end
    @song = Song.find(params[:song_id])
    @patch_names = MIDI::GM_PATCH_NAMES
    @track_numbers = (0..15).to_a - (@song.tracks.map(&:track_number) + Track::SPECIAL_CHANNELS.values)
    render 'tracks/new'
  end

  get :show, :with => :id do
    @track = Track.find(params[:id])
    render 'tracks/show'
  end

  post :create do
    @track = Track.new(params[:track])
    @song = Song.find(params[:song_id])
    unless @song.account == current_account || current_account.role == 'admin'
      flash[:error] = '編集する権限がありません'
      render 'tracks/new'
    end
    @track.song = @song
    if @track.mode != :drum
      @track.program = MIDI::GM_PATCH_NAMES.index(@track.name)
    else
      @track.program = 0
    end
    if @track.save
      flash[:notice] = 'パートが作成されました'
      if params[:play_now] == 'true'
        redirect url(:tracks, :play, :id => @track.id)
      else
        redirect url(:tracks, :edit, :id => @track.id)
      end
    else
      render 'tracks/new', :song_id => @song.id
    end
  end

  get :edit, :with => :id do
    @track = Track.find(params[:id])
    @song = @track.song
    @patch_names = MIDI::GM_PATCH_NAMES
    @track_numbers = ((0..15).to_a - (@song.tracks.map(&:track_number) + Track::SPECIAL_CHANNELS.values) + [@track.track_number]).sort
    render 'tracks/edit'
  end

  put :update, :with => :id do
    @track = Track.find(params[:id])
    @song = @track.song
    unless @song.account == current_account || current_account.role == 'admin'
      flash[:error] = '編集する権限がありません'
      render 'tracks/edit'
    end
    @track.assign_attributes(params[:track])
    if @track.mode != :drum
      @track.program = MIDI::GM_PATCH_NAMES.index(@track.name)
    end
    if @track.score == ''
      @track.destroy
      redirect url(:songs, :show, :id => @song.id)
    elsif @track.save
      flash[:notice] = 'パートが保存されました。'
      if params[:play_now] == 'true'
        redirect url(:tracks, :play, :id => @track.id)
      else
        redirect url(:tracks, :edit, :id => @track.id)
      end
    else
      render 'tracks/edit'
    end
  end

  get :play_data, :map => '/tracks/play/:id.mid' do
    track = Track.find(params[:id])
    song = track.song
    body = MidiConverter.new.convert(song, [track])
    [200,
     {'Content-Type' => 'audio/midi',
       'Content-Disposition' => 'attachment; filename="music.mid"',
       'Accept-Ranges' => 'bytes'},
     body]
  end

    get :play_data_mp3, :map => '/tracks/play/:id.mp3' do
    track = Track.find(params[:id])
    song = track.song
    body = MidiConverter.new.render_to_mp3(song, [track])
    [200,
     {'Content-Type' => 'audio/mp3',
       'Content-Disposition' => 'attachment; filename="music.mp3"',
       'Accept-Ranges' => 'bytes',
       'Expires' => (Time.now + 5).rfc822 },
     body]
  end

  get :play, :with => :id do
    @track = Track.find(params[:id])
    @song = @track.song
    render 'tracks/play'
  end
end
