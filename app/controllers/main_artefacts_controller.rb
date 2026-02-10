class MainArtefactsController < ApplicationController
  before_action :set_song

  def update
    artefact = @song.artefacts.find(params[:artefact_id])
    @song.main_artefact = artefact

    if @song.save
      redirect_to @song, notice: "Main artefact updated."
    else
      redirect_to @song, alert: @song.errors[:main_artefact].join(", ")
    end
  end

  def destroy
    @song.update!(main_artefact: nil)
    redirect_to @song, notice: "Main artefact cleared."
  end

  private

  def set_song
    @song = Song.find(params[:song_id])
  end
end
