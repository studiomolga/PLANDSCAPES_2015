public class pathfinder {
  PVector location;
  PVector velocity;
  float diameter;

  pathfinder(PVector _location) {
    location = _location;
    velocity = new PVector(0, -1);
    diameter = 1.5;
  }

  pathfinder(pathfinder parent) {
    location = parent.location.get();
    velocity = parent.velocity.get();
    float area = PI*sq(parent.diameter/2);
    float newDiam = sqrt(area/2/PI)*2;
    diameter = newDiam;

    diameter = newDiam < 0 ? 0 : newDiam;
    parent.diameter = newDiam < 0 ? 0 : newDiam;
  }

  public void update() {
    if (diameter>0.05) {
      location.add(velocity);
      PVector bump = new PVector(random(-1, 1), random(-1, 1));
      bump.mult(0.3);
      velocity.add(bump);
      velocity.normalize();
      if (random(0, 1) < 0.05) {
        paths = (pathfinder[]) append(paths, new pathfinder(this));
      }
    } else {
      diameter = 0;
    }
  }
}
