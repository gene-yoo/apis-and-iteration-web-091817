require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character)
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)

  while (character_hash.fetch("next"))
    character_hash["results"].each do |character_data|
      if character_data.fetch("name").downcase == character
        return character_data.fetch("films").collect {|film| JSON.parse(RestClient.get(film))}
      end
    end
    all_characters = RestClient.get(character_hash.fetch("next"))
    character_hash = JSON.parse(all_characters)
  end
end

def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list
  films_hash.each_with_index do |film, index|
    puts "#{index + 1} #{film["title"]}"
  end
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)

  if films_hash
    parse_character_movies(films_hash)
  else
    puts "No match found."
  end
end

## BONUS

def most_expensive_vehicle_i_can_afford(limit)

end
