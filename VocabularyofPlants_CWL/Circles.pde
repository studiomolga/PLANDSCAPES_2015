class Circles {

  float mCx, mCy;
  float px, py;
  float radius;


  FloatList pxList;
  FloatList pyList;
  FloatList psizeList;
  FloatList trunkSizeList;
  
//  float[] smallCircleRadiuses = {
//  random(40, 55), random(90, 155), random(100, 105), random(70, 145), random(90, 125), random(80, 185), random(90, 145), random(106, 185), random(60, 95), random(60, 95), random(60, 95)
//  };
//
//  float[] smallCircleAngels = {
//  random(1, 360), random(1, 360), random(1, 360), random(1, 360), random(1, 360), random(1, 360), random(1, 100), random(1, 120), random(1, 160), random(1, 120), random(1, 160)
//  };
  

  Circles (float _mCx, float _mCy, float _radius) {

    mCx = _mCx;
    mCy = _mCy;
    radius = _radius;


    pxList = new FloatList();
    pyList = new FloatList();
    psizeList = new FloatList();
  }


  float[] angle (float[] angles) { 
    return angles;
  }    

  float[] sideradius(float[] sideradiuses) { 
    return sideradiuses;
  }    

  void display() {
    noStroke();
    fill(255, 0);
    ellipse(mCx, mCy, radius*2, radius*2);
  }


  void displaySide() {   
//    float[] a = smallCircleAngels; 
//    float[] r = smallCircleRadiuses; 



    for (int i = 0; i < smallCircleAngels.length; i++) { 
      px = mCx+cos(radians(smallCircleAngels[i]))*(radius);
      py = mCy+sin(radians(smallCircleAngels[i]))*(radius);
//      fill(255, 0);
//      ellipse(px, py, r[i], r[i]);
      //println(px);
      //println(py);
      //println(smallCircleRadiuses);
      pxList.append(px);
      pyList.append(py);
      psizeList.append(smallCircleRadiuses);
    }
  }
}
