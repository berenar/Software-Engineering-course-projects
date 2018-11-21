with defs_general;use defs_general;
limited with d_clinica; 
with ada.Text_IO; use ada.Text_IO;

generic
	type visita is private;
package d_consulta is
	fallo_box:exception;
	no_consulta_disponible:exception;
	type consultas is limited private;

	procedure 	iniciarCons		 (c:in out consultas);
	procedure 	imprimirConsultas(c:in out consultas);
	procedure 	abrir_consulta	 (c:in out consultas;n: in num_cons);
	procedure 	cerrar_consulta	 (c:in out consultas;n: in num_cons);
	procedure 	llenar_consulta	 (c:in out consultas;n: in num_cons;tv:in tvisita;v:in out visita);
	procedure 	decr_ciclos		 (c:in out consultas;n: in num_cons;v:out visita;alerta:out integer);
	function 	consulta_libre	 (c:in out consultas) return num_cons;
	function 	consulta_cerr	 (c:in out consultas) return num_cons;

private
	type estado is(disp, ocu);
	type ciclos_rest is new ciclos;

	type consulta is record
		e:boolean;
		est:Integer;
		ciclos_en_cn:ciclos_rest;
		box:visita;
	end record;

	type m_consultas is array(num_cons) of consulta;

	type consultas is record
		contador:integer;
		consul:m_consultas;
	end record;


end d_consulta;