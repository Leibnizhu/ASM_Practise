assume cs:code 
         
code segment 
start: 
        mov ax,cs 
        mov ds,ax 
        mov si,offset lp 
        mov ax,0 
        mov es,ax 
        mov di,200h 
        mov cx,offset lp_end-offset lp 
        cld 
        rep movsb 
        mov word ptr es:[7ch*4],200h  
    mov word ptr es:[7ch*4+2],0  
    ;检验int 7ch中断例程 
    mov ax,0b800h 
    mov es,ax 
    mov di,160*12 
    mov bx,offset s-offset se 
    mov cx,80 
s: 
        mov byte ptr es:[di],'!' 
        add di,2 
        int 7ch 
se: 
        nop 
        mov ax,4c00h 
        int 21h 
        ;int 7ch中断例程代码 
lp: 
        push bp 
        mov bp,sp 
        dec cx 
        jcxz lpret 
        add ss:[bp+2],bx 
lpret: 
        pop bp 
        iret 
lp_end: 
        nop 
code ends 
end start 