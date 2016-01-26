class ShowsController < ApplicationController

  def show
    @show = Show.find(params[:id])

  end

  def load_shows
    if request.xhr?
      if params.has_key?(:year)
        @shows = Show.where(:band_id => params[:band_id],:year=> params[:year]).order(date: :asc)
        @band = Band.find(params[:band_id])
        render 'load_shows'
      end
    end
  end

  def load
    @show = Show.find(params[:show_id])
    render 'load_show'
  end

  def reaction
    @item = Show.find(params[:show_id])
    cancelled = false
    @reaction = Reaction.where(:post_id => params[:show_id], :user_id => current_user.id, :reaction_type => params[:type]).first
    if @reaction.present?
      Reaction.destroy(@reaction.id)
      cancelled = true
    else
      @reaction = Reaction.create!(:post_id => params[:show_id], :user_id => current_user.id, :reaction_type => params[:type], :reaction_source=>'show')
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

  def index
    @shows = Show.order(importance: :desc).limit(100)
  end


  def load_random
    rand = rand(Show.count)
    @show = Show.offset(rand).first
    @song = @show.songs.first
    @src = "https://archive.org/download/#{@song.show.identifier}/#{@song.filename}"
    @comments = @song.comment_threads.order('created_at desc')
    @new_comment = Comment.build_from(@song, current_user.id, "") if user_signed_in?
  end

end
