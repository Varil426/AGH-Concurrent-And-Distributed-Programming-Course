with vector, Ada.Text_IO, Ada.Calendar, Ada.Calendar.Formatting; use vector, Ada.Text_IO, Ada.Calendar;

procedure Main is
   mojWektor : Wektor  := (6.5, 3.4, 65.56, 10.0);
   T1, T2 : Time;
   D : Duration;
   Nazwa : String(1..100) := (others => ' ');
   Dlugosc : Integer := 0;
begin
   T1 := Clock;
   log("Start");
   Put_Line("Zawartosc wektora:");
   wypisz(mojWektor);
   Put_Line("Losowanie nowych wartosci do wektora:");
   losuj(mojWektor);
   Put_Line("Wypisanie wylosowanych wartosci");
   wypisz(mojWektor);
   Put_Line("Sortowanie");
   sort(mojWektor);
   Put_Line("Wypisanie posortowanych wartosci");
   wypisz(mojWektor);
   T2 := Clock;
   D := T2 - T1;
   Put_Line("Program do tej pory zajal " & D'Image & "[s]");
   Put_Line("Podaj nazwe pliku do otwarcia: ");
   Get_Line(Nazwa, Dlugosc);
   T1 := Clock;
   begin
      odczytaj(Nazwa, Dlugosc);
      log("Opened file " & Nazwa(1..Dlugosc));
   exception
      when Name_Error =>
         Put_Line("Plik nie zostal znaleziony");
         log("File not found");
   end;
   T2 := Clock;
   D := T2 - T1;
   Put_Line("Operacja na plikach trwala " & D'Image & "[s]");
   log("End");
   end Main;
