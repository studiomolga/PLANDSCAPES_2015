//import processing.serial.*;
//import cc.arduino.*;

import java.util.Vector;
import processing.pdf.*;

////Arduino arduino;
//boolean areLedsOn = false;
//boolean turnOnLed = false;
//int ledStartTime = 0;

PGraphics screen1;

static final private int DRAW_TIME = 60000;                  //this the time in milliseconds that we will draw to the pdf file

/** USAGE OF DAQ CLASS **/

static final private boolean DAQ_PLAY_FILE = false;                                        //select whether we are playing a file or connecting to a broker
static final private String[] TOPIC_ARRAY = {
  "/plant/1/probe/0"
};      //put here all the individual topics you want to subscribe to
static final private int BUFFER_SIZE = 10;

static final private int EVENT_LIMIT = 30;

boolean isPlaying = false;

DAQ daq;
Buffer buffer;

PApplet app;
Circles myCircles;
pathfinder[] paths;

float[] smallCircleRadiuses;
float[] smallCircleAngels;

float newStartSize;

float mainX = 360;
float mainY = 700;
float mainRadius = 150; 

float sidePx;
float sidePy;

float [] siderad;

float growth = 0.3;
boolean makerings = false;

float maintrunkstopsize; 

Trunk mainTrunk;
Trunk[] trunks/* = new Trunk[11]*/;

boolean isDrawing = false;
boolean setBackground = false;
int drawTime = 400;
int eventTime = 400;

ArrayList<Event> events = new ArrayList<Event>();

// WHEN THERE IS NEW DATA THIS CLASS IS CALLED
class Responder implements DataListener {
  @Override
    public void dataReceived() {
    buffer.addToBuffer(daq.getValue());
        //print("mean: ");
        //println(buffer.getMean());
        //print("std dev: ");
        //println(buffer.getStddev());
        //print(daq.getValue());
        //print(", ");
        //print(TOPIC_ARRAY[(int)daq.getTopic()]);
        //println();
  }
}

class EventResponder implements EventListener {
  @Override
    public void eventReceived(int eventType, float amplitude, float stddev, float mean) {
    
    if(!isDrawing){
      Event event = new Event(eventType, amplitude, stddev, mean);
      events.add(event);
      
      
  
  //    beginRecord(PDF, "test.pdf");
  
      setupEvents();
      isDrawing = true;
      setBackground = true;
//      areLedsOn = true;
//      turnOnLed = true;
    }

    //println("received event!");
  }
}

class Event {
  static final public int FAST_RISE = 0;
  static final public int FAST_DROP = 1;
  static final public int SLOW_RISE = 2;
  static final public int SLOW_DROP = 3;

  public int type;
  public float amplitude, stddev, mean;
  Event(int eventType, float amplitude, float stddev, float mean) {
    type = eventType;
    this.amplitude = amplitude;
    this.stddev = stddev;
    this.mean = mean;
  }
}

void setup() {
  size(768, 1024);
  background (255);
  
  smooth(4);
  
//  screen1 = createGraphics(displayWidth, displayHeight);

//  arduino = new Arduino(this, Arduino.list()[0], 57600);
//  arduino.pinMode(11, Arduino.OUTPUT);
//  arduino.digitalWrite(11, Arduino.LOW);

  buffer = new Buffer(BUFFER_SIZE, 0);
  EventResponder eventResponder = new EventResponder();
  buffer.addEventListener(eventResponder);

  if (!DAQ_PLAY_FILE) {
    //-----------------connect to a broker
    String brokerAddress = "tcp://192.168.1.1:1883";                //we set the address our broker is located, in our case its the ip address of the RPi
    daq = new DAQ(brokerAddress, TOPIC_ARRAY);                      //declare DAQ class with the addres and topics arguments

    Responder responder = new Responder();
    daq.addLivedataListener(responder);
  } else {
    //-----------------use file playback
    String filePath = "data/secondRun.csv";      //set the path of the csv file here
    daq = new DAQ(filePath);

    Responder responder = new Responder();
    daq.addPlaybackListener(responder);

    daq.playfile(); 
    daq.setMqttAddress(TOPIC_ARRAY);
  }
}


int starttime = 0;

void draw() {
  if (setBackground) {
//    beginDraw();
    background(255);
//    endDraw();
    setBackground = false;
    starttime = millis();
//    getFileName();
    beginRecord(PDF, getFileName());
  }

  if (isDrawing) {
    if(millis() - starttime < DRAW_TIME){
      drawEvents();
    } else{
      println("end recording");
      isDrawing = false;
      endRecord();
    }
  } 
}

String getFileName(){
  int year = year();
  int day = day();
  int month = month();
  int hour = hour();
  int minute = minute();
  int second = second();
  
  String filename = str(year) + str(month) + str(day) + str(hour) + str(minute) + str(second) + ".pdf";
  return filename;
}

void setupEvents() {
  if(events.size() > EVENT_LIMIT){
    //println("reached event limit");
    events.remove(0);     
    //println(events.size());
  }
  
  int amount = events.size();
  
  //println(events.size());

  trunks = new Trunk[amount];
  paths = new pathfinder[amount];
  smallCircleRadiuses = new float[amount];
  smallCircleAngels = new float[amount];

  for (int i = 0; i < smallCircleRadiuses.length; i++) {
    Event event = events.get(i);      //so we can use some value in event to set the multiplier with, depending on the event type

    if (event.type == event.FAST_RISE) {
      smallCircleRadiuses[i] = random(40, 185);
      smallCircleAngels[i] = random(1, 360);
    } else if (event.type == event.FAST_DROP) {
      smallCircleRadiuses[i] = random(40, 185);
      smallCircleAngels[i] = random(1, 360);
    } else if (event.type == event.SLOW_RISE) {
      smallCircleRadiuses[i] = random(40, 185);
      smallCircleAngels[i] = random(1, 360);
    } else if (event.type == event.SLOW_DROP) {
      smallCircleRadiuses[i] = random(40, 185);
      smallCircleAngels[i] = random(1, 360);
    }
  }

  myCircles = new Circles (mainX, mainX, mainRadius);
  myCircles.displaySide();
  int index = floor(myCircles.pxList.size());
  println(index);

  newStartSize = myCircles.psizeList.get(index - 1);

  for (int i=0; i<trunks.length; i++)
  {
    Event event = events.get(i);

    if (event.type == event.FAST_RISE) {
      trunks[i] = new Trunk( (int)(random(23, 80)), myCircles.pxList.get(i), myCircles.pyList.get(i), smallCircleRadiuses[i]/2, random(0.1, 5), random(0.15, 0.4));
      paths[i] = new pathfinder(new PVector(myCircles.pxList.get(i), myCircles.pyList.get(i)));
    } else if (event.type == event.FAST_DROP) {
      trunks[i] = new Trunk( (int)(random(23, 80)), myCircles.pxList.get(i), myCircles.pyList.get(i), smallCircleRadiuses[i]/2, random(0.1, 5), random(0.15, 0.4));
      paths[i] = new pathfinder(new PVector(myCircles.pxList.get(i), myCircles.pyList.get(i)));
    } else if (event.type == event.SLOW_RISE) {
      trunks[i] = new Trunk( (int)(random(23, 80)), myCircles.pxList.get(i), myCircles.pyList.get(i), smallCircleRadiuses[i]/2, random(0.1, 5), random(0.15, 0.4));
      paths[i] = new pathfinder(new PVector(myCircles.pxList.get(i), myCircles.pyList.get(i)));
    } else if (event.type == event.SLOW_DROP) {
      trunks[i] = new Trunk( (int)(random(23, 80)), myCircles.pxList.get(i), myCircles.pyList.get(i), smallCircleRadiuses[i]/2, random(0.1, 5), random(0.15, 0.4));
      paths[i] = new pathfinder(new PVector(myCircles.pxList.get(i), myCircles.pyList.get(i)));
    }
  }

  //we could set here maintrunk stuff depending on the amount of events?
  maintrunkstopsize = random(10, 80);
  mainTrunk = new Trunk(40, mainX, mainY, mainRadius, maintrunkstopsize, growth);
}

void drawEvents() {
  growth = random(0, 1);
  for (int i=0; i<paths.length; i++) {
    noStroke();

    
    PVector loc = paths[i].location;
    float diam = paths[i].diameter;
    fill(255, 0, 0, 255);

    ellipse(loc.x, loc.y, diam, diam);
    paths[i].update();
  }
  


  for (int i=0; i<trunks.length; i++) {
    trunks[i].display();
    trunks[i].grow();
  }
  
  mainTrunk.grow();
  mainTrunk.display();
  mainTrunk.maintrunkstop();
  mainTrunk.rings();
  
//        println(trunks.length);
//    println(paths.length);
  
//  if(mainTrunk.dead){
//    deadTrunks++;
//  }
//  
//  if(deadTrunks == trunks.length + 1){
//    println("start delay");
//  }
  
//  println(deadTrunks);
  
//  endDraw();
}

//void triggerLeds() {
//  if (areLedsOn && turnOnLed) {
//    ledStartTime = millis();
//    turnOnLed = false;
//  }
//
//  if (areLedsOn) {
//    arduino.digitalWrite(11, Arduino.HIGH);
//  } else {
//    arduino.digitalWrite(11, Arduino.LOW);
//  }
//  if (millis() - ledStartTime > 2500) areLedsOn = false;
//}


//simulate an event arriving
void keyReleased() {
  if (key == 'a') {
    if(!isDrawing){
      Event event = new Event(round(random(0, 3)), random(0.0003, 0.01), random(0.0003, 0.01), random(0.0003, 0.01));
      events.add(event);
      
  //    beginRecord(PDF, "test.pdf");
  
      setupEvents();
      isDrawing = true;
      setBackground = true;
//      areLedsOn = true;
//      turnOnLed = true;
    }
  }
  
//  if(key == 'b'){
//    endRecord();
//  }
}

//boolean sketchFullScreen() {
//  return true;
//}
