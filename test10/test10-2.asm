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
         
        ;�ӳ���divdw��ʼ 
        ;����:���в�������ĳ�������,��������dword��,������word��,���Ϊdword�� 
        ;����:(ax)=dword�����ݵĵ�16λ,(dx)=dword�����ݵĸ�16λ,(cx)=���� 
        ;����:(ax)=����ĵ�16λ,(dx)=����ĸ�16λ,(cx)=����, 
divdw: 
        push bx 
        push ax 
        mov ax,dx 
        mov dx,0 
        div cx;dx/cx 
        mov bx,ax;������Ҫ���ص�dx(����ĸ�16λ) 
        pop ax 
        div cx;(dx*65536+ax)/cx,������ax 
        mov cx,dx;����cx 
        mov dx,bx;��ʽ����dx 
        pop bx 
        ret 
        ;�ӳ���divdw���� 
code ends 
end start 