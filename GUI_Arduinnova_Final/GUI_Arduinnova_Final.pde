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
  case '1':
    tab = 1;
    break;
  case '2':
    tab = 2;
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
  //manage each mode depending on 
  switch(mode){
    case 1://manual
    showMonitorizationManual();
    break;
  case 2:
    showMonitorizationAuto();
    break;
  default:
    break;
  }
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
  drawManualLightControl();
  drawDistanceSensorDetection();
  drawLightSensorDetection();
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

}

//Func Descriptions: draws the monitorization for light detection --shows only in auto mode
void drawLightSensorDetection(){
  fill(0,0,0);
  rect(340, 270, 35, 255);
  int rangeDistance = 255;
  int lightLength = (lightValue*(rangeDistance))/1023;
  fill(255,255,0);
  rect(340, 270+(rangeDistance-lightLength), 35, lightLength);
}

//Func Descriptions: draws the monitorization for distance detection --shows in both modes
void drawDistanceSensorDetection(){
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
