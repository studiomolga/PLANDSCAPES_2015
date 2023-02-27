class Trunk {
  float x;
  float y;
  float lastxadjust;
  float lastyadjust;
  float size;
  float difRadius = random(-1, 1);  // the difference in the radius of each subsequent ellipse which make the whole branch, smaller the number, there is more ellipses - branch is longer
  boolean dead;
  float branchLength;
  float stopSize;
  int nVer;
  boolean drawrings = false;
  boolean stopDrawRings = false; 

  Blob myBlob;

  Trunk(int _nVer, float x, float y, float size, float stopSize, float _branchLength) {
    this.x = x;
    this.y = y;
    dead = false;
    this.size = size;
    this.stopSize = stopSize;
    nVer = _nVer;

    lastxadjust = random( -0.03, 0.03);  // X coordinates of how the branch will grow (where it bends, change direction etc)
    lastyadjust =  random( -0.4, 0.0);   // Y coordinates of how the branch will grow (where it bends, change direction etc)
    branchLength = _branchLength;
    myBlob = new Blob(nVer, int(size), int(x), int(y));
  }

  void grow() {
    if (!dead) {

      float lowerbound = lastxadjust - 0.1;  // based on the lastxadjust - the lower and upper bounds are values of differences in x variations of the next ellipse
      float upperbound = lastxadjust + 0.1;  // it takes each subsequent new x and y and adds or substract 0.1 - making gap bigger. 
      //                So if value is i.e. 2 - the gap between ellipses gets bigger and the branch grows faster (but it stops looking like a branch but a like of circles further away from each other)

      float xadjuster = random(lowerbound, upperbound);  // the variations in the x position of subsequent ellipses

      lowerbound = lastyadjust - 0.1;        // based on the lastxadjust - the lower and upper bounds are values of differences in y variations of the next ellipse
      upperbound = lastyadjust + 0.1;         // it takes each subsequent new x and y and adds or substract 0.1 - making gap bigger. 
      //                So if value is i.e. 2 - the gap between ellipses gets bigger and the branch grows faster (but it stops looking like a branch but a like of circles further away from each other)

      float yadjuster =  random(lowerbound, upperbound);   // the variations in the y position of subsequent ellipses

      lastxadjust = xadjuster;
      lastyadjust = yadjuster;

      this.x = this.x + xadjuster;
      this.y = this.y + yadjuster;

      if (this.size > stopSize) {
        this.size = this.size + branchLength* -1 ;//random(0.008, 0.03); // VARIABLE
      } else {
        dead = true;
      }
    }
  }

  void display() {
    if (!dead) {
      noStroke();

      myBlob.display(size*0.01+(random(0.01)), 0, (float) x-1, (float) y);
      myBlob.display(size*0.01, 255, (float) x, (float) y);
    }
  }

  boolean maintrunkstop () {
    if (this.size < maintrunkstopsize) {
      drawrings = true;
    }
    return drawrings;
  }

  void rings() {
    if (drawrings) {
      myBlob.displayRings(size*0.01, (float) x, (float) y);
//      println(size);
    }
  }
}
