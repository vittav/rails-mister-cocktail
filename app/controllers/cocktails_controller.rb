class CocktailsController < ApplicationController

  def index
    @cocktails = Cocktail.all
    @search = params["search"]
    if @search == [""]
      redirect_to cocktails_path if params["search"] == [""]
    else
      if @search.present?
        # raise
        @name = @search["name"]
        @cocktails = Cocktail.where(name: @name)
      else
        @cocktails = Cocktail.all
      end
    end
  end

  def show
    @dose = Dose.new
    @cocktail = Cocktail.find(params[:id])
    @doses = Dose.where(cocktail_id: @cocktail)
    @ingredients = []
    Ingredient.all.each do |ingredient|
      @ingredients << ingredient.name
    end
    @ingredients.sort!
  end

  def new
    @cocktail = Cocktail.new
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)
    # @cocktail.save
    if @cocktail.save
      redirect_to cocktails_path(@cocktail)
    else
      render 'new'
    end
  end

  def destroy
    @Cocktail = Cocktail.find(params[:id])
    @Cocktail.destroy

    redirect_to cocktails_path(@cocktail)
  end

  private

  def cocktail_params
    params.require(:cocktail).permit(:name, :img_url)
  end
end
