def movie(str)
    request = Typhoeus.get("http://www.omdbapi.com/", :params => {:s => str })
    parsed_results = JSON.parse( request.response_body )
    movies = parsed_results["Search"]
end

def poster(var)
  var.each do |movie|
  movie_search_str = movie[:imdbID]
  movie_request = Typhoeus.get("http://www.omdbapi.com/", :params => {:i => movie_search_str})
  movie_parsed_results = JSON.parse( movie_request.response_body )
  puts movie_parsed_results
end
