class SongGroupsController < ApplicationController

  def vote
    @vote = SongVote.where(:user_id=>current_user.id,:song_group_id => params[:song_group_id]).first
    if @vote
      @vote.update_attribute(:frequency,params[:val])
    else
      @vote = SongVote.create(:frequency=>params[:val],:user_id=>current_user.id,:song_group_id => params[:song_group_id])
    end
    render 'songs/voted'
  end

end
