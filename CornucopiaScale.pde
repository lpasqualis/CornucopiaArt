
class CornucopiaScale implements ContourScale {
  
  // t in range 0.0 to 1.0 inclusive
  public float scale(float t) {
    return exp(-t*3)/2+0.1;
  }
}