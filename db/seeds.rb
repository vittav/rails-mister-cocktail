require 'open-uri'
require 'json'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)
url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
serialized = open(url).read
ingredients = JSON.parse(serialized)

ingredients["drinks"].each do |ingredient|
  Ingredient.create(name: ingredient["strIngredient1"])
end

30.times do
  random = 'https://www.thecocktaildb.com/api/json/v1/1/random.php'
  serial_random = open(random).read
  cocktails = JSON.parse(serial_random)
  p cocktails['drinks'][0]['strDrink']
  cocktail = Cocktail.new(name: cocktails['drinks'][0]['strDrink'],
                          img_url: cocktails['drinks'][0]['strDrinkThumb'])
  cocktail.save
  p "Creating #{cocktail}..............................................."
  i = 1
  p "Testing conditions................................................."
  p cocktails['drinks'][0]["strIngredient1"]
  p "..................................................................."
  until cocktails['drinks'][0]["strIngredient#{i}"] == nil
    ingredient = Ingredient.where(name: cocktails['drinks'][0]["strIngredient#{i}"])
    p ingredient[0]
    if ingredient[0].nil?
      p "nil"
      new_ingredient = Ingredient.new(name: cocktails['drinks'][0]["strIngredient#{i}"])
      new_ingredient.save
      p new_ingredient
      dose = Dose.new(cocktail_id: cocktail.id, ingredient_id: new_ingredient.id, description: cocktails['drinks'][0]["strMeasure#{i}"])
      p "#{dose}"
      dose.save
    else
      p "not nil"
      dose = Dose.new(cocktail_id: cocktail.id, ingredient_id: ingredient[0].id, description: cocktails['drinks'][0]["strMeasure#{i}"])
      p "#{dose}"
      dose.save
    end
    i += 1
  end
end
