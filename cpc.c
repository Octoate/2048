unsigned char nPreviousValue = 0xFF;
unsigned char GetRandom_CPC(void)
{
	__asm
		LD A,(#_nPreviousValue)
		LD L,A
		LD A,R
		ADD L
		LD (#_nPreviousValue),A
	__endasm;
	
	return nPreviousValue;
}
	
unsigned char nGetChar;
unsigned char GetChar_CPC(void)
{
	__asm
		LD HL, #_nGetChar
		LD (HL), #0
		CALL 0xBB06 ;KM WAIT CHAR
		JP NC, _end_getchar
		LD (HL), A
		_end_getchar:
	__endasm;
  
  return nGetChar;
}

void SetBorder_CPC(unsigned char colourIndex)
{
	colourIndex;
	__asm
		LD HL,#2
		ADD HL,SP
		LD b,(HL)
		ld c,b
		call 0xBC38	;SCR SET BORDER
	__endasm;
}

void SetColour_CPC(unsigned char colourIndex, unsigned char paletteIndex)
{
	colourIndex;
	paletteIndex;
	__asm
		LD HL,#2
		ADD HL,SP
		LD A,(HL)
		INC HL
		LD B,(HL)
		LD C,B
		CALL 0xBC32	;SCR SET INK
	__endasm;
}

void SetMode_CPC(unsigned char graphicsMode)
{
	graphicsMode;
	__asm
		LD HL,#2
		ADD HL,SP
		LD a,(HL)
		CALL 0xBC0E ;SCR_SET_MODE
	__endasm;
}