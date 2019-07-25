#!/bin/bash

# replace "adminuser" with the user you want to force the password reset on

pwpolicy -a adminuser -u usertoforcechange -setpolicy "newPasswordRequired=1"