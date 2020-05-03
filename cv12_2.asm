%include "rw32-2018.inc"

; cv12.2
; priklad:
;
; v mainu nactete tri vstupny hodnoty typu float
; Implementujte funkci Dostrel, ktera provede vypocet rovnice d = ((v^2) / g ) * sin (2*p)
; vstup: parametry predane pres zasobnik dle CDECL
;   float Dostrel ( float v, float g, float p );
; vystup: hodnota d vracena v EAX
; pri zadani neplatneho vstupu g <= 0 vypsat chybove hlaseni 

section .data
err dw "Neplatny argument g!",0
    ; zde budou vase data

section .text
_main:
    push ebp
    mov ebp, esp
    
    push __float32__(0.7854)   ; float p
    push __float32__(9.81) ; float g
    push __float32__(15.5)   ; float v
    call Dostrel
    add esp, 12

    call WriteFloat

    mov eax, 0
    pop ebp
    ret
    
Dostrel:
    push ebp
    mov ebp, esp
    
    ; osetreni hodnoty float g
    fld dword [ebp+12] ; st0 = g, st1 =?
    ftst ; cmp st0, 0
    fstsw ax
    sahf
    jbe .invalid
    jmp continue
    
        .invalid:
        mov esi, err
        call WriteString
        mov eax, 0
        jmp end
    
    ; pokracovani pokud je g v poradku    
    continue:
    fld dword [ebp+8]  ; nahraje v
    fld dword [ebp+16] ; nahraje p -> st0 = p, st1 = v, st2 = g, st3 = ?
    fxch st1 ; st0 = v, st1 = p, st2 = g, ..
    fmul st0 ; st0 = v^2, st1 = p, st2 = g
    fdiv st2 ; st0 = (v^2) / g, st1 = p, st2 = g
    
    fxch st1 ; st0 = p, st1 = (v^2) / g, st2 = g
    fadd st0 ; st0 = p+p = 2p, st1 = (v^2) /g, st 2 = g
    fsin ; st0 = sin(2*p), st1 = (v^2) / g, st2 = g, ...
    fmul st1 ; st0 = sin(2*p) * ( (v^2) / g ), st1 = v^2 /g, st2 = g
    
    push eax
    fst dword [ebp-4]
    pop eax
                    
    end:
    finit ; uklid, vyprazdni FPU
    mov esp, ebp
    pop ebp
    ret