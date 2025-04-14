/*
DIPLOMADO EN MINERIA DE DATOS CON SAS
MODULO 1: INTELIGENCIA DE NEGOCIOS
CLASE 01
*/

*/
Al crear datasets en SAS se requiere hacer el paso de datos (Paso Data)
Este paso consiste en 2 fases:
	1.-Fase de compilación:
		-Buffer de entrada
		-Programa de Vector de Datos (PDV)	
			_N_ 	Esta variable lleva el conteo de cuantas lineas se han leído del archivo
			_ERROR_	Esta variable lleva los errores
	2.-Fase de ejecución:
			Lleva el contenido del PDV y los escribe en el dataset de SAS.
			Repetir hasta el paso 1.-
			Se repetirá tantas veces como datos se tenga.
*/

*Comentario de una línea;

/*
Comentario de más de 
una línea 
*/


/* 
Crear un dataset en SAS utilizando datos que escribimos directamente en el editor
*/

data personas;
input id nombre apaterno edad;
datalines;
1 Alejandro Ruíz 26
2 Patricia Hernández 25
3 Carlos López 22
4 Raúl Pérez 26
5 Carolina Ríos 18
;
run;




/* 
Crear un dataset en SAS utilizando datos que escribimos directamente en el editor
Es necesario especificar si la columna es de tipo caracter con el simbolo $
*/

data personas;
input id nombre $ apaterno $ edad;
datalines;
1 Alejandro Ruíz 26
2 Patricia Hernández 25
3 Carlos López 22
4 Raúl Pérez 26
5 Carolina Ríos 18
;
run;




/*
Biblioteca: Espacio de trabajo de SAS donde se pueden guardar datos.
Toda ejecucion en SAS requiere donde guardar los datos
Podemos verificar que en biblioteca WORK esta guardado el dataset que acabamos de crear
La bibliteca temporal por default de SAS es WORK
Al cerrar una sesión en SAS el contenido de la biblioteca WORK se borra
*/




/* 
Podemos cambiar el separador por ","
*/

data personas;
infile datalines delimiter=",";
input id nombre $ apaterno $ edad;
datalines;
1,Alejandro,Ruíz López,26
2,Patricia,Hernández,25
3,Carlos,López,22
4,Raúl,Pérez,26
5,Carolina.Ríos,18
;
run;




/* 
Podemos cargar los datos desde un archivo txt
INFILE: Permite hacer referencia a un archivo txt dentro del paso DATA
*/

data ingresos;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/ingresos.txt';
input id nombre $ ingresos gastos;
run;

/*
Aún nos da problemas con los acentos y con la longitud de la cadena de la variable nombre
*/




/* 
Podemos cargar los datos desde un archivo txt
INFILE: Permite hacer referencia a un archivo txt dentro del paso DATA
ENCODING: Permite hacer la lectura correcta de caracteres acentuados.
*/

data ingresos;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/ingresos.txt' 
	encoding ='wlatin1';
input id nombre $ ingresos gastos;
run;

/*
El dataset anterior es temporal y se guarda en la biblioteca WORK.
Si queremos guardar el dataset de forma permanente, es necesario crear una biblioteca que apunte a la ubicación física del dataset.
*/




/*
Crear una biblioteca permanente de salida en SAS
*/
libname s '/home/u61754732/sasuser.v94/Modulo1/C1';



/*
Con la biblioteca s creada, vamos a guardar el dataset ingresos en s
*/
data s.ingresos;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/ingresos.txt' 
	encoding ='wlatin1';
input id nombre $ ingresos gastos;
run;



/*
PROC CONTENTS: Permite conocer el descriptor del un dataset
*/
proc contents data=s.ingresos;
run;




/*
PROC CONTENTS: Permite conocer el descriptor del un dataset
Con la opción varnum nos muestra las variables en orden de creación
*/
proc contents data=s.ingresos varnum;
run;




/*
Leer más de un archivo TXT y guardarlo en el mismo dataset
Sólo sirve si los archivos tienen la misma estructura y mismo tipo de columnas
*/
filename dostxt (
'/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/ingresos.txt'
'/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/ingresos2.txt'
);

data s.ingresos2txt;
infile dostxt encoding='wlatin1';
input id nombre $ ingresos gastos;
run;
/*
Con esto, el contenido de los 2 archivos se guardo en el mismo dataset
*/





/*
Manejo de archivos de ancho fijo
Usaremos el archivo "MundoAcomoda.txt"
Manipulación del puntero en función de la línea
Creación de un dataset a partir de la posión INICIAL Y FINAL del puntero.

En el input le especificamos la posición de cada variable en el datset. Ya hace la lectura sin truncar las cadenas largas.
*/
data s.mundoaco;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/MundoAcomoda.txt' encoding='wlatin1';
input pais $ 1-17 poblacion 18-27 religion $ 28-40 esp_vida 41-42 mortalidad 48-51 natalidad 55-56;
run;




/*
Hacer un PROC CONTENTS para ver el contenido del dataset
*/
proc contents data=s.mundoaco;
run;




/*
Manejo de archivos de ancho fijo
Usaremos el archivo "MundoAcomoda.txt"
Creación de un dataset a partir de la posición INICIAL del puntero

En el input solo le especificamos la posición incial del puntero. Pero por default se consideran solo 8 bytes por cada cadena,
asi que esta alternativa trunca las cadenas que exceden los 8 bytes.
Se indica antes del nombre de cada variable y con un @
*/
data s.mundoaco2;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/MundoAcomoda.txt' encoding='wlatin1';
input @1 pais $ @18 poblacion @28 religion $41 @ esp_vida @48 mortalidad @55 natalidad;
run;




/*
Manejo de archivos de ancho fijo
Usaremos el archivo "MundoAcomoda.txt"
Podemos omitir columnas y cambiar el orden de lectura de las columnas del dataset.
Además es posible combinar ambas formas de manejo del puntero.
*/
data s.mundoaco3;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/MundoAcomoda.txt' encoding='wlatin1';
input religion $ 28-40 pais $ 1-17 @18 poblacion mortalidad 48-51 natalidad 55-56;
run;  




/*****************PARA REVISAR EN CASA***********************/

******** No olvides crear tu biblioteca de salida;
libname s '/home/u61754732/sasuser.v94/Modulo1/C1';




*Mostrar el contenido de un dataset: PROC PRINT;
proc print data = s.mundoaco;
	title 'Mostrando todas las observaciones';
run;




*Si queremos solo ver un cierto número de observaciones a partir de la primera;
*Se utiliza noobs si no queremos ver el número de la observación;
proc print data = s.mundoaco (obs = 2) noobs;
	title 'Mostrando solo dos observaciones';
run;




*Cuando se tiene una observación en dos líneas;
data s.mundo2lin;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/MundoObs2Lin.txt' 
       dlm = ',' encoding='wlatin1';
input pais $ poblacion religion $ /
      esp_vida mortalidad natalidad;
run;





*Cuando se tiene una observacion en tres lineas desordenadas;
data s.mundo3lin;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/MundoObs3Lin.txt' 
       dlm = ',' encoding='wlatin1';
input #1 pais $
      #3 poblacion religion $
      #2 esp_vida mortalidad natalidad;
run;





*Cuando una sola línea contiene dos observaciones;
data s.mundo2obs;
infile '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/Mundo2Obs.txt' 
       dlm = ',' encoding='wlatin1';
input pais $ poblacion religion $ 
      esp_vida mortalidad natalidad @@;
run;













