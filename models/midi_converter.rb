require 'stringio'
require 'tempfile'
require 'midilib'
require 'text_sequencer'
require 'text_sequencer/midilib_exporter'

class MidiConverter
  include MIDI

  def convert(song, tracks = nil, renumber = nil)
    io = StringIO.new
    create_midi(song, tracks, renumber).write io
    io.rewind
    io.read
  end

  def render_to_mp3(song, tracks = nil, renumber = nil)
    seq = create_midi(song, tracks, renumber)
    midi_file = Tempfile.new(%w[ t_score .mid ], encoding: 'ascii-8bit')
    mp3_file = Tempfile.new(%w[ t_score .mp3 ])
    seq.write(midi_file)
    midi_file.flush
    system("timidity -A90,120a -Ow -o - #{midi_file.path} 2> /dev/null | lame -S - #{mp3_file.path}") or raise 'Conversion failed'
    File.read(mp3_file.path)
  ensure
    midi_file.close!
    mp3_file.close!
  end

  def create_midi(song, tracks, renumber)
    tracks ||= song.tracks
      renumber_channels(tracks) if renumber
    seq = Sequence.new()
    meta_track = Track.new(seq)
    seq.tracks << meta_track
    meta_track.events << Tempo.new(Tempo.bpm_to_mpq(song.tempo))
    meta_track.events << MetaEvent.new(META_SEQ_NAME, song.title)
    tracks.each do |t|
      new_track = Track.new(seq)
      seq.tracks << new_track
      new_track.name = GM_PATCH_NAMES[t.program]
      new_track.instrument = GM_PATCH_NAMES[t.program]
      new_track.events << Controller.new(t.track_number, CC_VOLUME, 127)
      new_track.events << ProgramChange.new(t.track_number, t.program, 100)
      exporter = TextSequencer::MidilibExporter.new(new_track, t.track_number)
      TextSequencer.parse(t.score).export(exporter)
    end
    seq
  end

  def renumber_channels(tracks)
    availables = (0..15).to_a - ::Track::SPECIAL_CHANNELS.values
    tracks.each do |t|
      t.track_number = availables.shift unless t.mode == :drum
    end
  end
end
