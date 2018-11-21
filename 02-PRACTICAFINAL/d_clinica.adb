
package body d_clinica is

-----------------------------------------------------------------
-- procedimiento para iniciar base de datos. --
-----------------------------------------------------------------

procedure iniciar_clinica(bd:in out base_datos) is
begin
	consulta.iniciarCons(bd.cn);
	d_historial_mascota.empty(bd.tn);
	preparar_espera(bd.ls);
	for i in tvisita  loop
		prepararArray(bd.hv,i);
	end loop;
	
end iniciar_clinica;

procedure imprimirConsultas(bd:in out base_datos) is
begin
	imprimirConsultas(bd.cn);
end imprimirConsultas;

-----------------------------------------------------------------
-- procedimiento para registrar mascota  --
-----------------------------------------------------------------
procedure registrar_mascota(bd:in out base_datos; name: in char_string; tv: in tvisita; id: out name_id) is
	tn: names_table renames bd.tn;
begin -- registrar_mascota
	d_historial_mascota.put(tn,name,id);
end registrar_mascota;
-----------------------------------------------------------------
-- procedimiento para meter en lista de espera--
-----------------------------------------------------------------
procedure poner_lista_espera(bd:in out base_datos;v:in visita) is
	
begin -- poner_lista_espera
	sala_espera.encolar_masc(bd.ls,v,v.tv);
	Put("Se ha insertado en la lista de espera: ");
	Put_Line(v.nom);
end poner_lista_espera;
-----------------------------------------------------------------
-- mirar disponibilidad consultas --
-----------------------------------------------------------------
function disponibilidad_consulta_abierta(bd:in out base_datos;n:out num_cons) return integer is
	primera_libre:num_cons;
begin -- disponibilidad_consulta
	primera_libre:=consulta.consulta_libre(bd.cn);
	Put("Consulta libre:");
	Put(num_cons'Image(primera_libre));
	new_line(1);
	n:=primera_libre;
	return 0;
	exception
	when no_consulta_disponible =>return -1;
end disponibilidad_consulta_abierta;
-----------------------------------------------------------------
-- mirar disponibilidad consultas --
-----------------------------------------------------------------
function disponibilidad_consulta_cerrada(bd:in out base_datos;n:out num_cons) return integer is
	primera_cerr:num_cons;
begin -- disponibilidad_consulta
	primera_cerr:=consulta.consulta_cerr(bd.cn);
	n:=primera_cerr;
	return 0;
	exception
	when no_consulta_disponible =>return -1;
end disponibilidad_consulta_cerrada;
-----------------------------------------------------------------
-- meter en la consulta --
-----------------------------------------------------------------
procedure insertar_consulta(bd:in out base_datos;n:in num_cons) is
v:visita;
begin -- insertar_consulta
	sala_espera.desencolar(bd.ls,v,v.tv); --meterá en v todos los atributos de visita.
	consulta.llenar_consulta(bd.cn,n,v.tv,v);
	Put("Ha entrado en la consulta :");
	Put(num_cons'Image(n)&"->");
	Put_Line(v.nom);

	exception
		when mal_uso => Put_Line("No hay mascotas en la cola.");
					
end insertar_consulta;

-----------------------------------------------------------------
-- Actualizar historial clinico --
-----------------------------------------------------------------
procedure actualizar_historial(bd:in out base_datos;v:in visita) is
	tn: names_table renames bd.tn;
begin -- actualizar_historial
	d_historial_mascota.putHis(bd.tn,v.identifier,v.tv);-- actualiza historial mascota

	historial_visita.put(bd.hv,v.tv,v.identifier,v.nom);--actualiza historial visita
end actualizar_historial;
-----------------------------------------------------------------
-- Decrementar ciclos consultas --
-----------------------------------------------------------------
procedure decrementar_ciclos(bd:in out base_datos;v:out visita;id:in name_id) is
alerta:integer;
begin -- decrementar_ciclos
	for i in num_cons loop
		consulta.decr_ciclos(bd.cn,i,v,alerta);
		if alerta=1 then -- la consulta ha acabado
			actualizar_historial(bd,v);
			Put("Se ha acabado la consulta con: ");
			Put_Line(v.nom);

			modificar_dentro(bd,id,false);
		end if;
	end loop;
end decrementar_ciclos;
-----------------------------------------------------------------
-- rellenar una visita --
-----------------------------------------------------------------
procedure rellenar_visita(v:out visita;i:in name_id;name:in char_string;tvis:in tvisita)is 
begin
	v.identifier:=i;
	v.nom:=name;
	v.tv:=tvis;
	Put("Nombre de la mascota: ");
	Put(name);
	new_line(1);
	Put("Tipo de la visita: ");
	Put(tvisita'Image(tvis));
	new_line(2);

end rellenar_visita;
-----------------------------------------------------------------
-- abrir una consulta especificada --
-----------------------------------------------------------------
procedure abrir_consulta(bd:in out base_datos;n: in num_cons) is
begin
	consulta.abrir_consulta(bd.cn,n);
end abrir_consulta;
-----------------------------------------------------------------
-- cerrar una consulta especificada --
-----------------------------------------------------------------
procedure cerrar_consulta(bd:in out base_datos;n: in num_cons) is
begin
	consulta.cerrar_consulta(bd.cn,n);
end cerrar_consulta;
-----------------------------------------------------------------
-- mostrar el historial de visita de un tipo visita --
-----------------------------------------------------------------
procedure mostrar_historial_visita(bd:in out base_datos;tv:in tvisita) is

begin
	Put("Historial del tipo visita: ");
	Put_Line(tvisita'Image(tv));
	mostrar_historial(bd.hv,tv);
end mostrar_historial_visita;
-----------------------------------------------------------------
-- mostrar el historial de visitas de una mascota --
-----------------------------------------------------------------
procedure mostrar_historial_mascota(bd:in out base_datos;name: in char_string)is

begin
	mostrar_historial(bd.tn,name);

end mostrar_historial_mascota;
-----------------------------------------------------------------
-- mostrar mascotas de la sala de espera --
-----------------------------------------------------------------
procedure mostrar_sala_espera(bd:in out base_datos) is

begin
	imprimir_historial(bd.ls);
end mostrar_sala_espera;
-----------------------------------------------------------------
-- metodo usado en mostrar_sala_espera --
-----------------------------------------------------------------
function print(x1: in visita) return string is
begin
	return x1.nom;
end print;
-----------------------------------------------------------------
-- comprobar que una mascota este en la base de datos --
-----------------------------------------------------------------
function comprobar_dentro(bd:in out base_datos;id:in name_id) return boolean is
	begin
	return d_historial_mascota.comprobar_dentro(bd.tn,id);
	end comprobar_dentro;
-----------------------------------------------------------------
-- modificar una mascota --
-----------------------------------------------------------------
procedure modificar_dentro(bd:in out base_datos;id:in name_id;b:in boolean) is
begin
	d_historial_mascota.modificar_dentro(bd.tn,id,b);
end modificar_dentro;

end d_clinica;
