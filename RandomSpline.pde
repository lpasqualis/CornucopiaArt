class RandomSpline {
  int m_min;
  int m_max;
  int m_numberOfKnots;
  PVector[] m_knots;
  float m_length;
  PVector m_tr;

  RandomSpline() {
    m_min            = -100;
    m_max            =  240;
    m_numberOfKnots  =  12;
    reset();    
  }
  
  void reset() {
    m_knots  = null;
    m_length = random(600,900)*15;
    m_tr=new PVector(random(-1000,1000),random(-1000,1000),random(-1000,1000));
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
    PVector r = new PVector(from.x+(noise(from.x/100+m_tr.x,from.y/100+m_tr.y)-0.5)*length,
                            from.y+(noise(from.x/100+1000+m_tr.x,from.y/100+1000+m_tr.y)-0.5)*length,
                            from.z+(noise(from.x/100+2000+m_tr.z,from.y/100+2000+m_tr.z)-0.8)*length);
    return r;
  }

}