ORG 0x7C00	; The bios loads the bootloader at address 0x7C00
BITS 16		; Set number of bits to 16

main:
	XOR ax,ax	; xor operations: 0 if same object
	MOV ds,ax
	MOV es,ax
	MOV ss,ax

	MOV si,boot_msg	; si contains str msg

	MOV sp,0x7c00	; stack ptr = start address
	CALL print
	HLT 		; pauses cpu until it reaches (possible 32 bit) interrupt
	

print:
	PUSH si		; preserve si,ax,bx,registers by pushing onto stack
	PUSH ax
	PUSH bx

print_loop:
	LODSB		; load Single Byte; contains current character in the si register
	OR al,al	; check to see if the next charachter value is zero
	JZ done_print	; exit print loop if al is zero,meaning we reached the string null terminator
	
	MOV ah,0x0E	; BIOS teletype function : print character to screen
	MOV bh,0	; page number argument for which monitor you're writing to
	INT 0x10	; video interrup (looks at ah & bh to determine what to do)
	JMP print_loop

done_print:
	POP bx
	POP ax
	POP si
	RET
halt:
	JMP halt	; in case hlt interrupt is reached we go to halt label & loop there for now

boot_msg DB "Hello World",0x0D,0x0A,0 

TIMES 510-($-$$) DB 0	; we define zero up to 510 bytes, minus the byte size required to hold this code
DW 0AA55h		; we define the boot handler in the last 2 bytes of the sector


