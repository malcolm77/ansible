command = "powershell.exe -nologo -ExecutionPolicy Unrestricted -command C:\tools\Scripts\CopyLogs.bat"
 set shell = CreateObject("WScript.Shell")
 shell.Run command,0