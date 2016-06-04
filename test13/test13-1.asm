assume cs:code 

data segment 
        db "welcome to masm!",0 
data ends 

code segment 
start: 
        mov ax,cs 
        mov ds,ax 
        mov si,offset show_str 
        mov ax,0 
        mov es,ax 
        mov di,200h 
        mov cx,offset show_strend-offset show_str 
        cld 
        rep movsb 
        mov word ptr es:[7ch*4],200h  
    mov word ptr es:[7ch*4+2],0  
    ;检验int 7ch中断例程 
    mov dh,10 
    mov dl,10 
    mov cl,2 
    mov ax,data 
    mov ds,ax 
    mov si,0 
    int 7ch 
    mov ax,4c00h  
    int 21h 
         
show_str: 
        push ax        ;将用子程序到的寄存器入栈暂存 
        push bx 
        push cx 
        push dx 
        push di 
        push es 
        push si 
         
        mov ax,0B800h 
        mov es,ax        ;es存放显示缓冲区的段地址 
        mov al,dh        ;计算出(bx)=((dh)*160+(dl)*2),即dh行dl列的偏移地址 
        mov bl,160 
        mul bl 
        mov bx,ax        ;(bx)=((dh)*160) 
        mov dh,0 
        add bx,dx 
        add bx,dx        ;(bx)=((dh)*160+(dl)*2) 
        mov di,0        ;通过di指向字符串里各个字符 
         
printf: 
        cmp byte ptr ds:[si],0 
        je ok                ;判断字符串是否结束 
        mov al,ds:[si] 
        mov es:[bx+di],al        ;字符ASCII码放进显示缓冲区 
        mov es:[bx+di+1],cl        ;颜色参数码放进显示缓冲区 
        add di,2 
        inc si 
        jmp short printf 
         
ok:;出栈到原各寄存器 
        pop si 
        pop es 
        pop di 
        pop dx 
        pop cx 
        pop bx 
        pop ax 
        iret 
show_strend: 
        nop 
code ends 
end start 