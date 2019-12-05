int TRIGpin = 12;
int ECOpin = 13;
int LAPSE;
int DISTANCE;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(TRIGpin, OUTPUT);
  pinMode(ECOpin, INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
    digitalWrite(TRIGpin, HIGH);
    delay(1);
    digitalWrite(TRIGpin, LOW);
    LAPSE = pulseIn(ECOpin, HIGH);
    DISTANCE = LAPSE/ 58.2;
    Serial.write((char)DISTANCE);

    delay(1000);
}
