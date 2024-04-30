RS      equ     P1.3    
EN      equ     P1.2   

org 0000h

	LJMP START

org 0030h

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
	MOV A, #0h
	ACALL posicionaCursor      
	MOV A, R5
	MOV B, #10
;	DIV AB                                    
	ADD A, #30h
	ACALL sendCharacter	
	MOV A, B
	ADD A, #30h
	;ACALL sendCharacter	
	;ACALL retornaCursor
	MOV A, #7h
	ACALL posicionaCursor
	MOV R5, #7
	;ACALL lcd_init 
	MOV A, R5
	ADD A, #30h
	ACALL sendCharacter	
		
    MOV A, #0Dh
	ACALL posicionaCursor
	MOV R5, #9
	;ACALL lcd_init 
	MOV A, R5
	ADD A, #30h
	ACALL sendCharacter	
	MOV A, B

	MOV A, #42h
    ACALL posicionaCursor
	MOV A, #20h 
    ACALL escreveString
    
   


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

escreveString:
MOV R1, A 
loop:
MOV A, @R1 
JZ finish 
ACALL sendCharacter 
INC R1 
JMP loop 
finish:
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
