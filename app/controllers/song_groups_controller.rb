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

  def show
    @song_group = SongGroup.find(params[:id])
    @comments = @song_group.comment_threads.order('created_at desc')
    @new_comment = Comment.build_from(@song_group, current_user.id, "") if user_signed_in?
  end

end
