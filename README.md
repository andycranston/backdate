# backdate - a UNIX/Linux shell script to move a date forwards or backwards one or more days

The `backdate` shell script can move a date forward or backwards one
or more days. For example to move the date 5th March 2008 back 7 days type:

```
backdate 5 3 2008 -7
```

The response will be:

```
27 2 2008
```

Note how the `backdate` script correctly takes into account 2008 being a
leap year.

## Command line usage

The `backdate` script can be called with none, one, three or four arguments.

The examples below were run on 3rd April 2019.

When called with no arguments it displays yesterdays date.  Example:

```
$ backdate
2 4 2019
$
```

When called with one argument which is a positive integer argument it
displays the date that many days from todays date.  Example:

```
$ backdate 5
8 4 2019
$
```

When called with one argument which is a negative integer argument it
displays the date that many days before todays date.  Example:

```
$ backdate -7
27 3 2019
$
```

When called with three arguments the first argument is the day of
the month, the second argument is the month and the third argument is
the year.  The script will display the date one day before this date.
For example:

```
$ backdate 25 12 2000
24 12 2000
$
```

When called with four arguments (you can probably guess where this
is going :-) the first three arguments are the day of the month, the
month number and the year respectively.  The fourth argument is either
a positive or negative integer.

If the fourth argument is a positive integer the date on the command
line is moved forward that many days and displayed.  Examples:

```
$ backdate 25 12 2000 7
1 1 2001
$ backdate 6 7 1974 365
6 7 1975
$
```

If the fourth argument is a negative integer the date on the command
line is moved backwards that many days and displayed.  Examples:

```
$ backdate 2 1 2000 -2
31 12 1999
$ backdate 31 10 1960 -1461
31 10 1956
$
```

## A note on efficiency

The `backdate` shell script works iteratively - what this means is that to
move a date forwards or backwards 10 days takes ten times as long as moving
it just 1 day.  Similarly moving 1000 days takes one thousand times as long.
Hence it is usually used for tasks like working out yesterdays or
tomorrows date.  

## If it is so inefficient why did you write it?

Well it isn't that inefficient for moving dates up to around a month.
However, the real reason was to demonstrate how useful the concept of
the UNIX pipeline is.  The whole key behind the `backdate` script is being able
to work out the number of days in a specific month in a specific year.
This is usually constant for all the months except February.  For February
some logic is needed to determine if the year is a leap year or not.

Rather than implement code to handle leap years why not use existing
code from the standard UNIX command `cal`.  All we need to do is run the
`cal` command for a specific month and year and then inspect the output.

For example take the month of February in 1972.  Run the `cal` command as
follows:

```
$ cal 2 1972
   February 1972
Su Mo Tu We Th Fr Sa
       1  2  3  4  5
 6  7  8  9 10 11 12
13 14 15 16 17 18 19
20 21 22 23 24 25 26
27 28 29

$
```

We are only interested in lines with numbers in them so
use the `grep` command as follows:

```
$ cal 2 1972 | grep '[0-9]'
   February 1972
       1  2  3  4  5
 6  7  8  9 10 11 12
13 14 15 16 17 18 19
20 21 22 23 24 25 26
27 28 29
$
```

As we want to work out the number of days in the month
only the last line of the output is of interest so
use the `tail` command like this:

```
$ cal 2 1972 | grep '[0-9]' | tail -n 1
27 28 29
$
```

Nearly there.  Now we just want the last number on the line.  By
using the `awk` command we can do this:

```
$ cal 2 1972 | grep '[0-9]' | tail -n 1 | awk '{ print $NF }'
29
$
```

So 29 days in February in 1972.  It is the above pipeline that is present
in the `backdate` shell script.  Here it is in the `dim` function:

```
dim()
{
  m=$1
  y=$2

  cal $m $y | grep '[0-9]' | tail -n 1 | awk '{ print $NF }'
}
```

See the full script for details.

The thing to learn here is that if an existing command exists that can
solve part or most of your problem (in this case determining the number
of days in a given month and year) then use that command in a pipeline
that pulls the required data out in a format you can use.

## Exercise for the reader

Now you can see the power of the UNIX pipeline why not write a script
that given the day of the month, the month number and the year works
out and displays the day of the week that date is.

---------------------------------------------------

End of file
