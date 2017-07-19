import processing.serial.*;

int   Serial_SPEED=115200;
int dataLen = 9600;

Serial  inPort = null;
Serial  outPort = null;
boolean done = false;
String s;
String readVal = "";
String newVal = "";
String data = null;
char[] dataArr = new char[dataLen];
byte[] imgData = new byte[dataLen];

// Wait for line from serial port, with timeout
String readLine(Serial port) {
  int    start = millis();
  do {
    s = port.readStringUntil('\n');
  } while ( (s == null) && ((millis() - start) < 3000));
  return s;
}



void setup() {
  size(80, 60); // Dummy window for Serial
  inPort = findPort();
}

void draw() {
  
  println("Ready for data...");
  inPort.write("Ready!\n");
  
  

  data = inPort.readStringUntil('\n');
  if (data != null){
    dataArr = char(int(split(data, ' ')));
    print("THIS IS DATA ");
    
    loadPixels();  
    // Loop through every pixel column
    for (int x = 0; x < width; x++) {
      // Loop through every pixel row
      for (int y = 0; y < height; y++) {
        // Use the formula to find the 1D location
        int loc = x + y * width;
        float grey = 0;
        try {
          grey = map(dataArr[loc], 7900, 8400, 0, 255);
        }
        catch (java.lang.ArrayIndexOutOfBoundsException e) {
          println(e);
          println(loc);
          println(dataArr.length);
          println(data);
        }

        byte b = (byte)((dataArr[loc] & 0xF800) << 3);
        byte g = (byte)((dataArr[loc] & 0x7E0) << 2);
        byte r = (byte)((dataArr[loc] & 0x1F) << 3);
        pixels[loc] = color(grey);
      }
    }
    updatePixels(); 
  }
  
  
  delay(100);
  inPort.write("Got the data\n");

}




boolean gotString(Serial p, String s) {
  String val="";
  
  if (p.available() > 0){ // If data is available to read,
     val = p.readStringUntil('\n'); // read it and store it in val
     if (val == s){
        return true;
      }
   }
   return false;
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