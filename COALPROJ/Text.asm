include irvine32.inc
include macros.inc

.data ; begin data segment
    MatA        DWORD 50 dup(0)   ; matrix A
    MatB        DWORD 50 dup(0)   ; matrix B    
    num_rows    DWORD 0
    num_cols    DWORD 0    
    col_counter DWORD 0    
    row_counter DWORD 0    
    counter     DWORD 0    
    sum         DWORD 0
    count1      DWORD 0
    total       DWORD ?
    input       DWORD ?
    Trace_var       DWORD ?

    working_row DWORD 0    ; (0=1st row, 12=2nd row, 24=3rd row)
    working_col DWORD 0    ; (0=1st col, 4=2nd col, 8=3rd col)

    matrix_size DWORD ?     ; 2= [3x3]    9= [10x10]
    nextRow     DWORD ?     ; (matrix_size + 1) * 4

.code ; begin code segment

calcTotal PROC
    push ebp
    mov ebp,esp

    mov eax,DWORD PTR [ebp+8]
    inc eax
    mul DWORD PTR [ebp+8]

    pop ebp
    ret 4
calcTotal ENDP

calcNextRow PROC
    push ebp
    mov ebp, esp

    mov eax,DWORD PTR [ebp+8]
    inc eax
    mul DWORD PTR [ebp+12]

    pop ebp
    ret 8
calcNextRow ENDP

calcSize PROC
    ; Calculate num_rows and num_cols based on matrix_size

    mov eax, matrix_size
    mov ebx, nextrow
    mul ebx
    mov num_rows, eax

    mov eax, matrix_size
    mov ebx, 4
    mul ebx
    mov num_cols, eax
    ret
calcSize ENDP

setvalue PROC
    mwrite "Enter Value: "
    call readint
    mov [esi], eax
    ret
setvalue ENDP

InputA PROC
    mwrite "Enter Values for Matrix A Row-Wise: "
    call crlf

    mov esi, OFFSET MatA ; finds the start of the matrix
    call inputMatrix

    ret
InputA ENDP

InputB PROC
    mwrite "Enter Values for Matrix B Row-Wise: "
    call crlf

    mov esi, OFFSET MatB
    call inputMatrix

    ret
InputB ENDP

printvalue PROC

    push eax
    call WriteInt
    mov al, ' '
    call WriteChar 

    pop eax
    ret
printvalue ENDP

inputMatrix PROC
    push ecx
    mov ecx, matrix_size


    mov row_counter, 0 

NewRow:
    mov col_counter, 0 

NewCol:

    call setvalue 
    add esi, 4 

    inc col_counter 
    cmp col_counter, ecx 
    jle NewCol 

    inc row_counter 

    cmp row_counter, ecx 
    jle NewRow

    pop ecx
    ret
inputMatrix ENDP

DisplayMatrix PROC

    push ecx
    mov ecx, matrix_size

    call Crlf 
    mov row_counter, 0 

NewRow:
    mov col_counter, 0 

NewCol:

    mov eax, [esi]
    call printvalue 
    add esi, 4 

    inc col_counter 
    cmp col_counter, ecx 
    jle NewCol 

    call Crlf
    inc row_counter 
    cmp row_counter, ecx 
    jle NewRow

    pop ecx
    ret
DisplayMatrix ENDP

addElements PROC
    ; Add A1B1 + A2B2 + A3B3

    push ecx
    push edx

    mov ecx, matrix_size
    mov edx, nextRow

    mov eax, working_row 
    mov ebx, working_col 

    mov row_counter, eax
    mov col_counter, ebx

    mov counter, 0
    mov sum, 0

Next:

    call multiplyelements 
    add sum, eax 

    add row_counter, 4 
    add col_counter, edx

    inc counter

    cmp counter, ecx
    jle Next

    mov eax, sum

    pop edx
    pop ecx
    ret
addElements ENDP

multiplyelements PROC
    push edx

    mov esi, OFFSET MatA 
    add esi, row_counter
    mov eax, [esi] 

    mov esi, OFFSET MatB 
    add esi, col_counter 
    mov ebx, [esi] 

    mul ebx 

    pop edx
    ret
multiplyelements ENDP

multiplymatrix PROC USES ecx

    mov ecx, nextRow

    call Crlf
    mov working_row, 0

NewRow:

    mov working_col, 0 

NewCol:
    

    call addElements ; do all the addition and multiplication
    call printvalue 

    add working_col, 4 

    mov eax, working_col
    cmp eax, num_cols
    jle NewCol


    call Crlf ; new row
    add working_row, ecx

    mov eax, working_row 
    cmp eax, num_rows
    jle NewRow

    call Crlf
    ret
multiplymatrix ENDP

AddMatrix PROC

push ebp
mov ebp, esp
mov ecx, matrix_size

mov esi,[ebp+12] 
mov edi,[ebp+8]  

call Crlf

mov row_counter, 0 

NewRow:
    mov col_counter, 0 

NewCol:

    mov eax, [esi]
    add eax, [edi]

    call printvalue 

    add esi, 4 
    add edi, 4

    inc col_counter

    cmp col_counter, ecx
    jle NewCol

    call Crlf
    inc row_counter 

    cmp row_counter, ecx 
    jle NewRow

pop ebp
ret 8
AddMatrix ENDP

SubMatrix PROC

push ebp
mov ebp, esp
mov ecx, matrix_size

mov esi,[ebp+12]
mov edi,[ebp+8] 
call Crlf

mov row_counter, 0 

NewRow:
    mov col_counter, 0 

NewCol:

    mov eax, [esi]
    sub eax, [edi]

    call printvalue 

    add esi, 4 
    add edi, 4

    inc col_counter

    cmp col_counter, ecx
    jle NewCol

    call Crlf
    inc row_counter 

    cmp row_counter, ecx 
    jle NewRow

pop ebp
ret 8
SubMatrix ENDP

Trace Proc Matrix : DWORD
 push ecx
    
    mov ecx, matrix_size
    mov edx, 0
    mov row_counter, 0 
    mov trace_var, 0

NewRow:
    mov col_counter, 0 

NewCol:

    mov edx, col_counter
    cmp edx, row_counter
    JE Equals
    
    Jmp NotEquals

    Equals:
        mov edx, [Matrix]
        mov ebx, [edx]
        add trace_var, ebx
      

    NotEquals:
    add Matrix, 4 

    inc col_counter 
    cmp col_counter, ecx 
    jle NewCol 


    inc row_counter

    cmp row_counter, ecx 
    jle NewRow

    pop ecx

    mov eax,trace_var

ret
Trace Endp

menu proc

    call	Clrscr
    mwrite "Welcome to the Matrix Multiplicator"
    call crlf
    mwrite "Enter Size Of Matrix (2 = [3x3] & 9 = [10x10]), Option: "
     

    call readInt
    mov matrix_size, eax
    
    push 4
    push matrix_size
    
    call calcNextRow
    mov nextRow,eax
    
    push matrix_size
    call calcTotal
    mov total,eax

    call	calcSize		
    
    call	InputA				; generate matrix A
    call ClrScr
    
    call	InputB				; generate matrix B
    call ClrScr
    
    Top:

    call ClrScr

    mwrite "Displaying Matrix A: "
    call crlf
    mov esi, OFFSET MatA
    call DisplayMatrix
    call crlf

    mwrite "Displaying Matrix B: "
    call crlf
    mov esi, OFFSET MatB
    call DisplayMatrix
    call crlf


    ; Matrix operation options
    call crlf 
    mwrite "Option: 1, Matrix Multiplications"
    call crlf
    mwrite "Option: 2, Matrix Addition"
    call crlf
    mwrite "Option: 3, Matrix Subtraction"
    call Crlf
    mwrite "Option: 4, Calculate Trace"
    call crlf
    mwrite "Option: 5, Exit"
    call crlf

    mwrite"Enter Choice:  "
    call readint
    mov input, eax

    ; Matrix operation options

    cmp input, 1
    JE Multiplicator
    
    cmp input, 2
    JE Addition
    
    cmp input, 3
    JE Subtraction

    cmp input, 4
    JE Traces
     
    jmp END1

    Multiplicator:
    call	multiplymatrix
    call crlf
    jmp EndofProc

    Subtraction:

    push OFFSET MatA
    push OFFSET MatB
    call SubMatrix
    call crlf

    jmp EndofProc

    Addition:

    push OFFSET MatA
    push OFFSET MatB
    call AddMatrix
    call crlf


    jmp EndofProc

    Traces:
    mwrite "Trace of A: "
    INVOKE Trace, ADDR MatA
    call writeint
    call crlf
    mwrite "Trace of B: "
    INVOKE Trace, ADDR MatB
    call writeint
    call crlf

    jmp EndofProc

    EndofProc:
    call readChar
    jmp Top


    End1:

    ret 
menu endp

main proc

    mov eax, Blue+(gray*16)
    call SetTextColor
    call crlf
    call clrscr
    
    call menu

exit 
main ENDP
END MAIN
