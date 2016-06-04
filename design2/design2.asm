assume cs:code 

code segment 
;***软盘的安装程序,具体代码数据见后面***************************** 
start: 
        mov ax,cs 
        mov es,ax 
        mov ax,0303h 
        mov bx,offset part1 
        mov cx,0001h 
        mov dx,0000h;将cs:(offset part1)处写入A盘0道0面1扇区开始的3个扇区 
        int 13h 
         
        mov ax,4c00h 
        int 21h 
         
;***软盘的安装程序到此结束**************************************** 

;***以下为将要写入软盘的数据区************************************ 

;***1扇区的数据由此开始******************************************* 
org 7c00h 
part1: 
        XOR AX,AX 
jmp short retry 
        dw 8 dup(0) 
retry: 
        mov ax,0202h 
        mov cx,0002h 
        mov dx,0000h;读A盘0道0面2扇区开始的2个扇区 
        mov bx,0 
        mov es,bx 
        mov bx,7E00h 
        int 13h 
        ;cmp ah,0 
        ;jne retry;出错的话,继续读盘 
        mov ax,cs 
        mov ss,ax 
        mov sp,offset retry 
        mov ax,0 
        push ax;CS 
        mov ax,7E00h 
        push ax;IP 
        retf;跳到0:7E00,也就是0:7c00之后512字节的位置 
        ;debug联合WinHEX发现到此为止机器码共60字节,512-2-60＝450 
        db 455 dup(0);填充空间,凑够512字节 
        dw 0AA55h;以下引自网上资料: 
                        ;BIOS中断总是把主引导记录所在扇区(硬盘的0头0道1扇区)的内容(包括代码和数据)  
                        ;装入内存0000:7C00起始的区域，然后检验该扇区内容的最后两个字节是不是"AA55",  
                        ;如果不是,那么对不起，Int 19h将不把控制权交给主引导记录；若是，则主引导记录  
                        ;才能获得了控制权了(Int 19h通过跳转指令交转控制权) 

;***第1扇区的数据到此为止****************************************** 
                 
;***以下是放在2、3扇区的内容,为程序主体部分************************                         
part2_3:        ;1扇区的结束和2扇区的开始 
        jmp near ptr set 
menu:db 'Please press 1~4 to choose an item: ',0 
         db '1) Reset PC                         ',0 
         db '2) Start System in Existence        ',0 
         db '3) Clock                            ',0 
         db '4) Set Clock                        ',0 
date:db 'yy/mm/dd hh:mm:ss',0 
port:db 9,8,7,4,2,0 
settime: 
        db 'Set Time(yy/mm/dd hh:mm:ss)',0 
spc4char:  
        db 18 dup(0);字符栈空间 
stak: db 128 dup(0) 
table dw reset_pc,start_sys,clock,set_clock;子程序入口直接定址表 

set: 
        mov ah,2;光标 
        mov bh,0 
        mov dx,1123h 
        int 10h 
         
        mov ax,cs 
        mov ds,ax 
        mov ss,ax 
        mov sp,offset table 
        mov dx,0A16h;10行22列 
        mov cx,5;5行 
        mov si,offset menu 
s: 
        call show_str 
        inc dh 
        add si,37;下一行,这就是为什么我每行都用空格补齐的原因 
        loop s;显示菜单 
        ;等待键盘输入 
waiting: 
        mov ah,0 
        int 16h 
        cmp al,'4' 
        ja waiting;大于4,继续等待 
        cmp al,'1' 
        jb waiting;小于1,也继续等待 
         
        sub al,49;al:0~3 
        mov bl,al 
        mov bh,0 
        add bx,bx;bx:0,2,4,6 
        call word ptr table[bx];召唤各式各样的子程序 
        jmp short waiting;专供clock和set_clock回来时使用的 
;****************************************************************** 

;***reset_pc---重启电脑******************************************** 
reset_pc: 
        mov ax,0FFFFh;CS 
        push ax 
        mov ax,0;IP 
        push ax 
        retf;跳到FFFF:0 
;***reset_pc---结束************************************************ 

;***start_sys---启动现有系统*************************************** 
start_sys: 
        mov ax,0201h 
        mov cx,0001h 
        mov dx,0080h;C盘0道0面1扇区,共读1扇区 
        mov bx,0 
        mov es,bx 
        mov bx,7c00h;写入0:7c00h 
        int 13h 
         
        mov ax,0;CS 
        push ax 
        mov ax,7c00h;IP 
        push ax 
        retf;跳到0:7c00 
;***start_sys---结束*********************************************** 

;***clock---时钟程序*********************************************** 
;进入程序后,一直动态显示当前时间;当按下F1时,改变显示颜色;按下Esc键时,返回主选单 
clock: 
        push ax 
        push cx 
        push dx 
        push si 
        push di 
        push es 
         
        mov ax,cs 
        mov ds,ax 
        mov cx,4;cx记录颜色 
s0: 
        push cx 
        mov si,offset date;利用date处空间存储日期时间字符串 
        mov di,offset port 
        mov cx,6 
s1: 
        mov al,ds:[di] 
        out 70h,al 
        in al,71h 
        mov ah,al 
        push cx;右移4位用到cx 
        mov cl,4 
        shr ah,cl 
        pop cx 
        and al,00001111b 
        add ax,3030h 
         
        mov ds:[si],ah 
        mov ds:[si+1],al 
        inc di 
        add si,3 
        loop s1 
         
        pop cx;cx仍是存储颜色 
        mov ax,0 
        in al,60h 
        cmp al,1;Esc的扫描码 
        je back 
        cmp al,3bh;F1的扫描码 
        jne nochange;不改变颜色 
        inc cl;改颜色 
nochange: 
        mov dx,101fh;16行31列 
        mov si,offset date 
        call show_str;显示时间 
        jmp short s0;循环显示 
         
back: 
        mov ax,0b800h 
        mov es,ax 
        mov si,160*16+2*31;16行31列消去时间显示,以便回到主菜单 
        mov cx,18 
s2: 
        mov byte ptr es:[si],' ';以空格清空之 
        mov byte ptr es:[si+1],00000111b;颜色也改过来,不然可能出现一块非黑色的区域 
        add si,2 
        loop s2 
         
        pop es 
        pop di 
        pop si 
        pop dx 
        pop cx 
        pop ax 
        ret 
;***clock---结束**************************************************** 

;***set_clock---设置时钟******************************************** 
set_clock: 
        mov ax,cs 
        mov ds,ax 
        mov si,offset settime 
        mov dx,101ah;16行26列 
        mov cl,000000100b 
        call show_str;显示提示信息 
         
        mov si,offset spc4char 
        mov dx,1123h;17行35列 
        call getstr;返回字符串在spc4char 
         
        ;将字符串转换成字节形式的日期,写入CMOS 
        mov di,offset port;ds:di指向CMOS端口号数组 
        mov cx,6;6次,年月日时分秒 
s3: 
        mov ah,ds:[si] 
        mov al,ds:[si+1] 
        sub ax,3030h;还原数字 
        push cx;左移用到cx 
        mov cl,4 
        shl ah,cl 
        pop cx 
        add ah,al;ah输出,al要用来访问CMOS 
        mov al,ds:[di] 
        out 70h,al 
        mov al,ah;输出结果 
        out 71h,al 
         
        inc di 
        add si,3 
        loop s3 
         
        ret         
;***set_clock---结束************************************************         
         
;***getstr---数字输入*********************************************         
;ds:si指向字符栈空间,只响应数字、冒号、斜杠、退格、回车输入，其余输入一律忽略 
getstr: 
        push di 
        push es 
        push si 
        mov di,0 
getstrs: 
        mov ah,2;光标跟随 
        mov bh,0 
        push dx 
        add dx,di 
        int 10h 
        pop dx 
         
        mov ah,0 
        int 16h 
        cmp di,17;输入够了禁止输入字符,免得溢出覆盖后面的数据 
        je nonumber 
        cmp al,':' 
        je number 
        cmp al,'/' 
        je number 
        cmp al,'0' 
        jb nonumber 
        cmp al,'9' 
        ja nonumber 
number: 
        mov bx,si 
        mov ds:[bx+di],al 
        inc di 
        mov cl,00000111b 
        call show_str 
        jmp short getstrs 

nonumber: 
        cmp ah,0Eh 
        je backspace 
        cmp ah,1ch 
        je getstr_ret 
        jmp short getstrs 
         
backspace: 
        cmp di,0;如果字符栈里已经没有字符了,按退格键时直接忽略 
        je getstrs 
         
        mov bx,0b800h 
        mov es,bx 
        dec di 
        mov bx,di 
        add bx,bx 
        mov es:[bx+2790],' ' 
         
        mov bx,si 
        mov ds:[bx+di],0 
        ;mov cl,00000111b 
        ;call show_str 
        jmp short getstrs 
         
getstr_ret: 
        ;擦掉屏幕上显示过的没用的内容 
        mov bx,0b800h 
        mov es,bx 
        mov si,160*16+2*26;16行26列消去提示 
        mov cx,27 
s4: 
        mov byte ptr es:[si],' ';以空格清空之 
        add si,2 
        loop s4 
        ;擦掉输入区 
        mov si,17*160+35*2;17行35列 
        mov cx,18 
s5: 
        mov byte ptr es:[si],' ' 
        add si,2 
        loop s5 
         
        pop si 
        pop es 
        pop di 
        ret 
;***getstr---结束*************************************************** 
         
;****子程序show_str开始********************************************* 
;功能:在指定位置指定颜色显示一个用0结束的字符串 
;参数:(dh)=行号(0~24),(dl)=列号(0~79),(cl)=RGB颜色,ds:si指向字符串首地址 
;返回:<无>         
show_str: 
        push ax        ;将用子程序到的寄存器入栈暂存 
        push bx 
        push cx 
        push dx 
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
        pop dx 
        pop cx 
        pop bx 
        pop ax 
        ret 
;****子程序show_str结束********************************************* 

part2_3_end: 
        nop 
;***第2、3扇区的数据到此为止**************************************** 
code ends 
end start