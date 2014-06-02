require 'sinatra'
require 'pg'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)

  ensure
    connection.close
  end
end

#get entire list of recipes in alphabetical order
def get_all_recipes()
  query = "SELECT id, name FROM recipes"
  recipes = db_connection do |conn|
    conn.exec(query)
  end
  recipes = recipes.to_a
  recipes.sort_by {|recipe| recipe["name"]}
end

# #get a single recipe
# def get_recipe(recipe_id)
#   query = "SELECT name, description, instructions
#             FROM recipes
#             WHERE recipes.id = $1 "
#   recipe = db_connection do |conn|
#     conn.exec_params(query, [recipe_id])
#   end
# recipe.to_a
# end

#get recipe ingredients
def get_ingredients(recipe_id)

end

#==============

get '/' do
  redirect '/recipes'
end

#
get '/recipes' do
  @recipes = get_all_recipes
  erb :recipes
end

get '/recipes/:id' do
  @recipe_id = params["id"] #CHECK IF CORRECT PARAMS
  @recipe = get_recipe(@recipe_id)
  @ingredients = get_ingredients(@recipe_id)
  erb :recipe
end
