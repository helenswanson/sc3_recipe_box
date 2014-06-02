require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname: 'slacker_news')
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
  recipes = recipes.sort_by do |recipe|
    recipe["name"]
  end
  recipes
end

#get a single recipe
def get_recipe(recipe_id)
  query = "SELECT recipe.name, description, instructions
            FROM recipes
            JOIN ingredients ON recipes.id = ingredients.recipe_id
            WHERE recipes.id = $1 "
  recipe = db_connection do |conn|
    conn.exec_params(query, [recipe_id])
  end

  query = "SELECT ingredients.name
            FROM recipes
            JOIN ingredients ON recipes.id = ingredients.recipe_id
            WHERE recipes.id = $1 "
  ingredients = b_connection do |conn|
    conn.exec_params(query, [recipe_id])
  end
  recipe = recipe.to_a
  ingredients = ingredients.to_a
  recipe, ingredients
end


