/*=================================================================================================*/
libname clean '/home/u61536033/sasuser.v94/Modulo3/Clean3';
/*=================================================================================================*/

data clean.Patients;
	infile '/home/u61536033/my_shared_file_links/u61536033/03CD/Datasets/Patients.txt';
	
	input @1  Patno      $3.
	      @4  Account_No $7.
	      @11 Gender     $1.
	      @12 Visit      mmddyy10.
	      @22 HR         3.
	      @25 SBP        3.
	      @28 DBP        3.
	      @31 Dx         $7.
	      @38 AE         1.			
	;
	
	label
			Patno      = "Patient number"
			Account_No =  "Account Number"
			Gender     = "Gender"
			Visit      = "Visit Date"
			HR         = "Heart Rate"
			SBP        = "Systolic Blood Pressure"
			DBP        = "Diastolic Blood Pressure"
			Dx         = "Diagnosis Code"
			Ae         = "Adverse Event"
	;
	
	format Visit mmddyy10.;
run;
/*=================================================================================================*/
proc sort data=Clean.patients;
	by Patno;
run;
/*=================================================================================================*/
*Key is being specified using "by sentence";
proc sort data=clean.patients out=Single nodupkey;
	by Patno;
run;

Title "Data Set Single - Duplicated ID´s Removed from Patients";
proc print data=Single;
	id Patno;
run;
/***************************/
proc sort data=clean.patients out=Single2 noduprecs;
	by Patno;
run;

Title "Data Set Single - Duplicated Records Removed from Patients";
proc print data=Single2;
	id Patno;
run;
/*=================================================================================================*/
data Multiple;
   input ID $ X Y;
datalines;
001 1 2
006 1 2
009 1 2
001 3 4
001 1 2
009 1 2
001 1 2
;

proc sort data=Multiple out=PreStrange;
	by ID;
run;

proc sort data=Multiple out=Strange noduprecs;
	by ID;
run;
/*=================================================================================================*/
data Clean.Clinic_Visits;
	informat ID $3. Date mmddyy10.;
	input ID Date HR SBP DBP;
	format Date date9.;
datalines;
001 11/11/2016 80 120 76
001 12/24/2016 78 122 78
002 1/3/2017 66 140 88
003 2/2/2017 80 144 94
003 3/2/2017 78 140 90
003 4/2/2017 78 134 78
004 11/15/2016 66 118 78
004 11/15/2016 64 116 76
005 1/5/2017 72 132 82
005 3/15/2017 74 134 84
;

proc sort data=clean.clinic_visits;
	by ID Date;
run;

title "Examining First.ID and Last.ID";
data Clinic_Visits;
	set clean.clinic_visits;
	by ID;
	file print;
	put @1 ID= @10 Date= @25 First.ID= @38 Last.ID=;
run;
/*=================================================================================================*/
proc sort data=Clean.patients out=Tmp;
	by Patno;
run;

data Duplicates;
	set Tmp;
	by Patno;
	if First.Patno and Last.Patno then delete;
run;

data NoDuplicates;
	set Tmp;
	by Patno;
	if First.Patno and Last.Patno;
run;
/*=================================================================================================*/
proc freq data=clean.patients noprint;
	tables Patno/ out=Duplicates(keep=Patno Count
									where=(Count gt 1));
run;

proc sort data=clean.patients out=Tmp;
	by Patno;
run;

proc sort data=Duplicates;
	by Patno;
run;

data Duplicates_Obs;
	merge Tmp Duplicates(in=In_Duplicates drop=Count);
	by Patno;
	if In_Duplicates;
run;
/*=================================================================================================*/
/*
  T1     T2           RES      IT1 IT2
  (1) (1, AAA) --> (1,1,AAA)    T 	T
  (2) (2, BBB) --> (2,2,BBB)    T 	T
  (3)          --> (3, ,   )    T 	F
      (5, ccc) --> ( ,5,ccc)    F 	T
      
data Duplicates_Obs;
	merge Tmp(in=IT1) Duplicates(in=IT2);
	by Patno;
	if In_Duplicates;
run;

*/
/*=================================================================================================*/
proc sort data=clean.clinic_visits;
	by ID Date;
run;

title "Examining First.ID and Last.ID with Two By Variables";
data Clinic_Visits;
	set clean.clinic_visits;
	by ID Date;
	file print;
	put @1 ID= @8 Date= @24 First.ID= @36 Last.ID= @48 First.Date= @62 Last.Date=;
run;
/*=================================================================================================*/
proc sort data=clean.clinic_visits(keep=ID) out=Tmp;
	by ID;
run;

title "Patient ID's for patients with other than 2 observations";
data _null_;
	file print;
	set Tmp;
	by ID;
	if First.ID then n = 0;
	n + 1;   /* (n += 1() o bien (n = n + 1) */ /* SUM STATEMENT*/
	if Last.ID and n ne 2 then put
		"Patient number " ID "has " n "observation(s).";
run;
/*=================================================================================================*/
proc freq data=clean.clinic_visits noprint;
	tables ID / out=Duplicates(keep=ID Count
									where=(Count ne 2));
run;

proc print data=Duplicates noobs;
run;



































