@echo off
echo.

:: provide path to Intel Fortran bin directory
:: (update this according to the specific installation on your local machine)
set "pathIF=C:\Program Files (x86)\Intel\Compiler\11.1\048\bin" 

echo Initializing amd64 (intel64) instruction set:
echo =============================================
call "%pathIF%\ifortvars.bat" intel64

echo.
echo Running 'OneBayFrame_Imp.inp' Abaqus Model:
echo ===========================================
call abaqus job=onebayframe_imp user=genericclient_imp.obj interactive

goto :eof
