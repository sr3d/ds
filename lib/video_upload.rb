class YouTubeG
  module Upload
    class UploadError < Exception; end

    class VideoUpload
      def initialize
        @config = YAML::load(File.open("#{::Rails.root.to_s}/config/config.yml"))
      end

      def upload data, ad, opts = {}
        data = data.respond_to?(:read) ? data.read : data

        init_options(data, ad, opts)

        Net::HTTP.start("uploads.gdata.youtube.com") do |upload|
          response, data = upload.post("/feeds/api/users/default/uploads", upload_body(data), upload_header(data))
          #puts "--------- data: " + data
          #puts "----- response: " + response.inspect
          raise UploadError, response.body[/Error=(.+)/,1] unless response.code =~ /2\d+/
        end
        
        xml = REXML::Document.new(data)
        return xml.elements["//id"].text[/videos\/(.+)/, 1] if xml.elements["//id"] if xml && xml.elements
        raise UploadError "Can't parse youtube video id."
      end

      private
      def init_options(data, ad, opts)
        title = Time.now.to_f.to_s
        description = CGI::escape "#{ad.location.full_address} #{ad.category.name} #{ad.sub_category.name}\n"

        @opts = { 
          :mime_type => 'video/mp4',
          :filename => Digest::MD5.hexdigest(data),
          :title => title,
          :description => description,
          :category => 'People',
          :keywords => %w(reachoo ad) }.merge(opts)
          puts @opts.inspect
      end

      def upload_body(data)
        upload_body = ""
        upload_body << "--#{boundary}\r\n"
        upload_body << "Content-Type: application/atom+xml; charset=UTF-8\r\n\r\n"
        upload_body << video_xml
        upload_body << "\r\n--#{boundary}\r\n"
        upload_body << "Content-Type: #{@opts[:mime_type]}\r\nContent-Transfer-Encoding: binary\r\n\r\n"
        upload_body << data
        upload_body << "\r\n--#{boundary}--\r\n"
      end

      def upload_header(data)
        {
          "Authorization"  => "GoogleLogin auth=#{auth_token}",
          "X-GData-Client" => "#{@config['youtube_password']}",
          "X-GData-Key"    => "key=#{@config['youtube_dev_key']}",
          "Slug"           => "#{@opts[:filename]}",
          "Content-Type"   => "multipart/related; boundary=#{boundary}",
          "Content-Length" => "#{upload_body(data)}"
        }
      end

      def video_xml
        %[<?xml version="1.0"?>
           <entry xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://gdata.youtube.com/schemas/2007">
           <media:group>
           <media:title type="plain">#{@opts[:title]}</media:title>
           <media:description type="plain">#{@opts[:description]}</media:description>
           <media:category scheme="http://gdata.youtube.com/schemas/2007/categories.cat">#{@opts[:category]}</media:category>
           <media:keywords>#{@opts[:keywords].join ","}</media:keywords>
           </media:group></entry> ]
      end

      def boundary
        "An43094fu"
      end

      def auth_token
        http = Net::HTTP.new("www.google.com", 443)
        http.use_ssl = true
        body = "Email=#{CGI::escape @config['youtube_login']}&Passwd=#{CGI::escape @config['youtube_password']}&service=youtube&source=#{CGI::escape @config['youtube_password']}"
        response = http.post("/youtube/accounts/ClientLogin", body, "Content-Type" => "application/x-www-form-urlencoded")
        raise UploadError, response.body[/Error=(.+)/,1] if response.code.to_i != 200
        response.body[/Auth=(.+)/, 1]
      end
    end
  end
end