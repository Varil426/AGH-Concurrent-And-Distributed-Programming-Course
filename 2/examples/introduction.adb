with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Introduction is

   type MyData is
      record                                  -- struktura danych
         Name : String(1..10) := (others => ' ');
         Surname : String(1..40) := (others => ' ');
         Age : Integer := 0;
         NextMyData : access MyData := Null; -- wskaznik do nastepnego elementu
      end record;


   type ptrMyData is access all MyData;       -- wskaznik do typu MyData

   procedure PrintDataList(DataList : access MyData) is
      L : access MyData := DataList; -- iterator
      length : Integer;
   begin
      if DataList = Null then Put_Line("No elements in the collection!!");
      else Put_Line("Elements: ");
      end if;
      while L /= Null loop
         length := L.Name'Length;
         Put(L.Name);
         New_Line;
         Put(L.Surname);
         New_Line;
         Put(L.Age);
         New_Line;
         L := L.NextMyData;
      end loop;
   end PrintDataList;

   procedure InsertToDataList(DataList : in out ptrMyData; Name : String; Surname : String; Age : in Integer) is
   --procedure InsertToDataList(DataList : in out ptrMyData; Age : in Integer) is
      pL : ptrMyData := new MyData;

   begin
      for I in Name'Range loop
         pL.Name(I) := Name(I);
      end loop;

      for I in Surname'Range loop
         pL.Surname(I) := Surname(I);
      end loop;

      pL.Age := Age;
      pL.NextMyData := DataList;
      DataList := pL;
   end InsertToDataList;

   ListOfMyData : ptrMyData := Null;

   myName : String := "Name_1";
   mySurname : String := "Surname_1";

begin
   --  Insert code here.
   PrintDataList(ListOfMyData);

   InsertToDataList(ListOfMyData, myName, mySurname, 101);
   InsertToDataList(ListOfMyData, "Name_2", "Surname_2", 102);
   PrintDataList(ListOfMyData);

   --null;
end Introduction;
