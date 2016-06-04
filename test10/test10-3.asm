;把data段里所有数值以十进制输出,每行输出一个数字
assume cs:code,ss:stack,ds:data 

data segment 
        dw 123,12666,135,5,568 
        dw 8 dup(0);ds:16开始存放转换后的十进制数字 
data ends 

stack segment 
        dw 16 dup(0);十进制数字以及寄存器暂存要入栈,故设置足够栈长,保证不溢出覆盖其他数据 
stack ends 

code segment 
start: 
        mov ax,data 
        mov ds,ax 
        mov ax,stack 
        mov ss,ax 
        mov sp,48 
        mov bx,5;第5行开始显示 
        mov si,0 
s:   
        mov ax,ds:[si] 
        mov cx,ax 
        jcxz out1 
        push si 
        mov si,16;ds:16开始存放转换后的十进制数字 
        call dtoc 
        mov dh,bl;每个数字一行 
        mov dl,4;第4列开始显示 
        mov cl,2 
        call show_str 
        pop si 
        add si,2 
        inc bx 
        jmp short s 
out1: 
        mov ax,4c00h 
        int 21h 
         
        ;子程序dtoc开始 
        ;功能:将WORD型数据变为表示十进制数的字符串,字符串以0为结尾符 
        ;参数:(ax)=word型数据,ds:si指向字符串的首地址 
        ;返回:无 
dtoc: 
        push dx 
        push ax 
        push cx 
        push si 
        push di 
        mov di,0;记录数字的位数 
dtocs: 
        mov dx,0 
        mov cx,10 
        div cx;除法 
        add dx,30h;余数为十进制相应数字 
        push dx;十进制数字对应ASCII码入栈 
        inc di 
        mov cx,ax 
        jcxz dtocok 
        jmp short dtocs 
dtocok: 
        mov cx,di 
dtocs0: 
        pop ax 
        mov ds:[si],al 
        inc si 
        loop dtocs0 
        mov ds:[si],cx;结束了循环,cx肯定为0,放进字符串末尾 
        pop di 
        pop si 
        pop cx 
        pop ax 
        pop dx 
        ret 
        ;子程序dtoc结束 
         
        ;子程序show_str开始 
        ;功能:在指定位置指定颜色显示一个用0结束的字符串 
        ;参数:(dh)=行号(0~24),(dl)=列号(0~79),(cl)=RGB颜色,ds:si指向字符串首地址 
        ;返回:<无>         
show_str: 
        push ax        ;将用子程序到的寄存器入栈暂存 
        push bx 
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
        push cx        ;判断字符串结束用到cx,入栈暂存 
        mov cl,ds:[si] 
        mov ch,0 
        jcxz ok                ;判断字符串是否结束 
        pop cx        ;出栈到cx,cl依然是颜色参数 
        mov al,ds:[si] 
        mov es:[bx+di],al        ;字符ASCII码放进显示缓冲区 
        mov es:[bx+di+1],cl        ;颜色参数码放进显示缓冲区 
        add di,2 
        inc si 
        jmp short printf 
         
ok: 
        pop cx        ;出栈到原各寄存器 
        pop si 
        pop es 
        pop di 
        pop bx 
        pop ax 
        ret 
        ;子程序show_str结束 
code ends 
end start