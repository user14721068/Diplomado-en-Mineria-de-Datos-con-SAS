/*
Diplomado en Minería de Datos con SAS
Módulo 1: Inteligencia de Negocios
Evaluación Final Parte 3: Reportes SAS
Alumno: Nicolás Cruz Ramírez
*/


*Biblioteca de entrada;
libname e '/home/u61754732/sasuser.v94/Modulo1/EvaluaciónFinal';
*Biblioteca de salida;
libname s '/home/u61754732/sasuser.v94/Modulo1/EvaluaciónFinal';
/*Definir los filenames*/
filename Reporte1 '/home/u61754732/sasuser.v94/Modulo1/EvaluaciónFinal/Reporte1.html';
filename Reporte2 '/home/u61754732/sasuser.v94/Modulo1/EvaluaciónFinal/Reporte2.html';
filename Reporte3 '/home/u61754732/sasuser.v94/Modulo1/EvaluaciónFinal/Reporte3.html';
filename Reporte4 '/home/u61754732/sasuser.v94/Modulo1/EvaluaciónFinal/Reporte4.html';
/*Incluir el archivo tableeditor.tpl*/
%inc '/home/u61754732/my_shared_file_links/u61536033/01BI/tableeditor/tableeditor.tpl';

/*
Tomando como base el dataset HEART que se te proporciona y que mantiene información de alrededor
de 5209 observaciones correspondientes a un estudio de enfermedades del corazón. Apoyándote en
lo revisado en clase, crea un par de reportes y/o gráficas (los datos a mostrar son a tu consideración)
utilizando: PROC PRINT, PROC TABULATE y PROC GCHART
*/

/*
Reporte 1: Uso de proc print
*/

ods tagsets.tableeditor
file=Reporte1
options(
background_color = 'white'
highlight_color = 'grey'								
data_bgcolor = 'white'									
title_style = 'normal'									
header_bgcolor = 'lightblue'							
header_fgcolor = 'darkblue'
rowheader_bgcolor = 'lightblue'						
rowheader_fgcolor = 'darkblue'
autofilter = 'yes'									
);
proc print data = e.heart noobs;
id Status;
var  DeathCause AgeAtDeath Sex Smoking_Status; 								
where Status in ('Dead');
format saldoprom dollar14.2;
title1 "REPORTE DE DEFUNCIONES";
footnote1 "ELABORADO EL &sysdate9";
run;
ods tagsets.tableeditor close;

/*
Reporte 2: Uso de proc print
*/

ods tagsets.tableeditor
file=Reporte2
options(
background_color = 'white'
highlight_color = 'grey'								
data_bgcolor = 'white'									
title_style = 'normal'									
header_bgcolor = 'lightblue'							
header_fgcolor = 'darkblue'
rowheader_bgcolor = 'lightblue'						
rowheader_fgcolor = 'darkblue'
autofilter = 'yes'									
);
proc print data = e.heart noobs;
id Status;
var  AgeAtStart Height Weight Cholesterol Chol_Status BP_Status Smoking Smoking_Status; 								
where Status in ('Alive') and weight_status IN ('Underweight');
format saldoprom dollar14.2;
title1 "REPORTE DE PACIENTES VIVOS CON BAJO PESO";
footnote1 "ELABORADO EL &sysdate9";
run;
ods tagsets.tableeditor close;

/*
Reporte 3: Uso de proc tabulate
*/

ods html file = reporte3;	/*HTML*/
proc tabulate data = e.heart;
title1 "REPORTE DE EDAD EN PACIENTES ATENDIDOS";
footnote1 "ELABORADO EL &sysdate9";
class Status Sex;												
var AgeAtStart;															
table Status*Sex,	AgeAtStart*n='Conteo' 
					AgeAtStart*max = 'Edad Max' 
					AgeAtStart*min = 'Edad Min' 
					AgeAtStart*mean = 'Edad Prom';
run;
ods html close;		

/*
Reporte 4: Uso de proc tabulate
*/

ods html file = reporte4;	/*HTML*/
proc tabulate data = e.heart;
title1 "REPORTE DE EDAD DE FALLECIMIENTO DESGLOSADO POR SEXO Y CONSUMO DE CIGARRILLO";
footnote1 "ELABORADO EL &sysdate9";
class Sex Smoking_Status ;		
var AgeAtDeath;																								
table Sex*Smoking_Status,	AgeAtDeath*n='Conteo' 
					AgeAtDeath*max = 'Edad Max' 
					AgeAtDeath*min = 'Edad Min' 
					AgeAtDeath*mean = 'Edad Prom';
run;
ods html close;		

/*
Reporte 5: Uso de gchart
*/
filename grafout '/home/u61754732/sasuser.v94/Modulo1/EvaluaciónFinal'; 
ods listing;
goptions device=png;													
ods html path = grafout;		

proc gchart data = e.heart;
vbar status / group=sex subgroup=Weight_Status outside=pct autoref clipref	
name = 'Reporte5';															
title 'NUMERO DE PACIENTES POR ESTATUS, SEXO Y TIPO DE PESO';	
footnote1 "ELABORADO EL &sysdate9";						
run;
quit;

/*
Reporte 6: Uso de ghcart
*/
proc gchart data = e.heart;
hbar3d smoking_status / group=sex subgroup=Weight_Status outside=pct autoref clipref	
name = 'Reporte6';															
title 'NUMERO DE DEFUNCIONES POR TIPO DE HABITO DE CONSUMO DE CIGARRO, POR SEXO Y POR TIPO DE PESO';	
footnote1 "ELABORADO EL &sysdate9";		
where Status = 'Dead';				
run;
quit;

ods html close;															
ods listing close;														
filename grafout clear;			










