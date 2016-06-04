assume cs:code 

code segment 
start: 
        mov ax,cs 
        mov ds,ax 
        mov si,offset int_7ch 
        mov ax,0 
        mov es,ax 
        mov di,200h 
        mov cx,offset int_7ch_end-offset int_7ch 
        cld 
        rep movsb 
         
        mov word ptr es:[7ch*4],0 
        mov word ptr es:[7ch*4+2],20h 
         
        mov ax,4c00h 
        int 21h 
        ;新的int 7ch中断例程 
        ;参数:(ah)=功能,0---读,1---写;(dx)=要读写的扇区的逻辑扇区号;es:bx指向存储读出写入的数据的内存区 
        ;返回:<无> 
int_7ch: 
        push bx 
        push ax 
        mov ax,dx 
        mov dx,0 
        mov bx,1440 
        div bx 
        mov cx,dx;cx暂存dx 
        mov dh,al;面号 
        mov dl,0;A盘 
        mov ax,cx 
        mov bl,18 
        div bl 
        mov ch,ah;磁道号 
        inc al 
        mov cl,al;扇区号 
        pop ax 
        mov al,1;扇区数 
        add ah,2;int 13h的功能号 
        pop bx;es:bx指向了数据的内存区 
        int 13h 
        iret 
int_7ch_end: 
        nop 

code ends 
end start