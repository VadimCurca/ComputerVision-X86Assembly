global _sobel
extern sqrt

_sobel:
    push ebp
    mov ebp, esp
    push eax
    push ebx
    push ecx
    push edx
    pushf

    sub esp, 24         ; allocate 6 variables of 4 bytes

;   lines[0] = esp + 0
;   lines[1] = esp + 4
;   lines[2] = esp + 8
;   vx = esp + 12
;   vy = esp + 16
;   i = esp + 20

    mov eax, [ebp + 8]  ; inBuffer
    mov ecx, [ebp + 16] ; width

    mov [esp + 0], eax ; lines[0]
    add eax, 1920
    mov [esp + 4], eax ; lines[1]
    add eax, 1920
    mov [esp + 8], eax ; lines[2]

    mov [esp + 20], ecx  ; i

mainLoop:
;/////// vx
    xor edx, edx

    mov ebx, [esp + 0]  ; lines[0]
    movzx eax, byte [ebx]
    movzx ecx, byte [ebx + 2]
    xor eax, 0xFFFFFFFF
    add eax, 1
    add edx, eax
    add edx, ecx

    mov ebx, [esp + 4]  ; lines[1]
    movzx eax, byte [ebx]
    movzx ecx, byte [ebx + 2]
    shl ecx, 1
    xor eax, 0xFFFFFFFF
    add eax, 1
    shl eax, 1
    add edx, eax
    add edx, ecx

    mov ebx, [esp + 8]  ; lines[2]
    movzx eax, byte [ebx]
    movzx ecx, byte [ebx + 2]
    xor eax, 0xFFFFFFFF
    add eax, 1
    add edx, eax
    add edx, ecx

    mov [esp + 12], edx

;//////// vy

    xor edx, edx

    mov ebx, [esp + 0]  ; lines[0]
    movzx eax, byte [ebx]
    movzx ecx, byte [ebx + 2]
    movzx ebx, byte [ebx + 1]

    xor eax, 0xFFFFFFFF
    add eax, 1
    xor ebx, 0xFFFFFFFF
    add ebx, 1
    shl ebx, 1
    xor ecx, 0xFFFFFFFF
    add ecx, 1

    add edx, eax
    add edx, ebx
    add edx, ecx

    mov ebx, [esp + 8]  ; lines[2]
    movzx eax, byte [ebx]
    movzx ecx, byte [ebx + 2]
    movzx ebx, byte [ebx + 1]
    shl ebx, 1

    add edx, eax
    add edx, ebx
    add edx, ecx

    mov [esp + 16], edx

;////// gradient

    mov eax, [esp + 12]
    mul eax
    mov ecx, eax
    mov eax, [esp + 16]
    mul eax
    add eax, ecx

;// sqrt aproximation

;   test    eax, eax
    jnz     positive
    jmp end
positive:
    mov     ecx, eax
    shl     ecx, 1
    or      eax, ecx
    bsr     ecx, eax ; Get highest bit for later adjustment
    xor     edx, edx
sqrtLoop:
    shr     eax, 2
    rcr     dx, 1
    jnz     sqrtLoop
    shr     cl, 1    ; Adjust for skipped bits
    inc     cl
    rol     dx, cl
    mov     eax, edx ; Use ecx to store estimation
end:

    cmp eax, 255
    JL L2
    mov eax, 255
L2:

;////// output

    mov edx, [ebp + 12] ; out
    mov [edx], eax

;////// increment pointers

    mov eax, [esp + 0]
    inc eax
    mov [esp + 0], eax
    mov eax, [esp + 4]
    inc eax
    mov [esp + 4], eax
    mov eax, [esp + 8]
    inc eax
    mov [esp + 8], eax

    mov eax, [ebp + 8]
    inc eax
    mov [ebp + 8], eax
    mov eax, [ebp + 12]
    inc eax
    mov [ebp + 12], eax

    mov ecx, [esp + 20]
    DEC ecx
    mov [esp + 20], ecx
    JNZ mainLoop
;/////// end of loop

    ;add esp, 24
    ;popf
    ;pop edx
    ;pop ecx
    ;pop ebx
    ;pop eax

    mov esp, ebp
    pop ebp
    ret
