class IngredientDependency
  # e. g. @neo = Neography::Rest.new({:username => "user", :password => "user"})
  def initialize(neo)
    @neo = neo
    @laktose_zutaten = %w(Butter Buttermilch Buttermilchpulver Camembert Dickmilch Doppelrahmfrischkäse
                     E966 Edamer Eiscreme Feta Fruchtbuttermilch Fruchteiscreme Gouda Grießbrei
                     Hüttenkäse Joghurt Joghurteis Jogurt
                     Kaffeesahne Kamelmilch Kefir Kefirpulver Kefit Kondensmilch Kuhmilch Lactitol Lactose Laktit Laktose
                     Magermilch Magermilchpulver Magerquark Magertopfen Margarine Mascarpone Milch Milcherzeugnis
                     Milchpulver Milchschokolade Milchzubereitung Milchzucker Molke Molkenerzeugnisse Molkenpulver Mozzarella
                     Parmesan Pferdemilch Pudding Quark Rahm Ricotta Roquefort
                     Sahne Sahneeis Sahnefruchtjoghurt Sauermolke Sauermolkepulver Sauerrahm Saure-Sahne Schafsmilch
                     Schlagsahne Schmelzkäse Schokoladenzubereitung Sorbit Speiseeis Speisequark Stutenmilch Süßmolke Süßmolkenpulver
                     Tilsiter Topfen Trockenmagermilch Trockenvollmilch Vollmilch Vollmilchpulver Ziegenmilch)
  end

  def setup_db
    zutaten = @neo.create_node( "name" => "Zutaten")
    @neo.add_node_to_index("nodes", "name", "Zutaten", zutaten)
    intoleranzen = @neo.create_node("name" => "Intoleranzen")
    @neo.add_node_to_index("nodes", "name", "Intoleranzen", zutaten)
    laktoseintoleranz = @neo.create_node( "name" => "Laktoseintoleranz")
    @neo.add_node_to_index("nodes", "name", "Laktoseintoleranz", laktoseintoleranz)
    @neo.create_relationship("is_intoleranz", intoleranzen, laktoseintoleranz)


    @laktose_zutaten.each do |l_zutat|
      new_zutat = @neo.create_node("name" => l_zutat)
      @neo.add_node_to_index("nodes", "name", l_zutat, new_zutat)
      @neo.create_relationship("is_zutat", zutaten, new_zutat)
      @neo.create_relationship("verursacht", laktoseintoleranz, new_zutat)
    end
  end
end


