assume cs:code,ds:data,ss:stack  
data segment  
db '1975','1976','1977','1978','1979','1980','1981','1982','1983'  
db '1984','1985','1986','1987','1988','1989','1990','1997','1992'  
db '1993','1994','1995'  
;��������Ϊ��ݼ�¼(21��),4*21=84  
;ds:[84]  
dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514  
dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000  
;��������Ϊ�������¼(��Ӧ����21��),4*21=84  
;ds:[168]  
dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258  
    dw 2793,4037,5635,8226,11542,14430,15257,17800  
    ;��������Ϊ��Ա����(��Ӧ����21��),2*21=42  
    ;ds:[210]  
    db '            Data of Power Idea Company',0;39  
    db '--------------------------------------------------',0;51  
    db '      year     Income       Number    Average',0;46,6,15,28,38  
    ;ds:[346]  
    dw 8 dup (0)      
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
mov sp,32  
;�����ͷ  
mov dh,0  
mov dl,0  
mov cl,4  
mov si,210  
call show_str  
inc dh  
mov cl,7  
mov si,249  
call show_str  
inc dh  
mov si,300  
call show_str  
;������  
mov bx,0  
add dh,2  
mov cx,21  
s1:  
push ds:[bx]  
push ds:[bx+2]  
pop ds:[348]  
pop ds:[346]  
mov di,0  
mov ds:[350],di  
mov si,346  
mov dl,6  
push cx  
mov cl,2  
call show_str  
pop cx  
inc dh  
add bx,4  
loop s1  
;���������  
mov cx,21  
mov bx,84  
mov dl,15  
mov dh,4  
s2:  
push cx  
push dx  
mov ax,ds:[bx]  
mov dx,ds:[bx+2]  
mov si,346  
call dwtoc  
pop dx  
mov cl,2  
call show_str  
pop cx  
inc dh  
add bx,4  
loop s2  
;�����Ա����  
mov cx,21  
mov bx,168  
mov dl,28  
mov dh,4  
s3:  
push cx  
mov ax,ds:[bx]  
mov si,346  
call dtoc  
mov cl,2  
call show_str  
pop cx  
inc dh  
add bx,2  
loop s3  
;����˾�����  
mov cx,21  
mov bx,84  
mov bp,168  
mov dh,4  
s4:  
push cx  
push dx  
mov ax,ds:[bx]  
mov dx,ds:[bx+2]  
div word ptr ds:[bp]  
mov si,346  
call dtoc  
pop dx  
mov cl,2  
mov dl,38  
call show_str  
pop cx  
add bx,4  
add bp,2  
inc dh  
loop s4  

mov ax,4c00h  
int 21h  

;****�ӳ���dwtoc��ʼ********************************************  
;����:��DWORD�����ݱ�Ϊ��ʾʮ���������ַ���,�ַ�����0Ϊ��β��  
;����:(ax)=dword�����ݵĵ�16λ,(dx)=dword�����ݵĸ�16λ,ds:siָ���ַ������׵�ַ  
;����:��  
dwtoc:  
push ax  
push dx  
push cx  
push si  
push di  
mov di,0;��¼���ֵ�λ��  
dwtocs:  
mov cx,10  
call divdw  
add cx,30h;����Ϊʮ������Ӧ����  
push cx;ʮ�������ֶ�ӦASCII����ջ  
inc di  
mov cx,dx  
jcxz judge1  
jmp short dwtocs  
judge1:  
mov cx,ax  
jcxz judge2  
jmp short dwtocs  
judge2:  
mov cx,di  
dwtocs1:  
pop ax  
mov ds:[si],al  
inc si  
loop dwtocs1  
mov ds:[si],cx;������ѭ��,cx�϶�Ϊ0,�Ž��ַ���ĩβ  
pop di  
pop si  
pop cx  
pop dx  
pop dx  
ret  
;****�ӳ���dwtoc����********************************************  

;****�ӳ���dtoc��ʼ*********************************************  
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
;****�ӳ���dtoc����**************************************************  

;****�ӳ���divdw��ʼ*************************************************  
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
;****�ӳ���divdw����************************************************  

;****�ӳ���show_str��ʼ*********************************************  
;����:��ָ��λ��ָ����ɫ��ʾһ����0�������ַ���  
;����:(dh)=�к�(0~24),(dl)=�к�(0~79),(cl)=RGB��ɫ,ds:siָ���ַ����׵�ַ  
;����:<��>  
show_str:  
push ax ;�����ӳ��򵽵ļĴ�����ջ�ݴ�  
push bx  
push cx  
push dx  
push di  
push es  
push si  

mov ax,0B800h  
mov es,ax ;es�����ʾ�������Ķε�ַ  
mov al,dh ;�����(bx)=((dh)*160+(dl)*2),��dh��dl�е�ƫ�Ƶ�ַ  
mov bl,160  
mul bl  
mov bx,ax ;(bx)=((dh)*160)  
mov dh,0  
add bx,dx  
add bx,dx ;(bx)=((dh)*160+(dl)*2)  
mov di,0 ;ͨ��diָ���ַ���������ַ�  

printf:  
push cx ;�ж��ַ��������õ�cx,��ջ�ݴ�  
mov cl,ds:[si]  
mov ch,0  
jcxz ok  ;�ж��ַ����Ƿ����  
pop cx ;��ջ��cx,cl��Ȼ����ɫ����  
mov al,ds:[si]  
mov es:[bx+di],al ;�ַ�ASCII��Ž���ʾ������  
mov es:[bx+di+1],cl ;��ɫ������Ž���ʾ������  
add di,2  
inc si  
jmp short printf  

ok:  
pop cx ;��ջ��ԭ���Ĵ���  
pop si  
pop es  
pop di  
pop dx  
pop cx  
pop bx  
pop ax  
ret  
;****�ӳ���show_str����*********************************************  
code ends  
end start