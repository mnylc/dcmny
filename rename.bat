@echo off
for %%a in (*.jpg*) do (
	if %%~a NEQ %0 (
		md "%%~na" 2>nul
		move "%%a" "%%~na\OBJ.jpg"
	)
)
for %%a in (*.xml*) do (
	move "%%a" "%%~na\MODS.xml"
	)