/**************************************************************************************************
 *
 * File: boot.c
 *
 * Copyright (c) 2003, 2004	Erik Dubbelboer
 *
 * Contents:	boot_main
 *
 *************************************************************************************************/

#include "kernel.h"
#include "multiboot.h"




/** From: "paging.c" **/
void paging_init(void);




/**
 * will print the specified message to line 11.
 *
 * @param msg The null-terminated message string.
 **/
void very_simple_print(const char* msg)
{
	char* vid = (char*)(0xC00B8000 + 11 * 160);

	while (*msg != 0)
	{
		*vid++ = *msg++;
		*vid++ = 7;
	}
}





/**
 * First C function executed at the virtual Kernel address.
 **/
void boot_main(uint badboot, multiboot_header_t* header)
{
	if (badboot != 0x2BADB002)
	{
		// The Kernel isn't loaded by a Multiboot Compatible Bootloader.
		very_simple_print("We are not booted by GRUB!");
		halt();
	}


	very_simple_print("Boot successful!");
	halt();
}
