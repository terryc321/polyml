#!/bin/bash

# this is all from (https://www.polyml.org/documentation/Tutorials/CInterface.html)

gcc -c sample.c -o sample.o
ld -o sample.so sample.o -fPIC -shared 

