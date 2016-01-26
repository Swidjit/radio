class PlaylistsController < ApplicationController
  respond_to :js

  def create
    @playlist = Playlist.create(playlist_params)
    @playlist.save
    if params.has_key?(:song_id)
      @playlist.songs << Song.find(params[:song_id])
      @id = params[:song_id]
    else
      current_user.playlists << @playlist
    end
    current_user.playlists << @playlist
  end

  def index
    @playlists = Playlist.all.order(updated_at: :desc)
  end

  def add_song_to
    @playlist = Playlist.find(params[:id])
    if @playlist.songs << Song.find(params[:song_id])
      @id = params[:song_id]
      respond_with do |format|
        format.js
      end
    else
      respond_with do |format|
        format.js {render 'add_failed'}
      end
    end
  end

  def add_song
    puts 'sdfsd'
     @playlist = Playlist.find(params[:playlist_id])
    if @playlist.songs << Song.find(params[:song_id])
      @id = params[:song_id]
      respond_with do |format|
        format.js
      end
    else
      respond_with do |format|
        format.js {render 'add_failed'}
      end
    end
  end

  def show
    @playlist = Playlist.find(params[:id])
  end

  private

  def playlist_params
    params.require(:playlist).permit(:title, :description, :public)
  end

end
