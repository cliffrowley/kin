class ArtefactsController < ApplicationController
  before_action :set_song

  def new
    @parent = find_song_artefact(params[:parent_id]) if params[:parent_id].present?
    @artefact = (@parent || @song).artefacts.build
  end

  def edit
    @artefact = find_song_artefact(params[:id])
  end

  def update
    @artefact = find_song_artefact(params[:id])

    if @artefact.update(artefact_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @song, notice: "Artefact was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @parent = find_song_artefact(params[:artefact][:parent_id]) if params[:artefact][:parent_id].present?
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
    @artefact = find_song_artefact(params[:id])
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

  def find_song_artefact(id)
    artefact = Artefact.find(id)
    raise ActiveRecord::RecordNotFound unless artefact.song == @song
    artefact
  end

  def artefact_params
    params.require(:artefact).permit(:title, :notes, :audio)
  end
end
