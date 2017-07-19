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
int min = 7900;
int max = 8400;
int[] minmax = {9999,0};



// Wait for line from serial port, with timeout
String readLine(Serial port) {
  int    start = millis();
  do {
    s = port.readStringUntil('\n');
  } while ( (s == null) && ((millis() - start) < 3000));
  return s;
}



void setup() {
  size(640, 480); // Dummy window for Serial
  inPort = findPort();

}

void draw() {
  
  println("Ready for data...");
  inPort.write("Ready!\n");
  PImage img = createImage(80, 60, ALPHA);
  
  int newMin = 9999;
  int newMax = 0;

  data = inPort.readStringUntil('\n');
  if (data != null){
    dataArr = char(int(split(data, ' ')));
    minmax = findMinMax(dataArr);
    println(minmax);
    print("THIS IS DATA ");
    
    //loadPixels(); 
    img.loadPixels();
    // Loop through every pixel column
    for (int x = 0; x < img.width; x++) {
      // Loop through every pixel row
      for (int y = 0; y < img.height; y++) {
        // Use the formula to find the 1D location
        int loc = x + y * img.width;
        float grey = 0;
       
        
        try {
          grey = map(dataArr[loc], minmax[0], minmax[1], 0, 255);
          
          if ( dataArr[loc] < min ) {
            newMin = dataArr[loc];
          }
          if ( dataArr[loc] > max ) {
            newMax = dataArr[loc];
          }
        
        }
        catch (java.lang.ArrayIndexOutOfBoundsException e) {
          println(e);
          println(loc);
          println(dataArr.length);
          println(data);
        }

        img.pixels[loc] = color(grey);
      }
    }
    img.resize(640, 0);
    
    img.updatePixels(); 
    image(img,0,0);
    min = newMin;
    max = newMax;
  }
  
  delay(100);
  inPort.write("Got the data\n");

}

int[] findMinMax(char[] arr) {
  int len = arr.length;
  int i = 0;
  int min = 99999;
  int max = 0;
  
  
  for (i=0; i < len; i++) {
    if (arr[i] < min && arr[i] != 0) {
      min = arr[i];
    }
    if (arr[i] > max) {
      max = arr[i];
    }
  } 
  
  int[] returns = {min, max};
  return returns;
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