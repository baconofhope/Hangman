require 'httparty'
require 'json'

class HangmanDriver
  PLAYER_ID = <id>
  REQUEST_URL = <url>
  START_GAME = "startGame"
  NEXT_WORD = "nextWord"
  GUESS_WORD = "guessWord"
  GET_RESULT = "getResult"

  attr_reader :number_to_guess
  attr_reader :wrong_guess_count

  def initialize
    request = { "playerId" => PLAYER_ID, "action" => START_GAME }
    response = send_request(request)
    @session_id = response['sessionId']
    @wrong_guess_count = response['data']['numberOfGuessAllowedForEachWord']
    @total_number_to_guess = response['data']['numberOfWordsToGuess']
    @number_to_guess = @total_number_to_guess
  end

## TODO: CATCH HTTP errors and retry!
  def send_request(request)
    begin
      postData = HTTParty.post(REQUEST_URL, body: request.to_json, :headers => { 'Content-Type' => 'application/json' })
    rescue EOFError,SocketError => error
      sleep(0.5)
      STDERR.puts "retrying request"
      retry
    end
    return JSON.parse(postData.body)
  end

  def next_word
    request = { "sessionId" => @session_id, "action" => NEXT_WORD }
    response = send_request(request)
    @number_to_guess = @total_number_to_guess - response["data"]["totalWordCount"]
    return response["data"]["word"]
  end

  def guess_word(guess)
    request = { "sessionId" => @session_id, "action" => GUESS_WORD, "guess" => guess.upcase }
    response = send_request(request)
    return response["data"]["word"]
  end

  def get_result
    request = { "sessionId" => @session_id, "action" => GET_RESULT }
    return send_request(request)
  end
end

