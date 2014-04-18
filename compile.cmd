@echo.
@echo ==================== compile crt0 ====================
sdasz80 -go crt0_cpc.s

@echo.
@echo ==================== compile assembly files ====================
sdasz80 -o putchar_cpc.s

@echo.
@echo ==================== compile C files ====================
sdcc -mz80 -c cpc.c
sdcc -mz80 -c board.c
sdcc -mz80 -mz80 -c main.c

@echo.
@echo ==================== link object files ====================
sdcc --code-loc 0x4000 -mz80 --no-std-crt0 -mz80 -o 2048.ihx crt0_cpc.rel putchar_cpc.rel cpc.rel board.rel main.rel

@echo.
@echo ==================== convert intel hex to binary ====================
.\tools\hex2bin\hex2bin 2048.ihx

@echo.
@echo ==================== create DSK image ====================
del 2048.dsk
xcopy .\tools\empty_data_disc.dsk
ren empty_data_disc.dsk 2048.dsk
.\tools\CPCDiskXP\CPCDiskXP -File 2048.bin -AddAmsdosHeader 4000 -AddToExistingDsk 2048.dsk
.\tools\CPCDiskXP\CPCDiskXP -File .\tools\loader.bas -AddToExistingDsk 2048.dsk

@echo.
@echo ==================== convert to HFE disc image ====================
.\tools\HxCFloppyEmulator\hxcfe.exe -conv:HXC_HFE -finput:2048.dsk

rem pause
