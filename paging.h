/**************************************************************************************************
 *
 * File: paging.h
 *
 * Copyright (c) 2003, 2004	Erik Dubbelboer
 *
 * Contents:	x86 Paging
 *
 *************************************************************************************************/

#ifndef _X86_PAGING_H_
#define _X86_PAGING_H_




//
// Paging flags for Page-Tables and Page-Directories.
//
#define X86_PAGE_PRESENT	(1<<0)	// set if page or page-table is present
#define X86_PAGE_WRITE		(1<<1)	// set to allow writing to the page or page-table
#define X86_PAGE_USER		(1<<2)	// set to make the page or page-table a user page or page-table
									// if this flag is cleared the page or page-table can only be accessed in supervisor mode
#define X86_PAGE_PWT		(1<<3)	// when the PWT flag is set, write-through caching is enabled for the
									// page or page-table; when the flag is clear, write-back caching is
									// enabled for the page or page-table.
									// This type of caching is useful for VGA framebuffers.
#define X86_PAGE_PCD		(1<<4)	// Page Cache Disable, set this flag to disable caching of the page or page-table
#define X86_PAGE_ACCESSED	(1<<5)	// the processor sets this flag the first time the page or page table is accessed
#define X86_PAGE_DIRTY		(1<<6)	// the processor sets this flag the first time a page is accessed for a write operation
									// this flag is only used in page-table entries and should not be set for page-directory entries
#define X86_PAGE_PAGESIZE	(1<<7)	// page size extension flag. (Set for enable)
#define X86_PAGE_GLOBAL	(1<<8)	// this flag is only used in page-table entries
									// when a page is marked global and the page global enable (PGE) flag in register
									// CR4 is set, the page-table or page-directory entry for the page is not invalidated
									// in the TLB when register CR3 is loaded
#define X86_PAGE_AVAIL1	(1<<9)	// Available for usage by the Kernel
#define X86_PAGE_AVAIL2	(1<<10)	// Available for usage by the Kernel
#define X86_PAGE_AVAIL3	(1<<11)	// Available for usage by the Kernel




#endif // _X86_PAGING_H_
