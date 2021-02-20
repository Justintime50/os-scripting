#!/bin/bash

brew cleanup
yes | docker system prune
rm -rf "$HOME"/Downloads
