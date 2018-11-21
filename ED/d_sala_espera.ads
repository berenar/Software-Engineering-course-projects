with Ada.containers, defs_general,d_heap;
limited with d_clinica;--Quitar dependencia circular.
use Ada.containers, defs_general;
with ada.Text_IO; use ada.Text_IO;
generic
	type visita is private;
	with function Image(x1: in visita) return String;
package d_sala_espera is
	type lista_espera is limited private;
	type objeto is limited private;
	space_overflow: exception;
	mal_uso: exception;

	procedure preparar_espera(ls:in out lista_espera);
	procedure encolar_masc(ls:in out lista_espera;v:in visita;tv:in tvisita);
	procedure desencolar(ls:in out lista_espera;v:out visita;tv:in tvisita);
	procedure imprimir_historial(ls:in out lista_espera);
	function "<"(x1,x2: in objeto) return boolean;
	function ">"(x1,x2: in objeto) return boolean;

private

type objeto is record
	v:visita;
	ciclos_esp: ciclos;  --ciclos de espera de la mascota
end record;

package list_esp is new d_heap(max_heap,objeto,"<",">");
use list_esp;

type lista_espera is new priority_queue;

end d_sala_espera;