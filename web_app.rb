require "sinatra"
require "sinatra/reloader" if development?

enable :sessions
dictionary = File.readlines "5desk.txt"

get '/' do
	if session[:start] == true || session[:word] == nil
		redirect to("/newgame")
	end
	bridge
	win_condition
	erb :index
end

post '/' do
	check_word(params["guess"])
	redirect to('/')
end

get '/newgame' do
	valid_words = dictionary.select{ |word| str = word.size; str >= 5 && str <= 12}
	session[:word] = valid_words[rand(0..valid_words.size-1)]
	session[:show] = Array.new(session[:word].size-1, "")
	session[:start] = false
	redirect to('/')
end

get '/win' do
	session[:start] == true
	erb :win
end

def check_word(input)
    idx = 0
		counter = 0
		w = session[:word].scan /\w/
   	
		w.each do |check|
			
			if check == input
				session[:show][idx] = input
				counter += 1
			end
			
			idx += 1
		end
		
		if counter >= 1
			return true
		else
		 return false
		end  
end

def win_condition
    ray_compare = session[:word].scan /\w/
    idx = 0
    counter = 0
    ray_compare.each do |check|
        if check == @show[idx]
            counter += 1
        end
        idx +=1
    end

    if counter == ray_compare.size
        redirect to('/win')
    end
end

def bridge
	@word = session[:word]
	@show = session[:show]
end