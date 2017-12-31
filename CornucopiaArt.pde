/*
 * CornucopiaArt
 * Author: Lorenzo Pasqualis
 */

import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;

////////////////////////////////////////////////////////////////////////
// Main Settings
//

final int    size_w       = 4000;                  // Width of the image
final int    size_h       = 4000;                  // Height of the image
final int    image_count  = 3;                     // How many images to generate. image_count>0
final float  scale        = 2;                     // Scale of the image
final String textureFile  = "textures/water.jpg";  // null or a JPG/PNG filename for the texture
                                                   // to be used to texture the cornucopias.
final int texture_rep_ns = 2;                      // Repetition of the texture North to South
final int texture_rep_ew = 3;                      // Repetition of the texture East to West

////////////////////////////////////////////////////////////////////////
// Spine

final int   knots_start   = -100;
final int   knots_end     = 240;
final int   knots_count   = 20;
final float length_from   = 600;   // Minimum length of a cornucopia (~0-1000);
final float length_to     = 900;   // Maximum length of a cornucopia (~m_length_from-2000);
final float length_mul    = 30;    // Length of a Cornucopia (~~0-50). Larger values for long cornucopias.
// Nots on Orientation. 
// These parameters regulate the percentage of the orientation  of the random splines. 
// They are percentages. For example:
// - 0.5 is 50% is balanced.
// - 0% is 100% in one direction. 
// - 1 is 100% in the other.
final float orientation_x = 0.5;
final float orientation_y = 0.5;
final float orientation_z = 0.8;

////////////////////////////////////////////////////////////////////////
// Spiral
//
// The spiral forming a cornucopia is defined by a radius and by the angle of start and end
// of the spiral, from the center. The following parameters govern the random generation of
// Those values. // Corucopias start with the head, and end with a tail.

final float tail_radius_min           = 2;
final float tails_radius_max          = 15;
final float head_radius_min           = 20;
final float head_radius_max           = 100;
final float angle_start               = 0; 
final float angle_end_min             = 200;
final float angle_end_max             = 800;
final int spiral_segments             = 80;  // How many segments form a spiral. More is moother around the perimeter.
final int cornucopia_sections         = 200; // How many sections form a cornucopia (more is smoother from head to tail)
final float spiral_thickness          = 6;   // Thickness of the material forming the spiral.

//
// Space
//
// The observer is a distance 0. Cornucopia are generated from dist_from to dist_to (negative numbers).
// Generation starts at dist_from and is continues to dist_to, incrementing the positioon by increment_z
// for each cornucopia, and incrementing increment_z by inc_the_inc for each cornucopia.
// This mostly ensures drawing back to front, and prints fewer corncucopia in the front and more in the back.

final float space_depth_max = -8000;    // Negative number deciding how far the cornucopias start in space
final float space_depth_min = -300;     // Negative number deciding how close the cornucopias get to the observer
final float dist_deep_space = 0.5;      // How much to increment Z for each cornucopia drawn
final float dist_increment  = 0.03;     // Hop much to increment increment_z for each cornucopia drawn

////////////////////////////////////////////////////////////////////////
// Globals

ContourScale conScale;

float dist_from;
float dist_to;
float dist;
float mult;
float increment_z;
float inc_the_inc;
float curr_image=image_count;

////////////////////////////////////////////////////////////////////////
// Initialization
//

void settings() {
  size(size_w, size_h, P3D);
  mult=(size_w/600)/scale;
}

public void setup() {
  conScale   = new CornucopiaScale();   // Scaler
  restart();
  background(0, 0, 0);
  smooth(8);  
}

void restart() {
  dist_from    = space_depth_max;                   
  dist_to      = space_depth_min;                    
  increment_z  = dist_deep_space;                   
  inc_the_inc  = dist_increment;                    
  
  dist=dist_from;
}

////////////////////////////////////////////////////////////////////////
// Lighting and colors
//

color getCornucopiaColor() {
  return color(0,0,255);
}

color getSegmentColor() {
  return color(0,0,0,40);
}

void lighting()
{
  lights();
  ambientLight(0, 0, 0);
  //directionalLight(0, 0, 255, 0, 1, -1);
  pointLight(0,0,255,0,0,-1000);
  //lightFalloff(0, 1, 10);
  //lightSpecular(0, 0, 0);   
}

void metal() {
  lightSpecular(0, 0, 255);
  specular(0, 0, 255);
  emissive(0,0,0);
  shininess(255);
}

////////////////////////////////////////////////////////////////////////
// Drawing
//

public void draw() {
  scale(scale);
  colorMode(HSB, 255);

  color c  = getCornucopiaColor();
  color cs = getSegmentColor();

  dist          += increment_z;
  increment_z   += inc_the_inc;
  
  float z = dist; 
  float d = (abs(z)/1.8)*mult;

  translate(random(-d,width+d),random(-d,height+d),z);
  
  lighting();
  //metal();

  Contour contour = new Spiral(random(tail_radius_min*mult,tails_radius_max*mult),
                               random(head_radius_min*mult,head_radius_max*mult),
                               radians(angle_start), 
                               radians(random(angle_end_min,angle_end_max)),
                               spiral_segments,
                               spiral_thickness);

  RandomSpline randSpline = new RandomSpline(knots_start, knots_end, knots_count,
                                             length_from, length_to, length_mul,
                                             orientation_x, orientation_y, orientation_z);
  
  Extrusion    e          = new Extrusion(this, randSpline.path(), cornucopia_sections, contour, conScale);
  
  if (textureFile!=null) {
    e.setTexture(textureFile, texture_rep_ns, texture_rep_ew);
    e.drawMode(S3D.TEXTURE | S3D.WIRE);
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
    e.drawMode(S3D.TEXTURE | S3D.WIRE, S3D.BOTH_CAP);
  } else {
    e.drawMode(S3D.SOLID | S3D.WIRE);
  }
  
  // Draw the Cornucopia
  try {  
    e.draw();
  } 
  catch (Exception ex) {
    println("Error drawing frame #"+frameCount+": "+ex.getMessage());
    emptyMatrixStack(); // Hack to circumvent Shape3D bug with not popping the matrix when an exception is raised
  }

  //  
  // Print status to the console every 50 frames, or when we are around the end of the run
  //
  if (frameCount%50==0 || (dist_to-dist-image_count+1)<100) {
    println("Working on image "+(int)(image_count-curr_image+1)+"/"+image_count+
            " - Left: "+(int)(dist_to-dist)+"/"+(int)abs(space_depth_max-space_depth_min)+
            " [inc="+increment_z+"] [fps="+frameRate+"]");
  }

  //
  // Save the image and restart, if more images are needed.
  // 
  if (dist>=dist_to) {
    String fname="cornucopia-"+
               year()+""+nf(month(),2)+""+nf(day(),2)+"-"+
               nf(hour(),2)+""+nf(minute(),2)+""+nf(second(),2)+
               ".png";
    println("Saving image "+(int)(image_count-curr_image+1)+": "+fname);
    save(fname);
    println("Done saving.");
    curr_image--;
    if (curr_image<=0) {
      println("Finished.");
      exit();
    }
    background(0, 0, 0);
    restart();
  }
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Hack to work around Shape3D bugs that cause the matrix stack to fill up when an exception is thrown
//
void emptyMatrixStack() {
    boolean popDone=false;
    while(!popDone) {
      try { 
        popMatrix();
      } catch (Exception e) {
        popDone=true;
      }
    }
}