
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 11,059200 MHz
;Memory model           : Small
;Optimize for           : Speed
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8A
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _led_cnt=R7
	.DEF _data_led=R6
	.DEF _data_single_led=R9
	.DEF _data=R10
	.DEF _data_msb=R11
	.DEF _buff_cnt=R8
	.DEF _loop_cnt=R13
	.DEF _loop_read_cnt=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1,0x0,0xFF,0x0
	.DB  0x0,0x0,0x0


__GLOBAL_INI_TBL:
	.DW  0x07
	.DW  0x07
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : 3 phase Volt Meter
;Version : 1.0
;Date    : 15/11/2018
;Author  :
;Company :
;Comments:
;
;Chip type               : ATmega8L
;Program type            : Application
;AVR Core Clock frequency: 11,059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "delay.h"
;#include "SPI_SOFTWARE.h"
;#include "ADE7753.h"
;
;#define     RS    1
;#define     ST    2
;#define     TR    3
;#define     RN    4
;#define     SN    5
;#define     TN    6
;
;#define     RS_INPUT    PINC.0
;#define     ST_INPUT    PINC.1
;#define     TR_INPUT    PINC.2
;#define     RN_INPUT    PINC.3
;#define     SN_INPUT    PINC.4
;#define     TN_INPUT    PINC.5
;
;#define     SELECT_S0   PORTD.1
;#define     SELECT_S1   PORTD.2
;#define     SELECT_S2   PORTD.3
;
;#define     BUZZER      PORTD.0
;
;#define     BUZZER_ON   BUZZER = 1
;#define     BUZZER_OFF   BUZZER = 0
;
;/* So luong mau */
;#define     NUM_SAMPLE  40
;/* So luong mau loai do noise 2*NUM_FILTER = LOW_NOISE + HIGH_NOISE */
;#define     NUM_FILTER  13
;/* Thoi gian lay mau 10ms*TIME_GET_SAMPLE */
;#define     TIME_GET_SAMPLE   3
;/* 10ms*TIME_GET_SAMPLE*(NUM_SAMPLE-NUM_FILTER) */
;
;/* Thoi gian cap nhat gia tri hien thi 4,44ms*TIME_UPDATE_DISPLAY */
;#define     TIME_UPDATE_DISPLAY     200
;
;/* He so cac gia tri doc duoc tu ADE7753*/
;#define     SR_RATIO    266
;#define     ST_RATIO    244
;#define     TR_RATIO    252
;#define     RN_RATIO    276
;#define     SN_RATIO    258
;#define     TN_RATIO    229
;
;//global variables here
;unsigned char     led_cnt = 1;
;unsigned char     data_led;
;unsigned char     data_single_led = 0xff;
;unsigned int      data = 0;
;unsigned long      data_temp = 0;
;unsigned long int      data_buff[NUM_SAMPLE];
;unsigned char     buff_cnt = 0;
;unsigned char     loop_cnt = 0;
;unsigned char     loop_read_cnt = 0;
;unsigned char     loop_timer = 0;
;unsigned char     Uc_Last_Select;
;
;
;
;
;
;void    SCAN_LED(unsigned char num_led,unsigned char    data_in);
;void  READ_SELECT(void);
;// Timer1 overflow interrupt service routine
;/* 4,44 ms */
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 005C {

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 005D // Reinitialize Timer1 value
; 0000 005E       TCNT1H=0xE800 >> 8;
	LDI  R30,LOW(232)
	OUT  0x2D,R30
; 0000 005F       TCNT1L=0xE800 & 0xff;
	LDI  R30,LOW(0)
	OUT  0x2C,R30
; 0000 0060 
; 0000 0061       if(led_cnt == 1)  data_led = data/1000;
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x3
	MOVW R26,R10
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	MOV  R6,R30
; 0000 0062       else if(led_cnt == 2)  data_led = data%1000/100;
	RJMP _0x4
_0x3:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x5
	MOVW R26,R10
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __MODW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21U
	MOV  R6,R30
; 0000 0063       else if(led_cnt == 3)  data_led = data%100/10;
	RJMP _0x6
_0x5:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0x7
	MOVW R26,R10
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	MOV  R6,R30
; 0000 0064       else if(led_cnt == 4)  data_led = data%10;
	RJMP _0x8
_0x7:
	LDI  R30,LOW(4)
	CP   R30,R7
	BRNE _0x9
	MOVW R26,R10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	MOV  R6,R30
; 0000 0065       else if(led_cnt == 5)   data_led = data_single_led;
	RJMP _0xA
_0x9:
	LDI  R30,LOW(5)
	CP   R30,R7
	BRNE _0xB
	MOV  R6,R9
; 0000 0066 
; 0000 0067       SCAN_LED(led_cnt++,data_led);
_0xB:
_0xA:
_0x8:
_0x6:
_0x4:
	MOV  R30,R7
	INC  R7
	ST   -Y,R30
	MOV  R26,R6
	RCALL _SCAN_LED
; 0000 0068       if(led_cnt > 5)   led_cnt = 1;
	LDI  R30,LOW(5)
	CP   R30,R7
	BRSH _0xC
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0069       if(loop_timer < TIME_UPDATE_DISPLAY)    loop_timer++;
_0xC:
	LDS  R26,_loop_timer
	CPI  R26,LOW(0xC8)
	BRSH _0xD
	LDS  R30,_loop_timer
	SUBI R30,-LOW(1)
	STS  _loop_timer,R30
; 0000 006A }
_0xD:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void    SCAN_LED(unsigned char num_led,unsigned char    data_in)
; 0000 006D {
_SCAN_LED:
; .FSTART _SCAN_LED
; 0000 006E     unsigned char   byte1,byte2;
; 0000 006F     byte1 = 0xFF;
	ST   -Y,R26
	RCALL __SAVELOCR2
;	num_led -> Y+3
;	data_in -> Y+2
;	byte1 -> R17
;	byte2 -> R16
	LDI  R17,LOW(255)
; 0000 0070     byte2 = 0;
	LDI  R16,LOW(0)
; 0000 0071 
; 0000 0072       switch(data_in)
	LDD  R30,Y+2
	LDI  R31,0
; 0000 0073       {
; 0000 0074         case    0:
	SBIW R30,0
	BRNE _0x11
; 0000 0075         {
; 0000 0076             byte1 = 0x05;
	LDI  R17,LOW(5)
; 0000 0077             break;
	RJMP _0x10
; 0000 0078         }
; 0000 0079         case    1:
_0x11:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x12
; 0000 007A         {
; 0000 007B             byte1 = 0x7D;
	LDI  R17,LOW(125)
; 0000 007C             break;
	RJMP _0x10
; 0000 007D         }
; 0000 007E         case    2:
_0x12:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x13
; 0000 007F         {
; 0000 0080             byte1 = 0x46;
	LDI  R17,LOW(70)
; 0000 0081             break;
	RJMP _0x10
; 0000 0082         }
; 0000 0083         case    3:
_0x13:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x14
; 0000 0084         {
; 0000 0085             byte1 = 0x54;
	LDI  R17,LOW(84)
; 0000 0086             break;
	RJMP _0x10
; 0000 0087         }
; 0000 0088         case    4:
_0x14:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x15
; 0000 0089         {
; 0000 008A             byte1 = 0x3C;
	LDI  R17,LOW(60)
; 0000 008B             break;
	RJMP _0x10
; 0000 008C         }
; 0000 008D         case    5:
_0x15:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x16
; 0000 008E         {
; 0000 008F             byte1 = 0x94;
	LDI  R17,LOW(148)
; 0000 0090             break;
	RJMP _0x10
; 0000 0091         }
; 0000 0092         case    6:
_0x16:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x17
; 0000 0093         {
; 0000 0094             byte1 = 0x84;
	LDI  R17,LOW(132)
; 0000 0095             break;
	RJMP _0x10
; 0000 0096         }
; 0000 0097         case    7:
_0x17:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x18
; 0000 0098         {
; 0000 0099             byte1 = 0x5D;
	LDI  R17,LOW(93)
; 0000 009A             break;
	RJMP _0x10
; 0000 009B         }
; 0000 009C         case    8:
_0x18:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x19
; 0000 009D         {
; 0000 009E             byte1 = 0x04;
	LDI  R17,LOW(4)
; 0000 009F             break;
	RJMP _0x10
; 0000 00A0         }
; 0000 00A1         case    9:
_0x19:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x10
; 0000 00A2         {
; 0000 00A3             byte1 = 0x14;
	LDI  R17,LOW(20)
; 0000 00A4             break;
; 0000 00A5         }
; 0000 00A6     }
_0x10:
; 0000 00A7 
; 0000 00A8 
; 0000 00A9     switch(num_led)
	LDD  R30,Y+3
	LDI  R31,0
; 0000 00AA     {
; 0000 00AB         case    1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1E
; 0000 00AC         {
; 0000 00AD             byte2 = 0xFD;
	LDI  R16,LOW(253)
; 0000 00AE             break;
	RJMP _0x1D
; 0000 00AF         }
; 0000 00B0         case    2:
_0x1E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1F
; 0000 00B1         {
; 0000 00B2             byte2 = 0xFB;
	LDI  R16,LOW(251)
; 0000 00B3             break;
	RJMP _0x1D
; 0000 00B4         }
; 0000 00B5         case    3:
_0x1F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20
; 0000 00B6         {
; 0000 00B7             byte2 = 0xF7;
	LDI  R16,LOW(247)
; 0000 00B8             byte1 &= 0xFB;
	ANDI R17,LOW(251)
; 0000 00B9             break;
	RJMP _0x1D
; 0000 00BA         }
; 0000 00BB         case    4:
_0x20:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x21
; 0000 00BC         {
; 0000 00BD             byte2 = 0xDF;
	LDI  R16,LOW(223)
; 0000 00BE             break;
	RJMP _0x1D
; 0000 00BF         }
; 0000 00C0         case    5:
_0x21:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x1D
; 0000 00C1         {
; 0000 00C2               byte2 = 0xBF;
	LDI  R16,LOW(191)
; 0000 00C3               byte1 = data_in;
	LDD  R17,Y+2
; 0000 00C4               break;
; 0000 00C5         }
; 0000 00C6     }
_0x1D:
; 0000 00C7 
; 0000 00C8     SPI_SENDBYTE(byte2,0);
	ST   -Y,R16
	LDI  R26,LOW(0)
	RCALL _SPI_SENDBYTE
; 0000 00C9     SPI_SENDBYTE(byte1,1);
	ST   -Y,R17
	LDI  R26,LOW(1)
	RCALL _SPI_SENDBYTE
; 0000 00CA }
	RCALL __LOADLOCR2
	ADIW R28,4
	RET
; .FEND
;
;void LED_SELECT(unsigned char      led)
; 0000 00CD {
_LED_SELECT:
; .FSTART _LED_SELECT
; 0000 00CE 
; 0000 00CF       if( Uc_Last_Select != led)
	ST   -Y,R26
;	led -> Y+0
	LD   R30,Y
	LDS  R26,_Uc_Last_Select
	CP   R30,R26
	BREQ _0x23
; 0000 00D0       {
; 0000 00D1             BUZZER_ON;
	SBI  0x12,0
; 0000 00D2             delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00D3             BUZZER_OFF;
	CBI  0x12,0
; 0000 00D4             delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00D5             Uc_Last_Select = led;
	LD   R30,Y
	STS  _Uc_Last_Select,R30
; 0000 00D6       }
; 0000 00D7 
; 0000 00D8       switch(led)
_0x23:
	LD   R30,Y
	LDI  R31,0
; 0000 00D9       {
; 0000 00DA             case RS:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2B
; 0000 00DB             {
; 0000 00DC                   data_single_led = 0xDF;
	LDI  R30,LOW(223)
	RJMP _0x106
; 0000 00DD                   break;
; 0000 00DE             }
; 0000 00DF             case ST:
_0x2B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2C
; 0000 00E0             {
; 0000 00E1                   data_single_led = 0xEF;
	LDI  R30,LOW(239)
	RJMP _0x106
; 0000 00E2                   break;
; 0000 00E3             }
; 0000 00E4             case TR:
_0x2C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2D
; 0000 00E5             {
; 0000 00E6                   data_single_led = 0xF7;
	LDI  R30,LOW(247)
	RJMP _0x106
; 0000 00E7                   break;
; 0000 00E8             }
; 0000 00E9             case RN:
_0x2D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2E
; 0000 00EA             {
; 0000 00EB                   data_single_led = 0xFB;
	LDI  R30,LOW(251)
	RJMP _0x106
; 0000 00EC                   break;
; 0000 00ED             }
; 0000 00EE             case SN:
_0x2E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2F
; 0000 00EF             {
; 0000 00F0                   data_single_led = 0xFD;
	LDI  R30,LOW(253)
	RJMP _0x106
; 0000 00F1                   break;
; 0000 00F2             }
; 0000 00F3             case TN:
_0x2F:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2A
; 0000 00F4             {
; 0000 00F5                   data_single_led = 0xFE;
	LDI  R30,LOW(254)
_0x106:
	MOV  R9,R30
; 0000 00F6                   break;
; 0000 00F7             }
; 0000 00F8       }
_0x2A:
; 0000 00F9 }
	RJMP _0x2000003
; .FEND
;
;void  SELECT_INPUT(unsigned char    num)
; 0000 00FC {
_SELECT_INPUT:
; .FSTART _SELECT_INPUT
; 0000 00FD       switch(num)
	ST   -Y,R26
;	num -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 00FE       {
; 0000 00FF             case 0:
	SBIW R30,0
	BRNE _0x34
; 0000 0100             {
; 0000 0101                   SELECT_S0 = 0;
	CBI  0x12,1
; 0000 0102                   SELECT_S1 = 0;
	CBI  0x12,2
; 0000 0103                   SELECT_S2 = 0;
	CBI  0x12,3
; 0000 0104                   break;
	RJMP _0x33
; 0000 0105             }
; 0000 0106             case 1:
_0x34:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x3B
; 0000 0107             {
; 0000 0108                   SELECT_S0 = 1;
	SBI  0x12,1
; 0000 0109                   SELECT_S1 = 0;
	CBI  0x12,2
; 0000 010A                   SELECT_S2 = 0;
	CBI  0x12,3
; 0000 010B                   break;
	RJMP _0x33
; 0000 010C             }
; 0000 010D             case 2:
_0x3B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x42
; 0000 010E             {
; 0000 010F                   SELECT_S0 = 0;
	CBI  0x12,1
; 0000 0110                   SELECT_S1 = 1;
	SBI  0x12,2
; 0000 0111                   SELECT_S2 = 0;
	CBI  0x12,3
; 0000 0112                   break;
	RJMP _0x33
; 0000 0113             }
; 0000 0114             case 3:
_0x42:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x49
; 0000 0115             {
; 0000 0116                   SELECT_S0 = 1;
	SBI  0x12,1
; 0000 0117                   SELECT_S1 = 1;
	SBI  0x12,2
; 0000 0118                   SELECT_S2 = 0;
	CBI  0x12,3
; 0000 0119                   break;
	RJMP _0x33
; 0000 011A             }
; 0000 011B             case 4:
_0x49:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x50
; 0000 011C             {
; 0000 011D                   SELECT_S0 = 0;
	CBI  0x12,1
; 0000 011E                   SELECT_S1 = 0;
	CBI  0x12,2
; 0000 011F                   SELECT_S2 = 1;
	RJMP _0x107
; 0000 0120                   break;
; 0000 0121             }
; 0000 0122             case 5:
_0x50:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x57
; 0000 0123             {
; 0000 0124                   SELECT_S0 = 1;
	SBI  0x12,1
; 0000 0125                   SELECT_S1 = 0;
	CBI  0x12,2
; 0000 0126                   SELECT_S2 = 1;
	RJMP _0x107
; 0000 0127                   break;
; 0000 0128             }
; 0000 0129             case 6:
_0x57:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x5E
; 0000 012A             {
; 0000 012B                   SELECT_S0 = 0;
	CBI  0x12,1
; 0000 012C                   SELECT_S1 = 1;
	RJMP _0x108
; 0000 012D                   SELECT_S2 = 1;
; 0000 012E                   break;
; 0000 012F             }
; 0000 0130             case 7:
_0x5E:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x33
; 0000 0131             {
; 0000 0132                   SELECT_S0 = 1;
	SBI  0x12,1
; 0000 0133                   SELECT_S1 = 1;
_0x108:
	SBI  0x12,2
; 0000 0134                   SELECT_S2 = 1;
_0x107:
	SBI  0x12,3
; 0000 0135                   break;
; 0000 0136             }
; 0000 0137       }
_0x33:
; 0000 0138 }
	RJMP _0x2000003
; .FEND
;
;void  SELECT_INPUT_COMPARE(unsigned char  input)
; 0000 013B {
_SELECT_INPUT_COMPARE:
; .FSTART _SELECT_INPUT_COMPARE
; 0000 013C       switch(input)
	ST   -Y,R26
;	input -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 013D       {
; 0000 013E             case RS:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x6F
; 0000 013F             {
; 0000 0140                   SELECT_INPUT(1);
	LDI  R26,LOW(1)
	RJMP _0x109
; 0000 0141                   break;
; 0000 0142             }
; 0000 0143             case ST:
_0x6F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x70
; 0000 0144             {
; 0000 0145                   SELECT_INPUT(3);
	LDI  R26,LOW(3)
	RJMP _0x109
; 0000 0146                   break;
; 0000 0147             }
; 0000 0148             case TR:
_0x70:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x71
; 0000 0149             {
; 0000 014A                   SELECT_INPUT(5);
	LDI  R26,LOW(5)
	RJMP _0x109
; 0000 014B                   break;
; 0000 014C             }
; 0000 014D             case RN:
_0x71:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x72
; 0000 014E             {
; 0000 014F                   SELECT_INPUT(0);
	LDI  R26,LOW(0)
	RJMP _0x109
; 0000 0150                   break;
; 0000 0151             }
; 0000 0152             case SN:
_0x72:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x73
; 0000 0153             {
; 0000 0154                   SELECT_INPUT(2);
	LDI  R26,LOW(2)
	RJMP _0x109
; 0000 0155                   break;
; 0000 0156             }
; 0000 0157             case TN:
_0x73:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x6E
; 0000 0158             {
; 0000 0159                   SELECT_INPUT(4);
	LDI  R26,LOW(4)
_0x109:
	RCALL _SELECT_INPUT
; 0000 015A                   break;
; 0000 015B             }
; 0000 015C       }
_0x6E:
; 0000 015D }
_0x2000003:
	ADIW R28,1
	RET
; .FEND
;
;void  READ_SELECT(void)
; 0000 0160 {
_READ_SELECT:
; .FSTART _READ_SELECT
; 0000 0161      unsigned long int Uint_data_temp[40];
; 0000 0162      unsigned char Uc_temp_cnt;
; 0000 0163      unsigned int Uint_temp;
; 0000 0164      unsigned int data_temp2;
; 0000 0165       if(!RS_INPUT)
	SBIW R28,63
	SBIW R28,63
	SBIW R28,34
	RCALL __SAVELOCR6
;	Uint_data_temp -> Y+6
;	Uc_temp_cnt -> R17
;	Uint_temp -> R18,R19
;	data_temp2 -> R20,R21
	SBIC 0x13,0
	RJMP _0x75
; 0000 0166       {
; 0000 0167             LED_SELECT(RS);
	LDI  R26,LOW(1)
	RCALL _LED_SELECT
; 0000 0168             SELECT_INPUT_COMPARE(RS);
	LDI  R26,LOW(1)
	RCALL _SELECT_INPUT_COMPARE
; 0000 0169             if(loop_read_cnt > TIME_GET_SAMPLE)
	LDI  R30,LOW(3)
	CP   R30,R12
	BRLO PC+2
	RJMP _0x76
; 0000 016A             {
; 0000 016B                   // data = ADE7753_READ(1,VRMS)/253;
; 0000 016C                   loop_read_cnt = 0;
	CLR  R12
; 0000 016D                   data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
	MOV  R30,R8
	INC  R8
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _ADE7753_READ
	POP  R26
	POP  R27
	RCALL __PUTDP1
; 0000 016E                   if(buff_cnt >= NUM_SAMPLE)
	LDI  R30,LOW(40)
	CP   R8,R30
	BRLO _0x77
; 0000 016F                   {
; 0000 0170                         buff_cnt = 0;
	CLR  R8
; 0000 0171                   }
; 0000 0172                   data_temp = 0;
_0x77:
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 0173                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0x79:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0x7A
; 0000 0174                   {
; 0000 0175                         data_temp += data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	RCALL __ADDD12
	STS  _data_temp,R30
	STS  _data_temp+1,R31
	STS  _data_temp+2,R22
	STS  _data_temp+3,R23
; 0000 0176                   }
	INC  R13
	RJMP _0x79
_0x7A:
; 0000 0177 
; 0000 0178                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0x7C:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0x7D
; 0000 0179                   {
; 0000 017A                         Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 017B                   }
	INC  R13
	RJMP _0x7C
_0x7D:
; 0000 017C 
; 0000 017D                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0x7F:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRLO PC+2
	RJMP _0x80
; 0000 017E                   {
; 0000 017F                         for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<NUM_SAMPLE;Uc_temp_cnt++)
	MOV  R17,R13
_0x82:
	CPI  R17,40
	BRLO PC+2
	RJMP _0x83
; 0000 0180                         {
; 0000 0181                               if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __CPD12
	BRSH _0x84
; 0000 0182                               {
; 0000 0183                                     Uint_temp = Uint_data_temp[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X+
	LD   R19,X
; 0000 0184                                     Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 0185                                     Uint_data_temp[Uc_temp_cnt] = Uint_temp;
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R18
	CLR  R22
	CLR  R23
	RCALL __PUTDP1
; 0000 0186                               }
; 0000 0187                         }
_0x84:
	SUBI R17,-1
	RJMP _0x82
_0x83:
; 0000 0188                   }
	INC  R13
	RJMP _0x7F
_0x80:
; 0000 0189 
; 0000 018A                   data_temp = 0;
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 018B                   for(loop_cnt = NUM_FILTER;loop_cnt<NUM_SAMPLE-NUM_FILTER;loop_cnt++)
	LDI  R30,LOW(13)
	MOV  R13,R30
_0x86:
	LDI  R30,LOW(27)
	CP   R13,R30
	BRSH _0x87
; 0000 018C                   {
; 0000 018D                         data_temp += data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	RCALL __ADDD12
	STS  _data_temp,R30
	STS  _data_temp+1,R31
	STS  _data_temp+2,R22
	STS  _data_temp+3,R23
; 0000 018E                   }
	INC  R13
	RJMP _0x86
_0x87:
; 0000 018F                   //data = (unsigned int)data_temp/6;
; 0000 0190                   if(loop_timer == TIME_UPDATE_DISPLAY)
	LDS  R26,_loop_timer
	CPI  R26,LOW(0xC8)
	BRNE _0x88
; 0000 0191                   {
; 0000 0192                         loop_timer = 0;
	LDI  R30,LOW(0)
	STS  _loop_timer,R30
; 0000 0193                         data_temp2 = (unsigned int)(data_temp/SR_RATIO)/(NUM_SAMPLE-2*NUM_FILTER);
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	__GETD1N 0x10A
	RCALL __DIVD21U
	CLR  R22
	CLR  R23
	MOVW R26,R30
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RCALL __DIVW21U
	MOVW R20,R30
; 0000 0194                         if(data_temp2 > 100)    data = data_temp2;
	__CPWRN 20,21,101
	BRLO _0x89
	MOVW R10,R20
; 0000 0195                         else data = 0;
	RJMP _0x8A
_0x89:
	CLR  R10
	CLR  R11
; 0000 0196                   }
_0x8A:
; 0000 0197             }
_0x88:
; 0000 0198       }
_0x76:
; 0000 0199       else if(!ST_INPUT)
	RJMP _0x8B
_0x75:
	SBIC 0x13,1
	RJMP _0x8C
; 0000 019A       {
; 0000 019B             LED_SELECT(ST);
	LDI  R26,LOW(2)
	RCALL _LED_SELECT
; 0000 019C             SELECT_INPUT_COMPARE(ST);
	LDI  R26,LOW(2)
	RCALL _SELECT_INPUT_COMPARE
; 0000 019D             if(loop_read_cnt > TIME_GET_SAMPLE)
	LDI  R30,LOW(3)
	CP   R30,R12
	BRLO PC+2
	RJMP _0x8D
; 0000 019E             {
; 0000 019F                   // data = ADE7753_READ(1,VRMS)/253;
; 0000 01A0                   loop_read_cnt = 0;
	CLR  R12
; 0000 01A1                   data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
	MOV  R30,R8
	INC  R8
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _ADE7753_READ
	POP  R26
	POP  R27
	RCALL __PUTDP1
; 0000 01A2                   if(buff_cnt >= NUM_SAMPLE)
	LDI  R30,LOW(40)
	CP   R8,R30
	BRLO _0x8E
; 0000 01A3                   {
; 0000 01A4                         buff_cnt = 0;
	CLR  R8
; 0000 01A5                   }
; 0000 01A6                   data_temp = 0;
_0x8E:
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 01A7                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0x90:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0x91
; 0000 01A8                   {
; 0000 01A9                         data_temp += data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	RCALL __ADDD12
	STS  _data_temp,R30
	STS  _data_temp+1,R31
	STS  _data_temp+2,R22
	STS  _data_temp+3,R23
; 0000 01AA                   }
	INC  R13
	RJMP _0x90
_0x91:
; 0000 01AB 
; 0000 01AC                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0x93:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0x94
; 0000 01AD                   {
; 0000 01AE                         Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 01AF                   }
	INC  R13
	RJMP _0x93
_0x94:
; 0000 01B0 
; 0000 01B1                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0x96:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRLO PC+2
	RJMP _0x97
; 0000 01B2                   {
; 0000 01B3                         for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<NUM_SAMPLE;Uc_temp_cnt++)
	MOV  R17,R13
_0x99:
	CPI  R17,40
	BRLO PC+2
	RJMP _0x9A
; 0000 01B4                         {
; 0000 01B5                               if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __CPD12
	BRSH _0x9B
; 0000 01B6                               {
; 0000 01B7                                     Uint_temp = Uint_data_temp[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X+
	LD   R19,X
; 0000 01B8                                     Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 01B9                                     Uint_data_temp[Uc_temp_cnt] = Uint_temp;
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R18
	CLR  R22
	CLR  R23
	RCALL __PUTDP1
; 0000 01BA                               }
; 0000 01BB                         }
_0x9B:
	SUBI R17,-1
	RJMP _0x99
_0x9A:
; 0000 01BC                   }
	INC  R13
	RJMP _0x96
_0x97:
; 0000 01BD 
; 0000 01BE                   data_temp = 0;
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 01BF                   for(loop_cnt = NUM_FILTER;loop_cnt<NUM_SAMPLE-NUM_FILTER;loop_cnt++)
	LDI  R30,LOW(13)
	MOV  R13,R30
_0x9D:
	LDI  R30,LOW(27)
	CP   R13,R30
	BRSH _0x9E
; 0000 01C0                   {
; 0000 01C1                         data_temp += data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	RCALL __ADDD12
	STS  _data_temp,R30
	STS  _data_temp+1,R31
	STS  _data_temp+2,R22
	STS  _data_temp+3,R23
; 0000 01C2                   }
	INC  R13
	RJMP _0x9D
_0x9E:
; 0000 01C3                   //data = (unsigned int)data_temp/6;
; 0000 01C4                   if(loop_timer == TIME_UPDATE_DISPLAY)
	LDS  R26,_loop_timer
	CPI  R26,LOW(0xC8)
	BRNE _0x9F
; 0000 01C5                   {
; 0000 01C6                         loop_timer = 0;
	LDI  R30,LOW(0)
	STS  _loop_timer,R30
; 0000 01C7                         data_temp2 = (unsigned int)(data_temp/ST_RATIO)/(NUM_SAMPLE-2*NUM_FILTER);
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	__GETD1N 0xF4
	RCALL __DIVD21U
	CLR  R22
	CLR  R23
	MOVW R26,R30
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RCALL __DIVW21U
	MOVW R20,R30
; 0000 01C8                         if(data_temp2 > 100)    data = data_temp2;
	__CPWRN 20,21,101
	BRLO _0xA0
	MOVW R10,R20
; 0000 01C9                         else data = 0;
	RJMP _0xA1
_0xA0:
	CLR  R10
	CLR  R11
; 0000 01CA                   }
_0xA1:
; 0000 01CB             }
_0x9F:
; 0000 01CC       }
_0x8D:
; 0000 01CD       else if(!TR_INPUT)
	RJMP _0xA2
_0x8C:
	SBIC 0x13,2
	RJMP _0xA3
; 0000 01CE       {
; 0000 01CF             LED_SELECT(TR);
	LDI  R26,LOW(3)
	RCALL _LED_SELECT
; 0000 01D0             SELECT_INPUT_COMPARE(TR);
	LDI  R26,LOW(3)
	RCALL _SELECT_INPUT_COMPARE
; 0000 01D1             if(loop_read_cnt > TIME_GET_SAMPLE)
	LDI  R30,LOW(3)
	CP   R30,R12
	BRLO PC+2
	RJMP _0xA4
; 0000 01D2             {
; 0000 01D3                   // data = ADE7753_READ(1,VRMS)/253;
; 0000 01D4                   loop_read_cnt = 0;
	CLR  R12
; 0000 01D5                   data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
	MOV  R30,R8
	INC  R8
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _ADE7753_READ
	POP  R26
	POP  R27
	RCALL __PUTDP1
; 0000 01D6                   if(buff_cnt >= NUM_SAMPLE)
	LDI  R30,LOW(40)
	CP   R8,R30
	BRLO _0xA5
; 0000 01D7                   {
; 0000 01D8                         buff_cnt = 0;
	CLR  R8
; 0000 01D9                   }
; 0000 01DA                   data_temp = 0;
_0xA5:
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 01DB                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0xA7:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0xA8
; 0000 01DC                   {
; 0000 01DD                         data_temp += data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	RCALL __ADDD12
	STS  _data_temp,R30
	STS  _data_temp+1,R31
	STS  _data_temp+2,R22
	STS  _data_temp+3,R23
; 0000 01DE                   }
	INC  R13
	RJMP _0xA7
_0xA8:
; 0000 01DF 
; 0000 01E0                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0xAA:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0xAB
; 0000 01E1                   {
; 0000 01E2                         Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 01E3                   }
	INC  R13
	RJMP _0xAA
_0xAB:
; 0000 01E4 
; 0000 01E5                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0xAD:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRLO PC+2
	RJMP _0xAE
; 0000 01E6                   {
; 0000 01E7                         for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<NUM_SAMPLE;Uc_temp_cnt++)
	MOV  R17,R13
_0xB0:
	CPI  R17,40
	BRLO PC+2
	RJMP _0xB1
; 0000 01E8                         {
; 0000 01E9                               if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __CPD12
	BRSH _0xB2
; 0000 01EA                               {
; 0000 01EB                                     Uint_temp = Uint_data_temp[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X+
	LD   R19,X
; 0000 01EC                                     Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 01ED                                     Uint_data_temp[Uc_temp_cnt] = Uint_temp;
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R18
	CLR  R22
	CLR  R23
	RCALL __PUTDP1
; 0000 01EE                               }
; 0000 01EF                         }
_0xB2:
	SUBI R17,-1
	RJMP _0xB0
_0xB1:
; 0000 01F0                   }
	INC  R13
	RJMP _0xAD
_0xAE:
; 0000 01F1 
; 0000 01F2                   data_temp = 0;
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 01F3                   for(loop_cnt = NUM_FILTER;loop_cnt<NUM_SAMPLE-NUM_FILTER;loop_cnt++)
	LDI  R30,LOW(13)
	MOV  R13,R30
_0xB4:
	LDI  R30,LOW(27)
	CP   R13,R30
	BRSH _0xB5
; 0000 01F4                   {
; 0000 01F5                         data_temp += data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	RCALL __ADDD12
	STS  _data_temp,R30
	STS  _data_temp+1,R31
	STS  _data_temp+2,R22
	STS  _data_temp+3,R23
; 0000 01F6                   }
	INC  R13
	RJMP _0xB4
_0xB5:
; 0000 01F7                   if(loop_timer == TIME_UPDATE_DISPLAY)
	LDS  R26,_loop_timer
	CPI  R26,LOW(0xC8)
	BRNE _0xB6
; 0000 01F8                   {
; 0000 01F9                         loop_timer = 0;
	LDI  R30,LOW(0)
	STS  _loop_timer,R30
; 0000 01FA                         data_temp2 = (unsigned int)(data_temp/TR_RATIO)/(NUM_SAMPLE-2*NUM_FILTER);
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	__GETD1N 0xFC
	RCALL __DIVD21U
	CLR  R22
	CLR  R23
	MOVW R26,R30
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RCALL __DIVW21U
	MOVW R20,R30
; 0000 01FB                         if(data_temp2 > 100)    data = data_temp2;
	__CPWRN 20,21,101
	BRLO _0xB7
	MOVW R10,R20
; 0000 01FC                         else data = 0;
	RJMP _0xB8
_0xB7:
	CLR  R10
	CLR  R11
; 0000 01FD                   }
_0xB8:
; 0000 01FE             }
_0xB6:
; 0000 01FF       }
_0xA4:
; 0000 0200       else if(!RN_INPUT)
	RJMP _0xB9
_0xA3:
	SBIC 0x13,3
	RJMP _0xBA
; 0000 0201       {
; 0000 0202             LED_SELECT(RN);
	LDI  R26,LOW(4)
	RCALL _LED_SELECT
; 0000 0203             SELECT_INPUT_COMPARE(RN);
	LDI  R26,LOW(4)
	RCALL _SELECT_INPUT_COMPARE
; 0000 0204            if(loop_read_cnt > TIME_GET_SAMPLE)
	LDI  R30,LOW(3)
	CP   R30,R12
	BRLO PC+2
	RJMP _0xBB
; 0000 0205             {
; 0000 0206                   loop_read_cnt = 0;
	CLR  R12
; 0000 0207                   data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
	MOV  R30,R8
	INC  R8
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _ADE7753_READ
	POP  R26
	POP  R27
	RCALL __PUTDP1
; 0000 0208                   if(buff_cnt >= NUM_SAMPLE)
	LDI  R30,LOW(40)
	CP   R8,R30
	BRLO _0xBC
; 0000 0209                   {
; 0000 020A                         buff_cnt = 0;
	CLR  R8
; 0000 020B                   }
; 0000 020C                   data_temp = 0;
_0xBC:
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 020D                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0xBE:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0xBF
; 0000 020E                   {
; 0000 020F                         data_temp += data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	RCALL __ADDD12
	STS  _data_temp,R30
	STS  _data_temp+1,R31
	STS  _data_temp+2,R22
	STS  _data_temp+3,R23
; 0000 0210                   }
	INC  R13
	RJMP _0xBE
_0xBF:
; 0000 0211 
; 0000 0212                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0xC1:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0xC2
; 0000 0213                   {
; 0000 0214                         Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 0215                   }
	INC  R13
	RJMP _0xC1
_0xC2:
; 0000 0216 
; 0000 0217                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0xC4:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRLO PC+2
	RJMP _0xC5
; 0000 0218                   {
; 0000 0219                         for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<NUM_SAMPLE;Uc_temp_cnt++)
	MOV  R17,R13
_0xC7:
	CPI  R17,40
	BRLO PC+2
	RJMP _0xC8
; 0000 021A                         {
; 0000 021B                               if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __CPD12
	BRSH _0xC9
; 0000 021C                               {
; 0000 021D                                     Uint_temp = Uint_data_temp[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X+
	LD   R19,X
; 0000 021E                                     Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 021F                                     Uint_data_temp[Uc_temp_cnt] = Uint_temp;
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R18
	CLR  R22
	CLR  R23
	RCALL __PUTDP1
; 0000 0220                               }
; 0000 0221                         }
_0xC9:
	SUBI R17,-1
	RJMP _0xC7
_0xC8:
; 0000 0222                   }
	INC  R13
	RJMP _0xC4
_0xC5:
; 0000 0223 
; 0000 0224                   data_temp = 0;
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 0225                   for(loop_cnt = NUM_FILTER;loop_cnt<(NUM_SAMPLE-NUM_FILTER);loop_cnt++)
	LDI  R30,LOW(13)
	MOV  R13,R30
_0xCB:
	LDI  R30,LOW(27)
	CP   R13,R30
	BRSH _0xCC
; 0000 0226                   {
; 0000 0227                         data_temp += data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	RCALL __ADDD12
	STS  _data_temp,R30
	STS  _data_temp+1,R31
	STS  _data_temp+2,R22
	STS  _data_temp+3,R23
; 0000 0228                   }
	INC  R13
	RJMP _0xCB
_0xCC:
; 0000 0229                   if(loop_timer == TIME_UPDATE_DISPLAY)
	LDS  R26,_loop_timer
	CPI  R26,LOW(0xC8)
	BRNE _0xCD
; 0000 022A                   {
; 0000 022B                         loop_timer = 0;
	LDI  R30,LOW(0)
	STS  _loop_timer,R30
; 0000 022C                         data_temp2 = (unsigned int)(data_temp/RN_RATIO)/(NUM_SAMPLE-2*NUM_FILTER);
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	__GETD1N 0x114
	RCALL __DIVD21U
	CLR  R22
	CLR  R23
	MOVW R26,R30
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RCALL __DIVW21U
	MOVW R20,R30
; 0000 022D                         if(data_temp2 > 100)    data = data_temp2;
	__CPWRN 20,21,101
	BRLO _0xCE
	MOVW R10,R20
; 0000 022E                         else data = 0;
	RJMP _0xCF
_0xCE:
	CLR  R10
	CLR  R11
; 0000 022F                   }
_0xCF:
; 0000 0230             }
_0xCD:
; 0000 0231 
; 0000 0232       }
_0xBB:
; 0000 0233       else if(!SN_INPUT)
	RJMP _0xD0
_0xBA:
	SBIC 0x13,4
	RJMP _0xD1
; 0000 0234       {
; 0000 0235             LED_SELECT(SN);
	LDI  R26,LOW(5)
	RCALL _LED_SELECT
; 0000 0236             SELECT_INPUT_COMPARE(SN);
	LDI  R26,LOW(5)
	RCALL _SELECT_INPUT_COMPARE
; 0000 0237             if(loop_read_cnt > TIME_GET_SAMPLE)
	LDI  R30,LOW(3)
	CP   R30,R12
	BRLO PC+2
	RJMP _0xD2
; 0000 0238             {
; 0000 0239                   loop_read_cnt = 0;
	CLR  R12
; 0000 023A                   data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
	MOV  R30,R8
	INC  R8
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _ADE7753_READ
	POP  R26
	POP  R27
	RCALL __PUTDP1
; 0000 023B                   if(buff_cnt >= NUM_SAMPLE)
	LDI  R30,LOW(40)
	CP   R8,R30
	BRLO _0xD3
; 0000 023C                   {
; 0000 023D                         buff_cnt = 0;
	CLR  R8
; 0000 023E                   }
; 0000 023F                   data_temp = 0;
_0xD3:
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 0240                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0xD5:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0xD6
; 0000 0241                   {
; 0000 0242                         data_temp += data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	RCALL __ADDD12
	STS  _data_temp,R30
	STS  _data_temp+1,R31
	STS  _data_temp+2,R22
	STS  _data_temp+3,R23
; 0000 0243                   }
	INC  R13
	RJMP _0xD5
_0xD6:
; 0000 0244 
; 0000 0245                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0xD8:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0xD9
; 0000 0246                   {
; 0000 0247                         Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 0248                   }
	INC  R13
	RJMP _0xD8
_0xD9:
; 0000 0249 
; 0000 024A                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0xDB:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRLO PC+2
	RJMP _0xDC
; 0000 024B                   {
; 0000 024C                         for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<NUM_SAMPLE;Uc_temp_cnt++)
	MOV  R17,R13
_0xDE:
	CPI  R17,40
	BRLO PC+2
	RJMP _0xDF
; 0000 024D                         {
; 0000 024E                               if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __CPD12
	BRSH _0xE0
; 0000 024F                               {
; 0000 0250                                     Uint_temp = Uint_data_temp[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X+
	LD   R19,X
; 0000 0251                                     Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 0252                                     Uint_data_temp[Uc_temp_cnt] = Uint_temp;
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R18
	CLR  R22
	CLR  R23
	RCALL __PUTDP1
; 0000 0253                               }
; 0000 0254                         }
_0xE0:
	SUBI R17,-1
	RJMP _0xDE
_0xDF:
; 0000 0255                   }
	INC  R13
	RJMP _0xDB
_0xDC:
; 0000 0256 
; 0000 0257                   data_temp = 0;
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 0258                   for(loop_cnt = NUM_FILTER;loop_cnt<(NUM_SAMPLE-NUM_FILTER);loop_cnt++)
	LDI  R30,LOW(13)
	MOV  R13,R30
_0xE2:
	LDI  R30,LOW(27)
	CP   R13,R30
	BRSH _0xE3
; 0000 0259                   {
; 0000 025A                         data_temp += data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	RCALL __ADDD12
	STS  _data_temp,R30
	STS  _data_temp+1,R31
	STS  _data_temp+2,R22
	STS  _data_temp+3,R23
; 0000 025B                   }
	INC  R13
	RJMP _0xE2
_0xE3:
; 0000 025C                   if(loop_timer == TIME_UPDATE_DISPLAY)
	LDS  R26,_loop_timer
	CPI  R26,LOW(0xC8)
	BRNE _0xE4
; 0000 025D                   {
; 0000 025E                         loop_timer = 0;
	LDI  R30,LOW(0)
	STS  _loop_timer,R30
; 0000 025F                         data_temp2 = (unsigned int)(data_temp/SN_RATIO)/(NUM_SAMPLE-2*NUM_FILTER);
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	__GETD1N 0x102
	RCALL __DIVD21U
	CLR  R22
	CLR  R23
	MOVW R26,R30
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RCALL __DIVW21U
	MOVW R20,R30
; 0000 0260                         if(data_temp2 > 100)    data = data_temp2;
	__CPWRN 20,21,101
	BRLO _0xE5
	MOVW R10,R20
; 0000 0261                         else data = 0;
	RJMP _0xE6
_0xE5:
	CLR  R10
	CLR  R11
; 0000 0262                   }
_0xE6:
; 0000 0263             }
_0xE4:
; 0000 0264       }
_0xD2:
; 0000 0265       else if(!TN_INPUT)
	RJMP _0xE7
_0xD1:
	SBIC 0x13,5
	RJMP _0xE8
; 0000 0266       {
; 0000 0267             LED_SELECT(TN);
	LDI  R26,LOW(6)
	RCALL _LED_SELECT
; 0000 0268             SELECT_INPUT_COMPARE(TN);
	LDI  R26,LOW(6)
	RCALL _SELECT_INPUT_COMPARE
; 0000 0269             if(loop_read_cnt > TIME_GET_SAMPLE)
	LDI  R30,LOW(3)
	CP   R30,R12
	BRLO PC+2
	RJMP _0xE9
; 0000 026A             {
; 0000 026B                   loop_read_cnt = 0;
	CLR  R12
; 0000 026C                   data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
	MOV  R30,R8
	INC  R8
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _ADE7753_READ
	POP  R26
	POP  R27
	RCALL __PUTDP1
; 0000 026D                   if(buff_cnt >= NUM_SAMPLE)
	LDI  R30,LOW(40)
	CP   R8,R30
	BRLO _0xEA
; 0000 026E                   {
; 0000 026F                         buff_cnt = 0;
	CLR  R8
; 0000 0270                   }
; 0000 0271                   data_temp = 0;
_0xEA:
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 0272                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0xEC:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0xED
; 0000 0273                   {
; 0000 0274                         data_temp += data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	RCALL __ADDD12
	STS  _data_temp,R30
	STS  _data_temp+1,R31
	STS  _data_temp+2,R22
	STS  _data_temp+3,R23
; 0000 0275                   }
	INC  R13
	RJMP _0xEC
_0xED:
; 0000 0276 
; 0000 0277                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0xEF:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0xF0
; 0000 0278                   {
; 0000 0279                         Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 027A                   }
	INC  R13
	RJMP _0xEF
_0xF0:
; 0000 027B 
; 0000 027C                   for(loop_cnt = 0;loop_cnt<NUM_SAMPLE;loop_cnt++)
	CLR  R13
_0xF2:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRLO PC+2
	RJMP _0xF3
; 0000 027D                   {
; 0000 027E                         for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<NUM_SAMPLE;Uc_temp_cnt++)
	MOV  R17,R13
_0xF5:
	CPI  R17,40
	BRLO PC+2
	RJMP _0xF6
; 0000 027F                         {
; 0000 0280                               if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __CPD12
	BRSH _0xF7
; 0000 0281                               {
; 0000 0282                                     Uint_temp = Uint_data_temp[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X+
	LD   R19,X
; 0000 0283                                     Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 0284                                     Uint_data_temp[Uc_temp_cnt] = Uint_temp;
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R18
	CLR  R22
	CLR  R23
	RCALL __PUTDP1
; 0000 0285                               }
; 0000 0286                         }
_0xF7:
	SUBI R17,-1
	RJMP _0xF5
_0xF6:
; 0000 0287                   }
	INC  R13
	RJMP _0xF2
_0xF3:
; 0000 0288 
; 0000 0289                   data_temp = 0;
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 028A                   for(loop_cnt = NUM_FILTER;loop_cnt<(NUM_SAMPLE-NUM_FILTER);loop_cnt++)
	LDI  R30,LOW(13)
	MOV  R13,R30
_0xF9:
	LDI  R30,LOW(27)
	CP   R13,R30
	BRSH _0xFA
; 0000 028B                   {
; 0000 028C                         data_temp += data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R26,LOW(_data_buff)
	LDI  R27,HIGH(_data_buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	RCALL __ADDD12
	STS  _data_temp,R30
	STS  _data_temp+1,R31
	STS  _data_temp+2,R22
	STS  _data_temp+3,R23
; 0000 028D                   }
	INC  R13
	RJMP _0xF9
_0xFA:
; 0000 028E                   if(loop_timer == TIME_UPDATE_DISPLAY)
	LDS  R26,_loop_timer
	CPI  R26,LOW(0xC8)
	BRNE _0xFB
; 0000 028F                   {
; 0000 0290                         loop_timer = 0;
	LDI  R30,LOW(0)
	STS  _loop_timer,R30
; 0000 0291                         data_temp2 = (unsigned int)(data_temp/TN_RATIO)/(NUM_SAMPLE-2*NUM_FILTER);
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	__GETD1N 0xE5
	RCALL __DIVD21U
	CLR  R22
	CLR  R23
	MOVW R26,R30
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RCALL __DIVW21U
	MOVW R20,R30
; 0000 0292                         if(data_temp2 > 100)    data = data_temp2;
	__CPWRN 20,21,101
	BRLO _0xFC
	MOVW R10,R20
; 0000 0293                         else data = 0;
	RJMP _0xFD
_0xFC:
	CLR  R10
	CLR  R11
; 0000 0294                   }
_0xFD:
; 0000 0295             }
_0xFB:
; 0000 0296       }
_0xE9:
; 0000 0297 
; 0000 0298       delay_ms(10);
_0xE8:
_0xE7:
_0xD0:
_0xB9:
_0xA2:
_0x8B:
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0299       loop_read_cnt++;
	INC  R12
; 0000 029A 
; 0000 029B }
	RCALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,63
	ADIW R28,40
	RET
; .FEND
;
;
;
;
;void main(void)
; 0000 02A1 {
_main:
; .FSTART _main
; 0000 02A2 // Declare your local variables here
; 0000 02A3 unsigned long int   reg = 0;
; 0000 02A4 // Input/Output Ports initialization
; 0000 02A5 // Port B initialization
; 0000 02A6 // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=Out Bit0=In
; 0000 02A7 DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (0<<DDB0);
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
;	reg -> Y+0
	LDI  R30,LOW(42)
	OUT  0x17,R30
; 0000 02A8 // State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=T Bit1=0 Bit0=T
; 0000 02A9 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 02AA 
; 0000 02AB // Port C initialization
; 0000 02AC // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02AD DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 02AE // State: Bit6=T Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 02AF PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
	LDI  R30,LOW(63)
	OUT  0x15,R30
; 0000 02B0 
; 0000 02B1 // Port D initialization
; 0000 02B2 // Function: Bit7=Out Bit6=Out Bit5=In Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 02B3 DDRD=(1<<DDD7) | (1<<DDD6) | (0<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(223)
	OUT  0x11,R30
; 0000 02B4 // State: Bit7=0 Bit6=0 Bit5=T Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 02B5 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 02B6 
; 0000 02B7 // Timer/Counter 0 initialization
; 0000 02B8 // Clock source: System Clock
; 0000 02B9 // Clock value: Timer 0 Stopped
; 0000 02BA TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 02BB TCNT0=0x00;
	OUT  0x32,R30
; 0000 02BC 
; 0000 02BD // Timer/Counter 1 initialization
; 0000 02BE // Clock source: System Clock
; 0000 02BF // Clock value: 1382,400 kHz
; 0000 02C0 // Mode: Normal top=0xFFFF
; 0000 02C1 // OC1A output: Disconnected
; 0000 02C2 // OC1B output: Disconnected
; 0000 02C3 // Noise Canceler: Off
; 0000 02C4 // Input Capture on Falling Edge
; 0000 02C5 // Timer Period: 5,9997 ms
; 0000 02C6 // Timer1 Overflow Interrupt: On
; 0000 02C7 // Input Capture Interrupt: Off
; 0000 02C8 // Compare A Match Interrupt: Off
; 0000 02C9 // Compare B Match Interrupt: Off
; 0000 02CA TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 02CB TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 02CC TCNT1H=0xDF;
	LDI  R30,LOW(223)
	OUT  0x2D,R30
; 0000 02CD TCNT1L=0x9A;
	LDI  R30,LOW(154)
	OUT  0x2C,R30
; 0000 02CE ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 02CF ICR1L=0x00;
	OUT  0x26,R30
; 0000 02D0 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 02D1 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 02D2 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 02D3 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 02D4 
; 0000 02D5 // Timer/Counter 2 initialization
; 0000 02D6 // Clock source: System Clock
; 0000 02D7 // Clock value: Timer2 Stopped
; 0000 02D8 // Mode: Normal top=0xFF
; 0000 02D9 // OC2 output: Disconnected
; 0000 02DA ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 02DB TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 02DC TCNT2=0x00;
	OUT  0x24,R30
; 0000 02DD OCR2=0x00;
	OUT  0x23,R30
; 0000 02DE 
; 0000 02DF // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02E0 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 02E1 
; 0000 02E2 // External Interrupt(s) initialization
; 0000 02E3 // INT0: Off
; 0000 02E4 // INT1: Off
; 0000 02E5 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 02E6 
; 0000 02E7 // USART initialization
; 0000 02E8 // USART disabled
; 0000 02E9 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 02EA 
; 0000 02EB // Analog Comparator initialization
; 0000 02EC // Analog Comparator: Off
; 0000 02ED // The Analog Comparator's positive input is
; 0000 02EE // connected to the AIN0 pin
; 0000 02EF // The Analog Comparator's negative input is
; 0000 02F0 // connected to the AIN1 pin
; 0000 02F1 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02F2 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 02F3 
; 0000 02F4 // ADC initialization
; 0000 02F5 // ADC disabled
; 0000 02F6 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 02F7 
; 0000 02F8 // SPI initialization
; 0000 02F9 // SPI disabled
; 0000 02FA SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 02FB 
; 0000 02FC // TWI initialization
; 0000 02FD // TWI disabled
; 0000 02FE TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 02FF 
; 0000 0300 // Global enable interrupts
; 0000 0301 #asm("sei")
	sei
; 0000 0302 data = 8888;
	LDI  R30,LOW(8888)
	LDI  R31,HIGH(8888)
	MOVW R10,R30
; 0000 0303 reg = 0;
	LDI  R30,LOW(0)
	RCALL __CLRD1S0
; 0000 0304 reg |= (1<<SWRST);
	LD   R30,Y
	ORI  R30,0x40
	ST   Y,R30
; 0000 0305 ADE7753_WRITE(1,MODE,(reg>>8) & 0xFF,reg & 0xFF,0x00);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	__GETD2S 3
	LDI  R30,LOW(8)
	RCALL __LSRD12
	ST   -Y,R30
	LDD  R30,Y+4
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ADE7753_WRITE
; 0000 0306 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0307 reg = ADE7753_READ(1,MODE);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _ADE7753_READ
	RCALL __PUTD1S0
; 0000 0308 
; 0000 0309 reg = ADE7753_READ(1,MODE);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _ADE7753_READ
	RCALL __PUTD1S0
; 0000 030A reg |= (1<<WAVSEL0) | (1<<WAVSEL1) | (1<<DTRT0) | (1<<DTRT1) ;
	LDD  R30,Y+1
	ORI  R30,LOW(0x78)
	STD  Y+1,R30
; 0000 030B ADE7753_WRITE(1,MODE,(reg>>8) & 0xFF,reg & 0xFF,0x00);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	__GETD2S 3
	LDI  R30,LOW(8)
	RCALL __LSRD12
	ST   -Y,R30
	LDD  R30,Y+4
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ADE7753_WRITE
; 0000 030C reg = ADE7753_READ(1,MODE);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _ADE7753_READ
	RCALL __PUTD1S0
; 0000 030D 
; 0000 030E delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 030F ADE7753_WRITE(1,SAGLVL,0X2a,0X00,0X00);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(31)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ADE7753_WRITE
; 0000 0310 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0311 ADE7753_WRITE(1,SAGCYC,0XFF,0X00,0X00);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ADE7753_WRITE
; 0000 0312 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0313 
; 0000 0314 BUZZER_ON;
	SBI  0x12,0
; 0000 0315 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0316 BUZZER_OFF;
	CBI  0x12,0
; 0000 0317       while (1)
_0x102:
; 0000 0318       {
; 0000 0319       // Place your code here
; 0000 031A             READ_SELECT();
	RCALL _READ_SELECT
; 0000 031B       }
	RJMP _0x102
; 0000 031C }
_0x105:
	RJMP _0x105
; .FEND
;#include "SPI_SOFTWARE.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;
;void    SPI_SENDBYTE(unsigned char  data,unsigned char action)
; 0001 0005 {

	.CSEG
_SPI_SENDBYTE:
; .FSTART _SPI_SENDBYTE
; 0001 0006     unsigned char   i;
; 0001 0007     for(i=0;i<8;i++)
	ST   -Y,R26
	ST   -Y,R17
;	data -> Y+2
;	action -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x20004:
	CPI  R17,8
	BRSH _0x20005
; 0001 0008     {
; 0001 0009         if((data & 0x80) == 0x80)    DO_SPI_MOSI = 1;
	LDD  R30,Y+2
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	BRNE _0x20006
	SBI  0x18,3
; 0001 000A         else    DO_SPI_MOSI = 0;
	RJMP _0x20009
_0x20006:
	CBI  0x18,3
; 0001 000B         data <<= 1;
_0x20009:
	LDD  R30,Y+2
	LSL  R30
	STD  Y+2,R30
; 0001 000C         DO_SPI_SCK = 1;
	SBI  0x18,5
; 0001 000D         DO_SPI_SCK = 0;
	CBI  0x18,5
; 0001 000E     }
	SUBI R17,-1
	RJMP _0x20004
_0x20005:
; 0001 000F     if(action)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x20010
; 0001 0010     {
; 0001 0011         DO_SPI_LATCH = 1;
	SBI  0x18,1
; 0001 0012         DO_SPI_LATCH = 0;
	CBI  0x18,1
; 0001 0013     }
; 0001 0014 }
_0x20010:
	LDD  R17,Y+0
	RJMP _0x2000002
; .FEND
;#include "ADE7753.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "delay.h"
;
;
;void    SPI_7753_SEND(unsigned char data)
; 0002 0006 {

	.CSEG
_SPI_7753_SEND:
; .FSTART _SPI_7753_SEND
; 0002 0007     unsigned char   cnt;
; 0002 0008     unsigned char   tmp = data;
; 0002 0009 
; 0002 000A     for(cnt = 0;cnt < 8; cnt++)
	ST   -Y,R26
	RCALL __SAVELOCR2
;	data -> Y+2
;	cnt -> R17
;	tmp -> R16
	LDD  R16,Y+2
	LDI  R17,LOW(0)
_0x40004:
	CPI  R17,8
	BRSH _0x40005
; 0002 000B     {
; 0002 000C         if((tmp & 0x80) == 0x80)   SPI_MOSI_HIGHT;
	MOV  R30,R16
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	BRNE _0x40006
	CBI  0x12,4
; 0002 000D         else SPI_MOSI_LOW;
	RJMP _0x40009
_0x40006:
	SBI  0x12,4
; 0002 000E 
; 0002 000F         SPI_SCK_HIGHT;
_0x40009:
	CBI  0x12,7
; 0002 0010         delay_us(50);
	__DELAY_USB 184
; 0002 0011         SPI_SCK_LOW;
	SBI  0x12,7
; 0002 0012         delay_us(50);
	__DELAY_USB 184
; 0002 0013         tmp <<= 1;
	LSL  R16
; 0002 0014     }
	SUBI R17,-1
	RJMP _0x40004
_0x40005:
; 0002 0015 }
	RCALL __LOADLOCR2
_0x2000002:
	ADIW R28,3
	RET
; .FEND
;
;unsigned char    SPI_7753_RECEIVE(void)
; 0002 0018 {
_SPI_7753_RECEIVE:
; .FSTART _SPI_7753_RECEIVE
; 0002 0019     unsigned char cnt;
; 0002 001A     unsigned char data;
; 0002 001B     data = 0;
	RCALL __SAVELOCR2
;	cnt -> R17
;	data -> R16
	LDI  R16,LOW(0)
; 0002 001C     for(cnt = 0;cnt < 8; cnt++)
	LDI  R17,LOW(0)
_0x40011:
	CPI  R17,8
	BRSH _0x40012
; 0002 001D     {
; 0002 001E         data <<= 1;
	LSL  R16
; 0002 001F         SPI_SCK_HIGHT;
	CBI  0x12,7
; 0002 0020         delay_us(50);
	__DELAY_USB 184
; 0002 0021         SPI_SCK_LOW;
	SBI  0x12,7
; 0002 0022         if(SPI_MISO_HIGHT)   data += 1;
	SBIC 0x10,5
	SUBI R16,-LOW(1)
; 0002 0023         delay_us(50);
	__DELAY_USB 184
; 0002 0024 
; 0002 0025     }
	SUBI R17,-1
	RJMP _0x40011
_0x40012:
; 0002 0026     return data;
	MOV  R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0002 0027 }
; .FEND
;
;void    ADE7753_WRITE(unsigned char IC_CS,unsigned char addr,unsigned char num_data,unsigned char data_1,unsigned char d ...
; 0002 002A {
_ADE7753_WRITE:
; .FSTART _ADE7753_WRITE
; 0002 002B     unsigned char data[4];
; 0002 002C     unsigned char   i;
; 0002 002D     data[0] = data_1;
	ST   -Y,R26
	SBIW R28,4
	ST   -Y,R17
;	IC_CS -> Y+10
;	addr -> Y+9
;	num_data -> Y+8
;	data_1 -> Y+7
;	data_2 -> Y+6
;	data_3 -> Y+5
;	data -> Y+1
;	i -> R17
	LDD  R30,Y+7
	STD  Y+1,R30
; 0002 002E     data[1] = data_2;
	LDD  R30,Y+6
	STD  Y+2,R30
; 0002 002F     data[2] = data_3;
	LDD  R30,Y+5
	STD  Y+3,R30
; 0002 0030 
; 0002 0031     switch (IC_CS)
	LDD  R30,Y+10
	LDI  R31,0
; 0002 0032     {
; 0002 0033         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4001B
; 0002 0034         {
; 0002 0035             PHASE_1_ON;
	SBI  0x12,6
; 0002 0036             PHASE_2_OFF;
	CBI  0x18,0
; 0002 0037             PHASE_3_OFF;
	CBI  0x18,0
; 0002 0038             break;
	RJMP _0x4001A
; 0002 0039         }
; 0002 003A         case 2:
_0x4001B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x40022
; 0002 003B         {
; 0002 003C             PHASE_1_OFF;
	CBI  0x12,6
; 0002 003D             PHASE_2_ON;
	SBI  0x18,0
; 0002 003E             PHASE_3_OFF;
	CBI  0x18,0
; 0002 003F             break;
	RJMP _0x4001A
; 0002 0040         }
; 0002 0041         case 3:
_0x40022:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4001A
; 0002 0042         {
; 0002 0043             PHASE_1_OFF;
	CBI  0x12,6
; 0002 0044             PHASE_2_OFF;
	CBI  0x18,0
; 0002 0045             PHASE_3_ON;
	SBI  0x18,0
; 0002 0046             break;
; 0002 0047         }
; 0002 0048     }
_0x4001A:
; 0002 0049     addr &= 0x3F;
	LDD  R30,Y+9
	ANDI R30,LOW(0x3F)
	STD  Y+9,R30
; 0002 004A     addr |= 0x80;
	ORI  R30,0x80
	STD  Y+9,R30
; 0002 004B     delay_us(100);
	__DELAY_USW 276
; 0002 004C     SPI_7753_SEND(addr);
	LDD  R26,Y+9
	RCALL _SPI_7753_SEND
; 0002 004D     delay_us(100);
	__DELAY_USW 276
; 0002 004E     for(i=0;i<num_data;i++)    SPI_7753_SEND(data[i]);
	LDI  R17,LOW(0)
_0x40031:
	LDD  R30,Y+8
	CP   R17,R30
	BRSH _0x40032
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _SPI_7753_SEND
	SUBI R17,-1
	RJMP _0x40031
_0x40032:
; 0002 004F delay_us(100);
	__DELAY_USW 276
; 0002 0050     PHASE_1_OFF;
	CBI  0x12,6
; 0002 0051     PHASE_2_OFF;
	CBI  0x18,0
; 0002 0052     PHASE_3_OFF;
	CBI  0x18,0
; 0002 0053 }
	LDD  R17,Y+0
	ADIW R28,11
	RET
; .FEND
;unsigned long int    ADE7753_READ(unsigned char IC_CS,unsigned char addr,unsigned char num_data)
; 0002 0055 {
_ADE7753_READ:
; .FSTART _ADE7753_READ
; 0002 0056     unsigned char   i;
; 0002 0057     unsigned char   data[4];
; 0002 0058     unsigned long int res;
; 0002 0059     for(i=0;i<4;i++)    data[i] = 0;
	ST   -Y,R26
	SBIW R28,8
	ST   -Y,R17
;	IC_CS -> Y+11
;	addr -> Y+10
;	num_data -> Y+9
;	i -> R17
;	data -> Y+5
;	res -> Y+1
	LDI  R17,LOW(0)
_0x4003A:
	CPI  R17,4
	BRSH _0x4003B
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
	SUBI R17,-1
	RJMP _0x4003A
_0x4003B:
; 0002 005A switch (IC_CS)
	LDD  R30,Y+11
	LDI  R31,0
; 0002 005B     {
; 0002 005C         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4003F
; 0002 005D         {
; 0002 005E             PHASE_1_ON;
	SBI  0x12,6
; 0002 005F             PHASE_2_OFF;
	CBI  0x18,0
; 0002 0060             PHASE_3_OFF;
	CBI  0x18,0
; 0002 0061             break;
	RJMP _0x4003E
; 0002 0062         }
; 0002 0063         case 2:
_0x4003F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x40046
; 0002 0064         {
; 0002 0065             PHASE_1_OFF;
	CBI  0x12,6
; 0002 0066             PHASE_2_ON;
	SBI  0x18,0
; 0002 0067             PHASE_3_OFF;
	CBI  0x18,0
; 0002 0068             break;
	RJMP _0x4003E
; 0002 0069         }
; 0002 006A         case 3:
_0x40046:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4003E
; 0002 006B         {
; 0002 006C             PHASE_1_OFF;
	CBI  0x12,6
; 0002 006D             PHASE_2_OFF;
	CBI  0x18,0
; 0002 006E             PHASE_3_ON;
	SBI  0x18,0
; 0002 006F             break;
; 0002 0070         }
; 0002 0071     }
_0x4003E:
; 0002 0072     delay_us(10);
	__DELAY_USB 37
; 0002 0073     addr &= 0x3F;
	LDD  R30,Y+10
	ANDI R30,LOW(0x3F)
	STD  Y+10,R30
; 0002 0074     SPI_7753_SEND(addr);
	LDD  R26,Y+10
	RCALL _SPI_7753_SEND
; 0002 0075     delay_us(10);
	__DELAY_USB 37
; 0002 0076     for(i=0;i<num_data;i++) data[i] = SPI_7753_RECEIVE();
	LDI  R17,LOW(0)
_0x40055:
	LDD  R30,Y+9
	CP   R17,R30
	BRSH _0x40056
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _SPI_7753_RECEIVE
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-1
	RJMP _0x40055
_0x40056:
; 0002 0077 delay_us(10);
	__DELAY_USB 37
; 0002 0078     PHASE_1_OFF;
	CBI  0x12,6
; 0002 0079     PHASE_2_OFF;
	CBI  0x18,0
; 0002 007A     PHASE_3_OFF;
	CBI  0x18,0
; 0002 007B     res = 0;
	LDI  R30,LOW(0)
	__CLRD1S 1
; 0002 007C     for(i=0;i<num_data;i++)
	LDI  R17,LOW(0)
_0x4005E:
	LDD  R30,Y+9
	CP   R17,R30
	BRSH _0x4005F
; 0002 007D     {
; 0002 007E         res <<= 8;
	__GETD2S 1
	LDI  R30,LOW(8)
	RCALL __LSLD12
	__PUTD1S 1
; 0002 007F         res += data[i];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R31,0
	__GETD2S 1
	RCALL __CWD1
	RCALL __ADDD12
	__PUTD1S 1
; 0002 0080     }
	SUBI R17,-1
	RJMP _0x4005E
_0x4005F:
; 0002 0081     return res;
	__GETD1S 1
; 0002 0082     return  (res/480);
_0x2000001:
	LDD  R17,Y+0
	ADIW R28,12
	RET
; 0002 0083     //return data[0]+data[1] + data[2];
; 0002 0084 }
; .FEND
;
;void    ADE7753_INIT(void)
; 0002 0087 {
; 0002 0088     unsigned int   reg = 0;
; 0002 0089     ADE7753_WRITE(1,MODE,0x00,0x00,0x00);
;	reg -> R16,R17
; 0002 008A     delay_ms(500);
; 0002 008B     reg = 0;
; 0002 008C     reg |= (1<<SWRST);
; 0002 008D     ADE7753_WRITE(1,MODE,reg,0x00,0x00);
; 0002 008E     delay_ms(500);
; 0002 008F     reg = ADE7753_READ(1,MODE);
; 0002 0090     delay_ms(500);
; 0002 0091     reg = ADE7753_READ(1,MODE);
; 0002 0092     reg |= (1<<DISHPF) | (1<<WAVSEL0) | (1<<WAVSEL1);
; 0002 0093     ADE7753_WRITE(1,MODE,reg,0x00,0x00);
; 0002 0094     delay_ms(500);
; 0002 0095     ADE7753_WRITE(1,SAGLVL,0X2a,0X00,0X00);
; 0002 0096     ADE7753_WRITE(1,SAGCYC,0XFF,0X00,0X00);
; 0002 0097 }

	.DSEG
_data_temp:
	.BYTE 0x4
_data_buff:
	.BYTE 0xA0
_loop_timer:
	.BYTE 0x1
_Uc_Last_Select:
	.BYTE 0x1

	.CSEG

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__CLRD1S0:
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
