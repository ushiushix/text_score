# -*- coding: utf-8 -*-
TScore::App.controllers :instant_song do
  get :new, :map => '/instant_song/new' do
    @track = Track.new
    @track.track_number = 1
    @patch_names = GM_PATCHES_LOCALIZED
    @track_numbers = [0]
    render 'instant_song/new'
  end

  get :validate, :map => '/instant_song/validate' do
    @track = Track.new(params[:track])
    if @track.mode != :drum
      @track.program = params[:track][:program].to_i
      @track.name = GM_PATCHES_LOCALIZED[@track.program]
    else
      @track.program = 0
      @track.name = 'Drum'
    end
    if @track.validate
      status = 200
    else
      status = 400
    end
    body = {
      errors: @track.errors.messages
    }.to_json
    [status,
     {'Content-Type' => 'application/json'},
     body
    ]
  end

  get :play_data_mp3, :map => '/instant_song/play_data.mp3' do
    song = Song.new
    song.tempo = 100
    song.title = 'instant'
    @track = Track.new(params[:track])
    if @track.mode != :drum
      @track.program = params[:track][:program].to_i
      @track.name = GM_PATCHES_LOCALIZED[@track.program]
    else
      @track.program = 0
      @track.name = 'Drum'
    end
    body = MidiConverter.new.render_to_mp3(song, [@track])
    [200,
     {'Content-Type' => 'audio/mp3',
       'Content-Disposition' => 'attachment; filename="music.mp3"',
       'Accept-Ranges' => 'bytes',
       'Expires' => (Time.now + 5).rfc822 },
     body]
  end
end
