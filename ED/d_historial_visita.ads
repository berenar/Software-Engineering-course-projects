with d_arbre;
with defs_general;
use defs_general;
with d_historial_mascota;
use d_historial_mascota;

generic
	type clave is private;--este key queremos que sean los identificadores.
	with function "<"(k1,k2: in clave) return boolean;
	with function ">"(k1,k2: in clave) return boolean;
package d_historial_visita is
 	--llamamos al paquete de tabla_nombres para pasar por parámetro
 	--y poder acceder a todos sus procedimientos.
	type hvis is limited private;
	type item is limited private;
	space_overflow: exception;

	procedure 	put(h: in out hvis;tv :in tvisita; k: in clave;name: in char_string);
	procedure 	prepararArray(h: in out hvis;tv :in tvisita);
	procedure 	mostrar_historial(h: in out hvis;tv :in tvisita);
	function 	imprimir(i:in item) return string;

private

type item is record
	nombre:char_string;
end record;

package arbol_hist is new d_arbre(clave,item,"<",">",imprimir);
use arbol_hist;
	type mset is new set;

-------------------------------
-- Tipo history/historial --
-------------------------------
type hvis is array(tvisita) of mset;--solo hay 4 tipos de visitas

end d_historial_visita;