namespace :init do

  task :seed_bands => :environment do
    Band.create(:name=>"Grateful Dead",:description=>"Description")
  end

  task :import_shows => :environment do
    require 'net/http'
    require 'json'




    require 'rexml/document'
    include REXML
    file = File.new("dead.xml")
    doc = Document.new(file)
    count=0
    band = Band.find(1)
    Show.destroy_all
    SongGroup.delete_all
    doc.root.elements.each('result/doc') do |e|
      count += 1
      if count < 15
        if e.elements['str[@name="subject"]'].present?
          if e.elements['str[@name="subject"]'].text == 'Live concert'
            index = e.elements['str[@name="title"]'].text.match(/(\d{4})-(\d{2})-(\d{2})/)
            year = index.to_s.split('-')[0]
            index = index.to_s+'T04:05:06+07:00'
            puts DateTime.rfc3339(index)
            identifier = e.elements['str[@name="identifier"]'].text
            e.elements['str[@name="description"]'].present? ? desc = e.elements['str[@name="description"]'].text : desc='No description'

            #save the show
            @show=Show.create(:band=> band, :date=>DateTime.rfc3339(index), :year => year,:title=>e.elements['str[@name="title"]'].text, :identifier => identifier, :description => desc)
              if @show.valid?
              url = 'http://archive.org/metadata/'+identifier
              uri = URI(url)
              response = Net::HTTP.get(uri)
              data = JSON.parse(response)
              #.sort_by { |hash| hash['track'].to_i }
              #data = data.collect{ |hash| hash if hash['format']=='VBR MP3'}
              songs = []
              tracks = []
              data["files"].each do |data|
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
                s['title'] = s['title'].gsub(/[^\w\s]/,'')
                @song = Song.create(:track_num => s['track'].to_i, :filename => s['name'], :title => s['title'], :length => s['length'])
                @show.songs << @song
                t = s['title'].gsub(/[^\w,'&\s]/,'')
                group = SongGroup.where('lower(title) = ?',t.downcase).first
                if group.present?
                  group.increment!(:count)
                  group.songs << @song
                else
                  group=SongGroup.create(:title=>t,:count=>1)
                  group.songs << @song
                end
              end
            end
          end
        end
      end
    end

  end

end