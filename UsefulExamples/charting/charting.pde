int x = 0;
float py;
ArrayList<PVector> ar = new ArrayList();
 
void setup(){
  size(600,200);
  py = height/2;
}
 
void draw(){
  background(0);
  x++;
  x%=width;
  float fx = py + random(-20,20);
  fx = constrain(fx,0,height);
  ar.add(new PVector(x,fx));
  if( ar.size() > 50 ) ar.remove(0);
  for( int i = 0; i<ar.size()-1; i++){
    stroke(100,255,100,map(i,0,ar.size()-1,0,255));
    if( ar.get(i).x < ar.get(i+1).x) 
    line(ar.get(i).x,ar.get(i).y, ar.get(i+1).x,ar.get(i+1).y);
  }
  py = fx;
}
