class ShowsController < ApplicationController

  def show
    @show = Show.find(params[:id])

  end

  def load_shows
    if request.xhr?
      if params.has_key?(:year)
        @shows = Show.where(:band_id => params[:band_id],:year=> params[:year]).order(date: :asc)
        @total_pages = (@shows.length / 20) + 1
        @band = Band.find(params[:band_id])
        shows = @shows.pluck(:id)
        if params.has_key?(:page)  && params[:page].to_i > 0
          offset = (params[:page].to_i-1) * 20
          @shows = Show.where(:band_id => params[:band_id],:year=> params[:year]).order(date: :asc).offset(offset).limit(20)
          render :partial => 'shows/band_show', :collection => @shows, :as => :show
        else
          @shows = Show.where(:band_id => params[:band_id],:year=> params[:year]).order(date: :asc).limit(20)
          render 'load_shows'
        end


      end
    end
  end

  def load
    @show = Show.find(params[:show_id])
    History.create(:resource_type=>'Show',:resource_id => @show.id, :user=>current_user) if user_signed_in?
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
    @shows = Show.order(importance: :desc).limit(500)
    @total_pages = (@shows.length / 15) + 1

    shows = @shows.pluck(:id)
    if params.has_key?(:page)  && params[:page].to_i > 0
      offset = (params[:page].to_i-1) * 15
      ids = shows[offset..offset+14]
      @shows = Show.where('id in (?)',ids).order(created_at: :desc)
      render :partial => @shows
    else

      offset = 0
      ids = shows[offset..offset+14]
      @shows = Show.where('id in (?)',ids).order(created_at: :desc)
    end
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
