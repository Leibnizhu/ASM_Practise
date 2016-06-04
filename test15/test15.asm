assume cs:code 

stack segment 
        db 128 dup(0) 
stack ends 

code segment 
start: 
        mov ax,stack 
        mov ss,ax 
        mov sp,128 
        a 
        push cs 
        pop ds 
        mov ax,0 
        mov es,ax 
        mov si,offset int_9 
        mov di,204h 
        mov cx,offset int_9_end-offset int_9 
        cld 
        rep movsb 
        ;保存原有的int 9中断例程的入口地址 
        push es:[9*4] 
        pop es:[200h] 
        push es:[9*4+2] 
        pop es:[202h] 
         
        cli;设中断向量表的过程防止响应了int 9中断 
        mov word ptr es:[9*4],204h 
        mov word ptr es:[9*4+2],0 
        sti 
         
        mov ax,4c00h 
        int 21h 
         
int_9: 
        push es 
        push ax 
        push bx 
        push cx 
         
        in al,60h 
         
        pushf 
        call dword ptr cs:[200h] 
         
        cmp al,9eh;a的断码 
        jne int_9_ret 
         
        mov ax,0b800h 
        mov es,ax 
        mov bx,0 
        mov cx,2000 
s: 
        mov byte ptr es:[bx],'A';满屏A 
        add bx,2 
        loop s 
int_9_ret: 
        pop cx 
        pop bx 
        pop ax 
        pop es 
        iret 
int_9_end: 
        nop 
         
code ends 
end start