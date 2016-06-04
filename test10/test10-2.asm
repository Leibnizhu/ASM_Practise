assume cs:code,ss:stack 

stack segment 
        dw 8 dup(0) 
stack ends 

code segment 
        start: 
        mov ax,stack 
        mov ss,ax 
        mov sp,16 
        mov ax,4240h 
        mov dx,000fh 
        mov cx,0Ah 
        call divdw 
        mov ax,4c00h 
        int 21h 
         
        ;子程序divdw开始 
        ;功能:进行不会溢出的除法运算,被除数是dword型,除数是word型,结果为dword型 
        ;参数:(ax)=dword型数据的低16位,(dx)=dword型数据的高16位,(cx)=除数 
        ;返回:(ax)=结果的低16位,(dx)=结果的高16位,(cx)=余数, 
divdw: 
        push bx 
        push ax 
        mov ax,dx 
        mov dx,0 
        div cx;dx/cx 
        mov bx,ax;保存起要返回的dx(结果的高16位) 
        pop ax 
        div cx;(dx*65536+ax)/cx,返回商ax 
        mov cx,dx;返回cx 
        mov dx,bx;正式返回dx 
        pop bx 
        ret 
        ;子程序divdw结束 
code ends 
end start 