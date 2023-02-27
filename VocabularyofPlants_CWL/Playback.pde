import java.util.*;

public class Playback extends Thread {
  
  private boolean isRunning;
  private Table table;
  private int rowIndex;
  private long currTime;
  private int currTopic;
  private float currVal;
  private long fileStartTime;
  private int startTime;
  private String[] mqttAddress = {""};
  
  List<DataListener> listeners = new ArrayList<DataListener>();
  
  Playback(String filePath) {
    isRunning  = false;
    rowIndex = 0;
    currTime = 0;
    currTopic = 0;
    currVal = 0;
    
    table = loadTable(filePath, "csv");  
    String strVal = table.getString(0,0);        //get the first time value
    fileStartTime = Long.parseLong(strVal);
  }
  
  public void setMqttAddress(String[] _mqttAddress) {
      mqttAddress = _mqttAddress;
  }
  
  public void start() {
    isRunning = true;
    println("starting thread....");
    startTime = millis();
    super.start();
  }
  
  public void run() {
    while(true) {
      if(isRunning){
        execute();
      } else {
        break;
      }
    }
  }
  
  public void execute() {
    String strVal = table.getString(rowIndex, 0);
    currTime = Long.parseLong(strVal);

    if((long)(millis() - startTime) >= currTime - fileStartTime){
      String currAddress = table.getString(rowIndex, 3);
      
      for(int i = 0; i < mqttAddress.length; i++) {
        if(currAddress.equals(mqttAddress[i]) == true) {
          currTopic = i;
          break;
        }
      }
      
      currVal = table.getFloat(rowIndex, 4);
      rowIndex++;
      rowIndex%=table.getRowCount();
      
      for (DataListener pl : listeners){
        pl.dataReceived();
      }
    }
  }
  
  public void quit(){
    isRunning = false;
    interrupt(); 
  }
  
  public void addListener(DataListener toAdd) {
        listeners.add(toAdd);
  }
  
  public long getTime(){
    return currTime - fileStartTime;
  }
  
  public float getVal(){
    return currVal;
  }
  
  public int getTopic(){
    return currTopic;
  }
}
