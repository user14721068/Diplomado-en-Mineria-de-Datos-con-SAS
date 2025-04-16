/*
Diplomado en Minería de Datos con SAS
Módulo 1: Inteligencia de Negocios
Evaluación Final Parte 2: Manipulación de datasets
Alumno: Nicolás Cruz Ramírez
*/


*Biblioteca de entrada;
libname e '/home/u61754732/sasuser.v94/Modulo1/EvaluaciónFinal';
*Biblioteca de salida;
libname s '/home/u61754732/sasuser.v94/Modulo1/EvaluaciónFinal';
*Importar el dataset "bank_custom.xlsx" a traves de una biblioteca SAS;
libname bank xlsx '/home/u61754732/sasuser.v94/Modulo1/EvaluaciónFinal/bank_custom.xlsx';





/*
2. Manipulación de datasets
Carga en SAS el conjunto de datos bank_custom.xlsx y realiza las siguientes tareas:
*/




/*
Crea un dataset en donde apliques un formato de visualización para las variables Date Joined y 
Balance. El dataset se debe llamar clientesf.
*/
data s.clientesf;
set bank.bank_custom;
format 'Date Joined'n espdfwdx. Balance dollar14.2;
run;




/*
A partir de clientesf, crea un par de datasets, uno donde ya no existan las variables Gender y Age 
y otro donde solo aparezcan las variables Customer_ID, Region y Balance.
*/
data s.clientesfkeep;
set s.clientesf (keep = 'Customer ID'n Region Balance);
run;

data s.clientesfdrop;
set s.clientesf (drop = Gender Age);
run;




/*
Crea un dataset a partir de clientesf, donde modifiques la variable Balance, en este caso, se hará 
un incremente del 10% a los clientes de la región England, de un 8% a los clientes de Scotland y de 
un 9% a los clientes de Wales; para los demás el incremento será del 5%. Debes mostrar tanto el 
balance actual como el modificado
*/
data s.clientesfbalance;
set s.clientesf;
format Balance_anterior dollar14.2;  	*Formato para la variable de Balance_anterior;
Balance_anterior = Balance;
if Region = 'England' then Balance = Balance * 1.10;
else if Region = 'Scotland' then Balance = Balance * 1.08;
else if Region = 'Wales' then Balance = Balance * 1.09;
else Balance = Balance * 1.05;
run;




/*
Crea un programa que permita distribuir a los clientes en tres datasets, que corresponden a los 
clientes de 3 grupos: los del grupo 1 son aquellos que tienen un balance entre $5 y $75,000; el grupo 
2 para los que tengan un balance entre $75,000 y $135,000; el tercer grupo es para aquellos clientes 
que tengan un balance mayor a los $135,000.
*/
data s.clientesfgrupo1 s.clientesfgrupo2 s.clientesfgrupo3;
set s.clientesf;
if Balance >= 5 & Balance < 75000 THEN OUTPUT s.clientesfgrupo1;
else if Balance >= 75000 & Balance < 135000 THEN OUTPUT s.clientesfgrupo2;
else if Balance > 135000 THEN OUTPUT s.clientesfgrupo3;
run;




/*Crea un programa en SAS que permita obtener el balance promedio para todo el banco y el
balance promedio por región.*/

/*Balance Promedio para todo el banco*/
data s.clientesfptotal (keep = promedio);				
format promedio dollar12.4;
set s.clientesf end=ultimo;
retain acumulador contador;
contador + 1;
acumulador + Balance;
promedio = acumulador / contador;
if ultimo;
run;

/*Dataset auxiliar para ordenar por Region*/
proc sort data=s.clientesf out=s.clientesfordenado; 
by Region;
run;

/*Balance Promedio por Region*/
data s.clientesfregion (keep=Region promedio);
set s.clientesfordenado;
format promedio dollar12.4;
by Region;
retain acumulado contador promedio;
if first.Region then do;
	acumulado = 0;
	contador = 0;
	acumulado = acumulado + Balance;
	contador + 1;
	promedio = acumulado/contador;
end;
else do;
	acumulado = acumulado + Balance;
	contador + 1;
	promedio = acumulado/contador;
end;
if last.Region then output;	
run;




/*Utiliza los datasets cliente, cuenta, prestamo, ctacliente, prestatario y sucursal, para realizar las
siguientes consultas*/


/*Información de todas las cuentas que se tienen en los estados de Oaxaca, Puebla y Chiapas.*/
proc sql;
create table s.consulta1 as
select a.nombresucursal AS Sucursal, numcta as Numero_Cuenta , saldo format dollar18.2, fecha format=espdfwdx., estado
from s.cuenta a INNER JOIN s.sucursal b ON a.nombresucursal=b.nombresucursal
where estado IN ('OAXACA','PUEBLA','CHIAPAS')
ORDER BY estado;
quit;


/*Información de los clientes que tiene cuenta y prestamos en sucursales de Guanajuato.*/
proc sql;
create table s.consulta2 as
select *
from s.cliente j 
WHERE j.nombrecliente IN 	select a.nombrecliente 
							from s.cliente a INNER JOIN s.ctacliente b ON a.nombrecliente=b.nombrecliente
											INNER JOIN s.prestatario c ON a.nombrecliente=c.nombrecliente 
											INNER JOIN s.cuenta d ON d.numcta=b.numcta
											INNER JOIN s.sucursal f ON f.nombresucursal=d.nombresucursal
											INNER JOIN s.prestamo g ON g.numprestamo=c.numprestamo
							where a.nombrecliente IS NOT NULL and g.importe IS NOT NULL and f.estado='GUANAJUATO';
quit;


/*Un reporte donde indiques el saldo promedio, número de cuentas abiertas, saldo mínimo, saldo
máximo y la suma de los saldos por estado y nombre de sucursal,*/
proc sql;
create table s.consulta3 as
select 	estado, 
		b.nombresucursal, 
		avg(saldo) AS Saldo_Promedio format =dollar18.2,
		count(numcta) AS Numero_de_Cuentas,
		min(saldo) AS Saldo_Minimo format =dollar18.2,
		max(saldo) AS Saldo_Maximo format =dollar18.2,
		sum(saldo) AS Saldo_Total format =dollar18.2
from s.cuenta a INNER JOIN s.sucursal b ON a.nombresucursal=b.nombresucursal
group by estado, b.nombresucursal;
quit;


/*Un reporte donde indiques el importe promedio, número de préstamos otorgados, importe
mínimo, importe máximo y la suma de los importes por estado y nombre de sucursal. Solo importa
la información para el Norte del País.*/
proc sql;
create table s.consulta4 as
select 	estado, 
		b.nombresucursal, 
		avg(importe) AS Importe_Promedio format =dollar18.2,
		count(numprestamo) AS Numero_de_Prestamos,
		min(importe) AS Importe_Minimo format =dollar18.2,
		max(importe) AS Importe_Maximo format =dollar18.2,
		sum(importe) AS Importe_Total format =dollar18.2
from s.prestamo a INNER JOIN s.sucursal b ON a.nombresucursal=b.nombresucursal
where estado in ('BAJA CALIFORNIA','COAHUILA','CHIHUAHUA','DURANGO','NUEVO LEÓN','SINALOA','SONORA','TAMAULIPAS')
group by estado, b.nombresucursal
order by 1,2;
quit;