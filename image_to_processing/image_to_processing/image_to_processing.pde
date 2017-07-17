import processing.serial.*;

int     Serial_SPEED=250000;
Serial  port = null;
boolean done = false;
String s;

// Wait for line from serial port, with timeout
String readLine() {
  int    start = millis();
  do {
    s = port.readStringUntil('\n');
  } while ( (s == null) && ((millis() - start) < 3000));
  return s;
}

void setup() {
  size(200, 200); // Dummy window for Serial
  
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
    if (((s = readLine()) != null) && s.contains("Initialize Connection")) {
      break;
    } else {
      println();
      port.stop();
      port = null;
    }
  }
  if (port != null) { // Find one
      println("Arduino found");
      println("Arduino says something!");
  } else {
    println("No Serial ports found");
    done = true;
  }
}

void draw() {
  while (!done){
    println(port.readStringUntil("\n"));
  }
}