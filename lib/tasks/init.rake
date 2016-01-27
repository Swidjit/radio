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
    Band.create(:id=>13,:name=>"Furthur",:description=>"", :collection => 'Furthur')
    Band.create(:id=>14,:name=>"Bob Weir",:description=>"", :collection => 'BobWeir')
    Band.create(:id=>15,:name=>"BelaFleck",:description=>"", :collection => 'BelaFleckandtheFlecktones')
    Band.create(:id=>16,:name=>"TheRadiators",:description=>"", :collection => 'Radiators')
    Band.create(:id=>17,:name=>"Steve Kimock Band",:description=>"", :collection => 'SteveKimockBand')
    Band.create(:id=>18,:name=>"Tea Leaf Green",:description=>"", :collection => 'TeaLeafGreen')
    Band.create(:id=>19,:name=>"Strangefolk",:description=>"", :collection => 'Strangefolk')
    Band.create(:id=>20,:name=>"Greensky Bluegrass",:description=>"", :collection => 'GreenskyBluegrass')
    Band.create(:id=>21,:name=>"Big Mean Sound Machine",:description=>"", :collection => 'BigMeanSoundMachine')
    Band.create(:id=>22,:name=>"EOTO",:description=>"", :collection => 'EOTOband')
    Band.create(:id=>23,:name=>"STS9",:description=>"", :collection => 'SoundTribeSector9')
    Band.create(:id=>24,:name=>"Big Gigantic",:description=>"", :collection => 'BigGigantic')
    Band.create(:id=>25,:name=>"Zoogma",:description=>"", :collection => 'Zoogma')
    Band.create(:id=>27,:name=>"FiKus",:description=>"", :collection => 'FiKus')



  end

  task :clean_shows => :environment do
    Show.all.each do |show|
      if show.songs.count == 0
        show.destroy
      end
    end
  end

  task :import_shows => :environment do
    require 'httparty'
    require 'json'

    Show.delete_all
    Song.delete_all
    SongGroup.delete_all
    Band.all.each do |band|
      url = 'https://archive.org/advancedsearch.php?q=collection%3A%28'+band.collection+'%29&fl%5B%5D=collection&fl%5B%5D=description&fl%5B%5D=format&fl%5B%5D=identifier&fl%5B%5D=subject&fl%5B%5D=title&sort%5B%5D=&sort%5B%5D=&sort%5B%5D=&rows=10000&page=1&output=json#raw'
      uri = URI(url)
      require 'httparty'
      response = HTTParty.get(uri)
      data = response.parsed_response

      songs = []
      tracks = []
      data["response"]["docs"].each do |show|
        index = show["title"].match(/(\d{4})-(\d{2})-(\d{2})/)
        dates = index.to_s.split('-')
        puts index
        if (dates[1].to_i <= 12 && dates[1].to_i > 0 && dates[2].to_i <= 31 && dates[2].to_i > 0)
          puts 'in'
          puts dates[1]
          puts dates[2]
          year = dates[0]

          index = index.to_s+'T04:05:06+07:00'

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
            if song_data["files"].present?
              song_data["files"].each do |data|
                if data["track"].to_i > 0 && data["format"]=='VBR MP3'
                  if tracks.include?(data["track"].to_i)

                  else
                    tracks<< data["track"].to_i
                    songs << data
                  end
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


  task :import_band, [:band_name] => :environment  do |t, args|
    require 'httparty'
    require 'json'
    puts args
    puts args.band_name
    band = Band.find_by_collection(args.band_name)

    url = 'https://archive.org/advancedsearch.php?q=collection%3A%28'+band.collection+'%29&fl%5B%5D=collection&fl%5B%5D=description&fl%5B%5D=format&fl%5B%5D=identifier&fl%5B%5D=subject&fl%5B%5D=title&sort%5B%5D=&sort%5B%5D=&sort%5B%5D=&rows=10000&page=1&output=json#raw'
    uri = URI(url)
    require 'httparty'
    response = HTTParty.get(uri)
    data = response.parsed_response

    songs = []
    tracks = []
    data["response"]["docs"].each do |show|
      index = show["title"].match(/(\d{4})-(\d{2})-(\d{2})/)
      dates = index.to_s.split('-')
      puts index
      if (dates[1].to_i <= 12 && dates[1].to_i > 0 && dates[2].to_i <= 31 && dates[2].to_i > 0)
        puts 'in'
        puts dates[1]
        puts dates[2]
        year = dates[0]

        index = index.to_s+'T04:05:06+07:00'

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
          if song_data["files"].present?
            song_data["files"].each do |data|
              if data["track"].to_i > 0 && data["format"]=='VBR MP3'
                if tracks.include?(data["track"].to_i)

                else
                  tracks<< data["track"].to_i
                  songs << data
                end
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

  task :set_band_years => :environment do
    Band.all.each do |band|
      years = band.shows.order(year: :asc).pluck(:year)
      years = years.uniq
      band.years = years
      band.save
    end
  end

end