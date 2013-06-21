require 'rubygems'
require 'lastfm'
require 'discogs'
require 'json'
require 'debugger'

puts '##=================================Discogs==========================================================='

wrapper = Discogs::Wrapper.new("My awesome web app")
search = wrapper.search("Lana Del Ray")

discogs_result = []
search.results(:release).each do |release|
  discogs_result << { title: release.title, uri: release.uri, thumb: release.thumb, num: release.num }
end

discogs_result = { albums: discogs_result }

puts discogs_result.to_json

puts '##=================================Last FM==========================================================='
#api_key = 'ac00d1f091151fb986206b311d13737c'
#api_secret = 'ef0d73599469a6d2eeb2166297986a24'

#lastfm = Lastfm.new(api_key, api_secret)
#token = lastfm.auth.get_token

#lastfm.session = lastfm.auth.get_session(:token => token)['key']

#debugger
#lastfm.artist.search('Madonna')
