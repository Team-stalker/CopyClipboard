format PE GUI 4.0
entry main
 
include 'win32ax.inc'

       xor ebx, ebx

;***************************************************************************************************************
section '.data' data readable writeable

       String db 'XRAY PROJECT - COPY CLIPBOARD TEXT',0

section '.code' code readable executable
 
proc main
       stdcall Clipboard,String,NULL
       invoke  MessageBox,NULL,String,'test',MB_OK
.exit:
       xor eax, eax
       invoke  ExitProcess, 0
endp
;***************************************************************************************************************

;***************************************************************************************************************
proc Clipboard, pStrAddr, pSize
       push    ebx ecx edx esi edi
       mov     ebx, [pStrAddr]
       invoke  OpenClipboard,0
       or      eax, eax
       jz      .copy_buff_bag
       stdcall _lstrlen,[pStrAddr]
       or      eax, eax
       je      .copy_buff_close
       inc     eax
       mov     [pSize], eax
       invoke  EmptyClipboard
       invoke  GlobalAlloc,GMEM_MOVEABLE+GMEM_DDESHARE,[pSize]
       mov     ebx,eax
       invoke  GlobalLock,ebx
       mov     esi,[pStrAddr]
       mov     edi,eax
       mov     ecx,[pSize]
       repnz   movsb
       invoke  GlobalUnlock,ebx
       invoke  SetClipboardData,CF_TEXT,ebx
       invoke  GlobalFree,ebx
.copy_buff_close:
       invoke  CloseClipboard
.copy_buff_ok:
       xor  eax, eax
       jmp  .copy_buff_ret
.copy_buff_bag:
       mov  eax, 1
.copy_buff_ret:
       pop  edi esi edx ecx ebx
       ret
endp
;***************************************************************************************************************

;***************************************************************************************************************
proc _lstrlen,lpStr:dword
       push ebx ecx edx esi edi
       mov  eax,[lpStr]
       xor  ecx, ecx
       dec  eax
       dec  ecx
.lstrlen_loop:
       inc  eax
       inc  ecx
       cmp  ecx, 0x100
       ja   .lstrlen_end
       cmp  byte [eax],0
       jne  .lstrlen_loop
       sub  eax,[lpStr]
       jmp  .lstrlen_ret
.lstrlen_end:
       xor  eax, eax
.lstrlen_ret:
       pop  edi esi edx ecx ebx
       ret
endp
;***************************************************************************************************************

;***************************************************************************************************************
section '.idata' import data readable writeable

     library kernel32,'KERNEL32.DLL',\
          user32,'user32.dll'

     include 'api/kernel32.inc'
     include 'api/user32.inc'

;***************************************************************************************************************