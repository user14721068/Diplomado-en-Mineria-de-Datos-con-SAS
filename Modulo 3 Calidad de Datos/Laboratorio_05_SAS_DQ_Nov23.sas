/***************************************************************/
/*

	data UUUUU_Clean;
		set UUUUU;
    if  Patno = XXX then DX = '530.890';
	else if  Patno = YYY then do; 
		SBP = 146;
		DBP = 98;
		DX = '735.800';
	end;
	else if Patno = WWW then HR = 80;
	
	....
	....

*/
/***************************************************************/
/*
    Reading Raw Data in SAS: 
    
	List      input (datos delimitados) --> Tarea
	Column    input (indica inicio y fin de variable)
	Formatted input (punteros e informats)             -----> es el más   común
    Named     input                                    -----> es el menos común
*/
data Named;
	length Char $ 3;
	informat Date mmddyy10.;
	input x=
	      y=
	      Char=
	      Date=;
datalines;
x=3 y=4 Char=abc Date=10/21/2010
y=7
Date=11/12/2016 Char=xyz x=9
;
/***************************************************************/
data Corrections_01Jan2017;
	LENGTH Patno $ 3
	       Account_No Dx $ 7
	       Gender $ 1;
	
	informat Visit mmddyy10.;
	format   Visit date9.;
	
	input Patno=
	      Account_No=
	      Gender=
	      Visit=
	      HR=
	      SBP=
	      DBP=
	      DX=
	      AE=;

datalines;
Patno=003 SBP=110
Patno=023 SBP=146 DBP=98
Patno=027 Gender=F
Patno=039 Account_No=NJ34567
Patno=041 Account_No=CT13243
Patno=045 HR=90
;
/***************************************************************/
data Inventory;
	length PartNo $ 3;
	input Partno $ Quantity Price;
datalines;
133 200 10.99
198 105 30.00
933 45 59.95
;

data Transaction;
	length PartNo $ 3;
	input Partno=
	      Quantity=
	      Price=;
datalines;
PartNo=133 Quantity=195
PartNo=933 Quantity=40 Price=69.95
;

proc sort data=Inventory;
	by Partno;
run;

proc sort data=Transaction;
	by Partno;
run;

data Inventory_22Feb2017;
	update Inventory Transaction;
	by Partno;
run;
/***************************************************************/
data Corrections_01Jan2017;
	LENGTH Patno $ 3
	       Account_No Dx $ 7
	       Gender $ 1;
	
	informat Visit mmddyy10.;
	format   Visit mmddyy10.;
	
	input Patno=
	      Account_No=
	      Gender=
	      Visit=
	      HR=
	      SBP=
	      DBP=
	      DX=
	      AE=;
datalines;
Patno=003 SBP=110
Patno=009 Visit=03/15/2015
Patno=011 Dx=530.100
Patno=016 Visit=10/21/2016
Patno=023 SBP=146 DBP=98
Patno=027 Gender=F
Patno=039 Account_No=NJ34567
Patno=041 Account_No=CT13243
Patno=045 HR=90
Patno=050 HR=32
Patno=055 Gender=M
Patno=058 Gender=M
Patno=088 Gender=F
Patno=094 Dx=023.000
Patno=095 Gender=F
Patno=099 DBP=60
;
/***************************************************************/
proc sort data=Clean.patients out=Patients_No_Duprecs noduprecs;
	by Patno;
run;


data Fix_Incorrect_Patno;
   set Patients_No_Duprecs;

   if Patno='007' and Account_no='NJ90043' then Patno='102';
   else if Patno='050' and Account_No='NJ87682' then Patno='103';

   if Patno='XX5' then Patno='101';

   if missing(Patno) then Patno='104';
run;

proc sort data=Fix_Incorrect_Patno;
   by Patno;
run;

data Clean.Patients_02Jan2017;
	update Fix_Incorrect_Patno Corrections_01Jan2017;
	by Patno;
	
	array Char_Vars[4] Patno Account_no Gender Dx;
	do i=1 to 4;
		Char_Vars[i] = upcase(Char_Vars[i]);
	end;
	drop i;
run;

title "Listing of Data Set Clean.Patients_02Jan2017";
proc print data=Clean.Patients_02Jan2017;
	id Patno;
run;
/***************************************************************/
/*
   Table 1     Table 2
              X Y Z W Q
(1,A,B,C,45) (1,A,D,Y,47)  by X,Y;
(1,A,B,C,45) (1,A,J,C,45)
(1,A,J,C,45) (1,A,B,C,45)

   Table 1     Table 2
(1,A,B,C,45) (1,A,D,Y,47)
(1,A,J,C,45) 

*/
/***************************************************************/









