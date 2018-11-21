with defs_general,d_historial_mascota;
with d_historial_visita,d_consulta,d_sala_espera,pparaula,ada.Text_IO;
use defs_general;
use d_historial_mascota,pparaula,ada.Text_IO;

package d_clinica is

	type base_datos is limited private;
	type visita is limited private;
	mal_argumento:exception;
	no_disponible:exception;
	space_overflow: exception;
	malos_usos: exception;

	procedure 	iniciar_clinica(bd:in out base_datos);
	procedure 	imprimirConsultas(bd:in out base_datos);
	procedure 	registrar_mascota(bd:in out base_datos; name: in char_string; tv: in tvisita; id: out name_id);
	procedure 	poner_lista_espera(bd:in out base_datos;v:in visita);
	function 	disponibilidad_consulta_abierta(bd:in out base_datos;n:out num_cons) return integer;
	function 	disponibilidad_consulta_cerrada(bd:in out base_datos;n:out num_cons) return integer;
	procedure 	insertar_consulta(bd:in out base_datos;n:in num_cons);
	procedure 	decrementar_ciclos(bd:in out base_datos;v:out visita;id:in name_id);
	procedure 	rellenar_visita(v:out visita;i:in name_id;name:in char_string;tvis:in tvisita);
	procedure 	abrir_consulta(bd:in out base_datos;n: in num_cons);
	procedure 	cerrar_consulta(bd:in out base_datos;n: in num_cons);
	procedure 	mostrar_historial_visita(bd:in out base_datos;tv:in tvisita);
	procedure 	mostrar_historial_mascota(bd:in out base_datos;name: in char_string);
	function 	print(x1: in visita) return string;
	procedure 	mostrar_sala_espera(bd:in out base_datos);
	function 	comprobar_dentro(bd:in out base_datos;id:in name_id) return boolean;
	procedure 	modificar_dentro(bd:in out base_datos;id:in name_id;b:in boolean);

private

	type visita is record
	identifier: name_id; --ID de la mascota
	nom:char_string;
	tv:tvisita;			 --Tipo de visita
	end record;
	
	package historial_visita is new d_historial_visita(name_id,"<",">");
	use historial_visita;
	package sala_espera is new d_sala_espera(visita,print);
	use sala_espera;
	package consulta is new d_consulta(visita);
	use consulta;
	
	type base_datos is record
		tn: names_table;
		ls: lista_espera;
		hv: hvis;
		cn: consultas;
	end record;
	
end d_clinica;