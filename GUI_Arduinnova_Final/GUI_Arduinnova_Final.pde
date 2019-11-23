import processing.serial.*; //Importamos la librería Serial
 
Serial port; //Serial port name
int tab = 1;//Keeps track of current tab | [1]-->[monitorization] | [2]-->[Logs] 
int mode = 1;//Keeps current mode | [1]-->[manual] | [2]-->[Auto] 
int lightValue = 200;//Keep track of light value
void setup()
{
  //println(Serial.list()); //Visualiza los puertos serie disponibles en la consola de abajo
  //port = new Serial(this, Serial.list()[2], 9600); //Abre el puerto serie COM3
  size(800, 600); //Creamos una ventana de 800 píxeles de anchura por 600 píxeles de altura 
}
 
void draw()
{
  background(255,255,255);//Fondo de color blanco
  //DRAW LOGO
  PImage logo=loadImage("logo.png");
  image(logo,30,20,200,100);
  
  //show tab selected
  switch(tab){
    case 1:
    showMonitorization();
    break;
  case 2:
    showLogs();
    break;
  default:
  println("unknown state");
  }
}
 
void mousePressed()//When mouse pressend
{
  
}
 
void keyPressed()//When key pressed
{
   switch(key) {
  case '1': //Change to monitorization tab
    tab = 1;
    break;
  case '2': //Change to history tab
    tab = 2;
    break;
  case 'm': //Change to manual mode
    mode = 1;
    break;
  case 'a': //Change to auto mode
    mode = 2;
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
  fill(200,200,200);
  strokeWeight(1);
  //Posición Indicator
  PImage lucesPosicionSymbol =loadImage("lucesCortas.png");
  rect(300, 127, 120, 50);
  image(lucesPosicionSymbol,320,127,50,50);
  //Cortas Indicator
  PImage lucesCortasSymbol =loadImage("lucesCortas.png");
  rect(465, 127, 120, 50);
  image(lucesCortasSymbol,485,127,50,50);
  //Largas Indicator
  PImage lucesLargasSymbol =loadImage("lucesLargas.png");
  rect(630, 127, 120, 50);
  image(lucesLargasSymbol,650,127,50,50);
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
  line(260, 100, 750, 100);
}
//Func Description: draws and manages the manual mode
void showMonitorizationManual(){
  drawManualAutoIndicatorManualSelected();
  drawManualLightControl();
  drawDistanceSensorDetection();
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
  rect(50, 290, 200, 50);
  rect(50, 380, 200, 50);
  fill(255,0,0);
  rect(50, 470, 200, 50);
}
//Func Description: draws and manages the manual mode
void showMonitorizationAuto(){
  drawManualAutoIndicatorAutoSelected();
  drawAutoLightControl();
  drawDistanceSensorDetection();
  drawLightSensorDetection();
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
  fill(30,42,100);
  strokeWeight(1);
  rect(50, 290, 200, 50);
  rect(50, 380, 200, 50);
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
}

//Func Descriptions: draws the monitorization for distance detection --shows in both modes
void drawDistanceSensorDetection(){
  PImage lightDetectionSymbol =loadImage("distanceDetectionSymbol.png");
  image(lightDetectionSymbol,400,230,35,35);
  fill(0,0,0);
  rect(400, 270, 35, 255);
}





//-------------LOG TAB HANDLING FROM HERE DOWN-------------
//Func Description: draws the hisory logs
void showLogs(){
  drawMenuLogsSelected();
}

//Function Description: Draws the menu highlighting the selected Monitorization tab
void drawMenuLogsSelected(){
  textSize(25);
  fill(170,170,170);
  text("1: Monitorización", 270, 84);
  fill(0, 102, 153);
  text("2: Historial", 520, 84);
  stroke(30,42,100);
  strokeWeight(5);
  line(260, 100, 750, 100);
}
