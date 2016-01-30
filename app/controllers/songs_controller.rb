class SongsController < ApplicationController

  def show
    if request.xhr?
      @song = Song.find_by_filename(params[:filename])
      @src = "https://archive.org/download/#{@song.show.identifier}/#{@song.filename}"
      @comments = @song.comment_threads.order('created_at desc')
      @new_comment = Comment.build_from(@song, current_user.id, "") if user_signed_in?
      @similar = @song.song_group.songs
      History.create(:resource_type=>'Song',:resource_id => @song.id, :user=>current_user) if user_signed_in?
      render 'load_song'
    end
  end

  def shuffle

    @songs=Song.music.order("RANDOM()").limit(5)
    @song_info = []
    @songs.each do |song|
      @song_info << {:name=>song.title, :show=>song.show.title, :show_id => song.show.identifier, :filename => song.filename}
    end
    render :json => @song_info.to_json
  end

  def radio
    choices = []
    bad_songs = []
    current_user.song_votes.each do |v|
      choices += Array.new(v.frequency,v.song_group_id)
      bad_songs << v.song_group_id if v.frequency == 0
    end
    choices += SongGroup.music.order('RANDOM()').limit(50).pluck(:id)
    choices += SongGroup.music.order(importance: :desc).limit(250).pluck(:id)
    @song_info=[]
    choices = choices - bad_songs
    for i in 1..5 do
      num = rand(choices.length-1)
      id = choices[num]
      song_group = SongGroup.find(id)

      song_id = song_group.songs.offset(rand(song_group.songs.length-1)).first.id
      song = Song.find(song_id)
      @song_info << {:name=>song.title, :show=>song.show.title, :show_id => song.show.identifier, :filename => song.filename}

    end
    render :json => @song_info.to_json
  end

  def load_group
    @group = SongGroup.find_by_title(params[:title])
    @comments = @group.comment_threads.order('created_at desc')
    @new_comment = Comment.build_from(@group, current_user.id, "") if user_signed_in?
  end

  def reaction
    @item = Song.find(params[:song_id])
    cancelled = false
    @reaction = Reaction.where(:post_id => params[:song_id], :user_id => current_user.id, :reaction_type => params[:type]).first
    if @reaction.present?
      Reaction.destroy(@reaction.id)
      cancelled = true
    else
      @reaction = Reaction.create!(:post_id => params[:song_id], :user_id => current_user.id, :reaction_type => params[:type], :reaction_source=>'song')
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
    @top_songs = SongGroup.order(importance: :desc).limit(50)
    @top_jams = Song.music.order(importance: :desc).limit(500)
    @total_pages = (@top_jams.length / 30) + 1

    shows = @top_jams.pluck(:id)
    if params.has_key?(:page)  && params[:page].to_i > 0
      offset = (params[:page].to_i-1) * 30
      ids = shows[offset..offset+29]
      @top_jams = Song.where('id in (?)',ids).order(importance: :desc)
      render :partial => 'songs/song_small', :collection => @top_jams, :as => :song
    else

      offset = 0
      ids = shows[offset..offset+29]
      @top_jams = Song.where('id in (?)',ids).order(importance: :desc)
    end
  end
end
