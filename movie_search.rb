require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

MY_DB = []


get "/" do
	@movies = MY_DB

	erb :index
end

post '/' do
	movie = params[:movie]
	MY_DB << movie
	request = Typhoeus.get("http://www.omdbapi.com/", :params => {:s => movie[title] })
	parsed_results = JSON.parse( request.response_body )
	movies = parsed_results["Search"]
    sorted = movies.sort_by { |hash| hash["Year"] }

    display = ""
    sorted.each do |movie|
      @movies << {:title => movie["Title"], :year => movie["Year"], :imdb => movie["imdbID"]}   
		end
    erb :search_results
end

