/**************************************************************************************************
 *
 * File: paging.c
 *
 * Copyright (c) 2003, 2004	Erik Dubbelboer
 *
 * Contents:	paging functions.
 *
 *************************************************************************************************/

#include "kernel.h"
#include "paging.h"




/**
 * Set up the Boot Page-Directory and Tables, and enable Paging.
 *
 * This function is executed at the physicallKernel address.
 * Therefore it can not use global variables or switch() statements.
 **/
void paging_init(void)
{
	uint index;
	uint loop;
	uint* table;


	//
	// Boot Page-Directory
	//
	uint* dir = (uint*)0x124000;
	index = 0;

	// The 1e Page-Table.
	dir[index++] = 0x125000 | X86_PAGE_PRESENT | X86_PAGE_WRITE;

	// The rest of the tables till 3GB are not present.
	for (loop = 0; loop < 768 - 1; loop++)
		dir[index++] = 0; // Not present.

	// The 2e Page-Table.
	dir[index++] = 0x126000 | X86_PAGE_PRESENT | X86_PAGE_WRITE;

	// The rest of the tables is not present.
	for (loop = 0; loop < 256 - 1; loop++)
		dir[index++] = 0;


	//
	// Page-Table 1.
	//
	table = (uint*)0x125000;
	index = 0;

	// Map the First 2MB (512 Pages)
	for (loop = 0; loop < 512; loop++)
		table[index++] = (PAGE_SIZE * loop) | X86_PAGE_PRESENT | X86_PAGE_WRITE;

	// The rest is not present.
	for (loop = 0; loop < 512; loop++)
		table[index++] = 0;


	//
	// Page-Table 2.
	//
	table = (uint*)0x126000;
	index = 0;

	// Map the First 2MB (512 Pages)
	for (loop = 0; loop < 512; loop++)
		table[index++] = (PAGE_SIZE * loop) | X86_PAGE_PRESENT | X86_PAGE_WRITE;

	// The rest is not present.
	for (loop = 0; loop < 512; loop++)
		table[index++] = 0;


	// load cr3 (Page-Directory Base Register) with the Page-Directory we are going to use,
	// which is the Page-Directory from the Kernel process.
	set_cr3((uint)dir);


	//
	// Enable paging.
	//
	set_cr0(get_cr0() | 0x80000000); // Set the paging bit.
}
