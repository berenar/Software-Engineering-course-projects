with ada.io_exceptions,ada.text_io,ada.direct_io,defs_general,d_clinica,pparaula,ada.integer_text_io;
use ada.text_io,defs_general,d_clinica,pparaula, ada.integer_text_io;
procedure main is

	seed_100 : rand_int_100.generator;
	seed_72: rand_int_72.generator;
	probabilidades: probabilidad;

	primvera_vuelta:integer;

	m_base:base_datos;
	m_visita:visita;
	tv:tvisita;
	id:name_id;
	n:num_cons;

----------------------------------------------------------------------------------
-- procedimiento para generar valores aleatorios--
----------------------------------------------------------------------------------

procedure generarale(p:in out probabilidad) is
begin
	for i in num_prob loop
	p(i):=rand_int_100.random(seed_100);
end loop;

end generarale;
----------------------------------------------------------------------------------
-- procedimiento para gestionar las probabilidades--
----------------------------------------------------------------------------------
procedure visaleat(p:in probabilidad;tv:in out tvisita ) is
begin	
	if p(2)<=25 then
		tv:=re;
		elsif p(2)<=50 then
		tv:=cu;
		elsif p(2)<=75 then
		tv:=ci;
		else 
		tv:=em;
	end if;
end visaleat;
----------------------------------------------------------------------------------
--eliminar una consulta --
----------------------------------------------------------------------------------

procedure desaparece(bd:in out base_datos;p:in probabilidad) is
	n:num_cons;
	error:integer;
begin
	--encontrar consulta abierta y libre
	error:=disponibilidad_consulta_abierta(bd,n);
	--si n existe. si no dentro de disponibilidad lanza excepcion
	if error=0 then
		if(p(3)>90) then
			cerrar_consulta(bd,n);
		end if;
	end if;
end desaparece;
----------------------------------------------------------------------------------
--abrir una consulta --
----------------------------------------------------------------------------------

procedure apertura(bd:in out  base_datos;p:in probabilidad) is
	n:num_cons;
	error:integer;
begin
	--encontrar consulta cerrada
	error:=disponibilidad_consulta_cerrada(bd,n);
	--si n existe. si no dentro de disponibilidad lanza excepcion
	if(p(3)>90) then
		abrir_consulta(bd,n);
	end if;
end apertura;

----------------------------------------------------------------------------------
--leer una linia aleatoria del fichero --
----------------------------------------------------------------------------------
package fitxer_paraules is new ada.direct_io(element_type => tparaula);
use fitxer_paraules;
origen : origenparaules;
p : tparaula;
f : fitxer_paraules.file_type;
l, c : integer;

procedure llegir(nom:in string; o:in out origenparaules) is
begin
	open(origen, nom);
	rand_int_72.reset(seed_72);
	num_72 := rand_int_72.random(seed_72);
	for i in 0..num_72 loop
		get(o, p, l, c);
	end loop;
	close(origen);
end llegir;
 
error:integer;

----------------------------------------------------------------------------------
-- modo automáico de simulación--
----------------------------------------------------------------------------------
numerosim:integer;

procedure modo_automatico(ni:in integer) is
handle:ada.text_io.file_type;
begin
	ada.text_io.create(handle,ada.text_io.out_file,"salida.txt");


	ada.text_io.set_output (handle);
	put_line("-----------------------------------------------------------------------------------");
	put_line("simulación");
	put_line("-----------------------------------------------------------------------------------");
	tv:=tvisita'(re);
	rand_int_100.reset(seed_100);
	primvera_vuelta:=1;

	iniciar_clinica(m_base); --iniciamos la primera consulta abierta, el resto cerradas.
	for i in 1..ni  loop

		put_line("-----------------------------------------------------------------------------------");
		put("ciclo");
		put(integer'image(i));
		new_line(1);
		put_line("-----------------------------------------------------------------------------------");
		--generear todos los aleatorios;
		generarale(probabilidades);

		if primvera_vuelta=0 then
		--probabilidad del 10% de que desaparezca la consulta
			desaparece(m_base,probabilidades);
		end if;
		primvera_vuelta:=0;
		--probabilidad del 10% de abrir una consulta.
		apertura(m_base,probabilidades);
		if probabilidades(1)>=25 then
			llegir("mascotes",origen);
			visaleat(probabilidades,tv);

			--entra mascota
			registrar_mascota(m_base,tostring(p),tv,id);
			rellenar_visita(m_visita,id,tostring(p),tv);
			put_line("se ha rellenado la visita");
			--meter en lista de espera a la mascota (a partir del id).
			if comprobar_dentro(m_base,id)then
				poner_lista_espera(m_base,m_visita);
				modificar_dentro(m_base,id,true);
			end if;
			else
				put_line("no ha aparecido ninguna mascota");
		end if;
		--recorrer consultas y mirar si hay alguna disponible:
		error:=disponibilidad_consulta_abierta(m_base,n);
		-- if n not null_cons
		if error=0 then
		-- 	--insertar elemento en la consulta:
		insertar_consulta(m_base,n);
		-- end if;
		else
			put_line("no hay consulta disponible");
		end if;
		--decrementar ciclos de espera de consultas
		decrementar_ciclos(m_base,m_visita,id);
	end loop;
	ada.text_io.close(handle);
	ada.text_io.set_output(ada.text_io.standard_output);
end modo_automatico;

----------------------------------------------------------------------------------
-- modo manual de simulación--
----------------------------------------------------------------------------------
procedure modo_manual is
	entrada_teclado:character;
	entrada_int:integer;
	contador_ciclos:integer;
	primvera_vuelta:integer;
	error:integer;
	letra:character;
	std:char_string;
begin
	letra:=' ';
	contador_ciclos:=0;
	primvera_vuelta:=1;
	put_line("-----------------------------------------------------------------------------------");
	put_line("simulación");
	put_line("-----------------------------------------------------------------------------------");
	tv:=tvisita'(re);
	rand_int_100.reset(seed_100);
	primvera_vuelta:=1;

	iniciar_clinica(m_base); --iniciamos la primera consulta abierta, el resto cerradas.
	put_line("pulse c para avanzar, pulse p para acabar la simulación.");
	
	put_line("en cualquier momento pulse q para realizar una consulta");
	get(entrada_teclado);

	while entrada_teclado/= 'c' and then entrada_teclado/='p' loop
		get(entrada_teclado);
	end loop;

	while entrada_teclado/='p' loop
		if entrada_teclado='c' then
			contador_ciclos:=contador_ciclos+1;
			put_line("-----------------------------------------------------------------------------------");
			put("ciclo");
			put(integer'image(contador_ciclos));
			new_line(1);
			put_line("-----------------------------------------------------------------------------------");
			--generear todos los aleatorios;
			generarale(probabilidades);
			if primvera_vuelta=0 then
			--probabilidad del 10% de que desaparezca la consulta
				desaparece(m_base,probabilidades);
			end if;
			primvera_vuelta:=0;
			--probabilidad del 10% de abrir una consulta.
			apertura(m_base,probabilidades);
			if probabilidades(1)>=25 then
				llegir("mascotes",origen);
				visaleat(probabilidades,tv);

				--entra mascota
				registrar_mascota(m_base,tostring(p),tv,id);
				rellenar_visita(m_visita,id,tostring(p),tv);

				put_line("se ha rellenado la visita");
				new_line(1);
				--meter en lista de espera a la mascota (a partir del id).
				if comprobar_dentro(m_base,id)then
					poner_lista_espera(m_base,m_visita);
					modificar_dentro(m_base,id,true);
				end if;
				else
					put_line("no ha aparecido ninguna mascota");
					new_line(1);
			end if;
			--recorrer consultas y mirar si hay alguna disponible:
			error:=disponibilidad_consulta_abierta(m_base,n);
			-- if n not null_cons
			if error=0 then
			-- 	--insertar elemento en la consulta:
			insertar_consulta(m_base,n);
			else
				put_line("no hay consulta disponible");
			end if;
			--decrementar ciclos de espera de consultas
			decrementar_ciclos(m_base,m_visita,id);
			new_line(1);
		end if;	
		if entrada_teclado='q' then
			put_line("a continuación se muestran las diferentes consultas");

			put_line("pulsa e para mostrar las mascotas en espera.(en orden de prioridad)");
			put_line("pulsa m para mostrar el historial de una mascota.");
			put_line("pulsa v para mostrar el historial de una visita.");

			get(entrada_teclado);

			if entrada_teclado='e' then
				put_line("mostramos las mascotas en espera.");
				mostrar_sala_espera(m_base);
			elsif entrada_teclado='m' then
				put_line("para mostrar el historial de una mascota, teclee el nombre.");
				pparaula.get(p,letra,l,c);
				std:= tostring(p);
				mostrar_historial_mascota(m_base,std);
			elsif entrada_teclado='v' then
				put_line("para mostrar el tipo de visita, tecle lo siguiente:");
				put_line("'3' para una emergencia.");
				put_line("'2' para una cirugía.");
				put_line("'1' para una cura.");
				put_line("'0' para una revisión.");
				get(entrada_int);
				if entrada_int/=3 and then entrada_int/=2 and then entrada_int/=1 and then entrada_int/=0 then
					put_line("malos argumentos");
				else
					mostrar_historial_visita(m_base,tvisita'val(entrada_int));
				end if;			
			end if;

		end if;
		get(entrada_teclado);
		new_line(1);
	end loop;
end modo_manual;

opcion:integer;

----------------------------------------------------------------------------------
-- menu principal--
----------------------------------------------------------------------------------
begin -- main

	put_line("---------------------------------------------------------");
	put_line("bienvenido al simulador de la clínica veterinaria");
	put_line("---------------------------------------------------------");
	new_line(2);

	put_line("pulse 1 para realizar la simulación manual.");
	put_line("pulse 2 para realizar la simulación automática.");
	put_line("pulse 0 para salir.");
	get(opcion);
	while opcion/= 1 and then opcion/=2 and then opcion/= 0 loop
		put_line("pulse 1 para realizar la simulación manual.");
		put_line("pulse 2 para realizar la simulación automática.");
		put_line("pulse 0 para salir.");
		get(opcion);
	end loop;

	if opcion=1 then
	-- modo_manual;
		put_line("modo manual seleccionado.");
		modo_manual;
	elsif opcion= 2 then
		put("introduzca el número de ciclos para la simulación en un rango de 1 -");
		put_line(integer'image(num_lineas_fich)&".");
		get(numerosim);
		modo_automatico(numerosim);
	end if;


	exception
		when ada.io_exceptions.data_error =>put_line("malos argumentos");
end main;