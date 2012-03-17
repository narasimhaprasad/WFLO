#include <Servo.h>
#include <PID_v1.h>
#include <PID_AutoTune_v0.h>

//Define Variables we'll be connecting to
double Setpointx, Inputx, Outputx;
double Setpointy, Inputy, Outputy;

// Auto-tune parameters
byte ATuneModeRememberx=2;
byte ATuneModeRemembery=2;
double kpx=2,kix=0.5,kdx=2;
double kpy=2,kiy=0.5,kdy=2;
double aTuneStepx=50, aTuneNoisex=1, aTuneStartValuex=100;
double aTuneStepy=50, aTuneNoisey=1, aTuneStartValuey=100;
boolean tuningx = true;
boolean tuningy = true;
unsigned int aTuneLookBack=20;
unsigned long  modelTime, serialTime;

//Specify the links and initial tuning parameters
PID myPIDx(&Inputx, &Outputx, &Setpointx, kpx,kix,kdx, DIRECT);
PID myPIDy(&Inputy, &Outputy, &Setpointy, kpy,kiy,kdy, DIRECT);
PID_ATune aTunex(&Inputx, &Outputx);
PID_ATune aTuney(&Inputy, &Outputy);

//Define servos
Servo servox;
Servo servoy;

//Ultrasonic setup
const int pwPinx = 7;
const int pwPiny = 8;
int arraysizex = 9;
int arraysizey = 9;
int rangevaluex[] = {  
  0,0,0,0,0,0,0,0,0};
int rangevaluey[] = {
  0,0,0,0,0,0,0,0,0};
long pulsex ;
long pulsey ;
int modEx;
int modEy;

void setup()
{
  //Initialize serial communication
  Serial.begin(115600);
  servox.attach(9);
  servoy.attach(10);
  servox.writeMicroseconds(1450);
  servoy.writeMicroseconds(1450);
  serialTime = 0;

  //initialize the variables we're linked to
  Setpointx = 100;
  Setpointy = 100;

  //turn the PID on
  myPIDx.SetMode(AUTOMATIC);
  myPIDx.SetOutputLimits(1100,1900);
  myPIDy.SetMode(AUTOMATIC);
  myPIDy.SetOutputLimits(1100,1900);

  //Start auto-tune
  if(tuningx)
  {
    tuningx=false;
    changeAutoTunex();
    tuningx=true;
  }
  if(tuningy)
  {
    tuningy=false;
    changeAutoTuney();
    tuningy=true;
  }
}

void loop()
{
  pinMode(pwPinx,INPUT);
  pinMode(pwPiny,INPUT);

  for(int i = 0; i < arraysizex; i++)
  {								    
    pulsex = pulseIn(pwPinx, HIGH);
    rangevaluex[i] = pulsex/58;
    delay(10);
  }
  isort(rangevaluex,arraysizex);
  modEx = mode(rangevaluex,arraysizex);

  unsigned long now = millis();
  Inputx = modEx;

  if(tuningx)
  {
    byte valx = (aTunex.Runtime());
    if (valx!=0)
    {
      tuningx = false;
    }
    if(!tuningx)
    {
      kpx = aTunex.GetKp();
      kix = aTunex.GetKi();
      kdx= aTunex.GetKd();
      myPIDx.SetTunings(kpx,kix,kdx);
      AutoTuneHelperx(false);
    }
  }
  else myPIDx.Compute();

  servox.writeMicroseconds(Outputx);

  for(int i = 0; i < arraysizey; i++)
  {								    
    pulsey = pulseIn(pwPiny, HIGH);
    rangevaluey[i] = pulsey/58;
    delay(10);
  }
  isort(rangevaluey,arraysizey);
  modEy = mode(rangevaluey,arraysizey);

  Inputy = modEy;

  if(tuningy)
  {
    byte valy = (aTuney.Runtime());
    if (valy!=0)
    {
      tuningy = false;
    }
    if(!tuningy)
    {
      kpy = aTuney.GetKp();
      kiy = aTuney.GetKi();
      kdy= aTuney.GetKd();
      myPIDy.SetTunings(kpy,kiy,kdy);
      AutoTuneHelpery(false);
    }
  }
  else myPIDy.Compute();

  servoy.writeMicroseconds(Outputy);

  //send-recieve serial data
  if(millis()>serialTime)
  {
    SerialReceivex();
    SerialReceivey();
    SerialSend();
    serialTime+=500;
  } 
}

void changeAutoTunex()
{
  if(!tuningx)
  {
    //Set the output to the desired starting frequency.
    Outputx=aTuneStartValuex;
    aTunex.SetNoiseBand(aTuneNoisex);
    aTunex.SetOutputStep(aTuneStepx);
    aTunex.SetLookbackSec((int)aTuneLookBack);
    AutoTuneHelperx(true);
    tuningx = true;
  }
  else
  { //cancel autotune
    aTunex.Cancel();
    tuningx = false;
    AutoTuneHelperx(false);
  }
}

void changeAutoTuney()
{
  if(!tuningy)
  {
    //Set the output to the desired starting frequency.
    Outputy=aTuneStartValuey;
    aTuney.SetNoiseBand(aTuneNoisey);
    aTuney.SetOutputStep(aTuneStepy);
    aTuney.SetLookbackSec((int)aTuneLookBack);
    AutoTuneHelpery(true);
    tuningy = true;
  }
  else
  { //cancel autotune
    aTuney.Cancel();
    tuningy = false;
    AutoTuneHelpery(false);
  }
}

void AutoTuneHelperx(boolean startx)
{
  if(startx)
    ATuneModeRememberx = myPIDx.GetMode();
  else
    myPIDx.SetMode(ATuneModeRememberx);
}

void AutoTuneHelpery(boolean starty)
{
  if(starty)
    ATuneModeRemembery = myPIDy.GetMode();
  else
    myPIDy.SetMode(ATuneModeRemembery);
}

void SerialSend()
{
  Serial.print("setpointx: ");
  Serial.print(Setpointx);
  Serial.print("setpointy: ");
  Serial.print(Setpointy);  
  Serial.print(" ");
  Serial.print("inputx: ");
  Serial.print(Inputx);
  Serial.print(" ");
  Serial.print("inputy: ");
  Serial.print(Inputy); 
  Serial.print(" ");
  Serial.print("outputx: ");
  Serial.print(Outputx); 
  Serial.print(" ");
  Serial.print("outputy: ");
  Serial.print(Outputy); 
  Serial.print(" ");
  if(tuningx){
    Serial.println("tuning mode x");
  } 
  else {
    Serial.print("kpx: ");
    Serial.print(myPIDx.GetKp());
    Serial.print(" ");
    Serial.print("kix: ");
    Serial.print(myPIDx.GetKi());
    Serial.print(" ");
    Serial.print("kdx: ");
    Serial.print(myPIDx.GetKd());
    Serial.println();
  }
  if(tuningy){
    Serial.println("tuning mode y");
  } 
  else {
    Serial.print("kpy: ");
    Serial.print(myPIDy.GetKp());
    Serial.print(" ");
    Serial.print("kiy: ");
    Serial.print(myPIDy.GetKi());
    Serial.print(" ");
    Serial.print("kdy: ");
    Serial.print(myPIDy.GetKd());
    Serial.println();
  }
}

void SerialReceivex()
{
  if(Serial.available())
  {
    char b = Serial.read(); 
    Serial.flush(); 
    if((b=='1' && !tuningx) || (b!='1' && tuningx))changeAutoTunex();
  }
}

void SerialReceivey()
{
  if(Serial.available())
  {
    char b = Serial.read(); 
    Serial.flush(); 
    if((b=='1' && !tuningy) || (b!='1' && tuningy))changeAutoTuney();
  }
}

void isort(int *a, int n){
  // *a is an array pointer function
  for (int i = 1; i < n; ++i)
  {
    int j = a[i];
    int k;
    for (k = i - 1; (k >= 0) && (j < a[k]); k--)
    {
      a[k + 1] = a[k];
    }
    a[k + 1] = j;
  }
}

//Mode function, returning the mode or median.
int mode(int *x,int n){
  int i = 0;
  int count = 0;
  int maxCount = 0;
  int mode = 0;
  int bimodal;
  int prevCount = 0;
  while(i<(n-1)){
    prevCount=count;
    count=0;
    while(x[i]==x[i+1]){
      count++;
      i++;
    }
    if(count>prevCount&count>maxCount){
      mode=x[i];
      maxCount=count;
      bimodal=0;
    }
    if(count==0){
      i++;
    }
    if(count==maxCount){//If the dataset has 2 or more modes.
      bimodal=1;
    }
    if(mode==0||bimodal==1){//Return the median if there is no mode.
      mode=x[(n/2)];
    }
    return mode;
  }
}




