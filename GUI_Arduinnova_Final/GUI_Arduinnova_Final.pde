import processing.serial.*; //Importamos la librería Serial
 
Serial port; //Nombre del puerto serie
 
int xlogo=0;//Posición X de la imagen
int ylogo=0;//Posición Y de la imagen
 
void setup()
{
  //println(Serial.list()); //Visualiza los puertos serie disponibles en la consola de abajo
  //port = new Serial(this, Serial.list()[2], 9600); //Abre el puerto serie COM3
  size(800, 600); //Creamos una ventana de 800 píxeles de anchura por 600 píxeles de altura 
}
 
void draw()
{
  background(100,100,100);//Fondo de color blanco
  //DRAW LOGO
  PImage imagen=loadImage("logo.png");
  image(imagen,xlogo,ylogo,200,100);
  
   
}
 
void mousePressed()  //Cuando el mouse está apretado
{
  
}
 
void keyPressed() //Cuando se pulsa una tecla
{
  
}
