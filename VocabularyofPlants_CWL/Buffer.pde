//interface for events
interface EventListener {
  public void eventReceived(int eventType, float amplitude, float stddev, float mean);
}

public class Buffer{
  static final public int FAST_RISE = 0;
  static final public int FAST_DROP = 1;
  static final public int SLOW_RISE = 2;
  static final public int SLOW_DROP = 3;
  
  //static final private float SIGNAL_THRESHOLD = 0.08;
  
  // if there is no reaction, we need to play with this number
  static final private float SIGNAL_THRESHOLD = 0.0002;
  
  private ArrayList<Float> buffer = new ArrayList<Float>();
  
  private int size, bufferId, addIndex, eventStart, eventStop, eventDirection, eventType, eventAddIndex;
  private float mean, prevMean, variance, stddev, eventMin, eventMax, eventDuration, eventAmplitude, eventMeanSum, eventStddevSum, eventMean, eventStddev;
  private boolean isEventHappening;
  
  List<EventListener> listeners = new ArrayList<EventListener>();
  
  Buffer(int _size, int id) {
    size = _size;
    bufferId = id;
    isEventHappening = false;
    init();
  }
  
  private void init() {
    addIndex = 0;
    buffer.clear();
    for(int i = 0; i < size; i++) {
      buffer.add(0.0);
    }
  }
  
  public void addToBuffer(float val) {
    //println(val);
    buffer.remove(size - 1);           //REMOVE LAST ELEMENT
    Collections.reverse(buffer);        //reverse order
    buffer.add(val);                    //add new value to back
    Collections.reverse(buffer);        //reverse order to original
    
    setMean();
    setVariance();
    setStddev();
    
    if(addIndex < size){
      addIndex++;
    } else {
      checkForEvent();
    }
  }
  
  private void checkForEvent(){
    //println("checking for event");
    if(isEventHappening){
      if(mean > eventMax) eventMax = mean; //get the largest value during event
      if(mean < eventMin) eventMin = mean; //get the smallest value during event
      eventAddIndex++;
      eventMeanSum += mean;
      eventStddevSum += stddev;
    }
    
    println(stddev);
    //println(mean);
    //println(variance);
    //println(SIGNAL_THRESHOLD);
    //println("---------------------------");
    if (abs(stddev) > SIGNAL_THRESHOLD && !isEventHappening){ 
      println("event start");
      isEventHappening = true;
      eventAddIndex = 0;
      eventMeanSum = 0;
      eventStddevSum = 0;
      eventStart = millis();
      eventMin = mean;
      eventMax = mean;
      if(mean - prevMean > 0) eventDirection = 2;
      if(mean - prevMean == 0) eventDirection = 1;
      if(mean - prevMean < 0) eventDirection = 0;
    } else if(isEventHappening && abs(stddev) < SIGNAL_THRESHOLD) {
      println("event stop");
      isEventHappening = false;
      eventStop = millis();
      
      eventDuration = (eventStop - eventStart)/1000.0f;
      eventAmplitude = eventMax - eventMin;
      eventType = getEventType(eventDuration, eventDirection);   
      eventMean = eventMeanSum / eventAddIndex;
      eventStddev = eventStddevSum / eventAddIndex;
      
      for (EventListener el : listeners){
        el.eventReceived(eventType, eventAmplitude, eventStddev, eventMean);
      }
    }
  }
  
  public int getEventType(float duration, int direction){
    int type = -1;
    if(duration < 60.0f && direction == 2) type = FAST_RISE;
    if(duration < 60.0f && direction == 0) type = FAST_DROP;
    if(duration >= 60.0f && direction == 2) type = SLOW_RISE;
    if(duration >= 60.0f && direction == 0) type = SLOW_DROP;
    return type;
  }
  
  public void addEventListener(EventListener toAdd) {
    listeners.add(toAdd);
  }
  
  private void setMean() {
    float sum = 0.0f;
    
    for(float val : buffer) {
      sum += val;
    }
    
    prevMean = mean;
    mean = sum / buffer.size();
  }
  
  public float getMean() {
    return mean;
  }
  
  private void setVariance() {
    float sum = 0.0f;
    
    for(float val : buffer) {
      //println(val);
      sum += ((val - mean) * (val - mean));
    }
    //println("========");
    //println(buffer.size());
    //println(sum);
    //println("========");
    variance = sum / (buffer.size() - 1);
  }
  
  public float getVariance() {
    return variance;
  }
  
  private void setStddev() {
    stddev = sqrt(variance);
  }
  
  public float getStddev() {
    return stddev;
  }
  
  public void drawBuffer() {
    float xInc = width / buffer.size();
//    beginDraw();
    background(0,0,0,0);
    pushMatrix();
    translate(0, height/2);
    stroke(255);
    noFill();
    beginShape();
    for(int i = 0; i < buffer.size(); i++) {
      float x = i * xInc;
      float y = map(buffer.get(i), -0.02, 0.02, height, -height);
      vertex(x,y);
    }
    endShape();
    popMatrix();
  }
  
  public void printBuffer() {
    for(int i = 0; i < buffer.size(); i++) {
      float f = (Float)buffer.get(i);
      print(f);
      print(", ");
    }
    println();
  }
}
