%include "rw32-2018.inc"

; cv11-2

; pr2: ze vstupu nacist double hodnoty X, Y. Vypocitat rovnici F = odmocnina ( X^2 + Y^2 ). Vypsat zda je vysledek > nebo < nez pi. Zasobnik FPU na konci prazdny.
; undefined hodnoty a rovnost neosetrovat

; porovnavani:
;
; st0 > stn     = CF, ZF, PF = 0
; st0 < stn     = CF=1
; st0 = stn     = ZF=1
; undefined    = CF, ZF, PF = 0

section .data
vetsi dw "vetsi nez pi",0
mensi dw "mensi nez pi",0
    ; zde budou vase data
c1 dd 1.0
c2 dd 1.0

section .text
_main:
    push ebp
    mov ebp, esp
    
    ; st0 = ?, st1 = ?, st2 = ?, ..
    call ReadDouble ; st0 = X, st1 = ?
    call ReadDouble ; st0 = Y, st1 = X, st2 = ?
    fmul st0 ; st0 = st0 * st0 = Y*Y = Y^2 ;;; st1 = X, st2 = ?
    
    fxch st1 ; st0 = X, st1 = Y^2, st2 = ?
    fmul st0 ; st0 = X*X = X^2 ;; st1 = Y^2, st2 = ?
    
    fadd st1 ; st0 = st0 + st1 = X^2 + Y^2 ; zb. stejne
    fsqrt ; st0 = odmocnina (st0) = odmocnina (X^2 + Y^2) ; zb. stejne
    
    fldpi ; st0 = pi, st1 = odm(X^2+Y^2), st2 = Y^2, st3 = ?
    
    fxch st1 ; st0 = odm(X^2+Y^2), st1 = pi
    fcomip st1 ; cmp st0, st1 --> porovna + hodi flagy do ALU
    jc .less ; st0 < pi(st1)
    jnc .more ; st0 > pi(st1)q
    
        .less:
        mov esi, mensi
        call WriteNewLine
        call WriteString
        jmp .end
        
        .more:
        mov esi, vetsi
        call WriteNewLine
        call WriteString
        jmp .end
        
    .end:
    finit
    pop ebp
    ret