class MyDiscogs
  def self.search artist
    wrapper = Discogs::Wrapper.new("My script")
    search = wrapper.search(artist)

    discogs_result = []
    search.results(:release).each do |release|
      discogs_result << { title: release.title, uri: release.uri, thumb: release.thumb, num: release.num }
    end

    discogs_result = { albums: discogs_result }

    discogs_result.to_json
  end
end
