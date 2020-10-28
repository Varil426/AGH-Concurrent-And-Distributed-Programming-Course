with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Introduction_Ptr is

 --  struct _device_event {
 --      int major_number;
 --      int minor_number;
 --      int event_ident;
 --      struct _device_event* next;
 --   };

   type Date is
      record
         Year : Positive range 1 .. 2500;
         Month : Positive range 1 .. 12;
         Day : Positive range 1 .. 31;
         Next : access Date := null;
      end record;

   type Date_Ptr is access all Date;

   MyDay : Date := (2020, 10, 21, null);
   SomeOtherDay : Date := (Month => 10 , Day => 21 , Year => 2020, Next => null);

   procedure PrintDateList(DateList : access Date) is
      L : access Date := DateList;
   begin
      if DateList = Null then
         Put_Line("List EMPTY!");
      else
         Put_Line("List:");
      end if;
      while L /= Null loop
         Put_Line("Year: " & L.Year'Img);
         Put_Line("Month: " & L.Month'Img);
         Put_Line("Day: " & L.Day'Img);
         L := L.Next;
    end loop;
   end PrintDateList;

   procedure InsertDateToList(DateList : in out Date_Ptr; Year : in Positive; Month : in Positive; Day : in Positive) is
      E : Date_Ptr := new Date;

   begin
      E.Day := Day;
      E.Month := Month;
      E.Year := Year;
      E.Next := DateList;
      DateList := E;
   end InsertDateToList;

   DateList : Date_Ptr := Null;


begin
   --  No pointers:

   Put_Line("My Day");
   Put_Line("Year: " & MyDay.Year'Img);
   Put_Line("Month: " & MyDay.Month'Img);
   Put_Line("Day: " & MyDay.Day'Img);
   Put_Line("Some Other Day");
   Put_Line("Year: " & SomeOtherDay.Year'Img);
   Put_Line("Month: " & SomeOtherDay.Month'Img);
   Put_Line("Day: " & SomeOtherDay.Day'Img);

   -- Pointers:

   for I in reverse 1..5 loop
      InsertDateToList(DateList, 2020 + I, 1 + I, 10 + I);
   end loop;


   PrintDateList(DateList);

   null;
end Introduction_Ptr;
