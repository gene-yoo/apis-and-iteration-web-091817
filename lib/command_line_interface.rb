def welcome
  # puts out a welcome message here!
  puts "A long time ago, in a galaxy far, far away, you need information"
end

def get_character_from_user
  puts "please enter a character"
  # use gets to capture the user's input. This method should return that input, downcased.
  character = gets.strip.downcase
end
