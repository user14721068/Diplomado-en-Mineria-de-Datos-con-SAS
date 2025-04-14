libname clean '/home/u61536033/sasuser.v94/Modulo3/Clean3';
/*********************************************************************************/
* LENGTH Visit 4;

*	peso     = 78;
*   nombre   = "Pepe";
*   producto = "BSmart";
*   inicio   = '01Jan2010'd;
*   inicio   = '01Jan2010'D;
/*********************************************************************************/
/*
Utilizando proc print y el dataset patients, mantener la columna Patno y Visit.
Eliminar la columna Obs.
Excluir las visitas fuera del rango 01-Ene-20120 al 15-Abr-2017.
Visit no missing
Formato de salida date9.

Hint:
where
missing() 
Variable is missing/ Variable is not missing
format Var formato;
proc print data=llll (keep= list_vars)
*/
proc print data=clean.patients(keep=Patno Visit) noobs;
	where Visit not between '01Jan2010'd and '15Apr2017'd and
		Visit is not missing;
	format Visit date9.;	
run;
/*********************************************************************************/
data Dates;
	infile '/home/u61536033/my_shared_file_links/u61536033/03CD/Datasets/Patients.txt';
	input @12 Visit mmddyy10.;
	format Visit mmddyy10.;
run;

data Dates;
	infile '/home/u61536033/my_shared_file_links/u61536033/03CD/Datasets/Patients.txt';
	input @12 Visit mmddyy10.;
	format Visit date9.;
run;
/*********************************************************************************/
data _null_;
	file print;
	infile '/home/u61536033/my_shared_file_links/u61536033/03CD/Datasets/Patients.txt';
	input @1  Patno     $3.
	      @12 Visit     mmddyy10.
	      @12 Char_Date $char10.;
	      
	if missing(Visit) then put Patno= Char_date=;
run;

data _null_;
	file print;
	infile '/home/u61536033/my_shared_file_links/u61536033/03CD/Datasets/Patients.txt';
	input @1  Patno     $3.
	      @12 Visit     mmddyy10.
	      @12 Char_Date $char10.;
	      
	if missing(Visit) and not missing(Char_date) then 
		put Patno= Char_date=;
run;
/*********************************************************************************/
data Nonstandard;
	input Patno $ 1-3 Month 6-7 Day 13-14 Year 20-23;
	Date = mdy(Month,Day,Year);
	format Date mmddyy10.;
datalines;
001  05     23     1998
006  11     01     1998
123  14     03     1998
137  10            1946
;

title "Listing of data set Nonstandard";
proc print data=Nonstandard;
	id Patno;
run;
/*********************************************************************************/
data No_Day;
	input @1 Date1 monyy7.
	      @8  Month 2.
	      @10 Year  4.;
	
	Date2 =  mdy(Month,15,Year);
	format Date1 Date2 mmddyy10.;
datalines;
JAN98  011998
OCT1998101998
;
/*********************************************************************************/
data Miss_Day;
	input @1 Patno $3.
	      @4 Month 2.
	      @6 Day   2.
	      @8 Year  4.;
	      
	if not missing(Day) then Date=mdy(Month,Day,Year);
	else Date=mdy(Month,15,Year);
	format Date mmddyy10.;
datalines;
00110211998
00205  1998
00344  1998
;
/*********************************************************************************/
data Miss_Day;
	input @1 Patno $3.
	      @4 Month 2.
	      @6 Day   2.
	      @8 Year  4.;
	      
	Date = mdy(Month, coalesce(Day,15),Year);
	
	format Date mmddyy10.;
datalines;
00110211998
00205  1998
00344  1998
;
/*********************************************************************************/
/*
numPat Day
 1      2   coalesce(Day,15) => coalesce[2,15]  = 2
 4      5   coalesce(Day,15) => coalesce[5,15]  = 5
 3     10   coalesce(Day,15) => coalesce[10,15] = 10
 4     28   coalesce(Day,15) => coalesce[28,15] = 28
 7      .   coalesce(Day,15) => coalesce[.,15]  = 15
 
   Fecha    
 01102023
 
 data buildDate;
  	set tuDatatset;
  	day   = input(substr(Fecha,1,2),2.);
  	month = input(substr(Fecha,3,2),2.);
  	year  = input(substr(Fecha,5,4),4.);
  	
  	FechaNum = mdy(month,day,year);
  	format FechaNum date9.;
 run;
 
*/
/*********************************************************************************/


























