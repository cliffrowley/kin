class ArtefactsController < ApplicationController
  before_action :set_song

  def new
    @parent = @song.artefacts.find(params[:parent_id]) if params[:parent_id].present?
    @artefact = (@parent || @song).artefacts.build
  end

  def create
    @parent = @song.artefacts.find(params[:artefact][:parent_id]) if params[:artefact][:parent_id].present?
    @artefactable = @parent || @song
    @artefact = @artefactable.artefacts.build(artefact_params)

    if @artefact.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @song, notice: "Artefact was successfully uploaded." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @artefact = @song.all_artefacts.find(params[:id])
    @artefact.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @song, notice: "Artefact was successfully deleted." }
    end
  end

  private

  def set_song
    @song = Song.find(params[:song_id])
  end

  def artefact_params
    params.require(:artefact).permit(:title, :notes, :audio)
  end
end
