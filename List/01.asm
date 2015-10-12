
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 1,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	.DEF _timeSec=R5
	.DEF _timeMin=R4
	.DEF _indSwap=R7
	.DEF _isIndEnable=R6
	.DEF _btn1state=R9
	.DEF _btn1PressTime=R8
	.DEF _btn2PressTime=R11
	.DEF _btn2state=R10
	.DEF _migMig=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x6E:
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x1,0x0
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  _0x6E*2

_0xFFFFFFFF:
	.DW  0

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

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 15.09.2015
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 1,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
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
;
;#define RD1 PORTC.4
;#define RD2 PORTC.2
;#define RD3 PORTC.0
;#define RD4 PORTC.1
;#define RD5 PORTB.1
;#define RD6 PORTD.7
;#define RD7 PORTD.6
;#define RD8 PORTD.5
;#define RD9 PORTD.3
;#define RD10 PORTD.1
;#define RD11 PORTD.0
;#define RD12 PORTC.5
;#define LINE2 PORTB.0
;#define LINE1 PORTD.4
;#define BTN2 PIND.2
;#define BTN1 PINC.3
;
;#define MAX_TIME_OFF (20*1000)
;
;char time[3]={0,0,0};
;char timeSec=0, timeMin=0;
;char  indSwap=0, isIndEnable=1;
;char btn1state = 0, btn1PressTime = 0, btn2PressTime = 0, btn2state=1;
;char migMig=0;
;int indState, timeOff=0;
;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)  //1ms
; 0000 0038 {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0039 // Reinitialize Timer 0 value
; 0000 003A TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 003B 
; 0000 003C // Place your code here
; 0000 003D if(BTN1 == 0)
	SBIC 0x13,3
	RJMP _0x3
; 0000 003E {
; 0000 003F   timeOff = 0;
	RCALL SUBOPT_0x0
; 0000 0040   if(btn1PressTime == 50) //Антидребезг контактов
	LDI  R30,LOW(50)
	CP   R30,R8
	BRNE _0x4
; 0000 0041   {
; 0000 0042       btn1PressTime = 0;
	CLR  R8
; 0000 0043       if(++btn1state>3) btn1state=0;
	INC  R9
	LDI  R30,LOW(3)
	CP   R30,R9
	BRSH _0x5
	CLR  R9
; 0000 0044   }
_0x5:
; 0000 0045 }
_0x4:
; 0000 0046 else
	RJMP _0x6
_0x3:
; 0000 0047 {
; 0000 0048   if(btn1PressTime<50)btn1PressTime++;
	LDI  R30,LOW(50)
	CP   R8,R30
	BRSH _0x7
	INC  R8
; 0000 0049 }
_0x7:
_0x6:
; 0000 004A 
; 0000 004B if(BTN2 == 0)
	SBIC 0x10,2
	RJMP _0x8
; 0000 004C {
; 0000 004D    timeOff = 0;
	RCALL SUBOPT_0x0
; 0000 004E    if(++btn2PressTime > 250)
	INC  R11
	LDI  R30,LOW(250)
	CP   R30,R11
	BRSH _0x9
; 0000 004F    {
; 0000 0050       btn2PressTime = 0;
	CLR  R11
; 0000 0051       switch(btn1state)
	MOV  R30,R9
	RCALL SUBOPT_0x1
; 0000 0052       {
; 0000 0053         case 0:
	SBIW R30,0
	BRNE _0xD
; 0000 0054           if(--btn2state>1)btn2state=1;
	DEC  R10
	LDI  R30,LOW(1)
	CP   R30,R10
	BRSH _0xE
	MOV  R10,R30
; 0000 0055         break;
_0xE:
	RJMP _0xC
; 0000 0056         case 1:
_0xD:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xF
; 0000 0057         if(++time[0]>11)
	RCALL SUBOPT_0x2
	BRLO _0x10
; 0000 0058         {
; 0000 0059             time[0] = 0;
	RCALL SUBOPT_0x3
; 0000 005A             if(++timeMin>4)
	BRSH _0x11
; 0000 005B             {
; 0000 005C                   timeMin  = 0;
	RCALL SUBOPT_0x4
; 0000 005D                   if(++time[1] > 11)
	BRLO _0x12
; 0000 005E                   {
; 0000 005F                         time[1] = 0;
	RCALL SUBOPT_0x5
; 0000 0060                         if(++time[2]>11)
	BRLO _0x13
; 0000 0061                         {
; 0000 0062                             time[2]=0;
	RCALL SUBOPT_0x6
; 0000 0063                         }
; 0000 0064                   }
_0x13:
; 0000 0065             }
_0x12:
; 0000 0066         }
_0x11:
; 0000 0067         break;
_0x10:
	RJMP _0xC
; 0000 0068         case 2:
_0xF:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x14
; 0000 0069             if(++time[1] > 11)
	__GETB1MN _time,1
	SUBI R30,-LOW(1)
	__PUTB1MN _time,1
	CPI  R30,LOW(0xC)
	BRLO _0x15
; 0000 006A             {
; 0000 006B               time[1] = 0;
	RCALL SUBOPT_0x5
; 0000 006C               if(++time[2]>11)
	BRLO _0x16
; 0000 006D               {
; 0000 006E                   time[2]=0;
	RCALL SUBOPT_0x6
; 0000 006F               }
; 0000 0070             }
_0x16:
; 0000 0071         break;
_0x15:
	RJMP _0xC
; 0000 0072         case 3:
_0x14:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xC
; 0000 0073               if(++time[2]>11)
	__GETB1MN _time,2
	SUBI R30,-LOW(1)
	__PUTB1MN _time,2
	CPI  R30,LOW(0xC)
	BRLO _0x18
; 0000 0074               {
; 0000 0075                   time[2]=0;
	RCALL SUBOPT_0x6
; 0000 0076               }
; 0000 0077         break;
_0x18:
; 0000 0078       }
_0xC:
; 0000 0079    }
; 0000 007A }
_0x9:
; 0000 007B else
	RJMP _0x19
_0x8:
; 0000 007C {
; 0000 007D    btn2PressTime = 240; //Антидребезг контактов
	LDI  R30,LOW(240)
	MOV  R11,R30
; 0000 007E }
_0x19:
; 0000 007F 
; 0000 0080 
; 0000 0081 if(++timeOff < MAX_TIME_OFF)
	LDI  R26,LOW(_timeOff)
	LDI  R27,HIGH(_timeOff)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	CPI  R30,LOW(0x4E20)
	LDI  R26,HIGH(0x4E20)
	CPC  R31,R26
	BRLT PC+2
	RJMP _0x1A
; 0000 0082 {
; 0000 0083     if(btn1state==0)
	TST  R9
	BRNE _0x1B
; 0000 0084     {
; 0000 0085         indSwap &= 1; indSwap ^= 1;
	LDI  R30,LOW(1)
	AND  R7,R30
	EOR  R7,R30
; 0000 0086         indState = (int)1<<time[indSwap + btn2state];
	MOV  R26,R7
	CLR  R27
	MOV  R30,R10
	RCALL SUBOPT_0x1
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x6D
; 0000 0087     }
; 0000 0088     else
_0x1B:
; 0000 0089     {
; 0000 008A     btn2state=1;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 008B     if(btn1state==1) indSwap = 0;
	CP   R30,R9
	BRNE _0x1D
	CLR  R7
; 0000 008C     if(btn1state==2) indSwap = 1;
_0x1D:
	LDI  R30,LOW(2)
	CP   R30,R9
	BRNE _0x1E
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 008D     if(btn1state==3) indSwap = 2;
_0x1E:
	LDI  R30,LOW(3)
	CP   R30,R9
	BRNE _0x1F
	LDI  R30,LOW(2)
	MOV  R7,R30
; 0000 008E     indState = (int)1<<time[indSwap];
_0x1F:
	MOV  R30,R7
	RCALL SUBOPT_0x1
_0x6D:
	SUBI R30,LOW(-_time)
	SBCI R31,HIGH(-_time)
	LD   R30,Z
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __LSLW12
	STS  _indState,R30
	STS  _indState+1,R31
; 0000 008F     }
; 0000 0090     LINE1 = 0;
	CBI  0x12,4
; 0000 0091     LINE2 = 0;
	CBI  0x18,0
; 0000 0092     RD1 = (indState>>0)&1;
	RCALL SUBOPT_0x7
	ANDI R30,LOW(0x1)
	BRNE _0x24
	CBI  0x15,4
	RJMP _0x25
_0x24:
	SBI  0x15,4
_0x25:
; 0000 0093     RD2 = (indState>>1)&1;
	RCALL SUBOPT_0x7
	ASR  R31
	ROR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x26
	CBI  0x15,2
	RJMP _0x27
_0x26:
	SBI  0x15,2
_0x27:
; 0000 0094     RD3 = (indState>>2)&1;
	RCALL SUBOPT_0x7
	RCALL __ASRW2
	ANDI R30,LOW(0x1)
	BRNE _0x28
	CBI  0x15,0
	RJMP _0x29
_0x28:
	SBI  0x15,0
_0x29:
; 0000 0095     RD4 = (indState>>3)&1;
	RCALL SUBOPT_0x7
	RCALL __ASRW3
	ANDI R30,LOW(0x1)
	BRNE _0x2A
	CBI  0x15,1
	RJMP _0x2B
_0x2A:
	SBI  0x15,1
_0x2B:
; 0000 0096     RD5 = (indState>>4)&1;
	RCALL SUBOPT_0x7
	RCALL __ASRW4
	ANDI R30,LOW(0x1)
	BRNE _0x2C
	CBI  0x18,1
	RJMP _0x2D
_0x2C:
	SBI  0x18,1
_0x2D:
; 0000 0097     RD6 = (indState>>5)&1;
	RCALL SUBOPT_0x8
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x9
	BRNE _0x2E
	CBI  0x12,7
	RJMP _0x2F
_0x2E:
	SBI  0x12,7
_0x2F:
; 0000 0098     RD7 = (indState>>6)&1;
	RCALL SUBOPT_0x8
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x9
	BRNE _0x30
	CBI  0x12,6
	RJMP _0x31
_0x30:
	SBI  0x12,6
_0x31:
; 0000 0099     RD8 = (indState>>7)&1;
	RCALL SUBOPT_0x8
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x9
	BRNE _0x32
	CBI  0x12,5
	RJMP _0x33
_0x32:
	SBI  0x12,5
_0x33:
; 0000 009A     RD9 = (indState>>8)&1;
	RCALL SUBOPT_0x7
	RCALL __ASRW8
	ANDI R30,LOW(0x1)
	BRNE _0x34
	CBI  0x12,3
	RJMP _0x35
_0x34:
	SBI  0x12,3
_0x35:
; 0000 009B     RD10 = (indState>>9)&1;
	RCALL SUBOPT_0x8
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x9
	BRNE _0x36
	CBI  0x12,1
	RJMP _0x37
_0x36:
	SBI  0x12,1
_0x37:
; 0000 009C     RD11 = (indState>>10)&1;
	RCALL SUBOPT_0x8
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x9
	BRNE _0x38
	CBI  0x12,0
	RJMP _0x39
_0x38:
	SBI  0x12,0
_0x39:
; 0000 009D     RD12 = (indState>>11)&1;
	RCALL SUBOPT_0x8
	LDI  R30,LOW(11)
	RCALL SUBOPT_0x9
	BRNE _0x3A
	CBI  0x15,5
	RJMP _0x3B
_0x3A:
	SBI  0x15,5
_0x3B:
; 0000 009E 
; 0000 009F     if(btn1state==0 || migMig>125) // Мигание
	LDI  R30,LOW(0)
	CP   R30,R9
	BREQ _0x3D
	LDI  R30,LOW(125)
	CP   R30,R13
	BRSH _0x3C
_0x3D:
; 0000 00A0     {
; 0000 00A1       LINE1 = indSwap&1;
	SBRC R7,0
	RJMP _0x3F
	CBI  0x12,4
	RJMP _0x40
_0x3F:
	SBI  0x12,4
_0x40:
; 0000 00A2       LINE2 = (indSwap&1)^1;
	MOV  R30,R7
	ANDI R30,LOW(0x1)
	LDI  R26,LOW(1)
	EOR  R30,R26
	BRNE _0x41
	CBI  0x18,0
	RJMP _0x42
_0x41:
	SBI  0x18,0
_0x42:
; 0000 00A3     }
; 0000 00A4     if(++migMig>250) migMig=0;
_0x3C:
	INC  R13
	LDI  R30,LOW(250)
	CP   R30,R13
	BRSH _0x43
	CLR  R13
; 0000 00A5 }
_0x43:
; 0000 00A6 else
	RJMP _0x44
_0x1A:
; 0000 00A7 {
; 0000 00A8     btn2state=1;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 00A9     isIndEnable = 0;
	CLR  R6
; 0000 00AA     btn1state = 0;
	CLR  R9
; 0000 00AB     RD1 = 0;     //Выключаем светодиоды
	CBI  0x15,4
; 0000 00AC     RD2 = 0;
	CBI  0x15,2
; 0000 00AD     RD3 = 0;
	CBI  0x15,0
; 0000 00AE     RD4 = 0;
	CBI  0x15,1
; 0000 00AF     RD5 = 0;
	CBI  0x18,1
; 0000 00B0     RD6 = 0;
	CBI  0x12,7
; 0000 00B1     RD7 = 0;
	CBI  0x12,6
; 0000 00B2     RD8 = 0;
	CBI  0x12,5
; 0000 00B3     RD9 = 0;
	CBI  0x12,3
; 0000 00B4     RD10 = 0;
	CBI  0x12,1
; 0000 00B5     RD11 = 0;
	CBI  0x12,0
; 0000 00B6     RD12 = 0;
	CBI  0x15,5
; 0000 00B7     LINE1 = 0;
	CBI  0x12,4
; 0000 00B8     LINE2 = 0;
	CBI  0x18,0
; 0000 00B9 
; 0000 00BA }
_0x44:
; 0000 00BB 
; 0000 00BC }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 00C0 {
_timer2_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00C1     #asm("wdr")
	wdr
; 0000 00C2 
; 0000 00C3 if(btn1state==0 && ++timeSec > 4) //Считаем время, если статус кнопки = 0
	LDI  R30,LOW(0)
	CP   R30,R9
	BRNE _0x62
	INC  R5
	LDI  R30,LOW(4)
	CP   R30,R5
	BRLO _0x63
_0x62:
	RJMP _0x61
_0x63:
; 0000 00C4 {
; 0000 00C5     timeSec = 0;
	CLR  R5
; 0000 00C6     if(++time[0]>11)
	RCALL SUBOPT_0x2
	BRLO _0x64
; 0000 00C7     {
; 0000 00C8         time[0] = 0;
	RCALL SUBOPT_0x3
; 0000 00C9         if(++timeMin>4)
	BRSH _0x65
; 0000 00CA         {
; 0000 00CB               timeMin  = 0;
	RCALL SUBOPT_0x4
; 0000 00CC               if(++time[1] > 11)
	BRLO _0x66
; 0000 00CD               {
; 0000 00CE                     time[1] = 0;
	RCALL SUBOPT_0x5
; 0000 00CF                     if(++time[2]>11)
	BRLO _0x67
; 0000 00D0                     {
; 0000 00D1                         time[2]=0;
	RCALL SUBOPT_0x6
; 0000 00D2                     }
; 0000 00D3               }
_0x67:
; 0000 00D4         }
_0x66:
; 0000 00D5     }
_0x65:
; 0000 00D6 }
_0x64:
; 0000 00D7 
; 0000 00D8     if(!isIndEnable) //Идем спать
_0x61:
	TST  R6
	BRNE _0x68
; 0000 00D9     {
; 0000 00DA         btn1state = 0;
	CLR  R9
; 0000 00DB         TCCR0=0x00; //Выключаем таймер 0, для экономии энергии
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00DC         GICR|=0x40; //Включаем INT0, чтоб проснутся по кнопке
	IN   R30,0x3B
	ORI  R30,0x40
	RCALL SUBOPT_0xA
; 0000 00DD         GIFR|=0x40; //Сбрасываем флаг прерывания INT0
; 0000 00DE         TIFR|=0x41; //Сбрасываем флаг прерывания таймеров
	IN   R30,0x38
	ORI  R30,LOW(0x41)
	OUT  0x38,R30
; 0000 00DF         #asm("sei") //Разрешаем прерывания глобально
	sei
; 0000 00E0         MCUCR |= 128; //Разрешаем сон
	IN   R30,0x35
	ORI  R30,0x80
	OUT  0x35,R30
; 0000 00E1         #asm("sleep") //Спим
	sleep
; 0000 00E2     }
; 0000 00E3 }
_0x68:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 00E8 {
_ext_int0_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00E9   //Просыпаемся
; 0000 00EA   MCUCR &= ~128; //Запрещаем спать (хз зачем)
	IN   R30,0x35
	ANDI R30,0x7F
	OUT  0x35,R30
; 0000 00EB   GICR&= ~0x40;   // Выключаем INT0, чтоб не сидеть в нем вечно
	IN   R30,0x3B
	ANDI R30,0xBF
	RCALL SUBOPT_0xA
; 0000 00EC   GIFR|= 0x40;    // Сбрасываем флаг (на всяк случай)
; 0000 00ED   TCCR0=0x02;     // Запускаем таймер 0
	RCALL SUBOPT_0xB
; 0000 00EE   TCNT0=0x83;
; 0000 00EF   isIndEnable = 1; //Включаем индикацию
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 00F0 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;
;// Declare your global variables here
;
;void main(void)
; 0000 00F6 {
_main:
; 0000 00F7 // Declare your local variables here
; 0000 00F8 
; 0000 00F9 // Input/Output Ports initialization
; 0000 00FA // Port B initialization
; 0000 00FB // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out
; 0000 00FC // State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=0
; 0000 00FD PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00FE DDRB=0x03;
	LDI  R30,LOW(3)
	OUT  0x17,R30
; 0000 00FF 
; 0000 0100 // Port C initialization
; 0000 0101 // Func6=In Func5=Out Func4=Out Func3=In Func2=Out Func1=Out Func0=Out
; 0000 0102 // State6=T State5=0 State4=0 State3=P State2=0 State1=0 State0=0
; 0000 0103 PORTC=0x08;
	LDI  R30,LOW(8)
	OUT  0x15,R30
; 0000 0104 DDRC=0x37;
	LDI  R30,LOW(55)
	OUT  0x14,R30
; 0000 0105 
; 0000 0106 // Port D initialization
; 0000 0107 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=Out Func0=Out
; 0000 0108 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=P State1=0 State0=0
; 0000 0109 PORTD=0x04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 010A DDRD=0xFB;
	LDI  R30,LOW(251)
	OUT  0x11,R30
; 0000 010B 
; 0000 010C 
; 0000 010D // Timer/Counter 0 initialization
; 0000 010E // Clock source: System Clock
; 0000 010F // Clock value: 125,000 kHz
; 0000 0110 TCCR0=0x02;
	RCALL SUBOPT_0xB
; 0000 0111 TCNT0=0x83;
; 0000 0112 
; 0000 0113 // Timer/Counter 1 initialization
; 0000 0114 // Clock source: System Clock
; 0000 0115 // Clock value: Timer1 Stopped
; 0000 0116 // Mode: Normal top=0xFFFF
; 0000 0117 // OC1A output: Discon.
; 0000 0118 // OC1B output: Discon.
; 0000 0119 // Noise Canceler: Off
; 0000 011A // Input Capture on Falling Edge
; 0000 011B // Timer1 Overflow Interrupt: Off
; 0000 011C // Input Capture Interrupt: Off
; 0000 011D // Compare A Match Interrupt: Off
; 0000 011E // Compare B Match Interrupt: Off
; 0000 011F TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0120 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0121 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0122 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0123 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0124 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0125 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0126 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0127 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0128 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0129 
; 0000 012A // Timer/Counter 2 initialization
; 0000 012B // Clock source: TOSC1 pin
; 0000 012C // Clock value: PCK2/128
; 0000 012D // Mode: Normal top=0xFF
; 0000 012E // OC2 output: Disconnected
; 0000 012F ASSR=0x08;
	LDI  R30,LOW(8)
	OUT  0x22,R30
; 0000 0130 TCCR2=0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 0131 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0132 OCR2=0x00;
	OUT  0x23,R30
; 0000 0133 
; 0000 0134 // External Interrupt(s) initialization
; 0000 0135 // INT0: On
; 0000 0136 // INT0 Mode: Low level
; 0000 0137 // INT1: Off
; 0000 0138 GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0139 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 013A GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 013B 
; 0000 013C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 013D TIMSK=0x41;
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 013E 
; 0000 013F // USART initialization
; 0000 0140 // USART disabled
; 0000 0141 UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 0142 
; 0000 0143 // Analog Comparator initialization
; 0000 0144 // Analog Comparator: Off
; 0000 0145 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0146 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0147 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0148 
; 0000 0149 // ADC initialization
; 0000 014A // ADC disabled
; 0000 014B ADCSRA=0x00;
	OUT  0x6,R30
; 0000 014C 
; 0000 014D // SPI initialization
; 0000 014E // SPI disabled
; 0000 014F SPCR=0x00;
	OUT  0xD,R30
; 0000 0150 
; 0000 0151 // TWI initialization
; 0000 0152 // TWI disabled
; 0000 0153 TWCR=0x00;
	OUT  0x36,R30
; 0000 0154 
; 0000 0155 // Watchdog Timer initialization
; 0000 0156 // Watchdog Timer Prescaler: OSC/2048k
; 0000 0157 #pragma optsize-
; 0000 0158 //WDTCR=0x1F;
; 0000 0159 //WDTCR=0x0F;
; 0000 015A #ifdef _OPTIMIZE_SIZE_
; 0000 015B #pragma optsize+
; 0000 015C #endif
; 0000 015D 
; 0000 015E MCUCR |= 0b00110000; //Power-save
	IN   R30,0x35
	ORI  R30,LOW(0x30)
	OUT  0x35,R30
; 0000 015F 
; 0000 0160 // Global enable interrupts
; 0000 0161 #asm("sei")
	sei
; 0000 0162 
; 0000 0163 while (1)
_0x69:
; 0000 0164       {
; 0000 0165 
; 0000 0166 
; 0000 0167       }
	RJMP _0x69
; 0000 0168 }
_0x6C:
	RJMP _0x6C

	.DSEG
_time:
	.BYTE 0x3
_indState:
	.BYTE 0x2
_timeOff:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	STS  _timeOff,R30
	STS  _timeOff+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDS  R26,_time
	SUBI R26,-LOW(1)
	STS  _time,R26
	CPI  R26,LOW(0xC)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	STS  _time,R30
	INC  R4
	LDI  R30,LOW(4)
	CP   R30,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	CLR  R4
	__GETB1MN _time,1
	SUBI R30,-LOW(1)
	__PUTB1MN _time,1
	CPI  R30,LOW(0xC)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	__PUTB1MN _time,1
	__GETB1MN _time,2
	SUBI R30,-LOW(1)
	__PUTB1MN _time,2
	CPI  R30,LOW(0xC)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	__PUTB1MN _time,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	LDS  R30,_indState
	LDS  R31,_indState+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x8:
	LDS  R26,_indState
	LDS  R27,_indState+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	RCALL __ASRW12
	ANDI R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	OUT  0x3B,R30
	IN   R30,0x3A
	ORI  R30,0x40
	OUT  0x3A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(2)
	OUT  0x33,R30
	LDI  R30,LOW(131)
	OUT  0x32,R30
	RET


	.CSEG
__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

;END OF CODE MARKER
__END_OF_CODE:
