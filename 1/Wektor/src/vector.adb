with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Directories, Ada.IO_Exceptions, Ada.Calendar, Ada.Calendar.Formatting; use Ada.Text_IO;

package body vector is
   procedure wypisz (v : Wektor) is
      index : Integer := 0;
   begin
      for i in v'Range loop
         index := index + 1;
         Put("Dla indeksu: " & index'Image & " wartosc: ");
         Put_Line(v(i)'Image);
      end loop;
   end wypisz;

   procedure losuj (v: in out Wektor) is
      --package Los is new Ada.Numerics.Float_Random(Gen);
      --use Los;
   begin
      Ada.Numerics.Float_Random.Reset(Gen);
      for i in v'Range loop
         v(i) := Ada.Numerics.Float_Random.Random(Gen);
      end loop;
   end losuj;

   procedure sort (v: in out Wektor) is
      tmp: Float;
      finished : Boolean;
   begin
      --TODO Sortowanie
      loop
         finished := True;
         for i in v'First..v'Last-1 loop
            if(v(i) < v(i + 1)) then
               finished := False;
               tmp := v(i+1);
               v(i+1) := v(i);
               v(i) := tmp;
            end if;
         end loop;
         exit when finished;
      end loop;
   end sort;

   procedure odczytaj (fileName : String; length : Integer) is
      P1: File_Type;
      line: String(1..100);
      l: Integer;
   begin
      --Put_Line(Ada.Directories.Current_Directory);
      begin
         Open(P1, In_File, fileName(fileName'First..length));
         loop
            exit when End_Of_File(P1);
            Get_Line(P1, line, l);
            Put_Line(line(line'First..l));
         end loop;
      exception
            when Ada.IO_Exceptions.Name_Error => raise Ada.IO_Exceptions.Name_Error;
      end;
      Close(P1);
   end odczytaj;

   procedure log(event: String) is
      Dziennki : File_Type;
   begin
      begin
         Open(Dziennki, Append_File, "dziennik.txt");
      exception
         when Ada.IO_Exceptions.Name_Error => Create(Dziennki, Out_File, "dziennik.txt");
      end;
      Put_Line(Dziennki, event & ": " & Ada.Calendar.Formatting.Image(Ada.Calendar.Clock));
      Close(Dziennki);
   end log;



end vector;
