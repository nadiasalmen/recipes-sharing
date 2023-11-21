# frozen_string_literal: true

class Api::V1::RecipesController < ApplicationController
  before_action :authenticate_api_v1_user!, except: [:index]
  before_action :set_recipe, only: [:update]

  def index
    recipes = Recipe.all
    render json: recipes
  end

  def create
    user_id = user_id(request.headers['Authorization'].split(' ').last)
    recipe = Recipe.new(recipe_params.except(:image))
    attach_image(recipe, params[:recipe][:image]) if params[:recipe][:image]
    recipe.user_id = user_id.to_i if user_id
    if recipe.save
      render json: recipe, status: :created
    else
      render json: recipe.errors, status: :unprocessable_entity
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

  def attach_image(recipe, base64_image)
    decoded_image = Base64.decode64(base64_image)
    temp_file = Tempfile.new
    temp_file.binmode
    temp_file.write(decoded_image)
    temp_file.rewind
    blob = ActiveStorage::Blob.create_and_upload!(
      io: temp_file,
      filename: 'your_image_name.jpg',
      content_type: 'image/jpeg'
    )
    recipe.image.attach(blob)
    temp_file.close
    temp_file.unlink

    recipe
  end
end
