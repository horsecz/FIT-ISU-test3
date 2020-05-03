%include "rw32-2018.inc"

; cv11.5
;
; Vykreslete Mandelbrotovu mnozinu
;
; predpis: z_0 = 0,   z_n+1 = (z_n)^2 + c
; potom je to mnozina C cisel, pro kterou plati |z_k| < 2 pro vsechna k
; k vykresleni pouzijte cislice 0-9, znaci pocet iteraci, pro ktere platil vyraz: | real(z_k) | < 2 && | imag (z_k) < 2

section .data
    ; zde budou vase data

section .text
_main:
    push ebp
    mov ebp, esp
    
    call mandel

    pop ebp
    ret
    
mandel:
    push ebp
    mov ebp, esp
    
    
    
    pop ebp
    ret