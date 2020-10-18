with Ada.Numerics.Float_Random;

package vector is

   type Wektor is array (Integer range <>) of Float;

   procedure wypisz(v : Wektor);
   procedure losuj(v : in out Wektor);
   procedure sort(v : in out Wektor);
   procedure odczytaj(fileName : String; length : Integer);
   procedure log(event: String);

   private  Gen: Ada.Numerics.Float_Random.Generator;
end vector;
