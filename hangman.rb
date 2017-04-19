require 'json'
require_relative 'hangman_driver'

class WordGuesser
  def initialize
    words_file = File.read('./words.json')
    @words = JSON.parse(words_file)
  end

  def guess_letter(correct, incorrect)
    word_length = correct.length
    n_letter_words = @words[correct.length]
    candidate_words = n_letter_words.select { |w| (w.chars & incorrect).empty? }
    candidate_words.select! { |w| word_matches?(w, correct)}
    candidate_words.map! { |w| w.chars.to_a.uniq }
    candidate_words.flatten!
    freq = candidate_words.inject(Hash.new(0)) {|h, c| h[c] += 1; h}
    correct.chars.to_a.uniq.map { |c| freq[c] = 0 }
    return candidate_words.max_by { |v| freq[v] }
  end

  def word_matches?(word, pattern)
    raise "Length of candidate word should be same length as pattern" unless (word.length == pattern.length)
    known_chars = pattern.chars.to_a.uniq
    0.upto(word.length-1) do |i|
      unless word[i] == pattern[i] || ( pattern[i] == '*' && !known_chars.include?(word[i]) )
        return false
      end
    end
    return true
  end
end


class HangmanGame
  def initialize
    @guesser = WordGuesser.new
    @driver = HangmanDriver.new
    @max_guess_count = @driver.wrong_guess_count
    @wrong_guess_count = 0
  end

  def guess_word
    current = @driver.next_word
    incorrect = Array.new

    guess = @guesser.guess_letter(current, incorrect)
    response_word = @driver.guess_word(guess)
    @wrong_guess_count = 1
    while response_word.include?('*') && @wrong_guess_count < @max_guess_count
      if response_word == current
        incorrect << guess
        @wrong_guess_count += 1
      else
        current = response_word
      end
      guess = @guesser.guess_letter(current, incorrect)
      if !guess
        break
      end
      puts "Guessing letter #{guess}"
      response_word = @driver.guess_word(guess) 
    end
    puts "Word was #{response_word}"
  end

  def play
    while @driver.number_to_guess > 0
      if @driver.number_to_guess % 10 == 0
        puts @driver.get_result
      end
      guess_word
    end
  end

end

game = HangmanGame.new
game.play
