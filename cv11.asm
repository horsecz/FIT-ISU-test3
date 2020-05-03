%include "rw32-2020.inc"

; cv11-1
; pr1 - ze vstupu nacist 2 double hodnoty X, Y a spocitat rovnici F = (0.3*X)  / (2+Y) --> deleni 0 neosetrovat, FPU je na konci prazdny

section .data
two dd 2
zpt dq 0.3
string dw "Deleni nulou!",0

    ; zde budou vase data

section .text
_main:
    push ebp
    mov ebp, esp
    
    ;FPU: st0 = ?, st1 = ?, st2 = ?, st3 = ? ...
    ;fld qword [zpt]    ; st0 = 0.3, st1 = ?
    push __float32__(0.3)
    fld dword [ebp - 4] ; to same co nahore akorat z pameti (float = dword = 32b !!)
    
    ;fild dword [two]  ; st0 = 2, st1 = 0.3, st2 = ?
    fld1
    fadd st0 ; same co hore
    
    call ReadDouble ; nacte X --> st0 = X, st1 = 2, st2 = 0.3, st3 = ?
    fmul st2 ; st0 = X*0.3, zbytek stejny
    
    call ReadDouble ; nacte Y --> st0 = Y, st1 = X*0.3, st2 = 2, st3 = 0.3, st4 = ?
    fadd st0, st2 ; st0 = Y+2, zbytek stejny
    
    ; osetreni deleni nulou
    ftst ; cmp st0, 0
    fstsw ax ; ulozi priznaky FPU do AX
    sahf ; ulozi priznkay FPU z AX(AH) do CFLAGS registru -> namapuji se priznaky CF, ZF, PF
    ;jz .error          ; jump if zeroflag
    ;jnz .continue  ; not zero flag
    je .error
    jne .continue
        .error:
        mov esi, string
        call WriteNewLine
        call WriteString
        jmp end
    
    .continue:
    fxch st1 ; st0 = X*0.3, st1 = Y+2, st2 = 2, st3 = 0.3, st4 = ?
    
    fdiv st1 ; st0 = st0 / st1 = X*0.3 / 2+Y ; zbytek stejny
    call WriteNewLine
    call WriteDouble

    end:
    finit ; vyprazdni se fpu
    mov esp, ebp ; posune zasobnik (zahodi ty dve konstanty)
    pop ebp
    ret