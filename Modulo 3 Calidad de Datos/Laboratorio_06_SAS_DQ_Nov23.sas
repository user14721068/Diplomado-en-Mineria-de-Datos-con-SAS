/*****************************************************************************************************/
data One;
	infile "/home/u61536033/my_shared_file_links/u61536033/03CD/Datasets/file_1.txt" truncover;
	input @1  Patno  3.
	      @4  Gender $1.
	      @5  DOB    mmddyy8.
	      @13 SBP    3.
	      @16 DBP    3.;
	format DOB mmddyy10.;
run;

data Two;
	infile "/home/u61536033/my_shared_file_links/u61536033/03CD/Datasets/file_2.txt" truncover;
	input @1  Patno  3.
	      @4  Gender $1.
	      @5  DOB    mmddyy8.
	      @13 SBP    3.
	      @16 DBP    3.;
	format DOB mmddyy10.;
run;
/*****************************************************************************************************/
proc compare base=One compare=Two;
	Id Patno;
run;

proc compare data=One compare=Two;
	Id Patno;
run;
/*****************************************************************************************************/
proc compare base=One compare=Two brief transpose;
	Id Patno;
run;
/*****************************************************************************************************/
/*
Informat para el ejercicio:
Remplzar los informat:
   input @1  Patno  $char3.
         @4  Gender $char1.
         @5  DOB    $char8.
         @13 SBP    $char3.
         @16 DBP    $char3.;
         
Quitrar las sentencias format.
Ejecutar pro compare con las copciones brief y transpose.
Explicar la diferencia.
*/
data One;
	infile "/home/u61536033/my_shared_file_links/u61536033/03CD/Datasets/file_1.txt" truncover;
	input @1  Patno  $char3.
          @4  Gender $char1.
          @5  DOB    $char8.
          @13 SBP    $char3.
          @16 DBP    $char3.;
run;

data Two;
	infile "/home/u61536033/my_shared_file_links/u61536033/03CD/Datasets/file_2.txt" truncover;
	input @1  Patno  $char3.
          @4  Gender $char1.
          @5  DOB    $char8.
          @13 SBP    $char3.
          @16 DBP    $char3.;
run;

proc compare base=One compare=Two brief transpose;
	Id Patno;
run;
/*****************************************************************************************************/