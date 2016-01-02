class SongsController < ApplicationController

  def show
    if request.xhr?
      filename = (params[:filename] << '.mp3')
      @song = Song.find_by_filename(filename)
      @comments = @song.comment_threads.order('created_at desc')
      @new_comment = Comment.build_from(@song, current_user.id, "") if user_signed_in?
      @similar = @song.song_group.songs
      render 'load_song'
    end
  end

  def shuffle

    @song=Song.order("RANDOM()").first
    @comments = @song.comment_threads.order('created_at desc')
    @new_comment = Comment.build_from(@song, current_user.id, "") if user_signed_in?
    @similar = @song.song_group.songs
    @src = "https://archive.org/download/#{@song.show.identifier}/#{@song.filename}"
    render 'shuffle'
  end

  def index
    @group = SongGroup.find_by_title(params[:title])
    @comments = @group.comment_threads.order('created_at desc')
    @new_comment = Comment.build_from(@group, current_user.id, "") if user_signed_in?
    render 'load_group'
  end

  def reaction
    @item = Song.find(params[:song_id])
    cancelled = false
    @reaction = Reaction.where(:post_id => params[:song_id], :user_id => current_user.id, :reaction_type => params[:type]).first
    if @reaction.present?
      Reaction.destroy(@reaction.id)
      cancelled = true
    else
      @reaction = Reaction.create!(:post_id => params[:song_id], :user_id => current_user.id, :reaction_type => params[:type])
    end
    case params[:type]
      when 'like'
        if cancelled
          @item.update_attribute(:importance, @item.importance-1)
        else
          @item.update_attribute(:importance, @item.importance+1)
        end

        @count = @item.reactions.liked.size
        @class = "like"
        render 'reactions/liked'
      when 'love'
        if cancelled
          @item.update_attribute(:importance, @item.importance-3)
        else
          @item.update_attribute(:importance, @item.importance+3)
        end


        @count = @item.reactions.loved.size
        @class = "love"
        render 'reactions/liked'
      when 'share'
        if cancelled
          @item.update_attribute(:importance, @item.importance-5)
        else
          @item.update_attribute(:importance, @item.importance+5)
        end
        @count = @item.reactions.shared.size
        @class = "share"
        render 'reactions/liked'

    end
  end
end
