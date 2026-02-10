class CommentsController < ApplicationController
  before_action :set_song

  def create
    @comment = @song.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @song, notice: "Comment added."
    else
      redirect_to @song, alert: "Comment can't be blank."
    end
  end

  def destroy
    @comment = @song.comments.find(params[:id])

    if @comment.user == current_user
      @comment.destroy
      redirect_to @song, notice: "Comment deleted."
    else
      redirect_to @song, alert: "You can only delete your own comments."
    end
  end

  private

  def set_song
    @song = Song.find(params[:song_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
