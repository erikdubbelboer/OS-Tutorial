/**************************************************************************************************
 *
 * File: multiboot.h
 *
 * Copyright (c) 2003, 2004	Erik Dubbelboer
 *
 * Contents:	Multiboot constants and structures.
 *
 *************************************************************************************************/

#ifndef _MULTIBOOT_H_
#define _MULTIBOOT_H_




/** See: the comments in the multiboot_header_s structure **/
#define MULTIBOOT_FLAG_MEM		(1<<0)
#define MULTIBOOT_FLAG_BOOT		(1<<1)
#define MULTIBOOT_FLAG_CMD		(1<<2)
#define MULTIBOOT_FLAG_MOD		(1<<3)
#define MULTIBOOT_FLAG_AOUT		(1<<4)
// (1<<5) isn't used in Eppix, because Eppix uses the aout kludge
#define MULTIBOOT_FLAG_MMAP		(1<<6)




// Set structure alignment to 1 byte boundary.
#pragma pack (push, 1)




// The symbol table for the a.out format
typedef struct multiboot_aout_s
{
	ulong tabsize;
	ulong strsize;
	ulong addr;
	ulong reserved;
	
} multiboot_aout_t;



// The Module structure
typedef struct multiboot_mod_s
{
	void*	mod_start;	// starting address of the module
	void*	mod_end;	// ending address of the module
	char*	string;		// arguments for the module
	ulong	reserved;	// 0

} multiboot_mod_t;



// The memory map. Be careful that the offset 0 is base_addr_low but no size
typedef struct multiboot_memory_map_s
{
	ulong size;				// offset to the next structure
	ulong base_addr_low;
	ulong base_addr_high;
	ulong length_low;
	ulong length_high;
	ulong type;				//  1 is free ram, other is reserved

} multiboot_memory_map_t;



// The Multiboot information
typedef struct multiboot_header_s
{
	ulong			flags;			// this will always be set
									//										a variable is valid if the flag is set
									//										--------------------------------------
	ulong			mem_lower;		// KB of conventional memory			MULTIBOOT_FLAG_MEM
	ulong			mem_upper;		// KB of extended memory				MULTIBOOT_FLAG_MEM

	ubyte			boot_device[4]; // +---3---+---2---+---1---+---0---+	MULTIBOOT_FLAG_BOOT
									// | drive | part1 | part2 | part3 |
									// +-------+-------+-------+-------+
	
	char*			cmdline;		// arguments for the kernel				MULTIBOOT_FLAG_CMD

	ulong			mods_count;		// number of modules loaded				MULTIBOOT_FLAG_MOD
	multiboot_mod_t* mods;			// pointer to the first multiboot_mod_s MULTIBOOT_FLAG_MOD
	
	multiboot_aout_t aout_sym;		//										MULTIBOOT_FLAG_AOUT
	
	ulong			mmap_length;	// memory map size						MULTIBOOT_FLAG_MMAP
	multiboot_memory_map_t*	mmap;	// memory map address (memory_map_s)	MULTIBOOT_FLAG_MMAP

} multiboot_header_t;




// Restore default structure alignment.
#pragma pack (pop)




#endif // _MULTIBOOT_H_
