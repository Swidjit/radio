class PagesController < ApplicationController

  def home

  end

  def sitemap

  end

  def index
    if params[:page_name]=='popular'
      @favorite_songs = Song.where('importance > 0').order(importance: :desc).limit(25)
      @favorite_shows = Show.order(importance: :desc).limit(25)
    elsif params[:page_name]=='explore'
      c = Song.all.pluck(:id)
      random_ids = c.sort_by { rand }.slice(0, 13)
      @random_songs = Song.find(random_ids)
      @new_shows = Show.order(created_at: :desc).limit(25)

    elsif params[:page_name]=='dashboard'
      @favorite_songs = Song.where('id in (?)',Reaction.where(:user=>current_user).pluck(:post_id))
      @favorite_shows = Show.where('id in (?)',Reaction.where(:user=>current_user).pluck(:post_id))

    elsif params[:page_name]=='discussion'
      @new_comments = Comment.order(created_at: :desc).limit(15).pluck(:commentable_id)
      @recent_comments = Song.find(@new_comments)

      @popular_songs = Song.where('comment_count>0').order(comment_count: :asc).limit(15)
    end
    render params[:page_name]
  end

  def popular

  end
end
