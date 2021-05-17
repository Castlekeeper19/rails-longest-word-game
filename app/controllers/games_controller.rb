require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @start = Time.now.strftime("%S")
    alphabet = ("A".."Z").to_a
    @letters = []
    10.times {@letters << alphabet.sample}
    @letters
    @score = params[:score]
  end

  def score
    @old_score = params[:score].to_i
    @finish = Time.now.strftime("%S").to_i
    @start = params[:start].to_i
    @duration = duration(@finish, @start)
    @letters = params[:letters].split
    @guess = params[:guess]
    if word?(@guess) && include?(@guess, @letters)
      @results =  "Your word exists and is in the grid."
      @score = ((@guess.length * 100) / @duration) + @old_score
    elsif word?(@guess)
      @results =  "Your word is not in the grid."
      @score = @old_score
    elsif include?(@guess, @letters)
      @results = "Your word does not exist."
      @score = @old_score
    else
      @results = "Your word does not exist and is not in the grid."
      @score = @old_score
    end
  end

  def word?(guess)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{guess}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def include?(guess, letters)
    guess.chars.all? {|char| guess.count(char) <= letters.count(char)}
  end

  def duration(finish,start)
    if finish < start
      @duration = (finish + 60) - start
    else
      @duration = finish - start
    end
  end
end
