;*****************************************************************************
; pfftr - A small silly game
;
; Copyright 2017 Mats Engstrom, SmallRoomLabs. Licensed under the MIT license
;*****************************************************************************

;
; Define standard ROM routines
;
CLRSCR	EQU 3503 	; $0D6B
OPENCHN	EQU $1601 	; 5633
print	EQU $203C
SCREEN	EQU $4000
ATTRIBS EQU $5800	; 5800..5B00=$400 locs. FL BL P2 P1 P0 I2 I1 I0
SLOWRAM	EQU $5DC0 	; 24000 First usable location in slow ram
FASTRAM	EQU $8000 	; 32768 Start of the faster upper 32K ram

PORTBORDER EQU $FE	; OUT port for seting border color

;
; Color names
;
BLACK	EQU 0		; BK
BLUE	EQU 1		; BL
RED	EQU 2		; RE
MAGENTA	EQU 3		; MA
GREEN	EQU 4		; GR
CYAN	EQU 5		; CY
YELLOW	EQU 6		; YL
WHITE	EQU 7		; WH

	include "colors.inc"	; INK/PAPER color combos

;
; Game constants and settings
;
;OPTSPEED	EQU	1	; Defined=Optimize for Speed
CPUBORDER	EQU	1	; Defined=Show borders

	include "macros.asm"


	ORG SLOWRAM
	ALIGN 256
	include "playerdata.inc"
	include "fatfont.inc"
	include "ytable.asm"

;
;
;
Start:
	call	CLRSCR 		; clear the screen.
	ld	A,BLACK
	out	(PORTBORDER),A

	ld	A,253
	call	OPENCHN

	; Set Ink=WHite, Paper=Black in all screen attributes
	ld	DE,ATTRIBS+1
	ld	HL,ATTRIBS
	ld	BC,$3FF
	ld	(HL),WhBK
	ldir
IFDEF DEBUG
	call	DebugGrid
ENDIF


 MACRO DRAW,V
	ld	A,(HL)
	inc	HL
	ld	(V##+10),A
	ld	A,(HL)
	inc	HL
	ld	(V##+11),A
	ld	A,(HL)
	inc	HL
	ld	(V##+12),A
 ENDM


Loop:
	ld	HL,player0
	DRAW	Row10
	DRAW	Row11
	DRAW	Row12
	DRAW	Row13
	DRAW	Row14
	DRAW	Row15
	DRAW	Row16
	DRAW	Row17
	DRAW	Row18
	DRAW	Row19
	DRAW	Row20
	DRAW	Row21
	DRAW	Row22
	DRAW	Row23
	DRAW	Row24
	DRAW	Row25
	
IFDEF DEBUG
	ld HL,($0000)
	ld DE,Row0+0
	call PrintHLAtDE
	ld HL,($0000)
	ld DE,Row0+7
	call PrintHLAtDE
ENDIF

 IFDEF CPUBORDER
 	halt
 ELSE
	ld	A,BLACK
	out	(PORTBORDER),A
	halt
	ld	A,BLUE
	out	(PORTBORDER),A
 ENDIF
	jp	Loop


;
; Displays a number 0..9 from A as location starting at HL
;
DispNum:
	add	A,A 		; Multiply A by 8
	add	A,A
	add	A,A
	ld	DE,FatFont+$10*8 ; Address of digit 0 in charmap
	add	A,E		; Add A*8 to the address to get to the
	ld	E,A 		; correct offset of the requred digit

	ld	B,8
dn0	ld	A,(DE)		; Copy all 8 rows of the character map
	inc	DE		; into to the screen memory
	ld	(HL),A
	inc	H
	djnz	dn0
	ret




	 END Start
