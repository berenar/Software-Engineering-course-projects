with defs_general,ada.Text_IO;
use defs_general,ada.Text_IO;

package body d_historial_visita is
----------------------------------------------------------------------------------
-- proceso que inserta un identificador en la cola--
----------------------------------------------------------------------------------
procedure put(h: in out hvis;tv :in tvisita; k: in clave;name: in char_string) is
	i:item;
begin
	i.nombre:=name;
	put(h(tv), k,i);--llamada al put del package d_arbre
end put;
----------------------------------------------------------------------------------
-- proceso que prepara todas las colas del array--
----------------------------------------------------------------------------------
procedure prepararArray(h: in out hvis;tv :in tvisita) is
begin -- prepararArray
	for tv in tvisita loop
		empty(h(tv)); -- limpiará con el arbol.
	end loop;
end prepararArray;
-----------------------------------------------------------------
-- traversal --
-----------------------------------------------------------------
procedure mostrar_historial(h: in out hvis;tv :in tvisita) is
begin
	traversal(h(tv));
end mostrar_historial;
-----------------------------------------------------------------
-- metodo heredado --
-----------------------------------------------------------------
function imprimir(i:in item) return string is
	begin
	return i.nombre;
end imprimir;

end d_historial_visita;