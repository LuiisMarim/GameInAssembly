RS equ P1.3
EN equ P1.2
KEY0 equ P1.0 ; Tecla 0 do teclado matricial

org 0000h

LJMP START

org 023H
    MOV R6, #1H
    MOV A, SBUF
    CLR RI
    RETI

org 0040h


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
    MOV SCON, #50h
    MOV PCON, #80h
    MOV TMOD, #20h
    MOV TH1, #243
    MOV TL1, #243
    SETB TR1
    MOV IE, #90H
    MOV A, #'1'
    MOV R1, #30h

ROTINA:
    ACALL leituraTeclado
    JNB F0, ROTINA ; Se F0 estiver limpo, pule para ROTINA

ROT:
    ACALL clearDisplay
    MOV R2, #10
    MOV A, #30h
    ACALL generateRandomNumber

volta:
    MOV A, #02H
    ACALL posicionaCursor
    MOV A, #31h

    ACALL displayNumber
    ACALL delay_memoria
    ACALL clearDisplay

;Comparar com a entrada do usuário
    MOV R4, #3
    MOV R1, #31h
    ACALL checkUserInput


leituraTeclado:
    MOV R0, #0 ; Limpa R0 - a primeira tecla é a tecla 0

    ; Verifica a linha 0
    MOV P0, #0FFh
    CLR P0.0 ; Limpa a linha 0
    CALL colScan ; Chama a sub-rotina de varredura de coluna
    JB F0, Finish ; Se F0 estiver definido, pule para o final do programa (porque a tecla pressionada foi encontrada e seu número está em R0)
    Finish:
    RET

; Sub-rotina de varredura de coluna
colScan:
    JNB P0.4, gotKey ; Se col0 estiver limpo - tecla encontrada
    INC R0 ; Caso contrário, vá para a próxima tecla
    JNB P0.5, gotKey ; Se col1 estiver limpo - tecla encontrada
    INC R0 ; Caso contrário, vá para a próxima tecla
    JNB P0.6, gotKey ; Se col2 estiver limpo - tecla encontrada
    INC R0 ; Caso contrário, vá para a próxima tecla
    RET ; Retorne da sub-rotina - tecla não encontrada
gotKey:
    SETB F0 ; Tecla encontrada - defina F0
    RET ; E retorne da sub-rotina

generateRandomNumber:
    ;Endereço de memória onde armazenar o número gerado
    MOV R2, #10 ; Limite superior para o número gerado

generate_loop:
    MOV @R1, A 
    MOV B, #4
    ADD A, #3
	ADD A, B
    INC R1
    INC A
    DJNZ R2, generate_loop
	

generate_loop_end:
    JMP volta

displayNumber:
    MOV R2, #3 ; Número de dígitos a serem exibidos
    MOV R1, A ; Endereço do número a ser exibido

display_loop:
    MOV A, @R1 ; Carrega o número da memória
    ACALL sendCharacter ; Envia o dígito para o LCD
    INC R1 ; Avança para o próximo dígito
    DJNZ R2, display_loop ; Repete para os próximos dígitos
    RET

escreveString:
    MOV R1, A ; Endereço da string
    loop:
    MOV A, @R1 ; Carrega o caractere da memória
    JZ acabou
    ACALL sendCharacter ; Envia o caractere para o LCD
    INC R1 ; Avança para o próximo caractere
    JMP loop
    acabou:
    RET

checkUserInput:
   
    MOV R1, #31h ; Endereço da entrada do usuário

check_loop:
    MOV R6, #0H
    CJNE R6, #1H, $
    MOV R7, A ;
    MOV A, @R1 ; Carrega o dígito da memória
   

    SUBB A, R7 ; Compara com o número gerado aleatoriamente
    JNZ INPUT_ERRO ; Se não forem iguais, vá para INPUT_ERRO
    INC R1 ; Avança para o próximo dígito
    DJNZ R4, check_loop ; Repete para os próximos dígitos
    JMP INPUT_ACERTO ; Se todos os dígitos forem iguais, vá para INPUT_ACERTO

INPUT_ACERTO:

    MOV SCON, #40h ;porta serial no modo 1
    MOV PCON, #80h ;set o bit SMOD
    MOV TMOD, #20h ;CT1 no modo 2
    MOV TH1, #243 ;valor para a recarga
    MOV TL1, #243 ;valor para a primeira contagem
    SETB TR1 ;liga o contador/temporizador 1
    MOV 10H, #'V' 
    MOV 11H, #'I'
    MOV 12H, #'T'
    MOV 13H, #'O'
    MOV 14H, #'R'
    MOV 15H, #'I'
    MOV 16H, #'A'
    MOV R1, #10H
    MOV R2, #7

LB:
    MOV A, @R1
    MOV SBUF, A ;transmite o conteúdo do acumulador
   
    JNB TI, $ ;aguarda o término da transmissão
    CLR TI ;apaga indicador de fim de transmissão
    INC R1
    DJNZ R2, LB

    SJMP FIM
   
INPUT_ERRO:
    MOV SCON, #40h ;porta serial no modo 1
    MOV PCON, #80h ;set o bit SMOD
    MOV TMOD, #20h ;CT1 no modo 2
    MOV TH1, #243 ;valor para a recarga
    MOV TL1, #243 ;valor para a primeira contagem
    SETB TR1 ;liga o contador/temporizador 1
    MOV 50H, #'D' 
    MOV 51H, #'E'
    MOV 52H, #'R'
    MOV 53H, #'R'
    MOV 54H, #'O'
    MOV 55H, #'T'
    MOV 56H, #'A'
    MOV R1, #50H
    MOV R2, #7

LB1:
    MOV A, @R1 
    MOV SBUF, A ;transmite o conteúdo do acumulador
    JNB TI, $ ;aguarda o término da transmissão
    CLR TI ;apaga indicador de fim de transmissão
    INC R1
    DJNZ R2, LB1

    SJMP FIM

FIM:
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

    CALL delay_clear  
    RET


delay_clear:

    MOV R0, #255
    DJNZ R0, $
    MOV R0, #255
    DJNZ R0, $
    MOV R0, #255
    DJNZ R0, $
    RET

delay_memoria:
    MOV R0, #2
    DJNZ R0, $
    RET


delay:
    MOV R0, #50
    DJNZ R0, $
    RET
