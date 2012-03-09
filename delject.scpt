-- AS to delete hidden files and eject volume
property volumeLabel : ""

set rootDir to "/Volumes"
set fileSelector to "/.??*" -- question marks needed to not match "." and ".." selectors 

tell application "Finder"
	-- check if volumeLabel exists
	set volumeExists to do shell script "if [ -d \"" & rootDir & "/" & volumeLabel & "\" ]; then echo 1; fi"
	if volumeLabel is "" or volumeExists is "" then
		set volumeLabel to name of (choose folder default location rootDir with prompt "Choose Disk")
	end if
	
	-- get files to delete
	set allFiles to do shell script "ls -d " & rootDir & "/" & quoted form of volumeLabel & fileSelector & " || echo ''"
	
	if allFiles is not "" then
		-- confirm delete
		if button returned of (display dialog "Delete those files on " & volumeLabel & "?
		
" & allFiles buttons {"No", "Yes"} default button "No") is "Yes" then
			-- delete
			do shell script "rm -rf " & rootDir & "/" & quoted form of volumeLabel & fileSelector
		end if
	end if
	
	eject volumeLabel
end tell
