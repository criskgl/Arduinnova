import processing.serial.*; //Importamos la librería Serial
 
Serial port; //Serial port name
int tab = 1;//Keeps track of current tab | [1]-->[monitorization] | [2]-->[Logs] 

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
  image(logo,0,0,200,100);
  
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

//Navigation functions
//Func Description: draws the monitorization
void showMonitorization(){
  fill(30,42,100);
  strokeWeight(1);
  rect(50, 200, 200, 50);
  rect(50, 290, 200, 50);
  rect(50, 380, 200, 50);
  fill(255,0,0);
  rect(50, 470, 200, 50);
  textSize(25);
  fill(0, 102, 153);
  text("1: Monitorización", 270, 84);
  fill(170,170,170);
  text("2: Historial", 520, 84);
  stroke(30,42,100);
  strokeWeight(5);
  line(260, 100, 750, 100);
}
//Func Description: draws the hisory logs
void showLogs(){
  textSize(25);
  fill(170,170,170);
  text("1: Monitorización", 270, 84);
  fill(0, 102, 153);
  text("2: Historial", 520, 84);
  stroke(30,42,100);
  strokeWeight(5);
  line(260, 100, 750, 100);
}
