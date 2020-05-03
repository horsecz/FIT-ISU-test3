%include "rw32-2020.inc"

;cv12.1
;
; konvence volani:
;
; pascal     ->zleva-doprava                                            ->  uklizi volany   ->  jmena (v C) deklarovana symbol             -> pouziva se v Pascalu
; cdecl      -> zprava-doleva                                           ->   uklizi volajici   -> jmena (v C) deklarovana _symbol           -> pouziva se v C
; stdcall    -> zprava-doleva                                           ->   uklizi volany   -> jmena (v C) deklarovana _symbol@4       -> pouziva se v Win32 API
; fastcall   -> prvni dva v ecx, edx, zbytek zprava doleva ->   uklizi volany   -> jmena (v C) deklarovana @symbol@8      -> pouziva se v ruzne
;
; parametry zprava-doleva => prvni argument je ten nejbliz (ebp+8)
; parametry zleva-doprava => prvni argumentu je opravdu ten prvni

; zasobnik uklizi volajici     => v mainu pushe, call, potom idealne add esp, poc_pars*4 nebo popy
; zasobnik uklizi volany      => v mainu pushe, call, potom ret [pocet_pars*4]

; Cckovske funkce vesele prepisuje registry
; lokalni promenne =  [ebp - 4*n]
; argumenty =           [ebp + 4 + 4*n] (1. = +8, 2. = +12, ..), +4 = ramec, +0 = return

; C funkce maji navratove hodnoty v EAX standartne, jmena jsou _symbol, resp. _getchar, _putchar, _printf, ...
; !!! volanim funkci z C muze dojit k prepsani obecnych registru EAX, EBX, ECX, EDX

;
; priklad: 
; napiste funkci, ktera vytiskne N nahodnych cisel
; vstup: hodnota N predana pres zasobnik dle CDECL
; vystup: N nahodnych cisel vypsanych na stdout
; ujistete se,ze hodnoty jsou pri kazdem spusteni opravdu nahodne

; pouzijte funkce z C: rand(), srand(), time()

section .data
numbers dd 10
    ; zde budou vase data

section .text
_main:
    push ebp
    mov ebp, esp
    
    push dword [numbers]    
    call RandomNumbers
    add esp, 4

    pop ebp
    ret
    
RandomNumbers:
    push ebp
    mov ebp, esp
    sub esp, 4
    
    ; externi deklarace C funkci
    CEXTERN rand    ; int rand(void);   -> vrati nahodne cislo 0 - RAND_MAX
    CEXTERN srand  ; void srand(unsigned int seed); -> nastavi sito nove sekvence random cisel vracejicich rand()
    CEXTERN time    ; time_t time(time_t *tloc); -> vrati cas jako uint sekund od 70-01-01 00:00.00, tloc by mel byt vzdy NULL
    
    ; parametr funkce N je v ebp+8
    
    mov ecx, [ebp+8]
    
    for:
    mov dword [esp+12], ecx
    
    mov eax, 0
    push eax ; time_t *tloc
    call time
    add esp, 4
    imul dword [esp+12] ; znahodnime cisla
    push eax ; unsigned int seed
    call srand
    add esp, 4
    call rand
    call rand ; 2x aby bylo vic nahodne
    call WriteInt32
    call WriteNewLine
    
    mov ecx, [esp+12]
    dec ecx
    cmp ecx, 0
    jne for
    
    mov esp, ebp
    pop ebp
    ret