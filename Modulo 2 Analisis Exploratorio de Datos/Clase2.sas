/**************************************************************************************************
                           Estadística Descriptiva
Frecuencias de variables categóricas
**************************************************************************************************/

/* Habilitamos la librería/biblioteca eda */
libname eda '/home/u61536033/sasuser.v94/Modulo2/Clase2/Datasets';
run;

/* Obtención de tablas de frecuencias usando el proc freq*/
title "Frecuencias de los valores que tiene la variable origin";
proc freq data=sashelp.cars;
tables origin;
run;

/* Obtención de tablas de frecuencias usando el proc freq de las variables origin y type*/
title "Frecuencias de los valores que tiene la variable origin y type";
proc freq data=sashelp.cars;
tables origin type;
run;

/* Obtención de tablas de frecuencias usando el proc freq de las variables origin y type
sin las frecuencias acumuladas*/
title "Frecuencias de los valores que tiene la variable origin y type";
proc freq data=sashelp.cars;
tables origin type / nocum;
run;

/* Obtención de tablas de frecuencias usando el proc freq de las variables origin y type
sin las frecuencias acumuladas y tratando el valor de missing como un valor más de origin y type*/
title "Frecuencias de los valores que tiene la variable origin y type considerando valores missings";
proc freq data=sashelp.cars;
tables origin type / nocum missing;
run;

/* Obtención de tablas de frecuencias usando el proc freq de las variable begin del dataset holiday*/
title "Frecuencias de los valores que tiene la variable begin";
proc freq data=sashelp.holiday;
tables begin / nocum;
run;

/* Obtención de tablas de frecuencias usando el proc freq de las variable begin del dataset holiday
tratando el valor de missing como un valor más de begin*/
title "Frecuencias de los valores que tiene la variable begin considerando valores missings";
proc freq data=sashelp.holiday;
tables begin / nocum missing;
run;

/*proc format para modificar el formato de los origenes de los autos del dataset cars por los nombres
en español, es decir, por Asia, Europa y Estados Unidos */
proc format;
	value $origin 'Asia' = 'Asia'
				  'Europe' = 'Europa'
				  'USA' = 'Estados Unidos';
run;
/*proc freq usando el format creado anteriormente para tener los orígenes en español */
proc freq data=sashelp.cars;
	tables origin / nocum;
	format origin $origin.;
run;

/*proc format para modificar el formato de la variable begin de los días festivos, en donde se 
cambiarán los años por las oraciones "Antes de los setenta" y "Después de los setentas"*/
proc format;
	value begin 1938 = 'Antes de los setentas'
				 1971 = 'Después de los setentas'
				 1978 = 'Después de los setentas'
				 1986 = 'Después de los setentas';
run;

/*proc freq aplicando el format de la variable begin*/
proc freq data=sashelp.holiday;
	tables begin / nocum;
	format begin begin.;
run;

/* Otra forma de obtener el proc format de begin podría ser la siguiente*/
proc format;
	value Begin low-1970 = 'Antes de los setentas'
				1970-high = 'Después de los setentas';
run;

/*proc freq aplicando el format de la variable begin*/
proc freq data=sashelp.holiday;
	tables begin / nocum;
	format Begin begin.;
run;

/* proc format para la variable end */
proc format;
	value end low-1970 = 'Antes de los setentas'
				1970-high = 'Después de los setentas';
run;

/* proc freq con más de un format*/
proc freq data=sashelp.holiday;
	tables begin end category/ nocum;
	format Begin begin.
	       end end.;
run;

/* Generación de gráfica de barras verticales para visualizar la frecuencia de los valores del origen */
title "Generación de gráfica de barras verticales para visualizar la frecuencia de los valores 
clasificados por origen";
proc gchart data=sashelp.cars;
	vbar origin;
run;
quit;

/* Generación de gráfica de barras horizontales para visualizar la frecuencia de los valores del origen */
title "Generación de gráfica de barras horizontales para visualizar la frecuencia de los valores 
clasificados por origen";
proc gchart data=sashelp.cars;
	hbar origin;
run;
quit;

/* Generación de gráfica de barras y tablas de frecuencias con proc freq de la variable origen*/
proc freq data=sashelp.cars;
	tables Origin / plots=FreqPlot(scale=Percent) out=eda.freqcars;
run;

/* Generación de gráfica de barras y tablas de frecuencias con proc freq de origen por tipo*/
proc freq data=sashelp.cars;
	tables Origin*Type / plots=FreqPlot(twoway=cluster scale=Percent) out=eda.freqcars2;
run;

/* Generación de gráfica de barras por tipo y grupos de origen, con barras verticales y tipo cluster*/
proc sgplot data=eda.freqcars2;
	vbar type /group=Origin groupdisplay=cluster response=Percent;
run;

/* Generación de gráfica de barras por tipo y origen con barras verticales y tipo stack*/
proc sgplot data=eda.freqcars2;
	vbar type /group=Origin groupdisplay=stack response=Percent;
run;

/* Generación de gráfica de barras por tipo y grupos de origen, con barras horizontales y tipo cluster*/
proc sgplot data=eda.freqcars2;
	hbar type /group=Origin groupdisplay=cluster response=Percent;
run;

/* Generación de gráfica de barras por tipo y origen con barras horizontales y tipo stack*/
proc sgplot data=eda.freqcars2;
	hbar type /group=Origin groupdisplay=stack response=Percent;
run;

/* Generación de gráfica de barras y tablas de frecuencias con proc freq de origen por tipo*/
proc freq data=sashelp.cars;
	tables Origin*Type / plots=FreqPlot(twoway=stack scale=Percent) out=eda.freqcars3;
run;

/*Se ordena el dataset class por sexo*/
proc sort data=sashelp.class out=eda.classorderedsex;
	by sex;
run;

/* Generación de tablas de frecuencias por grupos usando el by*/
proc freq data=eda.classorderedsex;
	tables age;
	by sex;
run;

/* Generación de tablas de frecuencias de la variable edad*/
proc freq data=sashelp.class;
	tables age;
run;

/* Generación de gráfica de barras verticales de frecuencias de edad*/
proc sgplot data=eda.classorderedsex;
  vbar age;
run;

/* Generación de gráficas y tablas con proc freq da las variables de edad y sexo*/
proc freq data=sashelp.class;
	tables age*sex / plots=FreqPlot(twoway=cluster scale=Percent) out=eda.freqclass2;
run;

/*************************************************************************************************************
		                              Ejercicio del Dataset Salary Data
*************************************************************************************************************/
/***********************Ejercicio 1 ***********************************************************************/
/* Punto 1 */
title "Frecuencias de los valores que tienen las variables nivel de educación, género, edad  y años
 de experiencia considerando valores missing sin valores acumulados";
proc freq data=eda.salarydata;
tables Education_Level Gender Age Experience / nocum missing;
run;

/* Puntos 2 y 3 */
/* Creación de un format para establecer 4 valores nuevos en la edad */
proc format;
	value age 23-29 = 'En los veintes'
			   30-39 = 'En los treintas'
			   40-49 = 'En los cuarentas'
			   50-59 = 'En los cincuentas';
run;
/* proc freq aplicando el format en la variable de edad */
proc freq data=eda.salarydata;
	tables age / nocum missing;
	format age age.;
run;

/* Puntos 4 y 5 */
/* Creación de un format para establecer 3 valores en los años de experiencia */
proc format;
	value experience low-2 = 'Poca experiencia'
			         2-5 = 'Experiencia media'
			         5-high = 'Mucha experiencia';
run;
/* proc freq aplicando el format en la variable de años de experiencia */
proc freq data=eda.salarydata;
	tables experience / nocum missing;
	format experience experience.;
run;
/********************************Ejercicio 2************************************************************/

/* Punto 1*/
proc freq data=eda.salarydata;
	tables Gender;
run;

proc gchart data=eda.salarydata;
	vbar Gender;
run;
quit;


proc freq data=eda.salarydata;
	tables Gender / plots=FreqPlot(scale=Percent) out=eda.freqGenderSD;
run;

/* Punto 2*/
/* Obtención de frecuencias para cada género la cantidad de personas que tienen el tipo de nivel de 
educación correspondiente y generación de gráfica vertical para dichas frecuencias  */
proc freq data=eda.salarydata;
	tables Gender*Education_Level / plots=FreqPlot(twoway=cluster scale=Percent) out=eda.ELGSD;
run;
/*Generación de la gráfica de barras vertical de las frecuencias a partir del dataset anterior*/
proc sgplot data=eda.ELGSD;
	vbar Education_Level /group=Gender groupdisplay=cluster response=Percent;
run;