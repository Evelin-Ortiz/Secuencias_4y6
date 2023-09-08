#include p16f887.inc

; CONFIG1
; __config 0x28D5
 __CONFIG _CONFIG1, _FOSC_INTRC_CLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

    
    LIST p=16F887
    
N EQU 0xb0
cont1 EQU 0x20 
cont2 EQU 0x21 
cont3 EQU 0x22
DATOS0 EQU 0x31
DATOS1	EQU 0x32
DATOS2	EQU 0x33
DATOS3 EQU 0x34

    ORG	0x00
    GOTO INICIO
    
INICIO
    BCF STATUS,RP0   ;RP0 = 0
    BCF STATUS,RP1  ;RP1 = 0
    CLRF PORTA ;PORTA = 0
    CLRF PORTB ;PORT SECUENCIA LED
    ;MOVLW B'0000000'  ;
    ;MOVWF PORTA
    BSF STATUS, RP0 ;RP0 = 1
    CLRF TRISA
    CLRF TRISB ;SECUENCIA SALIDA
    BSF STATUS,RP1
    CLRF ANSELH
    BCF STATUS,RP0  ;BANK O RP1=0 RP0=0
    BCF STATUS,RP1


ARRANQUE
    
    BCF STATUS,C
    CLRF DATOS3
    
    MOVLW b'10000000'
    MOVWF DATOS0
    IORWF DATOS3,1; OR 
    MOVLW b'00100000'
    MOVWF DATOS1
    IORWF DATOS3,1;OR 
    MOVLW b'00000010'
    MOVWF DATOS2
    IORWF DATOS3,0;OR 
    MOVWF PORTB
    CALL RETARDO
    
    
PASAUNBIT
    
    RRF DATOS0 ;Mueve a la izq el bit que comienza en 1
    BTFSC DATOS0,0; Si el bit 0 de Datos0 Salta la siguiente linea, si es 1 la cumple
    goto PASOFINAL
    CLRF DATOS3
    MOVFW DATOS0
    IORWF DATOS3,1 ;Le hace or con el DATO3
    RRF DATOS1 ;Mueve a la izq el bit que comienza en 3
    MOVFW DATOS1
    IORWF DATOS3,1 ;Le hace or con el DATO3
    RLF DATOS2;Mueve a la izq el bit que comienza en 7
    BCF DATOS2,0
    MOVFW DATOS2
    IORWF DATOS3,0 ;Le hace or con el DATO3
    MOVWF DATOS3
    MOVWF PORTB
    CALL RETARDO
    goto PASAUNBIT

PASOFINAL
    BCF STATUS,C
    CLRF DATOS3
    MOVLW b'00000001'
    MOVWF DATOS3
    MOVWF PORTB
    CALL RETARDO
    GOTO ARRANQUE
   


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