const int lightAnalogSensorPin = 5;
/*For movement sensor*/
int TRIGpin = 12;
int ECOpin = 13;
int rafagaDelay = 200;

const int shortPin = 10;
const int longPin = 11;
bool shortIsOn = false;
bool longIsOn = false;

char GUI_Order = 0;
void setup() {
  pinMode(TRIGpin, OUTPUT);
  pinMode(ECOpin, INPUT);
  pinMode(shortPin, OUTPUT);
  pinMode(longPin, OUTPUT);
  // put your setup code here, to run once:
  Serial.begin(9600);
  
}

void loop() {
  if(Serial.available() > 0){/*Wait for GUI to send data*/
    GUI_Order = Serial.read();
    
    /*BEHAVE ACCORDING TO ORDER*/
    switch(GUI_Order) {
      case 'c': //ON-OFF Cortas
        if(shortIsOn) digitalWrite(shortPin, LOW);
        else digitalWrite(shortPin, HIGH);
        shortIsOn = !shortIsOn;
        break;
      case 'l': //ON-OFF Largas
        if(longIsOn) digitalWrite(longPin, LOW);
        else digitalWrite(longPin, HIGH);
        longIsOn = !longIsOn;
        break;
      case 'r': //Rafaga
        doRafaga();
        break;
      case 'x': //Xmas mode
      /*HANDLE XMAS MODE*/
        break;
      default:
        break;
    }
  }

  
  // put your main code here, to run repeatedly:
  int lightLevel = analogRead(lightAnalogSensorPin);//occupies 2 bytes
  int firstByte = highByte(lightLevel);
  int secondByte = lowByte(lightLevel);
  Serial.write(firstByte);
  Serial.write(secondByte);  
  delay(1000);
}

void doRafaga(){
  if(longIsOn){
    for(int i = 0; i < 6; i++){
      if(i % 2 == 0){
        digitalWrite(longPin, LOW);
      }else{
        digitalWrite(longPin, HIGH);
      }
      delay(rafagaDelay);
    }
  }else{
     for(int i = 0; i < 6; i++){
      if(i % 2 == 0){
        digitalWrite(longPin, HIGH);
      }else{
        digitalWrite(longPin, LOW);
      }
      delay(rafagaDelay);
    }
  }
}
