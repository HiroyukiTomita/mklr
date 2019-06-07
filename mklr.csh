#!/bin/csh 
#
# mklr_v1.0.csh [-mon] input_file_HR_YYYY.bin
#
# Output: 
#   output_file_LR_YYYY.bin
#----------------------------------------------------------------------- 
# Init.
  set code="~/MKLR/bin_mklr_v1.0.f"

# argv
if ($#argv == 0 ) then
 goto USAGE
else if ($#argv == 1) then
 set opt1="none"
 set input=$argv[1]
else if ($#argv == 2) then
 set opt1=$argv[1]
 set input=$argv[2]
endif

# echo "$opt1"
# echo $input

# CHK input file
 set input2=`echo $input  | sed s:'_HR_':'_LR_':g`
 set ofile=`echo $input2 | sed s:'_hr_':'_lr_':g`

# CHK ofile and modify if it does not include LR or lr
 echo $ofile | grep '_LR_' >/dev/null
 set chk=$?
 if ($chk != 0) then
  echo $ofile | grep '_lr_' >/dev/null
  if ($chk != 0) then
   set chkyr=`echo $ofile:r | rev |  cut -c 1-4 | rev`
   if ($chkyr >= 1900 && $chkyr <= 3000) then
    set ofile = `echo $ofile | sed s:${chkyr}:LR_${chkyr}:g`
   else
    set ofile = `echo $ofile | sed s:'.bin':'_LR.bin':g`
   endif
  endif
 endif
# echo $ofile

 if ($ofile == $input) then
  echo "NOTE:"
  echo " no _HR_ in file name"
  goto EOP
 endif

# TR: temoral resolution
if ("$opt1" == "none") then
 set tr=daily
else if ("$opt1" == "-day") then
 set tr=daily
else if ("$opt1" == "-mon") then
 set tr=monthly
else if ("$opt1" == "-clm") then
 set tr=clm
else if ("$opt1" == "-ann") then
 set tr=ann
endif
# echo $tr

# EXE parameter
switch ($tr)
 case daily:
  set nloop=366
  breaksw
 case monthly:
  set nloop=12
  breaksw
 case clm:
  set nloop=12
  breaksw
 case ann:
  set nloop=1
  breaksw
endsw

# Compile and exe
if -o mklr_$$.bin rm mklr_$$.bin
if -r output.bin rm output.bin
gfortran -o mklr_$$.bin $code 
if -o mklr_$$.bin ./mklr_$$.bin $input $ofile $nloop
if -o mklr_$$.bin rm mklr_$$.bin

goto EOP

USAGE:
echo "USAGE:"
echo " mklr1 [ -day|mon|clm ] input_file.bin"

EOP:

