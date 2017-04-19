# HangmanSolver
README.md

## Building and running
 - Ruby v2.2.2
 - Clone this project
 - Install the 'httparty' gem via `gem install httparty`
 - To play, run `ruby hangman.rb` in the code directory.

## Methodology
I used the Moby wordlist from http://www.gutenberg.org/ebooks/3201. I wrote a small script called `create_words_json.rb` to parse the complete wordlist and categorize words according to their word length. This is stored in json format and read by the WordGuesser class.

My algorithm isn't anything special, it just sorts characters by frequency based on the known information. Initially, that is only the word length. As the game progresses, some information is known about which characters do not appear in the word and the position of characters in the word. This limits the candidate set of possible words, and the character frequencies are recalculated accordingly.

## Future improvements
For future improvements, I would like to implement a cost function to determine when to stop guessing a word. I would do this by calculating the expectated value of placing the next guess. This formula is something like: `E = Frequency of guessed character / Total number of candidate words * Value of correct word + (1 - Frequency / Total number) * (Penalty of incorrect word)` where value of the correct word is 20 and penalty of the incorrect word is -10. If the expected value is lower than the current score for the word (ie -1 * number of incorrect guesses), then we should choose to stop guessing.

In general, I could also analyze the words my algorithm did not guess successfully to see if there are better strategies. 

On the engineering side, I would improve the logging and error handling for my program.
