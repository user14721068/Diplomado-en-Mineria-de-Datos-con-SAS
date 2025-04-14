data Company;
   input Name $ 50.;
datalines;
International Business Machines
International Business Macnines, Inc.
IBM
Little and Sons
Little & Sons
Little and Son
MacHenrys
McHenrys
MacHenries
McHenry's
Harley Davidson
;

proc format;
	value $Company
	
	"International Business Macnines, Inc." = "International Business Machines"
    "IBM"                                   = "International Business Machines"
    "Little & Sons"                         = "Little and Sons"
    "Little and Son"                        = "Little and Sons"
    "MacHenrys"                             = "McHenrys"
    "MacHenries"                            = "McHenrys"
    "McHenry's"                             = "McHenrys"
;
run;

data Standard;
	set Company;
	Standard_Name = put(Name,$Company.);
run;

title "Listing of Standarized Name";
proc print data=Standard noobs;
run;
/***********************************************************************************/
data Standardize;
	input @1  Alternate $40.
	      @41 Standard  $40.;
datalines;
International Business Machines, Inc.   International Business Machines
IBM                                     International Business Machines
Little & Sons                           Little and Sons
Little and Son                          Little and Sons
MacHenrys                               McHenrys
MacHenries                              McHenrys
McHenry's                               McHenrys
;
*FORMA 1;
data Control;
	set Standardize(rename=(Alternate=Start Standard=Label));
	Fmtname = "Company";
	Type    = "C";
run;

*FORMA 2;
data Control;
	set Standardize(rename=(Alternate=Start Standard=Label));
	retain Fmtname "Company" Type "C";
run;
/***********************************************************************************/
proc format library=work cntlin=Control fmtlib;
run;


data Standard;
	set Company;
	Standard_Name = put(Name,$Company.);
run;

title "Listing of Standarized Name";
proc print data=Standard noobs;
run;
/***********************************************************************************/








