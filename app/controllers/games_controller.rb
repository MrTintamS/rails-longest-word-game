require 'open-uri'
require 'json'
class GamesController < ApplicationController
  def new
    # Génère une grille de 10 lettres aléatoires
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end
  def score
    # Récupère le mot soumis et la grille
    @word = params[:word].upcase
    @letters = params[:letters].split
    @word_in_grid = word_in_grid?(@word, @letters)
    @valid_word = valid_english_word?(@word)
    # Logique de validation et message
    if !@word_in_grid
      @message = "Sorry, but #{@word} can't be built out of #{@letters.join(', ')}."
    elsif !@valid_word
      @message = "Sorry, but #{@word} is not a valid English word."
    else
      @message = "Congratulations! #{@word} is a valid English word!"
      session[:score] ||= 0
      session[:score] += @word.length
    end
  end
  private
  # Vérifie si le mot peut être construit avec les lettres disponibles
  def word_in_grid?(word, letters)
    word.upcase.chars.all? { |char| word.upcase.count(char) <= letters.count(char) }
  end
  # Vérifie si le mot est valide en anglais via une API
  def valid_english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    p response
    p JSON.parse(response)["found"]
  rescue
    false
  end
end
