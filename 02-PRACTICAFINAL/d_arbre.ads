with Ada.containers, defs_general,ada.Text_IO;
use Ada.containers, defs_general,ada.Text_IO;

-- tendremos que implementar la estructura de arbol binario con mascota como parametro.
-- El parametro para la ordenacion del arbol será a partir del ID
generic
	type clave is private;--este key queremos que sean los identificadores.
	type item is private;
	with function "<"(k1,k2: in clave) return boolean;
	with function ">"(k1,k2: in clave) return boolean;
	with function Image(a: in item) return String;

package d_arbre is
	type set is limited private;
	ya_existe:exception;
	space_overflow: exception;

	procedure empty (s: out set);
	procedure put(s: in out set;k:in clave;x:in item);
	procedure traversal(s: in out set);

private
	type node;
	type pnode is access node;
	type node is
		record
			k: clave;
			x:item;
			q:integer;
			lc,rc: pnode;
		end record;

	type set is record
		root:pnode;
	end record;

end d_arbre;