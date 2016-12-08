@neo = Neography::Rest.new({:username => "user", :password => "user"})
zutaten = @neo.create_node( "name" => "Zutaten")
intoleranzen = @neo.create_node("name" => "Intoleranzen")
laktoseintoleranz = @neo.create_node( "name" => "Laktoseintoleranz")
@neo.create_relationship("is_intoleranz", intoleranzen, laktoseintoleranz)

laktose_zutaten = %w(Butter Buttermilch Buttermilchpulver Camembert Dickmilch Doppelrahmfrischkäse
                     E966 Edamer Eiscreme Feta Fruchtbuttermilch Fruchteiscreme Gouda Grießbrei
                     Hüttenkäse Joghurt Joghurteis Jogurt
                     Kaffeesahne Kamelmilch Kefir Kefirpulver Kefit Kondensmilch Kuhmilch Lactitol Lactose Laktit Laktose
                     Magermilch Magermilchpulver Magerquark Magertopfen Margarine Mascarpone Milch Milcherzeugnis
                     Milchpulver Milchschokolade Milchzubereitung Milchzucker Molke Molkenerzeugnisse Molkenpulver Mozzarella
                     Parmesan Pferdemilch Pudding Quark Rahm Ricotta Roquefort
                     Sahne Sahneeis Sahnefruchtjoghurt Sauermolke Sauermolkepulver Sauerrahm Saure-Sahne Schafsmilch
                     Schlagsahne Schmelzkäse Schokoladenzubereitung Sorbit Speiseeis Speisequark Stutenmilch Süßmolke Süßmolkenpulver
                     Tilsiter Topfen Trockenmagermilch Trockenvollmilch Vollmilch Vollmilchpulver Ziegenmilch)

laktose_zutaten.each do |l_zutat|
  new_zutat = @neo.create_node("name" => l_zutat)
  @neo.create_relationship("is_zutat", zutaten, new_zutat)
  @neo.create_relationship("verursacht", laktoseintoleranz, new_zutat)
end

