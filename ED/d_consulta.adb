package body d_consulta is
-----------------------------------------------------------------
-- inicializar todas las consultas  --
-----------------------------------------------------------------
	procedure iniciarCons(c:in out consultas) is
		begin
		for i in num_cons loop
			c.consul(i).e:=false;
			c.consul(i).est:=0;
			c.consul(i).ciclos_en_cn:=0;
		end loop;
		c.consul(1).e:=true;
		c.consul(1).est:=estado'Pos(disp);
		c.contador:=1;
	end iniciarCons;
-----------------------------------------------------------------
-- abrir la consulta N  --
-----------------------------------------------------------------
	procedure abrir_consulta(c:in out consultas;n: in num_cons) is
	begin
		c.consul(n).e:=true;
		c.consul(n).est:=estado'Pos(disp);
		c.contador:=c.contador+1;
	end abrir_consulta;
-----------------------------------------------------------------
-- cerrar la consulta N  --
-----------------------------------------------------------------
	procedure cerrar_consulta(c:in out consultas;n: in num_cons) is
	begin
		c.consul(n).e:=false;
		c.contador:=c.contador-1;
	end cerrar_consulta;

	function obtener_ciclos_espera(tv:in tvisita) return ciclos_rest is
	i:ciclos_rest;
	begin
	i:=ciclos_rest(0);
	case tv is
		when  em => i:= ciclos_rest(4);
		when  ci => i:= ciclos_rest(8);
		when  cu => i:= ciclos_rest(5);
		when  re =>	i:= ciclos_rest(3);
	end case;
		return i;
	end obtener_ciclos_espera;

-----------------------------------------------------------------
-- llenar la consulta N  --
-----------------------------------------------------------------
	procedure llenar_consulta(c:in out consultas;n: in num_cons;tv:in tvisita;v:in out visita)is
	begin
		if c.consul(n).e=false then
			raise fallo_box;	
		end if;
		c.consul(n).est:=estado'Pos(ocu);
		c.consul(n).box:=v;
		c.consul(n).ciclos_en_cn:=obtener_ciclos_espera(tv);
		
	end llenar_consulta;
-----------------------------------------------------------------
-- vaciar la consulta N  --
-----------------------------------------------------------------
	procedure vaciar_consulta(c:in out consultas;n: in num_cons;v:out visita) is
	begin
		c.consul(n).est:=estado'Pos(disp);
		v:=c.consul(n).box;
	end vaciar_consulta;
-----------------------------------------------------------------
-- imprimir contenido de las consultas  --
-----------------------------------------------------------------
	procedure imprimirConsultas(c:in out consultas)is
	begin
		for i in num_cons loop
			Put("consulta n:");
			Put(num_cons'Image(i));
			Put(integer'Image(c.contador)& " ");
			Put(boolean'Image(c.consul(i).e));
			Put(integer'Image(c.consul(i).est));
			Put(ciclos_rest'Image(c.consul(i).ciclos_en_cn));
			new_line(1);
		end loop;
	end imprimirConsultas;

-----------------------------------------------------------------
-- decrementar ciclos de la consulta N  --
-----------------------------------------------------------------
	procedure decr_ciclos(c:in out consultas;n: in num_cons;v:out visita;alerta:out integer) is
	begin
		alerta:=0;
		if c.consul(n).e=true and then c.consul(n).est=estado'Pos(ocu) and then c.consul(n).ciclos_en_cn>0 then
		c.consul(n).ciclos_en_cn:=c.consul(n).ciclos_en_cn-1;
			if c.consul(n).ciclos_en_cn=0 then
				vaciar_consulta(c,n,v);
				if  c.contador>1 then
					cerrar_consulta(c,n);
				end if;
				alerta:=1;
			end if;
		end if;
	end decr_ciclos;
-----------------------------------------------------------------
-- devuelve el numero de la primera consulta libre  --
-----------------------------------------------------------------
	function consulta_libre(c:in out consultas) return num_cons is
	begin
		for i in num_cons loop
			if c.consul(i).e=true and then c.consul(i).est=estado'Pos(disp) then return i;
			end if;
		end loop;
		raise no_consulta_disponible;	--si no hay ninguna consulta disponible
	end consulta_libre;
-----------------------------------------------------------------
-- devuelve la posicion de la primera consulta cerrada  --
-----------------------------------------------------------------
	function consulta_cerr(c:in out consultas) return num_cons is
	begin
		for i in num_cons loop
			if c.consul(i).e=false then return i;
			end if;
		end loop;
		raise no_consulta_disponible;
	end consulta_cerr;


end d_consulta;