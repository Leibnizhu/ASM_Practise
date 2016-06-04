assume cs:code 

code segment 
start: 
        mov ax,cs 
        mov ds,ax 
        mov si,offset do0 
        mov ax,0 
        mov es,ax 
        mov di,200h 
        mov cx,offset do0end-offset do0;代码do0的长度 
        cld 
        rep movsb 
        ;设置中断向量 
        mov ax,0 
        mov es,ax 
        mov word ptr es:[0],200h 
        mov word ptr es:[2],0 
        ;检验除法溢出 
        mov ax,1000h 
        mov bh,1 
        div bh 
        mov ax,4c00h 
         
        int 21h 
         
do0: 
        jmp short do0start 
        db "Divide ERROR !" 
do0start: 
        mov ax,cs 
        mov ds,ax 
        mov si,202h 
         
        mov ax,0b800h 
        mov es,ax 
        mov di,12*160+33*2;12行33列,屏幕正中间 
         
        mov cx,14 
s: 
        mov al,ds:[si] 
        mov es:[di],al 
        mov al,01111100b 
        mov es:[di+1],al;白底高亮红字显示 
        inc si 
        add di,2 
        loop s 
         
        mov ax,4c00h 
        int 21h 
do0end: 
        nop 
code ends 
end start