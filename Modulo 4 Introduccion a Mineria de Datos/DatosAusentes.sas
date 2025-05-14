data times ;
  INPUT id trial1 trial2 trial3 ;
CARDS ;
1 1.5 1.4 1.6 
2 1.5  .  1.9 
3  .  2.0 1.6 
4  .   .  2.2 
5 2.1 2.3 2.2
6 1.8 2.0 1.9
;
run ;

/*Datos ausentes*/
*proc means: omite los datos ausentes;
proc means data=times;
  var trial1 trial2 trial3 ;
run;

*proc freq: solo opera con los datos no missing;
proc freq data=times ;
  tables trial1 trial2 trial3 ;
run ; 

proc freq data=times ;
  tables trial1 / missing ;
run ;  


libname e '/home/u61536033/my_shared_file_links/u61536033/04IMD/Datos/';

proc contents data=e.hsb2; run; 
proc contents data=e.hsb_mar; run;

/*************************************/
/******* Imputacion Multple **********/
/*************************************/

proc format;
  value female 0 = "male"
               1= "female";
  value prog 1 = "general"
             2 = "academic"
             3 = "vocation" ;
  value race 1 = "hispanic"
             2 = "asian"
             3 = "african-amer"
             4 = "white";
  value schtyp 1 = "public"
               2 = "private";
  value ses  1 =  "low"
             2 = "middle"
             3 = "high";
run;
options fmtsearch=(work); *Libref para buscar formatos;


TITLE 'FULL DATA REGRESSION';
proc glm data=e.hsb2; 
class female (ref=last) prog;
model read = write female math prog/solution ss3;
run;



/* Análisis de casos completos */
/*
Eliminar casos en un conjunto de datos a los que les faltan datos 
sobre cualquier variable de interés. 
Dependiendo de la variable de interes, seran los casos que se tendrán.
*/
proc means data = e.hsb_mar nmiss N min max mean std;
  var _numeric_ ;
run; 


/*Por defult, proc glm hace Análisis de casos completos (listwise deletion)*/
TITLE " LISTWISE REGRESSION";
proc glm data = e.hsb_mar;
class female (ref=last) prog;
model read = write female math prog /solution ss3;
run;
quit;

/*Análisis de casos disponibles (pairwise deletion)*/
*Creacion dummies;
data new;
set e.hsb_mar;
if prog ^=. then do;
	if prog =1 then progcat1=1;
	else progcat1=0;
	if prog =2 then progcat2=1;
	else progcat2=0;
end;
run;

*PROC CORR utiliza pairwise deletion para calcular la tabla de correlacion;
TITLE " PAIRWISE CORRELATIONS";
proc corr data = new cov outp=test;
var write read female math progcat1 progcat2 ;
run;

TITLE" AVAILABLE CASE REGRESSION";
proc reg data = test;
model read = write female math progcat1 progcat2 ;
run;
quit;

*ods trace on;
ods output Summary=mean_hsb_mar;
proc means data= e.hsb_mar; run;
*ods trace off;

/*********************************/
/****** Imputación Múltiple ******/
/*********************************/

proc means data=e.hsb_mar nmiss; 
var female write read math prog;
run;

*Crear banderas de valores faltantes;
data hsb_flag;
set new;
if female =.  then female_flag =1; else female_flag =0;
if write  = . then write_flag  =1; else write_flag  =0;
if read   = . then read_flag   =1; else read_flag   =0;
if math   = . then math_flag   =1; else math_flag   =0;
if prog   = . then prog_flag   =1; else prog_flag   =0;
run;

*Porcentajes de missing por variable;
proc freq data=hsb_flag;
tables female_flag write_flag read_flag math_flag prog_flag;
run;

*Examinar los patrones de datos faltantes entre sus variables de interés;
proc mi data=HSB_flag nimpute=0 ;
var socst write read female math prog;
ods select misspattern;
run;

*MI usando distribución normal multivariada (MVN);
/*SAS utiliza Markov Chain Monte Carlo (MCMC), 
que supone que todas las variables en el modelo
 de imputación tienen una distribución normal 
 multivariada conjunta.*/

*Fase 1 MI;
proc mi data= new nimpute=10 out=mi_mvn seed=54321;
var socst science write read female math progcat1 progcat2;
run;

/*proc contents data= mi_mvn; run;*/

*Fase 2 MI;
TITLE " MULTIPLE IMPUTATION REGRESSION - MVN";
proc glm data = mi_mvn ;
model read = write female math progcat1 progcat2 ;
by _Imputación;
/*by _imputation_*/
ods output ParameterEstimates=a_mvn;
run;

/*proc mianalyze parms=a_mvn;
modeleffects intercept write female math progcat1 progcat2;
run;*/


data a_mvn2;
set a_mvn (rename=(_Imputación=_Imputation_)); 
if parameter = "T. indepen" then parameter ="intercept";
run;

*Fase 3 MI;
proc mianalyze parms=a_mvn2;
modeleffects intercept write female math progcat1 progcat2;
run;