namespace :init do

  task :seed_bands => :environment do
    Band.delete_all
    Band.create(:id=>1,:name=>"Grateful Dead",:description=>"Description", :collection => 'GratefulDead')
    Band.create(:id=>3,:name=>"moe.",:description=>"Description", :collection => 'moe')
    Band.create(:id=>4,:name=>"Umphrey's McGee",:description=>"Description", :collection => 'UmphreysMcGee')
    Band.create(:id=>5,:name=>"Phil Lesh and Friends",:description=>"", :collection => 'PhilLeshandFriends')
    Band.create(:id=>6,:name=>"Dark Star Orchestra",:description=>"", :collection => 'DarkStarOrchestra')
    Band.create(:id=>7,:name=>"Disco Biscuits",:description=>"", :collection => 'DiscoBiscuits')
    Band.create(:id=>8,:name=>"String Cheese Incident",:description=>"", :collection => 'StringCheeseIncident')
    Band.create(:id=>9,:name=>"Ratdog",:description=>"", :collection => 'Ratdog')
    Band.create(:id=>10,:name=>"Max Creek",:description=>"", :collection => 'MaxCreek')
    Band.create(:id=>11,:name=>"Yonder Mountain String Band",:description=>"", :collection => 'YonderMountainStringBand')
    Band.create(:id=>12,:name=>"Lotus",:description=>"", :collection => 'Lotus')



  end



  task :import_shows => :environment do
    require 'httparty'
    require 'json'

    Show.delete_all
    Song.delete_all
    SongGroup.delete_all
    Band.all.each do |band|
      url = 'https://archive.org/advancedsearch.php?q=collection%3A%28'+band.collection+'%29&fl%5B%5D=collection&fl%5B%5D=description&fl%5B%5D=format&fl%5B%5D=identifier&fl%5B%5D=subject&fl%5B%5D=title&sort%5B%5D=&sort%5B%5D=&sort%5B%5D=&rows=100&page=1&output=json#raw'
      uri = URI(url)
      require 'httparty'
      response = HTTParty.get(uri)
      data = response.parsed_response

      songs = []
      tracks = []
      data["response"]["docs"].each do |show|
        index = show["title"].match(/(\d{4})-(\d{2})-(\d{2})/)
        year = index.to_s.split('-')[0]
        index = index.to_s+'T04:05:06+07:00'
        puts DateTime.rfc3339(index)
        identifier = show["identifier"]
        show["description"].present? ? desc = show["description"] : desc='No description'

        #save the show
        @show=Show.create(:band=> band, :date=>DateTime.rfc3339(index), :year => year,:title=>show["title"], :identifier => identifier, :description => desc)
        if @show.valid?
          url = 'http://archive.org/metadata/'+identifier
          uri = URI(url)
          response = Net::HTTP.get(uri)
          song_data = JSON.parse(response)
          #.sort_by { |hash| hash['track'].to_i }
          #data = data.collect{ |hash| hash if hash['format']=='VBR MP3'}
          songs = []
          tracks = []
          song_data["files"].each do |data|
            if data["track"].to_i > 0 && data["format"]=='VBR MP3'
              if tracks.include?(data["track"].to_i)

              else
                tracks<< data["track"].to_i
                songs << data
              end
            end

          end

          songs = songs.sort_by {|song| song['track'].to_i}

          songs.each do |s|
            if s['title']
              s['title'] = s['title'].gsub(/[^\w\s]/,'')
              @song = Song.create(:track_num => s['track'].to_i, :filename => s['name'], :title => s['title'], :length => s['length'], :band_id => band.id)
              @show.songs << @song
              t = s['title'].gsub(/[^\w,'&\s]/,'')
              group = SongGroup.where('lower(title) = ?',t.downcase).where(:band_id => band.id).first
              if group.present?
                group.increment!(:count)
                group.songs << @song
              else
                group=SongGroup.create(:title=>t,:count=>1, :band_id => band.id)
                group.songs << @song
              end
            end
          end
        end


      end
    end

  end

end