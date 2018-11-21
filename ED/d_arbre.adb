with Ada.Strings.Hash; use Ada.Strings;
with d_historial_visita;
with d_historial_mascota; use d_historial_mascota;

package body d_arbre is
----------------------------------------------------------------------------------
-- proceso que crea un árbol vacío--
----------------------------------------------------------------------------------
procedure empty(s:out set) is
	root: pnode renames s.root;
begin -- empty
	root:=null;	
end empty;
----------------------------------------------------------------------------------
-- proceso que inserta un identificador en el árbol (interno)--
----------------------------------------------------------------------------------
procedure put(p: in out pnode; k: in clave;x:in item) is
begin
	if p=null then
		p:= new node; 
		p.all:= (k,x,0, null, null); --árbol vacío
	else
	if k<p.k then put(p.lc,k,x); --clave menor (izq)
 		elsif k>p.k then put(p.rc,k,x); --clave mayor (der)
 		else p.q:=p.q+1;
 		end if;
 	end if ;
	exception
	when storage_error => raise space_overflow;
end put;
----------------------------------------------------------------------------------
-- proceso que inserta un identificador en el árbol--
----------------------------------------------------------------------------------
procedure put(s: in out set;k:in clave;x:in item) is

begin -- put
	put(s.root,k,x);
end put;
-----------------------------------------------------------------
-- traversal del arbol --
-----------------------------------------------------------------
procedure traversal(p:in out pnode;contador:in out Integer)is
begin
	Put(image(p.x));
	contador:=contador+1;			--aumentar el número de elementos que han 
	if p.lc /= null then
		traversal(p.lc,contador);
	end if;

	if p.rc /= null then
		traversal(p.rc,contador);
	end if;
	exception
		when CONSTRAINT_ERROR => Put_Line("Este árbol no posee elementos");
			
end traversal;

---------------------------------------------------
--Metodo traversal para sacar mascotas--
---------------------------------------------------
procedure traversal(s: in out set)is
	contador:integer;
begin
	contador:=0;
	traversal(s.root,contador);
	Put("numero de elementos");
	Put_Line(integer'image(contador));
end traversal;

end d_arbre;