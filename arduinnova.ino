/*
PHOTORESISTOR PART
  Use a photoresistor (light sensor) to control the brightness
  of a light. We will take advantage of this to dim or increase 
  our lighting power

-Hardware connections:
  Photo resistor:
    Connect one side of the photoresistor to 5 Volts (5V).
    Connect the other side of the photoresistor to ANALOG pin 0.
    Connect a 10K resistor between ANALOG pin 0 and GND.

    This creates a voltage divider, with the photoresistor one
    of the two resistors. The output of the voltage divider
    (connected to A0) will vary with the light level.

  LED:
    Connect the positive side (long leg) of the LED to
    digital pin 9. (To vary the brightness, this pin must
    support PWM, which is indicated by "~" or "PWM" on the
    Arduino itself.)

    Connect the negative side of the LED (short leg) to a
    330 Ohm resistor.

    Connect the other side of the resistor to GND.
*/

/*
MODE SWITCHER PART
we use a button to change state MANUAL to AUTO or viceversa.
We use two indicators lights. 
One for manual and other for automatic.

-Hardware connections:
  Button:
    Connect one side of button to PIN2 that will read the pushing
    Connect other side of button to ground to close the circuit
  M INDICATOR:
    Connect the M light with a 250 Ohm resistor to an LED, 
      ground it & set its input voltage to pin7 
  A INDICATOR:
    Connect the M light with a 250 Ohm resistor to an LED, 
      ground it & set its input voltage to pin6
*/
//NAME USED PINS
const int lightAnalogSensorPin = 0;
const int lighLevelLedObserver = 9;
const int buttonSmart = 2;

const int manualIndicatorPin = 7;
const int autoIndicatorPin = 6;

const int shortPin = 10;
const int longPin = 11;

//GLOBAL VARIABLES :
int lightLevel, high = 0, low = 1023;//to handle light level
bool smart = false;//to switch between MANUAL or AUTO
bool nightMode = false;


void setup()
{
  Serial.begin(9600);
  // We'll set up the LED pin to be an output.
  pinMode(lighLevelLedObserver, OUTPUT);
  //We don't need to do anything special to use the analog input for the input light sensor, we just read it

  pinMode(buttonSmart, INPUT_PULLUP);//mode switcher M/A

  pinMode(manualIndicatorPin, OUTPUT);
  pinMode(autoIndicatorPin, OUTPUT);

  pinMode(shortPin, OUTPUT);
  pinMode(longPin, OUTPUT);
}


void loop()
{
  //**********************TO-DO TURN ON POSITION LIGHTS ALWAYS ON!!!
  
  
  //measure the voltage coming from the photoresistor resistor pair
  //Range: [0-1023] (0 for 0 Volts and 1023 for 5V) 
  
  
  //lightLevel = analogRead(lightAnalogSensorPin);
  
  
  // We now want to use this number to control the brightness of
  // the LED. But we have a problem: the analogRead() function
  // returns values between 0 and 1023, and the analogWrite()
  // function wants values from 0 to 255.
  

  // We can solve this by using two handy functions called map()
  // and constrain(). Map will change one range of values into
  // another range. If we tell map() our "from" range is 0-1023,
  // and our "to" range is 0-255, map() will squeeze the larger
  // range into the smaller. (It can do this for any two ranges.)

  // lightLevel = map(lightLevel, 0, 1023, 0, 255);

  // Because map() could still return numbers outside the "to" 
  // range, (if they're outside the "from" range), we'll also use
  // a function called constrain() that will "clip" numbers into
  // a given range. If the number is above the range, it will reset
  // it to be the highest number in the range. If the number is
  // below the range, it will reset it to the lowest number.
  // If the number is within the range, it will stay the same.

  // lightLevel = constrain(lightLevel, 0, 255);

  // Here's one last thing to think about. The circuit we made
  // won't have a range all the way from 0 to 5 Volts. It will
  // be a smaller range, such as 300 (dark) to 800 (light).
  // If we just pass this number directly to map(), the LED will
  // change brightness, but it will never be completely off or
  // completely on.

  // You can fix this two ways, each of which we'll show
  // in the functions below. Uncomment ONE of them to
  // try it out:

  //manualTune();  // manually change the range from light to dark

  

  // The above functions will alter lightLevel to be cover the
  // range from full-on to full-off. Now we can adjust the
  // brightness of the LED:

  
  /*-------------------------------AUTOMATIC-------------------------*/
  while(smart){
    autoTune();// have the Arduino do the lightsensor autotune
    //measure the voltage coming from the photoresistor resistor pair
    //Range: [0-1023] (0 for 0 Volts and 1023 for 5V);
    lightLevel = analogRead(lightAnalogSensorPin);

    if(nightMode){
      digitalWrite(shortPin, HIGH);
    }else{
      digitalWrite(shortPin, LOW);
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
    if(digitalRead(buttonSmart) == LOW){//read the pushbutton value into a variable
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
    //keep short lights on
    
    String userOrder = "";
    if(Serial.available() != 0){
      userOrder = Serial.readString();//read command if any
    }
    if(!userOrder.equals("")){
      if(userOrder.compareTo("SHORT ON") == 10){
        Serial.println("Turning SHORT ON");
        digitalWrite(shortPin, HIGH);
      }
      else if(userOrder.compareTo("LONG ON") == 10){
        Serial.println("TURING LONG ON");
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
      else{
        Serial.println("NOT VALID COMMAND");
      }
    }

    

    //check if state has been changed to automatic
    if(digitalRead(buttonSmart) == LOW){//read the pushbutton value into a variable
      delay(300);
      smart = true;
      //manual indicator off
      digitalWrite(manualIndicatorPin, LOW);
      //auto indicator on
      digitalWrite(autoIndicatorPin, HIGH);
      Serial.println("AUTOMATIC MODE ON");
      break;
    }

    
    
    
  }

  
}


/************************************AUXILIAR FUNCTIONS***********************/

//FUNCTION TO MANUALLY TUNE THE LIGHT SENSOR
void manualTune()
{
  // As we mentioned above, the light-sensing circuit we built
  // won't have a range all the way from 0 to 1023. It will likely
  // be more like 300 (dark) to 800 (light). If you run this sketch
  // as-is, the LED won't fully turn off, even in the dark.

  // You can accommodate the reduced range by manually 
  // tweaking the "from" range numbers in the map() function.
  // Here we're using the full range of 0 to 1023.
  // Try manually changing this to a smaller range (300 to 800
  // is a good guess), and try it out again. If the LED doesn't
  // go completely out, make the low number larger. If the LED
  // is always too bright, make the high number smaller.

  // Remember you're JUST changing the 0, 1023 in the line below!

  lightLevel = map(lightLevel, 0, 1023, 0, 255);
  lightLevel = constrain(lightLevel, 0, 255);

  // Now we'll return to the main loop(), and send lightLevel
  // to the LED.
} 

//FUNCTION TO AUTOMATICALLY TUNE THE LIGHT SENSOR
void autoTune()
{
  // As we mentioned above, the light-sensing circuit we built
  // won't have a range all the way from 0 to 1023. It will likely
  // be more like 300 (dark) to 800 (light).

  // In the manualTune() function above, you need to repeatedly
  // change the values and try the program again until it works.
  // But why should you have to do that work? You've got a
  // computer in your hands that can figure things out for itself!

  // In this function, the Arduino will keep track of the highest
  // and lowest values that we're reading from analogRead().

  if (lightLevel < low)
  {
    low = lightLevel;
  }

  // We also initialized "high" to be 0. We'll save anything
  // we read that's higher than that:

  if (lightLevel > high)
  {
    high = lightLevel;
  }

  // Once we have the highest and lowest values, we can stick them
  // directly into the map() function. No manual tweaking needed!

  // One trick we'll do is to add a small offset to low and high,
  // to ensure that the LED is fully-off and fully-on at the limits
  // (otherwise it might flicker a little bit).

  lightLevel = map(lightLevel, low+30, high-30, 0, 255);
  lightLevel = constrain(lightLevel, 0, 255);

  // Now we'll return to the main loop(), and send lightLevel
  // to the LED.
}
