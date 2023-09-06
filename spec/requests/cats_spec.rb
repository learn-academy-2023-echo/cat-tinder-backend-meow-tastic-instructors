require 'rails_helper'

RSpec.describe "Cats", type: :request do
  describe "GET /index" do
    it "gets a list of cats" do 
      Cat.create(
        {
          name: 'Felix',
          age: 2,
          enjoys: 'Long naps on the couch, and a warm fire.',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      )
      # Make a request to endpoint
      get '/cats'
      # Specify data we want back in format of JSON
      cat = JSON.parse(response.body)
      # Assert to check that the response is a successful response of 200
      expect(response).to have_http_status(200)
      expect(cat.length).to eq 1
    end
  end

  describe "POST /create" do 
    it "creates a cat" do 
      cat_params = {
        cat: {
          name: 'Felix',
          age: 2,
          enjoys: 'Long naps on the couch, and a warm fire.',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      # Send the request to the server and pass params which are cat_params
      post '/cats', params: cat_params
      # Assert that this request was successful
      expect(response).to have_http_status(200)

      cat = Cat.first 

      p cat.id
      expect(cat.name).to eq 'Felix'
      expect(cat.age).to eq 2
      expect(cat.enjoys).to eq 'Long naps on the couch, and a warm fire.'
    end
  end

  describe "PATCH /update" do 
    it "updates a cat" do 
      # First create a cat so we have an instance to update
      cat_params = {
        cat: {
          name: 'Felix',
          age: 2,
          enjoys: 'Long naps on the couch, and a warm fire.',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      # Send the request to the server and pass params which are cat_params
      post '/cats', params: cat_params
      cat = Cat.first 

      updated_cat_params = {
        cat: {
          name: 'Felix',
          age: 3,
          enjoys: 'Long naps on the couch, and a warm fire.',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      # Make a request to update cat using string interpolation for the cat id
      patch "/cats/#{cat.id}", params: updated_cat_params
      # We need to grab the instance of cat after it has been updated to assert against it.
      updated_cat = Cat.find(cat.id)
      expect(response).to have_http_status(200)
      expect(updated_cat.age).to eq 3 
    end
  end

  describe "DELETE /destroy" do 
    it "deletes a cat" do 
      cat_params = {
        cat: {
          name: 'Felix',
          age: 2,
          enjoys: 'Long naps on the couch, and a warm fire.',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }

      post "/cats", params: cat_params
      cat = Cat.first
      delete "/cats/#{cat.id}"
      expect(response).to have_http_status(200)
      cats = Cat.all 
      expect(cats).to be_empty
    end
  end

  # Validation Request Specs
  describe "cannot create a cat without valid attributes" do 
    it "does not create a cat without a name" do 
      # Create a cat without a name
      cat_params = {
        cat: {
          age: 2,
          enjoys: 'Long naps on the couch, and a warm fire.',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      # Send request to server
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      # same test as above just written differently: 
      # expect(response).to have_http_status(422)

      # Convert the JSON response to Ruby hash
      cat = JSON.parse(response.body)
      expect(cat['name']).to include "can't be blank"
    end
    
    it "does not create a cat without a age" do 
      # Create a cat without a age
      cat_params = {
        cat: {
          name: 'Tobey',
          enjoys: 'Long naps on the couch, and a warm fire.',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      # Send request to server
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      # same test as above just written differently: 
      # expect(response).to have_http_status(422)

      # Convert the JSON response to Ruby hash
      cat = JSON.parse(response.body)
      expect(cat['age']).to include "can't be blank"
    end
  end
end
