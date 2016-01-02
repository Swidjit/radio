class PagesController < ApplicationController

  def home

  end

  def sitemap

  end

  def index
    if params[:page_name]=='popular'
      @favorite_songs = Song.where('importance > 0').order(importance: :desc).limit(25)
      @favorite_shows = Show.order(importance: :desc).limit(25)
    end
    render params[:page_name]
  end

  def popular

  end
end
