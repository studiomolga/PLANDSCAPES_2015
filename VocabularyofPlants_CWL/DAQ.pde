import com.ibm.mqtt.MqttClient;
import com.ibm.mqtt.MqttSimpleCallback;
import com.ibm.mqtt.MqttException;

// An interface to be implemented by everyone interested in "Hello" events
interface DataListener {
    public void dataReceived();
}

public class DAQ {
  //MQTT Parameters
  private MQTTLib m;
  private String MQTT_BROKER/* ="tcp://192.168.1.3:1883"*/;
  private String CLIENT_ID = "WWL_PLANET";
  private int[] QOS = {1};
  private String[] TOPICS = {"/#"};
  private boolean CLEAN_START = true;
  private short KEEP_ALIVE = 30;
  private boolean IS_DATA_LIVE = false;
  private float currVal = 0;
  private int currTopic = 0;
  
  public Playback playback;
  List<DataListener> listeners = new ArrayList<DataListener>();
  
  private class MessageHandler implements MqttSimpleCallback {
  
    public void connectionLost() throws Exception {
      System.out.println( "Connection has been lost." );
      setup_broker();
    }
  
    public void publishArrived( String topicName, byte[] payload, int QoS, boolean retained ) {
      //Extract the value
      for(int i = 0; i < TOPICS.length; i++) {
        if (topicName.equals(TOPICS[i])) {
          currVal = float(new String(payload));
          currTopic = i;
          for (DataListener pl : listeners){
            pl.dataReceived();
          }
          break;
        }
      }
    }
  }
  
  //constructor - live data
  DAQ(String _MQTT_BROKER, String[] _TOPICS){
    IS_DATA_LIVE = true;
    MQTT_BROKER = _MQTT_BROKER;
    TOPICS = _TOPICS;
    QOS = new int[TOPICS.length];
    for(int i = 0; i < QOS.length; i++) {
      QOS[i] = 1;
    }
    setup_broker();
  } 
  
  //constructor - file playback
  DAQ(String filepath){
    IS_DATA_LIVE = false;
    playback = new Playback(filepath);
  }
  
  public void setMqttAddress(String[] mqttAddress) {
      playback.setMqttAddress(mqttAddress);
  }
  
  private void setup_broker(){
    // set up broker connection
    m = new MQTTLib(MQTT_BROKER, new MessageHandler());
    m.connect(CLIENT_ID, CLEAN_START, KEEP_ALIVE);
    m.subscribe(TOPICS, QOS);
    System.out.println("broker setup");
  } 
  
  public void playfile(){
    playback.start();
  }
  
  public void stopfile(){
    playback.quit();
  }
  
  public float getValue(){
    if(IS_DATA_LIVE) {
      return currVal;
    } else {
      return playback.getVal();
    }
  }
  
  public float getTopic() {
    if(IS_DATA_LIVE) {
      return currTopic;
    } else {
      return playback.getTopic();
    }
  }
  
  public void addPlaybackListener(Responder responder){
    playback.addListener(responder);
  }
  
  public void addLivedataListener(DataListener toAdd){
    listeners.add(toAdd);
  }
}


public class MQTTLib {
  private MqttSimpleCallback callback;
  private MqttClient client = null;

  MQTTLib(String broker, MqttSimpleCallback p) {
    callback = p;
    try {
      client = (MqttClient) MqttClient.createMqttClient(broker, null);
      //class to call on disconnect or data received
      client.registerSimpleHandler(callback);
      //System.out.println("registered handler");
    } 
    catch (MqttException e) {
      System.out.println( e.getMessage() );
    }
  }

  public boolean connect(String client_id, boolean clean_start, short keep_alive) {
    try {
      //connect - clean_start=true drops all subscriptions, keep-alive is the heart-beat
      client.connect(client_id, clean_start, keep_alive);
      //subscribe to TOPIC
      return true;
    } 
    catch (MqttException e) {
      System.out.println( e.getMessage() );
      return false;
    }
  }

  public boolean subscribe(String[] topics, int[] qos ) {
    try {
      //subscribe to TOPIC
      client.subscribe(topics, qos);
      return true;
    } 
    catch (MqttException e) {
      System.out.println( e.getMessage() );
      return false;
    }
  }
}
