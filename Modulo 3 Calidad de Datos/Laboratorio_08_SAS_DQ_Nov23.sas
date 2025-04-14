
/*****************************************************************/
proc means data=Clean.patients n nmiss;
run;
/*****************************************************************/
proc format;
	value $Count_Missing     ' ' = 'Missing'
                           other = 'Nomissing';
run;

proc freq data=Clean.patients;
	tables _character_ / nocum missing;
	format _character_ $Count_Missing.;
run;
/*****************************************************************/
data _null_;
	file print;
	set clean.patients(keep=Patno Visit HR Gender Dx);
	if missing(Visit) then put "Missing or invalid Visit for ID " Patno;
	if missing(HR) then put "Missing or invalid HR for ID " Patno;
	/*... Gender y para Dx...*/
run;
/*****************************************************************/
/*
	LAG()
	LAG2()
	LAG3() .... LAGn()
	
	saldoUltim7d = lag(saldo) + lag2(saldo) + lag3(saldo) + ...+ lag7(saldo) / 7;
	if saldoUltim7d > 40000;
	
*/
data _null_;
	set clean.patients;
	file print;
	Previous_ID  = lag(Patno);
	Previous2_ID = lag2(Patno);
	if missing(Patno) then
		put "Missing patient ID. Two previous ID's are:"
			Previous2_ID " and " Previous_ID /
			@5 "Missing record is number " _n_;
	else if notdigit(trimn(Patno)) then
		put "Invalid patient ID:" patno +(-1)
		". Two previous ID's are:"
		Previous2_ID " and " Previous_ID /
		@5 "Invalid record is number:" _n_;
run;
/*****************************************************************/
proc print data=Clean.PATIENTS;
	where missing(Patno) or notdigit(trimn(Patno));
run;
/*****************************************************************/
title "Listing of Missing Values and Summary of Frequencies";
data _null_;
	set Clean.patients(keep=Patno Visit HR Gender Dx) end=Last;
	file print;
	if missing(Visit) then do;
		put "Missing or invalid visit date for ID " Patno;
		N_visit + 1;
	end;
	if missing(HR) then do;
		put "Missing or invalid HR for ID " Patno;
		N_HR + 1;
	end;
	if missing(gender) then do;
		put "Missing Gender for ID " Patno;
		N_Gender + 1;
	end;
	if missing(Dx) then do;
		put "Missing Dx for ID " Patno;
		N_Dx + 1;
	end;
	if Last then
		put // "Summary of missing values" /
		25*'-' /
		"Number of missing dates = " N_visit /
		"Number of missing HR´s = " N_HR /
		"Number of missing genders = " N_Gender /
		"Number of missing Dx = " N_Dx;
run;













