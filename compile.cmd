@echo ==================== compile crt0 ====================
sdasz80 -go crt0_cpc.s

@echo ==================== compile assembly files ====================
sdasz80 -o putchar_cpc.s
sdasz80 -o random_cpc.s

@echo ==================== compile C files ====================
rem sdcc -mz80 -c board.c
sdcc --no-std-crt0 -mz80 --code-loc 0x4100 --data-loc 0 -mz80 -c main.c

@echo ==================== link object files ====================
sdcc --no-std-crt0 -mz80 --code-loc 0x4100 --data-loc 0 -mz80 -o 2048.ihx crt0_cpc.rel putchar_cpc.rel random_cpc.rel main.rel

@echo ==================== convert intel hex to binary ====================
.\tools\hex2bin\hex2bin 2048.ihx

@echo ==================== create DSK image ====================
xcopy /Y .\tools\empty_data_disc.dsk 2048.dsk
.\tools\CPCDiskXP\CPCDiskXP -File 2048.bin -AddAmsdosHeader 4000 -AddToExistingDsk 2048.dsk
.\tools\CPCDiskXP\CPCDiskXP -File .\tools\loader.bas -AddToExistingDsk 2048.dsk

rem pause
