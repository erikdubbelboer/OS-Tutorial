OUTPUT_FORMAT("binary")
ENTRY(boot_entry)

_link_physical_address =  0x100000; /* 1MB */
_link_virtual_address = 0xC0100000; /* 4GB + 1MB */

SECTIONS
{
	_link_textstart = _link_physical_address;
	.text _link_virtual_address :
	{
		*(.text)
	}
	_link_textend = (. - _link_virtual_address) + _link_physical_address;

	.data . :
	{
		*(.data)
	}
	_link_dataend = (. - _link_virtual_address) + _link_physical_address;

	.bss . :
	{
		*(.bss)
		*(COMMON)
	}
	_link_bssend = (. - _link_virtual_address) + _link_physical_address;
}
