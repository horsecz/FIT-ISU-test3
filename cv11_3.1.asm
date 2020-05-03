%include "rw32-2018.inc"

; cv11.3
; bonusova uloha (good)
;
; Ze vstupu nacist 1 double hodnotu, vypocitat Y_i+1 = 1/2 * ( X/Y_i + Y_i) == funkce odmocnina, ta provede 10 iteraci a vypocita odmocninu cisla X (pribliznou).
; Vstupem je tedy X ulozen v st0, Vystup je odmocnina(X) v st0, ostatni registry musi zustat prazdne.
; Jako pocatecni hodnotu Y_0 = 1.0 - neplatne vstupy neosetrovat

section .data
    ; zde budou vase data
    
section .text
_main:
    push ebp
    mov ebp, esp
    
    call odmocnina
    
    pop ebp
    ret
    
   
odmocnina:
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
        fadd st1 ; X/Y_i + Y_i ; st0 = X/Y_i+Y_i , zbytek stejny
        fmul st2 ; st0 * 1/2, st0 = 1/2 * (X/Y_i + Y_i), zbytek stejny => st0 = Y_i+1, st1 = Y_i, st2 = 0.5, st3 = X
        fxch st1 ; st0 = Y_i = trash , st1 = Y_i+1, st2 = 0.5, st3 = X
        fxch st3 ; st0 = X, st1 = Y_i+1, st2 = 0.5, st3 = Y_i
        fst st3
        fst st3 ; st0 = X, st1 = Y_i+1, st2 = 0.5, st3 = X
        loop .for
   
    fxch st1
    call WriteDouble
    
    ; vycisti registry
    fst st1 ; zde mame X -> smaze st1
    fst st2 ; 0.5 -> smaze st2
    fst st3 ; zde je taky X -> smaze st3
    mov esp, ebp
    pop ebp
    ret