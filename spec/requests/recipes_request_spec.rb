require 'rails_helper'

RSpec.describe 'Recipes API', type: :request do
  let(:user) { create(:user) }
  let!(:recipes) { create_list(:recipe, 10, user_id: user.id) }
  let(:recipe_id) { recipes.first.id }

  describe 'GET /api/v1/recipes' do
    before { get '/api/v1/recipes' }

    it 'returns recipes' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /api/v1/recipes' do
    let(:valid_attributes) do
      {
        recipe: {
          title: 'Chicken Piccata',
          description: 'A classic Italian dish',
          ingredients: 'Chicken, Parmesan, Piccata Sauce',
          steps: 'Bread chicken, fry chicken, add sauce and cheese, bake'
        }
      }.to_json
    end

    context 'when the request is valid' do
      before do
        post '/api/v1/recipes', params: valid_attributes, headers: headers(user)
      end

      it 'creates a recipe' do
        expect(json['title']).to eq('Chicken Piccata')
        expect(json['description']).to eq('A classic Italian dish')
        expect(json['ingredients']).to eq('Chicken, Parmesan, Piccata Sauce')
        expect(json['steps']).to eq('Bread chicken, fry chicken, add sauce and cheese, bake')
        expect(json['user_id']).to eq(user.id)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid (missing title)' do
      before do
        post '/api/v1/recipes', params: { recipe: { description: 'A classic Italian dish', ingredients: 'Chicken, Parmesan, Piccata Sauce', steps: 'Bread chicken, fry chicken, add sauce and cheese, bake' } }.to_json, headers: headers(user)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation error message' do
        expect(response.body)
          .to match(["can't be blank", 'is too short (minimum is 5 characters)'].to_json)
      end
    end
  end

  describe 'PUT /api/v1/recipes/:id' do
    let(:valid_attributes) do
      {
        recipe: {
          title: 'Chicken Parm Updated'
        }
      }.to_json
    end

    context 'when the record exists' do
      before do
        put "/api/v1/recipes/#{recipe_id}", params: valid_attributes, headers: headers(user)
      end

      it 'updates the record' do
        expect(json['title']).to eq('Chicken Parm Updated')
        expect(json['created_at']).not_to eq(json['updated_at'])
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
