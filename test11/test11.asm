data segment 
        db "Beginner's All-purpose Symbolic Instruction Code.",0 
data ends 

code segment 
begin: 
        mov ax,data 
        mov ds,ax 
        mov si,0 
        call letterc 
         
        mov ax,4c00h 
        int 21h 
         
letterc: 
        push ax 
        push si 
lcmp: 
        mov al,ds:[si] 
        cmp al,0 
        je lreturn 
        cmp al,97 
        jb next 
        cmp al,122 
        ja next 
        sub al,32 
        mov ds:[si],al 
next: 
        inc si 
        jmp short lcmp 
lreturn: 
        pop si 
        pop cx 
        ret 
code ends 
end begin 