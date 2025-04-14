*Funciona, pero se tiene que restablecer la sesión de SAS;
*En caso de que no se hayan definido los libname de entrada/salida;
libname e '/home/u61754732/my_shared_file_links/u61536033/01BI/Datasets';
libname s '/home/u61754732/sasuser.v94/Modulo1/C4';
filename archivo '/home/u61754732/sasuser.v94/Modulo1/C4/pagina.html';

*Habilitar el tagset;
/*IMPORTANTE: Incluir el archivo tableeditor.tpl en nuestra sesión SAS usando una variable macro*/
%inc '/home/u61754732/my_shared_file_links/u61536033/01BI/tableeditor/tableeditor.tpl';




/*Para este ejemplo tendremos una pagina html con:
	-1 tabla generada con PROC TABULATE
	-5 graficas sencillas
*/


* IMPORTANTE: Una vez ejecutado, descargar pagina.html, graf1, graf2, graf3, graf4 y graf5;
* IMPORTANTE: Este proceso funcionara solo para graficas que generen una sola grafica. De lo contrario tendremos errores.;




ods tagsets.tableeditor file = archivo								/*Aqui poner el nombre del archivo donde se guardara. En nuestro caso el archivo es pagina.html*/
options(web_tabs = 'tabla1,tabla2,graf1,graf2,graf3,graf4,graf5') 	/*Especificar en la cadena los archivos que se generaran y utilizaran.*/
style=statistical;





*PROC TABULATE CON FORMATO;
proc tabulate data = e.detalle;
title1 'MI BANQUITO 2, S.A. DE C.V.';
title2 'CUENTAS POR SUCURSAL';
footnote1 'Reporte elaborado el &sysdate9';
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





*PROC TABULATE CON FORMATO;
proc tabulate data = e.detalle;
title1 'MI BANQUITO, S.A. DE C.V.';
title2 'CUENTAS POR SUCURSAL';
footnote1 'Reporte elaborado el &sysdate9';
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



filename grafout '/home/u61754732/sasuser.v94/Modulo1/C4';
ods listing;
goptions device=png;
ods html path = grafout;

proc gchart data = e.reportefecha;
vbar estado / name = 'graf1';
title 'Total de Cuentas por estado';
run;
quit;


proc gchart data = e.reportefecha;
vbar estado / group = anio type = pct  inside = freq outside=PCT name = 'graf2';
title 'Porcentaje Cuentas región sureste por año';
where estado in ('CHIAPAS','YUCATÁN','QUINTANA ROO');
run;
quit;

proc gchart data = e.reportefecha;
vbar estado / group = trimestre type = mean  inside = freq outside = mean sumvar = saldo 
name = 'graf3';
title 'Saldo promedio región sureste por año';
where estado in ('CHIAPAS','YUCATÁN','QUINTANA ROO');
run;
quit;

proc gchart data = e.reportefecha;
vbar estado / group = anio type = sum  inside = mean outside = sum sumvar = saldo 
name = 'graf4';
title 'Suma saldos región sureste en 2013, trim 1 y 3';
where estado in ('CHIAPAS','YUCATÁN','QUINTANA ROO') and anio = 2012 and trimestre in (1,3);
run;
quit;

proc gchart data = e.reportefecha;
vbar estado / subgroup = trimestre name = 'graf5';
title 'Cuentas contratadas en 2013 por trimestre';
where anio = 2013;
run;
quit;

ods html close;
ods listing close;
filename grafout clear;

ods tagsets.tableeditor close;						

