require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get '/' do
  html = %q(
  <html><head><title>Movie Search</title></head><body>
  <h1>Find a Movie!</h1>
  <form accept-charset="UTF-8" action="/result" method="post">
    <label for="movie">Search for:</label>
    <input id="movie" name="movie" type="text" />
    <input name="commit" type="submit" value="Search" /> 
  </form></body></html>
  )
end

post '/result' do
    search_str = params[:movie]

    request = Typhoeus.get("http://www.omdbapi.com/", :params => {:s => search_str })
    parsed_results = JSON.parse( request.response_body )
    movies = parsed_results["Search"]
    sorted = movies.sort_by { |hash| hash["Year"] }

    display = ""
    sorted.each do |movie|
        display << %Q(<li><a href="http://localhost:4567/poster/#{movie["imdbID"]}">#{movie["Title"]} (#{movie["Year"]})</a></li>)
    end

    html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1><br><ul>"
    html_str += "#{display}</ul></body></html>"

end

get '/poster/:imdb' do
    id = params[:imdb].to_s

    request = Typhoeus.get("http://www.omdbapi.com/", :params => {:i => id })
    results = JSON.parse( request.response_body )

    html_str = %Q(<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n)
    html_str += %Q(<h3>#{results["Title"]}</h3>)
    html_str += %Q(<img src="#{results["Poster"]}">)
    html_str += %Q(<br /><a href="/">New Search</a></body></html>)

end