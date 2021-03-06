;; FILE: crt0.s
;; Generic crt0.s for a Z80
;; From SDCC..
;; Modified to suit execution on the Amstrad CPC!
;; by H. Hansen 2003
;; Original lines has been marked out!
;; Updated to SDCC v3.3.0 by Mochilote in 2013 (Fixed initialization of global variables)
;; changed to fit the settings for this project in 2014 by Octoate (start address will be determined by --code-loc compiler option)

	.module crt0
	.globl	_main

	jp	init
	.ascii "(c)2014 Octoate"

init:

;; Stack at the top of memory.
;;	ld	sp,#0xffff        
;;	I will use the Basic stack, so the program can return to basic!

;; Initialise global variables
	call    gsinit
	call	_main
	jp	_exit

	;; Ordering of segments for the linker.
	.area	_HOME
	.area	_CODE
	.area	_INITIALIZER
	.area   _GSINIT
	.area   _GSFINAL

	.area	_DATA
	.area	_INITIALIZED
	.area	_BSEG
	.area   _BSS
	.area   _HEAP

	.area   _CODE
__clock::
	ret
	
_exit::
	ret
	
	.area   _GSINIT
gsinit::
	ld	bc, #l__INITIALIZER
	ld	a, b
	or	a, c
	jr	Z, gsinit_next
	ld	de, #s__INITIALIZED
	ld	hl, #s__INITIALIZER
	ldir
gsinit_next:

	.area   _GSFINAL
	ret

