PImage img;
PShape globe;
PShape sat;
float rotationY;
float rotationX;
float i, c;
float x, y, z;
float lat, lon;
float x2, y2, z2;
float lat2, lon2;
float angle = 1;
float h = 30000;
PVector cords;
JSONObject json;
JSONArray values;
String satName;
int satId;
void setup() {

  c = 0.01;
  rotationY = 0;
  rotationX = 0;
  size(820, 600, P3D);
  img = loadImage("earth.jpg");
  noStroke();
  globe = createShape(SPHERE, 200);
  globe.setTexture(img);
      textSize(20);
  sat = createShape(BOX, 20);
  jsonLoad();
}

void draw() {


  background(110);
  PVector satpos =  convert(lat, lon, 240);
  PVector satpos2 =  convert(lat2, lon2, 240);

  PVector satD = new PVector(satpos2.x - satpos.x, satpos2.y - satpos.y, satpos2.z - satpos.z);

  fill(255);
  text("Sattellite: " + satName, 0, 80);
  text("SatID: " + satId, 0, 130);
  
  
  satD.normalize();
  i++;

  lights();
  stroke(255);

  if (keyPressed && key == 'd') {
    rotationY  -= 1;
  } else if (keyPressed && key == 'a') {
    rotationY  += 1;
  } else if (keyPressed && key == 'w') {
    rotationX  -= 1;
  } else if (keyPressed && key == 's') {
    rotationX  += 1;
  } else if (keyPressed && key == 'r') {
    rotationX = 0;
    rotationY = 0;
  }
  pushMatrix();
  translate(width / 2, height / 2, 0);
  rotateY(radians(rotationY));
  rotateX(radians(rotationX));
  shape(globe );

  pushMatrix();
  rotateY(satD.y*i*c);
  translate(0, 0, 240);
  sat.setFill(color(0, 0, 255));
  shape(sat, satpos.x, satpos.y);
  popMatrix();
  popMatrix();


  fill(127);
}
void jsonLoad() {
  json = loadJSONObject("https://api.n2yo.com/rest/v1/satellite/positions/25544/41.702/-76.014/0/2/&apiKey=7XB5VF-GJ92GU-8UMJZW-4YB9");
  values = json.getJSONArray("positions");
  JSONObject pos1 = values.getJSONObject(0);
  JSONObject pos2 = values.getJSONObject(1);
  
  JSONObject info = json.getJSONObject("info");
  satName = info.getString("satname");
  satId = info.getInt("satid");
  

  lat = pos1.getFloat("satlatitude");
  lon = pos1.getFloat("satlongitude");
  h = pos1.getFloat("sataltitude");
  lat2 = pos2.getFloat("satlatitude");
  lon2 = pos2.getFloat("satlongitude");
}
PVector convert(float lat, float lon, float h ) {
  float theta = radians(lat);
  float phi = radians(lon) + PI;

  // fix: in OpenGL, y & z axes are flipped from math notation of spherical coordinates
  float x = h * cos(theta) * cos(phi);
  float y = -h * sin(theta);
  float z = -h * cos(theta) * sin(phi);

  return new PVector(x, y, z);
}
