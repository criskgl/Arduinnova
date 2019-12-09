/*TODO

GRAFICO MOVIMIENTO I
GRAFICO MOVIMIENTO II
LUCES POSICION

*/

import processing.serial.*; //Importamos la librería Serial
 
Serial port; //Serial port name
int tab = 1;//Keeps track of current tab | [1]-->[monitorization] | [2]-->[Logs] 
int mode = 1;//Keeps current mode | [1]-->[manual] | [2]-->[Auto] 
int lightValue = 200;//Keep track of light value
int umbralDay = 800;//Keep track of umbral value for day mode
int umbralNight = 300;//Keep track of umbral value for night mode
boolean isUnderUmbralNight = false;
boolean isOverUmbralDay = false;
int stepUmbralChange = 10;//steps when changing umbrales 

int distanceValue = 40;//Keep track of distance value
int limitDistance = 80;
int stepUmbralLimitDistance = 5;

boolean cortas = false;//keep track of on-off state of cortas
boolean largas = false;//keep track of on-off state of largas
int xLightDetections = 515;//keeps track of xValue for lightDetectionGraph
ArrayList<PVector> lightDetections = new ArrayList();//saves up to 50 values of lightDetectionGraph

int xDistanceDetections = 515;//keeps track of xValue for distanceDetectionGraph
ArrayList<PVector> distanceDetections = new ArrayList();//saves up to 50 values of distanceDetectionGraph

int secondsSinceStart;
/*Xmas variables*/
boolean isXmas = false;

int time = millis();
int[] serialInArray = new int[2];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive        
boolean firstContact = false;        // Whether we've heard from the microcontroller

PrintWriter logFile;//Create file where we will save the logs

int xAyuda = 0;
boolean showingHelp = false;
int lastTab = 1;
void setup()
{
  //println(Serial.list()); //Visualiza los puertos serie disponibles en la consola de abajo
  port = new Serial(this, Serial.list()[2], 9600); //Abre el puerto serie COM3
  logFile = createWriter("logFile.txt"); //Create file to save the logs 
  size(800, 600); //Creamos una ventana de 800 píxeles de anchura por 600 píxeles de altura 
}
 
void draw()
{  
  background(255,255,255);//white background
  //DRAW LOGO
  PImage logo=loadImage("logo.png");
  image(logo,30,20,200,100);
  
  //show tab selected between monitorization and logs
  switch(tab){
    case 1:
    showMonitorization();
    break;
  case 2:
    showLogs();
    break;
  case 3:
    showHelp();
    break;
  default:
    println("unknown state");
  }
  //DRAW help indicator
  stroke(0,0,0);
  strokeWeight(1);
  line(0, 570, 800, 570);
  textSize(18);
  fill(0, 0, 0);
  text("H: HELP", 390, 590);
}
 
void mousePressed()//When mouse pressend
{
  
}
 
void keyPressed()//When key pressed--handle states
{
   switch(key) {
  case '1': //Change to monitorization tab
    tab = 1;
    break;
  case '2': //Change to history tab
    tab = 2;
    break;
  case 'm': //Change to manual mode
    if(mode == 2)  writeLog(logFile, "MODO MANUAL");
    mode = 1;
    break;
  case 'a': //Change to auto mode
   if(mode == 1)  writeLog(logFile, "MODO AUTOMATICO");
    mode = 2;
    break;
  case 'c': //ON-OFF Cortas
    if(mode == 1){//if in manual mode
      if(cortas) writeLog(logFile, "CORTAS OFF");
      if(!cortas) writeLog(logFile, "CORTAS ON");
      cortas = !cortas;
      port.write('c');//send order to arduino
    }
    break;
  case 'l': //ON-OFF Largas
    if(largas) writeLog(logFile, "LARGAS OFF");
    if(!largas) writeLog(logFile, "LARGAS ON");
    largas = !largas; 
    port.write('l');//send order to arduino
    break;
  case 'r': //Rafaga
  writeLog(logFile, "RÁFAGA");
  port.write('r');
    break;
  case 'x': //Xmas mode
  /*HANDLE XMAS MODE*/
    isXmas = !isXmas;
    port.write('x');
    break;
  case 'd': //day umbral up
    if(umbralDay + stepUmbralChange > 1023) break;
    umbralDay+=stepUmbralChange;
    break;
  case 's': //day umbral down
    if(umbralDay - stepUmbralChange < umbralNight) break;
    umbralDay-=stepUmbralChange;
    break;
  case 'n': //night umbral up
    if(umbralNight + stepUmbralChange > umbralDay) break;
    umbralNight+=stepUmbralChange;
    break;
  case 'b': //night umbral down
  if(umbralNight - stepUmbralChange < 0) break;
    umbralNight-=stepUmbralChange;
    break;    
  case 'p': //proximity umbral up
  if(limitDistance - stepUmbralLimitDistance < 0) break;
    limitDistance-=stepUmbralLimitDistance;
    break;
  case 'o': //proximity umbral up
  if(limitDistance + stepUmbralLimitDistance > 150) break;
    limitDistance+=stepUmbralLimitDistance;
    break;
  case 'h': //help
    if(!showingHelp){
       lastTab = tab;
       tab = 3;
       showingHelp = true;
    }else{
      tab = lastTab;
      showingHelp = false;
    }
   
    break;
  default:
    break;
  }
}

//-------------MONITORIZATION TAB HANDLING DOWN HERE-------------
//Func Description: draws and manages the monitorization
void showMonitorization(){
  //Draw menu with monitorization selected
  drawMenuMonitorizationSelected();
  //Draw active lights panel
  drawLightPanel();
  //manage each mode depending on 
  switch(mode){
    case 1://manual
    showMonitorizationManual();
    break;
  case 2://automatic
    showMonitorizationAuto();
    break;
  default:
    break;
  }
}

//Draws the visualization of active lights
void drawLightPanel(){
  //rgb(255,165,0)--> orange
  //Posición Indicator -- ALWAYS ON
  fill(255,165,0);
  strokeWeight(1);
  PImage lucesPosicionSymbol =loadImage("lucesPosicion.png");
  rect(300, 127, 120, 50);
  image(lucesPosicionSymbol,335,127,50,50);

  //Cortas Indicator
  if(cortas){
    fill(255,165,0);
    strokeWeight(1);
  }else{
    fill(200,200,200);
    strokeWeight(0);
  }
  PImage lucesCortasSymbol =loadImage("lucesCortas.png");
  rect(465, 127, 120, 50);
  image(lucesCortasSymbol,505,127,50,50);
 
  //Largas Indicator
  if(largas){
    fill(255,165,0);
    strokeWeight(1);
  }else{
    fill(200,200,200);
    strokeWeight(0);
  }
  PImage lucesLargasSymbol =loadImage("lucesLargas.png");
  rect(630, 127, 120, 50);
  image(lucesLargasSymbol,670,127,50,50);
}

//Function Description: Draws the menu highlighting the selected Monitorization tab
void drawMenuMonitorizationSelected(){
  textSize(25);
  fill(0, 102, 153);
  text("1: Monitorización", 270, 84);
  fill(170,170,170);
  text("2: Historial", 520, 84);
  stroke(30,42,100);
  strokeWeight(5);
  line(260, 100, 500, 100);
  strokeWeight(2);
  line(500, 100, 675, 100);
}
//Func Description: draws and manages the manual mode
void showMonitorizationManual(){
  drawManualAutoIndicatorManualSelected();
  drawManualLightControl();
  drawDistanceSensorDetection();
  drawDistanceDetectionGraph(240);
  if(distanceValue > 150){
    //draw black screen background
    fill(0,0,0);
    stroke(0);
    rect(515,395,240,130);
    textSize(14);
    fill(26, 201, 82);
    text("Nada dentro del campo de visión", 525, 515);
    PImage check=loadImage("blind.png");
    image(check,515+96,460,50,50);
  }
  if(isXmas){
      PImage xMasFrame=loadImage("christmas-frame-1.png");
      image(xMasFrame,0,0,800,600);
  }
}

//Func Description: draws the indication of mode with manual mode selected
void drawManualAutoIndicatorManualSelected(){
  textSize(19);
  fill(0, 102, 153);
  text("M: Manual", 55, 140);
  fill(170,170,170);
  text("A: Auto", 180, 140);
}

//Func Description: draws the controls to handle lights
void drawManualLightControl(){
  fill(30,42,100);
  strokeWeight(1);
  rect(50, 200, 200, 50);
  textSize(22);
  fill(255, 255, 255);
  text("C: Cortas", 100, 235);
  
  fill(30,42,100);
  strokeWeight(1);
  rect(50, 290, 200, 50);
  fill(255, 255, 255);
  text("L: Largas", 100, 325);
  
  fill(30,42,100);
  strokeWeight(1);
  rect(50, 380, 200, 50);
  fill(255, 255, 255);
  text("R: Ráfaga", 100, 415);
  
  fill(255,0,0);
  rect(50, 470, 200, 50);
  fill(255, 255, 255);
  text("X: CHRISTMAS", 80, 505);
}
//Func Description: draws and manages the manual mode
void showMonitorizationAuto(){
  drawManualAutoIndicatorAutoSelected();
  if(lightValue < umbralNight || lightValue > umbralDay){//exceeding either umbralDay or umbralNight
      if(lightValue < umbralNight) {
        if(!isUnderUmbralNight){
          cortas = true;//entering umbralNight
          writeLog(logFile, "CORTAS ON");
          port.write('c');
          isUnderUmbralNight = true;
          isOverUmbralDay = false;
        }
      }
      else{//entering umbralDay
        if(!isOverUmbralDay){
           writeLog(logFile, "CORTAS OFF");
           port.write('c');
           cortas = false; 
           isOverUmbralDay = true;
           isUnderUmbralNight = false;
        }

      }
      
  }

  drawAutoLightControl();
  drawDistanceSensorDetection();
  drawLightSensorDetection();
  drawLightDetectionGraph(240);
  drawDistanceDetectionGraph(240);
  if(distanceValue > 150){
    //draw black screen background
    fill(0,0,0);
    stroke(0);
    rect(515,395,240,130);
    textSize(14);
    fill(26, 201, 82);
    text("Nada dentro del campo de visión", 525, 515);
    PImage check=loadImage("blind.png");
    image(check,515+96,460,50,50);
  }
  
}

//Func Description: draws the indication of mode with auto mode selected
void drawManualAutoIndicatorAutoSelected(){
  textSize(19);
  fill(170, 170, 170);
  text("M: Manual", 55, 140);
  fill(0,102,153);
  text("A: Auto", 180, 140);
}

//Func Description: draws the light control available in auto mode
void drawAutoLightControl(){
  textSize(22);
  fill(30,42,100);
  strokeWeight(1);
  rect(50, 290, 200, 50);
  fill(255, 255, 255);
  text("L: Largas", 100, 325);
  
  fill(30,42,100);
  strokeWeight(1);
  rect(50, 380, 200, 50);
  fill(255, 255, 255);
  text("R: Ráfaga", 100, 415);
}

//Func Descriptions: draws the monitorization for light detection --shows only in auto mode
void drawLightSensorDetection(){
  PImage lightDetectionSymbol =loadImage("lightDetectionSymbol.png");
  image(lightDetectionSymbol,340,230,35,35);
  fill(0,0,0);
  rect(340, 270, 35, 255);
  int rangeDistance = 255;
  int lightLength = (lightValue*(rangeDistance))/1023;
  fill(255,255,0);
  rect(340, 270+(rangeDistance-lightLength), 35, lightLength);
  
  int umbralDayLength = (umbralDay*(rangeDistance))/1023;
  stroke(0, 234, 255);
  strokeWeight(2);
  line(340, 270+(rangeDistance-umbralDayLength), 375, 270+(rangeDistance-umbralDayLength));
  int umbralNightLength = (umbralNight*(rangeDistance))/1023;
  stroke(170, 170, 170);
  strokeWeight(2);
  line(340, 270+(rangeDistance-umbralNightLength), 375, 270+(rangeDistance-umbralNightLength));
}

//Func Descriptions: draws the monitorization for distance detection --shows in both modes
void drawDistanceSensorDetection(){
  PImage lightDetectionSymbol =loadImage("distanceDetectionSymbol.png");
  image(lightDetectionSymbol,400,230,35,35);
  fill(0,0,0);
  strokeWeight(1);
  rect(400, 270, 35, 255);
  /*Draw rect for distance*/
  int rangeDistance = 255;
  int distanceLength = (distanceValue*(rangeDistance))/150;
  if(distanceValue > limitDistance){
    fill(26, 201, 82);//GOOD-Nothing close--green
  }else{
    fill(230, 32, 18);//BAD-Something close--red
  }
  rect(400, 270+(rangeDistance-distanceLength), 35, distanceLength);
  /*Draw line for proximity*/
  int limitDistanceAdjusted = (limitDistance*(rangeDistance))/150;
  stroke(170, 170, 170);
  strokeWeight(2);
  line(400, 270+(rangeDistance-limitDistanceAdjusted), 435, 270+(rangeDistance-limitDistanceAdjusted));
  strokeWeight(1);
  fill(0,0,0);
}

void drawLightDetectionGraph(int xLength){
  //draw black screen background
  fill(0,0,0);
  stroke(0);
  rect(515,230,240,130);
  //draw chart text
  textSize(9);
  fill(255,255,255);
  text("1023", 517, 240);
  fill(255,255,255);
  text("0", 517, 360);
  textSize(10);
  fill(0,0,0);
  text("Luz", 490, 240);
  fill(0,0,0);
  text("t(s)", 740, 375);
  //draw umbral lines
  stroke(0, 234, 255);
  strokeWeight(1);
  int umbralDayAdjusted = (((1023-umbralDay)*(360-230))/1023)+230;
  line(515, umbralDayAdjusted, 515+240, umbralDayAdjusted);
  stroke(170, 170, 170);
  int umbralNightAdjusted = (((1023-umbralNight)*(360-230))/1023)+230;
  line(515, umbralNightAdjusted, 515+240, umbralNightAdjusted);
  
  if(xLightDetections > 515+xLength){//take care of overflowing our screen black area
    xLightDetections = 515;
  }
  xLightDetections++;//step in x for next value
  int lightValueAdjusted = (((1023-lightValue)*(360-230))/1023)+230;
  lightDetections.add(new PVector(xLightDetections,lightValueAdjusted));//add value to array
  if( lightDetections.size() > 50 ) lightDetections.remove(0);//remove oldest value
  for( int i = 0; i<lightDetections.size()-1; i++){
    stroke(255,255,0,map(i,0,lightDetections.size()-1,0,255));
    strokeWeight(1);
    if( lightDetections.get(i).x < lightDetections.get(i+1).x) 
    line(lightDetections.get(i).x,lightDetections.get(i).y, lightDetections.get(i+1).x,lightDetections.get(i+1).y);
  }
  textSize(9);
  fill(255,255,0);
  text(lightValue, lightDetections.get(lightDetections.size()-1).x, lightDetections.get(lightDetections.size()-1).y);
}

void drawDistanceDetectionGraph(int xLength){
  //draw black screen background
  fill(0,0,0);
  stroke(0);
  rect(515,395,240,130);
  
  textSize(9);
  fill(255,255,255);
  text("150(cm)", 517, 405);
  fill(255,255,255);
  text("0(cm)", 517, 522);
  textSize(10);
  fill(0,0,0);
  text("Proximidad", 457, 407);
  fill(0,0,0);
  text("t(s)", 740, 540);
  
  /*Draw line with proximity limit*/
  int limitDistanceAdjusted = (((150-limitDistance)*(525-395))/150)+395;
  stroke(170, 170, 170);
  strokeWeight(1);
  line(515, limitDistanceAdjusted, 515+240, limitDistanceAdjusted);
  /*Graphing line distance*/
  if(xDistanceDetections > 515+xLength){//take care of overflowing our screen black area
    xDistanceDetections = 515;
  }
  xDistanceDetections++;//step in x for next value
  int distanceValueAdjusted = (((150-distanceValue)*(525-395))/150)+395;
  distanceDetections.add(new PVector(xDistanceDetections,distanceValueAdjusted));//add value to array
  if( distanceDetections.size() > 50 ) distanceDetections.remove(0);//remove oldest value
  for( int i = 0; i<distanceDetections.size()-1; i++){
    if(distanceValue > limitDistance){
      stroke(26, 201, 82,map(i,0,distanceDetections.size()-1,0,255));//GOOD-Nothing close--green
    }else{
      stroke(230, 32, 18,map(i,0,distanceDetections.size()-1,0,255));//BAD-Something close--red
    }
    strokeWeight(1);
    if( distanceDetections.get(i).x < distanceDetections.get(i+1).x) 
    line(distanceDetections.get(i).x,distanceDetections.get(i).y, distanceDetections.get(i+1).x,distanceDetections.get(i+1).y);
  }
  
  textSize(9);
  if(distanceValue > limitDistance && distanceValue > 150){ 
    fill(0, 0, 0);
    text("No hay datos", distanceDetections.get(distanceDetections.size()-1).x, distanceDetections.get(distanceDetections.size()-1).y);
  }else if(distanceValue > limitDistance){
    fill(26, 201, 82); 
    text(distanceValue+" cm", distanceDetections.get(distanceDetections.size()-1).x, distanceDetections.get(distanceDetections.size()-1).y);
  }else{
    fill(230, 32, 18);
    text(distanceValue+" cm", distanceDetections.get(distanceDetections.size()-1).x, distanceDetections.get(distanceDetections.size()-1).y);
  }
  
  
}
//-------------LOG TAB HANDLING FROM HERE DOWN-------------
//Func Description: draws the hisory logs
void showLogs(){
  drawMenuLogsSelected();
  drawLogs();
}

//Function Description: Draws the menu highlighting the selected Monitorization tab
void drawMenuLogsSelected(){
  textSize(25);
  fill(170,170,170);
  text("1: Monitorización", 270, 84);
  fill(0, 102, 153);
  text("2: Historial", 520, 84);
  stroke(30,42,100);
  strokeWeight(2);
  line(260, 100, 500, 100);
  strokeWeight(5);
  line(500, 100, 675, 100);
}

//Func Description: draws the last logs
void drawLogs(){
  //build the black rectangle for logs
  fill(0,0,0);
  stroke(20,150,0);
  strokeWeight(3);
  rect(260,150,420,405);
  //get the last lines
  ArrayList<String> lines = parseFile("logFile.txt");
  int logLimit = 30;
  textSize(12);
  fill(20,150,0);
  int yLogPosition = 170;
  int xLogPosition = 270;
  for(int i = lines.size()-1, logCount = 0; i >= 0 && logCount < logLimit; i--){
     text(lines.get(i), xLogPosition, yLogPosition);
     yLogPosition+=13;
     logCount++;
  }
}

//Function Description: write a message to a file
void writeLog(PrintWriter file, String message){
   file.print("["+day()+"/"+month()+"/"+year()+"|"+hour( )+":"+minute( )+":"+second( )+"]    ---    "+message+"\n");
   file.flush();
}

//Function Description: reads a each line giving back a list of strings
ArrayList<String> parseFile(String fileName){
  BufferedReader reader = createReader(fileName);//Open the file
  String line = null;
  ArrayList<String> result = new ArrayList<String>();
  try {
    while ((line = reader.readLine()) != null) {
      result.add(line);
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
  return result;
}

void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  // if this is the first byte received, and it's an A, clear the serial
  // buffer and note that you've had first contact from the microcontroller.
  // Otherwise, add the incoming byte to the array:
  if (firstContact == false) {
    if (inByte == 'Z') {
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('Z');       // ask for more
    }
  }
  else {
    // Add the latest byte from the serial port to array:
    serialInArray[serialCount] = inByte;
    serialCount++;

    // If we have 2 bytes:
    if (serialCount > 1 ) {
      lightValue = serialInArray[0]*4;
      distanceValue = serialInArray[1];
      if(distanceValue <= limitDistance){
        if(largas){
          writeLog(logFile, "LARGAS OFF");
          largas = false;
          port.write('l');
        }
      }
      // print the values (for debugging purposes only):
      //println(lightValue + "\t" + distanceValue);

      // Send a capital A to request new sensor readings:
      myPort.write('Z');
      // Reset serialCount:
      serialCount = 0;
    }
  }
}

void showHelp(){
  fill(0,0,0);
  stroke(0);
  rect(0,0,800,600);
  
  textSize(25);
  fill(255,255,255);
  text("H:SALIR DE AYUDA", 315, 84);
  PImage keyboard=loadImage("keyboardHelp.png");
  keyboard.resize(760, 0);
  image(keyboard,22,108);
}
  
