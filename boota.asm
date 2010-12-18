;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; File: boota.asm
;
; Copyright (c) 2003, 2004	Erik Dubbelboer

; Contents:	Kernel entry point.
;		Multiboot Header.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[SECTION .text]
[BITS 32]




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; boot_entry (called from GRUB)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[extern _paging_init]
[extern _boot_main]

[global boot_entry] ; needs to be global for the linker
boot_entry:
	mov	esp, 0x120000		; switch to the Boot Stack.
					; push the arguments for _boot_main on the stack
					; because _paging_init may destroy eax and ebx.
	push	ebx			; save the pointer to the Multiboot information.
	push	eax			; should be 0x2BADB002 (checked in _boot_main).
	cld				; C code may assume this.
	call	_paging_init
	add	esp, 0xC0000000		; Switch to the virtual address of the stack.
	mov	eax, _boot_main
	call	eax			; This will assemble in to a absolute jump
					; which is needed to jump to the virtual Kernel address.




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Multiboot header
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; put the multiboot header in the .text section so the bootloader can't find it easely.
; the multiboot header must be aligned at 4 bytes
; else the bootloader can't find it
align 4, db 0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Definitions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MULTIBOOT_PAGE_ALIGN		equ 1<<0 ; All boot modules loaded along with the operating system must be aligned on page (4KB) boundaries.
MULTIBOOT_MEMORY_INFO		equ 1<<1 ; Let the bootloader fill in the mem_ fields.
MULTIBOOT_AOUT_KLUDGE		equ 1<<16
MULTIBOOT_HEADER_MAGIC		equ 0x1BADB002
MULTIBOOT_HEADER_FLAGS		equ MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_AOUT_KLUDGE
MULTIBOOT_HEADER_CHECKSUM	equ -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Header
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
[global multibootheader]
multibootheader:
	dd MULTIBOOT_HEADER_MAGIC
	dd MULTIBOOT_HEADER_FLAGS
	dd MULTIBOOT_HEADER_CHECKSUM

[extern _link_textstart]
[extern _link_dataend]
[extern _link_bssend]

	; AOUT kludge
	dd _link_textstart + (multibootheader - boot_entry) ; point to the multiboot header
	dd _link_textstart ; start of kernel .text (code) section
	dd _link_dataend ; end of kernel .data section
	dd _link_bssend ; end of kernel .bss
	dd _link_textstart ; kernel entry point (initial EIP)




[SECTION .data]

dd	'DATA'
; there needs to be something in the .data section
; else _link_dataend can point to a location beyond the file
; and the bootloader will say that it is an unsupported executable format
