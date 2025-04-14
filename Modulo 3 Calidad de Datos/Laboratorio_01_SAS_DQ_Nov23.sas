/*=================================================================================================*/
/*
                                            PACIENTES
*/
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
data clean.Patients;
	infile '/home/u61536033/my_shared_file_links/u61536033/03CD/Datasets/Patients.txt';
	
	input @1  Patno      $3.
	      @4  Account_No $7.
	      @11 Gender     $upcase1.
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
	by Patno Visit;
run;
/*=================================================================================================*/
proc print data=Clean.patients;
	id Patno;
run;
/*=================================================================================================*/
data Check_Char;
	set clean.patients(keep=Patno Account_No Gender);
	length State $ 2;
	State = Account_No;
run;

proc freq data=Check_Char;
	tables Gender State /nocum nopercent;
run;
/*=================================================================================================*/
data Clean.Patients_Caps;
	set clean.Patients;
		
	array Chars[*] _character_;
	do i = 1 to dim(Chars);
		Chars[i] = upcase(Chars[i]);
	end;
	
	drop i;
run;

proc print data=clean.Patients_Caps(obs=10) noobs;
run;
/*=================================================================================================*/
/*=================================================================================================*/
/*
     notdigit("A123") = 1 ---> True
     notdigit("123A") = 4 ---> True
     notdigit("0123") = 0 ---> False
     
     <, >, <=, >=, ==, <>
     
     lt, gt, le, ge, eq, ne

*/
title "Checking for Invalid Dx Codes";

data _null_;
	set Clean.patients(keep=Patno Dx);
	length First_Three Last_Three $ 3 Period $ 1;
	First_Three = Dx;
	Period      = substr(Dx,4,1);
    Last_Three  = substr(Dx,5,3);
    
    file print;
    if missing(Dx) then put 
    	"Missing Dx for patient " Patno;
    else if notdigit(First_Three) or Period ne '.' or notdigit(Last_Three)
    	then put "Invalid Dx " Dx " for patient " Patno;
run;
/*=================================================================================================*/
data _null_;
    title "Checking for Invalid Dx Codes";
    title2;
    file print;
    
	set Clean.patients(keep=Patno Gender Account_No);
	length State $2;
	State = Account_No;
	
	*Checking value of Gender;
	if missing(Gender) then put
		"Patient number " Patno "has an invalid value for Gender: " Gender;
		
    *Checking for invalid State abbreviations;
	if State not in ('NJ','NY','PA','CT','DE','VT','NH','ME','RI','MA','MD')
		then put "Patient number " Patno "has an invalid State code: "	State;
run;
/*=================================================================================================*/
/*
    notdigit ---> OK
    notalpha ---> OK
    notalnum ---> combinación de los anteriores
    
    lowcase()  --> pasa a minusculas
    propcase() --> proper case, camel case "pepe pecas" --> "Pepe Pecas"
*/
title "Using PROC PRINT to idenntify data errors";
proc print data=Clean.patients;
	id Patno;
	var Account_No Gender;
	where notdigit(Patno) or
	      notalpha(Account_No,-2) or
	      notdigit(Account_No,3)  or
	      Gender not in ('M','F');
run;
/*=================================================================================================*/
title "Listing Invalid Values of Gender";
proc format;
	value $Gender_Check 'M','F' = 'Valid'
	                    ' '     = 'Missing'
	                    other   = 'Error'   
	;
run;

proc freq data=clean.Patients;
	tables Gender / nocum nopercent missing;
	format Gender $Gender_Check.;
run;
/****************/
data _null_;
	set clean.patients(keep=Patno Gender);
	file print;
	
	if put(Gender,$Gender_Check.) = 'Missing' then put 
		'Missing value for Gender for patient ' Patno;
	else if put(Gender,$Gender_Check.) = 'Error' then put
		'Invalid value of ' Gender 'for Gender for patient ' Patno;
run;
/*=================================================================================================*/
/*
                             COMPRESS(): quitar caracteres de un string
                             
                             COMPRESS(1_arg, 2_arg, 3_arg)
                             =======================================================================
                             1_arg: la cadena a la cual le vamos a quitar caracteres,
                             la función compress puede recibir solo un argumento (2 y 3 opcionales):
                             
                             2_arg: los caracteres que deseamos remover, en una lista dada por una cadena
                             
                             3_arg: modificador
                             
                             a		letras (mayus o minusc)
                             d      digitos
                             s      espacios en blancos
                             p      puntuacion
                             i      ignore case 
                             k      keep
                             =======================================================================
                             Solo 1er argumento:
                             
                             compress("Benito Juarez")          = "BenitoJuarez"
                             compress("Hola Mundo Mortal jaja") = "HolaMundoMortaljaja"
                             =======================================================================
                             Primer y segundo argumento:
                            
                             compress("ABC 123",   "B2 ") = "AC13"
                             compress("A1B2C3D4", "1234") = "ABCD"
                             
                             Nota:
                             CADENA1234 CADENA
                             C1A2D3E4NA CADENA
                             =======================================================================
                             compress("abc12345XYZ", ,"a")           = "12345"
                             compress("abc12345XYZ", ,"d")           = "abcXYZ"
                             compress("abc 12345	XY     Z", ,"s") = "abc12345XYZ"
                             compress("a,b,c,d", ,"p")               = "abcd"
                             =======================================================================
                             compress("AaBbCc","ab","i")             = "Cc"
                             =======================================================================
                             compress('10 kgs.',,"kd") = "10"
                             compress('10 kgs.',,"ka") = "kgs"
                             =======================================================================
                             compress('12345abcde','3',"a") = "1245abcde"
                             =======================================================================
*/
/*=================================================================================================*/
 	
 	findc(target, letra_a_buscar, modificador) ---> findc("Hola", 'h', 'i') = 1
 	                                                findc("alha", 'H', 'i') = 3
 	                                                findc("alha", 'K', 'i') = 0
/*=================================================================================================*/
/*
						                  input() ---- put()
						                  
            input(variable, formato) ---->  ¿Qué tipo de dato deberia tener "variable" en input? R. Numérico
            formato: tipo numérico
            
            put(variable, formato)   ----> ¿Qué tipo de dato deberia tener "variable" en put?   R. Caracter
            formato: tipo caracter
*/
/*=================================================================================================*/
/*      
            
 			input("365", 3.) = 365
 			
 			PAGOS_NUM = input(PAGOS, 5.) = 365
 			
 			PAGOS ---> character
 			1234
 			 456
 			  34
 			3456
 		   13780
 			
 			
 			put(365, $3.)    = "365" 
 			
 			idClte_Char = put(ID_CLIENTE, $4.)
 			
 			ID_CLIENTE ---> numeric
 			   1
 			  34
 			 456
 			 345
 		    4560
 			
 			
*/ 			
/*=================================================================================================*/








