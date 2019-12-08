/*For light sensor*/
const int lightAnalogSensorPin = 5;
/*For movement sensor*/
int TRIGpin = 12;
int ECOpin = 13;
int LAPSE;
int DISTANCE;

int rafagaDelay = 200;

const int shortPin = 10;
const int longPin = 11;
bool shortIsOn = false;
bool longIsOn = false;

bool isXmas = false;
bool xMasIsPlaying = false;
const int speakerOut = 8; 

char GUI_Order = 0;

int dist;
int light;


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


void setup() {
  pinMode(TRIGpin, OUTPUT);
  pinMode(ECOpin, INPUT);
  pinMode(shortPin, OUTPUT);
  pinMode(longPin, OUTPUT);
  pinMode(speakerOut, OUTPUT);
  // put your setup code here, to run once:
  Serial.begin(9600);
  establishContact();
  
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
        isXmas = !isXmas;
        break;
      case 'Z': //Send data
        light = analogRead(lightAnalogSensorPin)/4;
        delay(10);
        dist = calculateDistance();
        if(dist > 150) dist = 151; 
        Serial.write(light);
        Serial.write(dist);
      default:
        break;
    }

    if(!xMasIsPlaying){
      if(isXmas) playTone();
    }
  }

}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('Z');   // send a capital Z
    delay(300);
  }
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
/**************************CHRISTMAS MODE***************************/
void playTone() {
    
    xMasIsPlaying = true;
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
     if(!isXmas) {
        digitalWrite(speakerOut, LOW);
        return;
     }
   }
   else { // Rest beat; loop times delay
     for (int j = 0; j < rest_count; j++) { // See NOTE on rest_count
       if(!isXmas) {
          digitalWrite(speakerOut, LOW);
          return;
       }
       delayMicroseconds(duration); 
     } 
   }      
    // A pause between notes...
    delayMicroseconds(pause);
  }
  xMasIsPlaying = false;
}

int calculateDistance(){
    digitalWrite(TRIGpin, HIGH);
    delay(1);
    digitalWrite(TRIGpin, LOW);
    LAPSE = pulseIn(ECOpin, HIGH);
    DISTANCE = LAPSE/ 58.2;
    return DISTANCE;
}
