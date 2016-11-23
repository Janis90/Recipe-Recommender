class Event < ActiveRecord::Base
  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events
  belongs_to :creator, class_name: "User"

  validates :title,       presence: true
  validates :start_time,  presence: true
  validate :validate_end_time
  validate :validate_date

  after_initialize :set_default_date

  #end_time can not be before start time
  def validate_end_time
    if self.end_time.present? && self.end_time < self.start_time
      errors.add(:end_time, "can't be before start time")
    end
  end

  #date can't be in the past
  def validate_date
    if self.date.present? && self.date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end

  def set_default_date
    self.date ||= Date.today if new_record?
  end

  #calculates recommendations for a specific menu_type and a group of people
  def self.calculate_reommendations(menu_type, participants)
    recipe_scores = {}
    ingredient_scores = {}
    recipes = filter(menu_type, participants)
    recipe_recommendations = {}
    r = Random.new

    recipes.each {|recipe|
      recipe.ingredients.each { |ingredient|
        if ingredient.is_foodcategory
          ingredient_rankings = []

          #get the ingredient's rating from every user
          participants.each {|participant|
            ingredient_rankings << get_ingredient_ranking(participant, ingredient)
          }
          ingredient_scores[ingredient] = calculate_ingredient_score(ingredient_rankings, participants.size)
        end
      }
      recipe_scores[recipe] = calculate_recipe_score(recipe, ingredient_scores, participants.length)
    }

    (0..2).each do |i|
      key_value = largest_hash_key(recipe_scores)
      debugger
      if key_value.present?
        recipe_recommendations[key_value[0]] = key_value[1]
        recipe_scores.delete(key_value[0])
      end
    end


=begin
    possible_recommendations = recipe_scores.select{|k,v| v > 0.7}
    (0..2).each do |i|
      index = r.rand(0..(possible_recommendations.length -1))
      key = possible_recommendations.keys[index]
      unless key.present?
        recipe_recommendations[key] = recipe_scores[key]
        possible_recommendations.delete(key)
      end
    end
=end
debugger
    recipe_recommendations

  end

  private

  # filters recipes
  # only recipes are taken that belong to a certain menu_type and don't cause a problem for allergic people
  def self.filter(menu_type, participants)
    #a collection of all user's allergies
    allergies = []
    recipes = Recipe.where(menu_type: menu_type)

    participants.each { |participant|
      participant.allergies.each {|allergy|
        allergies << allergy unless allergies.include?(allergy)
      }
    }

    recipes.each { |recipe|
      recipe.allergies.each {|allergy|
        if allergies.include?(allergy)
          recipes.delete(recipe)
          break
        end
      }
    }
    recipes
  end

  def self.get_ingredient_ranking(participant, ingredient)
    user_ingredient = UserIngredient.where('user_id = ? and ingredient_id = ?', participant.id, ingredient.id).first
    user_ingredient.rating
  end

  # the score for a single ingredient is based on the ranking of all participants
  # in order to garantee that ingredients that a participant hates are excluded -> -inf
  # ingredients are rated based on exponentional groth, this garantees that ingredients are more likely to be selected
  #   when people love it
  # number_of_participants is needed because a fixed value can lead to under-/overestimation of an ingredient
  def self.calculate_ingredient_score(ingredient_rankings, number_of_participants)
    score = 0.0
    ingredient_rankings.each { |ingredient_rating|
      case ingredient_rating
        when 1
          score -= 1000 * number_of_participants
        when 2
          # equals out 1 (+5points) ingredient that everybody loves
          score -= 30 * (number_of_participants - 1)
        when 3
          # 3 does not have any effect on the outcome
        else
          score += ingredient_rating**2
      end
    }
    score
  end


  def self.calculate_recipe_score(recipe, ingredient_scores, number_participants)
    number_relevant_ingredients = 0
    score = 0.0
    # max score equals every participant loves (5) all relevant ingredients in a recipe
    max_score = 0.0
    #TODO exeption #relevant_ingredient = 0
    recipe.ingredients.each { |ingredient|
      if ingredient.is_foodcategory
        number_relevant_ingredients += 1
        score += ingredient_scores[ingredient]
      end
    }

    max_score = number_relevant_ingredients * number_participants * 25

    #the weighting is used so that recipes with only few important ingredients are not always selected
    if number_relevant_ingredients < 3
      score = score / max_score * 0.7
    elsif number_relevant_ingredients < 6
      score = score / max_score * 0.9
    else
      score = score / max_score
    end

    score
  end

  #returns an array [key,value]
  def self.largest_hash_key(hash)
    hash.max_by{|k,v| v}
  end
end


