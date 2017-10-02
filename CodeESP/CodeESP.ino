#include <EEPROM.h>

#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>

#include <ESP8266WiFi.h>
#include <WiFiClient.h>

#include <BlynkSimpleEsp8266.h>

MDNSResponder mdns;
ESP8266WebServer server(80);
WidgetTerminal terminal(V0);

const char *ssid = "ESPap";
const char *password = "123456789";
char auth[] = "b1e3ded572da4af4959bc0a7e9512ce7";

char SID[100];
char SPW[100];

String s, ID, PassWord;
char a = 17;
int ledPin = 4;

unsigned long i = 1;

int EEPROMread(byte a){
  int x = 0;
  while(char(EEPROM.read(30*a+x))!=17){
    x++;
  }
  return x;
}
void reSetStr(char *a){
  int i = 0;
  while(a[i]!=17){
    a[i] = 0;
    i++;
  }
  a[i]=0;
}
void getWifi()
{
  char a = 17;
  
  if(server.hasArg("ssid_in")) {
     ID = server.arg("ssid_in");
  }
  if(server.hasArg("password_in")) {
     PassWord = server.arg("password_in");
  }
  //setWeb();
  
  int i = 0, j = 0;
  int x, y;
  
  ID+=a; 
  PassWord+=a;
  
  while(ID[i]!=17){
    i++;
  }
  while(PassWord[j]!=17){
    j++;
  }
  char *ips = 0;
  char *pw = 0;
  
  for(x=0;x<i;x++){
    SID[x] = ID[x];
    delay(5);
  }
  ips = SID;
  
  for(y=0;y<j;y++){
    SPW[y] = PassWord[y];
    delay(5);
  }
  pw = SPW;
  /*
  Serial.print("Start Connect to ");
  Serial.println(ips);
  Serial.println(pw);*/
  
  WiFi.softAPdisconnect(true);

  delay(2000);
  //Connect to WiFi
  WiFi.begin(ips, pw);
  while(WiFi.status() != WL_CONNECTED){
    //Serial.print(".");
    delay(500);
  }
  SID[i]=17;
  reSetStr(SID);
  SPW[j]=17;
  reSetStr(SPW);
  
  for(x=0;x<i;x++){
    EEPROM.write(x,ips[x]);
    delay(5);
  }
  EEPROM.write(i, a);
  
  for(y=0;y<j;y++){
    EEPROM.write(y+30,pw[y]);
    delay(5);
  }
  EEPROM.write(j+30,a);

  EEPROM.commit();
  
  //Print IP Address
  if (mdns.begin("esp8266", WiFi.localIP())){
    Serial.print('o'); 
  }
  
  server.on("/", [](){
    server.send(200, "text/html", s);
  });
  server.begin();
}
void setup() {
  s += "<html>";
  s += "<title>ESP8266 SMARTCONFIG!</title>";
  s += "<h1>CONNECT TO WIFI!</h1>";
  s += "<form action='/setWifi' method=’POST’>";
  s += "SSID:<input name='ssid_in' value=><br><br>";
  s += "Password:<input name='password_in' value=><br><br>";
  s += "<input type='submit' name='action'   value=Login><br><br></form>";
  s += "</html>";

  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
  pinMode(5, INPUT_PULLUP);

  Serial.begin(9600);
  EEPROM.begin(512);

/*-----------------------------------*/
  if(digitalRead(5)==1){
    delay(20);
    char *ips = 0;
    
    for(int i=0;i<EEPROMread(0);i++){
      SID[i] = EEPROM.read(i);
      delay(5);
    }
    ips = SID;
    
    char *pw = 0;
    for(int j=0;j<EEPROMread(1);j++){
      SPW[j] = EEPROM.read(j+30);
      delay(5);
    }
    pw = SPW;
  
    Blynk.begin(auth, ips, pw);
    terminal.println(F("Blynk v" BLYNK_VERSION ": Device started"));
    
    terminal.flush();
  }
  else
  {
    delay(1000);
    
    WiFi.softAP(ssid, password);
  
    IPAddress myIP = WiFi.softAPIP();
    //Serial.print("AP IP address: ");
    //Serial.println(myIP);
  
    server.on("/", [](){
      server.send(200, "text/html", s);
    });
    server.on("/setWifi",getWifi);
    server.begin();
  }
}

void loop() {
  if(digitalRead(5)==1){
    delay(20);
    while(1){
      Blynk.run();
      if(Serial.available()>0){
        float Data = Serial.read()+0.14;
        if(Data!=10){
          terminal.print(" Can nang lan ");
          terminal.print(i);
          terminal.print(": ");
          terminal.println(Data);
      
          terminal.flush();
          i++;  
        }
      }  
    }
  }
  else{
    while(1){
      server.handleClient();  
    }
  }
}
