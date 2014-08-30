/*
 * cpc.h - contains Amstrad CPC specific code / routines
 */
#ifndef cpc_H
#define cpc_H
 
unsigned char GetRandom_CPC(void);
unsigned char GetChar_CPC(void);
void PutSpriteMode0(unsigned char *pSprite, unsigned char nX, unsigned char nY, unsigned char nWidth, unsigned char nHeight);
void SetBorder_CPC(unsigned char colourIndex);
void SetColour_CPC(unsigned char colourIndex, unsigned char paletteIndex);
void SetPaletteMode0_CPC(const unsigned char *pPalette);
void SetMode_CPC(unsigned char graphicsMode);

#endif // cpc_H