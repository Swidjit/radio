class ShowsController < ApplicationController

  def show
    @show = Show.find(params[:id])

  end

  def index
    if request.xhr?
      if params.has_key?(:year)
        @shows = Show.where(:band_id => params[:band_id],:year=> params[:year]).order(date: :asc)

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
      @reaction = Reaction.create!(:post_id => params[:show_id], :user_id => current_user.id, :reaction_type => params[:type])
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
