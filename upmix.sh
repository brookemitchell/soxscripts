#!/bin/bash

# This script converts a Stereo file into a 5.1 surround file vaguely along the guidelines for the profiles given at the doom9 forum here:
# http://forum.doom9.org/archive/index.php/t-134017.html.
# As well as trying a few 'improvements'

# Check correct commands given
if [ $# -lt 1 ]; then
  echo -e "Usage: $0 infile -upmixProfile\n\t\t\t Profile Options: -Farina -Multisonic -Grezen -SOS(Default)"
  exit 1


# Sound on Sound Profile (DEFAULT)
# sorry I know this is the woring way to do a conditional just dont know syntax very well
elif [ $2 == "-SOS" ] || [ $# -lt 2 ] ; then
  #Give usage
  echo -e "Usage: $0 infile -upmixProfile\n\t\t\t Profile Options: -Farina -Multisonic -Grezen -SOS(Default)"
  # split left/right channel turn down
  sox -S "$1" -c 1 L.wav mixer -l gain -6
  sox -S "$1" -c 1 R.wav mixer -r gain -6
  # centre simple mono mixdown of both (halved)
  sox -S "$1" C.wav mixer 0.25,0.25 channels 1
  # lowpass signal below 120, mono mix
  sox -S -v -0.5 "$1" -c 1 LFE.wav lowpass 120 remix 1-2
  # 20ms delay and extra filtering on surrounds, trying to keep kinda subtle
  sox -S "$1" LS.wav remix -m 1v0.668,2v-0.668 delay 0.02 gain -h sinc 100-7000
  sox -S "$1" RS.wav remix -m 1v0.668,2v-0.668 delay 0.02 gain -h sinc 100-7000
# Uncomment this line to also get a Surround mix in a single file
# sox -S -V -G -M L.wav R.wav LS.wav RS.wav LFE.wav  --comment "5.1 Upmix SOS Profile" Surround.wav
  exit 0


# Grezen Profile
elif [ $2 == "-Grezen" ]; then
  # slightly different mxiing profile more bleed between l/r
  sox -S "$1" -c 1 L.wav mixer .885,-.115 gain -6
  sox -S "$1" -c 1 R.wav mixer -.155,.855 gain -6
  # attempted to get a more balanced centre, kinda failed
  sox -S "$1" -c 1 C.wav mixer .4511,.4511 gain -3
  # same LFE
  sox -S -v -0.5 "$1" -c 1 LFE.wav lowpass 120 remix 1-2
  # same again
  sox -S "$1" LS.wav remix -m 1v0.668,2v-0.668 delay 0.02 sinc 100-7000
  sox -S "$1" RS.wav remix -m 1v0.668,2v-0.668 delay 0.02 sinc 100-7000
# sox -S -G -M L.wav R.wav LS.wav RS.wav LFE.wav --comment "5.1 Upmix Grezen Profile" Surround.wav
  exit 0


# Farina/Sursound approach Profile MS Style M=L+R, S=L-R, c=0.75, L' = (1-c/4)*M+(1+c/4)*S, C' = c*M, R' = (1-c/4)*M-(1+c/4)*S
elif [ $2 == "-Farina" ]; then
# This one was a little complicated and the profile given seemed wrong. Encodes L/R back to MS
  sox -S "$1" MS.wav remix -m 1v0.5,2v0.5 1v0.5,2v-0.5 gain -h
  ##decodes and balnces according to profil
  sox -S -v 0.5 "MS.wav" -c 1 L.wav mixer  1v0.8125,2v1.1875
  sox -S -v 0.5 "MS.wav" -c 1 R.wav mixer  1v0.8125,2v-1.1875
  # Centre channel Taken straight from Mid
  sox -S -v 0.375 "MS.wav" -c 1 C.wav mixer -l
  # same for LFE + low pass
  sox -S -v -0.5 "MS.wav" -c 1 LFE.wav mixer -l lowpass 120
  # couldn't get surrounds right so reverted back to old stereo tactics
  sox -S "$1" LS.wav remix -m 1v0.668,2v-0.668 delay 0.02 gain -h sinc 100-7000 gain -h
  sox -S "$1" RS.wav remix -m 1v0.668,2v-0.668 delay 0.02 gain -h sinc 100-7000 gain -h
# sox -S -G -M L.wav R.wav LS.wav RS.wav LFE.wav --comment "5.1 Upmix Farina Profile" Surround.wav
# remove M/S file
  rm ./MS.wav
  exit 0


# MultiSonic Profile) Modified with 20ms delay and some attenuation on surround
# This one is much of the same just with slightly different balance
elif [ $2 == "-Multisonic" ]; then
  sox -S "$1" -c 1 L.wav mixer 0.5,-0.25
  sox -S "$1" -c 1 R.wav mixer -0.25,0.5
  sox -S "$1" -c 1 C.wav mixer 0.5,0.5 gain -6
  sox -S -v -0.5 "$1" LFE.wav lowpass 120 remix 1-2
  sox -S "$1" LS.wav remix -m 1v0.668,2v-0.668 delay 0.02 sinc 100-7000
  sox -S "$1" RS.wav remix -m 1v0.668,2v-0.668 delay 0.02 sinc 100-7000
# sox -S -G -M L.wav R.wav LS.wav RS.wav LFE.wav --comment "5.1 Upmix Multisonic Profile" Surround.wav
  exit 0

else
  echo "Something went wrong: try again"
  exit 2
fi
