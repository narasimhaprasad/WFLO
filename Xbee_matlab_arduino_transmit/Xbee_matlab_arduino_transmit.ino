char x[12];
char y[12];
char buffer[24];

void setup(){
  Serial.begin(9600);
}

void loop(){
  while(Serial.available()>23)
  {
    for(int i=0;i<24;i++){
      buffer[i] = Serial.read();
    }
    for(int i =0;i<24;i++){
      Serial.print(buffer[i]);
      delay(10);
    }
  }
}


