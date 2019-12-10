<img src="https://github.com/criskgl/Arduinnova/blob/master/GUI/assets/logo.png" title="Arduinnova" alt="Arduinnova">

# Arduinnova

> Smart light system for a car based on Arduino. Manual + Automatic(looking at Distance proximity+Light exposure)

> arduino, processing, communication, light, system, detection, sensors, fotoresistor, movement, iot, IOT

[![Build Status](http://img.shields.io/travis/badges/badgerbadgerbadger.svg?style=flat-square)](https://travis-ci.org/badges/badgerbadgerbadger) 
[![Coverage Status](http://img.shields.io/coveralls/badges/badgerbadgerbadger.svg?style=flat-square)](https://coveralls.io/r/badges/badgerbadgerbadger) 
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org) 
[![Badges](http://img.shields.io/:badges-9/9-ff6799.svg?style=flat-square)](https://github.com/badges/badgerbadgerbadger)


[![intro](https://github.com/criskgl/Arduinnova/blob/master/readmeAssets/intro.gif)]()

---

## Table of Contents

- [Setup](#setup)
- [Features](#features)
- [Contributing](#contribuiting)
- [Support](#support)
- [License](#license)

---

## Setup

### Clone

- Clone this repo to your local machine using `https://github.com/criskgl/Arduinnova.git`

### Hardware Setup

- You can use any arduino, I recommend arduino UNO beacuse of its simplicity.

[![manual](https://github.com/criskgl/Arduinnova/blob/master/readmeAssets/hardwareSetup.png)]()

This system has been simplified to only using one light per type of light. Final picture of the project includes 2 lights per type connected in pararell 2 by 2.

### Software Setup

- Have the arduino IDE installed on your computer, you can download it <a href="https://www.arduino.cc/en/main/software">here</a>

- Have the processing IDE installed on your computer, you can download it <a href="https://processing.org/download/">here</a>

- It is very important that you follow the next steps **IN ORDER**.

* **1**. ***Upload the code to the arduino using the play button that the arduino IDE provides.***

* **2**. ***Run the processing code using the play button that the processing IDE provides.***

> Now... time to enjoy 😄

---

## Features

* Manual mode

    * All the lights can be controlled
    * Only proximity sensor affects the behaviour of this mode not letting the high beam lights turn on
    * If high beam lights are on and some object is under our limit distance, high beam lights are immediately turned off
    
* Auto mode
    
    * The low beam lights are now controlled by the computer following the next logic:
    
    🌒 *Night limit* (light has to stay below that level for 3 seconds to turn on low beam lights) 🌒 
    
    [![umbralNight](https://github.com/criskgl/Arduinnova/blob/master/readmeAssets/umbralDay.gif)]()

    🌞 *Day limit* (light has to stay above that level for 3 seconds to turn off low beam lights) 🌞
    
    [![umbralDay](https://github.com/criskgl/Arduinnova/blob/master/readmeAssets/umbralNight.gif)]()
    
    * The high beam lights can be controlled manually but proximity sensor takes effect on the behaviour in the same way as in manual mode
    * If high beam lights are on and some object is under our limit distance, high beam lights are immediately turned off

* Log history

    [![umbralChange](https://github.com/criskgl/Arduinnova/blob/master/readmeAssets/history.gif)]()
    
🎅🏻🌲🎄🎁🎅🏻🌲🎄🎁🎅🏻🌲🎄🎁🎅🏻🌲🎄🎁🎅🏻🌲🎄🎁🎅🏻🌲🎄🎁🎅🏻🌲🎄🎁🎅🏻🌲🎄🎁🎅🏻🌲🎄🎁🎅🏻🌲🎄🎁🎅🏻🌲🎄🎁🎅🏻🌲🎄🎁🎅🏻🌲🎄🎁

* **EASTER-EGG**: Xmas mode is accesible in manual mode. We just need to press 'x' and the lights will start dancing to the rythm of jingle bells. 

🎶🎅🏻🎶🎅🏻🎶🎅🏻🎶🎅🏻🎶🎅🏻🎶🎅🏻🎶🎅🏻🎶🎅🏻🎶🎅🏻🎶🎅🏻🎶🎅🏻🎶🎅🏻🎶🎅🏻🎶🎅🏻🎶🎅🏻🎶🎅🏻🎶🎅🏻

   [![xMas](https://github.com/criskgl/Arduinnova/blob/master/readmeAssets/manualXmas.gif)]()
   
* Help screen: If you feel stuck with the interface at any point your are welcope to press H to acces the help panel.

    [![xMas](https://github.com/criskgl/Arduinnova/blob/master/readmeAssets/help.gif)]()

## Settings

* Limit bove we consider day can be 
    * Increased: press 'd'
    * Decreased: press 's'
    
* Limit below we consider night can be 
    * Increased: press 'n'
    * Decreased: press 'b'
    
    [![umbralChange](https://github.com/criskgl/Arduinnova/blob/master/readmeAssets/umbralChange.gif)]()

* Distance limit below which we consider too close: 
    * Increased: press 'o'
    * Decreased: press 'p'
    
    [![umbralChange](https://github.com/criskgl/Arduinnova/blob/master/readmeAssets/distanceLimitChange.gif)]()

---

## Contributing

> To get started...

### Step 1

- **Option 1**
    - 🍴 Fork this repo!

- **Option 2**
    - 👯 Clone this repo to your local machine using `https://github.com/criskgl/Arduinnova.git`

### Step 2

- **HACK AWAY!** 🔨🔨🔨

### Step 3

- 🔃 Create a new pull request

---


## Support

Reach out to me at one of the following places!

- Website at <a href="https://criskgl.github.io" target="_blank">`criskgl.github.io`</a>
- Twitter at <a href="https://twitter.com/cryptocrisK" target="_blank">`cryptocrisK`</a>
---

## License

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

- **[MIT license](http://opensource.org/licenses/mit-license.php)**
