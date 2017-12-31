import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;

Extrusion e;

Path path;
Contour contour;
ContourScale conScale;
RandomSpline randSpline;

float dist_from;
float dist_to;
float dist;
float mult;
float increment_z;
float inc_the_inc;

int   size_w=4000;
int   size_h=4000;
int   scale=2;
String textureFile=null;//"textures/triangles.jpg";

void restart() {
  dist_from=-8000;
  dist_to=-300;
  dist=dist_from;
  increment_z=0.1;
  inc_the_inc=0.005;
}

void settings() {
  size(size_w, size_h, P3D);
  mult=(size_w/600)/scale;
}

public void setup() {
  randSpline = new RandomSpline();
  //contour = new Spiral(10,80,radians(0), radians(600),80);
  conScale = new CornucopiaScale();
  reset();
  restart();
  background(0, 0, 0);
  smooth(8);
  Shape3D.setOptimizedStrokeOn(true);
}

void reset() {
  randSpline.reset();
  contour = new Spiral(random(2*mult,15*mult),
                       random(20*mult,100*mult),radians(0), 
                       radians(random(200,800)),80);
}

color getCornucopiaColor() {
  //return color(random(0, 255),random(50, 100),random(100, 255));
  return color(0,0,255);
}

public void draw() {
  scale(scale);
  colorMode(HSB, 255);
  color c = getCornucopiaColor();
  color cs = color(0,0,0,40);
  dist+=increment_z;
  increment_z+=inc_the_inc;
  reset();
  float z = dist; 
  float d = (abs(z)/1.8)*mult;

  translate(random(-d,width+d),random(-d,height+d),z);
  lights();
  ambientLight(0, 0, 0);
  directionalLight(0, 0, 128, -5, 5, -1);
  lightFalloff(0, 0, 10);
  //lightSpecular(0, 0, 0);   
  

  path = randSpline.path();
  e = new Extrusion(this, path, 100, contour, conScale);
  if (textureFile!=null) {
    e.setTexture(textureFile, 4, 7);
    e.drawMode(S3D.TEXTURE);
  } else {
    e.drawMode(S3D.SOLID | S3D.WIRE);
  }
  
  e.strokeWeight(0.5f);
  e.stroke(cs);
  e.fill(c);

  // End caps
  e.stroke(cs, S3D.BOTH_CAP);
  e.fill(c, S3D.BOTH_CAP);
  e.strokeWeight(2.2f, S3D.BOTH_CAP);
  if (textureFile!=null) {
    e.setTexture(textureFile, S3D.BOTH_CAP);
    e.drawMode(S3D.TEXTURE, S3D.BOTH_CAP);
  } else {
    e.drawMode(S3D.SOLID | S3D.WIRE);
  }
  
  e.draw();
  if (dist>=dist_to) {
    save("cornucopia_doodle"+year()+""+month()+""+day()+""+hour()+""+minute()+""+second()+".png");
    background(0, 0, 0);
    restart();
  }
  if (frameCount%50==0 || (dist_to-dist)<100) {
    println("Left: "+(dist_to-dist));
    if (frameCount%50==0) System.gc();
  }
}

void keyPressed() {
    //background(0, 0, 0);
}