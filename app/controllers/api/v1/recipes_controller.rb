# frozen_string_literal: true

class Api::V1::RecipesController < ApplicationController
  before_action :authenticate_api_v1_user!, except: [:index]
  before_action :set_recipe, only: [:update]

  def index
    @recipes = Recipe.all
    render json: @recipes
  end

  def create
    user_id = user_id(request.headers['Authorization'].split(' ').last)
    @recipe = Recipe.new(recipe_params.except(:image))
    @recipe.user_id = user_id.to_i if user_id
    if @recipe.save
      AttachImageJob.perform_later(recipe: @recipe, base64_image: recipe_params[:image]) if recipe_params[:image]
      render json: @recipe, status: :created
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  def update
    if @recipe.update(recipe_params)
      render json: @recipe
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  private

  def set_recipe
    user_id = user_id(request.headers['Authorization'].split(' ').last)
    render json: { error: 'User not found' }, status: :not_found unless user_id

    @recipe = Recipe.find_by(id: params[:id])
    render json: { error: 'Recipe not found' }, status: :not_found unless @recipe
  end

  def recipe_params
    params.require(:recipe).permit(:title, :ingredients, :steps, :description, :image)
  end

  def user_id(token)
    decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: 'HS256' })
    decoded_token[0]['sub']
  end
end
