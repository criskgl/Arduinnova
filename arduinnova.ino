//NAME USED PINS
const int lightAnalogSensorPin = 5;
const int lighLevelLedObserver = 9;
const int buttonSmartPin = 2;

const int manualIndicatorPin = 7;
const int autoIndicatorPin = 6;

const int shortPin = 10;
const int shortButtonPin = 1;  
const int longPin = 11;
const int longButtonPin = 0;

const int speakerOut = 8; 

//GLOBAL VARIABLES :
int lightLevel, high = 0, low = 1023;//to handle light level
bool smart = false;//to switch between MANUAL or AUTO
bool nightMode = false;

bool shortIsOn = false;
bool longIsOn = false;

bool computerConnected = false;

int TRIGpin = 12;
int ECOpin = 13;
int LAPSE;
int DISTANCE;


/*Variables for Christmas mode*/
// TONES  ========================================== // Start by defining the relationship between
//       note, period, &  frequency.
 #define  C     2100
 #define  D     1870 
 #define  E     1670
 #define  f     1580    // Does not seem to like capital F
 #define  G     1400 
 // Define a special note, 'R', to represent a rest
 #define  R     0
// MELODY and TIMING  =======================================
 //  melody[] is an array of notes, accompanied by beats[],
 //  which sets each note's relative length (higher #, longer note)
 int melody[] = {E, E, E,R,
 E, E, E,R,
 E, G, C, D, E, R,
 f, f, f,f, f, E, E,E, E, D ,D,E, D, R, G ,R,
 E, E, E,R,
 E, E, E,R,
 E, G, C, D, E, R,
 f, f, f,f, f, E, E, E,  G,G, f, D, C,R };
 int MAX_COUNT = sizeof(melody) / 2; // Melody length, for looping.
 // Set overall tempo
 long tempo = 8000;           
 // Set length of pause between notes
 int pause = 500;
 // Loop variable to increase Rest length
 int rest_count = 50; //<-BLETCHEROUS HACK; See NOTES
 // Initialize core variables
 int tone_ = 0;
 int beat = 0;
 long duration  = 0;



void setup()
{
  pinMode(TRIGpin, OUTPUT);
  pinMode(ECOpin, INPUT);
  
  Serial.begin(9600);
  if(Serial){
    computerConnected = true;
  }
  else{
    computerConnected = false;
  }


  // We'll set up the LED pin to be an output.
  pinMode(lighLevelLedObserver, OUTPUT);
  //We don't need to do anything special to use the analog input for the input light sensor, we just read it

  pinMode(buttonSmartPin, INPUT_PULLUP);//mode switcher M/A
  pinMode(shortButtonPin, INPUT_PULLUP);//button to manually control short lights
  pinMode(longButtonPin, INPUT_PULLUP);//button to manually control long lights
  
  pinMode(manualIndicatorPin, OUTPUT);
  pinMode(autoIndicatorPin, OUTPUT);

  pinMode(shortPin, OUTPUT);
  pinMode(longPin, OUTPUT);

  //Change this to initialize system to smart mode or manual mode
  smart = false;

  pinMode(speakerOut, OUTPUT);
  
  if(smart){
      //manual indicator off
      digitalWrite(manualIndicatorPin, LOW);
      //auto indicator on
      digitalWrite(autoIndicatorPin, HIGH);
    }else{
      //auto indicator off
      digitalWrite(autoIndicatorPin, LOW);
      //manual indicator off
      digitalWrite(manualIndicatorPin, HIGH);
    }
    
}


void loop()
{
  //**********************TO-DO TURN ON POSITION LIGHTS ALWAYS ON!!!
  
  /*-------------------------------SMART-------------------------*/
  while(smart){
    //Start turning off long lights
    digitalWrite(longPin, LOW);
    
    autoTune();// have the Arduino do the lightsensor autotune
    //measure the voltage coming from the photoresistor resistor pair
    //Range: [0-1023] (0 for 0 Volts and 1023 for 5V);
    lightLevel = analogRead(lightAnalogSensorPin);
    Serial.write(lightLevel);
    if(nightMode){
      digitalWrite(shortPin, HIGH);
      shortIsOn = true;
    }else{
      digitalWrite(shortPin, LOW);
      shortIsOn = false;
    }
    //Check  if we need to turn on short lights
    if(lightLevel < 500){//NIGHT
      nightMode = true;
    }
    if(lightLevel > 700){//DAY
      nightMode = false;
    }
    static const unsigned long REFRESH_INTERVAL = 1000; // ms
    static unsigned long lastRefreshTime = 0;
    
    if(millis() - lastRefreshTime >= REFRESH_INTERVAL)
    {
      lastRefreshTime += REFRESH_INTERVAL;
                  Serial.println((String)"Light Intensity: "+lightLevel);
    }
    //send signal to our light level debugger led;
    analogWrite(lighLevelLedObserver, 255-lightLevel);
    
    //check if state has been changed
    if(digitalRead(buttonSmartPin) == LOW){//read the pushbutton value into a variable
      delay(300);
      smart = false;
      //auto indicator off
      digitalWrite(autoIndicatorPin, LOW);
      //manual indicator on
      digitalWrite(manualIndicatorPin, HIGH);
      Serial.println("MANUAL MODE ON");
    }
  }
  /*-------------------------------MANUAL----------------------------*/
  while(!smart){

    /*
    if(Serial.available() > 4){
      Serial.print("hola");
      String userOrder = Serial.readString();
      manageUserInput(userOrder);
    }*/
    checkUpdateLightButtons();
    offLongIfDistanceTooSmall();
    //check if state has been changed to automatic
    if(digitalRead(buttonSmartPin) == LOW){//read the pushbutton value into a variable
      delay(300);
      smart = true;
      //manual indicator off
      digitalWrite(manualIndicatorPin, LOW);
      //auto indicator on
      digitalWrite(autoIndicatorPin, HIGH);
      Serial.println("SMART MODE ON");
      break;
    }
  }
}
/************************************AUXILIAR FUNCTIONS***********************/
void serialFlush(){
  while(Serial.available() > 0) {
    char t = Serial.read();
  }
}   

void offLongIfDistanceTooSmall(){
    
    int dist = calculateDistance();
    Serial.println("distance detected: "+dist);
    if(dist < 10){
      digitalWrite(longPin, LOW);
      longIsOn = false; 
    }
}

void checkUpdateLightButtons(){
    //SHORT
    if(digitalRead(longButtonPin) == LOW){
      delay(300);
      if(!longIsOn){
        digitalWrite(longPin, HIGH);
        longIsOn = true;
      }else{ 
        digitalWrite(longPin, LOW);
        longIsOn = false;
      }
    }
    //LONG
    if(digitalRead(shortButtonPin) == LOW){
      delay(300);
      if(shortIsOn){
        digitalWrite(shortPin, LOW);
        shortIsOn = false;
    }else{ 
        digitalWrite(shortPin, HIGH);
        shortIsOn = true;
    }
  }
}

void manageUserInput(String userOrder){
  Serial.print(userOrder);
  if(!userOrder.equals("")){
    if(userOrder.compareTo("SHORT ON") == 10){
      Serial.println("Turning SHORT ON");
      digitalWrite(shortPin, HIGH);
    }
    else if(userOrder.compareTo("LONG ON") == 10){
      Serial.println("Turning LONG ON");
      digitalWrite(longPin, HIGH);
    }
    else if(userOrder.compareTo("SHORT OFF") == 10){
      Serial.println("Turning SHORT OFF");
      digitalWrite(shortPin, LOW);
    }
    else if(userOrder.compareTo("LONG OFF") == 10){
      Serial.println("Turning LONG OFF");
      digitalWrite(longPin, LOW);
    }else if(userOrder.compareTo("FLASH") == 10){
      Serial.println("Flashing...");
      digitalWrite(longPin, LOW);
      delay(200);
      digitalWrite(longPin, HIGH);
      delay(200);
      digitalWrite(longPin, LOW);
      delay(200);
      digitalWrite(longPin, HIGH);
    }
    else if(userOrder.compareTo("CHRISTMAS") == 10){
      Serial.println("HO HO HO!!");
      playTone();
      Serial.println("HO HO HO ENDED!");
    }
    else{
      Serial.println("NOT VALID COMMAND");
    }
  }
}


int calculateDistance(){
    digitalWrite(TRIGpin, HIGH);
    delay(1);
    digitalWrite(TRIGpin, LOW);
    LAPSE = pulseIn(ECOpin, HIGH);
    DISTANCE = LAPSE/ 58.2;
    return DISTANCE;
}
//FUNCTION TO MANUALLY TUNE THE LIGHT SENSOR
void manualTune()
{
  lightLevel = map(lightLevel, 0, 1023, 0, 255);
  lightLevel = constrain(lightLevel, 0, 255);
} 

//FUNCTION TO AUTOMATICALLY TUNE THE LIGHT SENSOR
void autoTune()
{
  if (lightLevel < low)
  {
    low = lightLevel;
  }
  if (lightLevel > high)
  {
    high = lightLevel;
  }
  lightLevel = map(lightLevel, low+30, high-30, 0, 255);
  lightLevel = constrain(lightLevel, 0, 255);
}

/**************************CHRISTMAS MODE***************************/
void playTone() {
    //NOTES
    /* #define  C     2100
 #define  D     1870 
 #define  E     1670
 #define  f     1580    // Does not seem to like capital F
 #define  G     1400 
 // Define a special note, 'R', to represent a rest
 #define  R     0*/
    for (int i=0; i<MAX_COUNT; i++) {
    tone_ = melody[i];
    beat = 50;
    if(longIsOn){
          if(melody[i] == E) {
            digitalWrite(longPin, LOW);
          }
          if(melody[i] == D) {
            digitalWrite(longPin, LOW);
          }
          if(melody[i] == f) {
            digitalWrite(longPin, LOW);
          }
          if(melody[i] == G) {
            digitalWrite(longPin, LOW);
          }
          if(melody[i] == R) {
            digitalWrite(longPin, LOW);
          }
          longIsOn = false;
    }else{
       if(melody[i] == E) {
            digitalWrite(longPin, HIGH);
          }
          if(melody[i] == D) {
            digitalWrite(longPin, HIGH);
          }
          if(melody[i] == f) {
            digitalWrite(longPin, HIGH);
          }
          if(melody[i] == G) {
            digitalWrite(longPin, HIGH);
          }
          if(melody[i] == R) {
            digitalWrite(longPin, HIGH);
          }
          longIsOn = true;
    }

    if(!shortIsOn){
       if(melody[i] == R) {
            digitalWrite(shortPin, HIGH);
          }
          if(melody[i] == G) {
            digitalWrite(shortPin, HIGH);
          }
          if(melody[i] == f) {
            digitalWrite(shortPin, HIGH);
          }
          if(melody[i] == D) {
            digitalWrite(shortPin, HIGH);
          }
          if(melody[i] == E) {
            digitalWrite(shortPin, HIGH);
          }
          shortIsOn = true;
    }else{
         if(melody[i] == R) {
            digitalWrite(shortPin, LOW);
          }
          if(melody[i] == G) {
            digitalWrite(shortPin, LOW);
          }
          if(melody[i] == f) {
            digitalWrite(shortPin, LOW);
          }
          if(melody[i] == D) {
            digitalWrite(shortPin, LOW);
          }
          if(melody[i] == E) {
            digitalWrite(shortPin, LOW);
          }
          shortIsOn = false;
    }

    duration = beat * tempo; // Set up timing

    long elapsed_time = 0;
   if (tone_ > 0) { // if this isn't a Rest beat, while the tone has
     //  played less long than 'duration', pulse speaker HIGH and LOW
     while (elapsed_time < duration) {
       digitalWrite(speakerOut,HIGH);
       delayMicroseconds(tone_ / 2);
       // DOWN
       digitalWrite(speakerOut, LOW);
       delayMicroseconds(tone_ / 2);
       // Keep track of how long we pulsed
       elapsed_time += (tone_);
     }
   }
   else { // Rest beat; loop times delay
     for (int j = 0; j < rest_count; j++) { // See NOTE on rest_count
       delayMicroseconds(duration); 
     } 
   }      
    // A pause between notes...
    delayMicroseconds(pause);
  }
                             
 }
