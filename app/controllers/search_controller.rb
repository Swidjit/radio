class SearchController < ApplicationController

  def index
    case params[:scope]
      when 'songs-and-bands'
        @songs = SongGroup.where('lower(title) LIKE ?',"%#{params[:q].downcase}%")
        @bands = Band.where('lower(name) LIKE ?',"%#{params[:q].downcase}%")
    end
    render params[:scope]
  end

end
