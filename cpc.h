/*
 * cpc.h - contains Amstrad CPC specific code / routines
 */
#ifndef cpc_H
#define cpc_H
 
unsigned char GetRandom_CPC(void);
unsigned char GetChar_CPC(void);
void SetBorder_CPC(unsigned char colourIndex);
void SetColour_CPC(unsigned char colourIndex, unsigned char paletteIndex);
void SetMode_CPC(unsigned char graphicsMode);

#endif // cpc_H