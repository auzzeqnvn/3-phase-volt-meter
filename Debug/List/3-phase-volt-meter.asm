
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
;//global variables here
;unsigned char     led_cnt = 1;
;unsigned char     data_led;
;unsigned char     data_single_led = 0xff;
;unsigned int      data = 0;
;unsigned long      data_temp = 0;
;unsigned long int      data_buff[40];
;unsigned char     buff_cnt = 0;
;unsigned char     loop_cnt = 0;
;unsigned char     loop_read_cnt = 0;
;
;
;
;void    SCAN_LED(unsigned char num_led,unsigned char    data_in);
;void  READ_SELECT(void);
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0045 {

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
; 0000 0046 // Reinitialize Timer1 value
; 0000 0047       TCNT1H=0xE800 >> 8;
	LDI  R30,LOW(232)
	OUT  0x2D,R30
; 0000 0048       TCNT1L=0xE800 & 0xff;
	LDI  R30,LOW(0)
	OUT  0x2C,R30
; 0000 0049 
; 0000 004A       if(led_cnt == 1)  data_led = data/1000;
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x3
	MOVW R26,R10
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	MOV  R6,R30
; 0000 004B       else if(led_cnt == 2)  data_led = data%1000/100;
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
; 0000 004C       else if(led_cnt == 3)  data_led = data%100/10;
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
; 0000 004D       else if(led_cnt == 4)  data_led = data%10;
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
; 0000 004E       else if(led_cnt == 5)   data_led = data_single_led;
	RJMP _0xA
_0x9:
	LDI  R30,LOW(5)
	CP   R30,R7
	BRNE _0xB
	MOV  R6,R9
; 0000 004F 
; 0000 0050       SCAN_LED(led_cnt++,data_led);
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
; 0000 0051       if(led_cnt > 5)   led_cnt = 1;
	LDI  R30,LOW(5)
	CP   R30,R7
	BRSH _0xC
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0052 }
_0xC:
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
; 0000 0055 {
_SCAN_LED:
; .FSTART _SCAN_LED
; 0000 0056     unsigned char   byte1,byte2;
; 0000 0057     byte1 = 0xFF;
	ST   -Y,R26
	RCALL __SAVELOCR2
;	num_led -> Y+3
;	data_in -> Y+2
;	byte1 -> R17
;	byte2 -> R16
	LDI  R17,LOW(255)
; 0000 0058     byte2 = 0;
	LDI  R16,LOW(0)
; 0000 0059 
; 0000 005A       switch(data_in)
	LDD  R30,Y+2
	LDI  R31,0
; 0000 005B       {
; 0000 005C         case    0:
	SBIW R30,0
	BRNE _0x10
; 0000 005D         {
; 0000 005E             byte1 = 0x05;
	LDI  R17,LOW(5)
; 0000 005F             break;
	RJMP _0xF
; 0000 0060         }
; 0000 0061         case    1:
_0x10:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x11
; 0000 0062         {
; 0000 0063             byte1 = 0x7D;
	LDI  R17,LOW(125)
; 0000 0064             break;
	RJMP _0xF
; 0000 0065         }
; 0000 0066         case    2:
_0x11:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x12
; 0000 0067         {
; 0000 0068             byte1 = 0x46;
	LDI  R17,LOW(70)
; 0000 0069             break;
	RJMP _0xF
; 0000 006A         }
; 0000 006B         case    3:
_0x12:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x13
; 0000 006C         {
; 0000 006D             byte1 = 0x54;
	LDI  R17,LOW(84)
; 0000 006E             break;
	RJMP _0xF
; 0000 006F         }
; 0000 0070         case    4:
_0x13:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x14
; 0000 0071         {
; 0000 0072             byte1 = 0x3C;
	LDI  R17,LOW(60)
; 0000 0073             break;
	RJMP _0xF
; 0000 0074         }
; 0000 0075         case    5:
_0x14:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x15
; 0000 0076         {
; 0000 0077             byte1 = 0x94;
	LDI  R17,LOW(148)
; 0000 0078             break;
	RJMP _0xF
; 0000 0079         }
; 0000 007A         case    6:
_0x15:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x16
; 0000 007B         {
; 0000 007C             byte1 = 0x84;
	LDI  R17,LOW(132)
; 0000 007D             break;
	RJMP _0xF
; 0000 007E         }
; 0000 007F         case    7:
_0x16:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x17
; 0000 0080         {
; 0000 0081             byte1 = 0x5D;
	LDI  R17,LOW(93)
; 0000 0082             break;
	RJMP _0xF
; 0000 0083         }
; 0000 0084         case    8:
_0x17:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x18
; 0000 0085         {
; 0000 0086             byte1 = 0x04;
	LDI  R17,LOW(4)
; 0000 0087             break;
	RJMP _0xF
; 0000 0088         }
; 0000 0089         case    9:
_0x18:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xF
; 0000 008A         {
; 0000 008B             byte1 = 0x14;
	LDI  R17,LOW(20)
; 0000 008C             break;
; 0000 008D         }
; 0000 008E     }
_0xF:
; 0000 008F 
; 0000 0090 
; 0000 0091     switch(num_led)
	LDD  R30,Y+3
	LDI  R31,0
; 0000 0092     {
; 0000 0093         case    1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1D
; 0000 0094         {
; 0000 0095             byte2 = 0xFD;
	LDI  R16,LOW(253)
; 0000 0096             break;
	RJMP _0x1C
; 0000 0097         }
; 0000 0098         case    2:
_0x1D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1E
; 0000 0099         {
; 0000 009A             byte2 = 0xFB;
	LDI  R16,LOW(251)
; 0000 009B             break;
	RJMP _0x1C
; 0000 009C         }
; 0000 009D         case    3:
_0x1E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1F
; 0000 009E         {
; 0000 009F             byte2 = 0xF7;
	LDI  R16,LOW(247)
; 0000 00A0             byte1 &= 0xFB;
	ANDI R17,LOW(251)
; 0000 00A1             break;
	RJMP _0x1C
; 0000 00A2         }
; 0000 00A3         case    4:
_0x1F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20
; 0000 00A4         {
; 0000 00A5             byte2 = 0xDF;
	LDI  R16,LOW(223)
; 0000 00A6             break;
	RJMP _0x1C
; 0000 00A7         }
; 0000 00A8         case    5:
_0x20:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x1C
; 0000 00A9         {
; 0000 00AA               byte2 = 0xBF;
	LDI  R16,LOW(191)
; 0000 00AB               byte1 = data_in;
	LDD  R17,Y+2
; 0000 00AC               break;
; 0000 00AD         }
; 0000 00AE     }
_0x1C:
; 0000 00AF 
; 0000 00B0     SPI_SENDBYTE(byte2,0);
	ST   -Y,R16
	LDI  R26,LOW(0)
	RCALL _SPI_SENDBYTE
; 0000 00B1     SPI_SENDBYTE(byte1,1);
	ST   -Y,R17
	LDI  R26,LOW(1)
	RCALL _SPI_SENDBYTE
; 0000 00B2 }
	RCALL __LOADLOCR2
	ADIW R28,4
	RET
; .FEND
;
;void LED_SELECT(unsigned char      led)
; 0000 00B5 {
_LED_SELECT:
; .FSTART _LED_SELECT
; 0000 00B6       switch(led)
	ST   -Y,R26
;	led -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 00B7       {
; 0000 00B8             case RS:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x25
; 0000 00B9             {
; 0000 00BA                   data_single_led = 0xDF;
	LDI  R30,LOW(223)
	RJMP _0xEE
; 0000 00BB                   break;
; 0000 00BC             }
; 0000 00BD             case ST:
_0x25:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x26
; 0000 00BE             {
; 0000 00BF                   data_single_led = 0xEF;
	LDI  R30,LOW(239)
	RJMP _0xEE
; 0000 00C0                   break;
; 0000 00C1             }
; 0000 00C2             case TR:
_0x26:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x27
; 0000 00C3             {
; 0000 00C4                   data_single_led = 0xF7;
	LDI  R30,LOW(247)
	RJMP _0xEE
; 0000 00C5                   break;
; 0000 00C6             }
; 0000 00C7             case RN:
_0x27:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x28
; 0000 00C8             {
; 0000 00C9                   data_single_led = 0xFB;
	LDI  R30,LOW(251)
	RJMP _0xEE
; 0000 00CA                   break;
; 0000 00CB             }
; 0000 00CC             case SN:
_0x28:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x29
; 0000 00CD             {
; 0000 00CE                   data_single_led = 0xFD;
	LDI  R30,LOW(253)
	RJMP _0xEE
; 0000 00CF                   break;
; 0000 00D0             }
; 0000 00D1             case TN:
_0x29:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x24
; 0000 00D2             {
; 0000 00D3                   data_single_led = 0xFE;
	LDI  R30,LOW(254)
_0xEE:
	MOV  R9,R30
; 0000 00D4                   break;
; 0000 00D5             }
; 0000 00D6       }
_0x24:
; 0000 00D7 }
	RJMP _0x2000003
; .FEND
;
;void  SELECT_INPUT(unsigned char    num)
; 0000 00DA {
_SELECT_INPUT:
; .FSTART _SELECT_INPUT
; 0000 00DB       switch(num)
	ST   -Y,R26
;	num -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 00DC       {
; 0000 00DD             case 0:
	SBIW R30,0
	BRNE _0x2E
; 0000 00DE             {
; 0000 00DF                   SELECT_S0 = 0;
	CBI  0x12,1
; 0000 00E0                   SELECT_S1 = 0;
	CBI  0x12,2
; 0000 00E1                   SELECT_S2 = 0;
	CBI  0x12,3
; 0000 00E2                   break;
	RJMP _0x2D
; 0000 00E3             }
; 0000 00E4             case 1:
_0x2E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x35
; 0000 00E5             {
; 0000 00E6                   SELECT_S0 = 1;
	SBI  0x12,1
; 0000 00E7                   SELECT_S1 = 0;
	CBI  0x12,2
; 0000 00E8                   SELECT_S2 = 0;
	CBI  0x12,3
; 0000 00E9                   break;
	RJMP _0x2D
; 0000 00EA             }
; 0000 00EB             case 2:
_0x35:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3C
; 0000 00EC             {
; 0000 00ED                   SELECT_S0 = 0;
	CBI  0x12,1
; 0000 00EE                   SELECT_S1 = 1;
	SBI  0x12,2
; 0000 00EF                   SELECT_S2 = 0;
	CBI  0x12,3
; 0000 00F0                   break;
	RJMP _0x2D
; 0000 00F1             }
; 0000 00F2             case 3:
_0x3C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x43
; 0000 00F3             {
; 0000 00F4                   SELECT_S0 = 1;
	SBI  0x12,1
; 0000 00F5                   SELECT_S1 = 1;
	SBI  0x12,2
; 0000 00F6                   SELECT_S2 = 0;
	CBI  0x12,3
; 0000 00F7                   break;
	RJMP _0x2D
; 0000 00F8             }
; 0000 00F9             case 4:
_0x43:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4A
; 0000 00FA             {
; 0000 00FB                   SELECT_S0 = 0;
	CBI  0x12,1
; 0000 00FC                   SELECT_S1 = 0;
	CBI  0x12,2
; 0000 00FD                   SELECT_S2 = 1;
	RJMP _0xEF
; 0000 00FE                   break;
; 0000 00FF             }
; 0000 0100             case 5:
_0x4A:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x51
; 0000 0101             {
; 0000 0102                   SELECT_S0 = 1;
	SBI  0x12,1
; 0000 0103                   SELECT_S1 = 0;
	CBI  0x12,2
; 0000 0104                   SELECT_S2 = 1;
	RJMP _0xEF
; 0000 0105                   break;
; 0000 0106             }
; 0000 0107             case 6:
_0x51:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x58
; 0000 0108             {
; 0000 0109                   SELECT_S0 = 0;
	CBI  0x12,1
; 0000 010A                   SELECT_S1 = 1;
	RJMP _0xF0
; 0000 010B                   SELECT_S2 = 1;
; 0000 010C                   break;
; 0000 010D             }
; 0000 010E             case 7:
_0x58:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2D
; 0000 010F             {
; 0000 0110                   SELECT_S0 = 1;
	SBI  0x12,1
; 0000 0111                   SELECT_S1 = 1;
_0xF0:
	SBI  0x12,2
; 0000 0112                   SELECT_S2 = 1;
_0xEF:
	SBI  0x12,3
; 0000 0113                   break;
; 0000 0114             }
; 0000 0115       }
_0x2D:
; 0000 0116 }
	RJMP _0x2000003
; .FEND
;
;void  SELECT_INPUT_COMPARE(unsigned char  input)
; 0000 0119 {
_SELECT_INPUT_COMPARE:
; .FSTART _SELECT_INPUT_COMPARE
; 0000 011A       switch(input)
	ST   -Y,R26
;	input -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 011B       {
; 0000 011C             case RS:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x69
; 0000 011D             {
; 0000 011E                   SELECT_INPUT(1);
	LDI  R26,LOW(1)
	RJMP _0xF1
; 0000 011F                   break;
; 0000 0120             }
; 0000 0121             case ST:
_0x69:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6A
; 0000 0122             {
; 0000 0123                   SELECT_INPUT(3);
	LDI  R26,LOW(3)
	RJMP _0xF1
; 0000 0124                   break;
; 0000 0125             }
; 0000 0126             case TR:
_0x6A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6B
; 0000 0127             {
; 0000 0128                   SELECT_INPUT(5);
	LDI  R26,LOW(5)
	RJMP _0xF1
; 0000 0129                   break;
; 0000 012A             }
; 0000 012B             case RN:
_0x6B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x6C
; 0000 012C             {
; 0000 012D                   SELECT_INPUT(0);
	LDI  R26,LOW(0)
	RJMP _0xF1
; 0000 012E                   break;
; 0000 012F             }
; 0000 0130             case SN:
_0x6C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x6D
; 0000 0131             {
; 0000 0132                   SELECT_INPUT(2);
	LDI  R26,LOW(2)
	RJMP _0xF1
; 0000 0133                   break;
; 0000 0134             }
; 0000 0135             case TN:
_0x6D:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x68
; 0000 0136             {
; 0000 0137                   SELECT_INPUT(4);
	LDI  R26,LOW(4)
_0xF1:
	RCALL _SELECT_INPUT
; 0000 0138                   break;
; 0000 0139             }
; 0000 013A       }
_0x68:
; 0000 013B }
_0x2000003:
	ADIW R28,1
	RET
; .FEND
;
;void  READ_SELECT(void)
; 0000 013E {
_READ_SELECT:
; .FSTART _READ_SELECT
; 0000 013F      unsigned long int Uint_data_temp[40];
; 0000 0140      unsigned char Uc_temp_cnt;
; 0000 0141      unsigned int Uint_temp;
; 0000 0142       if(!RS_INPUT)
	SBIW R28,63
	SBIW R28,63
	SBIW R28,34
	RCALL __SAVELOCR4
;	Uint_data_temp -> Y+4
;	Uc_temp_cnt -> R17
;	Uint_temp -> R18,R19
	SBIC 0x13,0
	RJMP _0x6F
; 0000 0143       {
; 0000 0144             LED_SELECT(RS);
	LDI  R26,LOW(1)
	RCALL _LED_SELECT
; 0000 0145             SELECT_INPUT_COMPARE(RS);
	LDI  R26,LOW(1)
	RCALL _SELECT_INPUT_COMPARE
; 0000 0146             if(loop_read_cnt > 10)
	LDI  R30,LOW(10)
	CP   R30,R12
	BRLO PC+2
	RJMP _0x70
; 0000 0147             {
; 0000 0148                   // data = ADE7753_READ(1,VRMS)/253;
; 0000 0149                   loop_read_cnt = 0;
	CLR  R12
; 0000 014A                   data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
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
; 0000 014B                   if(buff_cnt >= 40)
	LDI  R30,LOW(40)
	CP   R8,R30
	BRLO _0x71
; 0000 014C                   {
; 0000 014D                         buff_cnt = 0;
	CLR  R8
; 0000 014E                   }
; 0000 014F                   data_temp = 0;
_0x71:
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 0150                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0x73:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0x74
; 0000 0151                   {
; 0000 0152                         data_temp += data_buff[loop_cnt];
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
; 0000 0153                   }
	INC  R13
	RJMP _0x73
_0x74:
; 0000 0154 
; 0000 0155                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0x76:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0x77
; 0000 0156                   {
; 0000 0157                         Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
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
; 0000 0158                   }
	INC  R13
	RJMP _0x76
_0x77:
; 0000 0159 
; 0000 015A                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0x79:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRLO PC+2
	RJMP _0x7A
; 0000 015B                   {
; 0000 015C                         for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<40;Uc_temp_cnt++)
	MOV  R17,R13
_0x7C:
	CPI  R17,40
	BRLO PC+2
	RJMP _0x7D
; 0000 015D                         {
; 0000 015E                               if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
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
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __CPD12
	BRSH _0x7E
; 0000 015F                               {
; 0000 0160                                     Uint_temp = Uint_data_temp[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X+
	LD   R19,X
; 0000 0161                                     Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 0162                                     Uint_data_temp[Uc_temp_cnt] = Uint_temp;
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R18
	CLR  R22
	CLR  R23
	RCALL __PUTDP1
; 0000 0163                               }
; 0000 0164                         }
_0x7E:
	SUBI R17,-1
	RJMP _0x7C
_0x7D:
; 0000 0165                   }
	INC  R13
	RJMP _0x79
_0x7A:
; 0000 0166 
; 0000 0167                   data_temp = 0;
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 0168                   for(loop_cnt = 13;loop_cnt<27;loop_cnt++)
	LDI  R30,LOW(13)
	MOV  R13,R30
_0x80:
	LDI  R30,LOW(27)
	CP   R13,R30
	BRSH _0x81
; 0000 0169                   {
; 0000 016A                         data_temp += data_buff[loop_cnt];
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
; 0000 016B                   }
	INC  R13
	RJMP _0x80
_0x81:
; 0000 016C                   //data = (unsigned int)data_temp/6;
; 0000 016D                   data = (unsigned int)(data_temp/261)/14;
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	__GETD1N 0x105
	RCALL __DIVD21U
	CLR  R22
	CLR  R23
	MOVW R26,R30
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RCALL __DIVW21U
	MOVW R10,R30
; 0000 016E             }
; 0000 016F       }
_0x70:
; 0000 0170       else if(!ST_INPUT)
	RJMP _0x82
_0x6F:
	SBIC 0x13,1
	RJMP _0x83
; 0000 0171       {
; 0000 0172             LED_SELECT(ST);
	LDI  R26,LOW(2)
	RCALL _LED_SELECT
; 0000 0173             SELECT_INPUT_COMPARE(ST);
	LDI  R26,LOW(2)
	RCALL _SELECT_INPUT_COMPARE
; 0000 0174             if(loop_read_cnt > 10)
	LDI  R30,LOW(10)
	CP   R30,R12
	BRLO PC+2
	RJMP _0x84
; 0000 0175             {
; 0000 0176                   // data = ADE7753_READ(1,VRMS)/253;
; 0000 0177                   loop_read_cnt = 0;
	CLR  R12
; 0000 0178                   data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
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
; 0000 0179                   if(buff_cnt >= 40)
	LDI  R30,LOW(40)
	CP   R8,R30
	BRLO _0x85
; 0000 017A                   {
; 0000 017B                         buff_cnt = 0;
	CLR  R8
; 0000 017C                   }
; 0000 017D                   data_temp = 0;
_0x85:
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 017E                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0x87:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0x88
; 0000 017F                   {
; 0000 0180                         data_temp += data_buff[loop_cnt];
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
; 0000 0181                   }
	INC  R13
	RJMP _0x87
_0x88:
; 0000 0182 
; 0000 0183                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0x8A:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0x8B
; 0000 0184                   {
; 0000 0185                         Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
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
; 0000 0186                   }
	INC  R13
	RJMP _0x8A
_0x8B:
; 0000 0187 
; 0000 0188                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0x8D:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRLO PC+2
	RJMP _0x8E
; 0000 0189                   {
; 0000 018A                         for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<40;Uc_temp_cnt++)
	MOV  R17,R13
_0x90:
	CPI  R17,40
	BRLO PC+2
	RJMP _0x91
; 0000 018B                         {
; 0000 018C                               if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
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
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __CPD12
	BRSH _0x92
; 0000 018D                               {
; 0000 018E                                     Uint_temp = Uint_data_temp[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X+
	LD   R19,X
; 0000 018F                                     Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 0190                                     Uint_data_temp[Uc_temp_cnt] = Uint_temp;
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R18
	CLR  R22
	CLR  R23
	RCALL __PUTDP1
; 0000 0191                               }
; 0000 0192                         }
_0x92:
	SUBI R17,-1
	RJMP _0x90
_0x91:
; 0000 0193                   }
	INC  R13
	RJMP _0x8D
_0x8E:
; 0000 0194 
; 0000 0195                   data_temp = 0;
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 0196                   for(loop_cnt = 13;loop_cnt<27;loop_cnt++)
	LDI  R30,LOW(13)
	MOV  R13,R30
_0x94:
	LDI  R30,LOW(27)
	CP   R13,R30
	BRSH _0x95
; 0000 0197                   {
; 0000 0198                         data_temp += data_buff[loop_cnt];
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
; 0000 0199                   }
	INC  R13
	RJMP _0x94
_0x95:
; 0000 019A                   //data = (unsigned int)data_temp/6;
; 0000 019B                   data = (unsigned int)(data_temp/261)/14;
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	__GETD1N 0x105
	RCALL __DIVD21U
	CLR  R22
	CLR  R23
	MOVW R26,R30
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RCALL __DIVW21U
	MOVW R10,R30
; 0000 019C             }
; 0000 019D       }
_0x84:
; 0000 019E       else if(!TR_INPUT)
	RJMP _0x96
_0x83:
	SBIC 0x13,2
	RJMP _0x97
; 0000 019F       {
; 0000 01A0             LED_SELECT(TR);
	LDI  R26,LOW(3)
	RCALL _LED_SELECT
; 0000 01A1             SELECT_INPUT_COMPARE(TR);
	LDI  R26,LOW(3)
	RCALL _SELECT_INPUT_COMPARE
; 0000 01A2             if(loop_read_cnt > 10)
	LDI  R30,LOW(10)
	CP   R30,R12
	BRLO PC+2
	RJMP _0x98
; 0000 01A3             {
; 0000 01A4                   // data = ADE7753_READ(1,VRMS)/253;
; 0000 01A5                   loop_read_cnt = 0;
	CLR  R12
; 0000 01A6                   data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
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
; 0000 01A7                   if(buff_cnt >= 40)
	LDI  R30,LOW(40)
	CP   R8,R30
	BRLO _0x99
; 0000 01A8                   {
; 0000 01A9                         buff_cnt = 0;
	CLR  R8
; 0000 01AA                   }
; 0000 01AB                   data_temp = 0;
_0x99:
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 01AC                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0x9B:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0x9C
; 0000 01AD                   {
; 0000 01AE                         data_temp += data_buff[loop_cnt];
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
; 0000 01AF                   }
	INC  R13
	RJMP _0x9B
_0x9C:
; 0000 01B0 
; 0000 01B1                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0x9E:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0x9F
; 0000 01B2                   {
; 0000 01B3                         Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
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
; 0000 01B4                   }
	INC  R13
	RJMP _0x9E
_0x9F:
; 0000 01B5 
; 0000 01B6                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0xA1:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRLO PC+2
	RJMP _0xA2
; 0000 01B7                   {
; 0000 01B8                         for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<40;Uc_temp_cnt++)
	MOV  R17,R13
_0xA4:
	CPI  R17,40
	BRLO PC+2
	RJMP _0xA5
; 0000 01B9                         {
; 0000 01BA                               if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
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
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __CPD12
	BRSH _0xA6
; 0000 01BB                               {
; 0000 01BC                                     Uint_temp = Uint_data_temp[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X+
	LD   R19,X
; 0000 01BD                                     Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 01BE                                     Uint_data_temp[Uc_temp_cnt] = Uint_temp;
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R18
	CLR  R22
	CLR  R23
	RCALL __PUTDP1
; 0000 01BF                               }
; 0000 01C0                         }
_0xA6:
	SUBI R17,-1
	RJMP _0xA4
_0xA5:
; 0000 01C1                   }
	INC  R13
	RJMP _0xA1
_0xA2:
; 0000 01C2 
; 0000 01C3                   data_temp = 0;
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 01C4                   for(loop_cnt = 13;loop_cnt<27;loop_cnt++)
	LDI  R30,LOW(13)
	MOV  R13,R30
_0xA8:
	LDI  R30,LOW(27)
	CP   R13,R30
	BRSH _0xA9
; 0000 01C5                   {
; 0000 01C6                         data_temp += data_buff[loop_cnt];
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
; 0000 01C7                   }
	INC  R13
	RJMP _0xA8
_0xA9:
; 0000 01C8                   //data = (unsigned int)data_temp/6;
; 0000 01C9                   data = (unsigned int)(data_temp/261)/14;
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	__GETD1N 0x105
	RCALL __DIVD21U
	CLR  R22
	CLR  R23
	MOVW R26,R30
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RCALL __DIVW21U
	MOVW R10,R30
; 0000 01CA             }
; 0000 01CB       }
_0x98:
; 0000 01CC       else if(!RN_INPUT)
	RJMP _0xAA
_0x97:
	SBIC 0x13,3
	RJMP _0xAB
; 0000 01CD       {
; 0000 01CE             LED_SELECT(RN);
	LDI  R26,LOW(4)
	RCALL _LED_SELECT
; 0000 01CF             SELECT_INPUT_COMPARE(RN);
	LDI  R26,LOW(4)
	RCALL _SELECT_INPUT_COMPARE
; 0000 01D0            if(loop_read_cnt > 10)
	LDI  R30,LOW(10)
	CP   R30,R12
	BRLO PC+2
	RJMP _0xAC
; 0000 01D1             {
; 0000 01D2                   // data = ADE7753_READ(1,VRMS)/253;
; 0000 01D3                   loop_read_cnt = 0;
	CLR  R12
; 0000 01D4                   data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
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
; 0000 01D5                   if(buff_cnt >= 40)
	LDI  R30,LOW(40)
	CP   R8,R30
	BRLO _0xAD
; 0000 01D6                   {
; 0000 01D7                         buff_cnt = 0;
	CLR  R8
; 0000 01D8                   }
; 0000 01D9                   data_temp = 0;
_0xAD:
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 01DA                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0xAF:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0xB0
; 0000 01DB                   {
; 0000 01DC                         data_temp += data_buff[loop_cnt];
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
; 0000 01DD                   }
	INC  R13
	RJMP _0xAF
_0xB0:
; 0000 01DE 
; 0000 01DF                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0xB2:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0xB3
; 0000 01E0                   {
; 0000 01E1                         Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
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
; 0000 01E2                   }
	INC  R13
	RJMP _0xB2
_0xB3:
; 0000 01E3 
; 0000 01E4                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0xB5:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRLO PC+2
	RJMP _0xB6
; 0000 01E5                   {
; 0000 01E6                         for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<40;Uc_temp_cnt++)
	MOV  R17,R13
_0xB8:
	CPI  R17,40
	BRLO PC+2
	RJMP _0xB9
; 0000 01E7                         {
; 0000 01E8                               if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
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
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __CPD12
	BRSH _0xBA
; 0000 01E9                               {
; 0000 01EA                                     Uint_temp = Uint_data_temp[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X+
	LD   R19,X
; 0000 01EB                                     Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 01EC                                     Uint_data_temp[Uc_temp_cnt] = Uint_temp;
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R18
	CLR  R22
	CLR  R23
	RCALL __PUTDP1
; 0000 01ED                               }
; 0000 01EE                         }
_0xBA:
	SUBI R17,-1
	RJMP _0xB8
_0xB9:
; 0000 01EF                   }
	INC  R13
	RJMP _0xB5
_0xB6:
; 0000 01F0 
; 0000 01F1                   data_temp = 0;
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 01F2                   for(loop_cnt = 13;loop_cnt<27;loop_cnt++)
	LDI  R30,LOW(13)
	MOV  R13,R30
_0xBC:
	LDI  R30,LOW(27)
	CP   R13,R30
	BRSH _0xBD
; 0000 01F3                   {
; 0000 01F4                         data_temp += data_buff[loop_cnt];
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
; 0000 01F5                   }
	INC  R13
	RJMP _0xBC
_0xBD:
; 0000 01F6                   //data = (unsigned int)data_temp/6;
; 0000 01F7                   data = (unsigned int)(data_temp/261)/14;
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	__GETD1N 0x105
	RCALL __DIVD21U
	CLR  R22
	CLR  R23
	MOVW R26,R30
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RCALL __DIVW21U
	MOVW R10,R30
; 0000 01F8             }
; 0000 01F9 
; 0000 01FA       }
_0xAC:
; 0000 01FB       else if(!SN_INPUT)
	RJMP _0xBE
_0xAB:
	SBIC 0x13,4
	RJMP _0xBF
; 0000 01FC       {
; 0000 01FD             LED_SELECT(SN);
	LDI  R26,LOW(5)
	RCALL _LED_SELECT
; 0000 01FE             SELECT_INPUT_COMPARE(SN);
	LDI  R26,LOW(5)
	RCALL _SELECT_INPUT_COMPARE
; 0000 01FF             if(loop_read_cnt > 10)
	LDI  R30,LOW(10)
	CP   R30,R12
	BRLO PC+2
	RJMP _0xC0
; 0000 0200             {
; 0000 0201                   loop_read_cnt = 0;
	CLR  R12
; 0000 0202                   data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
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
; 0000 0203                   if(buff_cnt >= 40)
	LDI  R30,LOW(40)
	CP   R8,R30
	BRLO _0xC1
; 0000 0204                   {
; 0000 0205                         buff_cnt = 0;
	CLR  R8
; 0000 0206                   }
; 0000 0207                   data_temp = 0;
_0xC1:
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 0208                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0xC3:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0xC4
; 0000 0209                   {
; 0000 020A                         data_temp += data_buff[loop_cnt];
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
; 0000 020B                   }
	INC  R13
	RJMP _0xC3
_0xC4:
; 0000 020C 
; 0000 020D                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0xC6:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0xC7
; 0000 020E                   {
; 0000 020F                         Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
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
; 0000 0210                   }
	INC  R13
	RJMP _0xC6
_0xC7:
; 0000 0211 
; 0000 0212                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0xC9:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRLO PC+2
	RJMP _0xCA
; 0000 0213                   {
; 0000 0214                         for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<40;Uc_temp_cnt++)
	MOV  R17,R13
_0xCC:
	CPI  R17,40
	BRLO PC+2
	RJMP _0xCD
; 0000 0215                         {
; 0000 0216                               if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
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
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __CPD12
	BRSH _0xCE
; 0000 0217                               {
; 0000 0218                                     Uint_temp = Uint_data_temp[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X+
	LD   R19,X
; 0000 0219                                     Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 021A                                     Uint_data_temp[Uc_temp_cnt] = Uint_temp;
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R18
	CLR  R22
	CLR  R23
	RCALL __PUTDP1
; 0000 021B                               }
; 0000 021C                         }
_0xCE:
	SUBI R17,-1
	RJMP _0xCC
_0xCD:
; 0000 021D                   }
	INC  R13
	RJMP _0xC9
_0xCA:
; 0000 021E 
; 0000 021F                   data_temp = 0;
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 0220                   for(loop_cnt = 13;loop_cnt<27;loop_cnt++)
	LDI  R30,LOW(13)
	MOV  R13,R30
_0xD0:
	LDI  R30,LOW(27)
	CP   R13,R30
	BRSH _0xD1
; 0000 0221                   {
; 0000 0222                         data_temp += data_buff[loop_cnt];
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
; 0000 0223                   }
	INC  R13
	RJMP _0xD0
_0xD1:
; 0000 0224                   data = (unsigned int)(data_temp/253)/14;
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	__GETD1N 0xFD
	RCALL __DIVD21U
	CLR  R22
	CLR  R23
	MOVW R26,R30
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RCALL __DIVW21U
	MOVW R10,R30
; 0000 0225             }
; 0000 0226       }
_0xC0:
; 0000 0227       else if(!TN_INPUT)
	RJMP _0xD2
_0xBF:
	SBIC 0x13,5
	RJMP _0xD3
; 0000 0228       {
; 0000 0229             LED_SELECT(TN);
	LDI  R26,LOW(6)
	RCALL _LED_SELECT
; 0000 022A             SELECT_INPUT_COMPARE(TN);
	LDI  R26,LOW(6)
	RCALL _SELECT_INPUT_COMPARE
; 0000 022B             if(loop_read_cnt > 10)
	LDI  R30,LOW(10)
	CP   R30,R12
	BRLO PC+2
	RJMP _0xD4
; 0000 022C             {
; 0000 022D                   // data = ADE7753_READ(1,VRMS)/253;
; 0000 022E                   loop_read_cnt = 0;
	CLR  R12
; 0000 022F                   data_buff[buff_cnt++] = ADE7753_READ(1,VRMS);
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
; 0000 0230                   if(buff_cnt >= 40)
	LDI  R30,LOW(40)
	CP   R8,R30
	BRLO _0xD5
; 0000 0231                   {
; 0000 0232                         buff_cnt = 0;
	CLR  R8
; 0000 0233                   }
; 0000 0234                   data_temp = 0;
_0xD5:
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 0235                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0xD7:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0xD8
; 0000 0236                   {
; 0000 0237                         data_temp += data_buff[loop_cnt];
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
; 0000 0238                   }
	INC  R13
	RJMP _0xD7
_0xD8:
; 0000 0239 
; 0000 023A                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0xDA:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0xDB
; 0000 023B                   {
; 0000 023C                         Uint_data_temp[loop_cnt] = data_buff[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
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
; 0000 023D                   }
	INC  R13
	RJMP _0xDA
_0xDB:
; 0000 023E 
; 0000 023F                   for(loop_cnt = 0;loop_cnt<40;loop_cnt++)
	CLR  R13
_0xDD:
	LDI  R30,LOW(40)
	CP   R13,R30
	BRLO PC+2
	RJMP _0xDE
; 0000 0240                   {
; 0000 0241                         for(Uc_temp_cnt = loop_cnt;Uc_temp_cnt<40;Uc_temp_cnt++)
	MOV  R17,R13
_0xE0:
	CPI  R17,40
	BRLO PC+2
	RJMP _0xE1
; 0000 0242                         {
; 0000 0243                               if(Uint_data_temp[loop_cnt] > Uint_data_temp[Uc_temp_cnt])
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
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
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __CPD12
	BRSH _0xE2
; 0000 0244                               {
; 0000 0245                                     Uint_temp = Uint_data_temp[loop_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X+
	LD   R19,X
; 0000 0246                                     Uint_data_temp[loop_cnt] = Uint_data_temp[Uc_temp_cnt];
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 0247                                     Uint_data_temp[Uc_temp_cnt] = Uint_temp;
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R18
	CLR  R22
	CLR  R23
	RCALL __PUTDP1
; 0000 0248                               }
; 0000 0249                         }
_0xE2:
	SUBI R17,-1
	RJMP _0xE0
_0xE1:
; 0000 024A                   }
	INC  R13
	RJMP _0xDD
_0xDE:
; 0000 024B 
; 0000 024C                   data_temp = 0;
	LDI  R30,LOW(0)
	STS  _data_temp,R30
	STS  _data_temp+1,R30
	STS  _data_temp+2,R30
	STS  _data_temp+3,R30
; 0000 024D                   for(loop_cnt = 13;loop_cnt<27;loop_cnt++)
	LDI  R30,LOW(13)
	MOV  R13,R30
_0xE4:
	LDI  R30,LOW(27)
	CP   R13,R30
	BRSH _0xE5
; 0000 024E                   {
; 0000 024F                         data_temp += data_buff[loop_cnt];
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
; 0000 0250                   }
	INC  R13
	RJMP _0xE4
_0xE5:
; 0000 0251                   //data = (unsigned int)data_temp/6;
; 0000 0252                   data = (unsigned int)(data_temp/236)/14;
	LDS  R26,_data_temp
	LDS  R27,_data_temp+1
	LDS  R24,_data_temp+2
	LDS  R25,_data_temp+3
	__GETD1N 0xEC
	RCALL __DIVD21U
	CLR  R22
	CLR  R23
	MOVW R26,R30
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RCALL __DIVW21U
	MOVW R10,R30
; 0000 0253             }
; 0000 0254       }
_0xD4:
; 0000 0255 
; 0000 0256       delay_ms(10);
_0xD3:
_0xD2:
_0xBE:
_0xAA:
_0x96:
_0x82:
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0257       loop_read_cnt++;
	INC  R12
; 0000 0258 
; 0000 0259 }
	RCALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,63
	ADIW R28,38
	RET
; .FEND
;
;
;
;
;void main(void)
; 0000 025F {
_main:
; .FSTART _main
; 0000 0260 // Declare your local variables here
; 0000 0261 unsigned long int   reg = 0;
; 0000 0262 // Input/Output Ports initialization
; 0000 0263 // Port B initialization
; 0000 0264 // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=Out Bit0=In
; 0000 0265 DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (0<<DDB0);
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
;	reg -> Y+0
	LDI  R30,LOW(42)
	OUT  0x17,R30
; 0000 0266 // State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=T Bit1=0 Bit0=T
; 0000 0267 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0268 
; 0000 0269 // Port C initialization
; 0000 026A // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 026B DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 026C // State: Bit6=T Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 026D PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
	LDI  R30,LOW(63)
	OUT  0x15,R30
; 0000 026E 
; 0000 026F // Port D initialization
; 0000 0270 // Function: Bit7=Out Bit6=Out Bit5=In Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0271 DDRD=(1<<DDD7) | (1<<DDD6) | (0<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(223)
	OUT  0x11,R30
; 0000 0272 // State: Bit7=0 Bit6=0 Bit5=T Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0273 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0274 
; 0000 0275 // Timer/Counter 0 initialization
; 0000 0276 // Clock source: System Clock
; 0000 0277 // Clock value: Timer 0 Stopped
; 0000 0278 TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0279 TCNT0=0x00;
	OUT  0x32,R30
; 0000 027A 
; 0000 027B // Timer/Counter 1 initialization
; 0000 027C // Clock source: System Clock
; 0000 027D // Clock value: 1382,400 kHz
; 0000 027E // Mode: Normal top=0xFFFF
; 0000 027F // OC1A output: Disconnected
; 0000 0280 // OC1B output: Disconnected
; 0000 0281 // Noise Canceler: Off
; 0000 0282 // Input Capture on Falling Edge
; 0000 0283 // Timer Period: 5,9997 ms
; 0000 0284 // Timer1 Overflow Interrupt: On
; 0000 0285 // Input Capture Interrupt: Off
; 0000 0286 // Compare A Match Interrupt: Off
; 0000 0287 // Compare B Match Interrupt: Off
; 0000 0288 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0289 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 028A TCNT1H=0xDF;
	LDI  R30,LOW(223)
	OUT  0x2D,R30
; 0000 028B TCNT1L=0x9A;
	LDI  R30,LOW(154)
	OUT  0x2C,R30
; 0000 028C ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 028D ICR1L=0x00;
	OUT  0x26,R30
; 0000 028E OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 028F OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0290 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0291 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0292 
; 0000 0293 // Timer/Counter 2 initialization
; 0000 0294 // Clock source: System Clock
; 0000 0295 // Clock value: Timer2 Stopped
; 0000 0296 // Mode: Normal top=0xFF
; 0000 0297 // OC2 output: Disconnected
; 0000 0298 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0299 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 029A TCNT2=0x00;
	OUT  0x24,R30
; 0000 029B OCR2=0x00;
	OUT  0x23,R30
; 0000 029C 
; 0000 029D // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 029E TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 029F 
; 0000 02A0 // External Interrupt(s) initialization
; 0000 02A1 // INT0: Off
; 0000 02A2 // INT1: Off
; 0000 02A3 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 02A4 
; 0000 02A5 // USART initialization
; 0000 02A6 // USART disabled
; 0000 02A7 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 02A8 
; 0000 02A9 // Analog Comparator initialization
; 0000 02AA // Analog Comparator: Off
; 0000 02AB // The Analog Comparator's positive input is
; 0000 02AC // connected to the AIN0 pin
; 0000 02AD // The Analog Comparator's negative input is
; 0000 02AE // connected to the AIN1 pin
; 0000 02AF ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02B0 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 02B1 
; 0000 02B2 // ADC initialization
; 0000 02B3 // ADC disabled
; 0000 02B4 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 02B5 
; 0000 02B6 // SPI initialization
; 0000 02B7 // SPI disabled
; 0000 02B8 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 02B9 
; 0000 02BA // TWI initialization
; 0000 02BB // TWI disabled
; 0000 02BC TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 02BD 
; 0000 02BE // Global enable interrupts
; 0000 02BF #asm("sei")
	sei
; 0000 02C0 data = 8888;
	LDI  R30,LOW(8888)
	LDI  R31,HIGH(8888)
	MOVW R10,R30
; 0000 02C1 //delay_ms(1000);
; 0000 02C2 //ADE7753_INIT();
; 0000 02C3 //delay_ms(4000);
; 0000 02C4 reg = 0;
	LDI  R30,LOW(0)
	RCALL __CLRD1S0
; 0000 02C5 reg |= (1<<SWRST);
	LD   R30,Y
	ORI  R30,0x40
	ST   Y,R30
; 0000 02C6 ADE7753_WRITE(1,MODE,(reg>>8) & 0xFF,reg & 0xFF,0x00);
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
; 0000 02C7 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 02C8 reg = ADE7753_READ(1,MODE);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _ADE7753_READ
	RCALL __PUTD1S0
; 0000 02C9 // data = (reg >> 8) & 0xFF;
; 0000 02CA // data = reg & 0xFF;
; 0000 02CB //delay_ms(2000);
; 0000 02CC 
; 0000 02CD reg = ADE7753_READ(1,MODE);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _ADE7753_READ
	RCALL __PUTD1S0
; 0000 02CE // reg |= (1<<DISHPF) | (1<<WAVSEL0) | (1<<WAVSEL1) | (1<<DTRT0) | (1<<DTRT1) ;
; 0000 02CF reg |= (1<<WAVSEL0) | (1<<WAVSEL1) | (1<<DTRT0) | (1<<DTRT1) ;
	LDD  R30,Y+1
	ORI  R30,LOW(0x78)
	STD  Y+1,R30
; 0000 02D0 ADE7753_WRITE(1,MODE,(reg>>8) & 0xFF,reg & 0xFF,0x00);
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
; 0000 02D1 reg = ADE7753_READ(1,MODE);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _ADE7753_READ
	RCALL __PUTD1S0
; 0000 02D2 // data = reg;
; 0000 02D3 // data = (reg >> 8) & 0xFF;
; 0000 02D4 // data = reg & 0xFF;
; 0000 02D5 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 02D6 ADE7753_WRITE(1,SAGLVL,0X2a,0X00,0X00);
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
; 0000 02D7 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 02D8 ADE7753_WRITE(1,SAGCYC,0XFF,0X00,0X00);
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
; 0000 02D9 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 02DA 
; 0000 02DB BUZZER_ON;
	SBI  0x12,0
; 0000 02DC delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 02DD BUZZER_OFF;
	CBI  0x12,0
; 0000 02DE       while (1)
_0xEA:
; 0000 02DF       {
; 0000 02E0       // Place your code here
; 0000 02E1             READ_SELECT();
	RCALL _READ_SELECT
; 0000 02E2       }
	RJMP _0xEA
; 0000 02E3 }
_0xED:
	RJMP _0xED
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

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
