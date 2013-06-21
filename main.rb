require 'rubygems'
require 'lastfm'
require 'discogs'
require 'json'
require 'mechanize'
require 'debugger'

class Music
  def self.discogs
    puts '##=================================Discogs==========================================================='

    wrapper = Discogs::Wrapper.new("My awesome web app")
    search = wrapper.search("Lana Del Ray")

    discogs_result = []
    search.results(:release).each do |release|
      discogs_result << { title: release.title, uri: release.uri, thumb: release.thumb, num: release.num }
    end

    discogs_result = { albums: discogs_result }

    discogs_result.to_json
  end

  def self.lastfm
    puts '##=================================Last FM==========================================================='

    api_key = 'ac00d1f091151fb986206b311d13737c'
    api_secret = 'ef0d73599469a6d2eeb2166297986a24'

    lastfm = Lastfm.new(api_key, api_secret)
    token = lastfm.auth.get_token

    #-------------------------

    mech = Mechanize.new do |a|
      a.user_agent_alias = 'Linux Firefox'
      a.verify_mode = OpenSSL::SSL::VERIFY_NONE
      a.follow_meta_refresh = true
    end

    login_page = mech.get('https://last.fm/login')
    login_form = login_page.form_with(action: '/login')

    login_form.username = 'vitalyashevtsov'
    login_form.password = 'testing1'

    page = login_form.submit

    if page.uri.to_s == 'http://www.last.fm/home'
      puts "Login successful!"

    else
      puts page.uri.to_s
      exit
    end

    grantaccess_url = "http://www.last.fm/api/auth/?api_key=#{api_key}&token=#{token}"
    grantaccess_page = mech.get(grantaccess_url)

    grantaccess_form = grantaccess_page.form_with(action: '/api/grantaccess')
    grantaccess_form.submit

    lastfm.session = lastfm.auth.get_session(:token => token)['key']

    debugger
    lastfm.artist.search('Madonna')
  end
end

puts Music.discogs
puts Music.lastfm

