namespace :init do

  task :import_shows => :environment do
    require 'net/http'
    require 'json'




    require 'rexml/document'
    include REXML
    file = File.new("dead.xml")
    doc = Document.new(file)
    count=0
    doc.root.elements.each('result/doc') do |e|
      count += 1
      if count < 4
        if e.elements['str[@name="subject"]'].present?
          if e.elements['str[@name="subject"]'].text == 'Live concert'
            index = e.elements['str[@name="title"]'].text.match(/(\d{4})-(\d{2})-(\d{2})/)
            index = index.to_s+'T04:05:06+07:00'
            puts DateTime.rfc3339(index)
            identifier = e.elements['str[@name="identifier"]'].text
            desc = e.elements['str[@name="description"]'].text

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
              puts s['track']
              puts s['name']
              puts s['title']
              puts s['length']
            end

          end
        end
      end
    end

  end

end