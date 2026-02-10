class MainMixesController < ApplicationController
  before_action :set_song

  def update
    artefact = @song.artefacts.find(params[:artefact_id])
    @song.main_mix = artefact

    if @song.save
      redirect_to @song, notice: "Main mix updated."
    else
      redirect_to @song, alert: @song.errors[:main_mix].join(", ")
    end
  end

  def destroy
    @song.update!(main_mix: nil)
    redirect_to @song, notice: "Main mix cleared."
  end

  private

  def set_song
    @song = Song.find(params[:song_id])
  end
end
