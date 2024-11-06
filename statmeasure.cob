*> Adina Mubbashir

*> Defines the program's name
identification division.
program-id. statmeasure.

*> Input and output settings
environment division.
input-output section.
file-control.
select input-file assign to dynamic-input-file-name
    organization is line sequential.

*> Declaring file and structure
data division.
file section.
fd input-file.
01 input-value-r.
    02 x-in pic s9(6)v9(2).
    02 filler pic x(72).

*> Declaring arrays and variables
working-storage section.
77 eof-switch pic 9.
01 dynamic-input-file-name pic x(100).
77 sum-of-x-sqr pic 9(14)v9(2).
77 sum-of-x pic s9(10)v9(2).
77 n pic s9(4).
77 mean pic s9(6)v9(2).
77 i pic s9(4).
77 sr pic s9(10)v9(8).
77 sx2 pic s9(10)v9(8).
77 logx pic s9(10)v9(8).
01 array-area.
    02 x pic s9(6)v9(2) occurs 1000 times.
01 input-value-record.
    02 in-x pic s9(6)v9(2).
    02 filler pic x(72).
01 output-title-line.
    02 filler pic x(28) value
    "Statistical Report".
01 output-underline.
    02 filler pic x(28) value
    "----------------------------".
01 output-col-heads.
    02 filler pic x(10) value spaces.
    02 filler pic x(11) value "Data Values".
01 output-data-line.
    02 filler pic x(10) value spaces.
    02 out-x pic -(6)9.9(2).
01 output-results-line-1.
    02 filler pic x(9) value " mean=   ".
    02 out-mean pic -(6)9.9(2).
01 output-results-line-2.
    02 filler pic x(9) value " std dev=".
    02 std-deviation pic -(6)9.9(2).
01 output-results-line-3.
    02 filler pic x(20) value " harmonic mean=   ".
    02 harmonic-mean pic -(6)9.9(2).
01 output-results-line-4.
    02 filler pic x(24) value " root square mean=   ".
    02 root-square-mean pic -(6)9.9(2).
01 output-results-line-5.
    02 filler pic x(20) value " geometric mean=   ".
    02 geometric-mean pic -(6)9.9(2).

*> Performs statistical calculations
procedure division.
move 1 to eof-switch.
*>Ask for file name
display "Please enter the name of the input file: ".
accept dynamic-input-file-name.
open input input-file.
move zero to in-x.
perform proc-body
    until eof-switch = 0.
perform end-of-job.
proc-body.
perform write-output-header.
move zero to sum-of-x.
*>Loop to read each value from file
read input-file into input-value-record
    at end perform end-of-job.
*> loop until end of file
perform input-loop
    until eof-switch = 0.
perform calculate-mean.
move zero to sum-of-x-sqr.
perform sum-loop
    varying i from 0 by 1
    until i >= n.
*> Paragraphs for calculating
perform calculate-std-dev.
perform calculate-harmonic-mean.
perform calculate-root-square-mean.
perform calculate-geometric-mean.
perform write-output-results.

*>Displays header
write-output-header.
display output-title-line.
display output-underline.
display output-col-heads.
display output-underline.

*> Calculation for mean
calculate-mean.
compute mean rounded = sum-of-x / n.

*> Calculation for standard deviation
calculate-std-dev.
compute std-deviation rounded = (sum-of-x-sqr / n) ** 0.5.

*> Calculation for harmonic mean 
calculate-harmonic-mean.
compute harmonic-mean rounded = n / sr.

*> Calculation for root mean square
calculate-root-square-mean.
compute root-square-mean rounded = function sqrt(sx2/n).

*> Calculation for root geometric mean
calculate-geometric-mean.
compute geometric-mean rounded = function exp(logx/n).

*> Output to screen
write-output-results.
display output-underline.
move mean to out-mean.
display "Mean:  ", out-mean.
display "Std Dev: ", std-deviation.
display "Harmonic Mean: ", harmonic-mean.
display "Root Mean Square: ", root-square-mean.
display "Geometric Mean: ", geometric-mean.

*>Reads and stores data
input-loop.
move in-x to x(n), out-x.
display "Data Value: ", out-x.
compute sum-of-x = sum-of-x + x(n).
compute sr = sr + (1 / x(n)).
compute sx2 = sx2 + (x(n) * x(n)).
compute logx = logx + function log(x(n)).
read input-file into input-value-record
    at end move 0 to eof-switch.
*> add 1 to number count
   compute n = n + 1.

*> Used in sum of squares
sum-loop.
   compute sum-of-x-sqr = sum-of-x-sqr + (x(i) - mean) ** 2.

end-of-job.
   close input-file.
   stop run.
