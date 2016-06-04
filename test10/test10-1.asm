assume cs:code,ds:data,ss:stack 

data segment 
        db 'Welcome to masm!',0 
data ends 

stack segment 
        dw 8 dup(0) 
stack ends 

code segment 
start:mov ax,stack        ;设置栈 
        mov ss,ax 
        mov sp,16 
        mov dh,8        ;在第8行第3列(从0行0列算起)显示 
        mov dl,3 
        mov cl,2        ;黑底绿字 
        mov ax,data 
        mov ds,ax 
        mov si,0 
        call show_str        ;调用show_str显示字符 
         
        mov ax,4c00h 
        int 21h 
        ;子程序show_str开始 
        ;功能:在指定位置指定颜色显示一个用0结束的字符串 
        ;参数:(dh)=行号(0~24),(dl)=列号(0~79),(cl)=RGB颜色,ds:si指向字符串首地址 
        ;返回:<无> 
show_str:push ax        ;将用子程序到的寄存器入栈暂存 
        push bx 
        push di 
        push es 
         
        mov ax,0B800h 
        mov es,ax        ;es存放显示缓冲区的 
        mov al,dh        ;计算出(bx)=((dh)*160+(dl)*2),即dh行dl列的偏移地址 
        mov bl,160 
        mul bl 
        mov bx,ax        ;(bx)=((dh)*160) 
        mov dh,0 
        add bx,dx 
        add bx,dx        ;(bx)=((dh)*160+(dl)*2) 
        mov di,0        ;通过di指向字符串里各个字符 
         
printf:push cx        ;判断字符串结束用到cx,入栈暂存 
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
         
ok:pop es        ;出栈到原各寄存器 
        pop di 
        pop bx 
        pop bx 
        pop ax 
       ret
code ends 
end start 
