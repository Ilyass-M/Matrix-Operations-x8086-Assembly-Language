include irvine32.inc
include macros.inc

.data ; begin data segment
    MatA        DWORD 50 dup(0)   ; matrix A
    MatB        DWORD 50 dup(0)   ; matrix B    
    num_rows    DWORD 0
    num_cols    DWORD 0    
    col_counter DWORD 0    ; inner loop counter
    row_counter DWORD 0    ; outer loop counter
    counter     DWORD 0    ; this will always come in handy
    sum         DWORD 0
    count1      DWORD 0
    total       DWORD ?
    input       DWORD ?

    ; used to generate product matrix
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
    call readDec
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

    ; Print a value neatly
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

    ; Traverse each row of the matrix

    mov row_counter, 0 ; set to first row

NewRow:
    mov col_counter, 0 ; set to first column

NewCol:

    call setvalue ; put value in location
    add esi, 4 ; next data member of array

    inc col_counter ; did we reach the last column
    cmp col_counter, ecx ; of the row?
    jle NewCol ; if not, add another element

    inc row_counter ; new row

    cmp row_counter, ecx ; stop at 3rd row
    jle NewRow

    pop ecx
    ret
inputMatrix ENDP

DisplayMatrix PROC

    push ecx
    mov ecx, matrix_size

    call Crlf ; line feed
    mov row_counter, 0 ; set to first row

NewRow:
    mov col_counter, 0 ; set to first column

NewCol:

    mov eax, [esi]
    call printvalue ; print value while we're here
    add esi, 4 ; next data member of array

    inc col_counter ; did we reach the last column
    cmp col_counter, ecx ; of the row?
    jle NewCol ; if not, add another element

    call Crlf
    inc row_counter ; new row

    cmp row_counter, ecx ; stop at 3rd row
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

    mov eax, working_row ; row_counter = working_row
    mov ebx, working_col ; col_counter = working_col

    mov row_counter, eax
    mov col_counter, ebx

    mov counter, 0
    mov sum, 0

Next:
    ; -- begin loop --

    call multiplyelements ; multiply AxBx
    add sum, eax ; accumulate the sum

    add row_counter, 4 ; next elements
    add col_counter, edx

    inc counter ; increment loop counter

    cmp counter, ecx ; stop at 3rd row
    jle Next

    ; -- end loop --

    mov eax, sum

    pop edx
    pop ecx
    ret
addElements ENDP

multiplyelements PROC
    ; Multiply Ax and Bx
    push edx

    mov esi, OFFSET MatA ; find matrix A
    add esi, row_counter ; find location we want
    mov eax, [esi] ; put into eax

    mov esi, OFFSET MatB ; find matrix B
    add esi, col_counter ; find location we want
    mov ebx, [esi] ; put into ebx

    mul ebx ; do multiplication

    pop edx
    ret
multiplyelements ENDP

multiplymatrix PROC USES ecx

    mov ecx, nextRow

    ; Do matrix multiplication

    call Crlf
    mov working_row, 0 ; start on the first row

NewRow:

    mov working_col, 0 ; go to the first column

NewCol:
    ; -- begin inner loop --

    call addElements ; do all the addition and multiplication
    call printvalue ; print value

    add working_col, 4 ; get ready to do the next column

    mov eax, working_col ; did we reach the end of a row?
    cmp eax, num_cols
    jle NewCol

    ; -- end inner loop --

    call Crlf ; new row
    add working_row, ecx

    mov eax, working_row ; did we reach the last row?
    cmp eax, num_rows
    jle NewRow

    call Crlf
    ret
multiplymatrix ENDP

AddMatrix PROC

push ebp
mov ebp, esp
mov ecx, matrix_size

mov esi,[ebp+12] ;storing offset of MatA in esi
mov edi,[ebp+8]  ;storing offset of MatB in edi

call Crlf

mov row_counter, 0 ; set to first row

NewRow:
    mov col_counter, 0 ; set to first column

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
    inc row_counter ; new row

    cmp row_counter, ecx 
    jle NewRow

pop ebp
ret 8
AddMatrix ENDP

SubMatrix PROC

push ebp
mov ebp, esp
mov ecx, matrix_size

mov esi,[ebp+12] ;storing offset of MatA in esi
mov edi,[ebp+8]  ;storing offset of MatB in edi

call Crlf

mov row_counter, 0 ; set to first row

NewRow:
    mov col_counter, 0 ; set to first column

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
    inc row_counter ; new row

    cmp row_counter, ecx 
    jle NewRow

pop ebp
ret 8
SubMatrix ENDP

menu proc

    call	Clrscr
    mwrite "Welcome to the Matric Multiplicator"
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

    call	calcSize		; determine size of matrices
    
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
    mwrite "Option: 4, Exit"
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

    EndofProc:
    call readChar
    jmp Top

    End1:

    ret 
menu endp

main proc

call menu

exit 
main ENDP
END MAIN