class ArtefactsController < ApplicationController
  before_action :set_song

  def create
    @artefact = @song.artefacts.build(artefact_params)

    if @artefact.save
      redirect_to @song, notice: "Artefact was successfully uploaded."
    else
      render "songs/show", status: :unprocessable_entity
    end
  end

  def destroy
    @artefact = @song.artefacts.find(params[:id])
    @artefact.destroy
    redirect_to @song, notice: "Artefact was successfully deleted."
  end

  private

  def set_song
    @song = Song.find(params[:song_id])
  end

  def artefact_params
    params.require(:artefact).permit(:title, :artefact_type, :notes, :audio)
  end
end
