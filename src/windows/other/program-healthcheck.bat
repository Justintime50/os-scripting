:main
    :: Run healthcheck every 60 seconds
    :: TODO: For better performance, don't use this timed loop - setup a scheduled task instead
    @echo off
    timeout /t 60
    GOTO program_healthcheck
EXIT /B 0

:program_healthcheck
    :: Checks if a program is running and restarts it if not
    :: TODO: Don't print the output of finstr -> tasklist to console
    TASKLIST | FINDSTR "chrome" && echo Chrome's healthcheck passed || START "" "C:\Program Files\Google\Chrome\Application\chrome.exe" && echo Chrome's healthcheck failed, restarting...
    GOTO main
EXIT /B 0

call main
