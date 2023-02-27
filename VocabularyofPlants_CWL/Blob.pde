class Blob {

  int [] x;
  int [] y;
  float radius;
  int centerX, centerY;

  float angle = 0;

  float noiseSample = random(0, 100);  // Perlin noise index
  float noiseInc = .09;    // Perlin noise inc
  float maxRadiusDev = .5; // max radius deviation in percent
  float radFactor; // WHAT IS THAT? 
  float zRad; // WHAT IS THAT? - it closing and opening circle....

  int alpha;
  float curveAngle = 0.01;

  IntList pxList;
  IntList pyList;
  IntList psizeList;
  float d;
  boolean stopRingDraw = false;

  Ring[] myRing;

  Blob(int numVertex, float rad, int cX, int cY) {

    radius = rad;
    centerX = cX;
    centerY = cY;

    myRing = new Ring[numVertex];
    x = new int[numVertex];
    y = new int[numVertex];

    pxList = new IntList();
    pyList = new IntList();


    float deltaAngle = TWO_PI / numVertex;

    radFactor = 1 + maxRadiusDev * (1 - 2 * noise(noiseSample));
    x[0] = centerX + (int) (radFactor* radius * cos(angle));
    y[0] = centerY + (int) ( radFactor*radius * sin(angle));

    zRad = radFactor * radius;
    angle += deltaAngle;
    noiseSample += noiseInc;


    int i;

    for (i=1; i<(int) (.9 * numVertex); i++) {
      radFactor = 1 + maxRadiusDev * (1 - 2 * noise(noiseSample));
      x[i] = centerX + (int) (radFactor* radius * cos(angle));
      y[i] = centerY + (int) ( radFactor*radius * sin(angle));
      angle += deltaAngle;
      noiseSample += noiseInc;
    }


    int startI = i;
    int remInterval = numVertex - i;
    float rx = x[i-1] - centerX;
    float ry = y[i-1] - centerY;
    float lastRad = sqrt(rx * rx + ry * ry);
    float deltaRad = zRad - lastRad;



    for (; i<numVertex; i++) {
      float frac = (i-startI + 1) * deltaRad / remInterval;
      x[i] = centerX + (int) ((lastRad + (i-startI + 1) * deltaRad / remInterval) * cos(angle));
      y[i] = centerY + (int) ((lastRad + (i-startI + 1) * deltaRad / remInterval) * sin(angle));
      angle += deltaAngle;

    }


    float deg = (360/numVertex);

    for (int j=0; j<myRing.length; j++) {
      
     
      angle += radians(deg);
      myRing[j] = new Ring(x[j]+cos(angle), y[j]+sin(angle), 1, curveAngle/*, ringdistance*/);
    
    
  }
  }


  void display( float scaling, float c, float cx, float cy) {

    fill (c, 255);
//noFill();
//    stroke(c, 255);
//    noStroke();
    pushMatrix();

    translate(cx-cx*scaling, cy-cy*scaling);

    scale(scaling);
    beginShape();
    for (int i=0; i<x.length; i++) {
      //       myRing[i].waves();
      curveVertex(x[i], y[i]);
    }

    endShape(CLOSE);
    noStroke();
    popMatrix();
  }



  float displayRings(float scaling, float cx, float cy) {


    pushMatrix();
    translate(cx-cx*scaling, cy-cy*scaling);

    scale(scaling);

    beginShape();
    strokeWeight(0.7);

    curveVertex(myRing[0].x, myRing[0].y);


    for (int i=0; i<myRing.length; i++) {
     
      myRing[i].waves();
      curveVertex(myRing[i].x-1, myRing[i].y-1);
 
      noFill();
    }
    curveVertex(myRing[x.length-1].x, myRing[y.length-1].y);
     d = dist(centerX, centerY, myRing[12].x, myRing[12].y);
   
    endShape(CLOSE);
    popMatrix();
  
    return d;
  }
}
