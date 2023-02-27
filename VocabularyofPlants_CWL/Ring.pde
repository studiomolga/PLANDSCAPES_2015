class Ring {
  float x, y;
  float ar = random(-20, 20); // angles of the wave VARIABLE
  float angle;

  int alpha = 20;
  boolean alphastop = false;

  Ring(float xpos, float ypos, float angledeRotation, float _angle) {
    x  = xpos;
    y  = ypos;
    ar  = angledeRotation;
    angle = _angle;
  }

  void waves() {

    if (alpha < 230) {
      alpha+=1;
      stroke (0, alpha); // I kind of like random (0, 255) for grey rings BUT it looks beautiful at the beginning but then when it gets narrower it doesnt

      ar+= random(angle);  // slight offsetting // VARIABLE 
      x += cos(ar)*(random(1))+((width/2 - x) * 0.01); // 0.01 - VARIABLE
      y += sin(ar)*(random(1))+((height/2 - y) * 0.01); // 0.01 - VARIABLE
      alphastop=false;
    }
  }
}
