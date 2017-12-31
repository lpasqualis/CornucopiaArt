/*
 * RandomSpline
 * Author: Lorenzo Pasqualis
 */

class RandomSpline {
  int       m_min;
  int       m_max;
  int       m_numberOfKnots;
  PVector[] m_knots;
  float     m_length;
  PVector   m_tr;
  float     m_length_from;
  float     m_length_to;
  float     m_length_multiplier;
  float     m_orientation_x;
  float     m_orientation_y;
  float     m_orientation_z;

  //
  // Main Spline Settings
  //
  RandomSpline(int knots_start,        // Points from (Z dimension)
               int knots_end,          // Points to (Z dimension)
               int knots_count,        // How many points
               float length_from,      // Minimum length of the spline (~0-1000);
               float length_to,        // Maximum length of the spline (~m_length_from-2000);
               float length_mul,       // Length of the spline (~~0-50). Larger values for long splines.
               float orientation_x,    // From 0 to 1
               float orientation_y,    // From 0 to 1
               float orientation_z)    // From 0 to 1
               
  {
    m_min               = knots_start;
    m_max               = knots_end;
    m_numberOfKnots     = knots_count;

    //
    // Length
    //
    m_length_multiplier = length_mul;   
    m_length_from       = length_from;  
    m_length_to         = length_to;  
    
    m_orientation_x     = orientation_x;   
    m_orientation_y     = orientation_y;
    m_orientation_z     = orientation_z;     
    reset();    
  }
  
  void reset() {
    m_knots  = null;
    m_length = random(m_length_from,m_length_to)*m_length_multiplier;
    
    // Choose the area of noise to use for randomization of the spline
    m_tr     = new PVector(random(-1000,1000),random(-1000,1000),random(-1000,1000));
  }

  PVector[] knots() {
    if (m_knots==null) {
      m_knots = new PVector[m_numberOfKnots];
      m_knots[0] = new PVector(0,0,0);
      PVector nv;
      for (int k=1; k<m_numberOfKnots; k++) {
        m_knots[k]=getOne(m_knots[k-1]);
      }
    }
    return m_knots;
  }

  P_BezierSpline path() {
    return new P_BezierSpline(knots());
  }
  
  PVector getOne() {
    return new PVector(random(m_min,m_max), random(m_min,m_max), random(m_min,m_max));
  }

  PVector getOne(PVector from) {
    float length=m_length/m_numberOfKnots;
    PVector r = new PVector(from.x+(noise(from.x/100+m_tr.x,from.y/100+m_tr.y)-m_orientation_x)*length,
                            from.y+(noise(from.x/100+1000+m_tr.x,from.y/100+1000+m_tr.y)-m_orientation_y)*length,
                            from.z+(noise(from.x/100+2000+m_tr.z,from.y/100+2000+m_tr.z)-m_orientation_z)*length);
    return r;
  }

}