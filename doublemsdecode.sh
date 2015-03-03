#!/bin/bash

# Double M/S surround mix script. based off Farina Profile

#Centre Channel
sox -S -v 0.375 Front_Mid.wav -c 1 C.wav
#Left Channel
sox -S -m -v 0.5 Front_Mid.wav -v 0.5 Side.wav -c 1 L.wav
sox -S -m -v 0.5 Front_Mid.wav -v -0.5 Side.wav -c 1 R.wav
