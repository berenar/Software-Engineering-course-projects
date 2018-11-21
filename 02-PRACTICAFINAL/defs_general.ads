with Ada.containers,Ada.Numerics.Discrete_Random,pparaula;
use Ada.containers;

package defs_general is
----------------------------------------------------------------------------------
-- definición máximos--
----------------------------------------------------------------------------------
--máximo número de identificadores
max_id: constant integer:= 100; --DEFINIR MAXIMO IDENTIFICADOR
max_heap:constant integer:=80;
max_cicl: constant integer:=50;
max_cons:constant integer:= 5;
max_prob:constant integer:=4;

type ciclos is new integer range 0..max_cicl;
type name_id is new integer range 0..max_id;
null_id: constant name_id:= 0;
max_sim:constant integer:=71;

max_string:constant integer:=15;
num_lineas_fich: constant integer:=72;

type num_max_string is new integer range 1..max_string;
type num_sim is new integer range 1..max_sim;
subtype char_string is string(1..max_string);
type boolean is (true,false);

----------------------------------------------------------------------------------
-- definición randoms--
----------------------------------------------------------------------------------
type Rand_Range_100 is range 1..100; --Rango del random de probabilidades.
type Rand_Range_72 is range 1..72; --Rango del random de lectura de linea.

package Rand_Int_100 is new Ada.Numerics.Discrete_Random(Rand_Range_100);
package Rand_Int_72 is new Ada.Numerics.Discrete_Random(Rand_Range_72);

type num_prob is new integer range 1..max_cons;
type probabilidad is array (num_prob) of Rand_Range_100;

Num_100 : Rand_Range_100;
Num_72: Rand_Range_72;
----------------------------------------------------------------------------------
-- definición consultas--
----------------------------------------------------------------------------------
type num_cons is new integer range 1..max_cons;
----------------------------------------------------------------------------------
-- definicion tipo de visita--
----------------------------------------------------------------------------------
type tvisita is(em,ci,cu,re); --PRIMER VALUE ES 0 o 1 (?)

end defs_general;