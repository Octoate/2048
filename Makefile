#
# 2048 game port for the Amstrad CPC
#
# written 2014 by Octoate
#

# compiler options
CFLAGS = -mz80

PROJECTNAME = 2048
DSKIMAGENAME = $(PROJECTNAME).dsk

# folder which contains the game resources (e.g. graphics, loader, etc.)
RESOURCES = ./resources

# path to the tools in the tools directory
TOOLS_DIR = ./tools
HEX2BIN = $(TOOLS_DIR)/hex2bin/hex2bin
CPCDISKXP = $(TOOLS_DIR)/CPCDiskXP/CPCDiskXP
HXCFE = $(TOOLS_DIR)/HxCFloppyEmulator/hxcfe

all: $(PROJECTNAME)

.PHONY: clean
clean:
	@echo ""
	@echo "==================== Cleaning... ===================="
	rm -f *.rel
	rm -f *.dsk
	rm -f *.map
	rm -f *.sym
	rm -f *.ihx
	rm -f *.lk
	rm -f *.lst
	rm -f *.noi
	rm -f *.bin
	rm -f *.hfe
	rm -f *.bas
	rm -f board.asm
	rm -f main.asm
	rm -f cpc.asm

#
# defines all necessary files for the project
# NOTE: 1) create DSK image
#		2) add resources
#		3) add compiled binaries
#		4) convert to HxC floppy emulator image
# 
# TODO: define a target for a release and a debug build
#
$(PROJECTNAME): $(PROJECTNAME).dsk resources 2048.bin $(PROJECTNAME).hfe
	
#
# defines the DSK image to create and the files, which should be included into the DSK image
#
# NOTE: all resources will be automatically injected from the 'resources' directory
#
resources: loader.bas

#
# defines the start address of the file and the depending files
#
2048.bin: START=0x4000
2048.bin: crt0_cpc.rel putchar_cpc.rel sprites.rel cpc.rel board.rel main.rel

#
# define the target for the different assembly files, otherwise the
# search pattern below would executed
#
# NOTE: at least the 'putchar' can be included in the C code -> do that!
#
crt0_cpc.rel:
	@echo ""
	@echo "==================== Assemble CRT0 ===================="
	sdasz80 -go crt0_cpc.s

putchar_cpc.rel:
	@echo ""
	@echo "==================== Assemble putchar ===================="
	sdasz80 -go putchar_cpc.s

#
# creates an empty disk image and fills it with the files, listed in the target
#
%.dsk:
	@echo ""
	@echo "==================== Create an empty data disc image... ===================="
	cp $(RESOURCES)/empty_data_disc.dsk $@		# use the empty data disk from the tools directory
	
#
# compile the files with sdcc
#
%.rel: %.c
	@echo ""
	@echo "==================== Compile target '$@'... ===================="
	sdcc $(CFLAGS) -c $<
	
#
# link the files, convert them via hex2bin to a binary file and add them to the DSK image
#
# NOTE: this will automatically add an AMSDOS with the address defined by the 'START' variable
#
%.bin:
	@echo ""
	@echo "==================== Linking '$@'... ===================="
	sdcc --code-loc $(START) -mz80 --no-std-crt0 $(CFLAGS) -o $*.ihx $^
	$(HEX2BIN) $*.ihx
	$(CPCDISKXP) -AddAmsdosHeader $(START) -AddToExistingDsk $(DSKIMAGENAME) -File $@

#
# 'BASIC' files... just add them to the DSK image -> without an header, they already contain it
#
# NOTE: the 'BASIC' files need to be already in binary format. You can e.g. save them in an emulator and
# 		extract them to the resources folder to use them here
#
%.bas:
	@echo ""
	@echo "==================== Inserting '$@' into the DSK image ===================="
	cp $(RESOURCES)/$@ .	# workaround: unfortunately CPCDiskXP seems to be unable to use path information :-(
	$(CPCDISKXP) -AddToExistingDsk $(DSKIMAGENAME) -File $@
	rm -rf $@				# workaround: unfortunately CPCDiskXP seems to be unable to use path information :-(
	
#
# convert any disc image to a hfe HxC floppy emulator image
#
%.hfe: %.dsk
	@echo ""
	@echo "==================== convert '$<' to HFE disc image ===================="
	$(HXCFE) -conv:HXC_HFE -finput:$<
