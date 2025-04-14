/********************************************************************************************************
						Muestreo 
********************************************************************************************************/
/******* Muestreo simple ******/

libname eda '/home/u61536033/sasuser.v94/Modulo2/Clase4/Datasets';

/* proc surveyselect para obtener una muestra con muestreo simple de un tamaño de 200 observaciones*/
proc surveyselect data=eda.spotify2023
	method=srs
	sampsize=200
	out=eda.muestrasimple200;
run;

/********* Muestreo estratificado ********/

/* Usamos el proc freq para estudiar por cuál variable sería conveniente formar los estratos*/
proc freq data=eda.spotify2023;
	tables artist_count released_month released_year;
run;

/* Usamos el proc sort para ordenar el dataset por el mes en que fueron lanzadas las canciones
para formar los estratos*/
proc sort data=eda.spotify2023 out=eda.spotiorderedM;
	by released_month;
run;

/* Usamos el proc surveyselect con la sentencia de strata para utilizar el muestreo estratificado
donde cada estrato tiene tamaño de 30 observaciones cada uno.*/
proc surveyselect data=eda.spotiorderedm
	sampsize=30
	out=eda.muestraSpotiStrata30;
   strata released_month;
run;

/* Usamos el proc surveyselect para el muestreo estratificado sin tener previamente el dataset ordenado
por la variable del mes en que fueron lanzadas las canciones
MARCA ERROR*/
proc surveyselect data=eda.spotify2023
	sampsize=30
	out=eda.muestraNoOrderedStrata30;
   strata released_month;
run;

/*Usamos el proc surveyselect para el muestreo estratificado con un tamaño de muestra para cada
estrato mayor al tamaño de algunos estratos. */
proc surveyselect data=eda.spotiorderedm
	sampsize=70
	out=eda.muestraStrata70;
   strata released_month;
run;

/*Usamos el proc surveyselect para el muestreo estratificado con un tamaño del 30% de cada estrato*/
proc surveyselect data=eda.spotiorderedm
	samprate=0.30
	out=eda.muestraStrata30p;
   strata released_month;
run;


/*****Muestreo por clústers *****/
/* proc surveyselect para crear una muestra por clústers a partir de la variable del mes en que 
fueron lanzadas las canciones, donde cada cluster tiene un tamaño de 5 observaciones*/
proc surveyselect data=eda.spotiorderedm
	sampsize=5
	out=eda.spotiCluster;
  cluster released_month;
run;

/* proc surveyselect para crear una muestra por clústers a partir de la variable del mes en que
fueron lanzadas las canciones donde usamos la palabra samplinguni en lugar de cluster*/
proc surveyselect data=eda.spotiorderedm
	sampsize=5
	out=eda.spotiClusterSU;
   samplingunit released_month;
run;

/*proc surveyselect para crear una muestra por clústers a partir de la variable del mes en que 
fueron lanzadas las canciones con el dataset original sin haberlo ordenado previamente.*/
proc surveyselect data=eda.spotify2023
	sampsize=5
	out=eda.muestraClusterO;
   cluster released_month;
run;

/* proc surveyselect para crear una muestra por clústers a partir de la variable del mes en que fueron
lanzadas las canciones con el dataset original sin haber ordenado previamente usando samplingunit*/
proc surveyselect data=eda.spotify2023
	sampsize=5
	out=eda.muestraClusterSUO;
  samplingunit released_month;
run;

/* proc surveyselect para crear una muestra por clústers a partir de la variable del mes en que
fueron lanzadas las canciones con el dataset original con un tamaño de cada cluster de 20%*/
proc surveyselect data=eda.spotify2023
	samprate=0.20
	out=eda.muestraSpotiCluster20;
   cluster released_month;
run;

/*******  Muestreo sistemático ******/

/*proc surveyselect para crear una muestra con el muestreo sistemático donde
"especificamos" el tamaño de la muestra y se considera la variable artist_count
para asignar pesos y probabilidad a las observaciones para ser seleccionadas 
(extra en el muestreo sistemático)*/
proc surveyselect data=eda.spotiorderedm
	method=pps_sys
	sampsize=293
	out=eda.muestrasis294;
   size artist_count;
run;

/* proc surveyselect para crear una muestra con el muestreo sistemático donde
especificamos el intervalo a seguir y no el tamaño de la muestra. Se considera
la variable artist_count para asignar pesos y probabilidad a las observaciones para 
ser seleccionadas*/
proc surveyselect data=eda.spotify2023 
	method=pps_sys(interval=5)
	out=eda.spotisis5;
   size artist_count;
run;

/**********************************************************************************
		Ejercicio del Dataset de Youtube Channels
**********************************************************************************/

/***Ejercicio 1 ****/
/***Punto 1 ***/
proc surveyselect data=eda.youtube_channels
	method=srs
	sampsize=300
	out=eda.muestrayoutube300;
run;
/***Punto 2***/
proc surveyselect data=eda.youtube_channels
	method=srs
	samprate=0.25
	out=eda.muestrayoutube25p;
run;

/***Ejercicio 2***/

proc sort data=eda.youtube_channels out=eda.youtube_channelsOC;
	by category;
run;

proc surveyselect data=eda.youtube_channelsoc
	sampsize=10
	out=eda.youtube_channelsStratac;
   strata category;   
run;

proc surveyselect data=eda.youtube_channelsoc
	sampsize=1
	out=eda.youtubeStrata2;
  strata category;
run;

proc freq data=eda.youtube_channelsoc;
	tables category;
run;


/*Ejercicio 3 */
/* Punto 1 */
proc surveyselect data=eda.youtube_channelsoc
	sampsize=8
	out=eda.youtubeCluster8;
  cluster category;
run;

/* Punto 2 */
proc surveyselect data=eda.youtube_channels
	sampsize=10
	out=eda.muestraYoutubeYear10;
   samplingunit started;
run;

/* Ejercicio 4 */
/*Punto 1*/
proc surveyselect data=eda.youtube_channels
	method=pps_sys
	sampsize=400
	out=eda.youtubesis400;
   size started;
run;

/*Punto 2 */
proc surveyselect data=eda.youtube_channels
	method=pps_sys(interval=40)
	out=eda.youtubesisR40;
   size started;
run;

/***********************************************************************************************************
						Análisis Multivariado
***********************************************************************************************************/
/*** Análisis de correlación ***/
/* proc corr para generar tablas informativas con el coeficiente de pearson para realizar
análisis multivariado de correlación de las variables peso, consumo de oxígeno y el tiempo 
que corrieron las personas*/
proc corr data=eda.fitnesscourse pearson;
	var Weight Oxygen Runtime;
run;

/* proc corr para generar tablas informativas con el coeficiente de spearman para realizar
análisis multivariado de correlación de las variables peso, consumo de oxígeno y el tiempo 
que corrieron las personas*/
proc corr data=eda.fitnesscourse spearman;
	var Weight Oxygen Runtime;
run;

/* proc corr para generar tablas informativas con el coeficiente de kendall para realizar
análisis multivariado de correlación de las variables peso, consumo de oxígeno y el tiempo 
que corrieron las personas*/
proc corr data=eda.fitnesscourse kendall;
	var Weight Oxygen Runtime;
run;

/* proc corr para generar tablas informativas con el coeficiente de hoeffding para realizar
análisis multivariado de correlación de las variables peso, consumo de oxígeno y el tiempo 
que corrieron las personas*/
proc corr data=eda.fitnesscourse hoeffding;
	var Weight Oxygen Runtime;
run;


/* proc corr para generar tablas informativas con el coeficiente de pearson, spearman, kendall, 
hoeffding   para realizar análisis multivariado de correlación de las variables peso, 
consumo de oxígeno y el tiempo que corrieron las personas*/
proc corr data=eda.fitnesscourse pearson spearman kendall hoeffding;
	var Weight Oxygen Runtime;
run;

/* proc corr para generar tablas informativas con el coeficiente de pearson, spearman, kendall, 
hoeffding   para realizar análisis multivariado de correlación de las variables peso, 
consumo de oxígeno y el tiempo que corrieron las personas.
Genera una matriz con los gráficos de dispersión e histogramas*/
proc corr data=eda.fitnesscourse pearson spearman kendall hoeffding
			plots=matrix(histogram);
	var Weight Oxygen Runtime;
run;

/* proc corr para generar tablas informativas con el coeficiente de pearson, spearman, kendall, 
hoeffding   para realizar análisis multivariado de correlación de las variables peso, 
consumo de oxígeno y el tiempo que corrieron las personas
Genera gráficos por pares de dispersión con la elipse de predicción*/
proc corr data=eda.fitnesscourse pearson spearman kendall hoeffding
			plots=scatter;
	var Weight Oxygen Runtime;
run;

/* proc corr para generar tablas informativas con el coeficiente de pearson, spearman, kendall, 
hoeffding   para realizar análisis multivariado de correlación de las variables peso, 
consumo de oxígeno y el tiempo que corrieron las personas
Genera una matriz con los gráficos de dispersión y los diagramas de dispersión con la elipse de predicción.*/
proc corr data=eda.fitnesscourse pearson spearman kendall hoeffding
			plots=all;
	var Weight Oxygen Runtime;
run;

/* proc corr para generar tablas informativas con el coeficiente de pearson, spearman, kendall, 
hoeffding   para realizar análisis multivariado de correlación de las variables peso, 
consumo de oxígeno y el tiempo que corrieron las personas.
Genera una matriz con los gráficos de dispersión e histogramas
Con rank ordena los coeficientes de cada variable*/
proc corr data=eda.fitnesscourse pearson spearman kendall hoeffding
			 plots=matrix(histogram) rank;
	var Weight Oxygen Runtime;
run;

/* proc corr para generar tablas informativas con el coeficiente de pearson, spearman, kendall, 
hoeffding   para realizar análisis multivariado de correlación de las variables peso, 
consumo de oxígeno y el tiempo que corrieron las personas
Genera una matriz con los gráficos de dispersión y los diagramas de dispersión con la elipse de predicción.
Con nomiss no estamos considerando los valores ausentes(missing) en el análisis.*/
proc corr data=eda.fitnesscourse pearson spearman kendall hoeffding
			plots=all nomiss;
	var Weight Oxygen Runtime;
run;

/*****Análisis de Correlación Canónico ****/

/* proc cancorr para generar tablas informativas sobre el análisis de correlación canónica
donde las variables canónicas predictoras son: Career, Supervisor, Finance mientras que las variables
canónicas dependientes son: Variety Feedback y Autonomy*/
proc cancorr data=eda.jobs;
	var Career Supervisor Finance;
	with Variety Feedback Autonomy;
run;

/* proc cancorr para generar tablas informativas sobre el análisis de correlación canónica 
donde las variables canónicas predictoras son: Career, Supervisor, Finance mientras que las variables
canónicas dependientes son: Variety, Feedback y Autonomy.
Además, nombramos a cada uno de los grupos de las variables con vname (variables en la sentencia var)
y wname(variables en la sentencia with)*/
proc cancorr data=eda.jobs 
		vname='Áreas de satisfacción' wname='Características del trabajo';
	var Career Supervisor Finance;
	with Variety Feedback Autonomy;
run;

/* proc cancorr para generar tablas informativas sobre el análisis de correlación canónica donde
las variables canónica predictoras son: Career, Supervisor, Finance mientras que las variables
canónicas dependientes son: Variety Feedback y Autonomy.
Además, nombramos a cada uno de los grupos de las variables con vname (variables en la sentencia var)
 y wname (variables en la sentencia with).
 También, personalizamos el nombre de los prefijos para las variables correspondientes a los grupos
 por Satisfaccion (Grupo: Áreas de Satisfacción ) y Caracteristica (Grupo: Características del trabajo)*/
proc cancorr data=eda.jobs
		vprefix=Satisfaccion wprefix=Caracteristica
		vname= 'Áreas de satisfacción' wname='Características del trabajo';
	var Career Supervisor Finance;
	with Variety Feedback Autonomy;
run;

/* proc cancorr para generar tablas informativas sobre el análisis de correlación canónica donde
las variables canónica predictoras son: Career, Supervisor, Finance mientras que las variables
canónicas dependientes son: Variety Feedback y Autonomy.
Además, nombramos a cada uno de los grupos de las variables con vname (variables en la sentencia var)
 y wname (variables en la sentencia with).
 También, personalizamos el nombre de los prefijos para las variables correspondientes a los grupos
 por Satisfaccion (Grupo: Áreas de Satisfacción ) y Caracteristica (Grupo: Características del trabajo)
 Sí acepta acentos en los prefijos*/
proc cancorr data=eda.jobs
	vprefix=Satisfacción wprefix=Característica
	vname='Áreas de satisfacción' wname='Características del trabajo';
  var Career Supervisor Finance;
  with Variety Feedback Autonomy;
run;


/**** Análisis de componentes principales ***/

/* proc factor para generar tablas informativas del análisis de componentes principales y a su vez,
el análisis factorial del cual se deriva el análisis de componentes principales*/
proc factor data=eda.socioeconomics;
run;

/* proc factor para generar tablas informativas del análisis de componentes principales,
donde con la opción simple, nos permite ver las medidas de la media aritmética y desviación
estándar para cada una de las variables*/
proc factor data=eda.socioeconomics simple;
run;

/*proc factor para generar tablas informativas del análisis de componentes principales
donde con la opción de simple, nos permite ver las medidas de la media aritmética y desviación
estándar para cada una de las variables además, con la opción corr nos muestra una tabla de
correlaciones que existen entres las variables*/
proc factor data=eda.socioeconomics simple corr;
run;


/*********************************************************************************
				Ejercicio del Dataset Club Fitness
*********************************************************************************/

/**Ejercicio 1**/
/* Punto 1 */
proc cancorr data=eda.clubfitness
	vprefix=Medida vname='Medidas fisiológicas'
	wprefix=Ejercicio wname='Ejercicios';
  var Weight Waist Pulse;
  with Chins Situps Jumps;
run;