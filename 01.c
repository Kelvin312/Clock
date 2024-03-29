/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 15.09.2015
Author  : 
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 1,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>

#define RD1 PORTC.4
#define RD2 PORTC.2
#define RD3 PORTC.0
#define RD4 PORTC.1
#define RD5 PORTB.1
#define RD6 PORTD.7
#define RD7 PORTD.6
#define RD8 PORTD.5
#define RD9 PORTD.3
#define RD10 PORTD.1
#define RD11 PORTD.0
#define RD12 PORTC.5
#define LINE2 PORTB.0 
#define LINE1 PORTD.4
#define BTN2 PIND.2
#define BTN1 PINC.3

#define MAX_TIME_OFF (20*1000)

char time[3]={0,0,0};
char timeSec=0, timeMin=0;
char  indSwap=0, isIndEnable=1;
char btn1state = 0, btn1PressTime = 0, btn2PressTime = 0, btn2state=1;
char migMig=0;
int indState, timeOff=0;



// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)  //1ms
{
// Reinitialize Timer 0 value
TCNT0=0x83;

// Place your code here
if(BTN1 == 0)
{
  timeOff = 0;
  if(btn1PressTime == 50) //����������� ���������
  {
      btn1PressTime = 0; 
      if(++btn1state>3) btn1state=0;
  }
}
else
{
  if(btn1PressTime<50)btn1PressTime++;
}

if(BTN2 == 0)
{
   timeOff = 0; 
   if(++btn2PressTime > 250)
   {
      btn2PressTime = 0;
      switch(btn1state) 
      {
        case 0: 
          if(--btn2state>1)btn2state=1;
        break; 
        case 1: 
        if(++time[0]>11)
        {
            time[0] = 0; 
            if(++timeMin>4)
            { 
                  timeMin  = 0;
                  if(++time[1] > 11)
                  {
                        time[1] = 0;
                        if(++time[2]>11)
                        {
                            time[2]=0;
                        }
                  }
            }
        }
        break;
        case 2:
            if(++time[1] > 11)
            {
              time[1] = 0;
              if(++time[2]>11)
              {
                  time[2]=0;
              }
            } 
        break;
        case 3:
              if(++time[2]>11)
              {
                  time[2]=0;
              }
        break;
      }
   }
}
else
{
   btn2PressTime = 240; //����������� ���������
}


if(++timeOff < MAX_TIME_OFF)
{
    if(btn1state==0)
    { 
        indSwap &= 1; indSwap ^= 1; 
        indState = (int)1<<time[indSwap + btn2state];
    } 
    else 
    {
    btn2state=1;
    if(btn1state==1) indSwap = 0;        
    if(btn1state==2) indSwap = 1; 
    if(btn1state==3) indSwap = 2;        
    indState = (int)1<<time[indSwap];
    }
    LINE1 = 0;
    LINE2 = 0;
    RD1 = (indState>>0)&1; 
    RD2 = (indState>>1)&1;
    RD3 = (indState>>2)&1;
    RD4 = (indState>>3)&1;
    RD5 = (indState>>4)&1;
    RD6 = (indState>>5)&1;
    RD7 = (indState>>6)&1;
    RD8 = (indState>>7)&1;
    RD9 = (indState>>8)&1;
    RD10 = (indState>>9)&1;
    RD11 = (indState>>10)&1;
    RD12 = (indState>>11)&1;
    
    if(btn1state==0 || migMig>125) // �������
    {  
      LINE1 = indSwap&1;
      LINE2 = (indSwap&1)^1; 
    }
    if(++migMig>250) migMig=0;
}
else
{
    btn2state=1;
    isIndEnable = 0;
    btn1state = 0;
    RD1 = 0;     //��������� ����������
    RD2 = 0;
    RD3 = 0;
    RD4 = 0;
    RD5 = 0;
    RD6 = 0;
    RD7 = 0;
    RD8 = 0;
    RD9 = 0;
    RD10 = 0;
    RD11 = 0;
    RD12 = 0;
    LINE1 = 0;
    LINE2 = 0;
    
}
    
}

// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
    #asm("wdr") 
    
if(btn1state==0 && ++timeSec > 4) //������� �����, ���� ������ ������ = 0
{
    timeSec = 0;
    if(++time[0]>11)
    {
        time[0] = 0; 
        if(++timeMin>4)
        { 
              timeMin  = 0;
              if(++time[1] > 11)
              {
                    time[1] = 0;
                    if(++time[2]>11)
                    {
                        time[2]=0;
                    }
              }
        }
    }
}
    
    if(!isIndEnable) //���� �����
    {
        btn1state = 0; 
        TCCR0=0x00; //��������� ������ 0, ��� �������� �������
        GICR|=0x40; //�������� INT0, ���� ��������� �� ������
        GIFR|=0x40; //���������� ���� ���������� INT0
        TIFR|=0x41; //���������� ���� ���������� ��������   
        #asm("sei") //��������� ���������� ���������
        MCUCR |= 128; //��������� ���
        #asm("sleep") //����
    }
}


// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
  //�����������
  MCUCR &= ~128; //��������� ����� (�� �����) 
  GICR&= ~0x40;   // ��������� INT0, ���� �� ������ � ��� �����
  GIFR|= 0x40;    // ���������� ���� (�� ���� ������)
  TCCR0=0x02;     // ��������� ������ 0
  TCNT0=0x83;
  isIndEnable = 1; //�������� ���������
}


// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=0 
PORTB=0x00;
DDRB=0x03;

// Port C initialization
// Func6=In Func5=Out Func4=Out Func3=In Func2=Out Func1=Out Func0=Out 
// State6=T State5=0 State4=0 State3=P State2=0 State1=0 State0=0 
PORTC=0x08;
DDRC=0x37;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=P State1=0 State0=0 
PORTD=0x04;
DDRD=0xFB;


// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 125,000 kHz
TCCR0=0x02;
TCNT0=0x83;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: TOSC1 pin
// Clock value: PCK2/128
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x08;
TCCR2=0x05;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Low level
// INT1: Off
GICR|=0x40;
MCUCR=0x00;
GIFR=0x40;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x41;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/2048k
#pragma optsize-
//WDTCR=0x1F;
//WDTCR=0x0F;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

MCUCR |= 0b00110000; //Power-save

// Global enable interrupts
#asm("sei")

while (1)
      {
      

      }
}
