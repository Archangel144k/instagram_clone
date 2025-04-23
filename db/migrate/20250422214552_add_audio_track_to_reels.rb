class AddAudioTrackToReels < ActiveRecord::Migration[8.0]
  def change
    add_column :reels, :audio_track, :string
  end
end
