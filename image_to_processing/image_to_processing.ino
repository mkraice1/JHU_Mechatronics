int arraysize = 1296;

void setup() {
  Serial.begin(9600);
 
}

void loop() {

  Serial.println("Initialize Connection"); // Announce to PC we are ready
  Serial.println(arraysize); // Send to PC how many bytes to expect
  char *myarray = new char[arraysize];
  //////////////////////////////////// Fill array with repepating 0-255 sequentially to test the created file on pc is same
  for (int x = 0; x < arraysize; x++)
    myarray[x] = x % 256;
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  for (int i =0; i<10; i++){
    Serial.println(i);
    delay(1000);
  }

  delay(1000);
}

