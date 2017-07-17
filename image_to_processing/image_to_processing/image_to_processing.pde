import processing.serial.*;

int     Serial_SPEED=9600;
Serial  inPort = null;
Serial  outPort = null;
boolean done = false;
String s;
String readVal = "";
String newVal = "";
uint16_t rawValues[500];

// Wait for line from serial port, with timeout
String readLine(Serial port) {
  int    start = millis();
  do {
    s = port.readStringUntil('\n');
  } while ( (s == null) && ((millis() - start) < 3000));
  return s;
}



void setup() {
  size(200, 200); // Dummy window for Serial
  inPort = findPort();
}

void draw() {
  
  if (inPort.available() > 0) {
    newVal = inPort.readStringUntil('\n');
    if (newVal != null) {
      readVal = newVal;
    }
    println(readVal);
  }
  
  if (readVal.contains("9")) {
    println("Ready for data...");
    inPort.write("Ready for data\n");
    while(inPort.read() != -1){
      println(inPort.read()); 
    }
    delay(10000);
  }   
  
}




//Look for an available port
Serial findPort() {
  Serial port = null;
  
  // Look for an active serial port
  println("Scanning serial ports...");
  for (String portname : Serial.list ()) {
    try {
      port = new Serial(this, portname, Serial_SPEED);
    } 
    catch (Exception e) { // Port in use, etc.
      continue;
    }
    print("Trying port " + portname + "...");
    delay(1000);
    if (true) {
      break;
    } else {
      println();
      port.stop();
      port = null;
    }
  }
  if (port != null) { // Find one
      println("Arduino found");
      return port;
  } else {
    println("No Serial ports found");
    done = true;
    return null;
  }
}