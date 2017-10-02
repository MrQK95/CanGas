#include <mega32a.h>
#include <stdio.h>
#include <delay.h>
#define Data PORTA
#define LEDPORT PORTB
#define H1 PORTC.2
#define H2 PORTC.3
#define H3 PORTC.4
#define H4 PORTC.5
#define H5 PORTC.6
#define C1 PIND.3
#define C2 PIND.4
#define C3 PIND.5
#define C4 PIND.6
#define C5 PIND.7
#define Coi PORTC.7
#define Opto PORTB.0

unsigned char so[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
char led[3][5] = {{0x0E,0x16,0x06,0x1A,0x0A},
                  {0x12,0x02,0x1C,0x0C,0x14},
                  {0x04,0x18,0x08,0x10,0x00}};
unsigned char chu[7][5]={{0x5E,0x78,0x5F,0x30,0x38}, //dtail
                        {0x79,0x00,0x3D,0x77,0x6D}, //T Gas
                        {0x79,0x00,0x39,0x77,0x54}, //T Can
                        {0x6D,0x39,0x77,0x38,0x79}, //SCALE
                        {0x6D,0x79,0x78,0x00,0x00}, //SEt
                        {0x79,0x50,0x50,0x5C,0x50}, //Error
                        {0x00,0x00,0x00,0x00,0x00}};

unsigned char Recive;     //UART

long OFFSET=0;
int SCALE=718.0;
unsigned char blink=0;
float T_gas=0;
unsigned int T_can=0;
int SETUP_W=0;

//void RX();
void TX(char x);
void UART_Init();
void GPIO_Init();
void TIM1_Init();
float get_units(char times);
void tare(char times);
char quetphim();
void hienso(unsigned char a, float s);
void hienso_int(unsigned char a,unsigned long h);
void start();
void Details();
void Smart_conf();
void Set_scale();

//interrupt [USART_RXC] void usart_rx_isr(void)   {if(UCSRA.7==1)  Recive=UDR;}

interrupt [TIM1_OVF] void timer1_ovf_isr(void){
    static char dk_sent=0;
    blink++;
    dk_sent++;
    //Coi=~Coi;
    if(blink>2) blink=0;
    TX(49);
    //if(dk_sent>29) {TX(' '); dk_sent=0;} //Gui du lieu len Server sau 30s
    TCNT1H=0xD5;
    TCNT1L=0xCF;
}
void main(void){
    //float c_value=0;
    GPIO_Init();
    UART_Init();
    TIM1_Init();
    //start();
    while (1)
    {
        hienso_int(0,12345);
        hienso_int(1,11111);
        hienso_int(2,88888);
        /*
         Coi=1;
         delay_ms(100);
         Coi=0;
         delay_ms(100);
         //c_value=get_units(20);

         //TX(quetphim());
         //TX('a');
         //delay_ms(100);

         hienso(0,c_value);
         hienso(1,SETUP_W);
         hienso(2,SETUP_W-c_value);
         switch(quetphim()){
            case 'T':{          //nut Total
                Details();
                break;
            }
            case 'Z':{          //nut Zero
                tare(20);
                break;
            }
            case 'C':{         //nut Cal
                Smart_conf();
                break;
            }
            case 'F':{         //nut SF/SC
                Set_scale();
                break;
            }
         }
         */
    }
}

void GPIO_Init(){
    DDRA=0xFF;
    PORTA=0;
    DDRB=0xFF;
    PORTB=0xFF;
    DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (0<<DDC0);
    PORTC=(0<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (0<<PORTC1) | (1<<PORTC0);
    DDRD=0;
    PORTD=0xFF;
}

void UART_Init(){
    UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
    UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
    UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
    UBRRH=0x00;
    UBRRL=0x47;
}

void TIM1_Init(){
    TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
    TCNT1H=0xD5;
    TCNT1L=0xCF;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;
    MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
    MCUCSR=(0<<ISC2);
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
    #asm("sei")
}


void hienso(unsigned char a, float s){
    int h;
    char p,b;
    int tr,ch,dv,tp1,tp2;
    if(s<1000){
        h = s*100;
        p=0x80;
        b=0x00;
    }
    else{
        if((s>=1000)&&(s<10000)){
            h=s*10;
            p=0x00;
            b=0x80;
        }
        else{
            h=s;
            p=0x00;
            b=0x00;
        }
    }
    tr = h/10000;
    ch = (h%10000)/1000;
    dv = (h%1000)/100;
    tp1 = (h%100)/10;
    tp2 = h%10;
    LEDPORT = (LEDPORT&0xE1)|led[a][0];
    Data = so[tr];
    delay_ms(1);
    LEDPORT = (LEDPORT&0xE1)|led[a][1];
    Data = so[ch];
    delay_ms(1);
    LEDPORT = (LEDPORT&0xE1)|led[a][2];
    Data = so[dv]|p;
    delay_ms(1);
    LEDPORT = (LEDPORT&0xE1)|led[a][3];
    Data = so[tp1]|b;
    delay_ms(1);
    LEDPORT = (LEDPORT&0xE1)|led[a][4];
    Data = so[tp2];
    delay_ms(1);
}

void hienso_int(unsigned char a,unsigned long h){
    int tr,ch,dv,tp1,tp2;
    tr = h/10000;
    ch = (h%10000)/1000;
    dv = (h%1000)/100;
    tp1 = (h%100)/10;
    tp2 = h%10;
    LEDPORT = (LEDPORT&0xE1)|led[a][0];
    Data = so[tr];
    delay_ms(1);
    LEDPORT = (LEDPORT&0xE1)|led[a][1];
    Data = so[ch];
    delay_ms(1);
    LEDPORT = (LEDPORT&0xE1)|led[a][2];
    Data = so[dv];
    delay_ms(1);
    LEDPORT = (LEDPORT&0xE1)|led[a][3];
    Data = so[tp1];
    delay_ms(1);
    LEDPORT = (LEDPORT&0xE1)|led[a][4];
    Data = so[tp2];
    delay_ms(1);
}

void hienso_start(unsigned char h){
    unsigned char i;
    for(i=0;i<5;i++){
        LEDPORT = (LEDPORT&0xE1)|led[0][i];
        Data = so[h];
        LEDPORT = (LEDPORT&0xE1)|led[1][i];
        Data = so[h];
        LEDPORT = (LEDPORT&0xE1)|led[2][i];
        Data = so[h];
        delay_ms(1);
    }
}

void hien_chu(unsigned char a,unsigned char b){         //dong, chu
    unsigned char i;
    for(i=0;i<5;i++){
        LEDPORT = (LEDPORT&0xE1)|led[a][i];
        Data = chu[b][i];
        delay_ms(1);
    }
}

char quetphim(){
    char key = 255;
    H1 = 0; H2 = 1; H3 = 1; H4 = 1; H5 = 1;
    if(C1==0)   key = 'a';   //24.00
    if(C2==0)   key = 'b';   //25.00
    if(C3==0)   key = 'c';   //26.00
    if(C4==0)   key = 'd';   //80.00
    if(C5==0)   key = 'e';   //90.00

    H1 = 1; H2 = 0; H3 = 1; H4 = 1; H5 = 1;
    if(C1==0)   key = 'T';   //Total
    if(C2==0)   key = 1;
    if(C3==0)   key = 2;
    if(C4==0)   key = 3;
    if(C5==0)   key = 4;

    H1 = 1; H2 = 1; H3 = 0; H4 = 1; H5 = 1;
    if(C1==0)   key = 'Z';   //Zero
    if(C2==0)   key = 5;
    if(C3==0)   key = 6;
    if(C4==0)   key = 7;
    if(C5==0)   key = 8;

    H1 = 1; H2 = 1; H3 = 1; H4 = 0; H5 = 1;
    if(C1==0)   key = 'C';  //Cal
    if(C2==0)   key = 'E';  //exit
    if(C3==0)   key = 'c';  //Clear
    if(C4==0)   key = 9;
    if(C5==0)   key = 0;

    H1 = 1; H2 = 1; H3 = 1; H4 = 1; H5 = 0;
    if(C1==0)   key = 'F';  //SF/SC
    if(C2==0)   key = 'P';  //Pro
    if(C3==0)   key = 'e';  //Enter
    if(C4==0)   key = 'S';  //Stop
    if(C5==0)   key = 's';  //Start

    return key;
}

void TX(char x){
    while(UCSRA.5==0);
    UDR=x;
}

//void RX(){  if(UCSRA.7==1){Recive=UDR;}   }

unsigned long HX_read(){
    unsigned long value = 0;
    unsigned char i=0;
    PORTC.4=0;
    PORTC.5=0;
    for(i=0;i<24;i++){
        PORTC.1=1;
        value=value*2;
        PORTC.1=0;
        if(PINC.0) value++;
    }
    PORTC.1=1;
    value=value^0x800000;
    PORTC.1=0;
    return value;
}

float read_average(char times){
    float sum = 0;
    char i=0;
    for (i = 0; i < times; i++) {sum += HX_read();}
    return sum / times;
}

float get_value(char times){
    float tem;
    tem = read_average(times) - OFFSET;
    if(tem<0) tem=0;
    return  tem;
}

float get_units(char times){return get_value(times)/SCALE;}

void tare(char times){
     unsigned long sum=read_average(times);
     OFFSET=sum;
}

void start(){
    unsigned char i,j;
    get_units(20);
    tare(20);
    for(i=0;i<10;){
        hienso_start(i);
        j=blink;
        if(blink!=j) i++;       //sau 1s doi 1 lan
    }
}

void Details(){
    unsigned char state=0,dk=0,key;
    while(1){
        key=quetphim();
        if((blink==1)&&(dk==0)) {
            state=~state;
            dk=1;
        }
        if(blink==2) dk=0;
        if(state){
            hien_chu(0,0);  //dòng 1 hien dtail
            hien_chu(1,1);  //dòng 2 hien T Gas
            hien_chu(2,2);  //dong 3 hien T Can
         }
        else{
            hienso_int(1,T_gas);
            hienso_int(2,T_can);
        }
        if(key=='c'){       //nut clear
            while(1){
                key=quetphim();
                hien_chu(0,0);
                hienso_int(1,T_gas);
                hienso_int(2,T_can);
                if(key=='E') break;
                if(key=='e'){
                    T_gas=0;
                    T_can=0;
                    break;
                }
            }
        }
        if(key=='E') break;
    }
}

void Smart_conf(){
     ;
}

void Set_scale(){
    unsigned char key,x=4;
    int temp=0;
     while(1){
        key=quetphim();
        hien_chu(0,x);      //dong 1 hien SEt
        hien_chu(1,3);      //dong 2 hien SCALE
        hienso(2,temp);
        if(key<10){
            x=4;
            hien_chu(0,4);
            hien_chu(1,3);
            hienso_int(2,temp);
            temp=temp*10+key;
            if(temp>=1000) temp=temp%1000;
        }
        if(key=='E') break;
        if(key=='e'){
            if(temp==0)  x=5;  //Error
            else{
                SCALE=get_value(20)/temp;
            }
        }
     }
}

/*
void setup(){
    char dk=1;
    while(dk){
        switch(quetphim()){
            case '
            case 'E': dk=0;break;
        }
    }
}*/