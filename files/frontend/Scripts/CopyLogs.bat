@echo off
xcopy /y "C:\tools\MBIS\Logs\." "\\sbits-psi-uns01\shared\user_logs\%USERNAME%\*"
xcopy /y "C:\ProgramData\Morphotrak\Bis\log\." "\\sbits-psi-uns01\shared\user_logs\%USERNAME%\*"