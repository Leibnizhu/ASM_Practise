assume cs:code,ds:data,ss:stack  
data segment  
db '1975','1976','1977','1978','1979','1980','1981','1982','1983'  
db '1984','1985','1986','1987','1988','1989','1990','1997','1992'  
db '1993','1994','1995'  
;以上数据为年份记录(21年),4*21=84  
;ds:[84]  
dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514  
dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000  
;以上数据为年收入记录(对应上面21年),4*21=84  
;ds:[168]  
dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258  
    dw 2793,4037,5635,8226,11542,14430,15257,17800  
    ;以上数据为雇员人数(对应上面21年),2*21=42  
    ;ds:[210]  
    db '            Data of Power Idea Company',0;39  
    db '--------------------------------------------------',0;51  
    db '      year     Income       Number    Average',0;46,6,15,28,38  
    ;ds:[346]  
    dw 8 dup (0)      
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
mov sp,32  
;输出表头  
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
;输出年份  
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
;输出年收入  
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
;输出雇员人数  
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
;输出人均收入  
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

;****子程序dwtoc开始********************************************  
;功能:将DWORD型数据变为表示十进制数的字符串,字符串以0为结尾符  
;参数:(ax)=dword型数据的低16位,(dx)=dword型数据的高16位,ds:si指向字符串的首地址  
;返回:无  
dwtoc:  
push ax  
push dx  
push cx  
push si  
push di  
mov di,0;记录数字的位数  
dwtocs:  
mov cx,10  
call divdw  
add cx,30h;余数为十进制相应数字  
push cx;十进制数字对应ASCII码入栈  
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
mov ds:[si],cx;结束了循环,cx肯定为0,放进字符串末尾  
pop di  
pop si  
pop cx  
pop dx  
pop dx  
ret  
;****子程序dwtoc结束********************************************  

;****子程序dtoc开始*********************************************  
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
;****子程序dtoc结束**************************************************  

;****子程序divdw开始*************************************************  
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
;****子程序divdw结束************************************************  

;****子程序show_str开始*********************************************  
;功能:在指定位置指定颜色显示一个用0结束的字符串  
;参数:(dh)=行号(0~24),(dl)=列号(0~79),(cl)=RGB颜色,ds:si指向字符串首地址  
;返回:<无>  
show_str:  
push ax ;将用子程序到的寄存器入栈暂存  
push bx  
push cx  
push dx  
push di  
push es  
push si  

mov ax,0B800h  
mov es,ax ;es存放显示缓冲区的段地址  
mov al,dh ;计算出(bx)=((dh)*160+(dl)*2),即dh行dl列的偏移地址  
mov bl,160  
mul bl  
mov bx,ax ;(bx)=((dh)*160)  
mov dh,0  
add bx,dx  
add bx,dx ;(bx)=((dh)*160+(dl)*2)  
mov di,0 ;通过di指向字符串里各个字符  

printf:  
push cx ;判断字符串结束用到cx,入栈暂存  
mov cl,ds:[si]  
mov ch,0  
jcxz ok  ;判断字符串是否结束  
pop cx ;出栈到cx,cl依然是颜色参数  
mov al,ds:[si]  
mov es:[bx+di],al ;字符ASCII码放进显示缓冲区  
mov es:[bx+di+1],cl ;颜色参数码放进显示缓冲区  
add di,2  
inc si  
jmp short printf  

ok:  
pop cx ;出栈到原各寄存器  
pop si  
pop es  
pop di  
pop dx  
pop cx  
pop bx  
pop ax  
ret  
;****子程序show_str结束*********************************************  
code ends  
end start