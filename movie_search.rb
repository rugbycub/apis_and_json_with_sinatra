require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get "/" do
	erb :index
end


post '/search_result' do
    search_str = params[:movie]

    request = Typhoeus.get("http://www.omdbapi.com/", :params => {:s => search_str })
    parsed_results = JSON.parse( request.response_body )
    @movies = parsed_results["Search"]
    erb :search_results
    #@sorted = movies.sort_by { |hash| hash["Year"] }
end

get '/movie_information/:imdbID' do
    id = params[:imdbID].to_s

    request = Typhoeus.get("http://www.omdbapi.com/", :params => {:i => id })
    @results = JSON.parse( request.response_body )
    erb :movie_info

end

