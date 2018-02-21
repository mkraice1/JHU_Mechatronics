#include <Wire.h>
#include <SPI.h>

//Array to store one Lepton frame
byte leptonFrame[164];
//Array to store 80 x 60 RAW14 pixels
uint16_t rawValues[4800];

//Define the CS port for your FLIR Lepton here
#define Lepton_CS 10

/* SPI and Serial debug setup */
void setup() {
  //Also set all other SPI devices CS lines to Output and High here
  pinMode(Lepton_CS, OUTPUT);
  digitalWrite(Lepton_CS, HIGH);
  //Start SPI
  SPI.begin();
  //Start UART
  Serial.begin(250000);
  //Serial.println("Begin");

  //Serial.begin(9600);
}

/* Main loop, get temperatures and print them */
void loop() {
  getTemperatures();
  delay(50);
  printValues();
  delay(50);
}


/* Start Lepton SPI Transmission */
void beginLeptonSPI() {
  //Begin SPI Transaction on alternative Clock
  //Running at 72 MHz
  SPI.beginTransaction(SPISettings(72000000, MSBFIRST, SPI_MODE0));
  //Start transfer  - CS LOW
  digitalWriteFast(Lepton_CS, LOW);

}

/* End Lepton SPI Transmission */
void endLeptonSPI() {
  //End transfer - CS HIGH
  digitalWriteFast(Lepton_CS, HIGH);
  //End SPI Transaction
  SPI.endTransaction();
}


/* Reads one line (164 Bytes) from the lepton over SPI */
boolean leptonReadFrame(uint8_t line) {
  bool success = true;
  //Receive one frame over SPI
  SPI.transfer(leptonFrame, 164);
  //Check for success
  if ((leptonFrame[0] & 0x0F) == 0x0F) {
    success = false;
  }
  else if (leptonFrame[1] != line) {
    success = false;
  }
  return success;
}

/* Get one image from the Lepton module */
void getTemperatures() {
  //Serial.println("Start reading temperatures");
  byte leptonError = 0;
  byte line;
  //Begin SPI Transmission
  beginLeptonSPI();
  do {
    leptonError = 0;
    for (line = 0; line < 60; line++) {
      //Reset if the expected line does not match the answer
      if (!leptonReadFrame(line)) {
        //Reset line to -1, will be zero in the next cycle
        line = -1;
        //Raise Error count
        leptonError++;
        //Little delay
        delay(1);
        //If the Error count is too high, reset the device
        if (leptonError > 100) {
          //Re-Sync the Lepton
          endLeptonSPI();
          delay(186);
          beginLeptonSPI();
          break;
        }
      }
      //If line matches answer, save the packet
      else {
        //Go through the video pixels for one video line
        for (int column = 0; column < 80; column++) {
          uint16_t result = (uint16_t)(leptonFrame[2 * column + 4] << 8
                                       | leptonFrame[2 * column + 5]);
          //Save to array
          rawValues[column + (line * 80)] = result;
        }
      }
    }
  } 
  while ((leptonError > 100) || (line != 60));
  //Serial.println("Transmission ended");
  //End Lepton SPI
  endLeptonSPI();
}

/* Print out the 80 x 60 raw values array for every complete image */
void printValues(){
  for(int i=0;i<60;i++){
    for(int j=0;j<80;j++){
      Serial.print(rawValues[(i*80) + j]);
      Serial.print(" ");
    }
    Serial.println("");
  }
  Serial.println("");
}

