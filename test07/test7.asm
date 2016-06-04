assume cs:codesg,ds:data,es:table 

data segment 
        db '1975','1976','1977','1978','1979','1980','1981','1982','1983' 
        db '1984','1985','1986','1987','1988','1989','1990','1991','1992' 
        db '1993','1994','1995' 
        ;以上是表示21年的21个字符串 

        dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514 
        dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000 
        ;以上是表示21年公司总收的21个dword型数据 

        dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226 
        dw 11542,14430,45257,17800 
        ;以上是表示21年公司雇员人数的21个word型数据 
data ends 

table segment 
        db 21 dup('year summ ne ?? ') 
table ends 

codesg segment 
        start: 
        mov ax,data 
        mov ds,ax 
        mov ax,table 
        mov es,ax 
        mov si,0 
        mov bx,0 
        mov bp,0 
        mov cx,21 
        s: 
        mov ax,ds:[bx] 
        mov es:[bp],ax 
        mov ax,ds:[bx+2] 
        mov es:[bp+2],ax 
        mov ax,[bx+84]       
    mov dx,[bx+86]     
    mov es:[bp+5],ax     
    mov es:[bp+7],dx  
    div word ptr [si+168]  
    mov dx,[si+168]        
    mov es:[bp+10],dx   
    mov es:[bp+13],ax     
    add bp,16         
    add bx,4  
    add si,2  
    loop s 
    mov ax,4c00h  
    int 21h 
codesg ends 
end start 
