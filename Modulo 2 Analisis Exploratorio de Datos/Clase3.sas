/***************************************************************************************************************
									Estadística no paramétrica
***************************************************************************************************************/
/*Definición de librería*/
libname eda '/home/u61536033/sasuser.v94/Modulo2/Clase3/Datasets';

/****** Análisis de varianza (ANOVA) con factor paramétrico ******/
/*proc glm para realizar ANOVA con factor paramétrico sin la sentencia class
MARCA ERROR por cuestión de sintáxis */
proc glm data=eda.grades;
	model grade = group;
run;

/*proc glm para realizar ANOVA con factor paramétrico donde especificamos la variable de 
clasificación group*/
proc glm data=eda.grades;
	class group;
	model grade = group;
run;

/*proc glm para realizar ANOVA con factor paramétrico donde especificamos la variable de clasificación group
y agregamos la sentencia means para revisar los parámteros de la media y desviación estándar.*/
proc glm data=eda.grades;
	class group;
	model grade = group;
	means group;
run;

/*proc glm para realizar ANOVA con factor paramétrico donde especificamos la variable de clasificación group, 
agreamos la sentencia means para realizar pruebas t de tukey para comparar las medias.*/
proc glm data=eda.grades;
	class group;
	model grade = group;
	means group / tukey;
run;

/*proc glm para realizar ANOVA con factor paramétrico donde especificamos la variable de clasificación group,
agregamos la sentencia means para realizar pruebas t para comparar las medias. */
proc glm data=eda.grades;
	class group;
	model grade = group;
	means group / t;
run;

/*proc glm para realizar ANOVA con factor paramétrico donde especificamos la variable de clasificación group,
agregamos la sentencia means para realizar pruebas t para comparar las medias. */
proc glm data=eda.grades;
	class group;
	model grade = group;
	means group / lsd;
run;

/*proc glm para realizar ANOVA con un factor paramétrico donde especificamos la variable de clasificación group,
agregamos la sentencia means para realizar pruebas t de sidak para comparar las medias*/
proc glm data=eda.grades;
	class group;
	model grade = group;
	means group / sidak;
run;

/****** Análisis de varianza (ANOVA) con factor no paramétrico ******/

/*proc npar1way sirve para realizar análisis ANOVA con factor no paramétrico y muestra también los análisis de
prueba de Kruskal-Wallis, Wilcoxon, Mediana, Van der Waerden VM, Puntuaciones Savage (Exponenciales) y el
análisis empírico de la función de distribución (EDF)*/
proc npar1way data=eda.grades;
	class group;
	var grade;
run;

/*proc sort para ordenar el dataset de cars por origen*/
proc sort data=sashelp.cars out=eda.carsOrdered;
	by origin;
run;

/* proc npar1way para realizar análisis con factor no paramétrico de ANOVA, prueba de 
Kruskal-Wallis, Wilcoxon, Mediana, Van der Waerden VM, Puntuaciones Savage (Exponenciales) y el
análisis empírico de la función de distribución (EDF)  */
proc npar1way data=eda.carsOrdered;
	by origin;
	class type;
	var horsepower;
run;


/*************************************************************************************************
							Regresión Lineal
*************************************************************************************************/
/***********Regresión Lineal con proc reg ***************/
/*proc reg para el análisis con regresión lineal donde establecemos la relación de que el peso es
variable dependiente de la altura.*/
proc reg data=sashelp.class;
	model weight = height;
run;
/* proc reg para el análisis con regresión lineal donde establecemos la relación de que el peso
es variable dependiente de la altura y edad*/
proc reg data=sashelp.class;
	model weight = height age;
run;

/* proc sort para ordenar el dataset de class por sexo*/
proc sort data=sashelp.class out=eda.classOrdered;
	by sex;
run;
/* proc reg par el análisis con regresión lineal donde establecemos la relación de que el peso
depende de la altura y edad, por sexo.*/
proc reg data=eda.classOrdered;
	by sex;
	model weight = height age;
run;

/*proc reg donde establecemos dos modelos para la variable peso, en los cuales:
model 1: peso depende de la altura
model 2: peso depende de la altura y de la edad*/
proc reg data=eda.classordered;
	model weight = height;
	model weight = height age;
run;

/* proc reg donde establecemos dos modelos para la variable peso por sexo en los cuales:
Para el sexo femenino:
	* model 1: peso depende de la altura.
	* model 2: peso depende de la altura y de la edad
Para el sexo masculino:
	* model 1: peso depende de la altura.
	* model 2: peso depende de la altura y edad.*/
proc reg data=eda.classordered;
	by sex;
	model weight = height;
	model weight = height age;
run;

/*proc reg donde establecemos dos modelos para la variable peso por sexo, sin gráficos.*/
proc reg data=eda.classordered plots=none;
	by sex;
	model weight = height;
	model weight = height age;
run;

/***********Regresión Lineal con proc glm ***************/

proc glm data=sashelp.class;
	model weight = height;
run;



/***********************************************************************************************************
										Regresión no Lineal
***********************************************************************************************************/
/* Creación de un dataset de forma manual*/
data eda.ejemplo;
input x y;
datalines;
1 10
2 20
3 30
4 40
5 50
;
run;
/* proc nlin para ajustar los valores de a y b con regresión no lineal a un modelo exponencial
con el método de optimización por omisión que es gauss.*/
proc nlin data=eda.ejemplo;
	parms a=1 b=1;
	model y = a * exp(b * x);
run;

/* proc nlin para ajustar los valores de a y b con regresión no lineal a un modelo exponencial
con el método de optimización  gauss*/
proc nlin data=eda.ejemplo method=gauss;
	parms a=1 b=1;
	model y = a * exp(b * x);
run;

/* proc nlin para ajustar los valores de a y b con regresión no lineal a un modelo exponencial
con el método de optimización gradiente*/
proc nlin data=eda.ejemplo method=gradient;
	parms a=1 b=1;
	model y = a * exp(b * x);
run;
/* proc nlin para ajustar los valores de a y b con regresión no lineal a un modelo exponencial
con el método de optimización marquardt.*/
proc nlin data=eda.ejemplo method=marquardt;
	parms a=1 b=1;
	model y = a * exp(b * x);
run;

/* proc nlin para ajustar los valores de a y b con regresión no lineal a un modelo exponencial
con el método de optimización de newton*/
proc nlin data=eda.ejemplo method=newton;
	parms a=1 b=1;
	model y = a * exp(b * x);
run;

/************************************************************************************************************
							Regresión Logística
************************************************************************************************************/

/*Creación de dataset a mano sobre las horas de estudio de un grupo de estudiante y si aprobaron o no su 
examen
En aprobado 0 - no aprobó
            1 - sí aprobó*/
data eda.ejemplo2;
	input horas_estudio aprobado @@;
	datalines;
	1 0
	2 0
	3 0
	4 1
	5 1
	6 1
	7 1
	8 1
	9 1
	10 1
;
run;

/* proc logistic para el estudio de la variable dependiente aprobado a partir de las horas de estudio de los 
estudiantes y sirve para predecir si aprobarán o no.*/
proc logistic data=eda.ejemplo2;
	model aprobado(event='1') = horas_estudio / link=logit;
run;

/**********************************************************************************************************
						Tablas de contingencia
**********************************************************************************************************/
/* proc freq para generar la tabla de contingencia que muestra la relación entre las variables
origen y tipo. Además, incuye la prueba de independencia de chi-cuadrado con CHISQ*/
proc freq data=sashelp.cars;
	tables origin * type / CHISQ;
run;

/*  proc tabulate para generar la tabla de contingencia con el resumen de la media de la variable
caballos de fuera para cada tipo de auto*/
proc tabulate data=sashelp.cars;
	class type;
	var horsepower;
	table type, horsepower*(mean);
run;

/*************************************************************************************************
							Ejercicio del dataset Classfit
*************************************************************************************************/

/* Ejercicio 1 punto 1*/
proc glm data=sashelp.classfit;
	class age;
	model height = age;
	means age / t;
run;

/* Punto 2*/

proc sort data=sashelp.classfit out=eda.classfitordered;
	by sex;
run;

proc npar1way data=eda.classfitordered;
	by sex;
	class age;
	var weight;
run;


/* Punto 3*/

proc reg data=eda.classfitordered;
	by sex;
	model weight=height;
run;

proc reg data=eda.classfitordered;
	by sex;
	model weight = height age;
run;

proc reg data=eda.classfitordered;
	by sex;
    model weight = height;
	model weight = height age;
run;
/* Nombramos a cada uno de los modelos establecidos*/
proc reg data=eda.classfitordered;
	by sex;
	modelo1: model weight = height;
	modelo2: model weight = height age;
run;

/*****************************************************************************************************
							Muestreo
*****************************************************************************************************/
/*  Muestreo simple */

/*proc surveyselect para generar una muestra del dataset spotify2023 donde obtuvimos
un dataset nuevo (muestra) con un total del 10% de canciones*/
proc surveyselect data=eda.spotify2023
	method=srs
	samprate=0.10
	out=eda.muestraSimple10;
run;

/*proc surveyselect para generar una muestra del dataset spotify2023 donde obtuvimos
un dataset nuevo (muestra) con un total del 30% de las canciones*/
proc surveyselect data=eda.spotify2023
	method=srs
	samprate=0.30
	out=eda.muestrasimple30;
run;

proc surveyselect data=eda.spotify2023
	method=srs
	samprate=0.70
	out=eda.muestrasimple70;
run;

/* Se genera una muestra simple aleatoria "a mano", es decir, de modo no formal una muestra
creando un nuevo dataset con la ayuda de la función ranuni que sirve para números aleatorios
uniformes y estableciendo una condición para obtener el 20% de las canciones.
A diferencia del proc surveyselect no muestra información sobre la generación de este dataset*/
data eda.muestrasimple20;
	set eda.spotify2023;
	/*Condición para obtener un 20% de las canciones*/
	if ranuni(0) < 0.20 then output;
run;