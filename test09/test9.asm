assume cs:code,ds:data  

data segment  
    db 'welcome to masm!'  
data ends  

code segment  
    start:mov ax,data  
    mov ds,ax  
    mov ax,0B800h  
    mov es,ax  
    mov bx,0  
    mov bp,720h     正是第12行第33列  
    mov cx,16  
    s:mov al,ds:[bx]  
    mov es:[bp],al  
    mov es:[bp+160],al  
    mov es:[bp+320],al  
    mov al,10b  
    mov es:[bp+1],al  
    mov al,100100b  
    mov es:[bp+161],al  
    mov al,1110001b  
    mov es:[bp+321],al  
    inc bx  
    add bp,2  
    loop s  
    mov ax,4c00h  
    int 21h  
code ends  
end start  
