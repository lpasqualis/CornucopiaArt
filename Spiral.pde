class Spiral extends Contour {
  
  float thickness=6;
  
  public Spiral(float small_r, float large_r, 
                float theta1, float theta2,  
                int points_n) {

    PVector[] points1 = spiralPoints(small_r, large_r, theta1, theta2, points_n);
    PVector[] points2 = spiralPoints(small_r-thickness, large_r-thickness, theta1, theta2, points_n);

    for(int i = 0; i < points2.length / 2; i++)
    {
        PVector temp = points2[i];
        points2[i] = points2[points2.length - i - 1];
        points2[points2.length - i - 1] = temp;
    }
    
    PVector[] fin = new PVector[points_n*2];
    

    System.arraycopy(points1, 0, fin, 0, points1.length);
    System.arraycopy(points2, 0, fin, points1.length, points2.length);

    contour=fin;    
    for (PVector c : contour) c.mult(2);
  }
  
  PVector[] spiralPoints(float r1, float r2, float theta1, float theta2, int points_n) {
    PVector[] points = new PVector[points_n];
    float theta      = theta1;
    int   idx        = 0;
    float theta_inc  = (theta2-theta1)/points_n;
    float radius_inc = (r2-r1)/points_n;

    for (float r=r1; r<r2; r+=radius_inc) {
      if (idx>=points_n) break;
      points[idx] = new PVector();
      points[idx].x = r * cos(theta);
      points[idx].y = r * sin(theta);
      theta += theta_inc;
      idx++;
    }
    return points;
  }

}