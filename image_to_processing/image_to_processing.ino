#define DATA_LEN 500
uint16_t rawValues[DATA_LEN];
String val = "";

void setup() {
  //pinMode(ledPin, OUTPUT); // Set pin as OUTPUT
  Serial.begin(9600);
  randomValues();
}

void loop() {
  
  Serial.println("Initialize Connection"); // Announce to PC we are ready
  for (int i =0; i<10; i++){
    Serial.println(i);
    delay(500);
  }

  sendBytes(rawValues);
  if (Serial.available()) 
   { // If data is available to read,
     val = Serial.readStringUntil('\n'); // read it and store it in val
     if (val == "Ready for data"){
        sendBytes(rawValues);
      }
   }
  delay(1000);
}

void randomValues(){
  for(int i=0;i<DATA_LEN;i++){
    rawValues[i] = i;
  }
}

void sendBytes(uint16_t arr[]){
  int i = 0;
  for(i=0;i<DATA_LEN;i++){
    Serial.println(arr[i]);  
  }
}

