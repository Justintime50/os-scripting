:: Installs dependencies and the Devvm
:main
    @echo off
    
    echo Installing dependencies...
    call :install_dependencies
    echo Dependencies installed!

    call :setup_vagrant
    echo Devvm now running! Use "vagrant ssh" to connect.
EXIT /B 0

:install_dependencies
    choco install vagrant
    choco install virtualbox
EXIT /B 0

:setup_vagrant
    cd src
    vagrant up
EXIT /B 0

main
