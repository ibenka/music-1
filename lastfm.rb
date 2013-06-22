class MyLastfm

   class << self
     def config
       { api_key: 'ac00d1f091151fb986206b311d13737c',
         api_secret: 'ef0d73599469a6d2eeb2166297986a24',
         username: 'vitalyashevtsov',
         password: 'testing1'}
     end

     def sign_in token
       mech = Mechanize.new do |a|
         a.user_agent_alias = 'Linux Firefox'
         a.verify_mode = OpenSSL::SSL::VERIFY_NONE
         a.follow_meta_refresh = true
       end

       login_page = mech.get('https://last.fm/login')
       login_form = login_page.form_with(action: '/login')

       login_form.username = self.config[:username]
       login_form.password = self.config[:password]

       page = login_form.submit

       unless page.uri.to_s == 'http://www.last.fm/home'
         puts page.uri.to_s
         exit
       end

       grantaccess_url = "http://www.last.fm/api/auth/?api_key=#{self.config[:api_key]}&token=#{token}"
       grantaccess_page = mech.get(grantaccess_url)

       grantaccess_form = grantaccess_page.form_with(action: '/api/grantaccess')
       grantaccess_form.submit
     end

     def find_album_by_name artist
        artist = URI::encode(artist)
        result = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=album.search&album=#{artist}&api_key=#{self.config[:api_key]}&format=json")
        JSON.parse(result.response.body)['results']['albummatches']
     end

     def search artist
       lastfm = Lastfm.new(self.config[:api_key], self.config[:api_secret])
       token = lastfm.auth.get_token

       self.sign_in token

       lastfm.session = lastfm.auth.get_session(:token => token)['key']

       self.find_album_by_name(artist).to_json
     end
   end
end
