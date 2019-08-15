#!/bin/bash

sudo sysadminctl -addUser <new user> -password <password> -fullName "Real Name Here" -admin # creates an admin account. Replace <user> and <password> with desired values. For a standard account, remove "-admin"
sysadminctl -adminUser <current user> -adminPassword - -secureTokenOn admin -password <password> # enables Secure Token required to unlock FileVault Disks in 10.13+