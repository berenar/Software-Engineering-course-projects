with ada.strings.hash,ada.Text_IO;
use ada.strings,ada.Text_IO;
package body d_historial_mascota is
-----------------------------------------------------------------
--  inicializar hash --
-----------------------------------------------------------------
procedure empty (tn: out names_table) is
	td: disp_table renames tn.td;
	tid: id_table renames tn.tid;
	nid: name_id renames tn.nid;
	-- nc: natural renames tn.nc;
begin
	for i in hash_index loop
	td(i) := null_id;
	end loop;
	nid := 0;
	-- nc := 0;
	tid(null_id) := (null_id,null,null,false);
end empty;


----------------------------------------------------------------------------------
--  proceso para insertar un nombre en la tabla de nombres y obtener un ID --
----------------------------------------------------------------------------------
procedure put (tn: in out names_table; name: in char_string; id: out name_id) is
	td: disp_table	renames tn.td;
	tid: id_table	renames tn.tid;
	nid: name_id	renames tn.nid;
	i:hash_index;
	p:name_id;
	n:pmascota;
begin
	i := hash(name) mod b;
	-- put("HashImage: ");
	-- put(hash_index'Image(i));
	p := td(i);

	while p /= null_id and then name/=tid(p).pno.nom loop
		p := tid(p).psh;
	end loop;

	if p = null_id then
		if nid = name_id(max_id) then
			raise space_overflow;
	end if;

		n:=new mascota;
		n.nom:=name;

		nid := nid + 1;
		tid(nid) := (td(i),null,n,false);
		td(i) := nid;
		p := nid;
	end if;
	id := p;
end put;


-----------------------------------------------------------------
-- procedimiento para poner una visita en el historial de un id --
-----------------------------------------------------------------
procedure putHis(tn:in out names_table;id:in name_id;tv:in tvisita) is 
	tid: id_table renames tn.tid;
	p:pnode;
begin
	p := new node;	--creación nodo
	p.all := (tv, tid(id).phi); --el nodo será el primero de la lista.
	tid(id).phi:=p; --el puntero de tid apunta al nuevo nodo.
end putHis;


-----------------------------------------------------------------
-- funcion para consultar un nombre dada un ID --
-----------------------------------------------------------------
function consult (tn: in names_table; id: in name_id) return char_string is
	tid: id_table renames tn.tid;
	nid: name_id renames tn.nid;

begin
	if id = null_id or id > nid then
		raise bad_use;
	end if;
	return tid(id).pno.nom;
end consult;

-----------------------------------------------------------------
-- recorrer una lista de una mascota--
-----------------------------------------------------------------
procedure recorrer_lista(p:in out pnode)is
begin
	Put(tvisita'Image(p.tv)&" ");
	while p.sig /= null loop
		Put(tvisita'Image(p.tv)&" ");
		p:=p.sig;
	end loop;
	new_line(1);

	exception
		when constraint_error =>Put_Line("No existen visitas de esa mascota.");
			
end recorrer_lista;
-----------------------------------------------------------------
-- mostrar historial con mostrar_lista --
-----------------------------------------------------------------
procedure mostrar_historial(tn: in out names_table;name: in char_string)is
id:name_id;
begin
	put(tn,name,id);
	Put_Line("Muestra de historial de visitas");
	recorrer_lista(tn.tid(id).phi);
end mostrar_historial;

-----------------------------------------------------------------
-- metodo heredado --
-----------------------------------------------------------------
function comprobar_dentro(tn: in out names_table;id:in name_id) return boolean is
	begin
	return tn.tid(id).dentro=false;
	end comprobar_dentro;

-----------------------------------------------------------------
-- metodo heredado --
-----------------------------------------------------------------
procedure modificar_dentro(tn: in out names_table;id:in name_id;b:in boolean) is
begin
	tn.tid(id).dentro:=b;
end modificar_dentro;

end d_historial_mascota;