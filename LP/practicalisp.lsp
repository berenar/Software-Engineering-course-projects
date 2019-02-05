#| 
--------------------------------------------------------------------------------
--------FUNCIÓN DEL BUCLE PRINCIPAL DEL JUEGO.
--------SE INICIALIZAN LAS VARIABLES DEL JUEGO NO GOBLALES
--------SE INICIALIZA RESULTADOS.TXT 
--------------------------------------------------------------------------------
|#
(defun inicio()
	(setq contador 0)
	(setq turno 0)
	(setq stream (open"RESULTADOS.txt" 	:direction :output 
										:if-exists :append 
										:if-does-not-exist :create))
	(setf nombre_usuario (select_nombre))
	(format stream "El juego de la memoria. Jugador:~A" nombre_usuario )
	(terpri stream)
	(pintapanel)
	(generar_arr_img)
	(todo_reversos)
	(loop
		(pintar_turno)
		(pintar_contador)
		(movimiento)
		
		(if (comprobar_casillas fila1 columna1 fila2 columna2)
			(progn
				(poner_a_false fila1 columna1 fila2 columna2)
				(goto-xy 15 1)
				(CLEOL)
				(format t "CORRECTO")
				(format stream "Turno:~D Imagen (~D,~D) - Imagen (~D,~D) Correcto"
						turno fila1 columna1 fila2 columna2)
				(terpri stream)
				
				(espera)
				(setq contador (+ contador 1))
			)
			(progn
				(goto-xy 15 1)
				(CLEOL)
				(format t "INCORRECTO")
					(format stream "Turno:~D Imagen (~D,~D) - Imagen (~D,~D) Incorrecto"
							turno fila1 columna1 fila2 columna2)
					(terpri stream)
								
				(espera)
				(poner_reversos fila1 columna1 fila2 columna2)
			)
		)
	   (setq turno (+ turno 1))
	   (when (= contador 9) (close stream )(felicitacion))
	)
)

#| 
--------------------------------------------------------------------------------
--------FUNCIÓN DE MOVIMIENTO 
--------SE ENCARGA DE GESTIONAR EL MOVIMIENTO CONSISTENTE EN LA ELECCIÓN DE
--------DOS CASILLAS.
--------LA FUNCIÓN SIGUE MIENTRAS NO SE INTRODUZCA UN MOVIMIENTO VÁLIDO
--------------------------------------------------------------------------------
|#
(defun movimiento ()
	(loop
		(goto-xy 30 1)
		(CLEOL)
		(format t "Fila:")
		(setq fila1 (read))
		(goto-xy 40 1)
		(format t "Columna:")
		(setq columna1 (read) )

		(setq err (comprobar fila1 columna1))
		(if (= err 0)
			(progn
				(setq fila1 (- fila1 1))
				(setq columna1 (- columna1 1))
				(girar_carta fila1 columna1)
			)(progn
				(setq a err)
				(tratamiento_errores a)
				(espera)
				(movimiento)
				(return-from movimiento)
			)
		)
		(goto-xy 30 1)
		(CLEOL)
		(format t "Fila:")
		(setq fila2 (read))
		(goto-xy 40 1)
		(format t "Columna:")
		(setq columna2 (read))
		(setq err (comprobar fila2 columna2))
		(if (= err 0)
			(progn
				(setq err2 (son_iguales (+ fila1 1) (+ columna1 1) 
					fila2 columna2))
				(if (/= err2 0)
					(progn
						(setq a err2)
						(tratamiento_errores err2)
						(poner_un_reverso fila1 columna1)
						(espera)
						(movimiento)
						(return-from movimiento)
					)
				)
				(setq fila2 (- fila2 1))
				(setq columna2 (- columna2 1))
				(girar_carta fila2 columna2)
				(return-from movimiento 1)
			)(progn
				(setq a err)
				(tratamiento_errores a)
				(poner_un_reverso fila1 columna1)
				(espera)
				(movimiento)
				(return-from movimiento)
			)
		)
	)
)


#| 
--------------------------------------------------------------------------------
--------FUNCIÓN DE ESPERA
--------MIENTRAS NO SE PULSE LA TECLA N SEGUIRRÁ EN UN BUCLE.
--------------------------------------------------------------------------------
|#
(defun espera ()
	(loop
	(goto-xy 55 1)
		(format t "(N) para continuar:")
		(CLEOL)
		(setf tecla (read))
		(when (EQ 'N tecla ) (return-from espera ))
	)
)

#| 
--------------------------------------------------------------------------------
--------FUNCIÓN PINTA_TURNO Y PINTA_CONTADOR
--------MUESTRA EN PANTALLA LA VARIABLES GLOBALES TURNO Y CONTADOR
--------------------------------------------------------------------------------
|#
(defun pintar_turno ()
	(goto-xy 0 1)
	(format t "Turno: ~d" turno)
)
(defun pintar_contador ()
	(goto-xy 15 1)
	(format t "Aciertos: ~d" contador)
)


#| 
--------------------------------------------------------------------------------
--------FUNCIÓN DE ESPERA
--------Se encarga de poner las casillas a false, indicando que no son
--------introducibles a partir de ahora
--------------------------------------------------------------------------------
|#
(defun poner_a_false (fil1 col1 fil2 col2)
	(setf (aref(aref(aref arr_img fil1) col1)0) nil)
	(setf (aref(aref(aref arr_img fil2) col2)0) nil)
)

#| 
--------------------------------------------------------------------------------
--------FUNCIÓN DE TRATAMIENTO DE ERRORES
--------A PARTIR DEL PARÁMETRO DE ENTRADA IMPRIME EL TIPO DE ERROR
--------------------------------------------------------------------------------
|#
(defun tratamiento_errores (a)
	(goto-xy 30 1)
	(CLEOL)
	(case a
		(1 (format t "FORMATO INCORRECTO"))
		(2 (format t "MISMA CASILLA"))
		(3 (format t "CASILLA YA REVELADA"))
	)
)

#| 
--------------------------------------------------------------------------------
--------FUNCIÓN COMPRUEBA
--------COMPRUEBA QUE EL FORMATO INTRODUCIDO ES CORRECTO, EN CASO QUE LO SEA
--------MIRARÁ QUE SEA UNA CASILLA SELECCIONABLE
--------------------------------------------------------------------------------
|#
(defun comprobar (a b)
	(setq err 0)
	(if (AND (numberp a) (> a 0) (<= a 3) (numberp b) (> b 0) (<= b 6))
		(progn
			(if (NOT (aref(aref(aref arr_img (- a 1)) (- b 1))0))
				(setq err 3)
			)
		)(setq err 1)
	)
	(return-from comprobar err) 
)

#| 
--------------------------------------------------------------------------------
--------FUNCIÓN COMPROBAR_CASILLAS
--------COMPRUEBA QUE LAS DOS CASILLAS INTRODUCIDAS COINCIDEN.
--------------------------------------------------------------------------------
|#
(defun comprobar_casillas (a1 b1 a2 b2)
	(string= (aref(aref(aref arr_img a1) b1)1) 
			(aref(aref (aref arr_img a2) b2)1))
)

#| 
--------------------------------------------------------------------------------
--------FUNCIÓN SON IGUALES
--------VERIFICA SI LAS DOS CASILLAS INTRODUCIDAS SON LA MISMA
--------------------------------------------------------------------------------
|#
(defun son_iguales (a1 b1 a2 b2)
	(setq err2 0)
	(if (AND (= a1 a2) (= b1 b2))
		(setq err2 2)
	)
	(return-from son_iguales err2)
)
#| 
--------------------------------------------------------------------------------
--------FUNCIÓN generar_arr_img
--------GENERADOR ALEATORIO DEL TABLERO
--------------------------------------------------------------------------------
|#
(defun generar_arr_img ()
	(setq arr_rpt (make-array 10 :initial-element 0))
	(setq arr_img (make-array 3))
	(dotimes (i 3)
		(setf (aref arr_img i) (make-array 6))
		(dotimes (j 6)
			(setf (aref(aref arr_img i)j) (make-array 2))
			(setq rndm (random 10))
			(if (setq salida (apariciones arr_rpt rndm ))
				(progn
					(setf 
						(aref(aref(aref arr_img i) j)0) t
					)
					(setf 
						(aref(aref(aref arr_img i) j)1) (format nil "imagen_~A.img" salida))
					)
			)
		)
	)
)
#| 
--------------------------------------------------------------------------------
--------FUNCIÓN COMPRUEBA
--------COMPRUEBA QUE SOLO APARECEN DOS CASILLAS DE CADA IMAGEN
--------------------------------------------------------------------------------
|#
(defun apariciones (b a)
	(setq j (aref b a))
	(if (AND (> a 0) (< j 2))
		(progn
			(setf (aref b a) (+ (aref b a) 1))
			(return-from apariciones a )
		)
		(progn

			(setq a (random 10)) 
			(apariciones b a) 
		)
	)
)
#| 
--------------------------------------------------------------------------------
--------MODULO FUNCIONES REVERSO:
--------PONER UN REVERSO O VARIOS.
--------PONER TODO A REVERSOSO.
--------------------------------------------------------------------------------
|#
(defun poner_un_reverso (fil col)
	(setq x (- (* (+ col 1) 102) 97))
	(setq y (- 411 (* (+ fil 1) 102)))
	(limpiar_img x y)
	(setq a "Imagenes/img/Reverso.img")
	(leer_img a x y)
)

(defun poner_reversos (fil1 col1 fil2 col2)
	(poner_un_reverso fil1 col1)
	(poner_un_reverso fil2 col2)
)

(defun todo_reversos ()
	(setq a "Imagenes/img/reverso.img")
	(setq x 5)
	(setq y 105)
	(dotimes (i 3)
		(dotimes (k 6)
			(leer_img a x y)
			(setq x (+ x 102))
		)
		(setq x 5)
		(setq y (+ y 102))
		)
)


#| 
--------------------------------------------------------------------------------
--------FUNCIÓN GIRAR_CARTA
--------CON LOS PARÁMETROS DE ENTRADA FILA Y COLUMNA SELECCIONA LA CARTA A GIRAR
--------------------------------------------------------------------------------
|#
(defun girar_carta (fil col)
	(setq x (- (* (+ col 1) 102) 97))
	(setq y (- 411 (* (+ fil 1) 102)))
	(limpiar_img x y)
	(setq a "Imagenes/img/")
	(setq path (concatenate 'string a (aref(aref (aref arr_img fil) col) 1)))
	(leer_img path x y)
)


#| 
--------------------------------------------------------------------------------
--------MÓDULO DE FUNCIONES DE PANTALLAS:
--------FELICITACIÓN AL FINAL DEL JUEGO
--------SELECCIÓN DE NOMBRE DE JUGADOR
--------------------------------------------------------------------------------
|#
(defun felicitacion ()
	(CLS)
	(goto-xy 33 12)
	(pintalinea_hor 0 639 170 5)
	(pintalinea_hor 0 639 200 5)
	(format t "HAS GANADO CRACK")
	(espera)
	(goto-xy 55 1)
	(CLEOL)
	(loop
		(goto-xy 33 12)
		(CLEOL)
		(format t "(N) Terminar (S) para otra partida:")
		(CLEOL)
		(setf tecla (read))
		(when (EQ 'S tecla ) (CLS)(CLEOL)(inicio)(return-from espera ))
		(when (EQ 'N tecla ) (inicio)(return-from espera ))
	)
)

(defun select_nombre ()
	(CLS)
	(goto-xy 33 12)
	(pintalinea_hor 0 639 170 5)
	(pintalinea_hor 0 639 200 5)
	(format t "INTRODUCE NOMBRE: ")
	(setq nombre_usuario (read))
	(return-from select_nombre nombre_usuario)
)


#| 
--------------------------------------------------------------------------------
--------MÓDULO DE FUNCIONES DE REPRESENTACIÓN GRÁFICA:
--------PINTAR EL PANEL
--------PINTAR LAS LINEAS DE LA TABLA HORIZONTAL Y VERTICAL
--------LIMPIAR UNA CASILLA
--------------------------------------------------------------------------------
|#
(defun pintapanel ()
	(CLS)
	(pintalinea_vert 0 0 333 5)
	(pintalinea_hor 0 639 370 5)
	(pintalinea_vert 635 0 333 5)
	(pintalinea_hor 639 0 0 5)
	(pinta_g_v)
	(pinta_g_h)
	(goto-xy 7 3)
	(format t "1")
	(goto-xy 20 3)
	(format t "2")
	(goto-xy 33 3)
	(format t "3")
	(goto-xy 44 3)
	(format t "4")
	(goto-xy 57 3)
	(format t "5")
	(goto-xy 71 3)
	(format t "6")
	(goto-xy 78 6)
	(format t "1")
	(goto-xy 78 14)
	(format t "2")
	(goto-xy 78 20)
	(format t "3")
)

(defun pinta_g_h ()
	(setq tope 617)
	(setq coordenada 4)
	(move 0 coordenada)
	(setq numero_casillas_vertical 2)
	(setq i 0)
	(dotimes (i numero_casillas_vertical)
		(setq coordenada (+ coordenada 102))
		(pintalinea_hor 0 tope coordenada 1)
		(move 0 coordenada)
		(setq i (+ i 1))
	)
	(setq coordenada (+ coordenada 102))
	(move 0 coordenada)
	(pintalinea_hor 0 tope coordenada 2)
	(setq coordenada (+ coordenada 23))
	(move 0 coordenada)
	(pintalinea_hor 0 659 coordenada 5)
)

(defun pinta_g_v ()
	(setq tope 333)
	(setq coordenada 4)
	(move coordenada 0)
	(setq numero_casillas_hor 5)
	(setq i 0)
	(dotimes (i numero_casillas_hor)
		(setq coordenada (+ coordenada 102))
		(pintalinea_vert coordenada 0 tope 1)
		(move coordenada 0)
		(setq i (+ i 1))
	)
	(setq coordenada (+ coordenada 102))
	(pintalinea_vert coordenada 0 tope 2)
)

(defun pintalinea_hor (x1 x2 y n)
	(move x1 y)
	(setq i 0)
	(dotimes (i n)
		(draw x1 (+ y i) x2 (+ y i))
		(setq i (+ i 1))
		(move x1 (+ y i))
	)
)

(defun pintalinea_vert (x y1 y2 n)
	(move x y1)
	(setq i 0)
	(dotimes (i n)
		(draw (+ x i) y1 (+ x i) y2)
		(setq i (+ i 1))
		(move (+ x i) y1)
	)
)

(defun limpiar_img (posx posy)
	(color 255 255 255)
    (dotimes (y 100)
    	(dotimes (x 100)
    		(pintar (+ posx x) (- posy y))
    	)
    )
    (color 0 0 0)
)

( defun pintar (x y) 
	(move x y)
    (draw (+ x 1) y)
)


#| 
--------------------------------------------------------------------------------
--------FÚNCION DE LECTURA DE IMAGEN
--------A PARTIR DEL FICHERO .BMP REALIZA LA LECTURA DE LOS BYTES PARA PINTAR 
--------(O NO), CREANDO LA IMAGEN.
--------------------------------------------------------------------------------
|#
(defun leer_img (a posx posy)
    (setq identificador
      	(open a :element-type 'unsigned-byte))
    (dotimes (y 100)
    	(dotimes (x 100)
    		(cond 
    			((equal (read-byte identificador) 255) t)
    			((pintar (+ posx x) (- posy y)))
    		)
    	)
    )
)