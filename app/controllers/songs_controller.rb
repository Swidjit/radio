class SongsController < ApplicationController

  def show
    if request.xhr?
      filename = (params[:filename] << '.mp3')
      @song = Song.find_by_filename(filename)
      @comments = @song.comment_threads.order('created_at desc')
      @new_comment = Comment.build_from(@song, current_user.id, "") if user_signed_in?
      @similar = Song.where('title like ?',@song.title)
      render 'load_song'
    end
  end

  def index

  end

end
