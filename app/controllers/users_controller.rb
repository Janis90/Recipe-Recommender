class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user
  before_action :set_allergies, only: :edit
  before_action :set_category_ingredients, only: :edit
  #before_action :set_user_ingredients, only: :edit
  before_action :set_priorities

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    if params[:user][:allergy_ids].present?
      @user.allergies = get_allergies_from_params
    end

    if params[:user][:user_ingredients_attributes].present?
      @user.user_ingredients = get_user_ratings_from_params
    end

    if @user.save
    redirect_to edit_user_path(@user), notice: t('allergies.update_success')
    else

    redirect_to edit_user_path(@user), alert: t('allergies.update_fail')
    end
  end

  private

  def set_current_user
    @user = current_user
  end

  def set_allergies
    @allergies = Allergy.all
  end

  def get_allergies_from_params
    Allergy.where(id: params[:user][:allergy_ids])
  end

  def get_user_ratings_from_params
    user_ingredients = []
    temp = params[:user][:user_ingredients_attributes]
    temp.each do |t|
      user_ingredient = UserIngredient.where(id: t[1][:id]).first
      user_ingredient.rating = t[1][:rating]
      user_ingredients << user_ingredient
    end
    user_ingredients
  end

  #sets all types of ingredients that are a category
  #categories are ingredients that allow a good clustering
  #food categories are e.g. 'Potatoes', 'Rice' and 'Fish'
  def set_category_ingredients
    @ingredients = Ingredient.where(is_foodcategory: true)
  end

  #def get_category_ingredients_from_params
    #Ingredient.where(id: params[:user][:ingredient_ids])
  #end
  #
  #user_ingredients,rating gets the user's rating for
  #def set_user_ingredients
    #@ratings = @user.user_ingredients
  #end

  #sets a hash with values, accosiated with how much a user likes an ingredient
  # PRIORITY = {1 => "Hate", 2 => "Dislike", 3 => "It's okay", 4 => "Like", 5 => "Love" }
  def set_priorities
    @priorities = UserIngredient::PRIORITY
  end
end
