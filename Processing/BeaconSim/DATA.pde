// Classes that contains our urban sensor simulation
ArrayList<Field> city;
int cityIndex = 0;

void initFields() {
  
  city = new ArrayList<Field>();
  Field f;
  PImage img;
  
  // Mills Park (PaganFest)
  img = loadImage("0/millspark_1000ft.png");
  f = new Field(1000, 1000, 50, img); // (ft, ft, ft)
  city.add(f);
  f.loadBlocks("0/millspark_buildings.tsv");
  
  // Las Cruces
  // TBA  
    
  // 30 Rockefeller Center
  // TBA
}