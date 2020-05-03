%include "rw32-2020.inc"

; cv12.3
; priklad:

; vytvorte ekvivalent k zapisu
;   for (int i = 1; i <= 10; i++) {
;       printf ("%02d * pi = %f\n", i, M_PI*i);
;   }
;
; vypis pak vypada nejak takto:
;   01 * pi = 3.141593
;   02 * pi = 6.283185
;   ( ... )
;   10 * pi = 31.41527

section .data
format db "%02d * pi = %f",EOL,0
    ; zde budou vase data

section .text
_main:
    push ebp
    mov ebp, esp
    
    CEXTERN printf ; int printf(const char* format, ...);
    mov ecx, 1
    
    for:
    push ecx
    
    fild dword [esp]
    fldpi ; st0 = 3.14159 ...
    fmulp
    sub esp, 8

    fstp qword [esp]
    
    push ecx
    
    push format
    call printf
    add esp, 16
    pop ecx
    
    inc ecx
    cmp ecx, 10
    jna for
    
    mov eax, 0
    mov esp, ebp
    pop ebp
    ret