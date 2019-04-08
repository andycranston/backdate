#!/bin/sh
#
# @(!--#) @(#) backdate.txt, version 005, 21-march-2013
#
# backdate
#
# move a date backwards one day, forwards one day, backwards
# a number of days or forwards a number of days
#

#
# dim
#

dim()
{
  m=$1
  y=$2

  cal $m $y | awk '{ print $NF }' | grep "[0-9]" | $TAILCMD -n 1
}

#
# forward1day
#

forward1day()
{
  d=$1
  m=$2
  y=$3

  dimonth=`dim $m $y`

  if [ $d -lt $dimonth ]
  then
    d=`expr $d + 1`
  else
    d=1
    m=`expr $m + 1`
    if [ $m -eq 13 ]
    then
      m=1
      y=`expr $y + 1`
    fi
  fi

  echo $d $m $y
}

#
# forwarddays
#

forwarddays()
{
  d=$1
  m=$2
  y=$3
  n=$4

  while [ $n -gt 0 ]
  do
    set X `forward1day $d $m $y`

    d=$2
    m=$3
    y=$4

    n=`expr $n - 1`
  done

  echo $d $m $y
}

#
# reverse1day
#

reverse1day()
{
  d=$1
  m=$2
  y=$3

  if [ $d -gt 1 ]
  then
    d=`expr $d - 1`
  else
    m=`expr $m - 1`
    if [ $m -eq 0 ]
    then
      m=12
      y=`expr $y - 1`
    fi
    d=`dim $m $y`
  fi

  echo $d $m $y
}

#
# reversedays
#

reversedays()
{
  d=$1
  m=$2
  y=$3
  n=$4

  while [ $n -gt 0 ]
  do
    set X `reverse1day $d $m $y`

    d=$2
    m=$3
    y=$4

    n=`expr $n - 1`
  done

  echo $d $m $y
}

#
# Main
#

PATH=/bin:/usr/bin
export PATH

progname=`basename $0`

TAILCMD=tail

if [ -x /usr/xpg4/bin/tail ]
then
  TAILCMD=/usr/xpg4/bin/tail
fi

case $# in
  0)
    day="-"
    month="-"
    year="-"
    step=-1
    ;;
  1)
    day="-"
    month="-"
    year="-"
    step=$1
    ;;
  3)
    day=$1
    month=$2
    year=$3
    step=-1
    ;;
  4)
    day=$1
    month=$2
    year=$3
    step=$4
    ;;
  *)
    echo "$progname: usage:" 2>&1
    echo "    $progname" 2>&1
    echo "    $progname step" 2>&1
    echo "    $progname day month year" 2>&1
    echo "    $progname day month year step" 2>&1
    exit 2
    ;;
esac

if [ "$day" = "-" ]
then
  day=`date '+%d'`
fi

if [ "$month" = "-" ]
then
  month=`date '+%m'`
fi

if [ "$year" = "-" ]
then
  year=`date '+%Y'`
fi

# use expr to lose any leading zeroes and all that
day=`expr $day + 0`
month=`expr $month + 0`
year=`expr $year + 0`
step=`expr $step + 0`

# range check day less than one
if [ $day -lt 1 ]
then
  echo "$progname: day \"$day\" less than one" 2>&1
  exit 2
fi

# range check day greater than 31
if [ $day -gt 31 ]
then
  echo "$progname: day \"$day\" greater than 31" 2>&1
  exit 2
fi

# range check month less than one
if [ $month -lt 1 ]
then
  echo "$progname: month \"$month\" less than one" 2>&1
  exit 2
fi

# range check month greater than twelve
if [ $month -gt 12 ]
then
  echo "$progname: month \"$month\" greater than twelve" 2>&1
  exit 2
fi

# range check year less than one
if [ $year -lt 1 ]
then
  echo "$progname: year \"$year\" less than one" 2>&1
  exit 2
fi

if [ $day -gt `dim $month $year` ]
then
  echo "$progname: day \"$day\" too large for month $month, year $year" 2>&1
  exit 2
fi

if [ $step -eq 0 ]
then
  echo $day $month $year
elif [ $step -gt 0 ]
then
  forwarddays $day $month $year $step
else
  step=`expr $step \* -1`
  reversedays $day $month $year $step
fi

exit 0
