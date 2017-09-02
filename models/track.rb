# -*- coding: utf-8 -*-
class Track < ActiveRecord::Base
  class TextSequencerValidator < ActiveModel::Validator
    def validate(record)
      TextSequencer.parse(record.score) if record.score
    rescue TextSequencer::ParseError => e
      record.errors.add :score, "#{e.line}行目にエラーがあります: #{e.message}"
    end
  end

  SPECIAL_CHANNELS = {
    :control => 0,
    :drum => 9
  }

  NOTES_INST = %w(1 2 3 4 5 6 7).map do |r|
    %w(c c+ d d+ e f f+ g g+ a a+ b).map {|n| "#{n}#{r}" }
  end.flatten
  DEFAULT_NOTE = 'c4'
  NOTES_DRUM = [
    [36, 'バスドラム1'],
    [38, 'アコースティックスネア'],
    [42, 'クローズハイハット'],
    [46, 'オープンハイハット'],
    [49, 'クラッシュシンバル1'],
    [35, 'アコースティックバスドラム'],
    [36, 'バスドラム1'],
    [37, 'サイドスティック'],
    [38, 'アコースティックスネア'],
    [39, 'ハンドクラップ'],
    [40, 'エレクトリックスネア'],
    [41, 'ローフロアタム'],
    [42, 'クローズハイハット'],
    [43, 'ハイフロアタム'],
    [44, 'ペダルハイハット'],
    [45, 'ロータム'],
    [46, 'オープンハイハット'],
    [47, 'ローミッドタム'],
    [48, 'ハイミッドタム'],
    [49, 'クラッシュシンバル1'],
    [50, 'ハイタム'],
    [51, 'ライドシンバル1'],
    [52, 'チャイニーズシンバル'],
    [53, 'ライドベル'],
    [54, 'タンバリン'],
    [55, 'スプラッシュシンバル'],
    [56, 'カウベル'],
    [57, 'クラッシュシンバル2'],
    [58, 'ビブラスラップ'],
    [59, 'ライドシンバル2'],
    [60, 'ハイボンゴ'],
    [61, 'ローボンゴ'],
    [62, 'ミュートハイコンガ'],
    [63, 'オープンハイコンガ'],
    [64, 'ローコンガ'],
    [65, 'ハイティンバレス'],
    [66, 'ローティンバレス'],
    [67, 'ハイアゴゴ'],
    [68, 'ローアゴゴ'],
    [69, 'カバサ'],
    [70, 'マラカス'],
    [71, 'ショートホイッスル'],
    [72, 'ロングホイッスル'],
    [73, 'ショートギロ'],
    [74, 'ロングギロ'],
    [75, 'クラベス'],
    [76, 'ハイウッドブロック'],
    [77, 'ローウッドブロック'],
    [78, 'ミュートクイーカ'],
    [79, 'オープンクイーカ'],
    [80, 'ミュートトライアングル'],
    [81, 'オープントライアングル'],
  ]
  LENGTHS = %w(0 12 16 24 36 48 72 96 144 192)
  DEFAULT_LENGTH = '48'
  
  belongs_to :song
  validates_presence_of :name
  validates_presence_of :track_number
  validates_with TextSequencerValidator

  def mode
    case track_number
    when SPECIAL_CHANNELS[:drum]
      :drum
    when SPECIAL_CHANNELS[:control]
      :control
    else
      :melody
    end
  end
end
