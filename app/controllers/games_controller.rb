require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(26)
  end

  def score
    @word = params[:new]
    @in_grid = check_grid(params[:letters], @word)
    @valid_word = an_english_word(@word)
    @score_message = score_reply(@in_grid, @valid_word)
  end

  def score_reply(in_grid, valid_word)
    if in_grid == false
      "NOT IN GRID!"
    elsif valid_word == false
      "NOT A VALID WORD"
    else
      "YOU GOT IT!"
    end
  end

  private

  def generate_grid(grid_size)
    returned_alpha = []
    grid_size.times do
      returned_alpha << ("A".."Z").to_a.sample
    end
    returned_alpha
  end

  def an_english_word(attempt)
    html_content = URI.open("https://dictionary.lewagon.com/#{attempt}").read
    parsed_info = JSON.parse(html_content)
    parsed_info["found"]
  end

  def check_grid(grid, attempt)
    grid_array = grid.chars
    attempt_array = attempt.upcase.chars
    attempt_array.each do |letter|
      if grid_array.include?(letter)
        grid_array.delete_at(grid_array.index(letter))
      else
        return false
      end
    end
    return true
  end
end
