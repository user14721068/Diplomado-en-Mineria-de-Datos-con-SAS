/*
IMAM
DIPLOMADO EN MINERIA DE DATOS
MODULO 1
CLASE 3
30 SEPTIEMBRE 2023
ALUMNO: NICOLAS CRUZ RAMIREZ
*/




*Crear los libnames de entrada y de salida;
libname e '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets';
libname s '/home/u61754732/sasuser.v94/Modulo1/C3';




/*********************ESTRUCTURAS DE ITERACION EN SAS*************/




/*
Ejercicio1: Obtener el acumulado de ventas del dataset superstore
*/


/*
Primero debemos cargar el dataset
Opcion 1: Cargarlo a partir de un libname, luego hacer una copia para tenerlo en SAS
Opcion 2: Cargarlo usando proc import 
En este caso usaremos la opcion 2
*/
proc import out=s.super                  	/*Donde se guardaran los datos*/                
datafile='/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/Superstore.xlsx'
dbms=xlsx replace; 							/*Infraestructura del conjunto de datos*/
sheet="Orders";								/*Aqui le indicamos cual hoja leer*/
getnames=yes;								/*Le indicamos que tiene encabezados*/
run;




/*
Intento 1: 
Este no funciona pues no guarda el acumulado solo hace la multilicacion para cada fila
*/
data s.ventatotal;			/*Donde guardaremos el nuevo dataset*/
set s.super;				/*Donde nos basaremos para crear el nuevo dataset*/
acumulado = 0;
acumulado = acumulado + unitprice * orderquantity;
run;




/*
Intento 2: 
Esta ya calcula el acumulado;
*/
data s.ventatotal;			/*Donde guardaremos el nuevo dataset*/
set s.super;				/*Donde nos basaremos para crear el nuevo dataset*/
*acumulado = 0;				/*Esta linea es la que nos generaba el problema pues en cada iteracion del PDV se inicializaba en 0*/
acumulado + unitprice * orderquantity;  	/*Al omitir la asignacion a la variable acumulado se hace que no se resetee en cada iteracion del PDV*/
run;
/*
Pero tiene el problema de que la columna acumulado muestra el acumulado para cada fila del dase, pero en realidad nosotros requerimos
el acumulado total, es decir, solo la ultima fila de la variable acumulado.
*/




/*
Intento 2 más refinado
Podemos pedir que solo muestre la ultima fila y la variable acumulado
*/
data s.ventatotal (keep=acumulado);			/*Al final solo conservar la variable acumulado*/
set s.super end=ultimo;						/*Agregar indicadora "ultimo" que nos dice si la fila es la ultima del dataset*/
format acumulado dollar15.2;				/*Aplicar formato de moneda al mostrar la salida*/
acumulado + unitprice * orderquantity;
if ultimo;									/*Filtro que permite conservar solo las filas donde la indicadora ultimo = TRUE*/
run;




/*
Extra
Visualizar los datos con proc print
*/
proc print data = s.ventatotal; 
run;




/*
Ejercicio 2: Obtener el cliente que más compró;
*/



/*
Intento 1: 
*/

/*
Primero vamos a obtener cual fue la compra más costosa, por ahora nos conformaremos con obtener la compra mas costosa fila por fila.
Aqui solo agregamos la variable "venta" al dataset original
*/
data s.super;						/*Crear nueva columna de venta*/
set s.super;
venta = unitprice * orderquantity;
run;




/*
RETAIN
Despues vamos a agregar una variable llamada maxventa, no queremos que se resetee sino que en ella podamos
guardar el valor maximo de la venta a medida que el PDV lee fila por fila el dataset, esto lo haremos con la sentencia RETAIN
*/
data s.clientemas;								/*Donde guardaremos el nuevo dataset*/
set s.super;									/*De donde tomamos los datos*/
RETAIN maxventa;								/*Variable donde se almacenara la venta maxima, esta NO se debe resetear en cada iteracion del PDV*/
if maxventa < venta then maxventa = venta;		/*Si la fila actual tiene la venta mas grande, es la venta maxima, sino, no hace nada*/
run;
/*
Ya obtuvimos cual es la venta maxima por fila, pero nos la muestra hasta el final del dataset y ademas no sabemos que cliente la realizo.
*/




/*
Usando RETAIN sobre las variables "maxventa" y "CustomerName" ya podremos saber quien es el cliente que hizo la mayor compra.
*/
data s.clientemas;
set s.super;
retain maxventa nombre;			/*Variables que NO se deben resetear. Deben guard los valores de venta maxima y nombre del cliente que la hizo*/
if 	maxventa < venta then do;	/*Condicional para guardar el monto de la venta y nombre del cliente unicamente si es el que ha hecho la mayor compra hasta el momento*/
	maxventa = venta;
	nombre = customername;
end;
run;
/*
Problema: La venta máxima y el nombre del cliente que le corresponde se muestran hasta la ultima fila del dataset, 
pero solo quisieramos mostrar una fila con la max venta y nombre cliente
*/




/*
Combinando la sentencia END y la sentencia IF podemos hacer que ya solo se muestre la ultima fila del dataset, 
que guarda la venta máxima y el cliente que la hizo. Este nos devuelve la compra mas costosa
*/
data s.clientemas (keep=maxventa nombre);
set s.super end=ultimo;						/*Agregar indicadora "ultimo" que nos dice si la fila es la ultima del dataset*/
format maxventa dollar10.2;					/*Formato de salida para la variable mexventa*/
retain maxventa nombre;
if maxventa < venta then do;
	maxventa = venta;
	nombre = CustomerName;
end;
if ultimo;									/*Aplicar un filtro para solo traer la fila si esta es la ultima del dataset*/
run;




/*
Intento 1: 
Con esto terminamos el intento 1, pues ya pudimos obtener, fila por fila, cual es la mayor venta que se hizo y quien la hizo.
Ahora volvemos al ejercicio original: Obtener el cliente que más compró. 
Para hacerlo se requiere usar dons herramientas: ORDENAMIENTO y AGRUPACIONES;
Esto lo vemos a continuacion.
*/



/*
*************************************************************************************************************************************
												ORDENAMIENTO (PROC SORT)
*************************************************************************************************************************************
*/



/*
Crear una copia del dataset super
*/
data s.ordenes;
set s.super;
run;



/*
*PROC SORT
Al ordenar se requiere indicar la o las columnas para ordenar y la forma de ordenamiento.
Con este codigo se ordena pero se modifico el dataset original (s.ordenes), algo que no es recomendable en la vida real;
*/
proc sort data=s.ordenes;		/*Ya que no especificamos ruta en OUT lo que hace es modificar el dataset original en DATA*/
by orderpriority;				/*Indicar variables para ordenar y criterio de ordenamiento*/
run;




/*
*PROC SORT
Se requiere indicar la o las columnas para ordenar y la forma de ordenamiento.
Si no queremos modificar el dataset original entonces especificar la ruta destino en OUTPUT para crear una copia;
*/
proc sort data=s.super out=s.super_ord;			/*Al especificar OUT el dataset se guardara en la ruta de OUT y no modificamos el dataset original que se especifica en DATA*/
by orderdate;									/*Indicar variables para ordenar y criterio de ordenamiento*/
run;	



		
/*
PROC SORT
Ordenar por mas de un atributo;
Usar ordenamiento natural (ascendente)
*/
proc sort data=s.super out=s.super_ord;
by orderdate orderpriority;						/*Especificar los atributos por los cuales se va a ordenar*/
run;




/*
PROC SORT
Ordenamiento de manera descendente
Sin embargo el orden descendente no se aplica para la variable "orderpriority"
*/
proc sort data=s.super out=s.super_ord;
by descending orderdate orderpriority;
run;




/*
PROC SORT
Ordenar los 2 atributos de forma descendente. Es necesario indicar el tipo de ordenamiento de cada atributo.
*/
proc sort data=s.super out=s.super_ord;
by descending orderdate descending orderpriority;
run;




/*
IF-ELSE
Mapear la prioridad;
Crear un atributo para asignar un valor numerico a la columna orderpriority;
*/
data s.super;													/*Donde se guardara el nuevo dataset*/
set s.super;													/*Donde nos basaremos para crear el dataset*/
IF 		orderpriority = "Not Specified" THEN prioridad=0;
ELSE IF orderpriority = "Low" 			THEN prioridad=1;
ELSE IF orderpriority = "Medium" 		THEN prioridad=2;
ELSE IF orderpriority = "High" 			THEN prioridad=3;
ELSE IF orderpriority = "Critical" 		THEN prioridad=4;
run;



/*
PROC SORT
Ordenar los 2 atributos de forma descendente;
*/
proc sort data=s.super out=s.super_ord;
by descending orderdate descending prioridad;			/*Especificar el criterio de ordenamiento en cada atributo*/
run;




/*
*************************************************************************************************************************************
													AGRUPACION
*************************************************************************************************************************************
*/


/*
BY es una sentencia que se puede utilizar para indicar el atributo de ordenamiento en PROC SORT;
BY tambien se puede utilizar para simular el GROUP BY del SQL;
Cuando BY se utiliza dentro de un programa con la sentencia DATA, el cual prevamente se haya ordenado, se van a 
crear de forma automatica, dos variables binarias con al forma;
	first.variable_indicada_en_BY			Variable indicadora, vale 1 si la fila es la primera del grupo y 0 eoc
	last.variable_indicada_en_BY			Variable indicadora, vale 1 si la fila es la ultima  del grupo y 0 eoc
Se usaran estas variables auxiliares para hacer sumarizar por grupos.
*/




/*
Ejemplo: Obtener el total de ventas por fecha de compra
*/




/*
Paso 1
*Lo primero que debemos hacer es ordenar el dataset por la variable "fecha de compra". es decir, la variable sobre la cual queremos agrupar.
*/
proc sort data=s.super out=s.super_ord;			/*Indicar data y out para no sobreeescribir el dataset original*/
by orderdate;
run;



/*
Para mayor comprension veamos como lucen las columnas auxliares "primeragrupo" y "ultimagrupo";
*/
data s.ventasgrupo;								/*Donde se guardara el nuevo dataset*/	
set s.super_ord;								/*De cual dataset nos basaremos*/
by orderdate;
primeragrupo=first.orderdate;					/*Variable indicadora, vale 1 si la fila es la primera del grupo y 0 eoc*/
ultimagrupo=last.orderdate;						/*Variable indicadora, vale 1 si la fila es la ultima  del grupo y 0 eoc*/
run;




/*
Paso 2: Una vez ordenado, podemos "agrupar" usando las variables auxiliares "primeragrupo" y "ultimagrupo"
Con esto ya obtuvimos el total de ventas por fecha de compra
*/
data s.ventasgrupo (keep=orderdate acumulado);
set s.super_ord;
by orderdate;									/*Variable sobre la cual se agrupara*/
if first.orderdate then do;						/*Si la fila es la primera del grupo entonces:*/
	acumulado = 0; 								/*Como estamos en el inicio de un nuevo grupo, reiniciamos el acumulado de ventas*/
	acumulado = + venta; 						/*Definimos el acumulado de ventas igual a la venta de la primer fila del grupo*/
end;
else acumulado + venta; 						/*Si la fila es una observacion intermedias del grupo (No es ni la primera ni la ultima), entonces no hacemos asignacion para no olvidar el acumulado*/
if last.orderdate then output;				 	/*Si estamos en la ultima observacion, entonces manda esto a la salida, es decir, Solo nos quedamos con la ultima observacion del grupo*/
run;
/*
El dataset resultante tiene la estructura:
	OrderDate 	Acumulado
	01/01/2009	1055.27
	02/01/2009	11386.4
	...			...
*/




/*
Paso 3: Y podemos obtener el dia en que mas se vendio
*/
data s.diamayorventa (keep=maxventa dia);		/*Al final mostrar solo las variables maxventa y dia*/
set s.ventasgrupo end=ultimo;					/*Usar el dataset agrupado del paso anterior, el cual tiene las columnas orderdate (fecha) y acumulado(venta de esa fecha). Usar sentencia END para obtener la variables indicadora 1 si es la ultima fila del dataet y 0 eoc*/
format maxventa dollar15.2 dia ddmmyy10.;
retain maxventa dia;							/*Variables "maxventa" y "dia" NO se resetearan en cada iteracion del PDV*/
if 	maxventa < acumulado then do;				/*Si nuestra maxventa es mas pequeña que la columna de venta acumulada en el dia, significa que tenemos un nuevo maximo*/	
	maxventa = acumulado;						/*Hacer la reasignación de maxventa*/
	dia = orderdate;							/*Hacer la reasignacion de fecha de maxventa*/
end;
if ultimo;										/*Aplicar el filtro para conservar solo la ultima fila del dataset*/
run;
 






/*
Con esto ya podemos resolver el Ejercicio 2: Obtener el cliente que más compró;
*/




/*
Paso 1
Lo primero que debemos hacer es ordenar el dataset por la variable "CustomerName", es decir, la variable sobre la cual queremos agrupar.
*/
proc sort data=s.super out=s.super_ord_cust;			/*Indicar data y out para no sobreeescribir el dataset original*/
by CustomerName;
run;



/*
Paso 1.1
Para mayor comprension veamos como lucen las columnas auxliares "primeragrupo" y "ultimagrupo";
*/
data s.ventasgrupo_cust;								/*Donde se guardara el nuevo dataset*/	
set s.super_ord_cust;								/*De cual dataset nos basaremos*/
by CustomerName;
primeragrupo=first.CustomerName;					/*Variable indicadora, vale 1 si la fila es la primera del grupo y 0 eoc*/
ultimagrupo=last.CustomerName;						/*Variable indicadora, vale 1 si la fila es la ultima  del grupo y 0 eoc*/
run;





/*
Paso 2
Una vez ordenado, podemos "agrupar" usando las variables auxiliares "primeragrupo" y "ultimagrupo"
Con esto ya obtuvimos el total de ventas por nombre de cliente
*/
data s.ventasgrupo_cust_final (keep=CustomerName acumulado);
set s.super_ord_cust;
by CustomerName;								/*Variable sobre la cual se agrupara*/
if first.CustomerName then do;					/*Si la fila es la primera del grupo entonces:*/
	acumulado = 0; 								/*Como estamos en el inicio de un nuevo grupo, reiniciamos el acumulado de ventas*/
	acumulado = + venta; 						/*Definimos el acumulado de ventas igual a la venta de la primer fila del grupo*/
end;											
else acumulado + venta; 						/*Si la fila es una observacion intermedias del grupo (No es ni la primera ni la ultima), entonces no hacemos asignacion para no olvidar el acumulado*/
if last.CustomerName then output;				/*Si estamos en la ultima observacion, entonces manda esto a la salida, es decir, Solo nos quedamos con la ultima observacion del grupo*/
run;
/*
El dataset resultante tiene la estructura:
	CustomerName 		Acumulado
	Aaron Bergman		12310.93
	Aaron Hawkins		28433.29
	...			...			
*/




/*
Paso 3
Y podemos obtener el cliente que compro mas
*/
data s.clientemayorventa (keep=maxventa cliente);	/*Al final mostrar solo las variables maxventa y cliente*/
set s.ventasgrupo_cust_final end=ultimo;			/*Usar el dataset agrupado del paso anterior, el cual tiene las columnas CustomerName y acumulado(venta de ese cliente). Usar sentencia END para obtener la variables indicadora 1 si es la ultima fila del dataet y 0 eoc*/
format maxventa dollar15.2 cliente $10.;
retain maxventa cliente;							/*Variables "maxventa" y "cliente" NO se resetearan en cada iteracion del PDV*/
if 	maxventa < acumulado then do;					/*Si nuestra maxventa es mas pequeña que la columna de venta acumulada del cliente, significa que tenemos un nuevo maximo*/	
	maxventa = acumulado;							/*Hacer la reasignación de maxventa*/
	cliente = CustomerName;							/*Hacer la reasignacion de cliente que corresponde a la maxima venta*/
end;
if ultimo;											/*Aplicar el filtro para conservar solo la ultima fila del dataset*/
run;
/*
El dataset resultante tiene la estructura:
	maxventa 	cliente
	118,906.33	Emily Phan
*/




/*
Ejercicio 2: Listo, terminamos este ejercicio
*/


/*
PROC SORT
También nos permite también quitar elementos duplicados (por llave) de un datset;
Primera forma: quitar elementos duplicados (por llave) de un datset;
Nota: SQL sólo lo hace por fila no por llave
Sentencia nodupkey indica que no queremos llaves duplicadas
Sentencia dupout=s.dupllaves indica donde se guardaran las observaciones duplicadas, esta sentencia es opcional, la podemos omitir si queremos.
*/
proc sort data=e.cuentas out=s.cuentas_sindup nodupkey dupout=s.dupllaves; 	
by bill_id;																	/* Columna por la cual ordenar y remover llaves duplicadas */
run;
/*
En la ventana LOG se indica que 93 observaciones con duplicados en la variable bill_id fueron eliminadas
*/ 

 
 

/*
PROC SORT
Segunda forma: Quitar filas duplicadas (similar a DISTINCT del sql);
Sentencia noduprecs indica que no queremos filas duplicadas
Sentencia dupout=s.dupllaves indica donde se guardaran las observaciones duplicadas, esta sentencia es opcional, la podemos omitir si queremos.
*/
proc sort data=e.cuentas out=s.cuentas_sindup noduprecs dupout=s.dupllaves;
by cust_id;																	/* Columna por la cual ordenar. Aunque para quitar duplicados se van a considerar todas las columnas del dataset */
run;
/*
En la ventana LOG se indica que 19 filas duplicadas en la variable cust_id fueron eliminadas
*/




/*
******************************************************************************************************************************************
												MANIPULACION DE MAS DE UN DATASET EN SAS 
******************************************************************************************************************************************
*/



/*
Usaremos los datasets fact y factdif
*/

/*
fact.xlsx consta de las hojas:

	2011: Información de facturas del 2011. Tiene las columnas:
		Fecha		numFactura		abono
		15/08/2011	1531			$1,961.00
		
	2012: Información de facturas del 2012. Tiene las columnas
		fecha		numFactura		abono
		05/01/2012	1630			2760
	
	2013: Información de facturas del 2013. Tiene las columnas
		fecha		numfactura		abono		nosucursal
		14/01/2013	1789			2545		20
	
	11_13: Información de facturas del 2011 a 2013. Tiene las columnas
		fecha		numfactura		abono		nosucursal
		06/01/2011	1644			1175		18

factdif.xlsx consta de las hojas
	2011: Información de facturas del 2011. Tiene las columnas
		Fecha		factura			pago
		15/08/2011	1531			$1,961.00
	2012: Información de facturas del 2012. Tiene las columnas
		fecha		numFactura		abono
		19/08/0212	1648			$1,909.00
	2013: Información de facturas del 2013. Tiene las columnas
		fecha		numero			monto		sucursal
		20/10/2013	1764			1457		19
	11_13: Información de facturas del 2011 y 2013. Tiene las columnas
		fecha 		numFactura		abono		num
		12/12/2011	1649			1059		5
*/


/*
En el dataset fact.xlsx los nombres de columnas son los mismos pero se agregan nuevas columnas.
En el dataet facdit.xlsx los nombres de columnas son diferentes aunque representen la misma informacion, ademas de que en los 2 ultimos se agrega una columna extra
*/


/*
Obtener los datasets a través de libname
*/
libname f xlsx '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/fact.xlsx';
libname fd xlsx '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets/factdif.xlsx';




/*
*************************************************************************************************************************************
												REUNIONES VERTICALES:
												1.-CONCATENACION
												2.-INTERCALACION
*************************************************************************************************************************************
*/




/*
CONCATENACION
Une verticalmente dataset con los mismos nombres de variables;
No importa que haya datasets con variables que no esten en otros dataset.
Los agrega en el orden que se indica en SET	
Si hay columnas que esten en un dataset pero no en otro entonces agregara la columna pero rellenara con missing (.)
*/
data s.todas;									/*Donde guardaremos el dataset resultante*/
set f."2011"n f."2012"n f."2013"n f."11_13"n;	/*Pegar todas las observaciones de 2011, luego 2012, luego 2013 y luego las mezcladas de 2011-2013*/ /*Al llamar las hojas de una biblioteca usamos f."nombre_hoja"n */
run;											




/*
CONCATENACION
Une verticalmente dataset con los distintos nombres de variables
*/
data s.todas;
set fd."2011"n fd."2012"n fd."2013"n fd."11_13"n;	
run;
/*
Al tener distintos numero de variables, SAS agregara tantas columnas como nombres de variables diferentes haya, 
ya que no reconoce por ejemplo que "numFactura" es igual que "factura".
Esto se resolveria con un RENAME en la sentencia SET (Al inicio)
*/




/*
INTERCALACION
Permite que las observaciones se coloquen en el lugar que corresponde.
A continuacion se muestra un ejemplo con datasets que tienen los mismos nombres de variables.
También se puede hacer sobre varios dataset con distintos nombres de variables pero se tendría que usar el RENAME dentro del SET
*/




/*
Primero es necesario ordenar los conjuntos a intercalar
*/
proc sort data=f."2011"n out=s.fact_2011_ord;	/*Indicar la ruta de salida para que no se modifique el dataset original*/
by fecha;
run;

proc sort data=f."2012"n out=s.fact_2012_ord;	/*Indicar la ruta de salida para que no se modifique el dataset original*/
by fecha;
run;

proc sort data=f."2013"n out=s.fact_2013_ord;	/*Indicar la ruta de salida para que no se modifique el dataset original*/
by fecha;
run;

proc sort data=f."11_13"n out=s.fact_11_13_ord;	/*Indicar la ruta de salida para que no se modifique el dataset original*/
by fecha;
run;




/*
Procedemos a realizar la INTERCALACION
En la sentencia BY indicar la variable por la cual se va a intercalar.
*/
data s.intercaladas;													/*Donde se guardara el dataset resultante*/
set s.fact_2011_ord s.fact_2012_ord s.fact_2013_ord s.fact_11_13_ord;	/*Indicar los datasets a intercar*/
by fecha;																/*La intercalación se hara por la variable fecha*/
run;
/*
Una alernativa a la INTERCALACION sería CONCENTENAR y después ORDENAR
Nota: Al usar SAS Studio en la nube, para realizar una INTERCALACION siempre es necesario 
primero ordenar los datasets por la variable a intercalar.
En SAS instalado de manera local no es necesario realizar el ordenamiento previo.
*/



/*
PROC APPEND
Es otra alternativa para realizar la concatenación
*/



/*
Primero copiar los datasets "fact" y "factdif" solo para las hojas 2011 y 2012
*/
data s.f2011;
set f."2011"n;
run;

data s.f2012;
set f."2012"n;
run;

data s.fd2011;
set fd."2011"n;
run;

data s.fd2012;
set fd."2012"n;
run;




/*
PROC APPEND
Concatenar datasets que tienen:
	Mismo numero de columnas (variables)
	Variables con los mismos nombres
*/
proc append base=s.f2012 data=s.f2011;			/*BASE es el sataset base al cual se le añadira otro dataset. DATA es el dataset que se va a agregar al dataset base*/
run;
/*
Resultado: Al dataset BASE le pega las observaciones del dataset DATA
Al ejecutar no despliega el dataset modificado, solo el mensaje en LOG donde confirma que se agregaron los datasets.
El dataset resultante es guardado en s.f2012 y tiene la siguiente estructura:
	
	fecha 		numFactura 	abono
	01/05/2021	1630		2760
	...			...			...
	01/03/2011	1541		2768
	...			...			...
*/




/*
PROC APPEND
Concatenar datasets que tienen:
	Mismo numero de columnas (variables)
	Variables con distintos nombres
*/
proc append base=s.fd2012 data=s.fd2011 ;	/*BASE es el sataset base al cual se le añadira otro dataset. DATA es el dataset que se va a agregar al dataset base*/
run;
/*
Manda mensaje de error. Debido a que se tiene variables de nombres distintos no realiza el APPEND, pero da la opcion 
de que se puede forzar usando la palabra reservada FORCE
*/





/*
PROC APPEND
Concatenar datasets que tienen:
	Mismo numero de columnas (variables)
	Variables con los distintos nombres
*/
proc append base=s.fd2012 data=s.fd2011 FORCE;	/*BASE es el sataset base al cual se le añadira otro dataset. DATA es el dataset que se va a agregar al dataset base*/
run;
/*
Con la palabra reservada FORCE se forza a que se realice el APPEND, aunque las columnas que no encuentre es llenar con missing values.
La forma mas simple de resolver esto es renombrar los nombres de las columnas para que que coincidan en los datasets
*/



/**************************************************************************************************************************************
												REUNIONES HORIZONTALES
												1.-MERGE
**************************************************************************************************************************************/




/*
Usaremos los datasets

ctacliente tiene 12,035 filas y 2 columnas:
	idcliente		numcta
	1				C-00001
	2 				C-00002
	...				...

prestatario tienen 10,000 observaciones y 2 columnas:
	idcliente		numprestamo
	9502			P-00001
	9503			P-0002
	....			...
*/




/*
MERGE PREDETERMINADO

Hace una reunión 1 a 1 sin importar la coincidencia.
Esta acción se realiza de forma predeterminada por SAS, cuando en un programa se solicita la FUSIÓN entre
2 conjuntos de datos. 
El resultado es simplemente combinar las observaciones 1 a 1 en el orden en que aparecen en los conjuntos de datos.
*/




/* 
MERGE PREDETERMINADO
Datasets con nombres de variables iguales
*/
data s.horizontal;
merge e.ctacliente e.prestatario (rename=(numprestamo=numcta)); 	/*Indicar los datasets a reunir. Adicionalmente se hace un rename para renombrar la columna numprestamo del dataset prestatario*/
run;
/*Devuelve un dataset con 12,035 observaciones
Lo que hace este MERGE PREDETERMINADO es tomar el dataset ctacliente y literalmente superponer/encimar el dataset prestatario,
el dataset resultante es de la forma:

	idcliente		numcta
	-------------------------
	|	10,000 observaciones|
	|	del dataset 		|
	|	prestatario			|
	-------------------------
	-------------------------
	|	2,035 observaciones	|
	|	del dataset 		|
	|	ctacliente			|
	-------------------------	
*/





/* 
MERGE PREDETERMINADO
Datasets con nombres de variables distintos
*/
data s.horizontal;
merge e.ctacliente e.prestatario;  /*Omitimos el rename*/
run;
/*
Al tener nombres de variables distintos lo que hace es tomar el dataset ctacliente, se fija cuales columnas del dataset prestatario
coincinden en nomnbre, y las superpone/encima en el dataset ctacliente. Aquellas columnas del dataset prestario que no existan en
el dataset ctacliente, las agrega. El dataset queda con la siguiente estructura:

	idcliente			numcta			numprestamo
	------------------	--------------	-----------------
	|	10,000 		 |	|10,000		  |	|10,000			|
	|	observaciones|	|observaciones|	|observaciones	|
	|	del 		 |	|del          |	|del			|
	|	dataset 	 |	|dataset      |	|dataset		|
	|	prestatario	 |	|ctacliente   |	|prestatario	|
	-----------------	--------------	-----------------
	----------------------------------  -----------------
	|	2,035 observaciones			  |	|				|
	|	del dataset 				  |	|Missing Values	|
	|	ctacliente					  |	|				|
	----------------------------------	-----------------
*/




/*
MEZCLAS CON COINCIDENCIA: 
Se debe agregar la sentencia BY
Se require que los datasets a mezclarse estén ordenados.

UNO A UNO con mezcla coincidente. 
Hay 2 opciones:
	Datasets con nombres de variables iguales
	Datasets con nombres de variables distintos
*/




/*Primero se deben ordenar los datasets*/
proc sort data=e.ctacliente out=s.ctacliente_ord;
by idcliente;
run;

proc sort data=e.prestatario out=s.prestatario_ord;
by idcliente;
run;



/*
UNO A UNO con mezcla coincidente. 
Caso 1: Datasets con nombres de variables iguales
Una vez ordenados se hace la mezcla
*/
data s.horizontal;
merge s.ctacliente_ord s.prestatario_ord (rename=(numprestamo=numcta)); /*Usar los datasets ordenados. Renombrar para que los nombres coincidan*/
by idcliente;															/*Indicar atributo por el cual se hara la mezcla*/
run;
/*
Recordemos que al hacer el RENAME resulta que ambos datasets tienen las mismos nombres de columnas: 
	idcliente		numcta
Lo que hace esta mezcla es verificar si el idcliente del dataset prestatario esta en el idcliente del dataset ctacliente, 
si es así procede a sustituir el valor de numcta del dataset ctacliente por el valor de numcta del dataset prestatario. 
Esto se hara para todas las filas donde coincida el idcliente en ambos datasets.
*/



/*
UNO A UNO con mezcla coincidente. 
Caso 2: Datasets con nombres de variables distintos
Una vez ordenados se hace la mezcla
*/
data s.horizontal;							
merge s.ctacliente_ord s.prestatario_ord;				/* Omitir el RENAME para que solo coincidan en el nombre del atributo "pivote" */
by idcliente;											/*Es necesario que ambos datasets tengan el atributo pivote/llave*/
run;
/*
Ya que los nombres de variables son diferentes, no se sustituye información, solo se "pega", esto funciona parecido al JOIN
que ya conocemos de SQL.
El dataset resultante queda con las columnas 
	idcliente	numcta	numprestamo
Donde aquellos idcliente del dataset ctacliente que no tengan coincidencia en el dataset prestatario, se conservara la fila del dataset 
ctacliente y se rellenara con missing value las columnas de numprestamo.
*/




/* 
Mezclado 1 a 1 con coincidencia, simulando JOINS de SQL.
En muchos casos es posible que queramos controlar aún más, cuáles observaciones (de las que coiciden) se van
a incluir en el resultado final.
Esto lo haremos a través de una subselección de observaciones con un IF, combinado con 
la sentencia IN, con  varias opciones;
1.-NATURAL JOIN: Mantener solo las observaciones presentes en el conjunto A y B
2.-LEFT JOIN: Mantener solo las observaciones que aparecen en el conjunto A, aunque no haya coicidencia en el conjunto B
3.-RIGHT JOIN: Mantener solo las observaciones que aparecen en el conjunto B, aunque no haya coincidencia e e conjunto A
*/




/*
NATURAL JOIN:
Simulacion de NATURAL JOIN de SQL
*/
data s.mergeNJ;
merge s.ctacliente_ord (in=a) s.prestatario_ord (in=b);	/* Indicar que ctacliente sera la tabla a, y prestatario sera la tabla b */
by idcliente;											/* Indicar el atributo de mezcla */
if a = b;												/* Obtener las observaciones que esten presentes tanto en a como en b */
run;
/*
La ventana LOG confirma que se realizo correctamente:
Habia 12,035 observaciones en ctacliente_ord
Habia 10,000 observaciones en prestatario_ord
El dataset resultante tiene 5,018 observaciones de 3 variables
Se conserva solo los idcliente que estan en tabla a y tabla b
*/




/*
LEFT JOIN:
Simulacion de LEFT JOIN de SQL
*/
data s.mergeLJ;
merge s.ctacliente_ord (in=a) s.prestatario_ord (in=b);		/* Indicar que ctacliente sera la tabla a, y prestatario sera la tabla b */
by idcliente;												/* Indicar el atributo de mezcla */
if a;														/* Conservar las observaciones de la tabla a, tengan o no tengan coincidencia en b*/
run;




/*
RIGHT JOIN:
Simulacion de RIGHT JOIN de SQL
*/
data s.mergeLRJ;
merge s.ctacliente_ord (in=a) s.prestatario_ord (in=b);		/* Indicar que ctacliente sera la tabla a, y prestatario sera la tabla b */
by idcliente;												/* Indicar el atributo de mezcla */
if b;														/* Conservar las observaciones de la tabla b, tengan o no tengan coincidencia en a*/	
run;

/*NOTA: MERGE ES UNA OPERACION BINARIA, ES NECESARIO HACERLO SOLO CON PAREJAS DE TABLAS*/


/**********************************************************************************************************************************
												PROCESAMIENTO DE DATOS 
												MEDIANTE PROC SQL 
***********************************************************************************************************************************/




/*
Tenemos 2 opciones: 
	-Conectarnos a una base de datos
	-Manipular los datsets en SAS como si fueran una base de datos
*/




/*Configuración en SAS instalado de manera local para conectarmos a una base de datos*/




/*Imprimir el contendo de una tabla usando PROC PRINT*/
proc print data=e.ctacliente (obs=15);			/*Desplegar solo las primeras 15 observaciones*/
run;




/*
SQL: Lenguaje de consulta estructurado
Es un lenguaje declarativo, significa que solo debemos indicar que debemos obtener.
Precisa el uso de consultas, que tiene una estructura particular y consta de partes obligatorias y opciones:
Obligatorias:
	SELECT		Que quieres recuperar		Lista de columnas
	FROM		De donde tomamos los datos	Lista de tablas
Opcionales
	WHERE		Que condicion debe cumplir las tuplas que se van a recuperar
	GROUP BY	Como agrupar
	HAVING		Filtros o condiciones sobre los grupos formado
	ORDER BY	Como queremos ordenar
*/




/*Es necesario trabajar con el esquema de la base de datos para conocer los atributos de cada tabla y las llaves primarias y 
foraneas*/



/*
PROC SQL
Imprimir el contenido de una tabla y filtrar filas
Obtener toda la informacion de las sucursales de Hidalgo
*/
proc sql;
title 'Sucursales del Estado de Hidalgo';
select 	*										/*Indicar las columnas que requiero*/
from 	e.sucursal								/*Indicar de donde tomaremos los datos*/
where 	estado='HIDALGO';						/*Indicar la condicion*/
quit;											/*Este procedimiento requiere cerrase con un QUIT no con RUN*/										




/*
PROC SQL
Crear una copia de un dataset
*/		
PROC SQL;										/*Donde se va a guardar en nuevo dataset*/
CREATE TABLE s.sucursalcopia AS					/*Sentencia para crear una tabla*/
SELECT * FROM e.sucursal;						/*Consulta en la cual nos basaremos para crear el nuevo dataset*/
QUIT;											/*Cerrar el PROC SQL usando la sentencia QUIT*/




/*
*****************************************************************************************************************************
											REUNIONES UTILIZANDO PROC SQL
*****************************************************************************************************************************
*/


/*
Primero crear dos tablas para ejemplificar
*/
PROC SQL;
CREATE TABLE s.a AS												/* Sentencia para crear una tabla a partir de la consulta */
SELECT numsucursal AS ns1, nombresucursal AS s1, estado AS e1	/* Seleccionar las variables de interes y asignar el alias */
FROM e.sucursal 												/* De donde nos basaremos para crear el nuevo datset */
WHERE estado = 'HIDALGO';										/* Obtener informacion solo de la variable estado */
QUIT;															/* Cerrar el proc sql */
/*Este es un dataset de 6 filas x 3 columnas*/

PROC SQL;
CREATE TABLE s.b AS												/* Sentencia para crear una tabla a partir de la consulta */
SELECT numsucursal AS ns2, nombresucursal AS s2, estado AS e2	/* Seleccionar las variables de interes y aplicarles un alias */
FROM e.sucursal 												/* De donde nos basaremos para crear el nuevo datset */
WHERE estado = 'NAYARIT';										/* Obtener informacion solo de la variable estado */
QUIT;															/* Cerrar el proc sql */
/*Este es un dataset de 3 filas x 3 columnas*/




/*
*****************
CROSS JOIN 
*****************
Realiza el producto cartesiano: Combinación de todos vs todos
Ser cuidadoso con este pues consume muchos recursos
*/
PROC SQL;
CREATE TABLE s.crossjoin AS									/*Sentencia CREATE TABLE para generar un dataset a partir de una consulta*/
SELECT *
FROM s.a CROSS JOIN s.b;
QUIT;
/*El dataset resultantes es de 18 filas x 6 columnas*/




/*
*****************
NATURAL JOIN
*****************
Este join es por coincidencia de atributos, esto es, que en las tablas los atributos se llamen igual y tengan el mismo tipo de atributo.
A diferencia de MERGE, en PROC SQL  no es necesario ordenar los datasets antes de hacer la reunion.
*/
PROC SQL;
CREATE TABLE s.naturaljoin AS
SELECT *
FROM e.ctacliente NATURAL JOIN e.prestatario;
QUIT;
/*Es nos devuelve la información de los clientes que tiene cuenta en el banco*/




/*
*****************
THETA JOIN
*****************
El NATURAL JOIN no esta implementado en todos los SMBD por ejemplo, no existe en MYSQL o SQLSERVER, por lo cual hay una alternativa, 
utilizar el JOIN con condicion o tambien llamado THETA JOIN.
Si el JOIN se hace por coincidencia de atributos tambien se le conoce como EQUI JOIN
*/
PROC SQL;
CREATE TABLE s.equijoin AS
SELECT *
FROM e.ctacliente JOIN e.prestatario ON ctacliente.idcliente = prestatario.idcliente; /*Se usa la sentencia JOIN pero se especifica el atributo donde deben coincidir usando la sentencia ON*/
QUIT;
/*El resultado es igual al obtenido con NATURAL JOIN, aunque si se hace en un SMBD como postgresql si hay una diferencia importante,
con el natural join el atributo pivote se muestra como una sola columna, mientras que con THETA JOIN el atributo pivote se
muestra en 2 columnas, una que corresponde a la tabla A y otra columnas que corresponde a la tabla B.
Es por esto que al usar el THETA JOIN la ventana LOG nos mostrara un mensaje.
*/



/*
Tanto el LEFT JOIN como el RIGHT JOIN se puede utilizar en PROC SQL, y se puede hacer desde 2 perspectivas:
	Utilizando NATURAL JOIN
	Utilizando THETA JOIN
Como vimos, en PROC SQL no hay diferencia de que camino usemos ya que nos devuelve el mismo resultado, 
pero al usar un SMBD si habra diferencia conceptual ya que devuelve la columna pivote 2 veces.
*/




/*
*****************
LEFT JOIN
*****************
Utilizando perspectiva NATURAL
*/
PROC SQL;
CREATE TABLE s.leftnaturaljoin AS
SELECT *
FROM e.ctacliente NATURAL LEFT JOIN e.prestatario;												/*LEFT JOIN con perspectiva NATURAL*/
QUIT;
/*Devuelve un dataset de 15,042 filas por 3 columnas. Son los clientes que (solo tienen cuenta) o (clientes que tienen cuenta y prestamo)*/




/*
*****************
LEFT JOIN
*****************
Utilizando perspectiva THETA
*/
PROC SQL;
CREATE TABLE s.equijoinleft AS
SELECT *
FROM e.ctacliente LEFT JOIN  e.prestatario ON ctacliente.idcliente = prestatario.idcliente;		/*LEFT JOIN con perspectiva THETA*/
QUIT;
/*Devuelve un dataset de 15,042 filas por 3 columnas. Son los clientes que (solo tienen cuenta) o (clientes que tienen cuenta y prestamo)*/




/*Obtener los clientes que solo tiene cuenta*/
PROC SQL;
CREATE TABLE s.solocuenta AS
SELECT *
FROM e.ctacliente NATURAL LEFT JOIN e.prestatario
WHERE numprestamo is NULL;
QUIT;
/*Devuelve un dataset de 7,019 filas por 3 columnas. Son los clientes que solo tienen cuenta pero no tiene prestamo*/




/*
*****************
RIGHT JOIN
*****************
Utilizando perspectiva NATURAL
*/
PROC SQL;
CREATE TABLE s.rightnaturaljoin AS
SELECT *
FROM e.ctacliente NATURAL RIGHT JOIN e.prestatario;												/*RIGHT JOIN con perspectiva NATURAL*/
QUIT;
/*Devuelve un dataset de 15,042 filas por 3 columnas. Son los clientes que tienen (cuenta y prestamo) o (aquellos clientes que tiene solo prestamo).*/




/*
***********************************************************************************************************************
										MATERIAL EXTRA DE PROC SQL
***********************************************************************************************************************
*/

libname e '/home/u61754732/sasuser.v94/Modulo1/EvaluaciónFinal';
libname s '/home/u61754732/sasuser.v94/Modulo1/C3';


/*Una consulta sencilla*/
PROC SQL;
SELECT *
FROM e.cliente
WHERE estado='CHIAPAS';
QUIT;


/*Guardar la tabla como dataset SAS*/
PROC SQL;
CREATE TABLE s.clientechiapas AS
SELECT *
FROM e.cliente
WHERE estado='CHIAPAS';
QUIT;


/*Reunión entre varias tablas usando la condicion. Similar a THETA JOIN*/
proc sql;
create table s.clientecuentas AS
select a.nombrecliente, b.numcta, saldo
from e.cliente a, e.ctacliente b, e.cuenta c
where a.nombrecliente = b.nombrecliente and b.numcta =c.numcta;
quit;
/*Devuelve un dataset de 13708 x 3*/



/*NATURAL JOIN */
/*Ya que NATURAL JOIN por defaul conserva solo una de las columnas pivote al hacer la reunion, no es necesario
especificar en la sentencia select de que tabla queremos jalar el atributo*/
proc sql;
create table s.clientecuentas AS
select nombrecliente, numcta, saldo
from e.cliente NATURAL JOIN e.ctacliente NATURAL JOIN e.cuenta;
quit;
/*Devuelve un dataset de 13708 x 3. Es el mismo resultado que la consula anterior*/



/*JOIN*/
/*Similar al THETHA JOIN ya que se debe establecer la condicion sobre los atributos que se usan como pivote*/
/*Primero se hace la reunion de cliente con ctacliente y usando ON se establece la condicion.*/
/*Posteriormente se hace la reunion con la tabla cuenta y se establece la condicion con la sentencia ON*/
/*Ya que usamos un THETA JOIN es necesario especificar en el SELECT de que tabla vamos a obtener cada atributo para no tener ambiguedad*/
proc sql;
create table s.clientecuentas AS
select a.nombrecliente, b.numcta, saldo
from e.cliente a JOIN e.ctacliente b ON a.nombrecliente = b.nombrecliente 
	JOIN e.cuenta c ON b.numcta =c.numcta;
quit;
/*Devuelve un dataset de 13708 x 3. Es el mismo resultado que la consula anterior*/



/*INNER JOIN*/
/*Da exactamente el mismo resultado que la consulta anterior con la salvedad de que SAS si reconoce INNER JOIN como palabra
reservada y lo poner en color azul. De allí en fuera es indistinto usar INNER JOIN o usar solo JOIN*/
proc sql;
create table s.clientecuentas AS
select a.nombrecliente, b.numcta, saldo
from e.cliente a INNER JOIN e.ctacliente b ON a.nombrecliente = b.nombrecliente 
	INNER JOIN e.cuenta c ON b.numcta =c.numcta;
quit;
/*Devuelve un dataset de 13708 x 3. Es el mismo resultado que la consula anterior*/




/*Tambien existen los JOIN EXTERNOS que nos sirven para realizar busqueda de informacion faltantes*/
/*Estos se pueden implementar desde las dos perspectivas:
	-Perspectiva NATURAL JOIN
	-Perspectiva THETA JOIN
*/


/*LEFT JOIN usando la perspectiva NATURAL JOIN*/
/*Recordemos que desde la perspectiva NATURAL JOIN no es necesario especificar la condicion pues se sobreentiende que el atributo pivote 
se llama igual en ambas tablas*/
proc sql;
create table s.cuentasleft as
select *
from e.ctacliente NATURAL LEFT JOIN e.prestatario;
quit;




/*LEFT JOIN usando la perspectiva NATURAL JOIN*/
/*Obtener aquellos clientes que unicamente tiene cuenta en el banco (ie no tiene prestamo)*/
proc sql;
create table s.cuentasleft as
select *
from e.ctacliente NATURAL LEFT JOIN e.prestatario
WHERE numprestamo is NULL;
quit;



/*RIGHT JOIN usando la perpspectiva THETA JOIN*/
/*Al usar esta perspectiva se debe especificar la condicion sobre los atributos pivote*/
/*Esta consulta recupera solo la informacion de los clientes que tiene prestamos pero no tienen cuenta*/
proc sql;
create table s.cuentasright as
select b.nombrecliente, numcta, numprestamo
from e.ctacliente a RIGHT JOIN e.prestatario b ON a.nombrecliente = b.nombrecliente
WHERE numcta is NULL;
quit;



/*CONSULTAS DE RESUMEN*/

/*MAX*/
/*Obtener el saldo maximo de las cuentas del banco*/
proc sql;
select max(saldo)
from e.cuenta;
quit;



/*MAX sobre una SUBCONSULTA*/
/*Obtener datos de la cuenta con saldo maximo del banco*/
proc sql;
select * 
from e.cuenta
where saldo =  select max(saldo) from e.cuenta;
quit;


/*MAX sobre una SUBCONSULTA*/
/*Obtener datos de la cuenta con saldo maximo del banco*/
proc sql;
select a.*,nombresucursal 
from e.cuenta a NATURAL JOIN  e.sucursal b
where saldo =  select max(saldo) from e.cuenta;
quit;



/*Obtener información resumen para todas las cuentas del banco*/

/*Paso 1:Obtener la tabla con la reunión. La usaremos de manera auxiliar*/
PROC SQL;
CREATE TABLE s.auxiliar AS
SELECT *
FROM e.cuenta a JOIN e.sucursal b ON a.nombresucursal = b.nombresucursal;	/*Usamos la perspeciva THETHA JOIN. Si quisieramos usar la perspectica NATURAL JOIN debemos poner:  FROM cuenta NATURAL JOIN sucursal; */
QUIT;



/*Paso 2:Obtener el resumen para todas las cuentas del banco*/
PROC SQL;
CREATE TABLE s.resumencuentas AS
SELECT 	estado, 
		nombresucursal, 
		sum(saldo) AS Suma_Saldo, 
		avg(saldo) AS Avg_Saldo, 
		max(saldo) AS Max_saldo,  
		min(saldo) AS Min_saldo, 
		count(numcta) As Conteo
FROM s.auxiliar
GROUP BY estado, nombresucursal
ORDER BY 1,2;
QUIT;



/*Paso 3: Darle formato a las columnas*/
PROC SQL;
CREATE TABLE s.resumencuentas AS
SELECT 	estado, 
		nombresucursal, 
		sum(saldo) AS Suma_Saldo format = dollar18.2, 
		avg(saldo) AS Avg_Saldo format = dollar12.2, 
		max(saldo) AS Max_saldo format = dollar12.2,  
		min(saldo) AS Min_saldo format = dollar12.2, 
		count(numcta) as Conteo
FROM s.auxiliar
GROUP BY estado, nombresucursal
ORDER BY 1,2;
QUIT;




/*Ejercicio: Obtener la información de cuentas que se obtuvieron de sucursales de GUANAJUATO y fecha mayor a 20 mayo 2013*/
PROC SQL;
TITLE 'Cuentas de las sucursales de Guanajuato';
SELECT *
FROM e.cuenta NATURAL JOIN e.sucursal
WHERE estado='GUANAJUATO' AND fecha >= '20MAY2013'd
ORDER BY nombresucursal,fecha;
QUIT;



/*Ejercicio: Obtener la información de cuentas que se obtuvieron de sucursales de GUANAJUATO y año mayor entre 2012 y 2013 */
PROC SQL;
TITLE 'Cuentas de las sucursales de Guanajuato';
SELECT *
FROM e.cuenta NATURAL JOIN e.sucursal
WHERE estado='GUANAJUATO' AND year(fecha) BETWEEN 2012 AND 2013 		/*Tambien se puede extraer el mes con la funcion MONTH, el dia con DAY, dia de la semana con DAYWEEK, semana con WEEK, trimestre con QTR*/
ORDER BY nombresucursal,fecha;
QUIT;




/*Ejercicio: Obtener la información de cuentas que se obtuvieron de sucursales de GUANAJUATO y del primer y tercer trimestre del 2012 */
PROC SQL;
TITLE 'Cuentas de las sucursales de Guanajuato';
SELECT *
FROM e.cuenta NATURAL JOIN e.sucursal
WHERE estado='GUANAJUATO' AND year(fecha) = 2012 AND QTR(fecha) IN (1,3) 	/*Tambien se puede extraer el mes con la funcion MONTH, el dia con DAY, dia de la semana con DAYWEEK, semana con WEEK, trimestre con QTR*/
ORDER BY nombresucursal,fecha;
QUIT;




/*Obtener el total de cuentas y saldo promedio, agrupado por estado y por sucursal*/
PROC SQL;
CREATE TABLE s.resumencuentas AS
SELECT 	estado, 
		a.nombresucursal, 
		count(numcta) AS total_cuenta label = 'Total Cuentas',
		avg(saldo) AS saldo_promedio label ='Saldo Promedio' format =dollar18.2
FROM e.cuenta a INNER JOIN e.sucursal b ON a.nombresucursal = b.nombresucursal
GROUP BY estado, a.nombresucursal
ORDER BY 1,2;
QUIT;




