/*************************************************************************************************************************
                           Estadísicas de sumarización (resumen)
 mean: promedio                    min y max: mínimo y máximo respectivamente
 median: mediana                   var: varianza
 std: desviación estándar          mode: moda
*************************************************************************************************************************/
/* proc means de todas las variables */
proc means data=SASHELP.CARS mean std min max median n stderr var mode;
run;
/* proc means de una variable en particular */
proc means data=SASHELP.CARS mean std min max median n stderr var mode;
	var Weight;
run;
/* proc means de una variable en particular dividida en subgrupos */
proc means data=SASHELP.CARS mean std min max median n stderr var mode;
	var Weight;
	class Origin;
run;
/*  proc sort y proc means para hacer grupos con el BY */
proc sort data=SASHELP.CARS out=WORK.TempCarsSorted;
	by Type;
run;

proc means data=WORK.TempCarsSorted mean std min max median n stderr var mode;
	var Weight;
	class Origin;
	by Type;
run;
/* Se elimina el dataset temporal */
proc datasets library=WORK noprint;
	delete TempCarsSorted;
	run;
/* proc univariate para la generación del histograma por Origen */
proc univariate data=SASHELP.CARS noprint;
	var Weight;
	class Origin;
	histogram Weight;
run;
/* proc univariate para la generación del histograma por Origen con medidas de tendencia central y de distribución */
proc univariate data=SASHELP.CARS noprint;
	var Weight;
	class Origin;
	histogram Weight;
	inset mean std min max median stderr var mode / position=ne;
run;
/* proc univariate para la generación del histograma por Origen con tablas informativas de la estadística*/
proc univariate data=SASHELP.CARS;
	var Weight;
	class Origin;
	histogram Weight;
run;
/* proc univariate para la generación del histograma por Origen con medidas de tendencia central y de distribución
   con tablas informativas de la estadística */
proc univariate data=SASHELP.CARS;
	var Weight;
	class Origin;
	histogram Weight;
	inset mean std min max median stderr var mode / position=ne;
run;

/* Revisión de diferencia entre CLASS y BY */
/* Creación de un dataset a partir del de SAS HELP donde los cilindros son 4,6,8 y el tipo es distinto al híbrido */
data cars;
   set  SASHELP.CARS;
   where cylinders in (4,6,8) and type ^= 'Hybrid'; 
run;

 /* Ordenamos el dataset por origen */
proc sort data=cars out=CarsSorted; 
   by Origin; 
run;

/* Probamos class en proc univariate */
proc univariate data=cars;
   class Origin;
   var Horsepower;
   histogram Horsepower / nrows=3; /*usamos nrows para tener un panel */
   ods select histogram;
run;

/* Probamos class en proc univariate */
proc univariate data=cars;
   class Origin;
   var Horsepower;
   histogram Horsepower;
   ods select histogram;
run;

/* Probamos by en proc univariate */
proc univariate data=CarsSorted;
   by Origin;
   var Horsepower;
   histogram Horsepower;
   ods select histogram;
run;

/* Probamos class en proc means */ 
proc means data=cars N Mean Std;
   class Origin;
   var Horsepower Weight Mpg_Highway;
run;

/* Probamos by en proc means */
proc means data=CarsSorted N Mean Std;
   by Origin;
   var Horsepower Weight Mpg_Highway;
run;

/**************************************************************************************
                          EJERCICIOS DATASET SPOTIFY 2023
**************************************************************************************/
/*Se asigna la biblioteca eda donde almacenaremos los datasets*/
libname eda '/home/u61536033/sasuser.v94/Modulo2/Clase1/Datasets';
run;

/**************************************************************************************
                                     EJERCICIO 1
***************************************************************************************/
/*Mínima, máxima y promedio de la cantidad de reproducciones de las canciones  */
proc means data=eda.spotify2023 min max mean;
	var streams;
run;
/* Moda, promedio, varianza, desviación estándar y error estándar de las palabras que aparecen*/
proc means data=eda.spotify2023 mode mean var std stderr;
	var speechiness;
run;
/* Los dos incisos combinados con info extra */
proc means data=eda.spotify2023 min max mean mode var std stderr;
	var streams speechiness;
run;
/****************************************************************************************
                                       EJERCICIO 2
****************************************************************************************/
/* Se ordena primero el dataset por artistas */
proc sort data=eda.spotify2023 out=eda.spotifysortedart;
	by artist_name;
run;
/* Usando el proc MEANS
Se calculan las medidas de tendencia central y medidas de dispersión del número de listas de reproducción pr artistas */
proc means data=eda.spotifysortedart mean median mode min max var std stderr;
	var in_spotify_playlists in_apple_playlists in_deezer_playlists;
	by artist_name;
run;
/* Se calculan las medidad de tendencia central y mediddas de dispersión del número de listas de reproducción  */
proc means data=eda.spotifysortedart mean median mode min max var std stderr;
	var in_spotify_playlists;
run;
/* proc univariate para la generación del histograma del número de listas de reprodiccoón con medidas de tendencia central
 y de distribución */
proc univariate data=eda.spotify2023 noprint;
	var in_spotify_playlists;
	histogram in_spotify_playlists;
	inset mean std min max median stderr var mode / position=ne;
run;

/*********************************************************************************************************
                                    Análisis de Distribución
*********************************************************************************************************/
/* Se usará también el proc univariate para generar gráficos descriptivos para analizar la distribución */

/* Generación de histograma y gráfico de probabilidad */
proc univariate data=SASHELP.PRICEDATA;
	var sale;
	histogram sale;
	probplot sale;
	qqplot sale;
run;

/*Generación de histograma*/
title "proc univariate para obtener el histograma";
proc univariate data=SASHELP.PRICEDATA;
	ods select Histogram;
	var sale;
	histogram sale;
run;

/* Generación de histograma y test de bondad de ajuste */
title "proc univariate para obtener el histograma y test de bondad de ajuste";
proc univariate data=sashelp.pricedata;
	ods select Histogram GoodnessOfFit;
	var sale;
	/* Ajustamos para que sea de acuerdo a la distribución normal*/
	histogram sale / normal(mu=est sigma=est);
run;

/* Generación de histograma, test de bondad de ajuste y gráfico de probabilidad normal */
title "proc univariate para obtener el histograma, test de bondad de ajuste y gráfico de probabilidad normal";
proc univariate data=sashelp.pricedata;
	ods select Histogram GoodnessOfFit Probplot;
	var sale;
	/* Ajustamos para que sea de acuerdo a la distribución normal la prueba de ajuste y
	el gráfico de probabilidad*/
	histogram sale / normal(mu=est sigma=est);
	probplot sale / normal(mu=est sigma=est);
run;

/* Generación de histograma, test de bondad de ajuste, gráfico de probabilidad normal, gráfico de cuantiles */
title "proc univariate para obtener el histograma, test de bondad de ajuste, gráfico de probabilidad normal y gráfico de cuantil-cuantil";
proc univariate data=sashelp.pricedata;
	ods select Histogram GoodnessOfFit Probplot QQPlot;
	var sale;
	/* Ajustamos para que sea de acuerdo a la distribución normal la prueba de ajuste y
	el gráfico de probabilidad*/
	histogram sale / normal(mu=est sigma=est);
	probplot sale / normal(mu=est sigma=est);
	qqplot sale / normal(mu=est sigma=est);
run;

/*********************************************************************************************************************
                                proc means vs proc univariate
*********************************************************************************************************************/
/* Cálculo de percentiles con proc means de los percentiles 5,25,75 y 95 */
proc means data=sashelp.cars noprint; 
var mpg_city mpg_highway;
output out=pctlsMeans P5= P25= P75= P95= / autoname;
run;
/* Le damos formato para que lo muestre no como dataset*/ 
proc print data=pctlsMeans noobs; 	
run;

/* Cálculo de percentiles no admitidos por proc means como 4 que lo cambia por 40*/
proc means data=sashelp.cars noprint; 
var mpg_city mpg_highway;
output out=pctlsMeans P4= P25= P75= P95= / autoname;
run;
/* Le damos formato para que lo muestre no como dataset*/ 
proc print data=pctlsMeans noobs; 	
run;

/* Cálculo de percentiles no admitidos por proc means como 12 que lo cambia por 1*/
proc means data=sashelp.cars noprint; 
var mpg_city mpg_highway;
output out=pctlsMeans P12= P25= P75= P95= / autoname;
run;
/* Le damos formato para que lo muestre no como dataset*/ 
proc print data=pctlsMeans noobs; 	
run;

/* Cálculo de percentiles no admitidos por proc means como 4 y 12 que lo cambia por 1 */
proc means data=sashelp.cars noprint; 
var mpg_city mpg_highway;
output out=pctlsMeans P4= P12= P25= P75= P95= / autoname;
run;
/* Le damos formato para que lo muestre no como dataset*/ 
proc print data=pctlsMeans noobs; 	
run;

/*Otra forma de obtener los percentiles*/
proc means data=sashelp.cars StackODSOutput P5 P25 P75 P95; 
var mpg_city mpg_highway;
ods output summary=LongPctls;
run;
/* Cambian los nombres de los percentiles */
proc print data=LongPctls noobs;run;

/*proc univariate para obtener percentiles dados por el usuario*/
proc univariate data=sashelp.cars noprint;
var mpg_city mpg_highway;
output out=UniPctls pctlpre=CityP_ HwyP_ pctlpts=4,12,65,97.5; 
run; 
proc print data=UniPctls noobs; run;

/* proc univariate para obtener percentiles dados por el usuario */
proc stdize data=sashelp.cars PctlMtd=ORD_STAT outstat=StdLongPctls
           pctlpts=4,12,65,97.5;
var mpg_city mpg_highway;
run;
/* El tipo P es el que incluye los percentiles */
proc print data=StdLongPctls noobs;
where _type_ =: 'P';
run;

/* Obtención de puntos extremos con proc univariate se pueden obtener valores 
repetidos*/
title 'Observaciones extremas en las variables mpg_city y mpg_highway';
ods select ExtremeObs;
proc univariate data=sashelp.cars;
   var mpg_city mpg_highway;
run;

/* Obtención de valores y orden de puntos extremos con proc univariate no se obtienen valores
repetidos  */
title 'Valores extremos en las variables';
ods select ExtremeValues;
proc univariate data=sashelp.cars nextrval=5;
   var mpg_city mpg_highway;
run;