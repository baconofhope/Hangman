require 'json'

words_file = "./words.txt"
all_words = File.readlines(words_file)
all_words.map! { |w| w.upcase.chomp }
words = Array.new
1.upto(32).map { |index| words[index] = Array.new } #TODO: derive max word length programatically
all_words.map { |word| words[word.length] << word }
File.write("./words.json", words.to_json)
