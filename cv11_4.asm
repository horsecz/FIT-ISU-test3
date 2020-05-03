%include "rw32-2018.inc"

; cv11.4 -> neco podobne na testu:
;
; vytvorte funkci: f(x) = cos ( -3*x*pi + 6 ) / abs(x^3)
; funkci je predan parametr v EAX (float), vysledek je vracen v eax (float)
; nemusi zachovat stavy registru FPU, EAX, a priznaku
; nutne osetrit deleni nulou => funkce vraci potom 0
;
; vstup: 32b hodnota v eax
; vystup: vysledna hodnota v eax

section .data
    ; zde budou vase data

section .text
_main:
    push ebp
    mov ebp, esp
    
    mov eax, __float32__(2.0)
    call funkce
    call WriteFloat
    
    mov eax, 0 ; SASM bere navratove hodnoty v EAX - nektere hodnoty muze vzit jakoze program spadnul, i kdyz tomu tak neni
    
    pop ebp
    ret
    
    
funkce:
    push ebp
    mov ebp, esp
    
    ; nachystam konstanty
    push eax
    fld dword [ebp-4] ; st0 = EAX, st1 = ?
    push __float32__(6.0)
    fld dword [ebp-8] ; st0 = 6, st1 = EAX
    push __float32__(3.0)
    fld dword [ebp-12] ; st0 = 3, st1 = 6, st2 = EAX    
    
    ; abs(x^3)
    fxch st2 ; st0 = EAX, st1 = 6, st2 = 3
    fst st3 ; st0 = EAX, st1 = 6, st2 = 3, st3 = EAX
    fmul st0 ; st0 = EAX*EAX
    fmul st3 ; st0 = EAX^3, zbytek stejne
    fabs ; st0 = abs(EAX^3)
    
    ; osetreni 0 (deleni)
    ftst ; cmp st0, 0
    fstsw ax
    sahf
    jz end
    jnz continue ; vysledek abs(x^3) je v st0 !
        
    continue:
    fldpi ; st0 = pi, st1 = abs(x^3), st2 = 6, st3 = 3, st4 = EAX = X
    fmul st4 ; st0 = x*pi, zbytek stejny
    fxch st4 ; st0 = x = eax, st1 = abs(x^3), st2 = 6, st3 = 3, st4 = x*pi
    fxch st3 ; st0 = 3, st1 = abs(x^3), st2 = 6, st3 = x, st4 = x*pi
    fchs ; st0 = -3, zb. stejny
    
    fmul st4 ; st0 = -3 * st4 = -3*x*pi ;; st0 = -3*x*pi, st1 = abs(x^3), st2 = 6, st3 = x, st4 = x*pi
    fadd st2 ; st0 = -3*x*pi+6, zb. stejne
    fcos ; st0 = cos (-3*x*pi + 6), zb stejne
    
    fdiv st1 ; st0 = (-3*x*pi+6) / abs(x^3), zb. stejne
    
    ; zkopiruje na zasobnik st0 (vysledek) a popne do eax
    end:
    fst dword [ebp-12]
    pop eax
    mov esp, ebp
    pop ebp
    ret