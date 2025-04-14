/*
Regex Examples:

/\d\d\d-\d\d-\d\d\d\d/

\d --> any digit
 - --> -
 
000-00-0000
111-00-9099
999-99-9999
1234-56-789

1244-79-455

1-56788-678

/\d\d\d-\d\d-\d{4}/

[]

[ABCDEFG]
[1234567890] --> \d
[1234]
[A-Z]
[a-z]
[A-Za-z]
[123]
[0-5]
[0-9] --> \d

.  ---> any character
\. ---> .
*, ?

567.78.789

/[1234]{3}-[56]{2}-\d{4}/

tyui-AB-yuTY
/[a-z]{4}-[AB]{2}-[a-z]{2}[A-Z]{2}/

/[a-z]{4}-AB-[a-z]{2}[A-Z]{2}/

*/
/*=================================================================================================*/
libname clean '/home/u61536033/sasuser.v94/Modulo3/Clean3';
/*=================================================================================================*/
data _null_;
    file print;
	set clean.patients;
	if not prxmatch("/\d\d\d\.\d\d\d/",Dx) then
		put "Error for patient " Patno "Dx code =" Dx;
run;
/*=================================================================================================*/
data _null_;
	file print;
	input Zip $10.;
	
	if not prxmatch("/\d{5}(-\d{4})?/",Zip) then
		put "Invalid zip code " Zip;

datalines;
12345
78010----5049
12Z44
ABCDE
08822
;

/*
"/\d{5}(-{4}\d{4})?/"

"/\d{5}((-\d){4})?/" 

Regla:
5 digitos
o
5 digitos seguidos de un guión seguidos de 4 digitos

Salida:
Invalid zip code $$$$$
Invalid zip code $$$$$
Invalid zip code $$$$$
..

Hint:
           (x+6)*(X-8)
             x+6*x-8
  (\d-\d-){5} ---> 7-8-7-8-7-8-7-8-7-8-
  \d-\d-{5}   ---> 5-7-----
  
  (\d-\d-)?
  
           ?  ---> 0 o 1 aparición
   A234
    456    
    
   A?\d\d\d
*/
/*=================================================================================================*/
/*
========================================
CODE
1
23
456
45678

--------
|1     |
--------
"1     "

"1"
--------
|1     |
--------

if CODE eq "1" then
	Region = "Region A";
========================================

*/


























