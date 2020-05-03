%include "rw32-2018.inc"

; cv11.3
; bonusova uloha (bad)
;
; mocnina cisla z inputu (vytvoreno omylem xd), 

section .data
    ; zde budou vase data

section .text
_main:
    push ebp
    mov ebp, esp
    
    call ReadDouble ; st0 = X
    mov ecx, 10
    fld1 ; st0 = 1.0 = Y_0, st1 = X
    fld1
    
    push __float32__(2.0)
    fdiv dword [ebp-4] ; st0 = 1.0 / 2 = 0.5, st1 = 1.0, st2 = X
    fxch st2 ; st0 = X, st1 = 1.0 = Y_i = Y_0, st2 = 0.5
    fst st3 ; st0 = X, st1 = 1.0 = Y_0, st2 = 0.5, st3 = X
    
    .for:
        fdiv st1 ; X/Y_i
        fadd st0 ; X/Y_i + Y_i ; st0 = X/Y_i+Y_i , zbytek stejny
        fmul st2 ; st0 * 1/2, st0 = 1/2 * (X/Y_i + Y_i), zbytek stejny => st0 = Y_i+1, st1 = Y_i, st2 = 0.5, st3 = X
        fxch st1 ; st0 = Y_i+1, st1 = Y_i, st2 = 0.5, st3 = X
        fxch st3 ; st0 = X, st1 = Y_i, st2 = 0.5, st3 = Y_i+1
        loop .for
    ; zde bude vas kod
    fxch st3 ; st0 = Y_i+1, st1 = Y_i, st2 = 0.5, st3 = X
    call WriteDouble
    
    finit
    mov esp, ebp
    pop ebp
    ret