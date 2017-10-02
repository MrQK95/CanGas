
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 11.059200 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _Recive=R5
	.DEF _SCALE=R6
	.DEF _SCALE_msb=R7
	.DEF _blink=R4
	.DEF _T_can=R8
	.DEF _T_can_msb=R9
	.DEF _SETUP_W=R10
	.DEF _SETUP_W_msb=R11

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0xCE,0x2
	.DB  0x0,0x0,0x0,0x0

_0x3:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F
_0x4:
	.DB  0xE,0x16,0x6,0x1A,0xA,0x12,0x2,0x1C
	.DB  0xC,0x14,0x4,0x18,0x8,0x10
_0x5:
	.DB  0x5E,0x78,0x5F,0x30,0x38,0x79,0x0,0x3D
	.DB  0x77,0x6D,0x79,0x0,0x39,0x77,0x54,0x6D
	.DB  0x39,0x77,0x38,0x79,0x6D,0x79,0x78,0x0
	.DB  0x0,0x79,0x50,0x50,0x5C,0x50

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  _so
	.DW  _0x3*2

	.DW  0x0E
	.DW  _led
	.DW  _0x4*2

	.DW  0x1E
	.DW  _chu
	.DW  _0x5*2

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
	OUT  MCUCR,R31
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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32a.h>
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
;#include <delay.h>
;
;#define Data PORTA
;#define LEDPORT PORTB
;#define H1 PORTC.2
;#define H2 PORTC.3
;#define H3 PORTC.4
;#define H4 PORTC.5
;#define H5 PORTC.6
;#define C1 PIND.3
;#define C2 PIND.4
;#define C3 PIND.5
;#define C4 PIND.6
;#define C5 PIND.7
;#define Coi PORTC.7
;#define Opto PORTB.0
;
;unsigned char so[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};

	.DSEG
;char led[3][5] = {{0x0E,0x16,0x06,0x1A,0x0A},
;                  {0x12,0x02,0x1C,0x0C,0x14},
;                  {0x04,0x18,0x08,0x10,0x00}};
;unsigned char chu[7][5]={{0x5E,0x78,0x5F,0x30,0x38}, //dtail
;                        {0x79,0x00,0x3D,0x77,0x6D}, //T Gas
;                        {0x79,0x00,0x39,0x77,0x54}, //T Can
;                        {0x6D,0x39,0x77,0x38,0x79}, //SCALE
;                        {0x6D,0x79,0x78,0x00,0x00}, //SEt
;                        {0x79,0x50,0x50,0x5C,0x50}, //Error
;                        {0x00,0x00,0x00,0x00,0x00}};
;
;unsigned char Recive;     //UART
;
;long OFFSET=0;
;int SCALE=718.0;
;unsigned char blink=0;
;float T_gas=0;
;unsigned int T_can=0;
;int SETUP_W=0;
;
;//void RX();
;void TX(unsigned char x);
;
;void UART_Init();
;void GPIO_Init();
;void TIM1_Init();
;float get_units(char times);
;void tare(char times);
;char quetphim();
;void hienso(unsigned char a, float s);
;void start();
;void Details();
;void Smart_conf();
;void Set_scale();
;
;interrupt [USART_RXC] void usart_rx_isr(void)   {if(UCSRA.7==1)  Recive=UDR;}
; 0000 0037 interrupt [14] void usart_rx_isr(void)   {if(UCSRA.7==1)  Recive=UDR;}

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	SBIC 0xB,7
	IN   R5,12
	RETI
; .FEND
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void){
; 0000 0039 interrupt [10] void timer1_ovf_isr(void){
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
; 0000 003A     static char dk_sent=0;
; 0000 003B     blink++;
	INC  R4
; 0000 003C     dk_sent++;
	LDS  R30,_dk_sent_S0000001000
	SUBI R30,-LOW(1)
	STS  _dk_sent_S0000001000,R30
; 0000 003D     if(blink>2) blink=0;
	LDI  R30,LOW(2)
	CP   R30,R4
	BRSH _0x7
	CLR  R4
; 0000 003E     if(dk_sent>29) {TX(' '); dk_sent=0;} //Gui du lieu len Server sau 30s
_0x7:
	LDS  R26,_dk_sent_S0000001000
	CPI  R26,LOW(0x1E)
	BRLO _0x8
	LDI  R26,LOW(32)
	RCALL _TX
	LDI  R30,LOW(0)
	STS  _dk_sent_S0000001000,R30
; 0000 003F     TCNT1H=0xD5;
_0x8:
	LDI  R30,LOW(213)
	OUT  0x2D,R30
; 0000 0040     TCNT1L=0xCF;
	LDI  R30,LOW(207)
	OUT  0x2C,R30
; 0000 0041 }
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
;void main(void){
; 0000 0042 void main(void){
_main:
; .FSTART _main
; 0000 0043     float c_value=0;
; 0000 0044     GPIO_Init();
	RCALL SUBOPT_0x0
;	c_value -> Y+0
	RCALL _GPIO_Init
; 0000 0045     UART_Init();
	RCALL _UART_Init
; 0000 0046     TIM1_Init();
	RCALL _TIM1_Init
; 0000 0047     start();
	RCALL _start
; 0000 0048     while (1)
_0x9:
; 0000 0049     {
; 0000 004A          c_value=get_units(20);
	LDI  R26,LOW(20)
	RCALL _get_units
	RCALL SUBOPT_0x1
; 0000 004B          hienso(0,c_value);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL SUBOPT_0x2
	RCALL _hienso
; 0000 004C          hienso(1,SETUP_W);
	LDI  R30,LOW(1)
	ST   -Y,R30
	MOVW R30,R10
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 004D          hienso(2,SETUP_W-c_value);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL SUBOPT_0x5
	MOVW R26,R10
	CALL __CWD2
	CALL __CDF2
	CALL __SWAPD12
	CALL __SUBF12
	RCALL SUBOPT_0x4
; 0000 004E          switch(quetphim()){
	RCALL _quetphim
; 0000 004F             case 'T':{          //nut Total
	CPI  R30,LOW(0x54)
	BRNE _0xF
; 0000 0050                 Details();
	RCALL _Details
; 0000 0051                 break;
	RJMP _0xE
; 0000 0052             }
; 0000 0053             case 'Z':{          //nut Zero
_0xF:
	CPI  R30,LOW(0x5A)
	BRNE _0x10
; 0000 0054                 tare(20);
	LDI  R26,LOW(20)
	RCALL _tare
; 0000 0055                 break;
	RJMP _0xE
; 0000 0056             }
; 0000 0057             case 'C':{         //nut Cal
_0x10:
	CPI  R30,LOW(0x43)
	BRNE _0x11
; 0000 0058                 Smart_conf();
	RCALL _Smart_conf
; 0000 0059                 break;
	RJMP _0xE
; 0000 005A             }
; 0000 005B             case 'F':{         //nut SF/SC
_0x11:
	CPI  R30,LOW(0x46)
	BRNE _0xE
; 0000 005C                 Set_scale();
	RCALL _Set_scale
; 0000 005D                 break;
; 0000 005E             }
; 0000 005F          }
_0xE:
; 0000 0060     }
	RJMP _0x9
; 0000 0061 }
_0x13:
	RJMP _0x13
; .FEND
;
;void GPIO_Init(){
; 0000 0063 void GPIO_Init(){
_GPIO_Init:
; .FSTART _GPIO_Init
; 0000 0064     DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0065     PORTA=0;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0066     DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0067     PORTB=0xFF;
	OUT  0x18,R30
; 0000 0068     DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(254)
	OUT  0x14,R30
; 0000 0069     PORTC=(0<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (0<<PORTC1) | (1<<PORTC0);
	LDI  R30,LOW(125)
	OUT  0x15,R30
; 0000 006A     DDRD=0;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 006B     PORTD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 006C }
	RET
; .FEND
;
;void UART_Init(){
; 0000 006E void UART_Init(){
_UART_Init:
; .FSTART _UART_Init
; 0000 006F     UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0070     UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0071     UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0072     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0073     UBRRL=0x47;
	LDI  R30,LOW(71)
	OUT  0x9,R30
; 0000 0074 }
	RET
; .FEND
;
;void TIM1_Init(){
; 0000 0076 void TIM1_Init(){
_TIM1_Init:
; .FSTART _TIM1_Init
; 0000 0077     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0078     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);   //clock/1024=10800 H ...
	LDI  R30,LOW(13)
	OUT  0x2E,R30
; 0000 0079     TCNT1H=0xD5;
	LDI  R30,LOW(213)
	OUT  0x2D,R30
; 0000 007A     TCNT1L=0xCF;
	LDI  R30,LOW(207)
	OUT  0x2C,R30
; 0000 007B     ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 007C     ICR1L=0x00;
	OUT  0x26,R30
; 0000 007D     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 007E     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 007F     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0080     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0081 }
	RET
; .FEND
;
;void hienso(unsigned char a, float s){
; 0000 0083 void hienso(unsigned char a, float s){
_hienso:
; .FSTART _hienso
; 0000 0084     int h;
; 0000 0085     char p,b;
; 0000 0086     int tr,ch,dv,tp1,tp2;
; 0000 0087     if(s<1000){
	CALL __PUTPARD2
	SBIW R28,8
	CALL __SAVELOCR6
;	a -> Y+18
;	s -> Y+14
;	h -> R16,R17
;	p -> R19
;	b -> R18
;	tr -> R20,R21
;	ch -> Y+12
;	dv -> Y+10
;	tp1 -> Y+8
;	tp2 -> Y+6
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
	BRSH _0x14
; 0000 0088         h = s*100;
	RCALL SUBOPT_0x6
	__GETD1N 0x42C80000
	CALL __MULF12
	CALL __CFD1
	MOVW R16,R30
; 0000 0089         p=0x80;
	LDI  R19,LOW(128)
; 0000 008A         b=0x00;
	RJMP _0x9F
; 0000 008B     }
; 0000 008C     else{
_0x14:
; 0000 008D         if((s>=1000)&&(s<10000)){
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
	BRLO _0x17
	RCALL SUBOPT_0x6
	__GETD1N 0x461C4000
	CALL __CMPF12
	BRLO _0x18
_0x17:
	RJMP _0x16
_0x18:
; 0000 008E             h=s*10;
	RCALL SUBOPT_0x6
	__GETD1N 0x41200000
	CALL __MULF12
	CALL __CFD1
	MOVW R16,R30
; 0000 008F             p=0x00;
	LDI  R19,LOW(0)
; 0000 0090             b=0x80;
	LDI  R18,LOW(128)
; 0000 0091         }
; 0000 0092         else{
	RJMP _0x19
_0x16:
; 0000 0093             h=s;
	__GETD1S 14
	CALL __CFD1
	MOVW R16,R30
; 0000 0094             p=0x00;
	LDI  R19,LOW(0)
; 0000 0095             b=0x00;
_0x9F:
	LDI  R18,LOW(0)
; 0000 0096         }
_0x19:
; 0000 0097     }
; 0000 0098     tr = h/10000;
	MOVW R26,R16
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CALL __DIVW21
	MOVW R20,R30
; 0000 0099     ch = (h%10000)/1000;
	MOVW R26,R16
	RCALL SUBOPT_0x8
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 009A     dv = (h%1000)/100;
	MOVW R26,R16
	RCALL SUBOPT_0x9
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 009B     tp1 = (h%100)/10;
	MOVW R26,R16
	RCALL SUBOPT_0xA
; 0000 009C     tp2 = h%10;
	MOVW R26,R16
	RCALL SUBOPT_0xB
; 0000 009D     LEDPORT = (LEDPORT&0xE1)|led[a][0];
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 009E     Data = so[tr];
	RCALL SUBOPT_0xE
; 0000 009F     delay_ms(1);
; 0000 00A0     LEDPORT = (LEDPORT&0xE1)|led[a][1];
	RCALL SUBOPT_0xC
	__ADDW1MN _led,1
	LD   R30,Z
	OR   R30,R22
	OUT  0x18,R30
; 0000 00A1     Data = so[ch];
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	RCALL SUBOPT_0xF
; 0000 00A2     delay_ms(1);
; 0000 00A3     LEDPORT = (LEDPORT&0xE1)|led[a][2];
	RCALL SUBOPT_0x10
	__ADDW1MN _led,2
	LD   R30,Z
	OR   R30,R22
	OUT  0x18,R30
; 0000 00A4     Data = so[dv]|p;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUBI R30,LOW(-_so)
	SBCI R31,HIGH(-_so)
	LD   R30,Z
	OR   R30,R19
	RCALL SUBOPT_0x11
; 0000 00A5     delay_ms(1);
; 0000 00A6     LEDPORT = (LEDPORT&0xE1)|led[a][3];
	RCALL SUBOPT_0x12
; 0000 00A7     Data = so[tp1]|b;
	SUBI R30,LOW(-_so)
	SBCI R31,HIGH(-_so)
	LD   R30,Z
	OR   R30,R18
	RCALL SUBOPT_0x11
; 0000 00A8     delay_ms(1);
; 0000 00A9     LEDPORT = (LEDPORT&0xE1)|led[a][4];
	RCALL SUBOPT_0x13
; 0000 00AA     Data = so[tp2];
; 0000 00AB     delay_ms(1);
; 0000 00AC }
	CALL __LOADLOCR6
	ADIW R28,19
	RET
; .FEND
;
;void hienso_int(unsigned char a,int h){
; 0000 00AE void hienso_int(unsigned char a,int h){
_hienso_int:
; .FSTART _hienso_int
; 0000 00AF     int tr,ch,dv,tp1,tp2;
; 0000 00B0     tr = h/10000;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR6
;	a -> Y+12
;	h -> Y+10
;	tr -> R16,R17
;	ch -> R18,R19
;	dv -> R20,R21
;	tp1 -> Y+8
;	tp2 -> Y+6
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CALL __DIVW21
	MOVW R16,R30
; 0000 00B1     ch = (h%10000)/1000;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0x8
	MOVW R18,R30
; 0000 00B2     dv = (h%1000)/100;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0x9
	MOVW R20,R30
; 0000 00B3     tp1 = (h%100)/10;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0xA
; 0000 00B4     tp2 = h%10;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0xB
; 0000 00B5     LEDPORT = (LEDPORT&0xE1)|led[a][0];
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xD
; 0000 00B6     Data = so[tr];
	ADD  R26,R16
	ADC  R27,R17
	RCALL SUBOPT_0x15
; 0000 00B7     delay_ms(1);
; 0000 00B8     LEDPORT = (LEDPORT&0xE1)|led[a][1];
	__ADDW1MN _led,1
	LD   R30,Z
	OR   R30,R22
	OUT  0x18,R30
; 0000 00B9     Data = so[ch];
	LDI  R26,LOW(_so)
	LDI  R27,HIGH(_so)
	ADD  R26,R18
	ADC  R27,R19
	RCALL SUBOPT_0x15
; 0000 00BA     delay_ms(1);
; 0000 00BB     LEDPORT = (LEDPORT&0xE1)|led[a][2];
	__ADDW1MN _led,2
	LD   R30,Z
	OR   R30,R22
	OUT  0x18,R30
; 0000 00BC     Data = so[dv];
	LDI  R26,LOW(_so)
	LDI  R27,HIGH(_so)
	RCALL SUBOPT_0xE
; 0000 00BD     delay_ms(1);
; 0000 00BE     LEDPORT = (LEDPORT&0xE1)|led[a][3];
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x12
; 0000 00BF     Data = so[tp1];
	RCALL SUBOPT_0xF
; 0000 00C0     delay_ms(1);
; 0000 00C1     LEDPORT = (LEDPORT&0xE1)|led[a][4];
	IN   R30,0x18
	ANDI R30,LOW(0xE1)
	MOV  R22,R30
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x13
; 0000 00C2     Data = so[tp2];
; 0000 00C3     delay_ms(1);
; 0000 00C4 }
	CALL __LOADLOCR6
	ADIW R28,13
	RET
; .FEND
;
;void hienso_start(unsigned char h){
; 0000 00C6 void hienso_start(unsigned char h){
_hienso_start:
; .FSTART _hienso_start
; 0000 00C7     unsigned char i;
; 0000 00C8     for(i=0;i<5;i++){
	ST   -Y,R26
	ST   -Y,R17
;	h -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x1B:
	CPI  R17,5
	BRSH _0x1C
; 0000 00C9         LEDPORT = (LEDPORT&0xE1)|led[0][i];
	IN   R30,0x18
	ANDI R30,LOW(0xE1)
	MOV  R26,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_led)
	SBCI R31,HIGH(-_led)
	LD   R30,Z
	OR   R30,R26
	RCALL SUBOPT_0x16
; 0000 00CA         Data = so[h];
; 0000 00CB         LEDPORT = (LEDPORT&0xE1)|led[1][i];
	__POINTW2MN _led,5
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	OR   R30,R0
	RCALL SUBOPT_0x16
; 0000 00CC         Data = so[h];
; 0000 00CD         LEDPORT = (LEDPORT&0xE1)|led[2][i];
	__POINTW2MN _led,10
	RCALL SUBOPT_0x17
	OR   R30,R0
	OUT  0x18,R30
; 0000 00CE         Data = so[h];
	LDD  R30,Y+1
	LDI  R31,0
	RCALL SUBOPT_0xF
; 0000 00CF         delay_ms(1);
; 0000 00D0     }
	SUBI R17,-1
	RJMP _0x1B
_0x1C:
; 0000 00D1 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
; .FEND
;
;void hien_chu(unsigned char a,unsigned char b){         //dong, chu
; 0000 00D3 void hien_chu(unsigned char a,unsigned char b){
_hien_chu:
; .FSTART _hien_chu
; 0000 00D4     unsigned char i;
; 0000 00D5     for(i=0;i<5;i++){
	ST   -Y,R26
	ST   -Y,R17
;	a -> Y+2
;	b -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x1E:
	CPI  R17,5
	BRSH _0x1F
; 0000 00D6         LEDPORT = (LEDPORT&0xE1)|led[a][i];
	IN   R30,0x18
	ANDI R30,LOW(0xE1)
	MOV  R22,R30
	LDD  R30,Y+2
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_led)
	SBCI R31,HIGH(-_led)
	MOVW R26,R30
	RCALL SUBOPT_0x17
	OR   R30,R22
	OUT  0x18,R30
; 0000 00D7         Data = chu[b][i];
	LDD  R30,Y+1
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_chu)
	SBCI R31,HIGH(-_chu)
	MOVW R26,R30
	RCALL SUBOPT_0x17
	OUT  0x1B,R30
; 0000 00D8         delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 00D9     }
	SUBI R17,-1
	RJMP _0x1E
_0x1F:
; 0000 00DA }
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
;
;char quetphim(){
; 0000 00DC char quetphim(){
_quetphim:
; .FSTART _quetphim
; 0000 00DD     char key = 255;
; 0000 00DE     H1 = 0; H2 = 1; H3 = 1; H4 = 1; H5 = 1;
	ST   -Y,R17
;	key -> R17
	LDI  R17,255
	CBI  0x15,2
	SBI  0x15,3
	SBI  0x15,4
	SBI  0x15,5
	SBI  0x15,6
; 0000 00DF     if(C1==0)   key = 'a';   //24.00
	SBIS 0x10,3
	LDI  R17,LOW(97)
; 0000 00E0     if(C2==0)   key = 'b';   //25.00
	SBIS 0x10,4
	LDI  R17,LOW(98)
; 0000 00E1     if(C3==0)   key = 'c';   //26.00
	SBIS 0x10,5
	LDI  R17,LOW(99)
; 0000 00E2     if(C4==0)   key = 'd';   //80.00
	SBIS 0x10,6
	LDI  R17,LOW(100)
; 0000 00E3     if(C5==0)   key = 'e';   //90.00
	SBIS 0x10,7
	LDI  R17,LOW(101)
; 0000 00E4 
; 0000 00E5     H1 = 1; H2 = 0; H3 = 1; H4 = 1; H5 = 1;
	SBI  0x15,2
	CBI  0x15,3
	SBI  0x15,4
	SBI  0x15,5
	SBI  0x15,6
; 0000 00E6     if(C1==0)   key = 'T';   //Total
	SBIS 0x10,3
	LDI  R17,LOW(84)
; 0000 00E7     if(C2==0)   key = 1;
	SBIS 0x10,4
	LDI  R17,LOW(1)
; 0000 00E8     if(C3==0)   key = 2;
	SBIS 0x10,5
	LDI  R17,LOW(2)
; 0000 00E9     if(C4==0)   key = 3;
	SBIS 0x10,6
	LDI  R17,LOW(3)
; 0000 00EA     if(C5==0)   key = 4;
	SBIS 0x10,7
	LDI  R17,LOW(4)
; 0000 00EB 
; 0000 00EC     H1 = 1; H2 = 1; H3 = 0; H4 = 1; H5 = 1;
	SBI  0x15,2
	SBI  0x15,3
	CBI  0x15,4
	SBI  0x15,5
	SBI  0x15,6
; 0000 00ED     if(C1==0)   key = 'Z';   //Zero
	SBIS 0x10,3
	LDI  R17,LOW(90)
; 0000 00EE     if(C2==0)   key = 5;
	SBIS 0x10,4
	LDI  R17,LOW(5)
; 0000 00EF     if(C3==0)   key = 6;
	SBIS 0x10,5
	LDI  R17,LOW(6)
; 0000 00F0     if(C4==0)   key = 7;
	SBIS 0x10,6
	LDI  R17,LOW(7)
; 0000 00F1     if(C5==0)   key = 8;
	SBIS 0x10,7
	LDI  R17,LOW(8)
; 0000 00F2 
; 0000 00F3     H1 = 1; H2 = 1; H3 = 1; H4 = 0; H5 = 1;
	SBI  0x15,2
	SBI  0x15,3
	SBI  0x15,4
	CBI  0x15,5
	SBI  0x15,6
; 0000 00F4     if(C1==0)   key = 'C';  //Cal
	SBIS 0x10,3
	LDI  R17,LOW(67)
; 0000 00F5     if(C2==0)   key = 'E';  //exit
	SBIS 0x10,4
	LDI  R17,LOW(69)
; 0000 00F6     if(C3==0)   key = 'c';  //Clear
	SBIS 0x10,5
	LDI  R17,LOW(99)
; 0000 00F7     if(C4==0)   key = 9;
	SBIS 0x10,6
	LDI  R17,LOW(9)
; 0000 00F8     if(C5==0)   key = 0;
	SBIS 0x10,7
	LDI  R17,LOW(0)
; 0000 00F9 
; 0000 00FA     H1 = 1; H2 = 1; H3 = 1; H4 = 1; H5 = 0;
	SBI  0x15,2
	SBI  0x15,3
	SBI  0x15,4
	SBI  0x15,5
	CBI  0x15,6
; 0000 00FB     if(C1==0)   key = 'F';  //SF/SC
	SBIS 0x10,3
	LDI  R17,LOW(70)
; 0000 00FC     if(C2==0)   key = 'P';  //Pro
	SBIS 0x10,4
	LDI  R17,LOW(80)
; 0000 00FD     if(C3==0)   key = 'e';  //Enter
	SBIS 0x10,5
	LDI  R17,LOW(101)
; 0000 00FE     if(C4==0)   key = 'S';  //Stop
	SBIS 0x10,6
	LDI  R17,LOW(83)
; 0000 00FF     if(C5==0)   key = 's';  //Start
	SBIS 0x10,7
	LDI  R17,LOW(115)
; 0000 0100 
; 0000 0101     return key;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0102 }
; .FEND
;
;void TX(unsigned char x){
; 0000 0104 void TX(unsigned char x){
_TX:
; .FSTART _TX
; 0000 0105     while(UCSRA.5==0);
	ST   -Y,R26
;	x -> Y+0
_0x6B:
	SBIS 0xB,5
	RJMP _0x6B
; 0000 0106     UDR=x;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0107 }
	RJMP _0x2000003
; .FEND
;
;//void RX(){  if(UCSRA.7==1){Recive=UDR;}   }
;
;unsigned long HX_read(){
; 0000 010B unsigned long HX_read(){
_HX_read:
; .FSTART _HX_read
; 0000 010C     unsigned long value = 0;
; 0000 010D     unsigned char i=0;
; 0000 010E     PORTC.4=0;
	RCALL SUBOPT_0x0
	ST   -Y,R17
;	value -> Y+1
;	i -> R17
	LDI  R17,0
	CBI  0x15,4
; 0000 010F     PORTC.5=0;
	CBI  0x15,5
; 0000 0110     for(i=0;i<24;i++){
	LDI  R17,LOW(0)
_0x73:
	CPI  R17,24
	BRSH _0x74
; 0000 0111         PORTC.1=1;
	SBI  0x15,1
; 0000 0112         value=value*2;
	RCALL SUBOPT_0x5
	CALL __LSLD1
	RCALL SUBOPT_0x18
; 0000 0113         PORTC.1=0;
	CBI  0x15,1
; 0000 0114         if(PINC.0) value++;
	SBIS 0x13,0
	RJMP _0x79
	RCALL SUBOPT_0x5
	__SUBD1N -1
	RCALL SUBOPT_0x18
; 0000 0115     }
_0x79:
	SUBI R17,-1
	RJMP _0x73
_0x74:
; 0000 0116     PORTC.1=1;
	SBI  0x15,1
; 0000 0117     value=value^0x800000;
	RCALL SUBOPT_0x2
	__GETD1N 0x800000
	CALL __XORD12
	RCALL SUBOPT_0x18
; 0000 0118     PORTC.1=0;
	CBI  0x15,1
; 0000 0119     return value;
	RCALL SUBOPT_0x5
	LDD  R17,Y+0
	RJMP _0x2000002
; 0000 011A }
; .FEND
;
;float read_average(char times){
; 0000 011C float read_average(char times){
_read_average:
; .FSTART _read_average
; 0000 011D     float sum = 0;
; 0000 011E     char i=0;
; 0000 011F 	for (i = 0; i < times; i++) {sum += HX_read();}
	ST   -Y,R26
	RCALL SUBOPT_0x0
	ST   -Y,R17
;	times -> Y+5
;	sum -> Y+1
;	i -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0x7F:
	LDD  R30,Y+5
	CP   R17,R30
	BRSH _0x80
	RCALL _HX_read
	RCALL SUBOPT_0x2
	CALL __CDF1U
	CALL __ADDF12
	RCALL SUBOPT_0x18
	SUBI R17,-1
	RJMP _0x7F
_0x80:
; 0000 0120 	return sum / times;
	LDD  R30,Y+5
	LDI  R31,0
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x19
	LDD  R17,Y+0
	ADIW R28,6
	RET
; 0000 0121 }
; .FEND
;
;float get_value(char times){
; 0000 0123 float get_value(char times){
_get_value:
; .FSTART _get_value
; 0000 0124     float tem;
; 0000 0125     tem = read_average(times) - OFFSET;
	ST   -Y,R26
	SBIW R28,4
;	times -> Y+4
;	tem -> Y+0
	LDD  R26,Y+4
	RCALL _read_average
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_OFFSET
	LDS  R31,_OFFSET+1
	LDS  R22,_OFFSET+2
	LDS  R23,_OFFSET+3
	CALL __CDF1
	CALL __SWAPD12
	CALL __SUBF12
	RCALL SUBOPT_0x1
; 0000 0126     if(tem<0) tem=0;
	LDD  R26,Y+3
	TST  R26
	BRPL _0x81
	LDI  R30,LOW(0)
	CALL __CLRD1S0
; 0000 0127     return  tem;
_0x81:
	CALL __GETD1S0
	RJMP _0x2000002
; 0000 0128 }
; .FEND
;
;float get_units(char times){return get_value(times)/SCALE;}
; 0000 012A float get_units(char times){return get_value(times)/SCALE;}
_get_units:
; .FSTART _get_units
	ST   -Y,R26
;	times -> Y+0
	LD   R26,Y
	RCALL _get_value
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R6
	RCALL SUBOPT_0x19
_0x2000003:
	ADIW R28,1
	RET
; .FEND
;
;void tare(char times){
; 0000 012C void tare(char times){
_tare:
; .FSTART _tare
; 0000 012D      unsigned long sum=read_average(times);
; 0000 012E      OFFSET=sum;
	ST   -Y,R26
	SBIW R28,4
;	times -> Y+4
;	sum -> Y+0
	LDD  R26,Y+4
	RCALL _read_average
	CALL __CFD1U
	RCALL SUBOPT_0x1
	CALL __GETD1S0
	STS  _OFFSET,R30
	STS  _OFFSET+1,R31
	STS  _OFFSET+2,R22
	STS  _OFFSET+3,R23
; 0000 012F }
_0x2000002:
	ADIW R28,5
	RET
; .FEND
;
;void start(){
; 0000 0131 void start(){
_start:
; .FSTART _start
; 0000 0132     unsigned char i,j;
; 0000 0133     get_units(20);
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	j -> R16
	LDI  R26,LOW(20)
	RCALL _get_units
; 0000 0134     tare(20);
	LDI  R26,LOW(20)
	RCALL _tare
; 0000 0135     for(i=0;i<10;){
	LDI  R17,LOW(0)
_0x83:
	CPI  R17,10
	BRSH _0x84
; 0000 0136         hienso_start(i);
	MOV  R26,R17
	RCALL _hienso_start
; 0000 0137         j=blink;
	MOV  R16,R4
; 0000 0138         if(blink!=j) i++;       //sau 1s doi 1 lan
	CP   R16,R4
	BREQ _0x85
	SUBI R17,-1
; 0000 0139     }
_0x85:
	RJMP _0x83
_0x84:
; 0000 013A }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void Details(){
; 0000 013C void Details(){
_Details:
; .FSTART _Details
; 0000 013D     unsigned char state=0,dk=0,key;
; 0000 013E     while(1){
	CALL __SAVELOCR4
;	state -> R17
;	dk -> R16
;	key -> R19
	LDI  R17,0
	LDI  R16,0
_0x86:
; 0000 013F         key=quetphim();
	RCALL _quetphim
	MOV  R19,R30
; 0000 0140         if((blink==1)&&(dk==0)) {
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x8A
	CPI  R16,0
	BREQ _0x8B
_0x8A:
	RJMP _0x89
_0x8B:
; 0000 0141             state=~state;
	COM  R17
; 0000 0142             dk=1;
	LDI  R16,LOW(1)
; 0000 0143         }
; 0000 0144         if(blink==2) dk=0;
_0x89:
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x8C
	LDI  R16,LOW(0)
; 0000 0145         if(state){
_0x8C:
	CPI  R17,0
	BREQ _0x8D
; 0000 0146             hien_chu(0,0);  //dòng 1 hien dtail
	RCALL SUBOPT_0x1A
; 0000 0147             hien_chu(1,1);  //dòng 2 hien T Gas
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x1B
; 0000 0148             hien_chu(2,2);  //dong 3 hien T Can
	LDI  R26,LOW(2)
	RCALL _hien_chu
; 0000 0149          }
; 0000 014A         else{
	RJMP _0x8E
_0x8D:
; 0000 014B             hienso_int(1,T_gas);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL SUBOPT_0x1C
; 0000 014C             hienso_int(2,T_can);
; 0000 014D         }
_0x8E:
; 0000 014E         if(key=='c'){       //nut clear
	CPI  R19,99
	BRNE _0x8F
; 0000 014F             while(1){
_0x90:
; 0000 0150                 key=quetphim();
	RCALL _quetphim
	MOV  R19,R30
; 0000 0151                 hien_chu(0,0);
	RCALL SUBOPT_0x1A
; 0000 0152                 hienso_int(1,T_gas);
	RCALL SUBOPT_0x1C
; 0000 0153                 hienso_int(2,T_can);
; 0000 0154                 if(key=='E') break;
	CPI  R19,69
	BREQ _0x92
; 0000 0155                 if(key=='e'){
	CPI  R19,101
	BRNE _0x94
; 0000 0156                     T_gas=0;
	LDI  R30,LOW(0)
	STS  _T_gas,R30
	STS  _T_gas+1,R30
	STS  _T_gas+2,R30
	STS  _T_gas+3,R30
; 0000 0157                     T_can=0;
	CLR  R8
	CLR  R9
; 0000 0158                     break;
	RJMP _0x92
; 0000 0159                 }
; 0000 015A             }
_0x94:
	RJMP _0x90
_0x92:
; 0000 015B         }
; 0000 015C         if(key=='E') break;
_0x8F:
	CPI  R19,69
	BRNE _0x86
; 0000 015D     }
; 0000 015E }
	RJMP _0x2000001
; .FEND
;
;void Smart_conf(){
; 0000 0160 void Smart_conf(){
_Smart_conf:
; .FSTART _Smart_conf
; 0000 0161      ;
; 0000 0162 }
	RET
; .FEND
;
;void Set_scale(){
; 0000 0164 void Set_scale(){
_Set_scale:
; .FSTART _Set_scale
; 0000 0165     unsigned char key,x=4;
; 0000 0166     int temp=0;
; 0000 0167      while(1){
	CALL __SAVELOCR4
;	key -> R17
;	x -> R16
;	temp -> R18,R19
	LDI  R16,4
	__GETWRN 18,19,0
_0x96:
; 0000 0168         key=quetphim();
	RCALL _quetphim
	MOV  R17,R30
; 0000 0169         hien_chu(0,x);      //dong 1 hien SEt
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R16
	RCALL SUBOPT_0x1D
; 0000 016A         hien_chu(1,3);      //dong 2 hien SCALE
; 0000 016B         hienso(2,temp);
	MOVW R30,R18
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 016C         if(key<10){
	CPI  R17,10
	BRSH _0x99
; 0000 016D             x=4;
	LDI  R16,LOW(4)
; 0000 016E             hien_chu(0,4);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL SUBOPT_0x1D
; 0000 016F             hien_chu(1,3);
; 0000 0170             hienso_int(2,temp);
	MOVW R26,R18
	RCALL _hienso_int
; 0000 0171             temp=temp*10+key;
	MOVW R30,R18
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R18,R30
; 0000 0172             if(temp>=1000) temp=temp%1000;
	__CPWRN 18,19,1000
	BRLT _0x9A
	MOVW R26,R18
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21
	MOVW R18,R30
; 0000 0173         }
_0x9A:
; 0000 0174         if(key=='E') break;
_0x99:
	CPI  R17,69
	BREQ _0x98
; 0000 0175         if(key=='e'){
	CPI  R17,101
	BRNE _0x9C
; 0000 0176             if(temp==0)  x=5;  //Error
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x9D
	LDI  R16,LOW(5)
; 0000 0177             else{
	RJMP _0x9E
_0x9D:
; 0000 0178                 SCALE=get_value(20)/temp;
	LDI  R26,LOW(20)
	RCALL _get_value
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R18
	RCALL SUBOPT_0x19
	CALL __CFD1
	MOVW R6,R30
; 0000 0179             }
_0x9E:
; 0000 017A         }
; 0000 017B      }
_0x9C:
	RJMP _0x96
_0x98:
; 0000 017C }
_0x2000001:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;/*
;void setup(){
;    char dk=1;
;    while(dk){
;        switch(quetphim()){
;            case '
;            case 'E': dk=0;break;
;        }
;    }
;}*/

	.DSEG
_so:
	.BYTE 0xA
_led:
	.BYTE 0xF
_chu:
	.BYTE 0x23
_OFFSET:
	.BYTE 0x4
_T_gas:
	.BYTE 0x4
_dk_sent_S0000001000:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x0:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	__GETD2S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	MOVW R26,R30
	MOVW R24,R22
	RJMP _hienso

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	__GETD2S 14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	__GETD1N 0x447A0000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+6,R30
	STD  Y+6+1,R31
	IN   R30,0x18
	ANDI R30,LOW(0xE1)
	MOV  R22,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDD  R30,Y+18
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	SUBI R30,LOW(-_led)
	SBCI R31,HIGH(-_led)
	LD   R30,Z
	OR   R30,R22
	OUT  0x18,R30
	LDI  R26,LOW(_so)
	LDI  R27,HIGH(_so)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	OUT  0x1B,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	IN   R30,0x18
	ANDI R30,LOW(0xE1)
	MOV  R22,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xF:
	SUBI R30,LOW(-_so)
	SBCI R31,HIGH(-_so)
	LD   R30,Z
	OUT  0x1B,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	IN   R30,0x18
	ANDI R30,LOW(0xE1)
	MOV  R22,R30
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	OUT  0x1B,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	__ADDW1MN _led,3
	LD   R30,Z
	OR   R30,R22
	OUT  0x18,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	__ADDW1MN _led,4
	LD   R30,Z
	OR   R30,R22
	OUT  0x18,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDD  R30,Y+12
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15:
	LD   R30,X
	OUT  0x1B,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	IN   R30,0x18
	ANDI R30,LOW(0xE1)
	MOV  R22,R30
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	OUT  0x18,R30
	LDD  R30,Y+1
	LDI  R31,0
	SUBI R30,LOW(-_so)
	SBCI R31,HIGH(-_so)
	LD   R30,Z
	OUT  0x1B,R30
	IN   R30,0x18
	ANDI R30,LOW(0xE1)
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	RCALL SUBOPT_0x3
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _hien_chu
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	RCALL _hien_chu
	LDI  R30,LOW(2)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1C:
	LDS  R30,_T_gas
	LDS  R31,_T_gas+1
	LDS  R22,_T_gas+2
	LDS  R23,_T_gas+3
	CALL __CFD1
	MOVW R26,R30
	RCALL _hienso_int
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOVW R26,R8
	RJMP _hienso_int

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	RCALL _hien_chu
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RJMP SUBOPT_0x1B


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

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__XORD12:
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLD1:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
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

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
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
