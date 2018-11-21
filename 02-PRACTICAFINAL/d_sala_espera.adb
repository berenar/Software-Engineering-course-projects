package body d_sala_espera is

-----------------------------------------------------------------
-- inicilizar sala de espera --
-----------------------------------------------------------------
procedure preparar_espera(ls:in out lista_espera)is 
begin
	empty(ls);
end preparar_espera;
----------------------------------------------------------------------------------
-- obtener numero de ciclos de cada tipo de visita --
----------------------------------------------------------------------------------
	function obtener_ciclos(tv:in tvisita) return ciclos is
	i:ciclos;
	begin
	i:=ciclos(0);
	case tv is
		when  em => i:= ciclos(3);
		when  ci => i:= ciclos(2);
		when  cu => i:= ciclos(1);
		when  re =>	i:= ciclos(0);
	end case;
		return i;
	end obtener_ciclos;
----------------------------------------------------------------------------------
--  proceso meter visita --
----------------------------------------------------------------------------------
	procedure encolar_masc(ls:in out lista_espera;v:in visita;tv:in tvisita)is
	o:objeto;
	begin
	o.v:=v;
	o.ciclos_esp:= obtener_ciclos(tv);
	put(ls,o);
	end encolar_masc;
----------------------------------------------------------------------------------
--  proceso proceso para desencolar un elemento y obtener visita --
----------------------------------------------------------------------------------
	procedure desencolar(ls:in out lista_espera;v:out visita;tv:in tvisita)is
	begin
	v:=get_least(ls).v;
	delete_least(ls);

	exception
		when bad_use => raise mal_uso;
	end desencolar;
-----------------------------------------------------------------
-- recorrer lista de espera--
-----------------------------------------------------------------
procedure imprimir_historial(ls:in out lista_espera)is
	n:integer;
	obj:objeto;
begin
	n:=getn(ls);
	for i in 1..n loop
		obj:=get(ls, i);
		put(ciclos'Image(obj.ciclos_esp)&" ");
		Put_Line(Image(obj.v));
	end loop;
end imprimir_historial;

----------------------------------------------------------------------------------
-- funcion personalizada de comparacion --
----------------------------------------------------------------------------------
function "<"(x1,x2: in objeto) return boolean is
	begin
	if x1.ciclos_esp<x2.ciclos_esp then
		return true;
	end if;
	return false;
end "<";
----------------------------------------------------------------------------------
-- funcion personalizada de comparacion --
----------------------------------------------------------------------------------
function ">"(x1,x2: in objeto) return boolean is
	begin
	if x1.ciclos_esp>x2.ciclos_esp then
		return true;
	end if;
	return false;
end ">";

end d_sala_espera;