assume cs:code,ds:data 

data segment 
        db 'yy/mm/dd hh:mm:ss','$';放显示时间的字符串 
        db 9,8,7,4,2,0 
data ends 

code segment 
start: 
        mov ax,data 
        mov ds,ax 
        mov si,0;显示时间的字符串 
        mov di,18;要读取CMOS时间的单元 
        mov cx,6 
s: 
        mov al,ds:[di] 
        out 70h,al 
        in al,71h 
        mov ah,al 
        push cx 
        mov cl,4 
        shr ah,cl 
        pop cx 
        and al,00001111b 
        add ax,3030h 
        mov ds:[si],ah;十位数 
        mov ds:[si+1],al;个位数 
        inc di 
        add si,3 
        loop s 
        ;利用BIOS的int 10h中断例程设置光标 
        mov ah,2 
        mov bh,0 
        mov dh,5 
        mov dl,12 
        int 10h 
        ;利用DOS的int 21h中断例程显示字符串 
        mov dx,0 
        mov ah,9 
        int 21h 
        ;死循环，不断显示时间 
        jmp short start 
        ;以下基本没用，不过把外中断键盘那部分学了，就可以弄成按键退出了 
        mov ax,4c00h 
        int 21h 
code ends 
end start