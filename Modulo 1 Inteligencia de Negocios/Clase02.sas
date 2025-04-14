/*
DIPLOMADO EN MINERÍA DE DATOS CON SAS
CLASE 2
23 DE SEPTIEMBRE DE 2023
*/




*Crear biblioteca de entrada (donde estan los datasets);
libname e '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets';
*Crear biblioteca de salida (donde guardaremos los datasets);
libname s '/home/u61754732/sasuser.v94/Modulo1/C2';
/*
Si se ejecuto exitosamente debe mandar el mensaje en la ventana LOG
*/




/*
Aplicar formato de entrada y o salida a los datos
Usaremos el archivo de ancho fijo llamado nomina
*/
data s.nomina;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/nomina.txt';
input @1 id @7 nombre $ @27 apellido $ @47 fecha @59 salario;
run;
/*
En esta lectura de datos las columnas fecha y salario no se leyeron correctamente y en el dataset aparecen como .
El problema es que estas columnas traen un formato de fecha y dinero, el cual no reconoce SAS
*/




/*
INFORMAT: Se puede resolver el problema de formato en la fecha y salario en la entrada utilizando informat.
Con INFORMAT se puede también resolver el problema de truncamiento.
Los numero indican la longitud de la cadena, al poner el "." se indica que es un formato
*/
data s.nomina;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/nomina.txt';
informat id 6. nombre $20. apellido $20. fecha ddmmyy10. salario dollar14.2;
input @1 id @7 nombre $ @27 apellido $ @47 fecha @59 salario;
run;
/*
Con esto ya hace la lectura de la manera correcta, pero al desplegar los datos vemos que la columna fecha y la columna salario
las muestra sin el formato correcto
*/




/*
FORMAT: La setencia de SAS para dar formato de salida a los datos.
*/
data s.nomina;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/nomina.txt';
informat id 6. nombre $20. apellido $20. fecha ddmmyy10. salario dollar14.2;
format   id 6. nombre $20. apellido $20. fecha ddmmyy10. salario dollar14.2;
input @1 id @7 nombre $ @27 apellido $ @47 fecha @59 salario;
run;




/*
Cambiar el formato de salida de la variable fecha de ddmmyy a mmddyy
*/
data s.nomina;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/nomina.txt';
informat id 6. nombre $20. apellido $20. fecha ddmmyy10. salario dollar14.2;
format   id 6. nombre $20. apellido $20. fecha mmddyy10. salario dollar14.2;
input @1 id @7 nombre $ @27 apellido $ @47 fecha @59 salario;
run;




/*
Mostrar la fecha en formato largo
*/
data s.nomina;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/nomina.txt';
informat id 6. nombre $20. apellido $20. fecha ddmmyy10. salario dollar14.2;
format   id 6. nombre $20. apellido $20. fecha worddate. salario dollar14.2;
input @1 id @7 nombre $ @27 apellido $ @47 fecha @59 salario;
run;




/*
Mostrar la fecha en formato largo pero en Español
*/
data s.nomina;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/nomina.txt';
informat id 6. nombre $20. apellido $20. fecha ddmmyy10. salario dollar14.2;
format   id 6. nombre $20. apellido $20. fecha espdfwdx. salario dollar14.2;
input @1 id @7 nombre $ @27 apellido $ @47 fecha @59 salario;
run;




*********************************MANEJO DE ARCHIVOS DE DIFERENTE FORMATO***************************************;

/*
Leer el archivo separado por comas "AutosComa.csv"
*/
data s.autoscoma;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/AutosComa.csv'  dlm=',';
input  nombre $ tipo $ avg airbag $ cilindros;
run;
/*
Al desplegar los datos muestra truncada la columna nombre y airbag, esto se arregla con un 
format (El problema no es en la lectura si no en el despliegue de la información, ya que al hacer la lectura 
con el separador "," no hay truncamiento)
*/



/*
Leer el archivo separado por comas "AutosComa.csv"
FORMAT para desplegar correctamente las columnas y ordenarlas de manera personalizada
*/
data s.autoscoma;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/AutosComa.csv'  dlm=',';
format airbag $15. nombre $30. ; 
input  nombre $ tipo $ avg airbag $ cilindros;
run;
/*
Ya que en la sentencia FORMAT colocamos airbag y nombre, al desplegar el dataset estas columnas se muestran primero
*/




/*
Lectura del archivo separado por tabulacion "AutosTab.TSV"
*/
data s.autostab;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/AutosTab.tsv' dlm='09'x;
format airbag $15. nombre $30.; 
input  nombre $ tipo $ avg airbag $ cilindros;
run;
/*
Para indicar que se trata de un archivo separado por tabulacion se pone dlm='09'x
*/




/*
Lectura del archivo separados por comas "AutosComa2.csv"
Este archivo no tienen encabezados y tiene formato de entrada en columna avg
*/
data s.autoformato2;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/AutosComa2.csv' dlm=',';
format nombre $30.
       tipo $8.
       avg dollar5.1
       airbag $15.
       cilindros 1.;
input nombre $ tipo $ avg airbag $ cilindros;
run;
/*
Al desplegar la información muestra la columna avg como .
Esto se debe corregir usando INFORMAT
*/




/*
Lectura del archivo separados por comas "AutosComa2.csv"
Este archivo no tienen encabezados y tiene formato de entrada en columna avg
*/
data s.autoformato2;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/AutosComa2.csv' dlm=',';
format nombre $30.
       tipo $8.
       avg dollar5.1
       airbag $15.
       cilindros 1.;
informat avg dollar5.1;
input nombre $ tipo $ avg airbag $ cilindros;
run;




/*
Importar datos desde un archivo EXCEL
Hay dos formas:
	1.-Importar el conjunto de datos a través de una biblioteca SAS
	2.-Importar los datos a SAS a traves de un proceso de importación
*/




/*
1.-Importar el conjunto de datos a través de una biblioteca de SAS

Permite traer las hojas que se encuentran en un libro de excel, pero no se pueden modificar, solo se pueden visualizar,
ya que los datos no pertenecen a SAS pues no pasaron por el paso data.
Estos los podemos visualizar en la carpeta librerías -> Mis librerías -> AUTO

En SAS instalado de manera local debemos usar: 
libname auto excel '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/Autos.xlsx';
*/
libname auto xlsx '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/Autos.xlsx';




/*
2.-Importar los datos a SAS a traves de un proceso de importación

Esto se hace a través del PROC IMPORT
Si usamos SAS instalado de manera local usariamos:
proc import out=s.autosexcel 
datafile='/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/Autos.xlsx' dbms=excel replace;
range="Autos$";
getnames=yes;
run;
*/
proc import out=s.autosexcel 
datafile='/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/Autos.xlsx' dbms=xlsx replace;
sheet="Autos";
getnames=yes;
run;




/*
Usar un proc contents para ver el contenido del dataset
*/
proc contents data=s.autosexcel;
run;




/*
Importar datos que no son de Excel a un dataset a SAS
Importaremos datos en formato CSV usando proc import
*/
proc import out=s.autoscsv
datafile = '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/AutosCSV1.csv' dbms=csv replace;
getnames=no;
datarow=1;
run;



/* *****************************MANIPULACION DE DATASET CON SAS************************************************* */
/* 	Para poder manipular un dataset es necesario que ya exista en SAS
	Los dataset que ya existen en SAS tiene la extensión .sas7bdat
*/



/*
Crear un dataset a partir de otro dataset
Obtenemos una copia completa del dataset autoscsv
*/
data s.autosn; 		*Donde lo guardamos;
set s.autoscsv; 	*De donde lo tomamos;
run;




/*
Crear un dataset a partir de otro dataset
Renombrar los nombres de las variables AL INICIO
*/
data s.autosn;
set s.autoscsv (rename=(var1=Nombre var2=Tipo var3=avg var4=airbag));
run;




/*
Crear un dataset a partir de otro dataset
Renombrar los nombres de las variables AL FINAL
*/
data s.autosn (rename=(var1=Nombre var2=Tipo var3=avg var4=airbag));
set s.autoscsv ;
run;




/*
Crear un dataset a partir de otro dataset
Mantener solo un subconjunto de variables, desde el INICIO
Es decir, entre la sentencia SET y la sentencia RUN, todo el procesamiento de variables que se haga
ya solo puede ocupar las variables que se seleccionaron.
*/
data s.autoskeep;
set s.autosexcel (keep= nombre tipo avg cilindros tanque_gal pasajeros);
run;




/*
Crear un dataset a partir de otro dataset
Mantener solo un subconjunto de variables, al FINAL
Es decir, entre la sentencia SET y la sentencia RUN, todo el procesamiento de variables que se haga
si puede ocupar las variables originales del dataset, porque el filtrado de variables ocurre hasta el final
del todos los procedimientos.
*/
data s.autoskeep (keep= nombre tipo avg cilindros tanque_gal pasajeros);
set s.autosexcel;
run;




/*
Eliminar un subgrupo de variable con DROP
Borrar variables desde el INICIO (en la sentencia SET)
*/
data s.autosdrop;
set s.autosexcel (drop=max min motor_litros hp rpm_max rpm_crus);
run;




/*
Eliminar un subgrupo de variable con DROP
Borrar variables al FINAL (en la sentencia DATA)
*/
data s.autosdrop (drop=max min motor_litros hp rpm_max rpm_crus);
set s.autosexcel;
run; 




/*
Crear dataset a partir de archivos Excel, definidos como biblioteca
Obtener un subgrupo de las variables del dataset original
Renombrar una variables del dataset original
*/
data s.autos (rename=(avg=precio));
set auto.autos (keep=nombre tipo avg max min airbag cilindros motor_litros transmision pasajeros extranjero);
run;




/*
Hasta ahora hemos podido tomar subgrupo de variables, pero también es posible tomar subgrupos de observaciones (filas)
*/




************************************** PROCESAMIENTO CONDICIONAL***********************;
/*
Se refiere a la capacidad que tiene un programa para tomar decisiones basadas en el valor de los datos.
A partir de las estructuras de decision es posible;
	1.-Generar y asignar un valor a nuevas variables
	2.-Seleccionar un subconjunto de observaciones
	3.-Determinar si los valores de las variables entan dentro del rango permitido
Las herramientas que proporciona SAS son 
	IF
	IF-ELSE
*/




/*
AGREGAR NUEVAS VARIABLES
Por ejemplo: Modificar una variable numerica
*/
data s.autosvar;
set s.autos;
*Preservar las variables anteriores;
max_ant=max;
precio_ant=precio;
*Actualizar las variables;
max = max * 1.04;
precio=mean(min,max);
run;




/*
AGREGAR NUEVAS VARIABLES
Por ejemplo: Modificar una variable numerica
También se agrega el formato a los precio
*/
data s.autosvar;
set s.autos;
format max_ant dollar12.2 precio_ant dollar12.2;
*Preservar las variables anteriores;
max_ant=max;
precio_ant=precio;
*Actualizar las variables;
max = max * 1.04;
precio=mean(min,max);
run;




/*
Operador Relacional			Simbolo			Mnemonico Equivalente		PROC SQL

Igual						=				EQ
Diferente					^=				NE							<>
Menor que					<				LT
Mayor que					>				GT
Menor o igual 					<=				LE
Mayor o igual 					>=				GE
Igual a uno en la lista				IN				
En un rango					BETWEEN			

NOTA: El operador BETWEEN no es valido en el paso de datos.
Solo lo podremos usar en el PROC SQL
*/



/*
********** OPERADORES LOGICOS **********
& 	AND
|	OR
~	NOT
^	NOT
*/



/*
*********** IF ***********
UNA SENTENCIA				VARIAS SENTENCIAS

IF condicion THEN;			IF condicion THEN DO;
	sentencia_1;				sentencia_1;
						sentencia_2;
						...
						sentencia_n;
						END;
*/




/*
*********** IF - ELSE ***********
UNA SENTENCIA				VARIAS SENTENCIAS

IF condicion THEN;			IF condicion THEN DO;
	sentencia_1;				sentencia_1;
ELSE sentencia_1;				sentencia_2;
						...
						sentencia_n;
					END;
					ELSE DO;
						sentencia_n+1;
						sentencia_n+2;
						...
						sentencia_n+m;
					END
*/




/*
Uso de IF
Crear una nueva variable llamada gama y darle un valor segun el valor de la columnas precio:
baja: 	[7-15]
media:  (15,35]
alta: 	(35,+infinito)
*/
data s.autosgama;	*Donde se guardará el nuevo dataset;
set s.autos;		*A partir de se crea el nuevo dataset;
length gama $10.; 	*Definir la variable como cadena de longitud 10 bytes;
if precio >= 7 and precio <= 15 then gama = 'Baja';
if precio >15  and precio <=35  then gama = 'Media';
if precio >35                   then gama = 'Alta';
run;




/*
Uso de IF ELSE

Crear una nueva variable llamada gama y darle un valor segun el valor de la columnas precio:
baja: 	[7-15]
media:  (15,35]
alta: 	(35,+infinito)
*/
data s.autosgama;
set s.autos;
length gamma $10.;
if precio >= 7 and precio <= 15 	then gama = 'Baja';
else if precio >15  and precio <=35  	then gama = 'Media';
else if precio >35                   	then gama = 'Alta';
run;




/*
Aplicar un descuento en el precio del 10% para todos
*/
data s.autosgama;
set s.autos;
length gama $10.;
format precio_ant dollar10.2;		*Crear el formato para la nueva columna precio_ant;
if precio >= 7 and precio <= 15 	then gama = 'Baja';
else if precio >15  and precio <=35  	then gama = 'Media';
else if precio >35                   	then gama = 'Alta';
precio_ant = precio;			*Crear la variable para guardar el precio anterior;
precio = precio_ant * 0.9;		*Aplicar el descuento del 10% al precio anterior;
run;



/*
Aplicar un descuento en funcion de la gama del auto;
Gama baja 	- Descuento del 5%
Gama media 	- Descuento del 8%
Gama baja 	- Descuento del 10%
Además el precio lo vamos a multiplicar por 10,000

*/
data s.autosgama;
set s.autos;
length gama $10.;
format precio_ant dollar10.2;	*Crear el formato para la nueva columna precio_ant;
precio_ant = precio;			*Crear la variable para guardar el precio anterior;
if precio >= 7 and precio <= 15 	then do;
	gama = 'Baja';
	precio = precio * 0.95 * 10000;					*Aplicar descuento segun la gama;
end;
else 	if precio >15  and precio <=35  then do;
			gama = 'Media';
			precio = precio * 0.92 * 10000;			*Aplicar descuento segun la gama;
end;
else 	if precio >35                 	then do;
			gama = 'Alta';
			precio = precio * 0.9 * 10000;			*Aplicar descuento segun la gama;
end;
run;




/*
Suponer que si la gama del auto es MEDIA y ((el tamaño del auto es MIDSIZE de 6 pasejeros) o de tamaño LARGE),
asignaremos una variable regalo, con el valor de RADIO MP3. Para todos los demas el valor del regalo 
es NO APLICA.
*/
data s.autosgama;
set s.autos;
length gama $10. regalo $10.; 					*Crear el formato para la nueva columna gama y regalo;
format precio_ant dollar10.2;					*Crear el formato para la nueva columna precio_ant;
precio_ant = precio;						*Crear la variable para guardar el precio anterior;
if precio >= 7 and precio <= 15 then do;
	gama = 'Baja';
	precio = precio * 0.95 * 10000;					*Aplicar descuento segun la gama;
	regalo = 'No Aplica';						*Tipo de regalo para gama baja;
end;
else 	if precio >15  and precio <=35  then do;
			gama = 'Media';
			precio = precio * 0.92 * 10000;			*Aplicar descuento segun la gama;
			if (tipo = 'Midsize' & pasajeros = 6) | (tipo='Large') then regalo = 'Estereo MP3';
			else regalo = 'No Aplica';
	end;
else 	if precio >35                 	then do;
			gama = 'Alta';
			precio = precio * 0.9 * 10000;			*Aplicar descuento segun la gama;
			regalo = 'No Aplica';				*Tipo de regalo para gama baja;
	end;
run;




/* 
*************************************************************************************************************
                                          OBTENER SUBCONJUNTOS DE OBSERVACIONES 
*************************************************************************************************************
*/





/*
Obtener un dataset con observaciones (filas) que cumplan ambas condiciones:
	(a) Tipo 'Small' o tipo 'Compact'
	(b) 5 o 6 pasajeros
Usando solamente operador |
*/
data s.autospeques;   								*Donde se guardara el nuevo dataset;
set s.autos;									*Dataset donde nos basaremos;
if 	(tipo = 'Small' | tipo='Compact') & (pasajeros=5 | pasajeros =6); 	*Para obtener las filas solo basta poner la condicion;
run;	




/*
Obtener un dataset con observaciones (filas) que cumplan ambas condiciones:
	-Tipo 'Small' o tipo 'Compact'
	-5 o 6 pasajeros
Usando operador IN
*/
data s.autospeques;   						*Donde se guardara el nuevo dataset;
set s.autos;							*Dataset donde nos basaremos;
if 	(tipo IN ('Small','Compact')) & (pasajeros IN (5,6)); 	*Para obtener las filas solo basta poner la condicion;
run;




/*
Obtener un dataset con las observaciones que cumplan la siguiente condicion:
	-Tipo es distinto a 'Small' y distinto a 'Compact'
	-5 o 6 pasajeros
*/
data s.autosnopeques;										*Donde se guardara el nuevo dataset;
set s.autos;												*Dataset donde nos basaremos;
if tipo NOT IN ('Small','Compact') & pasajeros IN (5,6);	*Para obtener las filas solo basta poner la condicion;
run;




/*
Obtener un dataset con las observaciones que cumplan la siguiente condicion:
	-Tipo es 'Large'o 'Midsize'
*/
data s.autosnopeques;										*Donde se guardara el nuevo dataset;
set s.autos;												*Dataset donde nos basaremos;
if tipo IN ('Large','Midsize'); 							*Para obtener las filas solo basta poner la condicion;
run;




/*
Obtener un dataset con las observaciones que cumplan la siguiente condicion:
	-Tipo es 'Large'o 'Midsize'
Usando WHERE
*/
data s.autosml;												*Donde se guardara el nuevo dataset;
set s.autos;												*Dataset donde nos basaremos;
WHERE tipo IN ('Large','Midsize'); 							*Usando Where es mas rapido;
run;




/*
Obtener un dataset que OMITA las observaciones con las siguientes caracteristicas:
	-(no. cilindros = 4 y extranjero = 'Foreign' ) o (no tengan bolsa de aire)
Usando IF y la clausula DELETE
*/
data s.autosno4;
set s.autos;
IF (cilindros IN (4) & extranjero = 'Foreign') OR (Airbag = 'None') THEN delete;
run;




/*
SELECT y WHEN.
Aplicar un descuento en funcion de la gama del auto;
Gama baja 	- Descuento del 5%
Gama media 	- Descuento del 8%
Gama baja 	- Descuento del 10%
Además multiplicar el precio por 10,000
*/
DATA s.autoselect;		*Donde se guardara el nuevo dataset;
SET s.autos;			*En que dataset nos basaremos para crear el nuevo dataset;
LENGTH gama $10.;		*Que la nueva variable gama tenga espacio para 10 bytes por default;

SELECT;
WHEN (precio >= 7 & precio <= 15) DO;		*En todos los WHEN las condiciones debe ir entre parentesis;
	gama='Baja';
	precio = precio * 0.95 * 10000;
END;
WHEN (precio >= 15 & precio <=35) DO;
	gama='Media';
	precio = precio * 0.92 * 10000;
END;
WHEN (precio > 35) DO;
	gama='Alta';
	precio=precio*0.9*10000;
END;

END;						/*Tambien se debe cerrar el sel3ct*/								
RUN;




/*
DISTRIBUIR DATASETS A PARTIR DE UNA VARIABLE
El dataset autosgama ya tiene la columna gama con las categorias de auto
Ejercicio:Obtener un dataset para cada una de las gamas de los autos
*/

data s.autosbaja s.autosmedia s.autosalta;		*Donde se guardaran los datasets nuevos;
set s.autosgama;								*Dataset donde nos basamos para crear los nuevos datasets;
IF 		gama = 'Baja'  THEN output s.autosbaja;				*Guardar los autos de gama baja;
ELSE IF gama = 'Media' THEN OUTPUT s.autosmedia;			*Guardar los autos de gama media;
ELSE IF gama = 'Alta'  THEN OUTPUT s.autosalta;				*Guardar los autos de gama alta;
RUN;




/*
DISTRIBUIR DATASETS A PARTIR DE UNA VARIABLE
El dataset autosgama tiene la columna cilindros
Ejercicio:Obtener un dataset para cada uno de los numeros de cilindros
*/
data s.autos4 s.autos6 s.autos8;				*Donde se guardaran los datasets nuevos;
set s.autosgama;								*Dataset donde nos basamos para crear los nuevos datasets;

SELECT(cilindros);                              *Atajo para indicar que la condicion es sobre la variable cilindro;

WHEN (4) OUTPUT s.autos4;						*Se guarda cada observacion en un dataset segun el numero de cilindros;
WHEN (6) OUTPUT s.autos6;
WHEN (8) OUTPUT s.autos8;
OTHERWISE;										*Se puede agregar una sentencia para aquellos que no cumplan los when;

END;
RUN;





/*****************PARA REVISAR EN CASA***********************/

******** No olvides crear tus bibliotecas de entrada y de salida;
libname e '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets';
libname s '/home/u61754732/sasuser.v94/Modulo1/C2';


* Ejecuta el siguiente código y analiza la salida, ¿qué observas?;
* ¿Qué pasa con las observaciones, por ejemplo, 4, 7, 9?;
* ¿Tiene sentido el valor de la variable regalo para estas observaciones?;
data s.autosgama;
set e.autos2;
length gama $8.
       regalo $20.;
precio_ant = precio;
format precio_ant dollar10.2;
if precio >= 7  and precio <= 15 then do;
	gama = 'Baja';
	precio = precio * 0.95 * 10000;
	regalo = 'No Aplica';
end;
else if precio gt 15 & precio le 35  then do;
	gama = 'Media';
	precio = precio * 0.92 * 10000;
	if tipo = 'Midsize' & pasajeros = 6 | tipo = 'Large' then
		regalo = 'Estereo MP3';
	else regalo = 'No aplica';
end;
else if precio >= 35 then do;
	gama = 'Alta';
	precio = precio * 0.9 * 10000;
	regalo = 'No Aplica';
end;
run;






* Ejecuta el siguiente código y observa si las inconsistencias del anterior se presentan?
  ¿Mejoró la salida? ¿Cómo se logró?;
data s.autosgama;
set e.autos2;
length gama $8.
       regalo $20.;
precio_ant = precio;
format precio_ant dollar10.2;
if precio >= 7  and precio <= 15 then do;
	gama = 'Baja';
	precio = precio * 0.95 * 10000;
	regalo = 'No Aplica';
end;
else if precio gt 15 & precio le 35  then do;
	gama = 'Media';
	precio = precio * 0.92 * 10000;
	if not missing(tipo) then
		if tipo = 'Midsize' & pasajeros = 6 | tipo = 'Large' then
			regalo = 'Estereo MP3';
		else regalo = 'No aplica';
	else regalo = 'Valor perdido';
end;
else if precio >= 35 then do;
	gama = 'Alta';
	precio = precio * 0.9 * 10000;
	regalo = 'No Aplica';
end;
run;





/********* APLICACIONES DE FUNCIONES VARIAS**********/
*Desglosar el IVA del precio de todos los autos;
data c.autosiva (drop = precio);
set c.autos;
subtotal = precio/1.16;
iva = subtotal * .16;
total = subtotal + iva;
run;

* Aplicar algunos cambios:
* Nombre del auto en mayúsculas, formato en las cantidades;
* Ve quitando los diferentes comentarios y observa los cambios.

data c.autosiva (drop = precio);
set c.autos;
nombre = upcase(nombre);
*nombre = lowcase(nombre);
*nombre = propcase(nombre);
*nombre2 = catx(' ',nombre,tipo);
subtotal = precio/1.16;
iva = subtotal * .16;
*st_ceil = ceil(precio/1.16); *CIL
*iva_ceil = ceil(subtotal * .16);
*st_floor = floor(precio/1.16);
*iva_floor = floor(subtotal * .16);
*st_int = int(precio/1.16);
*iva_int = int(subtotal * .16);
*st_round = round(precio/1.16);
*iva_round = round(subtotal * .16);
st_round = round(precio/1.16,.01);
iva_round = round(subtotal * .16,.01);
*total = subtotal + iva;
total = sum(subtotal,iva);
run;
