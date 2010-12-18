###################################################################################################
#
# File: Makefile
#
# Contents from Eppix
# Copyright (c) 2003, 2004	Erik Dubbelboer
#
# - dependencies are alwais generated, also with clear.
#
###################################################################################################



# Because this is the first target in the Makefile it will be build
# when you execute make withoud a specefied target
all: main



###################################################################################################
#
# Definitions
#
###################################################################################################
LD		= ld
CC		= gcc
CPP		= gpp
ASM		= nasm
HC		= ghc

# Flags
LDFLAGS		= -nostdlib
CFLAGS		= -Wall -Winline -O3 -fno-keep-inline-functions -fomit-frame-pointer -fstrength-reduce \
		-ffreestanding -fno-exceptions -nostdinc -D $(ARCH)
CPPFLAGS	= -Wall -Winline -O3 -fno-keep-inline-functions -fomit-frame-pointer -fstrength-reduce \
		-fno-rtti -fno-exceptions -nostdinc -D $(ARCH)
ASMFLAGS	= -f coff -D $(ARCH)
HCFLAGS		= -fglasgow-exts $(EXTRA_HC_OPTS)




###################################################################################################
#
# Configuration
#
###################################################################################################

#Architecture
ARCH		= x86




###################################################################################################
# Object files to build
###################################################################################################
OBJECTS = boota.o boot.o paging.o



###################################################################################################
# external objects to link to in final product
###################################################################################################
EXTERNS = 



###################################################################################################
# Directory for object files
###################################################################################################
OBJECTSDIR = objects/


###################################################################################################
# Directory for dependencies files
###################################################################################################
DEPSDIR = depends/



###################################################################################################
#
# Rule for making .hs files (Haskell)
#
###################################################################################################
# compile
$(OBJECTSDIR)%.o: %.hs
	$(HC) $(HCFLAGS) -c $(OBJECTSDIR)$*.o -odir $(OBJECTSDIR) -hidir $(OBJECTSDIR) $*.hs

# dependencies
$(DEPSDIR)%.d: %.hs
	$(HC) $(HCFLAGS) -odir $(OBJECTSDIR) -hidir $(OBJECTSDIR) -M -optdep-f -optdep$(DEPSDIR)$*.d $*.hs



###################################################################################################
#
# Rule for making .asm files
#
###################################################################################################
# compile
$(OBJECTSDIR)%.o: %.asm
	$(ASM) $(ASMFLAGS) -o $(OBJECTSDIR)$*.o $*.asm

# dependencies
$(DEPSDIR)%.d: %.asm
	$(ASM) $(ASMFLAGS) -M -o $(OBJECTSDIR)$*.o $*.asm > $(DEPSDIR)$*.d



###################################################################################################
#
# Rule for making .c files
#
###################################################################################################
# compile
$(OBJECTSDIR)%.o: %.c
	$(CC) $(CFLAGS) -c -o $(OBJECTSDIR)$*.o $*.c

# dependencies
$(DEPSDIR)%.d: %.c
	$(CC) $(CFLAGS) -MT $(OBJECTSDIR)$*.o -M $*.c > $(DEPSDIR)$*.d



###################################################################################################
#
# Rule for making .cpp files
#
###################################################################################################
# compile
$(OBJECTSDIR)%.o: %.cpp
	$(CPP) $(CPPFLAGS) -c -o $(OBJECTSDIR)$*.o $*.cpp

# dependencies
$(DEPSDIR)%.d: %.cpp
	$(CPP) $(CPPFLAGS) -MT $(OBJECTSDIR)$*.o -M $*.cpp > $(DEPSDIR)$*.d




###################################################################################################
#
# Main target
#
###################################################################################################
main:	$(addprefix $(OBJECTSDIR), $(OBJECTS))
	@echo -
	@echo *******************************************************************************
	@echo ** Linking...
	@echo ********************************************************************************
	$(LD) -o kernel -T link.ld $(LDFLAGS) $(addprefix $(OBJECTSDIR), $(OBJECTS)) $(EXTERNS)
	@echo -
	@echo *******************************************************************************
	@echo ** Build Finished.
	@echo ********************************************************************************




###################################################################################################
#
# Clear targets
#
# del only accepts the windows slash \
###################################################################################################
win_clear:
	del $(OBJECTSDIR:/=\)*.o
	del $(DEPSDIR:/=\)*.d
	del kernel

lin_clear:
	rm $(OBJECTSDIR)*.o
	rm $(DEPSDIR)*.d
	rm kernel


###################################################################################################
#
# Include Dependencies
#
###################################################################################################
-include $(addprefix $(DEPSDIR), $(OBJECTS:.o=.d))
