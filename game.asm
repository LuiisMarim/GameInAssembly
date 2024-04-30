RS      equ     P1.3    
EN      equ     P1.2   
KEY0    equ     P1.0    ; Tecla 0 do teclado matricial

org 0000h

    LJMP START

org 0030h
MAIN:
	ACALL lcd_init

START:
    MOV 20H, #'M' 
    MOV 21H, #'E'
    MOV 22H, #'M'
    MOV 23H, #'O'
    MOV 24H, #'R'
    MOV 25H, #'I'
    MOV 26H, #'Z'
    MOV 27H, #'E'
    MOV R5, #5
    ACALL lcd_init
    
    MOV A, #42h
    ACALL posicionaCursor
    MOV A, #20h 
    ACALL escreveString
    MOV SCON, #40h 
    MOV PCON, #80h 
    MOV TMOD, #20h 
    MOV TH1, #243 
    MOV TL1, #243
    SETB TR1 
    MOV A, #'1' 
    MOV R1, #30h
		



    ROTINA:
	MOV R3, #3
	ACALL leituraTeclado
	JNB F0, ROTINA   ;if F0 is clear, jump to ROTINA
    ROT:
    ACALL clearDisplay
    MOV R2, #10
    ACALL generateRandomNumber
   ;arrumar posicionacursor pra mostrar
   ;3 numeros em sequencia
    MOV A, #02H
    ACALL posicionaCursor
    MOV A, #31h 
	;arrumar a impressao no led para ints
    ACALL displayNumber
    
    DJNZ R3, ROT
	
  	;fazer comparação com o recebido
    ; pelo user


    ;ACALL checkUserInput
	CLR F0
	JMP  MAIN




leituraTeclado:
	MOV R0, #0			; clear R0 - the first key is key0

	; scan row0
	MOV P0, #0FFh	
	CLR P0.0			; clear row0
	CALL colScan		; call column-scan subroutine
	JB F0, Finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)
	Finish:
	RET

; column-scan subroutine
colScan:
	JNB P0.4, gotKey	; if col0 is cleared - key found
	INC R0				; otherwise move to next key
	JNB P0.5, gotKey	; if col1 is cleared - key found
	INC R0				; otherwise move to next key
	JNB P0.6, gotKey	; if col2 is cleared - key found
	INC R0				; otherwise move to next key
	RET					; return from subroutine - key not found
gotKey:
	SETB F0				; key found - set F0
	RET					; and return from subroutine

   
  

generateRandomNumber:
    ; Aqui estamos gerando um número pseudo-aleatório 
	ADD A, #30H
    MOV @R1, A 
    MOV B, #3
    ADD A, #2
    MUL AB  
    INC R1
    INC A
    DJNZ R2, generateRandomNumber
    RET
	
    
displayNumber:
	 MOV R2, #4
	 MOV R1, A
denovo:
    MOV A, @R1 
    ACALL sendCharacter 
    INC R1 
    DJNZ R2, denovo 
over:
    RET


escreveString:
    MOV R1, A 
loop:
    MOV A, @R1 
    JZ acabou 
    ACALL sendCharacter 
    INC R1 
    JMP loop 
acabou:
    RET

waitForUserInput:
    ; Aqui estamos esperando a entrada do usuário
WAIT_INPUT:
    JNB KEY0, WAIT_INPUT ; Esperar pelo pressionamento do botão 0 do teclado matricial
    MOV A, P1
    ANL A, #0Fh
    MOV R6, A
    RET

checkUserInput:
    ; Aqui estamos verificando se a entrada do usuário está correta
    MOV A, R6
    SUBB A, R7
    JZ INPUT_CORRECT
    ; Aqui você pode adicionar o código para lidar com a entrada incorreta
INPUT_CORRECT:
    ; Aqui você pode adicionar o código para lidar com a entrada correta
    MOV DPTR, #congratsMsg
    ACALL escreveString
    RET

congratsMsg:
    DB 'A'

JMP $


lcd_init:
    CLR RS        
    CLR P1.7       
    CLR P1.6       
    SETB P1.5    
    CLR P1.4       
    SETB EN       
    CLR EN    

    CALL delay    

    SETB EN       
    CLR EN    

    SETB P1.7       

    SETB EN       
    CLR EN    
    CALL delay      

    CLR P1.7       
    CLR P1.6       
    CLR P1.5    
    CLR P1.4       

    SETB EN    
    CLR EN    

    SETB P1.6   
    SETB P1.5   
    SETB EN       
    CLR EN       

    CALL delay    

    CLR P1.7       
    CLR P1.6       
    CLR P1.5       
    CLR P1.4       

    SETB EN   
    CLR EN   

    SETB P1.7   
    SETB P1.6   
    SETB P1.5   
    SETB P1.4   

    SETB EN   
    CLR EN      

    CALL delay  
    RET

sendCharacter:
    SETB RS          
    MOV C, ACC.7    
    MOV P1.7, C      
    MOV C, ACC.6    
    MOV P1.6, C      
    MOV C, ACC.5    
    MOV P1.5, C          
    MOV C, ACC.4      
    MOV P1.4, C      

    SETB EN            
    CLR EN            

    MOV C, ACC.3    
    MOV P1.7, C      
    MOV C, ACC.2    
    MOV P1.6, C      
    MOV C, ACC.1    
    MOV P1.5, C          
    MOV C, ACC.0      
    MOV P1.4, C      

    SETB EN            
    CLR EN            

    CALL delay        
    RET


posicionaCursor:
    CLR RS          
    SETB P1.7             
    MOV C, ACC.6    
    MOV P1.6, C      
    MOV C, ACC.5    
    MOV P1.5, C      
    MOV C, ACC.4    
    MOV P1.4, C      

    SETB EN         
    CLR EN          

    MOV C, ACC.3    
    MOV P1.7, C      
    MOV C, ACC.2    
    MOV P1.6, C      
    MOV C, ACC.1    
    MOV P1.5, C      
    MOV C, ACC.0    
    MOV P1.4, C          

    SETB EN         
    CLR EN          

    CALL delay          
    RET

retornaCursor:
    CLR RS     
    CLR P1.7   
    CLR P1.6   
    CLR P1.5   
    CLR P1.4       

    SETB EN   
    CLR EN   

    CLR P1.7   
    CLR P1.6   
    SETB P1.5       
    SETB P1.4       

    SETB EN       
    CLR EN       

    CALL delay  
    RET

clearDisplay:
    CLR RS         
    CLR P1.7   
    CLR P1.6   
    CLR P1.5   
    CLR P1.4   

    SETB EN   
    CLR EN   

    CLR P1.7       
    CLR P1.6   
    CLR P1.5       
    SETB P1.4       

    SETB EN   
    CLR EN   

    CALL delay  
    RET

delay:
    MOV R0, #50
    DJNZ R0, $
    RET
