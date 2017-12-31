/*
 * CornucopiaScale
 * Author: Lorenzo Pasqualis
 */

//
// Determines the diameter of the cornucopia along its length. 
//
class CornucopiaScale implements ContourScale {
  
  //
  // t in range 0.0 to 1.0 inclusive. 
  // t is the head, and 0 is the tail.
  //
  public float scale(float t) {
    return exp(-t*3)/2+0.1;
  }
}