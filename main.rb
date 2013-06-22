require './gems.rb'
require './discogs.rb'
require './lastfm.rb'

puts 'Please type artist name:'
artist = gets

raise "Sorry but you didn't enter artist name. Bye!" if artist == "\n"

puts 'search for releases in Discogs.......'

puts MyDiscogs.search(artist)

puts 'search for releases in Lastfm........'

puts MyLastfm.search(artist)
