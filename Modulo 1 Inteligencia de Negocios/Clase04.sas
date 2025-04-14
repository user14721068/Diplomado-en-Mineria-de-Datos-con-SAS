/*
DIPLOMADO EN MINERIA DE DATOS
MODULO 1 INTELIGENCIA DE NEGOCIOS
CLASE 4: REPORTES EN SAS
7 OCTUBRE 2023
ALUMNO: CRUZ RAMIREZ NICOLAS
*/




*Liberar un LIBNAME;
*libname nombre_libname clear;




*Se debe actualizar la ruta de la capeta de datos persistentes;
libname e '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets';
libname s '/home/u61754732/sasuser.v94/Modulo1/C4';




/*
FILENAME: 
Sirve para dejar en una ubicacion particular y un nombre especifico la creacion de un archivo, el cual podemos replicar en todos 
los programas donde se requiera generar una salida.
Es necesario especificar el nombre del archivo y la extensión, es este caso HTML.
Este archivo HTML lo vamos a poder descargar y visualizar, sin necesidad de tener SAS instalado.
*/
filename archivo '/home/u61754732/sasuser.v94/Modulo1/C4/reporte.html';





/*
***********************************************************************************************************************************
												PRESENTACIÓN DE RESULTADOS
***********************************************************************************************************************************
*/



/*La presentacion de resultados: lograr que los reportes que se generan tengan ayudas visuales que permitan al usuario tomar una
decision mas rapida*/




/*
PROC PRINT
Reporte con Titulo y Pie de Página
*/
proc print data = e.saldoprom NOOBS;		/*Sentencia NOOBS omite el id de la observacion que muestra SAS por default*/
format saldoprom dollar15.2;				/*Aplicar formato moneda a columna saldoprom*/
title1 'MI BANQUITO, S.A. DE C.V.';			/*Al ser un reporte HTML se puede agregar titulos y notas al pie*/
title2 'Saldos promedio por sucursal';
footnote1 'Reporte octubre 2023';
footnote2 'Información confidencial';
run;
/*Al ejecutar nos muestra el reporte en la ventana de RESULTADOS. ESte reporte lo podemos descargar en formato HTML.*/




/*
PROC PRINT
Reporte con Titulo y Pie de Página.
Agregar un indicador tipo semadoro de color al reporte.
*/

/*Paso 1. Creamos un formato personalizado tipo semaforo*/
proc format;					
value indicador (multilabel notsorted)
	low - 65000 	= 'red'
	65000 - 75000 	= 'yellow'
	75000 - high 	= 'green'; *Indicamos los niveles;
run;

/*Paso 2: Agregar el formato de semaforo al reporte*/
proc print data = e.saldoprom noobs;
format saldoprom dollar15.2;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'Saldos promedio por sucursal';
footnote1 'Reporte octubre 2023';
footnote2 'Información confidencial';
VAR estado nombresucursal;								/*Indicar cuales variables no sufriran modificacion*/
VAR saldoprom/style = [background=indicador.];			/*Indicar en cual variables se aplicara el formato de semaforo. Especificar que es sobre el color de la celda*/
run;



/*Esto que realizamos es directamente usando programación en SAS*/
/*En SAS existen un conjunto de etiquetas (TAGSET)que permiten mejorar la visualizacion de un reporte.*/


/*
Tagset TABLE EDITOR;
El conjunto de etiquetas (tagset) TableEditor permite mejorar la funcionalidad de un 
data grid (es simplemente una o más tablas de datos que se generan con un procedimiento 
SAS o con el paso  DATA.)

Los tagsets consisten en eventos (como System_Title, Header, Data, System_Footer, etc.) 
que se activan en un orden particular basado en un procedimiento SAS o paso DATA. 
El conjunto de etiquetas TableEditor hereda del conjunto de etiquetas HTML4.

Este conjunto de etiquetas no sustituye a los métodos actuales de generación de estilos, pero
se puede utilizar en conjunto con los métodos actuales para crear estilos y mejoras para el grid
de datos. Permite también generar informes utilizando un conjunto común de opciones en todos los
procedimientos (independientemente del procedimiento, PRINT, REPORT o TABULATE).

Para utilizarlo hay dos opciones:
	2.-Incluir el archivo en nuestra sesión SAS usando una variable macro
	1.-Abrir con el editor de SAS el programa tableeditor.tpl, seleccionarlo todo y ejecutarlo.
*/




/*IMPORTANTE: Incluir el archivo tableeditor.tpl en nuestra sesión SAS usando una variable macro*/
%inc '/home/u61754732/my_shared_file_links/u61536033/01BI/tableeditor/tableeditor.tpl';




/*
TAGSET
Alternar colores de las filas en el la tabla:
Se debe cambiar el color en las propiedades;
banner_color_even = 'white' (Fila par en color blanco)
banner_color_odd = 'lipgr'  (Fila impar en otro color)
*/
ods tagsets.tableeditor			/*Para habilitar el conjunto de etiquetas dentro del proc print SAS tiene un sistema para despliegue de salidas llamado ODS, entonces todo lo que tenga que ver con salidas SAS lo controla a través del ODS, asi que con la instruccion ods tagsets.tableeditor le indicamos que va a hacer uso del conjunto de etiquetas, mismas que ya nos encargamos de hacerlas visibles para nuestra sesión.*/
file=archivo					/*Ruta y como queremos como se llame nuestro archivo al guardarlo*/
options(
header_bgcolor = 'darkblue' 	/*Color de fondo de encabezados de columna*/
header_fgcolor = 'white'		/*Color de fuente de encabezados de columnas*/
banner_color_even = 'white'		/*Color fila par*/
banner_color_odd = '#90B0D9'	/*Color fila impar*/
); 

proc print data = e.saldoprom noobs;		/*EScribir el proc print para ver los resultados*/
format saldoprom dollar10.2;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'Saldos promedio por sucursal';
footnote1 'Reporte octubre 2023';
footnote2 'Información confidencial';
run;

ods tagsets.tableeditor close;				/*Cerramos el ods*/
/*La salida en la ventana RESULTADOS no se visualizan con los cambios, sino que tenemos que descargar el archivo de salida
reporte.HTML mismo que podemos descargar y ver en nuestro navegador, donde ya se muestran los cambio usando TAGSET*/




/*
NOTA:
Si se quiere poner lineas a las columnas, agregar la propiedad:
gridlines='cols'
*/




/*
TAGSET
Alternar colores de las columnas en el la tabla:
Se debe cambiar el color en las propiedades;
col_color_even = 'white' (Fila par en color blanco)
col_color_odd = 'lipgr'  (Fila impar en otro color)
*/
ods tagsets.tableeditor			/*Para habilitar el conjunto de etiquetas dentro del proc print SAS tiene un sistema para despliegue de salidas llamado ODS, entonces todo lo que tenga que ver con salidas SAS lo controla a través del ODS, asi que con la instruccion ods tagsets.tableeditor le indicamos que va a hacer uso del conjunto de etiquetas, mismas que ya nos encargamos de hacerlas visibles para nuestra sesión.*/
file=archivo					/*Ruta y como queremos como se llame nuestro archivo al guardarlo*/
options(
header_bgcolor = 'darkblue' 	/*Color de fondo de encabezados de columna*/
header_fgcolor = 'white'		/*Color de fuente de encabezados de columnas*/
col_color_even = 'white'		/*Color columna par*/
col_color_odd = '#90B0D9'		/*Color columna impar*/
gridlines='cols'
); 

proc print data = e.saldoprom noobs;		/*EScribir el proc print para ver los resultados*/
format saldoprom dollar10.2;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'Saldos promedio por sucursal';
footnote1 'Reporte octubre 2023';
footnote2 'Información confidencial';
run;

ods tagsets.tableeditor close;				/*Cerramos el ods*/
/*La salida en la ventana RESULTADOS no se visualizan con los cambios, sino que tenemos que descargar el archivo de salida
reporte.HTML mismo que podemos descargar y ver en nuestro navegador, donde ya se muestran los cambio usando TAGSET*/




/*
TAGSET + SENTENCIA ID DENTRO DE PROC PRINT
Es posible definir una llave (puede estar o ordenada o no) dentro del PROC PRINT--> Sentencia ID;
Este permite ver un atributo como si fuera encabezado de fila, parecido a desplegar una tabla dinamica de Excel o un CROSS TAB
*Se puede cambiar el color de letra y fondo de los encabezados de FILA, aquí se
utilizan las propiedades rowheader_bgcolor y rowheader_fgcolor
*/
ods tagsets.tableeditor
file=archivo
options(
background_color = 'white'							/*Color de fondo de la pagina completa*/
header_bgcolor = 'green'							/*Color de fondo de celda encabezado de columas*/
header_fgcolor = 'white'							/*Color de letra de celda encabezado de columnas*/
rowheader_bgcolor = 'green'							/*Color de fondo de celda encabezado de fila*/
rowheader_fgcolor = 'white'							/*Color de letra de celda encabezado de fila*/
banner_color_even = '#E0FFFF'
banner_color_odd = 'white'							/*Alternar color en filas*/
); 

proc print data = e.saldoprom noobs;
id nombresucursal;									/*Atributo para mostrar como encabezado de fila*/
format saldoprom dollar10.2;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'Saldos promedio por sucursal';
footnote1 'Reporte octubre 2023';
footnote2 'Información confidencial';
run;

ods tagsets.tableeditor close;						/*Siempre abrir y cerrar el ODS*/




/*
Si ordenaramos el dataset reporte, tenemos 2 opciones:
	1.-Usar PROC SORT
	2.-Usar PROC SQL
*/




/*
Usando PROC SORT
*/
proc sort data = e.saldoprom out = s.saldoorden;
by nombresucursal;
run;




/*
Usando PROC SQL
*/
proc sql;
create table s.saldoorden as
select *
from e.saldoprom
order by nombresucursal desc;
quit;




/*
TAGSET + SENTENCIA ID DENTRO DE PROC PRINT
Usando ahora el dataset ordenado
*/
ods tagsets.tableeditor
file=archivo
options(
background_color = 'white'
header_bgcolor = 'green'
header_fgcolor = 'white'
rowheader_bgcolor = 'green'
rowheader_fgcolor = 'white'
banner_color_even = '#E0FFFF'
banner_color_odd = 'white'
); 

proc print data = s.saldoorden noobs;
id nombresucursal;										/*Atributo para mostrar como encabezado de fila*/
format saldoprom dollar10.2;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'Saldos promedio por sucursal';
footnote1 'Reporte octubre 2023';
footnote2 'Información confidencial';
run;

ods tagsets.tableeditor close;




/*
TAGSET
Resaltar una fila al mover el sursor sobre ella
Se requiere habilitar la propiedad highlight_color="algun_color_SAS"
*/
ods tagsets.tableeditor
file=archivo
options(
background_color = '#D9E5B0'							/*Color de fondo es verde*/
header_bgcolor = 'green'								/*Color de fondo de encabezados de columnas*/
header_fgcolor = 'white'								/*Color de letra de encabezados de columnas*/

highlight_color = '#C6E55C'								/*Color de resaltado de la fila al poner el cursor*/
data_bgcolor = 'white'									/*Color de fondo de la tabla*/
title_style = 'normal'									/**/
); 

proc print data = e.saldoprom noobs;
format saldoprom dollar10.2;
title1 c = '#FF0080' 'MI BANQUITO, S.A. DE C.V.';		/*c=stolg indica que el titulo va en color #FF0080*/
title2 c = stolg 'Saldos promedio por sucursal';		/*c=stolg indica que el titulo va en color stolg*/
footnote1 c = black 'Reporte octubre 2023';				/*c=stolg indica que el pie de pagina va en color stolg*/
footnote2 c = black 'Información confidencial';			/*c=stolg indica que el pie de pagina va en color stolg*/
run;

ods tagsets.tableeditor close;							/*Cerrar siempre el ODS*/
/*Muy recomandable que usemos los colores en hexadecimal para que SAS los reconozca a la primera.*/




/*Si queremos obtener un subconjunto de nuestro dataset original podemos hacerlo de 2 formas:
	1.-Modificar el dataset antes de llevarlo al PROC PRINT
	2.-Usar la sentencia WHERE dentro de PROC PRINT
*/




/*
TAGSET + WHERE (DENTRO DE PROC PRINT)
Es posible solo seleccionar ciertas variables y/o observaciones, en este
caso se utiliza la sentencia WHERE, que permite establecer condiciones paralas observaciines que se desean recuperar.
*/

ods tagsets.tableeditor
file=archivo														/*Donde se va a guardar el archivo y en que formato*/
options(
header_bgcolor = 'darkblue'											/*Opciones de color en fondo, letra, filas*/
header_fgcolor = 'white'
rowheader_bgcolor = 'darkblue'
rowheader_fgcolor = 'white'
banner_color_even = 'white'
banner_color_odd = 'lipgr'
);

proc print data = e.saldoprom noobs;
var nombresucursal saldoprom; 										/*Aquí especificamos el orden*/
where estado in ('AGUASCALIENTES','JALISCO','TLAXCALA') and 		/*La sentencia WHERE la usaremos dentro del PROC PRINT*/
      saldoprom between 50000 and 100000;
format saldoprom dollar14.2;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'Saldos promedio para GUERRERO, JALISCO y TLAXCALA';
footnote1 'Reporte octubre 2023';
footnote2 'Información confidencial';
run;

ods tagsets.tableeditor close;




/* 
TAGSET: BOTON PARA ORDENAR EL DATASET EN EL HTML
- Es posible habilitar un medio que permita ordenar las columnas, se cuenta con las
  propiedades:
  sort = 'yes'
  sort_arrow_color = 'brown'
  exclude_summary = 'yes'
  NOTA: Se debe agregar en proc print: style(gtotal)={htmlclass='noFilter'}
- De la misma forma, es posible agregar algunos aspectos de resumen para las variables
  en el reporte, por ejemplo, el total (para esto se utiliza la sentencia SUM).
*/

ods tagsets.tableeditor
file=archivo										/*Donde se va a guardar el archivo*/
style=ocean
options(
header_bgcolor = 'darkblue'							/*Opciones de color en fondo, letra, filas*/
header_fgcolor = 'white'
rowheader_bgcolor = 'darkblue'						/*Encabezado de columna*/
rowheader_fgcolor = 'white'
banner_color_even = 'white'							/*Color por fila*/
banner_color_odd = 'lipgr'

sort = 'yes'										/*Opcion para poder ordenar en el HTML*/
sort_arrow_color = '#87CEEB'						/*Color del boton de ordenamiento*/
exclude_summary = 'yes'								/*Exluir el resumen al final de la tabla*/
);

proc print data = e.reporte noobs;
id nombresucursal;													/*Variable a usar como encabezado de fila. Estilo Tabla Dinamica*/
var cuentas saldoprom;												/*Variables que vamos a usar*/
where saldoprom between 50000 and 80000;
format saldoprom dollar14.2;
sum cuentas saldoprom; *Especificamos los totales;					/*Opcion que agrera un resumen tipo sum aplicar sobre la columna cuentas y saldoprom*/
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'Saldos promedio por Sucursal';
footnote1 'Reporte octubre 2023';
footnote2 'Información confidencial';
run;

ods tagsets.tableeditor close;
/*El HTML ya permite ordenas las observaciones de manera interactiva, pero sigue ordenando la ultima fila de resumen, cosa que
no deberia hacer, para corregirlo debemos agregar lo siguiente en la sentencia PROC PRINT: style(gtotal)={htmlclass='noFilter'}*/




/* 
TAGSET: BOTON PARA ORDENAR EL DATASET EN EL HTML
- Es posible habilitar un medio que permita ordenar las columnas, se cuenta con las
  propiedades:
  sort = 'yes'
  sort_arrow_color = 'brown'
  exclude_summary = 'yes'
  NOTA: Se debe agregar en proc print: style(gtotal)={htmlclass='noFilter'}
- De la misma forma, es posible agregar algunos aspectos de resumen para las variables
  en el reporte, por ejemplo, el total (para esto se utiliza la sentencia SUM).
*/
ods tagsets.tableeditor
file=archivo										/*Donde se va a guardar el archivo*/
style=ocean
options(
header_bgcolor = 'darkblue'							/*Opciones de color en fondo, letra, filas*/
header_fgcolor = 'white'
rowheader_bgcolor = 'darkblue'						/*Encabezado de columna*/
rowheader_fgcolor = 'white'
banner_color_even = 'white'							/*Color por fila*/
banner_color_odd = 'lipgr'

sort = 'yes'										/*Opcion para poder ordenar en el HTML*/
sort_arrow_color = '#87CEEB'						/*Color del boton de ordenamiento*/
exclude_summary = 'yes'								/*Exluir el resumen al final de la tabla*/
);

proc print data = e.reporte noobs style(gtotal)={htmlclass='noFilter'}; /*Se agrega la opcion para no considerar la fila resumen en el ordenamiento*/
id nombresucursal;													/*Variable a usar como encabezado de fila. Estilo Tabla Dinamica*/
var cuentas saldoprom;												/*Variables que vamos a usar*/
where saldoprom between 50000 and 80000;
format saldoprom dollar14.2;
sum cuentas saldoprom; *Especificamos los totales;					/*Opcion que agrera un resumen tipo sum aplicar sobre la columna cuentas y saldoprom*/
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'Saldos promedio por Sucursal';
footnote1 'Reporte octubre 2023';
footnote2 'Información confidencial';
run;

ods tagsets.tableeditor close;
/*Al ordenar de manera interactiva, ya se excluye la fila de resumen*/




/*
TAGSET: FILTROS SOBRE LAS COLUMNAS
Se utiliza la propiedad:
autofilter="yes"
*/
ods tagsets.tableeditor
file=archivo
style=ocean
options(
header_bgcolor = 'darkblue'							/*Opciones sobre encabezados de columnas*/
header_fgcolor = 'white'
rowheader_bgcolor = 'darkblue'						/*Opciones sobre encabezados de fila*/
rowheader_fgcolor = 'white'
banner_color_even = 'white'							/*Color de las filas pares e impares */
banner_color_odd = 'lipgr'

autofilter = 'yes'									/*Habilitar los filtros sobre columnas*/
);

proc print data = e.reporte noobs;
id estado;
var nombresucursal cuentas saldoprom;
where saldoprom between 50000 and 80000;
format saldoprom dollar14.2;
sum cuentas saldoprom; *Especificamos lo totales;	/*Con PROC PRINT el unico resumen que podemos pedir es de suma. Indicar sobre que columnas de hara el resumen.*/
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'Saldos promedio por Sucursal';
footnote1 'Reporte octubre 2023';
footnote2 'Información confidencial';
run;

ods tagsets.tableeditor close;



/*
TAGSET: AGREGAR NIVELES DE AGREGACION
En el ejercicio anterior el resumen se muestra para todo el dataset, pero qusieramos mostrar el resumen por estado.
Se pueden agregar algunos niveles de agregación, en este caso se utiliza la propiedad BY (habilitar SUMLABEL), 
por ejemplo, para agregar por estado. 
Esto se hace en el PROC PRINT, no tiene que ver con TAGSET.
*/
ods tagsets.tableeditor
file=archivo							/*Donde se va a guardar el archivo y en que formato*/
style=ocean
options(
header_bgcolor = 'darkblue'				/*Colores para encabezado de columna*/
header_fgcolor = 'white'
rowheader_bgcolor = 'darkblue'			/*Colores para encabezado de fila*/
rowheader_fgcolor = 'white'
banner_color_even = 'white'				/*Colores para filas pares e impares*/
banner_color_odd = 'lipgr'
);

proc print data = e.reporte noobs sumlabel;	 				/*Habilitar SUMLABEL para poder mostrar la suma agrupada*/
var estado nombresucursal cuentas saldoprom;
format saldoprom dollar14.2;
sum cuentas saldoprom; 										/*Indica sobre que columnas se calculara la suma por grupo*/			
by estado;													/*Indicar sobre que variables se formaran los grupos*/
label estado = 'Estado';									/*Indicar la etiqueta del grupo*/
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'Saldos promedio por Sucursal';
footnote1 'Reporte octubre 2023';
footnote2 'Información confidencial';
run;

ods tagsets.tableeditor close;
/*Si ejecutamos solo el PROC PRINT nos devuelve el resultado en varias tablas.
Si ejecutamos todos el ODS al descargar el HTML podemos ver que separo las tablas agrupando por el atributo que le indicamos*/




/*
***************************************************************************************************************************
										MOSTRAR EL RESULTADO EN DISTINTOS FORMATOS DE ARCHIVO
***************************************************************************************************************************
*/



/*
ODS 
Generar y guardar un reporte en formato HTML, PDF y RTF (WORD).
OSD puede guardar los resultados de un PROC PRINT en distintos formatos.
Notemos que aqui ya no usamos el TAGSET para guardar el resultado, sino directamente ODS nos ayuda a guardar el resultado de un 
proc print
*/

*Especificar que la salida sea en formato PDF|RTF|HTML;
ods html file = '/home/u61754732/sasuser.v94/Modulo1/C4/salidahtml.html';	/*HTML*/
ods pdf file = '/home/u61754732/sasuser.v94/Modulo1/C4/salidapdf.pdf';		/*PDF*/
ods rtf file = '/home/u61754732/sasuser.v94/Modulo1/C4/salidartf.rtf';		/*WORD*/

proc print data = e.reporte noobs sumlabel;							/*Habilitar SUMLABEL para poder mostrar la suma agrupada*/
var estado nombresucursal cuentas saldoprom;
format saldoprom dollar14.2;
sum cuentas saldoprom; *Especificamos lo totales;					/*Indica sobre que columnas se calculara la suma por grupo*/
by estado;															/*Indicar sobre que variables se formaran los grupos*/
title1 'MI BANQUITO, S.A. DE C.V.';									
title2 'Saldos promedio por Sucursal';
footnote1 'Reporte octubre 2023';
footnote2 'Información confidencial';
run;

ods rtf close;
ods pdf close;
ods html close;														/*Cerrar cada uno de los ODS*/





/*
ODS
Mostrar cada tabla del reporte en una hoja distinta del PDF y RTF
- Para lograr que se muestre un resultado por hoja, se agrega la opción PAGEBY.
- Para este ejemplo, solo se muestra el PDF
- Para cambir las etiquetas se debe agregar en PROC PRINT la opción LABEL.
*/
ods pdf file = '/home/u61754732/sasuser.v94/Modulo1/C4/salidapageby.pdf';	/*Indicar donde se debe guardar el archivo y el formato*/
*ods rtf file = 'INDICAR_CARPETA_DE_SALIDA/salidapageby.rtf';

proc print data = e.reporte noobs label;									/*Indicar que aplique los nuevos nombres de columnas*/		
id estado;
var nombresucursal cuentas saldoprom;
format saldoprom dollar14.2;
sum cuentas saldoprom; *Especificamos lo totales;
by estado;
pageby estado;															/*En cada una de las pagina poner solo un grupo*/
label estado = 'Estado'													/*Indicar los nuevos nombres de columnas*/
      nombresucursal = 'Sucursal'										
	  cuentas = 'Cuentas activas'
	  saldoprom = 'Saldo promedio';
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'Saldos promedio por Sucursal';
footnote1 'Reporte octubre de 2023';
footnote2 'Información confidencial';
run;

*ods rtf close;
ods pdf close;





/*
TAGSET + BOTON DE DESCARGA TIPO EXCEL
Es posible realizar un reporte que se pueda descargar, por ejemplo en formato EXCEL.
En este caso se debe habilitar la opción: auto_excel = 'yes' y quit = 'no'
IMPORTANTE: SOLO FUNCIONA EN INTERNET EXPLORER. 
*/
ods tagsets.tableeditor
file = archivo
options(header_bgcolor = 'darkblue'
header_fgcolor = 'white'
rowheader_bgcolor = 'darkblue'
rowheader_fgcolor = 'white'
banner_color_even = 'white'
banner_color_odd = 'lipgr'
data_bgcolor = 'white'
auto_excel = 'yes'									/*Agregar boton de descarga en excel*/
quit = 'no'
); 

proc print data = e.reporte noobs;
var estado nombresucursal cuentas saldoprom;
format saldoprom dollar14.2;
sum cuentas saldoprom; *Especificamos lo totales;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'Saldos promedio por Sucursal';
footnote1 'Reporte octubre 2023';
footnote2 'Información confidencial';
run;

ods tagsets.tableeditor close;						/*Cerrado de ODS*/




/*
TAGSET: CONGELAR ENCABEZADOS DE FILA /COLUMNA
En ocasiones resultará necesario no perder de vista los encabezados de las tablas,
principalmente cuando son muchas las observaciones, en este caso se pueden congelar filas 
y/o columnas. Se utilizan las propiedades:
frozen_headers = 'yes'
frozen_rowheaders = '1,2,3'
IMPORTANTE: SOLO FUNCIONA EN INTERNET EXPLORER
*/
ods tagsets.tableeditor
file=archivo						/*Donde se guardara el resultado */
style=ocean
options(
header_bgcolor = 'darkblue'
header_fgcolor = 'white'
rowheader_bgcolor = 'darkblue'
rowheader_fgcolor = 'white'
banner_color_even = 'white'
banner_color_odd = 'lipgr'

frozen_headers = 'yes' 				/*Opcion para congelar encabezados*/
);

proc print data = e.reporte noobs sumlabel;
var estado nombresucursal cuentas saldoprom;
where saldoprom between 50000 and 80000;
format saldoprom dollar14.2;
sum cuentas saldoprom; *Especificamos lo totales;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'Saldos promedio por Sucursal';
footnote1 'Reporte octubre 2023';
footnote2 'Información confidencial';
run;

ods tagsets.tableeditor close;




/*
TAGSET: DIVIDIR PANTALLA EN PANELES
También es posible mostrar la información en PANELES (dividir pantalla), en este caso se utiliza la 
propiedad panelcols=número_paneles
*/
ods tagsets.tableeditor 							/*Usaremos tagset*/
file=archivo										/*Donde se guardara el archivo*/
style=ocean
options(
panelcols='2'										/*Dividir la pantalla a la mitad. Permite mostrar tantos PROC PRINT como paneles se hayan elegido.*/
);

proc print data = e.reporte noobs sumlabel;			/*1er proc print*/
var estado nombresucursal cuentas saldoprom;
where estado = 'CHIAPAS';
format saldoprom dollar14.2;
sum cuentas saldoprom; *Especificamos lo totales;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'Saldos promedio para Chiapas';
run;

proc print data = e.reporte noobs sumlabel;			/*2do proc print*/
var estado nombresucursal cuentas saldoprom;
where estado = 'OAXACA';
format saldoprom dollar14.2;
sum cuentas saldoprom; *Especificamos lo totales;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'Saldos promedio para Oaxaca';
run;

ods tagsets.tableeditor close;						/*Cerrar el ODS*/




/*
********************************************************************************************************************************
									PROCEDIMIENTO PARA RESUMENES
									PROC TABULATE
********************************************************************************************************************************
*/




/*
PROC TABULATE
Se trata de un procedimiento que permite desplegar estadísticas descriptivas en formato tabular (tabla de referencias cruzadas o crosstab).
Calcula muchas de las estadísticas que proporcionan otros procedimientos como MEANS,FREQ y REPORT.
Produce tablas a partir de una dimensión y permite dentro de cada dimensión, múltiples variables
Revisar archivo Data Summary_Analysis&Reporting.pdf
El proc tabulate permite generar tablas en distintas dimensiones, desde dimension 1 hasta dimension 3.
El proc tabulate solo trabaja sobre datasets con informacion detallada, no resumida. 
El proc tabulate no genera archivos que podamos descargar de manera directa, unicamente generar reportes tipo HTML
*/




/*
PROC TABULATE
Tabla resumen de 1 dimension
*/
proc tabulate data = e.detalle;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'CUENTAS POR SUCURSAL';
footnote1 "Reporte elaborado el &sysdate9";
footnote2 'Información confidencial';
class nombresucursal;							/*Variable categorica respecto a la cual se quiere generar el reporte*/
table nombresucursal;							/*Controlar la dimension del reporte*/
run; 
/*Este reporte despliega en cada columna el nombre de la sucursal y en una unica fila indica el numero de cuentas en la
sucursal. Por default el resumen lo hace por conteo para variables categoricas y por suma para variables numericas*/



/*
PROC TABULATE
Tabla resumen de 2 dimensiones
Además de el numero de cuentas activas, la suma de saldos;
*/
proc tabulate data = e.detalle;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'CUENTAS POR SUCURSAL';
footnote1 "Reporte elaborado el &sysdate9";
footnote2 'Información confidencial';
class nombresucursal;												/*Indicar variables categoricas*/
var saldo;															/*Indicar variables numericas*/
table nombresucursal,saldo;											/*Indicar las dos variables pues la tabla es de dimension dos*/
run;
/*La tabla despliega la suma de los saldos por nombre de sucursal. Los hace con la suma ya que es el resumen por default*/




/*
PROC TABULATE
Tabla resumen de 3 dimensiones (dividiendo la tabla);
Además de el numero de cuentas activas, la suma de saldos;
*/
proc tabulate data = e.detalle;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'CUENTAS POR SUCURSAL';
footnote1 "Reporte elaborado el &sysdate9";
footnote2 'Información confidencial';
class estado nombresucursal;									/*Indicar variables categoricas*/
var saldo;														/*Indicar variables numericas*/
table estado,nombresucursal,saldo;								/*Indicar las 3 variables pues es una tabla de dimension 3. Para visualizar 3 dimensiones SAS despliega una tabla por cada valor de la variables "estado"*/
*Podemos ocupar: N,SUM,MIN,MAX,MEAN;
run;
/*Para cada uno de los estados, despliega una tabla con la suma de saldos por sucursal. Pero queremos no resumir por suma sino por
media de saldos. Veamos el ejemplo siguiente*/




/*
PROC TABULATE
Tabla resumen de tres dimensiones(dividiendo la tabla);
Además de el numero de cuentas activas, la media de saldos;
*/
proc tabulate data = e.detalle;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'CUENTAS POR SUCURSAL';
footnote1 "Reporte elaborado el &sysdate9";
footnote2 'Información confidencial';
class estado nombresucursal;									/*Indicar variables categoricas*/
var saldo;														/*Indicar variables numericas*/
table estado,nombresucursal,saldo*mean;							/*Indicar las 3 variables pues es una tabla de dimension 3. Para visualizar 3 dimensiones SAS despliega una tabla por cada valor de la variables "estado"*/
*Podemos ocupar: N,SUM,MIN,MAX,MEAN;							/*Para aplicar distintas formas de resumen usar la sintaxis: nombre_variable*tipo_resumen */
run;




/*
PROC TABULATE
Tabla resumen de tres dimensiones(dividiendo la tabla);
Además de el numero de cuentas activas, la media de saldos y usar formato de moneda;
*/
proc tabulate data = e.detalle;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'CUENTAS POR SUCURSAL';
footnote1 "Reporte elaborado el &sysdate9";
footnote2 'Información confidencial';
class estado nombresucursal;									/*Indicar variables categoricas*/
var saldo;														/*Indicar variables numericas*/
table estado,nombresucursal,saldo*mean*f=dollar14.2;			/*Indicar las 3 variables pues es una tabla de dimension 3. Para visualizar 3 dimensiones SAS despliega una tabla por cada valor de la variables "estado"*/
*Podemos ocupar: N,SUM,MIN,MAX,MEAN;							/*Para aplicar distintas formas de resumen usar la sintaxis: nombre_variable*tipo_resumen */
run;															/*Para aplicar el formato usar la sintaxis: f=dollar14.2 */




/*
PROC TABULATE
Tabla resumen de tres dimensiones(Integrar la 3ra dimension en la misma tabla);
*Mostrar múltiples estadísticas en la misma tabla;
*/
proc tabulate data = e.detalle;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'CUENTAS POR SUCURSAL';
footnote1 "Reporte elaborado el &sysdate9";						/*Actualizacion automatica de la fecha de elaboracion*/
footnote2 'Información confidencial';							
class estado nombresucursal;									/*Indicar variables categoricas*/
classlev estado /s=[background=dark blue foreground = white];	/*Cambiar color de fondo y fuente en el encabezado de fila estado*/
classlev nombresucursal;									
var saldo;														/*Indicar variables numericas*/
table estado*nombresucursal,saldo*n = 'Cuentas activas'			/*Combinar estado con sucursal. El saldo resumirlo por conteo, max, min, suma, promedio.*/
            (saldo*max = 'Mayor saldo')*f = dollar14.2
			(saldo*min = 'Menor saldo')*f = dollar14.2
			(saldo*sum = 'Suma saldos')*f = dollar14.2
			(saldo*mean = 'Saldo promedio')*f = dollar14.2;
run;
/*Este ultimo reporte despliega una sola tabla, en el encabezado de las filas viene desglosado por estado y dentro de ese desglose viene la sucursal.
En las columasn viene el saldo resumido por conteo, maximo, minimo, suma, promedio.*/




/*
PROC TABULATE
Tabla resumen de tres dimensiones(Integrar la 3ra dimension en la misma tabla);
*Mostrar múltiples estadísticas en la misma tabla;
Agregar estadisticas por grupo.
*/
proc tabulate data = e.detalle;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'CUENTAS POR SUCURSAL';
footnote1 "Reporte elaborado el &sysdate9";							/*Variable macro para indicar fecha actual*/
footnote2 'Información confidencial';
class estado nombresucursal;										/*Indicar variables categoricas*/
var saldo;															/*Indicar variables numericas*/
table estado='Estado'*(nombresucursal='Sucursal' all) all,			/*Combinar estado con sucursal. Renombrar estado como Estado y nombresucursal como Sucursal. Con all indicamos que se desplieguen subtotaltes a nivel sucursal y a nivel estado*/
      saldo = ''*(n = 'Cuentas activas'								/*Renombramos saldo como cadena vacia. Los resumimos por conteo, max, min,sum,mean*/
                 (max = 'Mayor saldo'								
        		 (min = 'Menor saldo'
			     (sum = 'Suma saldos'
			     (mean = 'Saldo promedio'))))*f = dollar14.2);		/*Aplicar formato de moneda a todos menos al conteo*/
run;
/*Este ultimo reporte despliega una sola tabla, en el encabezado de las filas viene desglosado por estado y dentro de ese desglose viene la sucursal.
En las columasn viene el saldo resumido por conteo, maximo, minimo, suma, promedio.
Ademas ya agrego los subtotales por sucursal y el gran total por estado.
*/




/*
PROC TABULATE + FORMATO CON SAS
*Aplicando formato con SAS;
*/
proc tabulate data = e.detalle;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'CUENTAS POR SUCURSAL';
footnote1 "Reporte elaborado el &sysdate9";
footnote2 'Información confidencial';
class estado nombresucursal;
classlev estado / style = [background = DEGB foreground = white];
classlev nombresucursal / style = [background = LIGGR foreground = black];
var saldo;
table estado = 'Estado' *(nombresucursal =  'Sucursal'
      all = {label = 'Total x estado' s = [just = r background = VIOY font_weight = bold]} *
      [style = [background = yellow font_weight = bold]]) 
      (all = {label = 'Total nacional' s = [just = r background = green 
	  font_weight = bold foreground = white]} *
      [style = [background = pay font_weight = bold]]),
      saldo = ''*(n = 'Cuentas activas'
                 (max = 'Mayor saldo'
        		 (min = 'Menor saldo'
			     (sum = 'Suma saldos'
			     (mean = 'Saldo promedio'))))*f = dollar14.2);
run;
/*Esta es una alternativa a TAGSET*/




/*
PROC TABULATE: MANDAR UN PROC TABULATE A UN ARCHIVO EXCEL
A traves del TAGSET.EXCELXP podemos mandar la salida de un proc a un archivo excel, sin importar si nos haya generado un
conjunto de datos SAS.
El TAGSET.EXCELXP no es necesario realizar una descarga y habilitarlo para que funcione, a diferencia del TAGSET.tableeditor
que si lo requiere. 
*/
ODS tagsets.excelxp 												
file='/home/u61754732/sasuser.v94/Modulo1/C4/proctabulateexcel.xls'			/*Indicar donde se guardara el archivo. En este caso un excel de 2007*/
STYLE=printer																/*Elegir estilo sin colores*/
OPTIONS (
sheet_name='Proc Tabulate');												/*Indicar el nombre de la hoja donde se guardara el conjunto de datos*/

proc tabulate data = e.detalle;												/*Ejecutamos el PROC TABULATE que queremos guardar en xlsx*/
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'CUENTAS POR SUCURSAL';
footnote1 "Reporte elaborado el &sysdate9";
footnote2 'Información confidencial';
class estado nombresucursal;												/*Indicar variables categoricas*/
var saldo;																	/*Indicar variables numericas*/
table estado='Estado'*(nombresucursal='Sucursal' all) all,					/*Combinar estado con sucursal. Renombrar estado como Estado y nombresucursal como Sucursal. Con all indicamos que se desplieguen subtotaltes a nivel sucursal y a nivel estado*/
      saldo = ''*(n = 'Cuentas activas'										/*Renombramos saldo como cadena vacia. Los resumimos por conteo, max, min,sum,mean*/
                 (max = 'Mayor saldo'
        		 (min = 'Menor saldo'
			     (sum = 'Suma saldos'
			     (mean = 'Saldo promedio'))))*f = dollar14.2);				/*Aplicar formato de moneda a todos menos al conteo*/
run;

ods tagsets.excelxp close;													/*Cerrar el ODS*/
/*Este TAGSET siempre se puede usar cuando se requiera guardar la salida de un procedimiento en archivo xlsx*/





/*
****************************************************************************************************************************************
											GRAFICAS CON SAS
											PROC GCHART	
													BLOQUES
													BARRAS HORIZONTALES
													BARRAS VERTICALES
													PASTEL
													DONA
													ESTRELLAS
****************************************************************************************************************************************
*/


/*
Ejemplos de algunas gráficas básicas con SAS
El procedimiento GCHART produce seis tipos de gráficos: de bloques, de barras horizontales y verticales, 
gráficos de pastel y de dona, y gráficos de estrellas. Estos gráficos representan gráficamente el valor de una
estadística calculada para una o más variables en un conjunto de datos de entrada. 
Las variables graficadas pueden ser numéricas o de caracteres.

El procedimiento calcula estos estadísticos:
- Frecuencia o frecuencia acumulada
- Porcentajes o porcentajes acumulados
- Sumas
- Medias

Este procedimiento permite:
- Mostrar y comparar magnitudes exactas y relativas
- Examinar la contribución de las partes al conjunto
- Analizar los casos en que los datos están desequilibrados

Revisar el archivo Ch13_gchart.pdf para mas detalles
*/




/*
******************************************************************************************************************************
												PROC GCHART
												GRÁFICAS DE BARRAS VERTICALES
******************************************************************************************************************************
*/




/*Grafica de barras verticales de: Numero de cuentas por estado.*/
/*Ejemplo 1*/
filename grafout '/home/u61754732/sasuser.v94/Modulo1/C4'; 				/*Si queremos guardar la grafica agregar este bloque*/
ods listing;
goptions device=png;													/*Formato del archivo de salida*/
ods html path = grafout;												/*Establecer que la ruta de salida para todos los elementos*/

proc gchart data = e.reportefecha;										/*Indicar de donde tomar los datos*/
vbar estado / name = 'grafica1';										/*vbar indica reporte de barras verticales.*/
title 'Total de Cuentas por estado';									/*Toda gráfica debe llevar un nombre para poder guardarla*/
run;						
quit;																	/*Cerrar el lienzo de gchart para liberar recursos*/

ods html close;															/*Cerrar ODS html*/		
ods listing close;														/*Cerrar ODS listing*/
filename grafout clear;													/*Cerrar filename grafout*/




/*Consulta SQL equivalente para obtener: Numero de cuentas por estado.*/
proc sql;
select estado, count(numcta) as totasctas
from e.cuenta NATURAL JOIN e.sucursal
group by estado;
quit;




/*Grafica de barras verticales: Saldo promedio en las cuentas, por estado, agrupando estado por anio. Solo mostrar estados 'CHIAPAS','YUCATÁN','QUINTANA ROO'*/
*Ejemplo 2;
proc gchart data = e.reportefecha;										
format saldo dollar18.2;												/*Aplicar formato a la variable saldo*/
vbar estado / group=anio sumvar=saldo type=mean name = 'grafica2';		/*Barras verticales por estado. Agrupar por el estado por anio. Variable a sumarizar es Saldo. Tipo de sumarizacion es promedio.*/
title 'Saldo promedio región sureste por año';							
where estado in ('CHIAPAS','YUCATÁN','QUINTANA ROO');					/*Filtrado de datos*/
run;
quit;





/*Grafica de barras verticales: Suma de saldo en las cuentas, por estado, agrupando estado por anio. Solo mostrar estados 'CHIAPAS','YUCATÁN','QUINTANA ROO', adempas mostrar para cada barra vertical el porcentaje respecto al total de barras*/
*Ejemplo 3;
proc gchart data = e.reportefecha;
format saldo dollar18.2;
vbar estado / group=anio sumvar=saldo type=sum outside=pct autoref clipref	/*Barras verticales por estado. Agrupar por el estado por anio. Variable a sumarizar es Saldo. Tipo de sumarizacion es suma. Mostrar para cada barra vertical el porcentaje respecto al total de barras.*/
name = 'grafica3';															/*Nombre para la grafica*/
title 'Porcentaje de saldo región sureste por año';							
where estado in ('CHIAPAS','YUCATÁN','QUINTANA ROO');						/*Filtrado de datos*/
run;
quit;




/*Grafica de barras verticales: Saldo promedio en las cuentas, por estado, agrupando estado por trimestre. Solo mostrar estados 'CHIAPAS','YUCATÁN','QUINTANA ROO' y solo anio 2012. Mostrar para cada barra vertical el conteo de elementos*/
*Ejemplo 4;
proc gchart data = e.reportefecha;		
format saldo dollar18.2;													/*Formato para el saldo*/
vbar estado / group=trimestre sumvar=saldo type=mean inside=freq 			/*Barras verticales por estado. Agrupar estado por trimestre. Variable a sumarizar es saldo. Tipo de sumarizacion es promedio. Mostrar para cada barra vertical el conteo de elementos. */
name = 'grafica4';															/*Nombre para la grafica*/
title 'Saldo promedio región sureste por trimestres de 2012';
where estado in ('CHIAPAS','YUCATÁN','QUINTANA ROO') and anio = 2012;		/*Filtrado de datos*/
run;
quit;




/*Grafica de barras verticales: Saldo promedio en las cuentas, por estado, agrupando estado por anio. Subagrupar por trimestre. Solo mostrar estados 'CHIAPAS','YUCATÁN','QUINTANA ROO'. Mostrar para cada barra vertical el conteo de elementos*/
/*La segunda agrupacion la realiza coloreando las barras verticales por cada trimestre diferente*/
*Ejemplo 5;
proc gchart data = e.reportefecha;
vbar estado / group=anio subgroup=trimestre 								/*Barras verticales por estado. Agrupar estado por anio. Subagrupar por trimestre. */
sumvar=saldo type=mean inside=freq name = 'grafica5';						/*Variable a sumarizar es saldo. Tipo de sumarizacion es promedio. Mostrar conteo de elementos en cada barra vertical.*/
title 'Saldo promedio región sureste por año y trimestre';
where estado in ('CHIAPAS','YUCATÁN','QUINTANA ROO');						/*Filtrado de datos*/
run;
quit;



/*Grafica en 3D*/
*Grafica de barras verticales: Suma de saldo en las cuentas, por estado, agrupando estado por anio. Subagrupando por trimestre. Solo mostrar estados 'CHIAPAS','YUCATÁN','QUINTANA ROO' y año 2013. Mostrar para cada barra vertical el procentaje respecto al total de barras*/
/*La segunda agrupacion la realiza coloreando las barras verticales por cada trimestre diferente*/
*Ejemplo 6;
proc gchart data = e.reportefecha;
pattern1 color=lipk; pattern2 color=cyan;								/*Colores de las barras*/
pattern3 color=lime; pattern4 color=blue;
format saldo dollar18.2;
vbar3d estado / group=anio subgroup=trimestre							/*Barras verticales 3D por estado. Agrupar estado por anio. Subagrupar por trimestre. */
sumvar=saldo type=sum inside=subpct cframe=libgr name = 'grafica6';		/*Variable a sumarizar es saldo. Tipo de sumarizacion es promedio*/
title 'Suma saldos región sureste para los trimestres de 2013';
where estado in ('CHIAPAS','YUCATÁN','QUINTANA ROO') and anio = 2013;	/*Filtro sobre los datos*/
run;
quit;





/*Grafica en 3D*/
*Grafica de barras verticales: Suma de saldo en las cuentas, por estado, agrupando estado por anio. Subagrupando por trimestre. Solo mostrar estados 'CHIAPAS','YUCATÁN','QUINTANA ROO' para todos los anios. Mostrar para cada barra vertical el procentaje respecto al total de barras*/
/*La segunda agrupacion la realiza coloreando las barras verticales por cada trimestre diferente*/
*Ejemplo 6;
proc gchart data = e.reportefecha;
pattern1 color=lipk; pattern2 color=cyan;								/*Colores de las barras*/
pattern3 color=lime; pattern4 color=blue;
format saldo dollar18.2;
vbar3d estado / group=anio subgroup=trimestre							/*Barras verticales 3D por estado. Agrupar estado por anio. Subagrupar por trimestre. */
sumvar=saldo type=sum inside=subpct cframe=libgr name = 'grafica6';		/*Variable a sumarizar es saldo. Tipo de sumarizacion es promedio*/
title 'Suma saldos región sureste para los trimestres de 2013';
where estado in ('CHIAPAS','YUCATÁN','QUINTANA ROO');					/*Filtro sobre los datos*/
run;
quit;




/*
******************************************************************************************************************************
												PROC GCHART
												GRÁFICAS DE BARRAS HORIZONTALES
******************************************************************************************************************************
*/



/*Las graficas de barras horizontales permiten desplegar tambien otras estadisticas adicionales:
Frecuencia:				freq
Frecuencia Acumulada: 	cfreq
Porcentaje:				pct
Porcentaje Acumulado:	cpct
*/




/*Grafica de barra horizonales. En las fila pone nombre sucursal. El subgrupo es por anio. Por default muestra una tabla a la derecha con los estadisticos freq,cfreq,pct,cpct*/
/*SAS Despliega cada subgrupo como colores distintos en las barras horizontales*/
*Ejemplo 7: debe mostrar una tabla con freq, cfreq, pct y cpct;
proc gchart data = e.reportefecha;
hbar nombresucursal / subgroup = anio name = 'grafica7';		/*Barras horizontales por nombresucursal. Subgrupos por anio.*/
title 'Cuentas en la Ciudad de México por año';					/*Al no especificar variable a sumarizar y tipo de sumarizacion, por default muestra el conteo de elementos y las estadisticas freq,cfre,pct,cpct son sobre el conteo*/
where estado = 'DISTRITO FEDERAL';								/*Filtro de datos*/
run;
quit;



/*Grafica de barras horizontales en 3D. En las fila pone nombre sucursal. El subgrupo es por anio. Mostrar una tabla a la derecha con los estadisticos freq,cfreq*/
/*SAS Despliega cada subgrupo como colores distintos en las barras horizontales*/
*Ejemplo 8.1: La tabla solo se construye con 2 estadísticas freq cfreq;
proc gchart data = e.reportefecha;
hbar3d nombresucursal / subgroup = anio freq cfreq name = 'grafica8';   /*Barras horizontales por nombresucursal. Subgrupos por anio. Con freq y cfreq se indica que solo se requieren las estadisticas frecuencia y frecuencia acumulada*/
title 'Cuentas en la Ciudad de México por año';							/*Al no especificar variable a sumarizar y tipo de sumarizacion, por default muestra el conteo de elementos y las estadisticas freq,cfre,pct,cpct son sobre el conteo*/
where estado = 'DISTRITO FEDERAL';										/*Filtro sobre los datos*/
run;
quit;





/*Grafica de barras horizontales en 3D. En las fila pone nombre sucursal. El subgrupo es por anio. Omitir la tabla con los estadisticos*/
/*SAS Despliega cada subgrupo como colores distintos en las barras horizontales*/
*Ejemplo 8.2: No desplegar la tabla con estadisticas;
proc gchart data = e.reportefecha;
hbar3d nombresucursal / subgroup = anio NOSTATS name = 'grafica8';   	/*Barras horizontales por nombresucursal. Subgrupos por anio. Con nostats  se indica que no se muestre la tabla con estadisticas.*/
title 'Cuentas en la Ciudad de México por año';							/*Al no especificar variable a sumarizar y tipo de sumarizacion, por default muestra el conteo de elementos y las estadisticas freq,cfre,pct,cpct son sobre el conteo*/
where estado = 'DISTRITO FEDERAL';										/*Filtro sobre los datos*/
run;
quit;





/*
Grafica de barras horizontales. Se sumariza la variable saldo. Tipo de sumarizacion es promedio de saldos. En las filas pone nombre de 
sucursal. Se aplica un filtro a los datos.
Variable a sumarizar tipo continua y tipo de sumarizacion es promedio de saldos.
*/
*Ejemplo 9;
proc gchart data = e.reportefecha;
format saldo dollar15.2;
hbar nombresucursal / sumvar=saldo type=mean  autoref clipref			/*Barras horizontales en nombre sucursal. Variable de sumarizacion es Saldo. Las opciones autoref clipref son para modificar la malla de rayas verticales en el grafico.*/
     freqlabel='Total cuentas' meanlabel='Saldo promedio'				/*Renombrar las estadistica freq y mean.*/
     name = 'grafica9';													/*Al especificar variable a sumarizar tipo continua y tipo de sumarizacion es promedio de saldos , por default las estadisticas que muestra son: -conteo de elementos -promedio por barra*/
title 'Saldo promedio Yucatán por sucursal';
where estado = 'YUCATÁN' and anio = 2012;
run;
quit;




/*
Grafica de barras horizontales sobre nombresucursal. Sucursal agrupada por anio. Subgrupos por trimestre se muestran como color en cada barra. 
Variable de sumarizacion es saldo. Tipo de sumarizacion es promedio de saldos.
*/
*Ejemplo 10;
proc gchart data = e.reportefecha;
format saldo dollar15.2;								
hbar nombresucursal / group=anio subgroup=trimestre		/*Barras horizontales sobre nombresucursal. Sucursal agrupada por anio. Subgrupos por trimestre se muestran como color en cada barra. */
     sumvar=saldo type=mean  autoref clipref			/*Variable de sumarizacion es saldo. Tipo de sumarizacion es promedio de saldos.*/
     name = 'grafica10';
title 'Saldo promedio Yucatán por sucursal, año y trimestre';	
where estado = 'YUCATÁN';										/*Filtrado de datos*/
run;
quit;




/*
******************************************************************************************************************************
												PROC GCHART
												GRÁFICAS DE PASTEL
******************************************************************************************************************************
*/



/*
Grafica de pastel de estado. Agrupar por anio. Por default el tipo de sumarizacion es conteo de observaciones.
El agrupamiento por anio se despliega generando tantas graficas como categorias de anio.
*/
*Ejemplo 11;
proc gchart data = e.reportefecha;
pie estado / group = anio name = 'grafica11';		/*Grafica de pastel de estado. Agrupar por anio.  */
title 'Cuentas por año en México';
run;
quit;




/*
Grafica de pastel de nombresucursal. Agrupar por anio. Por default el tipo de sumarizacion es conteo de observaciones.
Se filtra el dataset para obtener informacion de CHIAPAS.
El agrupamiento por anio se despliega generando tantas graficas como categorias de anio.
*/
*Ejemplo 12;
proc gchart data = e.reportefecha;
pie nombresucursal / group = anio name = 'grafica12';	/*Grafico de pastel de nombresucursal. Agrupar por anio */
title 'Cuentas por año en CHIAPAS';
where estado = 'CHIAPAS';								/*Filtro sobre los datos*/
run;
quit;





/*
Grafica de pastel de nombresucursal. Agrupar por anio. Variable de sumarizaciones saldo. Tipo de sumarizacion es suma de saldos.
Se filtra el dataset para obtener informacion de CHIAPAS.
El agrupamiento por anio se despliega generando tantas graficas como categorias de anio.
*/
*Ejemplo 13;
proc gchart data = e.reportefecha;
format saldo dollar18.2;							
pie nombresucursal / group = anio					/*Grafico de pastel de nombresucursal. Agrupar por anio */ 
sumvar=saldo type=sum name = 'grafica13';			/*Variable de sumarizaciones saldo. Tipo de sumarizacion es suma de saldos.*/
title 'Saldo por año en el estado de CHIAPAS';		
where estado = 'CHIAPAS';							/*Filtro sobre el dataset*/
run;
quit;




/*
Grafica de pastel de nombresucursal. Agrupar por anio. Variable de sumarizaciones saldo. Tipo de sumarizacion es suma de saldos.
Se filtra el dataset para obtener informacion de CHIAPAS.
El agrupamiento por anio se despliega generando tantas graficas como categorias de anio.
*/
*Ejemplo 14;
proc gchart data = e.reportefecha;
format saldo dollar18.2;
pie nombresucursal / group = anio 						/*Grafico de pastel de nombresucursal. Agrupar por anio */ 
    sumvar=saldo type=mean name = 'grafica14';			/*Variable de sumarizaciones saldo. Tipo de sumarizacion es promedio de saldos.*/
title 'Saldo promedio por año en el estado de CHIPAS';
where estado = 'YUCATÁN';								/*Filtro sobre el dataset*/
run;
quit;





/*
Grafica de pastel 3D de nombresucursal. Agrupar por anio. Variable de sumarizaciones saldo. Tipo de sumarizacion es suma de saldos.
Resaltar rebanada de sucursal 'BONAMPAK'
Filtra el dataset para obtener informacion de CHIAPAS.
El agrupamiento por anio se despliega generando tantas graficas como categorias de anio.
*/
*Ejemplo 15;
proc gchart data = e.reportefecha;
format saldo dollar18.2;
pie3d nombresucursal / group = anio 				/*Grafica pastel 3D por nombresucursal. Agrupar por anio.*/
    sumvar=saldo type=mean  						/*Variable de sumarizaciones saldo. Tipo de sumarizacion es promedio de saldos.*/
    explode='BONAMPAK'								/*Rebanada a resaltar*/
    name = 'grafica15';
title 'Saldo promedio por año en el estado de CHIAPAS';		/*Filtro sobre el dataset*/
where estado = 'CHIAPAS';
run;
quit;





/*Usando grupos y subgrupos*/
/*El agrupamiento lo implementa mostrando tantas gráficas como categorias la variable de agrupamiento.*/
/*El subagrupamiento lo implementa cortando cada pastel en tantos anillos como categorias de la variable de subgrupo*/
/*Esta grafica ya es demasiado compleja de interpretar.*/
/*Ejemplo Extra:*/
proc gchart data = e.reportefecha;
format saldo dollar18.2;
pie nombresucursal / group = anio subgroup = trimestre 	/*Grafico de pastel de nombresucursal. Agrupar por anio. Subagrupar por trimestre*/ 
    sumvar=saldo type=mean name = 'grafica14';			/*Variable de sumarizaciones saldo. Tipo de sumarizacion es promedio de saldos.*/
title 'Saldo promedio por año en el estado de CHIPAS';
where estado = 'YUCATÁN';								/*Filtro sobre el dataset*/
run;
quit;




/*
Grafica de pastel de nombresucursal. Agrupar por anio
Al no especificar variable ni tipo de sumarizacion, lo hace por conteo de filas, por default.
Se agrega una flecha con los datos de cada rebanada.
*/
*Ejemplo 17;
proc gchart data = e.reportefecha;
pie nombresucursal / group = anio 				/*Grafica de pastel de nombresucursal. Agrupar por anio*/
    percent=arrow slice=arrow value=inside 		/*Agregar una fecha para colocar la informacion de cada rebanada.*/
    name = 'grafica17';							/**/
title 'Cuentas por año en OAXACA';
where estado = 'DISTRITO FEDERAL';
run;
quit;





/*******************************************************************************************************************************
												PROC GCHART
												GRÁFICAS DE DONA
*******************************************************************************************************************************/




/*
La grafica de dona es igual a la grafica de pastel solo que con un agujero en el centro.
*/




/*
Grafica de dona de nombresucursal. Subgrupo sera por trimestre. 
Variable a sumarizar es saldo. Tipos de sumarizacion es promedio. 
El subagrupamiento lo implementa en la misma grafica, dividiendo la dona en anillos.
*/
*Ejemplo 16.1;
proc gchart data = e.reportefecha;								
format saldo dollar18.2;										
donut nombresucursal / subgroup=trimestre 						/*Grafica de dona de nombresucursal. Subgrupo sera por trimestre*/
    sumvar=saldo type=mean name = 'grafica16';					/*Variable a sumarizar es saldo. Tipos de sumarizacion es promedio*/
title 'Saldo promedio por trimestre en CHIPAS (2013)';			
where estado = 'CHIAPAS' and anio = 2013;						/*Filtro sobre los datos*/
run;
quit;





/*
Grafica de dona de nombresucursal. Subgrupo sera por trimestre. 
Variable a sumarizar es saldo. Tipos de sumarizacion es promedio. 
El agrupamiento lo implementa generando una dona por cada categoria en la variable de agrupamiento.
*/
*Ejemplo 16.1;
proc gchart data = e.reportefecha;								
format saldo dollar18.2;										
donut nombresucursal / group=trimestre 							/*Grafica de dona de nombresucursal. Grupo sera por trimestre*/
    sumvar=saldo type=mean name = 'grafica16';					/*Variable a sumarizar es saldo. Tipos de sumarizacion es promedio*/
title 'Saldo promedio por trimestre en CHIPAS (2013)';			
where estado = 'CHIAPAS' and anio = 2013;						/*Filtro sobre los datos*/
run;
quit;












/*******************************************************************************************************************************
												PROC GCHART
												GRÁFICAS DE BLOQUE
*******************************************************************************************************************************/


/*Es una grafica de barras con profundidad y espaciado entre barras.. */





/*Grafica de bloque de nombresucursal. Variable de sumariacion saldo. */
/*Al no especificar tipo de sumarizacion, se toma por default la suma*/
/**/
*Ejemplo 18;
proc gchart data = e.reportefecha;
format saldo dollar18.2;
block nombresucursal / sumvar=saldo name = 'grafica18';		/*Grafica de bloque de nombresucursal. Variable de sumariacion saldo. */
title 'Total saldo en GUANAJUATO durante 2013';				/*Al no especificar tipo de sumarizacion, se toma por default la suma*/
where estado = 'GUANAJUATO' and anio = 2013;				/*Filtrado de datos*/
run;
quit;




/*
Grafica de bloque de nombresucursal. Variable de sumarizacion saldo. Tipos de sumarizacion es promedio de saldos.
Agrupamiento por anio: 			Lo implementa agregando hileras de barras ene l fondo.
Subagrupamiento por trimestre:	Lo implementa coloreando las barras de acuerdo a la variable de subagrupamiento.
*/
*Ejemplo 19;
proc gchart data = e.reportefecha;
format saldo dollar18.2;
block nombresucursal / sumvar=saldo type=mean				/*Grafica de bloque de nombresucursal. Variable de sumarizacion saldo. Tipos de sumarizacion es promedio de saldos.*/
      group=anio subgroup=trimestre name = 'grafica19';		/*Agrupamiento por anio. Subagrupamiento por trimestre.*/
title 'Total saldo en GUANAJUATO por año y trimestre';
where estado = 'GUANAJUATO';
run;
quit;




/*
GUARDAR GRAFICAS
*/
/*Si se quiere guardar las graficas usar las siguientes sentencias de apertura y cierre.*/

filename grafout '/home/u61754732/sasuser.v94/Modulo1/C4'; 				/*Si queremos guardar la grafica agregar este bloque*/
ods listing;
goptions device=png;													/*Formato del archivo de salida*/
ods html path = grafout;												/*Establecer que la ruta de salida para todos los elementos*/

proc gchart data = e.reportefecha;
format saldo dollar18.2;
block nombresucursal / sumvar=saldo type=mean							/*Grafica de bloque de nombresucursal. Variable de sumarizacion saldo. Tipos de sumarizacion es promedio de saldos.*/
      group=anio subgroup=trimestre name = 'grafica19';					/*Agrupamiento por anio. Subagrupamiento por trimestre.*/
title 'Total saldo en GUANAJUATO por año y trimestre';
where estado = 'GUANAJUATO';
run;
quit;																	/*Cerrar el lienzo de gchart para liberar recursos*/

ods html close;															/*Cerrar ODS html*/		
ods listing close;														/*Cerrar ODS listing*/
filename grafout clear;													/*Cerrar filename grafout*/


/*
Continuación: Ver archivo 'PaginaWeb.sas'
*/