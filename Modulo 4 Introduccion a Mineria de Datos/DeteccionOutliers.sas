/*create dataset*/
data original_data;
    input team $ points;
    datalines;
Z 34
W 35
X 54    
A 18
B 24
C 26
D 34
E 38
F 45
G 48
H 54
I 60
J 73
K 79
L 85
M 94
N 98
O 221
P 223
;
run;


/*Identificacion por Metodos Graficos*/
*Outliers = Observations > Q3 + 1.5*IQR  or < Q1 – 1.5*IQR;
*El Boxplot por default utiliza la anterior formula;
/*create boxplot to visualize distribution of points*/
ods output sgplot=boxplot_data;
*ods trace on;
proc sgplot data=original_data;
    vbox points;
run;
*ods trace off;


/********************************/
/* Enfoque asumiendo normalidad */
/********************************/

/*Identificacion por Medidas Estadísticas*/
/*Si se cumple el supuesto de normalidad, entonces todas las observaciones que están a más de 3 desviaciones estándar de la media se consideran valores atípicos*/
data work.my_data;
    call streaminit(123);
    do i = 1 to 1000;
	value = rand("Normal", 0, 1);
	output;
    end;
    drop i;
run;

ods output TestsForNormality = work.normal_test;
ods output BasicMeasures = work.measures;
*ods trace on; 
proc univariate data=work.my_data normal;
    var value;
    histogram value / normal;
run;
*ods trace off;

proc sql noprint;
    select pValue label= 'p-value' into :pvalue from work.normal_test where test = 'Shapiro-Wilk';
    select LocValue label = 'Mean' into :mean from work.measures where LocMeasure ='Media';
    select VarValue label = 'Std Dev' into :stddev from work.measures where VarMeasure ='Desviación std';
quit;

%put &=pvalue.;
%put &=mean.;
%put &=stddev.;


data work.outliers_normaldistr;
    set work.my_data;
    obs = _N_; 
    if value lt (&mean. - 3*&stddev.) 
	or value gt (&mean. + 3*&stddev.) then output;
run;
 
 
ods output sgplot=work.sgplotdata;
proc sgplot data=my_data;
    vbox value;
run;

*Filtrar valores OUTLIERS;
*Box(value)__Y
Box(value)__st;
*;
proc contents data= work.sgplotdata;run;


data work.outliers_boxplot (keep = Value2 Statistic);
    set work.sgplotdata
	(rename=("BOX(value)___Y"n = Value2
		"BOX(value)__ST"n = Statistic));
    where find(Statistic, "OUTLIER") gt 0;
run;



/*******************/
/** Winsorization **/
/*******************/

*Calculamos percentiles;
proc means data=work.my_data p5 p95;
    var value;
    output out=work.percentiles_p5_p95
	p5 = P_5
	p95 = P_95;
run;

*Guardamos como macrovariables; 
proc sql noprint;
    select p_5 into :p5 from work.percentiles_p5_p95;
    select p_95 into :p95 from work.percentiles_p5_p95;
quit;

%put &=p5;
%put &=p95;



*Outliers por winsorization;
data work.outliers_winsorization;
	id = _N_;
    set work.my_data; 
    if value lt &p5.
	or value gt &p95. then output;
run;

/**********************/
/**** D de Cook    ****/
/**********************/

* Calculate Cooks D and create data set with LSMeans
ods output lsmeans=lsmeans0; 
proc glm data=sashelp.baseball (keep=sampleid e earn12-earn16)  ;   
class e;   
model earn14 = e yrearn;   
lsmeans e / pdiff stderr;   
output out=work.cooksd(where=(cooksd>= 4/&nobs)) cookd=cooksd; 
quit; 
ods output close; 

/*proc contents data = sashelp.baseball; 
run;*/



proc sql noprint; 
select count(*) into: nobs 
from sashelp.baseball;quit;



	 

*proc reg; 


proc glm data=sashelp.baseball;   
class Position;   
model Salary = nHits nHome nRuns nRBI nBB YrMajor;   
/*lsmeans Position / pdiff stderr;   */
output out=work.cooksd (where=(cooksd>= 4/&nobs)) cookd=cooksd; 
quit; 
