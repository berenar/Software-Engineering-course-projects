with Ada.containers, defs_general;
use Ada.containers, defs_general;
package d_historial_mascota is
	type names_table is limited private;
	space_overflow: exception;
	bad_use: exception;

	procedure 	empty 				(tn: out names_table);
	procedure 	put 				(tn: in out names_table;name: in char_string; id: out name_id);
	function  	consult				(tn: in names_table; id: in name_id) return char_string;
	procedure 	putHis				(tn:in out names_table;id:in name_id;tv:in tvisita);
	procedure	mostrar_historial	(tn: in out names_table;name: in char_string);
	function	comprobar_dentro	(tn: in out names_table;id:in name_id) return boolean;
	procedure 	modificar_dentro	(tn: in out names_table;id:in name_id;b:in boolean);

private

b: constant ada.containers.hash_type := ada.containers.hash_type(max_id);
subtype hash_index is ada.containers.hash_type range 0 .. b;

-----------------------------------------------------------------
-- definición de nodo para la cola de historial --
-----------------------------------------------------------------
type mascota;
type pmascota is access mascota;
type mascota is record
	nom:char_string;
end record;

type node;
type pnode is access node;
type node is record
	tv:tvisita;
	sig: pnode;
end record;

type list_item is record
psh: name_id; -- puntero a sus sucesores en la lista de sinónimos de hash
-- ptc: natural;
phi: pnode;	--lista de historial
pno: pmascota;
dentro:boolean;

end record;

type id_table is array (name_id) of list_item;
type disp_table is array (hash_index) of name_id;

type names_table is record
td: disp_table;
tid: id_table;
nid: name_id; -- número de identificadores asignados
end record;

end d_historial_mascota;

