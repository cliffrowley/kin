class Artefacts::CommentsController < ApplicationController
  before_action :set_song
  before_action :set_artefact

  def create
    @comment = @artefact.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @song, notice: "Comment added."
    else
      redirect_to @song, alert: "Comment can't be blank."
    end
  end

  private

  def set_song
    @song = Song.find(params[:song_id])
  end

  def set_artefact
    @artefact = @song.artefacts.find(params[:artefact_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
