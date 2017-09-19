require 'rest-client'
require 'json'
require 'pry'

# ----------- ORIGINAL -----------
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

# ----------- Incorporating Jason's feedback -----------
# def all_character_data
#   all_characters = RestClient.get('http://www.swapi.co/api/people/')
#   character_hash = JSON.parse(all_characters)
#   character_data = character_hash.fetch("results")
#
#   while (character_hash.fetch("next"))
#     all_characters = RestClient.get(character_hash.fetch("next"))
#     character_hash = JSON.parse(all_characters)
#     character_data << character_hash.fetch("results")
#   end
#
#   character_data.flatten
# end
#
# def get_character_movies_from_api(character)
#   all_characters = all_character_data
#   solution = all_characters.find do |char|
#     char.fetch("name").downcase == character
#   end
#   if solution
#     solution.fetch("films").collect {|film| JSON.parse(RestClient.get(film))}
#   end
# end

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

## ----------- BONUS -----------

# method to find most expensive vehicle based on spending limit
def most_expensive_vehicle_i_can_afford(limit)
  all_vehicles = RestClient.get('http://www.swapi.co/api/vehicles/')
  vehicles_hash = JSON.parse(all_vehicles)

  max_vehicle = ""
  max_cost = 0

  while (vehicles_hash.fetch("next"))
    vehicles_hash["results"].each do |vehicle_data|
      if (vehicle_data.fetch("cost_in_credits").to_i > max_cost && vehicle_data.fetch("cost_in_credits").to_i <= limit)
        max_vehicle = vehicle_data.fetch("name")
        max_cost = vehicle_data.fetch("cost_in_credits").to_i
      end
    end
    all_vehicles = RestClient.get(vehicles_hash.fetch("next"))
    vehicles_hash = JSON.parse(all_vehicles)
  end

  if max_cost == 0
    "You can't afford any vehicles for your limit of #{limit}."
  else
    "You can afford #{max_vehicle} for #{max_cost} in credits."
  end
end

# method to find all star wars vehicles and prices
def all_star_wars_vehicles
  all_vehicles = RestClient.get('http://www.swapi.co/api/vehicles/')
  vehicles_hash = JSON.parse(all_vehicles)
  collection = []

  while (vehicles_hash.fetch("next"))
    vehicles_hash["results"].each do |vehicle_data|
      collection << {vehicle_data.fetch("name") => vehicle_data.fetch("cost_in_credits")}
    end
    all_vehicles = RestClient.get(vehicles_hash.fetch("next"))
    vehicles_hash = JSON.parse(all_vehicles)
  end
  collection
end

# sets the api of the type of thing you want to use. e.g. people, planets, films, species, vehicles, starships, must be the right text for the url
def all_whatever
  puts "Which API would you like to use? (people, planets, films, species, vehicles, starships)"
  thing = gets.chomp
  all_objects = RestClient.get("http://www.swapi.co/api/#{thing}/")
  objects_hash = JSON.parse(all_objects)
  objects_data = objects_hash.fetch("results") #array

 while objects_hash.fetch("next")
    all_objects = RestClient.get(objects_hash.fetch("next"))
    objects_hash = JSON.parse(all_objects)
    objects_data << objects_hash.fetch("results")
  end
  objects_data.flatten
end
