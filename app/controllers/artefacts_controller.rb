class ArtefactsController < ApplicationController
  before_action :set_song

  def create
    @artefact = if params[:artefact][:parent_id].present?
      parent = @song.artefacts.find(params[:artefact][:parent_id])
      parent.artefacts.build(artefact_params_without_parent)
    else
      @song.artefacts.build(artefact_params_without_parent)
    end

    if @artefact.save
      redirect_to @song, notice: "Artefact was successfully uploaded."
    else
      @parent_artefacts = @song.artefacts.top_level
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

  def artefact_params_without_parent
    params.require(:artefact).permit(:title, :notes, :audio)
  end
end
