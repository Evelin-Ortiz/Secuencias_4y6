#include "p16F887.inc"    
; CONFIG1
; __config 0x28D5
 __CONFIG _CONFIG1, _FOSC_INTRC_CLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

  LIST p=16F887
    
  
N     EQU 0xD0
cont1 EQU 0x20
cont2 EQU 0x21
cont3 EQU 0x22
var   EQU 0X23
sol   EQU 0X24
der   EQU 0x25
izq   EQU 0x26
comb  EQU 0x27

    ORG	0x00
    GOTO INICIO
    
INICIO
    BCF  STATUS,RP0   ;RP0 = 0
    BCF  STATUS,RP1  ;RP1 = 0
    CLRF PORTA	;PORTA = 0
    CLRF PORTB ;PORT SECUENCIA LED
    BSF  STATUS, RP0 ;RP0 = 1
    CLRF TRISA
    CLRF TRISB	;SECUENCIA SALIDA
    BSF  STATUS,RP1
    CLRF ANSELH
    BCF  STATUS,RP0  ;BANK O RP1=0 RP0=0
    BCF  STATUS,RP1
    
    MOVLW 0x00
    MOVWF sol

SECUENCIA1 
    
    MOVF sol,0
    CALL SEVENSEG_LOOKUP
    MOVWF PORTB ;PUT DATA ON PORTB.
    CALL RETARDO
    INCF sol
    BTFSS PORTB, 1 
    BTFSS PORTB, 1 
    BTFSS PORTB, 1 
    BTFSS PORTB, 1 
    GOTO SECUENCIA1
   
	
;--------------------------------------------------------------------------
; NUMBERIC LOOKUP TABLE FOR 7 SEG
;--------------------------------------------------------------------------
SEVENSEG_LOOKUP 
	ADDWF PCL,f
	RETLW 81h  ;   //Hex value to display the number 0.
	RETLW 0xC2 ;   //Hex value to display the number 1.
	RETLW 0xE4 ;   //Hex value to display the number 2.
	RETLW 0xF8 ;   //Hex value to display the number 3.
	RETLW 18h  ;   //Hex value to display the number 4.
	RETLW 0x2C ;   //Hex value to display the number 5.
	RETLW 0x4E ;   //Hex value to display the number 6.
	RETLW 0x8F ;   //Hex value to display the number 7.
	
	RETURN

RETARDO
    MOVLW N
    MOVWF cont1
    
REP_1
    MOVLW N
    MOVWF cont2
    
REP_2
    DECFSZ cont2,1
    GOTO REP_2
    DECFSZ cont1,1
    GOTO REP_1
    RETURN
   
    END