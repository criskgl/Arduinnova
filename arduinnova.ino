/*
 Input Pullup Serial

 This example demonstrates the use of pinMode(INPUT_PULLUP). It reads a
 digital input on pin 2 and prints the results to the serial monitor.
 
 OPEN THE SERIAL MONITOR TO SEE THE OUTPUT FROM THE INPUT PIN >>

 The circuit:
 * Momentary switch attached from pin 2 to ground
 * Built-in LED on pin 6

 Unlike pinMode(INPUT), there is no pull-down resistor necessary. An internal
 20K-ohm resistor is pulled to 5V. This configuration causes the input to
 read HIGH when the switch is open, and LOW when it is closed.

 */
bool smart = false;//this variable will be a flag for each mode

void setup() {
  //start serial connection
  Serial.begin(9600);
  //configure pin2 as an input and enable the internal pull-up resistor
  pinMode(2, INPUT_PULLUP);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
  
}

void loop() {
  //Serial.println(automaticButton);
  /* Keep in mind the pullup means the pushbutton's
     logic is INVERTED. It goes HIGH when it's open,
     and LOW when it's pressed. Turn on pin 6 when the
     button's pressed, and off when it's not.*/
  
  while(smart){//Handle automatic functioning here
    digitalWrite(6, HIGH);
    digitalWrite(7, LOW);
    //check if state has been changed
    delay(500);
    if(digitalRead(2) == LOW){//read the pushbutton value into a variable
      smart = false;
    }
  }
  
  while(!smart){//Handle manual functioning here
    digitalWrite(7, HIGH);
    digitalWrite(6, LOW);
    //check if state has been changed to automatic
    delay(500);
    if(digitalRead(2) == LOW){//read the pushbutton value into a variable
      smart = true;
    }
  }
  
  
}
