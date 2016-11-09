class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy, :add_recipe]

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.all
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = Recipe.new(recipe_params)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def my_recipes
    @recipes = current_user.recipes
  end

  def add_recipe
    UserRecipe.create(user: current_user, recipe: @recipe)
    redirect_to my_recipes_path, notice: 'Recipe was successfully added.'
  end

  def search_for_recipes
    #require 'open-uri'
    #TODO add other categories
    #crawler = WebCrawler.new('http://www.lecker-ohne.de/alle-rezepte?&ka=1&titel=&field_rezeptzutaten_value=&&items_per_page=60', 'Vorspeise')
    #crawler.crawl

     crawler = WebCrawler.new('http://www.lecker-ohne.de/alle-rezepte?&ka=6&titel=&field_rezeptzutaten_value=&&items_per_page=60&page=2', 'Hauptgericht')
     crawler.crawl

     #crawler = WebCrawler.new('http://www.lecker-ohne.de/alle-rezepte?ka=7&titel=&field_rezeptzutaten_value=&items_per_page=60', 'Dessert')
     #crawler.crawl
    redirect_to recipes_url, notice: 'Recipes added.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.require(:recipe).permit(:name, :url, :instructions, :picture_url, :menu_type)
    end
end
