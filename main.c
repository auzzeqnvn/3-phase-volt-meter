/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 3 phase Volt Meter
Version : 1.0
Date    : 15/11/2018
Author  : 
Company : 
Comments: 

Chip type               : ATmega8L
Program type            : Application
AVR Core Clock frequency: 11,059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega8.h>
#include "delay.h"
#include "SPI_SOFTWARE.h"
#include "ADE7753.h"

#define     RS    1
#define     ST    2
#define     TR    3
#define     RN    4
#define     SN    5
#define     TN    6

#define     RS_INPUT    PINC.0
#define     ST_INPUT    PINC.1
#define     TR_INPUT    PINC.2
#define     RN_INPUT    PINC.3
#define     SN_INPUT    PINC.4
#define     TN_INPUT    PINC.5

#define     SELECT_S0   PORTD.1
#define     SELECT_S1   PORTD.2
#define     SELECT_S2   PORTD.3

#define     BUZZER      PORTD.0

#define     BUZZER_ON   BUZZER = 1
#define     BUZZER_OFF   BUZZER = 0

/* So luong mau */
#define     NUM_SAMPLE  40
/* So luong mau loai do noise 2*NUM_FILTER = LOW_NOISE + HIGH_NOISE */
#define     NUM_FILTER  13
/* Thoi gian lay mau 10ms*TIME_GET_SAMPLE */
#define     TIME_GET_SAMPLE   3
/* 10ms*TIME_GET_SAMPLE*(NUM_SAMPLE-NUM_FILTER) */

/* Thoi gian cap nhat gia tri hien thi 4,44ms*TIME_UPDATE_DISPLAY */
#define     TIME_UPDATE_DISPLAY     200

/* He so cac gia tri doc duoc tu ADE7753*/
#define     SR_RATIO    266  
#define     ST_RATIO    244
#define     TR_RATIO    252
#define     RN_RATIO    276
#define     SN_RATIO    258
#define     TN_RATIO    229

//global variables here
unsigned char     led_cnt = 1;
unsigned char     data_led;
unsigned char     data_single_led = 0xff;
unsigned int      data = 0;
unsigned long      data_temp = 0;
unsigned long int      data_buff[NUM_SAMPLE];
unsigned char     buff_cnt = 0;
unsigned char     loop_cnt = 0;
unsigned char     loop_read_cnt = 0;
unsigned char     loop_timer = 0;
unsigned char     Uc_Last_Select;





void    SCAN_LED(unsigned char num_led,unsigned char    data_in);
void  READ_SELECT(void);
// Timer1 overflow interrupt service routine
/* 4,44 ms */
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Reinitialize Timer1 value
      TCNT1H=0xE800 >> 8;
      TCNT1L=0xE800 & 0xff;
      
      if(led_cnt == 1)  data_led = data/1000;
      else if(led_cnt == 2)  data_led = data%1000/100;
      else if(led_cnt == 3)  data_led = data%100/10;
      else if(led_cnt == 4)  data_led = data%10;
      else if(led_cnt == 5)   data_led = data_single_led;

      SCAN_LED(led_cnt++,data_led);
      if(led_cnt > 5)   led_cnt = 1;
      if(loop_timer < TIME_UPDATE_DISPLAY)    loop_timer++;
}

void    SCAN_LED(unsigned char num_led,unsigned char    data_in)
{
    unsigned char   byte1,byte2;
    byte1 = 0xFF;
    byte2 = 0;

      switch(data_in)
      {
        case    0:
        {
            byte1 = 0x05;
            break;
        }
        case    1:
        {
            byte1 = 0x7D;
            break;
        }
        case    2:
        {
            byte1 = 0x46;
            break;
        }
        case    3:
        {
            byte1 = 0x54;
            break;
        }
        case    4:
        {
            byte1 = 0x3C;
            break;
        }
        case    5:
        {
            byte1 = 0x94;
            break;
        }
        case    6:
        {
            byte1 = 0x84;
            break;
        }
        case    7:
        {
            byte1 = 0x5D;
            break;
        }
        case    8:
        {
            byte1 = 0x04;
            break;
        }
        case    9:
        {
            byte1 = 0x14;
            break;
        }
    }


    switch(num_led)
    {
        case    1:
        {
            byte2 = 0xFD;
            break;
        }
        case    2:
        {
            byte2 = 0xFB;
            break;
        }
        case    3:
        {
            byte2 = 0xF7;
            byte1 &= 0xFB;
            break;
        }
        case    4:
        {
            byte2 = 0xDF;
            break;
        }
        case    5:
        {
              byte2 = 0xBF;
              byte1 = data_in;
              break;
        }
    }
    
    SPI_SENDBYTE(byte2,0);
    SPI_SENDBYTE(byte1,1);
}

void LED_SELECT(unsigned char      led)
{      
      
      if( Uc_Last_Select != led)
      {
            BUZZER_ON;
            delay_ms(50);
            BUZZER_OFF;
            delay_ms(50);
            Uc_Last_Select = led;
      }
      
      switch(led)
      {
            case RS:
            {
                  data_single_led = 0xDF;
                  break;
            }
            case ST:
            {
                  data_single_led = 0xEF;
                  break;
            }
            case TR:
            {
                  data_single_led = 0xF7;
                  break;
            }
            case RN:
            {
                  data_single_led = 0xFB;
                  break;
            }
            case SN:
            {
                  data_single_led = 0xFD;
                  break;
            }
            case TN:
            {
                  data_single_led = 0xFE;
                  break;
            }
      }
}

void  SELECT_INPUT(unsigned char    num)
{
      switch(num)
      {
            case 0:
            {
                  SELECT_S0 = 0;
                  SELECT_S1 = 0;
                  SELECT_S2 = 0;
                  break;
            }
            case 1:
            {
                  SELECT_S0 = 1;
                  SELECT_S1 = 0;
                  SELECT_S2 = 0;
                  break;
            }
            case 2:
            {
                  SELECT_S0 = 0;
                  SELECT_S1 = 1;
                  SELECT_S2 = 0;
                  break;
            }
            case 3:
            {
                  SELECT_S0 = 1;
                  SELECT_S1 = 1;
                  SELECT_S2 = 0;
                  break;
            }
            case 4:
            {
                  SELECT_S0 = 0;
                  SELECT_S1 = 0;
                  SELECT_S2 = 1;
                  break;
            }
            case 5:
            {
                  SELECT_S0 = 1;
                  SELECT_S1 = 0;
                  SELECT_S2 = 1;
                  break;
            }
            case 6:
            {
                  SELECT_S0 = 0;
                  SELECT_S1 = 1;
                  SELECT_S2 = 1;
                  break;
            }
            case 7:
            {
                  SELECT_S0 = 1;
                  SELECT_S1 = 1;
                  SELECT_S2 = 1;
                  break;
            }
      }
}

void  SELECT_INPUT_COMPARE(unsigned char  input)
{
      switch(input)
      {
            case RS:
            {
                  SELECT_INPUT(1);
                  break;
            }
            case ST:
            {
                  SELECT_INPUT(3);
                  break;
            }
            case TR:
            {
                  SELECT_INPUT(5);
                  break;
            }
            case RN:
            {
                  SELECT_INPUT(0);
                  break;
            }
            case SN:
            {
                  SELECT_INPUT(2);
                  break;
            }
            case TN:
            {
                  SELECT_INPUT(4);
                  break;
            }
      }
}

void  READ_SELECT(void)
{
     unsigned long int Uint_data_temp[40];
     unsigned char Uc_temp_cnt;
     unsigned int Uint_temp;
     unsigned int data_temp2;
      if(!RS_INPUT)
      {
            LED_SELECT(RS);
            SELECT_INPUT_COMPARE(RS);
            if(loop_read_cnt > TIME_GET_SAMPLE)
            {
                  // data = ADE7753_READ(1,VRMS)/253;
                  loop_read_cnt = 0;
                  data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
                  if(buff_cnt >= NUM_SAMPLE)      
                  {
                        buff_cnt = 0;
                  }
                  data_temp = 0;
                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        data_temp += data_buff[loop_cnt];
                  }

                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
                  }
                  
                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<NUM_SAMPLE;Uc_temp_cnt++)
                        {
                              if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
                              {
                                    Uint_temp = Uint_data_temp[loop_cnt];
                                    Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
                                    Uint_data_temp[Uc_temp_cnt] = Uint_temp;
                              }
                        }
                  }

                  data_temp = 0;
                  for(loop_cnt = NUM_FILTER;loop_cnt<NUM_SAMPLE-NUM_FILTER;loop_cnt++)
                  {
                        data_temp += data_buff[loop_cnt];
                  }
                  //data = (unsigned int)data_temp/6;
                  if(loop_timer == TIME_UPDATE_DISPLAY)
                  {
                        loop_timer = 0;
                        data_temp2 = (unsigned int)(data_temp/SR_RATIO)/(NUM_SAMPLE-2*NUM_FILTER);
                        if(data_temp2 > 100)    data = data_temp2; 
                        else data = 0;
                  }
            }
      }
      else if(!ST_INPUT)
      {
            LED_SELECT(ST);
            SELECT_INPUT_COMPARE(ST);
            if(loop_read_cnt > TIME_GET_SAMPLE)
            {
                  // data = ADE7753_READ(1,VRMS)/253;
                  loop_read_cnt = 0;
                  data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
                  if(buff_cnt >= NUM_SAMPLE)      
                  {
                        buff_cnt = 0;
                  }
                  data_temp = 0;
                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        data_temp += data_buff[loop_cnt];
                  }

                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
                  }
                  
                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<NUM_SAMPLE;Uc_temp_cnt++)
                        {
                              if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
                              {
                                    Uint_temp = Uint_data_temp[loop_cnt];
                                    Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
                                    Uint_data_temp[Uc_temp_cnt] = Uint_temp;
                              }
                        }
                  }

                  data_temp = 0;
                  for(loop_cnt = NUM_FILTER;loop_cnt<NUM_SAMPLE-NUM_FILTER;loop_cnt++)
                  {
                        data_temp += data_buff[loop_cnt];
                  }
                  //data = (unsigned int)data_temp/6;
                  if(loop_timer == TIME_UPDATE_DISPLAY)
                  {
                        loop_timer = 0;
                        data_temp2 = (unsigned int)(data_temp/ST_RATIO)/(NUM_SAMPLE-2*NUM_FILTER); 
                        if(data_temp2 > 100)    data = data_temp2; 
                        else data = 0;
                  }  
            }
      }
      else if(!TR_INPUT)
      {
            LED_SELECT(TR);
            SELECT_INPUT_COMPARE(TR);
            if(loop_read_cnt > TIME_GET_SAMPLE)
            {
                  // data = ADE7753_READ(1,VRMS)/253;
                  loop_read_cnt = 0;
                  data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
                  if(buff_cnt >= NUM_SAMPLE)      
                  {
                        buff_cnt = 0;
                  }
                  data_temp = 0;
                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        data_temp += data_buff[loop_cnt];
                  }

                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
                  }
                  
                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<NUM_SAMPLE;Uc_temp_cnt++)
                        {
                              if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
                              {
                                    Uint_temp = Uint_data_temp[loop_cnt];
                                    Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
                                    Uint_data_temp[Uc_temp_cnt] = Uint_temp;
                              }
                        }
                  }

                  data_temp = 0;
                  for(loop_cnt = NUM_FILTER;loop_cnt<NUM_SAMPLE-NUM_FILTER;loop_cnt++)
                  {
                        data_temp += data_buff[loop_cnt];
                  }
                  if(loop_timer == TIME_UPDATE_DISPLAY)
                  {
                        loop_timer = 0;
                        data_temp2 = (unsigned int)(data_temp/TR_RATIO)/(NUM_SAMPLE-2*NUM_FILTER);    
                        if(data_temp2 > 100)    data = data_temp2; 
                        else data = 0;
                  }
            }
      }
      else if(!RN_INPUT)
      {
            LED_SELECT(RN);
            SELECT_INPUT_COMPARE(RN);
           if(loop_read_cnt > TIME_GET_SAMPLE)
            {
                  loop_read_cnt = 0;
                  data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
                  if(buff_cnt >= NUM_SAMPLE)      
                  {
                        buff_cnt = 0;
                  }
                  data_temp = 0;
                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        data_temp += data_buff[loop_cnt];
                  }

                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
                  }
                  
                  for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
                  {
                        for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<NUM_SAMPLE;Uc_temp_cnt++)
                        {
                              if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
                              {
                                    Uint_temp = Uint_data_temp[loop_cnt];
                                    Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
                                    Uint_data_temp[Uc_temp_cnt] = Uint_temp;
                              }
                        }
                  }

                  data_temp = 0;
                  for(loop_cnt = NUM_FILTER;loop_cnt<(NUM_SAMPLE-NUM_FILTER);loop_cnt++)
                  {
                        data_temp += data_buff[loop_cnt];
                  }
                  if(loop_timer == TIME_UPDATE_DISPLAY)
                  {
                        loop_timer = 0;
                        data_temp2 = (unsigned int)(data_temp/RN_RATIO)/(NUM_SAMPLE-2*NUM_FILTER);
                        if(data_temp2 > 100)    data = data_temp2; 
                        else data = 0;
                  }
            }
            
      }
      else if(!SN_INPUT)
      {
            LED_SELECT(SN);
            SELECT_INPUT_COMPARE(SN);
            if(loop_read_cnt > TIME_GET_SAMPLE)
            {
                  loop_read_cnt = 0;
                  data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
                  if(buff_cnt >= NUM_SAMPLE)      
                  {
                        buff_cnt = 0;
                  }
                  data_temp = 0;
                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        data_temp += data_buff[loop_cnt];
                  }

                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
                  }
                  
                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<NUM_SAMPLE;Uc_temp_cnt++)
                        {
                              if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
                              {
                                    Uint_temp = Uint_data_temp[loop_cnt];
                                    Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
                                    Uint_data_temp[Uc_temp_cnt] = Uint_temp;
                              }
                        }
                  }

                  data_temp = 0;
                  for(loop_cnt = NUM_FILTER;loop_cnt<(NUM_SAMPLE-NUM_FILTER);loop_cnt++)
                  {
                        data_temp += data_buff[loop_cnt];
                  }
                  if(loop_timer == TIME_UPDATE_DISPLAY)
                  {
                        loop_timer = 0;
                        data_temp2 = (unsigned int)(data_temp/SN_RATIO)/(NUM_SAMPLE-2*NUM_FILTER);
                        if(data_temp2 > 100)    data = data_temp2; 
                        else data = 0;
                  }
            }
      }
      else if(!TN_INPUT)
      {
            LED_SELECT(TN);
            SELECT_INPUT_COMPARE(TN);
            if(loop_read_cnt > TIME_GET_SAMPLE)
            {
                  loop_read_cnt = 0;
                  data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
                  if(buff_cnt >= NUM_SAMPLE)      
                  {
                        buff_cnt = 0;
                  }
                  data_temp = 0;
                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        data_temp += data_buff[loop_cnt];
                  }

                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
                  }
                  
                  for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
                  {
                        for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<NUM_SAMPLE;Uc_temp_cnt++)
                        {
                              if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
                              {
                                    Uint_temp = Uint_data_temp[loop_cnt];
                                    Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
                                    Uint_data_temp[Uc_temp_cnt] = Uint_temp;
                              }
                        }
                  }

                  data_temp = 0;
                  for(loop_cnt = NUM_FILTER;loop_cnt<(NUM_SAMPLE-NUM_FILTER);loop_cnt++)
                  {
                        data_temp += data_buff[loop_cnt];
                  }
                  if(loop_timer == TIME_UPDATE_DISPLAY)
                  {
                        loop_timer = 0;
                        data_temp2 = (unsigned int)(data_temp/TN_RATIO)/(NUM_SAMPLE-2*NUM_FILTER);
                        if(data_temp2 > 100)    data = data_temp2; 
                        else data = 0;
                  }
            }
      }
      
      delay_ms(10);
      loop_read_cnt++;

}




void main(void)
{
// Declare your local variables here
unsigned long int   reg = 0;
// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=Out Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=T Bit1=0 Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P 
PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=In Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(1<<DDD7) | (1<<DDD6) | (0<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=T Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1382,400 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 5,9997 ms
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
TCNT1H=0xDF;
TCNT1L=0x9A;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Global enable interrupts
#asm("sei")
data = 8888;
reg = 0; 
reg |= (1<<SWRST);
ADE7753_WRITE(1,MODE,(reg>>8) & 0xFF,reg & 0xFF,0x00);
delay_ms(500);
reg = ADE7753_READ(1,MODE);

reg = ADE7753_READ(1,MODE);
reg |= (1<<WAVSEL0) | (1<<WAVSEL1) | (1<<DTRT0) | (1<<DTRT1) ;
ADE7753_WRITE(1,MODE,(reg>>8) & 0xFF,reg & 0xFF,0x00);
reg = ADE7753_READ(1,MODE);

delay_ms(500);
ADE7753_WRITE(1,SAGLVL,0X2a,0X00,0X00);
delay_ms(500);
ADE7753_WRITE(1,SAGCYC,0XFF,0X00,0X00);
delay_ms(500);

BUZZER_ON;
delay_ms(100);
BUZZER_OFF;
      while (1)
      {
      // Place your code here
            READ_SELECT();
      }
}
