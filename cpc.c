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
unsigned char GetChar_CPC()
{
  __asm
    LD HL, #_nGetChar
    LD (HL), #0
    CALL #0xBB09 ;KM READ CHAR
    JP NC, _end_getchar
    LD (HL), A
    _end_getchar:
  __endasm;
  
  return nGetChar;
}