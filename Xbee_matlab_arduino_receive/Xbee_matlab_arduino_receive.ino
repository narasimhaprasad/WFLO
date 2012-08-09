char buff[24];
char xpos[3];
char ypos[3];
int x,y;

void setup(){
  Serial.begin(9600);
}

void loop(){
  while(Serial.available()>23){
    for(int c=0;c<24;c++){
      buff[c] = Serial.read();
    }   
    char* indx = strstr(buff,"x1");
    for(int i=0;i<3;i++){
      xpos[i]=buff[indx-buff+(i-2)];
      x = atoi(xpos);
    }
    char* indy = strstr(buff,"y1");
    for(int j=0;j<3;j++){
      ypos[j]=buff[indy-buff+(j-2)];
      y = atoi(ypos);
    }
    Serial.println(x);
    Serial.println(y);
  }
}




