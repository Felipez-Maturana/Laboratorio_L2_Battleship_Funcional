#lang racket


;##############################FunciOn entregada por la coordinaciOn##############################
(define a 1103515245)
(define c 12345)
(define m 2147483648)
;Esta función random tuma un xn y obtiene el xn+1 de la secuencia de números aleatorios.
(define myRandom
  (lambda
    (xn)
    (remainder (+ (* a xn) c) m)
  )
)
;Cada vez que pedimos un random, debemos pasar como argumento el random anterior.


;Acá un ejemplo que permite generar una lista de números aleatorios.
;Parámetros:
;* "cuantos" indica el largo de la lista a generar.
;* "xActual" valor actual del random, se pasa en cada nivel de recursiOn de forma actualizada
;* "maximo" Los números generados van desde 0 hasta maximo-1
(define getListaRandom
  (lambda (cuantos xActual maximo)
    (if (= 0 cuantos)
        '()
        (let ((xNvo (myRandom xActual)))
          (cons (remainder xNvo maximo)
              (getListaRandom (- cuantos 1) xNvo maximo)
          )
        )
    )
  )
)
;###############################################################################################

;###################################TDA Ships###################################################
;Representacion: 0
;TDA Ships
;Es una lista n-area la cual contiene todos los barcos del jugador o del enemigo. Para este ejemplo se harA con 4 Barcos
;El primer elemento es un entero el cual representa la cantidad de barcos que contiene el TDA.
;Los siguientes elementos son sub-listas que contienen las caracteristicas principales de ese ship.
;Las caracteristicas que contiene las sub listas de cada ship son:
;     #Largo (entero): 3
;     #Ancho(entero): 1
;     #Vida(entero): Largo*Ancho
;     #TipoATK(entero): 0 Ataques normales, 1 ataques por columnas
;     #Caracter (char): a-z y A-Z (ASCII imprimible)
;     #Comandante (a quien le pertenece): 1 para Jugador, 2 para enemigo
;Ejemplo para 4 barcos
; '(4 (3 1 3 0 #\a 2) (3 1 3 0 #\b 2) (3 1 3 0 #\c 2) (3 1 3 0 #\d 2))

;Constructores: 1
(define (Ships N Tipos) ;N cantidad de Barcos y Tipos una lista de la forma: '(1 #\a 1 #\b 2 #\c 2 #\d). Tipo de barco y letra que lo representa.
  (define (AuxShips N Tipos) ;Funcion encapsulada
    (if (= N 0) ;Caso base de la recursiOn
        null
        (if (= (car Tipos) 1) ;Si el Tipo de barco es 1
            (cons (list 3 1 3 0 (car (cdr Tipos)) 2) (AuxShips (- N 1) (cdr(cdr Tipos)))) ;list 3(largo) 1(ancho) 3(vida) 0(tipoATK) charRepresentado 2(a quien le pertenece) representa las caracteristicas del barco. Recursion Lineal.
            (if (= (car Tipos) 2)
                (cons (list 3 1 3 1 (car (cdr Tipos)) 2) (AuxShips (- N 1) (cdr(cdr Tipos)))) ;List posee las caracteristicas del barco segun el tipo. Recursion Lineal
                null)
            )
        )
    )
  (if (and (= (/ (length Tipos) 2) N) (= (length (filter char? Tipos)) (length (filter integer? Tipos))) ) ;Robustez de la funciOn, verifica que haya la misma cantidad de enteros que de char. Sin embargo no verifica el Orden. OJO puede ocasionar errores. EJ '(1 1 3 #\b #\a #\c 2 #\d)
      (cons N (AuxShips N Tipos))
      null)
  )

;Funciones de Pertenencia: 2
(define (Ships? S)
  (if (and (integer? (car S)) (= (car S) (length (cdr S)))) ;Verifica cantidad de barcos sea entero y que contenga la cantidad de barcos que senhala
      (if (= (length (filter list? (cdr S))) (car S)) ;Verifica que el resto de los elementos sean Listas.
          (if (= (length (filter (lambda(x)(= x 6)) (map length (filter list? (cdr S))))) (car S)) ; verifica que todas las listas tengan 6 elementos.
              #t
              #f)
          #f)
      #f)
  ) 
  
;Selectores: 3
(define (getShip Ships N) ;Funcion que obtiene la lista del barco N solicitado. 
  (define (getShipAux Ships N) ;Mediante una funciOn Auxiliar se optimiza los recursos utilizados en la robustez
    (if (= N 0) ;Se identifica el caso base
        (car Ships)
        (getShipAux (cdr Ships) (- N 1)) ;Se realiza el llamado Recursivo. Recursion de Cola
        )
    )
  (if (and (Ships? Ships) (< N (car Ships))) ;Se verifica que el parametro Ships contenga los barcos y que se consulte por un barco que exista en la posiciOn.
           (getShipAux (cdr Ships) N) ;Se llama a la funciOn auxiliar despuEs de las verificaciones correspondientes
           null)
  )

(define (getTotalBarcos Ships) ;Funcion que obtiene la cantidad total de barcos que posee el TDA Ships
  (if (Ships? Ships)
      (car Ships)
      -1)
  )

;Las funciones selectoras a continuaciOn utilizan el selector anterior para llevar a cabo su correcto funcionamiento.
;Cada una posee un funcionamiento similar, asi que sOlo se explicarAn dos de ellas getLargo y getComandante.
(define (getLargo Ships N) ;Para obtener el largo es necesario el parAmetro Ships que contiene todos los barcos del jugador o del Enemigo y el nUmero del barco que se desea consultar (N)
  (define (getLargoAux Ship) ;Mediante una funciOn auxiliar se optimiza los recursos utilizados en las consultas de robustez.
    (car Ship)) ;Se obtiene el primer elemento de la lista SHIP.
  (if (and (Ships? Ships) (< N (car Ships))) ;se verifica que Ships pertenezca al TDA SHIPS y que el N consultado pertenezca a la lista
      (getLargoAux (getShip Ships N)) ;SHIP serA el barco N de la lista SHIPS
      null) ;Si no cumple con las condiciones anteriormente expuestas: null
  )

(define (getAncho Ships N) 
  (define (getAnchoAux Ship)
    (car (cdr Ship)))
  (if (and (Ships? Ships) (< N (car Ships)))
      (getAnchoAux (getShip Ships N))
      null)
  )

(define (getVida Ships N)
  (define (getVidaAux Ship)
    (car (cdr (cdr Ship))))
  (if (and (Ships? Ships) (< N (car Ships)))
      (getVidaAux (getShip Ships N))
      null)
  )

(define (getTipoATK Ships N)
  (define (getTipoATKAux Ship)
    (car (cdr (cdr (cdr Ship)))))
  (if (and (Ships? Ships) (< N (car Ships)))
      (getTipoATKAux (getShip Ships N))
      null)
  )

(define (getChar Ships N)
  (define (getCharAux Ship)
    (car (cdr (cdr (cdr (cdr Ship))))))
  (if (and (Ships? Ships) (< N (car Ships)))
      (getCharAux (getShip Ships N))
      null)
  )

(define (getComandante Ships N) ;Para obtener a quiEn le pertenece el barco es necesario la lista que contiene todos los barcos (SHIPS) y el nUmero del barco que se desea consultar (N) 
  (define (getComandanteAux Ship) ;se utiliza una funciOn auxiliar
    (car (cdr (cdr (cdr (cdr (cdr Ship))))))) ;Se obtiene el sexto elemento de la lista SHIP (el barco N consultado)
  (if (and (Ships? Ships) (< N (car Ships))) ;Se verifica que el TDA Ships cumpla con las condiciones y el barco N pertenezca a la lista.
      (getComandanteAux (getShip Ships N)) ;Se realiza el llamado a la funciOn auxiliar. el parAmetro Ship corresponde al barco N de la lista Ships.
      null) ;En caso de que no cumpla con las condiciones anteriormente expuestas: null.
  )

;Modificadores: 4.
(define (setTotalBarcos Ships N)
  (define (setTotalAux Ships N)
    (cons N (cdr Ships)))
  (setTotalAux Ships N)
  )
    
   
(define (setVida Ships N Vida) ;Recibe la lista con los barcos, el nUmero del barco a Modificar y la vida resultante
  (define (setVidaAux Ships2 N Largo Ancho Vida TipoATK Char Comandante); Funcion auxiliar que encapsula el resto de parAmetros del barco a modificar
    (if (= N 0) ;Caso Base (se llegO al barco que se quiere modificar)
        (cons (list Largo Ancho Vida TipoATK Char Comandante) (cdr Ships2)) ;Se "actualiza" el barco N con los nuevos parAmetros  
        (cons (car Ships2) (setVidaAux (cdr Ships2) (- N 1) Largo Ancho Vida TipoATK Char Comandante))) ;Llamado recursivo (LINEAL)
    )
  (if (and (Ships? Ships) (< N (car Ships))) ;VerificaciOn de TDA Ships y que N pertenezca a la lista (no exceda los limites) 
      (cons (car Ships) (setVidaAux (cdr Ships) N (getLargo Ships N) (getAncho Ships N) Vida (getTipoATK Ships N) (getChar Ships N) (getComandante Ships N))) ;Llamado a la funciOn auxiliar
      null)
  )

(define (setTipoATK Ships N TipoATK) ;Funcion que cambia el tipo de ataque de un barco N contenido en ships al entero TipoATK.
  (define (setTipoATKAux Ships2 N Largo Ancho Vida TipoATK Char Comandante) ;funciOn auxiliar
    (if (= N 0) ;se identifica el caso base (se llegO al barco que se quiere "modificar"
        (cons (list Largo Ancho Vida TipoATK Char Comandante) (cdr Ships2)) ;Se modifica el antiguo tipo de ataque del barco N por el entero TipoATK 
        (cons (car Ships2) (setTipoATKAux (cdr Ships2) (- N 1) Largo Ancho Vida TipoATK Char Comandante))) ;Llamado recursivo, LINEAL
    )
  (if (and (Ships? Ships) (< N (car Ships)))
      (cons (car Ships) (setTipoATKAux (cdr Ships) N (getLargo Ships N) (getAncho Ships N) (getVida Ships N) TipoATK (getChar Ships N) (getComandante Ships N)))
      null)
  )


;Funciones que operan sobre TDA Ships: 5.
(define (addBarco Ships)
  (setTotalBarcos Ships (+ (getTotalBarcos Ships) 1))
  )
         
(define (Ataque Ships N) ;Funcion que realiza un ataque a un Barco N (resta su vida en una unidad)
  (setVida Ships N (- (getVida Ships N) 1)) ;Resta una unidad a la vida del Barco N
  )

(define (ObtenerNBarco Ships Char) ;Funcion que identifica el N del barco segUn el Char que lo represente
  (define (ObtenerNBarcoAux Ships Char N TotalBarcos) ;FunciOn auxiliar que encapsula el parAmetro N que funciona como contador
    (if (= N TotalBarcos)
        -1
        (if (eqv? (getChar Ships N) Char) ;Caso Base, si el caracter del barco N es igual que el caracter "Char"
            N
            (ObtenerNBarcoAux Ships Char (+ N 1) TotalBarcos)) ;Llamado recursivo aumentando en una unidad N. Recursion de COLA
        )
    )
  (ObtenerNBarcoAux Ships Char 0 (getTotalBarcos Ships))
  )

(define (agregarBarco Ships Tipo) ;Agrega un barco con las caracteristicas de Tipo al TDA Ships
  (define (agregarBarcoAux Ships Tipo acum NBarcos) ;FunciOn auxiliar que encapsula acum y NBarcos
    (if (= acum NBarcos) ;Caso base, final de la lista.
        (cons Tipo null) ;se agrega el nuevo Tipo al final de la lista.
        (cons (car Ships) (agregarBarcoAux (cdr Ships) Tipo (+ acum 1) NBarcos))) ;Llamado recursivo (LINEAL) hasta llegar al final de la lista
    )
  (setTotalBarcos (agregarBarcoAux Ships Tipo -1 (getTotalBarcos Ships)) (+ (getTotalBarcos Ships) 1)) ;Se realiza el llamado a la funciOn auxilair con acum -1 ya que la lista posee un elemento adicional que es el nUmero de barcos, entonces para llegar al final se debe realizar una recursiOn extra. Se agrega un barco al NBarcos.
  )
    
        
;Representacion: 0
;TDA Battleship
;El Board es una lista la cual contiene 9 elementos.
;El primer elemento corresponde a un entero que representa numero de Filas
;El segundo elemento corresponde a un entero que representa numero de Columnas
;El tercer elemento corresponde a un entero quiEn realizO el Ultimo disparo, 1 para jugador, 2 para enemigo. Inicialmente serA 0 ya que cualquiera puede partir jugando.
;El cuarto elemento corresponde a un entero que representa si la partida ha comenzado o no. 1 para comenzado, 0 en caso contrario.
;El quinto elemento corresponde a un entero que representa si la partida ha finalizado o no. 1 para finalizado, 0 en caso contrario.
;El sexto elemento corresponde a un entero que representa el resultado del Ultimo disparo realizado, 0 si cayO al agua, 1 si dio a un barco sin destruirlo completamente y 2 si lo hizo.
;El septimo elemento corresponde a una lista dentro de Esta estructura que representa el tablero donde se jugarA, este tendrA las siguientes caracterIsticas
;     #La dimension de la lista serA de una fila por n*m columnas, es decir: 1xN*M
;     #Las casillas vacias o las que no se han revelado aUn se representaran con el carActer '.' (ASCII 46)
;     #Cada una de las columnas se irAn posicionando una tras otra de forma lineal por cada fila, es decir, en un tablero de 3x4 (3 filas y 4 columnas)
;     #Ejemplo 3x4: ''(3 4 0 0 0 0 (#\. #\. #\. #\X #\. #\. #\O #\. #\. #\. #\. #\.) 0 0 (0) (0)) La X estA posicionada en la coordenada 2,1 y la O EstA posicionada en la coordenada 3,1.
;El tablero sOlo se ha iniciado, por lo que los Ultimos cuatro elementos se encuetran vacIos y con valor cero para el caso del TDA Ships y la cantidad de barcos de cada jugador respectivamente.
;El octavo elemento corresponde a un entero que representa la cantidad de Barcos que posee el Enemigo
;El noveno elemento corresponde a un entero que representa la cantidad de Barcos que posee el Jugador
;El dEcimo elemento corresponde a una lista de barcos del jugador correspondientes al TDA Ships descrito anteriormente.
;El onceavo elemento corresponde a una lista de barcos del jugador correspondientes al TDA Ships descrito anteriormente.


;Constructores: 1.
;Recibe como parametros la dimension del tablero nxm (filas y columnas respectivamente)
(define (Battleship n m)
  (define (AuxTablero a) ;funcion auxiliar que crea el tablero de dimension nxm con m par
    (if (= a 0)
        null
        (cons #\. (AuxTablero (- a 1)))
        )
    )
  (if (and (integer? m) (integer? (/ m 2))) ;verifica si m es entero y si es par 
      (if (integer? n) ;verifica que n sea entero
          (if (> n 0) ;verifica que n sea mayor que 0
              (if (> m 1) ;verifica que m sea mayor que 1
                  (cons n (cons m (cons 0 (cons 0 (cons 0(cons 0(cons (AuxTablero (* n m)) (cons 0 (cons 0 (cons '(0) (cons '(0) null))))))))))); Si cumple todas las condiciones anteriormente descritas crea una
                  null) ;Si no cumple una de las condiciones anteriormente expuestas retorna null (conservando el recorrido de las funciones)
              null)
          null)
      null)
  )


;Funciones de Pertenencia: 2. 
(define (Battleship? B) ;Comprueba si B cumple las condiciones para ser considerado un TDA Battleship (Solo si pertenece, no si es vAlido)
  (if (and (list? B) (= (length B) 11) (integer? (car B)) (> (car B) 0) ); Verifica que contenga 11 elementos y que la primera componente, es decir las filas sean un entero mayor a 0
      (if (and (integer? (car (cdr B))) (> (car (cdr B)) 0)); Verifica que el segundo elemento, es decir, las columnas sea un entero y mayor a 0.
          (if (and (integer? (car(cdr(cdr B)))) (or (= (car(cdr(cdr B))) 0) (= (car(cdr(cdr B))) 1) (= (car(cdr(cdr B))) 2))); Verifica el ultimo jugador sea un 0, un 1 o un 2. 
              (if (and (integer? (car(cdr(cdr(cdr B)))) ) (or (= (car(cdr(cdr(cdr B)))) 0) (= (car(cdr(cdr(cdr B)))) 1))); Verifica Si el entero que representa una partida iniciada sea un 
                  (if (and (integer? (car(cdr(cdr(cdr(cdr B))))) ) (or (= (car(cdr(cdr(cdr(cdr B))))) 0) (= (car(cdr(cdr(cdr(cdr B))))) 1)))
                      (if (and (integer? (car(cdr(cdr(cdr(cdr (cdr B)))))) ) (or (= (car(cdr(cdr(cdr(cdr (cdr B)))))) 0) (= (car(cdr(cdr(cdr(cdr (cdr B)))))) 1) (= (car(cdr(cdr(cdr(cdr (cdr B)))))) 2)))
                          (if (and (list? (car(cdr(cdr(cdr(cdr (cdr (cdr B)))))))) ( = (length(car(cdr(cdr(cdr(cdr(cdr(cdr B)))))))) (* (car B) (car (cdr B)))) )
                              (if (integer? (car(cdr(cdr(cdr(cdr (cdr (cdr (cdr B)))))))))
                                  (if (integer? (car(cdr(cdr(cdr(cdr (cdr (cdr (cdr (cdr B))))))))))
                                      #t
                                      #f)
                                  #f)
                              #f)
                          #f)
                      #f)
                  #f)
              #f)
          #f)
      #f))
                                         
;Selectores: 3.
;El siguiente selector permite acceder a una posiciOn X,Y del tablero en el TDA Ships, es necesario senhalar que la identificaciOn del tablero en sus dos coordenadas comienzan en el 0,0.
;Recibe como parAmetros las coordenadas X e Y a las cuales se quiere acceder y el tda Battleship.
;El recorrido de la funciOn son el conjunto de los char.
(define (getElemento x y BS) ;El sig
  (define (auxElemento1 a L) ;FunciOn auxiliar que recibe la lsita que representa al tablero (sEptimo elemento del TDA Battleship), a un entero que representa la posicion lineal equivalente
    ;a la posiciOn ingresada en la matriz, ya que esta representaciOn es lineal y una matriz no lo es.
    ;la forma de calcular a es: (M * X) + Y donde M es la cantidad de columnas y X,Y la posiciOn a la cuAl se quiere acceder.
    (if (= a 0) ;caso base de la recursiOn de cola 
        (car L) ;se retorna el elemento encontrado
        (auxElemento1 (- a 1) (cdr L)) ;llamado recursivo (COLA)
        )
    )
  (if (and (Battleship? BS) (< x (car BS)) (< y (car (cdr BS)) ) ) ;se verifica que BS pertenezca al TDA Battleship
      (auxElemento1 (+ (* (car (cdr BS)) x) y) (car(cdr(cdr(cdr(cdr(cdr(cdr BS)))))))) ;llamado a la funciOn auxiliar con a= M*X + Y
      #\%);para respetar el codominio de la funciOn se retorna un char que no pertenece a ninguna representaciOn.
  )

(define (getFila BS) ;FunciOn que entrega la cantidad de filas que tiene el TDA Battleship
  ;como parAmetro recibe TDA Battleship
  (if (Battleship? BS) ;se consulta si BS pertenece al TDA Battleship mediante la funciOn de pertenencia del TDA Battleship(nivel 2)
      (car BS)
      -1) ;Para respetar el codominio de la funciOn se retorna -1, valor que no tiene consistencia en la implementaciOn.
  )

(define (getColumna BS)
  ;como parAmetro recibe TDA Battleship
  (if (Battleship? BS);se consulta si BS pertenece al TDA Battleship mediante la funciOn de pertenencia del TDA Battleship(nivel 2)
      (car (cdr BS))
      -1) ;Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA -1, valor que no tiene consistencia en la implementaciOn.
  )

(define (getUltimoJugador BS)
  ;como parAmetro recibe TDA Battleship
  (if (Battleship? BS);se consulta si BS pertenece al TDA Battleship mediante la funciOn de pertenencia del TDA Battleship(nivel 2)
      (car (cdr (cdr BS)))
      -1);Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA -1, valor que no tiene consistencia en la implementaciOn.
  )

(define (getPartidaIniciada BS)
  ;como parAmetro recibe TDA Battleship
  (if (Battleship? BS);se consulta si BS pertenece al TDA Battleship mediante la funciOn de pertenencia del TDA Battleship(nivel 2)
      (car (cdr(cdr (cdr BS))))
      -1);Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA -1, valor que no tiene consistencia en la implementaciOn.
  )

(define (getPartidaFinalizada BS)
  ;como parAmetro recibe TDA Battleship
  (if (Battleship? BS);se consulta si BS pertenece al TDA Battleship mediante la funciOn de pertenencia del TDA Battleship(nivel 2)
      (car (cdr(cdr(cdr(cdr BS)))))
      -1);Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA -1, valor que no tiene consistencia en la implementaciOn.
  )

(define (getEstadoDisparo BS)
  ;como parAmetro recibe TDA Battleship
  (if (Battleship? BS);se consulta si BS pertenece al TDA Battleship mediante la funciOn de pertenencia del TDA Battleship(nivel 2)
      (car (cdr(cdr(cdr(cdr(cdr BS))))))
      -1) ;Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA -1, valor que no tiene consistencia en la implementaciOn.
  )

(define (getTablero BS)
  ;como parAmetro recibe TDA Battleship
  (if (Battleship? BS);se consulta si BS pertenece al TDA Battleship mediante la funciOn de pertenencia del TDA Battleship(nivel 2)
      (car (cdr(cdr(cdr(cdr(cdr(cdr BS)))))))
      -1) ;Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA -1, valor que no tiene consistencia en la implementaciOn.
  )

(define (getBarcosEnemigo BS)
  ;como parAmetro recibe TDA Battleship
  (if (Battleship? BS);se consulta si BS pertenece al TDA Battleship mediante la funciOn de pertenencia del TDA Battleship(nivel 2)
      (car (cdr(cdr(cdr(cdr(cdr(cdr(cdr BS))))))))
      -1) ;Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA -1, valor que no tiene consistencia en la implementaciOn.
  )

(define (getBarcosJugador BS)
  ;como parAmetro recibe TDA Battleship
  (if (Battleship? BS);se consulta si BS pertenece al TDA Battleship mediante la funciOn de pertenencia del TDA Battleship(nivel 2)
      (car (cdr(cdr(cdr(cdr(cdr(cdr(cdr(cdr BS)))))))))
      -1);Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA null valor que no tiene consistencia en la implementaciOn.
  )

(define (getListaBarcosJugador BS)
  ;como parAmetro recibe TDA Battleship
  (if (Battleship? BS);se consulta si BS pertenece al TDA Battleship mediante la funciOn de pertenencia del TDA Battleship(nivel 2)
      (car (cdr(cdr(cdr(cdr(cdr(cdr(cdr(cdr(cdr BS))))))))))
      null) ;Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA null, valor que no tiene consistencia en la implementaciOn.
  )

(define (getListaBarcosEnemigos BS)
  ;como parAmetro recibe TDA Battleship
  (if (Battleship? BS);se consulta si BS pertenece al TDA Battleship mediante la funciOn de pertenencia del TDA Battleship(nivel 2)
      (car (cdr(cdr(cdr(cdr(cdr(cdr(cdr(cdr(cdr(cdr  BS)))))))))))
      null) ;Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA null, valor que no tiene consistencia en la implementaciOn.
  )

;Modificadores: 4.
;Todos los modificadores poseen el mismo conjunto de llegada, TDA Battleship.
;ademAs, todos poseen parAmetros estructurados de la siguiente forma:
;el primero es el TDA Battleship, y el nuevo parAmetro con el que se construirA 
(define (setLastPlayer BS LP)
  (if (Battleship? BS)
      (list (getFila BS) (getColumna BS) LP (getPartidaIniciada BS) (getPartidaFinalizada BS) (getEstadoDisparo BS) (getTablero BS) (getBarcosEnemigo BS) (getBarcosJugador BS) (getListaBarcosJugador BS) (getListaBarcosEnemigos BS)) 
      null) ;Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA null, valor que no tiene consistencia en la implementaciOn.
  )

(define (setPartidaIniciada BS PINI)
  (if (Battleship? BS)
      (list (getFila BS) (getColumna BS) (getUltimoJugador BS) PINI (getPartidaFinalizada BS) (getEstadoDisparo BS) (getTablero BS) (getBarcosEnemigo BS) (getBarcosJugador BS) (getListaBarcosJugador BS) (getListaBarcosEnemigos BS)) 
      null) ;Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA null, valor que no tiene consistencia en la implementaciOn.
  )

(define (setPartidaFinalizada BS PFINI)
  (if (Battleship? BS)
      (list (getFila BS) (getColumna BS) (getUltimoJugador BS) (getPartidaIniciada BS) PFINI (getEstadoDisparo BS) (getTablero BS) (getBarcosEnemigo BS) (getBarcosJugador BS) (getListaBarcosJugador BS) (getListaBarcosEnemigos BS)) 
      null) ;Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA null, valor que no tiene consistencia en la implementaciOn.
  )

(define (setEstadoDisparo BS EDISPARO)
  (if (Battleship? BS)
      (list (getFila BS) (getColumna BS) (getUltimoJugador BS) (getPartidaIniciada BS) (getPartidaFinalizada BS) EDISPARO (getTablero BS) (getBarcosEnemigo BS) (getBarcosJugador BS) (getListaBarcosJugador BS) (getListaBarcosEnemigos BS)) 
      null) ;Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA null, valor que no tiene consistencia en la implementaciOn.
  )

(define (setCelda x y BS ELEMENTO) ;crea un nuevo tablero con Elemento inserto en la posiciOn x,y segUn la implementaciOn.
  (define (auxElemento1 a L)
    (if (= a 0)
        (cons ELEMENTO (cdr L))
        (cons (car L) (auxElemento1 (- a 1) (cdr L)))
        )
    )
  (if (and (< x (getFila BS)) (< y (getColumna BS)))
      (list (getFila BS) (getColumna BS) (getUltimoJugador BS) (getPartidaIniciada BS) (getPartidaFinalizada BS) (getEstadoDisparo BS) (auxElemento1 (+ (* (getColumna BS) x) y) (getTablero BS)) (getBarcosEnemigo BS) (getBarcosJugador BS) (getListaBarcosJugador BS) (getListaBarcosEnemigos BS))
      null) ;Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA null, valor que no tiene consistencia en la implementaciOn.
  )

(define (setBarcosEnemigos BS NBENEMIGOS)
  (if (Battleship? BS)
      (list (getFila BS) (getColumna BS) (getUltimoJugador BS) (getPartidaIniciada BS) (getPartidaFinalizada BS) (getEstadoDisparo BS) (getTablero BS) NBENEMIGOS (getBarcosJugador BS) (getListaBarcosJugador BS) (getListaBarcosEnemigos BS))
      null) ;Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA null, valor que no tiene consistencia en la implementaciOn.
  )

(define (setBarcosJugador BS NBJUGADOR)
  (if (Battleship? BS)
      (list (getFila BS) (getColumna BS) (getUltimoJugador BS) (getPartidaIniciada BS) (getPartidaFinalizada BS) (getEstadoDisparo BS) (getTablero BS) (getBarcosEnemigo BS) NBJUGADOR (getListaBarcosJugador BS) (getListaBarcosEnemigos BS))
      null) ;Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA null, valor que no tiene consistencia en la implementaciOn.
  ) 

(define (setListaBarcosJugador BS Tipo)
  (if (Battleship? BS)
      (list (getFila BS) (getColumna BS) (getUltimoJugador BS) (getPartidaIniciada BS) (getPartidaFinalizada BS) (getEstadoDisparo BS) (getTablero BS) (getBarcosEnemigo BS) (+ (getBarcosJugador BS) 1) (agregarBarco (getListaBarcosJugador BS) Tipo) (getListaBarcosEnemigos BS))
      null) ;Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA null, valor que no tiene consistencia en la implementaciOn.
  )

(define (setListaBarcosEnemigo BS Tipo)
  (if (Battleship? BS)
      (list (getFila BS) (getColumna BS) (getUltimoJugador BS) (getPartidaIniciada BS) (getPartidaFinalizada BS) (getEstadoDisparo BS) (getTablero BS) (+ (getBarcosEnemigo BS) 1) (getBarcosJugador BS) (getListaBarcosJugador BS) (agregarBarco (getListaBarcosEnemigos BS) Tipo))
      null) ;Para respetar el codominio de la funciOn, en el caso que falle el elemento de llegada serA null, valor que no tiene consistencia en la implementaciOn.
  )
  








;Funciones que operan sobre Battleship: 5.
(define (aumentarBarcosJugador board)
  ;recorrido: listas.
  ;FunciOn que aumenta en uno la cnatidad total de barcos del jugador, esta funciOn se utiliza en el posicionamiento de barcos (putship)
  (if (Battleship? board)
      (setBarcosJugador board (+ (getBarcosJugador board) 1)) ;se obtiene la cantidad actual y se aumenta en una unidad.
      null) 
  )


(define (AtacarBarcoJugador BS N)
  ;funciOn que se encarga de restar en una unidad la vida del barco que ocupa la posiciOn numero N en la lista de barcos del jugador, esta funciOn se utiliza en la funciOn play.
  ;recorrido: listas.
  (if (Battleship? BS)
      ;se crea un nuevo TDA BAttleship, se apoya en la funciOn ataque perteneciente del TDA SHIPS el cual recibe el parAmetro con la lista de ships que se obtiene mediante (getListaBarcosJugador) y el parAmetro N.
      (list (getFila BS) (getColumna BS) (getUltimoJugador BS) (getPartidaIniciada BS) (getPartidaFinalizada BS) (getEstadoDisparo BS) (getTablero BS) (getBarcosEnemigo BS) (getBarcosJugador BS) (Ataque (getListaBarcosJugador BS) N) (getListaBarcosEnemigos BS))
      null)
  )

(define (AtacarBarcoEnemigo BS N)
  (list (getFila BS) (getColumna BS) (getUltimoJugador BS) (getPartidaIniciada BS) (getPartidaFinalizada BS) (getEstadoDisparo BS) (getTablero BS) (getBarcosEnemigo BS) (getBarcosJugador BS) (getListaBarcosJugador BS) (Ataque (getListaBarcosEnemigos BS) N))
  )


(define (destruirBarcoEnemigo BS)
  ;funciOn que resta en una unidad la cantidad de barcos total del enemigo. Se utiliza esta funciOn cuando la vida de un barco ha llegado a cero.
  ;recorrido: Listas.
  (if (Battleship? BS)
      (list (getFila BS) (getColumna BS) (getUltimoJugador BS) (getPartidaIniciada BS) (getPartidaFinalizada BS) (getEstadoDisparo BS) (getTablero BS) (- (getBarcosEnemigo BS) 1) (getBarcosJugador BS) (getListaBarcosJugador BS) (getListaBarcosEnemigos BS))
      null)
  )

(define (destruirBarcoJugador BS)
  ;recorrido: Listas.
  (if (Battleship? BS)
      (list (getFila BS) (getColumna BS) (getUltimoJugador BS) (getPartidaIniciada BS) (getPartidaFinalizada BS) (getEstadoDisparo BS) (getTablero BS) (getBarcosEnemigo BS) (- (getBarcosJugador BS) 1) (getListaBarcosJugador BS) (getListaBarcosEnemigos BS))
      null)
  )

(define (setGanador BS)
  ;recorrido: Listas.
  ;verifica que a alguno de los jugadores no le resten barcos por jugar, si es asI cambia el valor de PartidaFinalziada (5to elemnto del TDA Battleship)
  ;por un 1 si es que el jugador ganO la partida y por un 2 si es que el enemigo ganO la partida.
  (if (Battleship? BS)
      (if (= (getBarcosJugador BS) 0)
          (list (getFila BS) (getColumna BS) (getUltimoJugador BS) (getPartidaIniciada BS) 2 (getEstadoDisparo BS) (getTablero BS) (getBarcosEnemigo BS) (getBarcosJugador BS) (getListaBarcosJugador BS) (getListaBarcosEnemigos BS))
          (if (= (getBarcosEnemigo BS) 0)
              (list (getFila BS) (getColumna BS) (getUltimoJugador BS) (getPartidaIniciada BS) 1 (getEstadoDisparo BS) (getTablero BS) (getBarcosEnemigo BS) (getBarcosJugador BS) (getListaBarcosJugador BS) (getListaBarcosEnemigos BS))
              BS) )
      null)
  )

(define (verificarGanador BS) ;FunciOn que verifica si existe algUn ganador, en la funciOn play se hace uso de esta funciOn para verificar si la partida ha finalizado o no, en caso de que haya finalizado no permita realizar mAs ataques.
  ;recorrido: listas.
  (if (Battleship? BS) ;Verifica que BS sea TDA Battleship, de lo contrario el elemento de llegada es null.
      (if (not (= (getPartidaFinalizada BS) 0)) ;si el elemento que representa el estado de partida finalizado no es igual a cero, quiere decir que ha finalizado.
          #t
          #f) ;en el caso que sea igual a cero quiere decir que la partida no ha finalizado 
      null)
  )
          


;FunciOn createBoardRC: crea un tablero vAlido con la mitad del enemigo con sus barcos posicionados de forma Aleatoria. Se hace uso de la funciOn getListaRandom entregada por la coordinaciOn.
(define (createBoardRC N M ships seed) ;Recibe un entero N que representa la cantidad de Filas que tendrA el tableor, un entero M (Columnas), un TDA Ships en su representaciOn y una semilla la cuAl estA representada como un entero la cual se encarga de 
  (define (posicionamientoAuxH BS X Y ship acum) ;FunciOn que se encarga de posicionar el barco de forma horizontal en la posiciOn X Y 3 unidades hacia la derecha
    (if (= acum 3) ;condiciOn de borde, si ya se posicionaron los 3 char que representan al barco 
        (setListaBarcosEnemigo BS ship) ;Cuando ya se posicion el barco, se agrega Este al TDA (Ultimo elemento del TDA)
        (posicionamientoAuxH (setCelda X (+ Y acum) BS (car (cdr (cdr (cdr (cdr ship)))))) X Y ship (+ acum 1)     ) ) ) ;RecursiOn de cola, no hay elementos pendientes
  (define (posicionamientoAuxV BS X Y ship acum) ;Al igual que la anterior, posiciona el barco de forma vertical a partir la posiciOn X Y 3 unidades hacia abajo
    (if (= acum 3) ;condiciOn de borde, si ya se posicionaron los 3 char que representa al barco
        (setListaBarcosEnemigo BS ship) ;se agrega el barco a la lista de barcos enemigos en el TDA (Ultimo elemento del TDA) 
        (posicionamientoAuxV (setCelda (+ X acum) Y BS (car (cdr (cdr (cdr (cdr ship)))))) X Y ship (+ acum 1)     ) ) ) ;RecursiOn de cola, no hay elementos pendientes.
  (define (columnaRandom seed M) ;funciOn que genera una lista con potenciales columnas para nuestro tablero.
    ;Recorrido: Lista con elementos aleatorios mayores o iguales a M/2  y menores a 3 posiciones que el mAximo de columnas.
    ;Ej: si el tablero es de 5x10. generarA una lista con 30 elementos del 0 a 8. Luego filtra de esos 30 elementos los que son mayores o iguales a M/2.
    ;Inicialmente se generan 30 elementos ya que existe la posibilidad que genere sOlo elementos menores a M/2 lo cual provocarA un error. A mayor cantidad de elementos se reduce la posibilidad de caer en un error por falta de elementos
    (filter (lambda (x) (> x (- (/ M 2) 1) )) (getListaRandom 30 seed (- M 2)))
    )
  (define (createAux BS ships seed acum NBarcos N M) ;FunciOn que se encarga de crear el tablero.
    (if (= acum NBarcos) ;CondiciOn de borde, si ya se posicionaron todos los barcos.
        BS ;El codominio es el TDA Battleship, en este caso el que proviene de las recursiones de createAux cuando ya se hayan posicionado todos los barcos que provienen de ships.
        (if (and (eqv? (getElemento (car (getListaRandom 2 seed N)) (car (columnaRandom seed M) ) BS) #\.) (eqv? (getElemento (car (getListaRandom 2 seed N)) (+ (car (columnaRandom seed M)) 1) BS) #\.) (eqv? (getElemento (car (getListaRandom 2 seed N)) (+ (car (columnaRandom seed M)) 2) BS) #\.) ) ;verifica que en las tres posiciones [(X,Y) (X,Y+1) (X,Y+2)]  estEn libres, es decir sean iguales a #\. 
            (createAux (posicionamientoAuxH BS (car (getListaRandom 2 seed N)) (car (columnaRandom seed M) ) (car ships) 0) (cdr ships) (+ seed 1) (+ acum 1) NBarcos N M) ;Si estAn libres las tres posiciones consultadas ocurre un posicionamiento Horizontal. 
            (if (and (eqv? (getElemento (car (getListaRandom 2 seed N)) (car (columnaRandom seed M)) BS) #\.) (eqv? (getElemento (+ (car (getListaRandom 2 seed N)) 1) (car (columnaRandom seed M)) BS) #\.) (eqv? (getElemento (+ (car (getListaRandom 2 seed N)) 2) (car (columnaRandom seed M)) BS) #\.) ) ;verifica que las tres posiciones [(X,Y) (X+1,Y) (X+2,Y)] estEn libres, es decir, sean equivalentes a #\.
                (createAux (posicionamientoAuxV BS (car (getListaRandom 2 seed N)) (car (columnaRandom seed M)) (car ships) 0) (cdr ships) (+ seed 1) (+ acum 1) NBarcos N M) ;Si estAn libres las tres posiciones verticales consultadas, ocurre un posicionamiento Vertical.
                (createAux BS ships (+ seed 1) acum NBarcos N M) ) ;Si ninguna de las 2 veces que consultamos por posiciones el acumulador se mantiene ya que el posicionamiento no fue exitoso y se realiza un llamado recursivo con una nueva semilla la cual generarA nuevas posiciones X e Y para posicionar.
            )
        )
    )
  (if (even? M) ;Se verifica que M sea par para evitar problemas de creaciOn mAs tarde
      (createAux (Battleship N M) (cdr ships) seed 0 (car ships) N M)
      null)
  )


;FunciOn createBoardRL: crea un tablero vAlido con la mitad del enemigo con sus barcos posicionados de forma Aleatoria. Se hace uso de la funciOn getListaRandom entregada por la coordinaciOn.
(define (createBoardRL N M ships seed) ;Recibe un entero N que representa la cantidad de Filas que tendrA el tableor, un entero M (Columnas), un TDA Ships en su representaciOn y una semilla la cuAl estA representada como un entero la cual se encarga de 
  (define (posicionamientoAuxH BS X Y ship) ;FunciOn que se encarga de posicionar los barcos en forma horizonal (3 casillas de forma contigua)
    (setListaBarcosEnemigo (setCelda X Y (setCelda X (+ Y 1) (setCelda X (+ Y 2) BS (car (cdr (cdr (cdr (cdr ship)))))) (car (cdr (cdr (cdr (cdr ship)))))) (car (cdr (cdr (cdr (cdr ship))))) ) ship))
  (define (posicionamientoAuxV BS X Y ship) ;FunciOn que se encarga de posicionar los barcos en forma vertical (3 casillas de forma contigua).
    ;Recorrido TDA Battleship
    (setListaBarcosEnemigo (setCelda X Y (setCelda (+ X 1) Y (setCelda (+ X 2) Y BS (car (cdr (cdr (cdr (cdr ship)))))) (car (cdr (cdr (cdr (cdr ship)))))) (car (cdr (cdr (cdr (cdr ship))))) ) ship) )
  ;recursiOn lineal: las dos funciones setCelda exteriores esperan el resultado del setCelda interno (+ x 2) es decir, son estados pendientes.
  (define (columnaRandom seed M) ;FunciOn que se encarga de generar una lista que posea una columna congruente con las Dimensiones
    ;Recorrido: Lista con elementos aleatorios mayores o iguales a M/2  y menores a 3 posiciones que el mAximo de columnas.
    ;Ej: si el tablero es de 5x10. generarA una lista con 30 elementos del 0 a 8. Luego filtra de esos 30 elementos los que son mayores o iguales a M/2.
    ;Inicialmente se generan 30 elementos ya que existe la posibilidad que genere sOlo elementos menores a M/2 lo cual provocarA un error. A mayor cantidad de elementos se reduce la posibilidad de caer en un error por falta de elementos.
    (filter (lambda (x) (> x (- (/ M 2) 1) )) (getListaRandom 30 seed (- M 2)))
    )
  (define (createAux BS ships seed acum NBarcos N M)
    (if (= acum NBarcos) ;CondiciOn de borde, ya se posicionaron todos los barcos.
        BS ;Recorrido: TDA Battleship
        (if (and (eqv? (getElemento (car (getListaRandom 2 seed N)) (car (columnaRandom seed M) ) BS) #\.) (eqv? (getElemento (car (getListaRandom 2 seed N)) (+ (car (columnaRandom seed M)) 1) BS) #\.) (eqv? (getElemento (car (getListaRandom 2 seed N)) (+ (car (columnaRandom seed M)) 2) BS) #\.) )
            ;RecursiOn de cola a crearAux con un nuevo tablero al cual se posicionO un barco. se cambia la semilla para generar nuevas posiciones y se aumenta en una unidad la cantidad de barcos posicionados hasta el momento
            (createAux (posicionamientoAuxH BS (car (getListaRandom 2 seed N)) (car (columnaRandom seed M)) (car ships)) (cdr ships) (+ seed 1) (+ acum 1) NBarcos N M)
            (if (and (eqv? (getElemento (car (getListaRandom 2 seed N)) (car (columnaRandom seed M)) BS) #\.) (eqv? (getElemento (+ (car (getListaRandom 2 seed N)) 1) (car (columnaRandom seed M)) BS) #\.) (eqv? (getElemento (+ (car (getListaRandom 2 seed N)) 2) (car (columnaRandom seed M)) BS) #\.) )
                (createAux (posicionamientoAuxV BS (car (getListaRandom 2 seed N)) (car (columnaRandom seed M)) (car ships)) (cdr ships) (+ seed 1) (+ acum 1) NBarcos N M)
                (createAux BS ships (+ seed 1) acum NBarcos N M) ) ;Si no fue posible posicionar en X Y generados por la semilla, se cambia la semilla y no se agregan barcos ya que el posicionamiento con esa semilla fue no exitoso.
            )
        )
    )
  (if (even? M) ;verifica que M sea par. Posteriormente se realiza esta verificacion, sin embargo realizarla en esta etapa economiza recursos y optimiza el cOdigo ya que en primera instancia ni si quiera se llamarA a createAux
      (createAux (Battleship N M) (cdr ships) seed 0 (car ships) N M)
      null)
  )


;Funcion checkBoard, verifica que un tablero previamente creado, cumpla con las condiciones como para ser considerado vAlido
(define (checkBoard board) ;funciOn que su dominio es un TDA battleship y su recorrido es un booleano #t en caso que cumpla con todas las verificaciones y #f en caso contrario 
  (define (checkBoardAux N M LastPlayer Pcomenzada Pfinalizada EstadoUltimoDisparo Tablero NBarcosEnemigo NBarcosJugador ShipsJugador ShipsEnemigo) ;FunciOn auxiliar que recibe todos los elementos del TDA a ser chequeados
    (if (and (integer? N) (> N 0)) ;verifica que las filas sean un entero y que sea mayor a 0.
        (if (and (integer? M) (> M 0) (even? M 2) 0) ;verifica que la coordenada de columna sea un entero, ademAs, sea par y mayor a 0
            (if (and (integer? LastPlayer) (or (= LastPlayer 0) (= LastPlayer 1)) ) ;verifica que la representaciOn de LastPlayer sea un entero y ademAs posea los valores congruentes (0 y 1)
                (if (and (integer? Pcomenzada) (or (= Pcomenzada 0) (= Pcomenzada 1)) ) ;verifica que la representaciOn de PartidaComensada sea un entero y ademAs posea los valores congruentes (0 y 1)
                    (if (and (integer? EstadoUltimoDisparo) (or (= EstadoUltimoDisparo 0) (= EstadoUltimoDisparo 1)) ) ;verifica que la representaciOn de LastPlayer sea un entero y ademAs posea los valores congruentes (0 y 1)
                        (if (and (list? Tablero) (eqv? (length Tablero) (* N M)) (eqv? (length (filter char? Tablero)) (* N M) ) ) ;verifica que la representaciOn de tablero corresponda a un entero y que el largo de Este sea equivalente a la cantidad total de filas * columnas y que todas los elementos contenidos en El sean char.
                            (if (and (integer? NBarcosEnemigo) (>= NBarcosEnemigo 0)) ;La cantidad de barcos enemigos debe ser un entero y mayor a 0
                                (if (and (integer? NBarcosJugador) (>= NBarcosJugador 0)) ;La cantidad de barcos jugador debe ser un entero y mayor a 0
                                    (if (Ships? ShipsJugador) ;El penUltimo elemento del TDA Battleship corresponda a una lista de barcos jugador (correspondiente al TDA Ships) ver linea 74.
                                        (if (Ships? ShipsEnemigo) ;El ultimo elemento del TDA Battleship corresponde a una lista de barcos del enemigo (corresponde al TDA ships) ver lInea 74.
                                            #t
                                            #f)
                                        #f)
                                    #f)
                                #f)
                            #f)
                        #f)
                    #f)
                #f)
            #f)
        #f))
  (if (Battleship? board) ;se verifca que el dominio de la funciOn sea concordante con lo esperado (TDA Battleship)
      (checkBoardAux board) ;Si lo anterior es correcto, se procede a verificar. (Recorrido: Boolean)
      #f)
  )


;Funcion board->string muestra por pantalla de forma entendible y comprensible para el usuario, showComplete determina si se muestra el tablero de forma completa o parcial (solo el tablero del jugador)
(define (board->string board showComplete) ;Recibe board (TDA BATTLESHIP) y (un entero) showComplete
  ;funciOn recibe un TDA Ships como parAmetro
  ;conjunto de llegada: mostrar un string por pantalla mediante printf.
  (define (mostrar1 board N M acum)  ;Funcion auxiliar que entrega una lista como resultado. (recibe N M (dimensiones del tablero) y un acum que inicialmente es 0.
    (if (= acum (* N M))  ;se reconoce el caso base, si acum es igual a N*M, no queda tablero por imprimir. 
        (cons #\| (cons #\newline (cons #\newline null))) ;se agrega un separador y dos saltos de lInea al final de la lista.
        (if (and (not (= acum 0)) (= (remainder acum M) 0)) ;Si el resto entre el acumulador y la cantidad de columnas, quiere decir que es necesario ingresar una nueva fila.
            (cons #\| (cons #\newline (cons #\| (cons (car board) (mostrar1 (cdr board) N M (+ acum 1)))   ))) ;se agrega un salto de linea y se realiza un llamado recursivo (LINEAL)
            (cons #\| (cons (car board) (mostrar1 (cdr board) N M (+ acum 1)) )) ) ;El caso normal es que se agregue un separador, y el elemento que se encuentra en la posiciOn acum (de forma lineal, segun la representaciOn de nuestro tablero).
        )
    )
  (define (mostrar0 board N M x y acum)
    (if (= acum (* N M))
        (cons #\newline (cons #\newline null))
        (if (< y (/ M 2))
            (cons #\| (cons (car board) (mostrar0 (cdr board) N M x (+ y 1) (+ acum 1))))
            (if (or (eqv? (car board) #\.) (eqv? (car board) #\@) (eqv? (car board) #\O) (eqv? (car board) #\X))
                (if (= y (- M 1))
                    (cons #\| (cons (car board) (cons #\| (cons #\newline (mostrar0 (cdr board) N M x 0 (+ acum 1)))   )))
                    (cons #\| (cons (car board) (mostrar0 (cdr board) N M x (+ y 1) (+ acum 1)) )))
                (if (= y (- M 1))
                    (cons #\| (cons #\. (cons #\| (cons #\newline (mostrar0 (cdr board) N M x 0 (+ acum 1)))   )))
                    (cons #\| (cons #\. (mostrar0 (cdr board) N M x (+ y 1) (+ acum 1)) )) ) ))
        )
    )
  (if (Battleship? board) ;Se realizan las verificaciones correspondientes
      (if (integer? showComplete) ;showComplete debe ser un entero
          (if (= showComplete 1) ;Si showcomplete es 1, mostramos el tablero de forma completa
              (printf (list->string (mostrar1 (getTablero board) (getFila board) (getColumna board) 0)))
              (if (= showComplete 0)
                  (printf (list->string (mostrar0 (getTablero board) (getFila board) (getColumna board) 0 0 0)))
                  (printf "showComplete debe ser 0 o 1.")) )             
          (printf "El segundo parAmetro debe ser un entero."))
      (printf "Ingrese un tablero vAlido"))       
  )

;FunciOn putship coloca un barco en el tablero board
(define (putship board position ship)  ;Position tiene la forma: (N '(X1 Y1 X2 Y2 X3 Y3 ...)) Donde N senhala la cantidad de posiciones que posee la sub lista siguiente), en este caso es solo una posiciOn y la funciOn posiciona el barco segUn la cantidad de espacios que utilice.
  (define (putshipAux BS X Y ship) ;FunciOn auxiliar que encapsula a X e Y que representan la posiciOn X1 e Y1 contenidas en PosiciOn
    (setCelda X Y BS (car (cdr (cdr (cdr (cdr ship)))))) ) ;Mediante el modificador setCelda se "modifica" la celda (X,Y) del tablero por la letra del ship contenida en (car (cdr (cdr (cdr (cdr ship)))))
  (if (and (Battleship? board) (= (getPartidaIniciada board) 0) (< (getBarcosJugador board) (+ (getBarcosEnemigo board) 1))) ;Verifica que la partida no se haya iniciado aUn, y que el jugador no posea mAs de 1 barco de diferencia respecto a los barcos Enemigos
      (if (and (list? (car (cdr position))) (= (car position) (/ (length (car (cdr position))) 2))  (= (car(cdr(cdr(cdr(cdr(cdr ship)))))) 1)   ) ;Verifica que la posiciOn posea el formato que se expuso mAs arriba
          (if (and (integer? (car (car (cdr position)))) (< (car (car (cdr position))) (getFila board)) (> (car (car (cdr position))) -1) ) ;Verifica que la coordenada de Fila de la posiciOn entregada sea mayor o igual a 0 y menor al numero de filas del tablero
              (if (and (integer? (car (cdr (car (cdr position))))) (< (car (cdr (car (cdr position)))) (/ (getColumna board) 2) ) (> (car (cdr (car (cdr position)))) -1) ) ;Verifica que la coordenada de Columna de la posiciOn entregada 
                  (if (and (< (+ (car (car (cdr position))) 2) (getFila board)) (eqv? #\. (getElemento (car (car (cdr position))) (car (cdr (car (cdr position)))) board)) (eqv? #\. (getElemento (+ (car (car (cdr position))) 1) (car (cdr (car (cdr position)))) board)) (eqv? #\. (getElemento (+ (car (car (cdr position))) 2) (car (cdr (car (cdr position)))) board))) ;Verifica que tres posiciones hacia abajo consecutivas estEn desocupadas 
                      (setListaBarcosJugador (putshipAux (putshipAux (putshipAux board (+ (car (car (cdr position))) 2) (car (cdr (car (cdr position)))) ship) (+ (car (car (cdr position))) 1) (car (cdr (car (cdr position)))) ship) (car (car (cdr position))) (car (cdr (car (cdr position)))) ship) ship);Si las posiciones estAn desocupadas, se hace el llamado a putshipAux 3 veces, recibiendo el tablero con el que se previamente se colocO el barco, ademAs aumentando en una unidad los barcos que posee el Jugador en este caso.
                      (if (and (< (+ (car (cdr (car (cdr position)))) 2) (/ (getColumna board) 2) ) (eqv? #\. (getElemento (car (car (cdr position))) (car (cdr (car (cdr position)))) board)) (eqv? #\. (getElemento (car (car (cdr position))) (+ (car (cdr (car (cdr position)))) 1) board)) (eqv? #\. (getElemento (car (car (cdr position))) (+ (car (cdr (car (cdr position)))) 2) board))) ;Si las 3 posiciones consecutivas hacia abajo no estAn desocupadas (#\.) se verifican las 3 posiciones consecutivas hacia la derecha.
                          (setListaBarcosJugador (putshipAux (putshipAux (putshipAux board (car (car (cdr position))) (+ (car (cdr (car (cdr position)))) 2) ship) (car (car (cdr position))) (+ (car (cdr (car (cdr position)))) 1) ship) (car (car (cdr position))) (car (cdr (car (cdr position)))) ship) ship);Si estAn desocupadas, de forma similar a la anterior se realiza el posicionamiento del barco en las posiciones previamente probadas.
                          board))
                  board)
              board)
          board)
      board)
  )
                      
                  
                  
                  
  
    
;FunciOn play realiza una jugada sobre el tablero, el ataque lo realiza el barco ship y afecta en las posiciones que contenga el TDA positions segUn el disenho que Este posee en esta implementaciOn         
;ExplicaciOn Algoritmo:
;En primer lugar verifica que el ship que realiza el ataque pertenezca al jugador, esta funciOn no la puede realizar el enemigo ya que es el jugador. Los ataques tanto del enemigo como del jugador
;son realizados con disparoAux.
;Si la partida aUn no ha comenzado, y posee las caracteristicas como para empezar (difernecia entre cantidad de barcos jugador y enemigo debe tener un delta de 1)
;Si la partida ya ha comenzado es necesario verificar si no ha terminado, si ya ha terminado el elemento de llegada serA el mismo tablero que fue ingresado como parAmetro de la funciOn
;verificarGanador tiene como elemento de llegada el booleano true si la partida ha finalizado.
;Si todas las condiciones anteriores se cumplen, se realizan los dos ataques. en primer lugar el del jugador y luego como respuesta un ataque del enemigo de un barco seleccionado de forma aleatoria y
;posiciones elegidas de forma aleatoria de acuerdo a las caracteristicas de armamento que posea ese barco. El algoritmo realizarA ataques masivos siempre que pueda.
;Para eso se crearon las funciones ship aleatorio, ademAs X e Y aleatorios que generan coordenadas aleatorias sin violar las condiciones del tablero y que pertenezcan al tablero del jugador/
;La funciOn verificarPositions recibe las posiciones donde el jugador atacarA (parAmetro positions)
;y revisa que todas las posiciones a atacar pertenezcan a la mitad del enemigo, para eso se apoya de verificarFilas y verificarColumnas
;verifica principalmente que todas las coordenadas de filas sean mayores a 0 y menores al dimensiOn FILA del board
;y que todas las coordenadas de columnas sean mayores o iguales a M/2 y menores a M.
;La funciOn disparoAux se lleva todo el trabajo de verificar los tipos de disparos (agua, debilitar barco y destruir barco)
;para se utiliza recursiOn de cola, el caso de borde es cuando se han realizado todos los disparos. En este momento se asigna como LastPlayer en el TDA Battleship.\
;en primer lugar se verifica a quiEn pertenece el barco que estA atacando, si pertenece a jugador, cuando se encuentre un barco se buscarAn en la ListaBarcosEnemigo petenecientes al TDA.
;En caso contrario, si esl disparo lo efectUa un barco que le pertenezca al enemigo (comandante = 2) se buscarA en ListaBarcosJugador.
;El resto de las recursiones pregunta por el char que estA en la celda (x,y) correspondientes a la posiciOn que recibe la funciOn
;Las representaciones de la matriz son las siguientes:
; #\. = vacIa.
; #\@ = disparo que cayO al agua.
; #\O = disparo que le diO a un barco pero no lo destruyO
; #\X = disparo que diO a un barco y lo destruyO
;Si estA vacIa \#. se cambia por el char \#@.
;Si la celda consultada no es #\. #@ #\O #\X
;Quiere decir que en la celda hay un barco. por lo tanto se obtiene el char que ocupa la celda y se consigue el nUmero que ocupa en ListaBarcosXXXXX.
;Gracias a este nUmero y la implementaciOn del TDA Ship es posible consultar por sus caracteristicas con getShip N de la lista de barcos del player correspondiente
;Si la vida resultante es 0, quiere decir que lo hemos destruidos, se descuenta en una unidad la cantidad Total de barcos que posee el duenho del barco
;Si tras ese descuento no le quedan mAs barcos la partida se da por finalizada y se registra en el tablero.
;de lo contrario quiere decir que el barco no ha sido destruido y se marca con #\O.
;En ambos casos se registra el estado del Ultimo disparo en el TDA.
(define (play board ship positions seed)  
  (define (disparoAux BS position Npositions ship acum) ;FunciOn auxiliar que realiza los disparos en el tablero.
    (if (= Npositions acum) ;Se identifica el caso base de la recursiOn de cola
        (setLastPlayer BS (getComandante ship 0)) ;Cuando no queden disparos por realizar, se aisgna como Ultimo jugador, el jugador al cual le pertenece el Barco
        (if (eqv? (getElemento (car position) (car (cdr position)) BS) #\.) ;CondiciOn si la celda estA vacIa
            (disparoAux (setEstadoDisparo (setCelda (car position) (car (cdr position)) BS #\@) 0) (cdr (cdr position)) Npositions ship (+ acum 1)) ; Si la celda estA vaciA se identifica en el tablero con un char @
            (if (and (not (eqv? (getElemento (car position) (car (cdr position)) BS) #\.)) (not (eqv? (getElemento (car position) (car (cdr position)) BS) #\X)) (not (eqv? (getElemento (car position) (car (cdr position)) BS) #\@)) (not (eqv? (getElemento (car position) (car (cdr position)) BS) #\O))) ;CondiciOn que verifica que en la celda exista un barco (que no estE vacIa y que no sea ni una X O @ las cuales representan que se realizO previamente un disparo)
                (if (and (= (getComandante ship 0) 1) (not (verificarGanador BS)))  ;condiciOn que el disparo fue realizado por el jugador
                    (if (= (getVida (getListaBarcosEnemigos BS) (ObtenerNBarco (getListaBarcosEnemigos BS) (getElemento (car position) (car (cdr position)) BS) ) ) 1) ;Si el disparo fue realizado por el jugador, se busca en la lista de los barcos enemigos la letra que representa al barco para consultar por su vida
                        (setGanador (destruirBarcoEnemigo (disparoAux (setEstadoDisparo (setCelda (car position) (car (cdr position)) (AtacarBarcoEnemigo BS (ObtenerNBarco (getListaBarcosEnemigos BS) (getElemento (car position) (car (cdr position)) BS) )) #\X) 2) (cdr (cdr position)) Npositions ship (+ acum 1)) ))  ;Si (= (- vida 1) 0) el barco ha sido destruido. Se marca con una X. Y se resta en una unidad la cantidad de barcos totales. se deja una marca histOrica en el tablero. 2 como resultado del Ultimo disparo
                        (disparoAux (setEstadoDisparo (setCelda (car position) (car (cdr position)) (AtacarBarcoEnemigo BS (ObtenerNBarco (getListaBarcosEnemigos BS) (getElemento (car position) (car (cdr position)) BS) )) #\O) 1) (cdr (cdr position)) Npositions ship (+ acum 1)) ) ;Si la vida es mayor a 0 luego del ataque, se marca solo con una O y se deja una marca histOrica en el tablero. 1 como resultado del Ultimo disparo
                    (if (and (= (getComandante ship 0) 2) (not (verificarGanador BS))) ;de forma idEntica a lo explicado anteriormente sOlo que en esta ocasiOn el disparo lo realiza la cpu
                        (if (= (getVida (getListaBarcosJugador BS) (ObtenerNBarco (getListaBarcosJugador BS) (getElemento (car position) (car (cdr position)) BS) ) ) 1) ;condiciOn para verificar si el barco ha sido destruido
                            (setGanador (destruirBarcoJugador (disparoAux (setEstadoDisparo (setCelda (car position) (car (cdr position)) (AtacarBarcoJugador BS (ObtenerNBarco (getListaBarcosJugador BS) (getElemento (car position) (car (cdr position)) BS) )) #\X) 2) (cdr (cdr position)) Npositions ship (+ acum 1)) )) ;Si ha sido destruido se marca con una X (con setCelda) en el tablero, ademAs se realiza el disparo, como fue destruido es necesario restar en una unidad el total de  barcos que posee el jugador y si esta cantidad es igual a 0, la partida ha finalizado (setGanador verifica y setea). 
                            (disparoAux (setEstadoDisparo (setCelda (car position) (car (cdr position)) (AtacarBarcoJugador BS (ObtenerNBarco (getListaBarcosJugador BS) (getElemento (car position) (car (cdr position)) BS) )) #\O) 1) (cdr (cdr position)) Npositions ship (+ acum 1)) ) ;
                        BS))
                BS)))
    )
  (define (verificarPositions board positions Npositions) 
    (define (verificarFilas N positions Npositions acum)
      (if (= acum Npositions)
          #t
          (if (and (>= (car positions) 0) (< (car positions) N))
              (verificarFilas N (cdr (cdr positions)) Npositions (+ acum 1))
              #f)))
    (define (verificarColumnas M positions Npositions acum)
      (if (= acum Npositions)
          #t
          (if (and (>= (car (cdr positions)) (/ M 2)) (< (car (cdr positions)) M))
              (verificarColumnas M (cdr (cdr positions)) Npositions (+ acum 1))
              #f)))
    (if (and (verificarFilas (getFila board) (car (cdr positions)) (car positions) 0) (verificarColumnas (getColumna board) (car (cdr positions)) (car positions) 0))
        #t
        #f)
    )
 
  (define (generadorPosiciones N M ship X Y)
    (define (generadorAUX N M tipoATK X Y acum)
      (if (= tipoATK 1)
          (if (= acum (- N 1))
              (cons X (cons Y null)) 
              (cons X (cons Y (generadorAUX N M tipoATK (+ X 1) Y (+ acum 1)))))
          null)
      )
    (if (= (getTipoATK ship 0) 0)
          (list 1 (list X Y))
          (if (= (getTipoATK ship 0) 1)
              (list N  (generadorAUX N M (getTipoATK ship 0) 0 Y 0))
              null) )
    )
  (define (shipAleatorio BS seed)
    (list 1 (getShip (getListaBarcosEnemigos BS) (car (getListaRandom 1 (+ seed 3) (getTotalBarcos (getListaBarcosEnemigos BS)))))) ;Obtiene un barco aleatorio, el primer elemento de la lista random creada con la semilla y como mAximo la cantidad de barcos que tiene el Enemigo.
    )
  (define (XAleatorio BS seed)
    (car (getListaRandom 1 (+ seed 3) (getFila BS)))
    )
  (define (YAleatorio BS seed)
    (car (filter (lambda (x) (< x (/ (getColumna BS) 2))) (getListaRandom 30 (+ seed 4) (getColumna BS)) )) 
    )    
  (if (and (= (getComandante ship 0) 1) (verificarPositions board positions (car positions)) )
      (if (and (= (getPartidaIniciada board) 0) (>= (getBarcosJugador board) 1) (>= (getBarcosEnemigo board) 0) (<= (abs (- (getBarcosJugador board) (getBarcosEnemigo board))) 1) )  
          (setPartidaIniciada (disparoAux (disparoAux board (car (cdr (generadorPosiciones (getFila board) (getColumna board) (shipAleatorio board seed) (XAleatorio board seed) (YAleatorio board seed)) )) (car (generadorPosiciones (getFila board) (getColumna board) (shipAleatorio board seed) (XAleatorio board seed) (YAleatorio board seed))) (shipAleatorio board seed)  0) (car (cdr positions)) (car positions) ship 0) 1)
          (if (= (getPartidaIniciada board) 1)
              (if (verificarGanador board)
                  board
                  (disparoAux (disparoAux board (car (cdr (generadorPosiciones (getFila board) (getColumna board) (shipAleatorio board seed) (XAleatorio board seed) (YAleatorio board seed)) )) (car (generadorPosiciones (getFila board) (getColumna board) (shipAleatorio board seed) (XAleatorio board seed) (YAleatorio board seed))) (shipAleatorio board seed)  0) (car (cdr positions)) (car positions) ship 0)) 
              board) )
      board)
  )


(define (getScore board)
  (define (getTableroEnemigo N M board y acum)
    (if (= acum (* N M))
        null
        (if (< y (/ M 2))
            (getTableroEnemigo N M (cdr board) (+ y 1) (+ acum 1))
            (if (= y (- M 1))
                (cons (car board) (getTableroEnemigo N M (cdr board) 0 (+ acum 1)))
                (cons (car board) (getTableroEnemigo N M (cdr board) (+ y 1) (+ acum 1))))
            )
        )
    )
  (define (getDisparosExitosos board)
    (length (filter (lambda (x) (eqv? x #\O)) board))
    )
  (define (getBarcosDestruidos board)
    (length (filter (lambda (x) (eqv? x #\X)) board))
    )
  (define (getDisparosFaliidos board)
    (length (filter (lambda (x) (eqv? x #\@)) board))
    )
  (define (getScoreAux DE BD DF BJ BE)
    (- (+ (* DE 100) (* BD 400) (* (- BJ BE) 200) ) (* DF 50))
    )
  (if (Battleship? board)
      (if (> (getScoreAux (getDisparosExitosos (getTableroEnemigo (getFila board) (getColumna board) (getTablero board) 0 0)) (getBarcosDestruidos (getTableroEnemigo (getFila board) (getColumna board) (getTablero board) 0 0)) (getDisparosFaliidos (getTableroEnemigo (getFila board) (getColumna board) (getTablero board) 0 0)) (getBarcosJugador board) (getBarcosEnemigo board)) 0)
          (getScoreAux (getDisparosExitosos (getTableroEnemigo (getFila board) (getColumna board) (getTablero board) 0 0)) (getBarcosDestruidos (getTableroEnemigo (getFila board) (getColumna board) (getTablero board) 0 0)) (getDisparosFaliidos (getTableroEnemigo (getFila board) (getColumna board) (getTablero board) 0 0)) (getBarcosJugador board) (getBarcosEnemigo board))
          0)
      -1)
  )
            






        
  















;(Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d))
;(setTotalBarcos (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 5)
;(agregarBarco '(0) '(3 1 3 1 #\d 2))
;(Ships? '(4 (3 1 3 0 #\a #\a) (3 1 3 0 #\b 2) (3 1 3 1 #\c 2) (3 1 3 1 #\d 2)))

;Prueba de los Selectores TDA Ships
;(getShip (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 3)
;(getLargo (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 3)
;(getAncho (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 3)
;(getVida (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 3)
;(getTipoATK (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 3)
;(getChar (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 3)
;(getComandante (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 3)
;(ObtenerNBarco (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) #\d)
;Prueba modificadores TDA Ships
;(setVida (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 3 0) 
;(setTipoATK (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 3 0)
;Prueba de Funciones que operan sobre TDA Ships
;(Ataque (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 3)


;Pruebas TDA BattleShip
;(Battleship 5 8)
;(getElemento 2 1 (Battleship 3 2))
;(checkBoard (Battleship 3 4))
;(Battleship? (Battleship 3 4))
;(setCelda 2 1 (Battleship 5 10) #\C)
;(setCelda 2 2 (Battleship 10 5) #\C)
;(board->string (Battleship 5 10) 1)


;(board->string (putship (Battleship 5 10) (list 1 (list 1 1)) '(3 1 3 1 #\d 2)) 1)
;(board->string (putship (putship (Battleship 5 10) (list 1 (list 1 1)) '(3 1 2 1 #\d 2)) (list 1 (list 0 1)) '(3 1 2 1 #\e 2)) 1)

;(putship (putship (Battleship 5 10) (list 1 (list 1 1)) '(3 1 2 1 #\d 2)) (list 1 (list 0 1)) '(3 1 2 1 #\e 2))
;(board->string (createBoardRC 5 10 (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 4) 1)
;(createBoardRC 5 9 (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 3)



;(board->string (putship (putship (putship (putship (putship (createBoardRC 5 10 (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 1) (list 1 (list 1 1)) '(3 1 3 1 #\d 1)) (list 1 (list 0 1)) '(3 1 3 1 #\e 1)) (list 1 (list 4 1)) '(3 1 3 1 #\a 1)) (list 1 (list 1 0)) '(3 1 3 1 #\b 1)) (list 1 (list 1 2)) '(3 1 3 1 #\c 1)) 1)
;(play (putship (putship (putship (putship (putship (createBoardRC 5 10 (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 1) (list 1 (list 1 1)) '(3 1 3 1 #\d 1)) (list 1 (list 0 1)) '(3 1 3 1 #\e 1)) (list 1 (list 4 1)) '(3 1 3 1 #\a 1)) (list 1 (list 1 0)) '(3 1 3 1 #\b 1)) (list 1 (list 1 2)) '(3 1 3 1 #\c 1)) '(1 (3 1 3 1 #\d 2)) (list 1 (list 1 1)) 1) 
;(board->string (play (putship (putship (putship (putship (putship (createBoardRC 5 10 (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 1) (list 1 (list 1 1)) '(3 1 3 1 #\d 1)) (list 1 (list 0 1)) '(3 1 3 1 #\e 1)) (list 1 (list 4 1)) '(3 1 3 1 #\a 1)) (list 1 (list 1 0)) '(3 1 3 1 #\b 1)) (list 1 (list 1 2)) '(3 1 3 1 #\c 1)) '(1 (3 1 3 1 #\d 1)) (list 5 (list 0 5 0 6 0 7 0 8 0 9)) 10) 1)

;(play (putship (putship (putship (putship (putship (createBoardRC 5 10 (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 1) (list 1 (list 1 1)) '(3 1 3 1 #\d 1)) (list 1 (list 0 1)) '(3 1 3 1 #\e 1)) (list 1 (list 4 1)) '(3 1 3 1 #\a 1)) (list 1 (list 1 0)) '(3 1 3 1 #\b 1)) (list 1 (list 1 2)) '(3 1 3 1 #\c 1)) '(1 (3 1 3 1 #\d 1)) (list 3 (list 0 5 0 6 0 7)) 10)
(board->string (play (putship (putship (putship (putship (putship (createBoardRC 5 10 (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 1) (list 1 (list 1 1)) '(3 1 3 1 #\d 1)) (list 1 (list 0 1)) '(3 1 3 1 #\e 1)) (list 1 (list 4 1)) '(3 1 3 1 #\a 1)) (list 1 (list 1 0)) '(3 1 3 1 #\b 1)) (list 1 (list 1 2)) '(3 1 3 1 #\c 1)) '(1 (3 1 3 1 #\d 1)) (list 5 (list 0 5 0 6 0 7 0 8 0 9)) 10) 0)
(board->string (play (putship (putship (putship (putship (putship (createBoardRC 5 10 (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 1) (list 1 (list 1 1)) '(3 1 3 1 #\d 1)) (list 1 (list 0 1)) '(3 1 3 1 #\e 1)) (list 1 (list 4 1)) '(3 1 3 1 #\a 1)) (list 1 (list 1 0)) '(3 1 3 1 #\b 1)) (list 1 (list 1 2)) '(3 1 3 1 #\c 1)) '(1 (3 1 3 1 #\d 1)) (list 5 (list 0 5 0 6 0 7 0 8 0 9)) 10) 1)
;(play (putship (putship (putship (putship (putship (createBoardRC 5 10 (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 1) (list 1 (list 1 1)) '(3 1 3 1 #\d 1)) (list 1 (list 0 1)) '(3 1 3 1 #\e 1)) (list 1 (list 4 1)) '(3 1 3 1 #\a 1)) (list 1 (list 1 0)) '(3 1 3 1 #\b 1)) (list 1 (list 1 2)) '(3 1 3 1 #\c 1)) '(1 (3 1 3 1 #\d 1)) (list 5 (list 0 5 0 6 0 7 0 8 0 9)) 10)

(getScore (play (putship (putship (putship (putship (putship (createBoardRC 5 10 (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 1) (list 1 (list 1 1)) '(3 1 3 1 #\d 1)) (list 1 (list 0 1)) '(3 1 3 1 #\e 1)) (list 1 (list 4 1)) '(3 1 3 1 #\a 1)) (list 1 (list 1 0)) '(3 1 3 1 #\b 1)) (list 1 (list 1 2)) '(3 1 3 1 #\c 1)) '(1 (3 1 3 1 #\d 1)) (list 5 (list 0 5 0 6 0 7 0 8 0 9)) 10))

(board->string (play (putship (putship (putship (putship (putship (createBoardRC 5 10 (Ships 4 '(1 #\a 1 #\b 2 #\c 2 #\d)) 1) (list 1 (list 1 1)) '(3 1 3 1 #\d 1)) (list 1 (list 0 1)) '(3 1 3 1 #\e 1)) (list 1 (list 4 1)) '(3 1 3 1 #\a 1)) (list 1 (list 1 0)) '(3 1 3 1 #\b 1)) (list 1 (list 1 2)) '(3 1 3 1 #\c 1)) '(1 (3 1 3 1 #\d 1)) (list 5 (list 0 0 0 1 0 2 0 3 0 4)) 10) 1)