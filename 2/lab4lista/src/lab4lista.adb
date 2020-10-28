with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Numerics.Discrete_Random, System.Address_Image, Ada.Unchecked_Deallocation;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Lab4Lista is

   type Element is
      record 
         Data : Integer := 0;
         Next : access Element := Null;
      end record; 

   type Elem_Ptr is access all Element;

   procedure Free is new Ada.Unchecked_Deallocation(Element, Elem_Ptr);
   
procedure Print(List : access Element) is
  L : access Element := List;
begin
  if List = Null then
    Put_Line("List EMPTY!");
  else
    Put_Line("List:"); 
  end if; 
  while L /= Null loop
    Put(L.Data, 4); -- z pakietu Ada.Integer_Text_IO
    New_Line;
    L := L.Next;
  end loop; 
end Print;

procedure Insert(List : in out Elem_Ptr; D : in Integer) is
  E : Elem_Ptr := new Element; 
begin
  E.Data := D;
  E.Next := List;
  -- lub E.all := (D, List);
  List := E;
end Insert;

-- wstawianie jako funkcja - wersja krótka
function Insert(List : access Element; D : in Integer) return access Element is 
  ( new Element'(D,List) ); 

-- do napisania !! 
   procedure Insert_Sort(List : in out Elem_Ptr; D : in Integer) is 
      current: Elem_Ptr;
      tmp: Elem_Ptr;
begin
      -- napisz procedurę wstawiającą element zachowując posortowanie (rosnące) listy
      if(List = null) then
         List := new Element;
         List.Data := D;
      else
               current := List;
      if(current.Data > D) then
         Insert(List, D);
      else
         while current.Next /= null and then current.Next.Data < D
         loop
            current := current.Next;
         end loop;
         if(current.Next = null) then
               current.Next := new Element;
               current.Next.Data := D;
               current.Next.Next := null;
            else
               tmp := current.Next;
               current.Next := new Element;
               current.Next.Data := D;
               current.Next.Next := tmp;
            end if;
      end if;
      end if;
end Insert_Sort;

   procedure generate(List: in out Elem_Ptr;N :in Integer; M : in Integer) is
      package Los_Liczby is new Ada.Numerics.Discrete_Random(Integer);
      use Los_Liczby;
      Gen: Generator;
   begin
      Reset(Gen);
      for I in 1..N loop
         Insert_Sort(List, Random(Gen) mod M);
      end loop;
   end generate;
   
Lista : Elem_Ptr := Null;


   function search(List: in Elem_Ptr; e : Integer) return Elem_Ptr is
      current : Elem_Ptr := List;
   begin
      while current.Data /= e and then current.Next /= Null loop
         current := current.Next;
      end loop;
      if current.Data = e then
         return current;
      end if;
      return null;
   end search;
   
   procedure remove(List: in out Elem_Ptr; e : Integer) is
      current: Elem_Ptr;
      tmp: Elem_Ptr;
   begin
      while List.Data = e loop
         tmp := List;
         List := List.Next;
         Free(tmp);
      end loop;
      if List /= null then
         current := List.Next;
         while current.Next.Next /= null loop
            if current.Next.Data = e then
               tmp := current.Next;
               current.Next := current.Next.Next;
               Free(tmp);
            else
               current := current.Next;
            end if;
         end loop;
         if current.Next.Data = e then
            tmp := current.Next;
            current.Next := null;
            Free(tmp);
         end if;
      end if;
   end remove;
   
   elemtToBeFound : Elem_Ptr;
   
begin
  Print(Lista);
  Insert_Sort(Lista, 21);
  Print(Lista);
  Insert(Lista, 20); 
  Print(Lista);
  --for I in reverse 1..12 loop
  --Insert(Lista, I);
  --end loop;
  Print(Lista);
  Insert_Sort(Lista, 22);
  Insert_Sort(Lista, 22);
  Insert_Sort(Lista, 22);
  Insert_Sort(Lista, 1);
  Insert_Sort(Lista, 1);
  Insert_Sort(Lista, 60);
  Insert_Sort(Lista, 60);
  Insert_Sort(Lista, 61);


   Print(Lista);
   --generate(Lista, 4, 100);
   Print(Lista);
   elemtToBeFound := search(Lista, 61);
   if(elemtToBeFound /= null) then
      Put_Line("Znaleziono 61, w elemencie: " & System.Address_Image(elemtToBeFound.all'address) & " " & elemtToBeFound.Data'Image);
   else
      Put_Line("Nie znaleziono elementu");
      end if;
   Put_Line("Usuwanie z listy");
   remove(Lista, 1);
   remove(Lista, 60);
   remove(Lista, 61);
   remove(Lista, 20);
   Print(Lista);
end Lab4Lista;
