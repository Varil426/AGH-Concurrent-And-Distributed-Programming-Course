with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Pointer is

   type Date is
      record
         Year : Positive range 1 .. 2500;
         Month : Positive range 1 .. 12;
         Day : Positive range 1 .. 31;
         Next : access Date := null;
      end record;

   type Date_Ptr is access all Date;

   ptr : Date_Ptr := Null;
   ptrNew : Date_Ptr := Null;

begin
   --  Insert data:
   ptr := new Date;
   ptr.Year := 2020;
   ptr.Month := 10;
   ptr.Day := 21;
   ptr.Next := Null;

   ptrNew := new Date;
   ptrNew := ptr;

   -- Print data:
   Put_Line("Year: " & ptr.Year'Img);
   Put_Line("Month: " & ptr.Month'Img);
   Put_Line("Day: " & ptr.Day'Img);

   -- Print data:
   Put_Line("Year: " & ptrNew.Year'Img);
   Put_Line("Month: " & ptrNew.Month'Img);
   Put_Line("Day: " & ptrNew.Day'Img);

   --  Insert data:
   --ptr := new Date;
   ptrNew.Year := 2000;
   ptrNew.Month := 12;
   ptrNew.Day := 31;
   ptrNew.Next := Null;

   -- Print data:
   Put_Line("Year: " & ptr.Year'Img);
   Put_Line("Month: " & ptr.Month'Img);
   Put_Line("Day: " & ptr.Day'Img);

   null;
end Pointer;
