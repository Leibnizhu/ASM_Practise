;��data����������ֵ��ʮ�������,ÿ�����һ������
assume cs:code,ss:stack,ds:data 

data segment 
        dw 123,12666,135,5,568 
        dw 8 dup(0);ds:16��ʼ���ת�����ʮ�������� 
data ends 

stack segment 
        dw 16 dup(0);ʮ���������Լ��Ĵ����ݴ�Ҫ��ջ,�������㹻ջ��,��֤����������������� 
stack ends 

code segment 
start: 
        mov ax,data 
        mov ds,ax 
        mov ax,stack 
        mov ss,ax 
        mov sp,48 
        mov bx,5;��5�п�ʼ��ʾ 
        mov si,0 
s:   
        mov ax,ds:[si] 
        mov cx,ax 
        jcxz out1 
        push si 
        mov si,16;ds:16��ʼ���ת�����ʮ�������� 
        call dtoc 
        mov dh,bl;ÿ������һ�� 
        mov dl,4;��4�п�ʼ��ʾ 
        mov cl,2 
        call show_str 
        pop si 
        add si,2 
        inc bx 
        jmp short s 
out1: 
        mov ax,4c00h 
        int 21h 
         
        ;�ӳ���dtoc��ʼ 
        ;����:��WORD�����ݱ�Ϊ��ʾʮ���������ַ���,�ַ�����0Ϊ��β�� 
        ;����:(ax)=word������,ds:siָ���ַ������׵�ַ 
        ;����:�� 
dtoc: 
        push dx 
        push ax 
        push cx 
        push si 
        push di 
        mov di,0;��¼���ֵ�λ�� 
dtocs: 
        mov dx,0 
        mov cx,10 
        div cx;���� 
        add dx,30h;����Ϊʮ������Ӧ���� 
        push dx;ʮ�������ֶ�ӦASCII����ջ 
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
        mov ds:[si],cx;������ѭ��,cx�϶�Ϊ0,�Ž��ַ���ĩβ 
        pop di 
        pop si 
        pop cx 
        pop ax 
        pop dx 
        ret 
        ;�ӳ���dtoc���� 
         
        ;�ӳ���show_str��ʼ 
        ;����:��ָ��λ��ָ����ɫ��ʾһ����0�������ַ��� 
        ;����:(dh)=�к�(0~24),(dl)=�к�(0~79),(cl)=RGB��ɫ,ds:siָ���ַ����׵�ַ 
        ;����:<��>         
show_str: 
        push ax        ;�����ӳ��򵽵ļĴ�����ջ�ݴ� 
        push bx 
        push di 
        push es 
        push si 
         
        mov ax,0B800h 
        mov es,ax        ;es�����ʾ�������Ķε�ַ 
        mov al,dh        ;�����(bx)=((dh)*160+(dl)*2),��dh��dl�е�ƫ�Ƶ�ַ 
        mov bl,160 
        mul bl 
        mov bx,ax        ;(bx)=((dh)*160) 
        mov dh,0 
        add bx,dx 
        add bx,dx        ;(bx)=((dh)*160+(dl)*2) 
        mov di,0        ;ͨ��diָ���ַ���������ַ� 
         
printf: 
        push cx        ;�ж��ַ��������õ�cx,��ջ�ݴ� 
        mov cl,ds:[si] 
        mov ch,0 
        jcxz ok                ;�ж��ַ����Ƿ���� 
        pop cx        ;��ջ��cx,cl��Ȼ����ɫ���� 
        mov al,ds:[si] 
        mov es:[bx+di],al        ;�ַ�ASCII��Ž���ʾ������ 
        mov es:[bx+di+1],cl        ;��ɫ������Ž���ʾ������ 
        add di,2 
        inc si 
        jmp short printf 
         
ok: 
        pop cx        ;��ջ��ԭ���Ĵ��� 
        pop si 
        pop es 
        pop di 
        pop bx 
        pop ax 
        ret 
        ;�ӳ���show_str���� 
code ends 
end start