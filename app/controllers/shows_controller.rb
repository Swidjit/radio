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

end
