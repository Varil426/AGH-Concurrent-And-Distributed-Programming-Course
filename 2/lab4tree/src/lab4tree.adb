with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Unchecked_Deallocation, Ada.Numerics.Discrete_Random, System.Address_Image;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Lab4Tree is
   type Element is
      record
         Data: Integer;
         Child1 : access Element := null;
         Child2: access Element := null;
         Parent: access Element;
      end record;

   type Elem_Ptr is access all Element;

   type IntArray is array (Positive range <>) of Integer;

   procedure Free is new Ada.Unchecked_Deallocation(Element, Elem_Ptr);

   procedure PrintHelper(Tree: access Element) is
   begin
      if(Tree /= null) then
         Put(Tree.Data'Image & " (");
         PrintHelper(Tree.Child1);
         Put(", ");
         PrintHelper(Tree.Child2);
         Put(")");
   else
      Put("null");
      end if;
      end PrintHelper;

   procedure Print(Tree : access Element) is
   begin
      PrintHelper(Tree);
      Put_Line("");
      end Print;

   function Search(Tree : in Elem_Ptr; Data : Integer) return Elem_Ptr is
   begin
      if(Tree = null) then
         return null;
         end if;
      if(Data = Tree.Data) then
         return Tree;
      elsif (Data < Tree.Data) then
         return Search(Tree.Child1, Data);
      else
         return Search(Tree.Child2, Data);
         end if;
   end Search;

   procedure Insert(Tree : in out Elem_Ptr; Data : Integer; Parent : Elem_Ptr := null) is
   begin
      if(Tree = null) then
         Tree := new Element;
         Tree.Data := Data;
         Tree.Parent := Parent;
      else
         if(Data <= Tree.Data) then
            Insert(Tree.Child1, Data, Tree);
         else
            Insert(Tree.Child2, Data, Tree);
         end if;
      end if;
   end Insert;

   procedure Generate(Tree: in out Elem_Ptr;N :in Integer; M : in Integer) is
      package Los_Liczby is new Ada.Numerics.Discrete_Random(Integer);
      use Los_Liczby;
      Gen: Generator;
   begin
      Reset(Gen);
      for I in 1..N loop
         Insert(Tree, Random(Gen) mod M);
      end loop;
   end generate;

   procedure Remove(Tree: in out Elem_Ptr; Data: Integer) is
      ElementToRemove : Elem_Ptr;
      RighestChild : Elem_Ptr;
      Parent: Elem_Ptr;
   begin
      if(Tree /= null) then
         ElementToRemove := Search(Tree, Data);
         while(ElementToRemove /= null) loop
            if(ElementToRemove.Child2 = null) then
               if(ElementToRemove.Parent = null) then
                  if(ElementToRemove.Child1 = null) then
                     Tree := null;
                  else
                     Tree := ElementToRemove.Child1;
                  end if;
               else
                  Parent := ElementToRemove.Parent;
                  Parent.Child2 := null;
               end if;
               Free(ElementToRemove);
            else
               RighestChild := ElementToRemove.Child2;
               while(RighestChild.Child2 /= null) loop
                  RighestChild := RighestChild.Child2;
               end loop;
               ElementToRemove.Data := RighestChild.Data;
               Parent := RighestChild.Parent;
               Free(RighestChild);
               Parent.Child2 := null;
            end if;
            ElementToRemove := Search(Tree, Data);
         end loop;
      end if;

   end Remove;

   function CountElements(Tree: Elem_Ptr) return Integer is
      Sum : Integer := 1;
   begin
      if (Tree = null) then
         return 0;
      end if;
      Sum := Sum + CountElements(Tree.Child1);
      Sum := Sum + CountElements(Tree.Child2);
      return Sum;
      end CountElements;

   procedure TraverseInorderAndAddToArray(Tree: Elem_Ptr; a : in out IntArray; index : in out Integer) is
   begin
      if(Tree /= null) then
         if(Tree.Child1 /= null) then
            TraverseInorderAndAddToArray(Tree.Child1, a, index);
         end if;
         a(index) := Tree.Data;
         index := index + 1;
         if(Tree.Child2 /= null) then
            TraverseInorderAndAddToArray(Tree.Child2, a, index);
         end if;
      end if;
   end TraverseInorderAndAddToArray;

   procedure BuildBalancedTreeFromSortedArray(a : in out IntArray; Tree : in out Elem_Ptr; startIndex : Integer; endIndex : Integer) is
      middle : Integer := startIndex + (endIndex - startIndex)/2;
   begin
      --Put_Line("middle: " & middle'Image);
      Insert(Tree, a(middle));
      if(middle - startIndex > 0) then
         BuildBalancedTreeFromSortedArray(a, Tree, startIndex, middle-1);
      end if;
      if(endIndex - middle > 0) then
         BuildBalancedTreeFromSortedArray(a, Tree, middle+1, endIndex);
      end if;
   end BuildBalancedTreeFromSortedArray;

   procedure BalanceTree(Tree: in out Elem_Ptr) is
      a : IntArray (1 .. CountElements(Tree));
      index : Integer := 1;
      newTree : Elem_Ptr;
   begin
      TraverseInorderAndAddToArray(Tree, a, index);
      BuildBalancedTreeFromSortedArray(a, newTree, 1, CountElements(Tree));
      Tree := NewTree;
   end BalanceTree;

   procedure TreeToXMLHelper(Tree: in Elem_Ptr; file : File_Type) is
   begin
      Put_Line(file, "<value>" & Tree.Data'Image & "</value>");
      if(Tree.Child1 /= null) then
            Put_Line(file, "<left-subtree>");
            TreeToXMLHelper(Tree.Child1, file);
            Put_Line(file, "</left-subtree>");
         end if;
         if(Tree.Child2 /= null) then
            Put_Line(file, "<right-subtree>");
            TreeToXMLHelper(Tree.Child2, file);
            Put_Line(file, "</right-subtree>");
         end if;
   end TreeToXMLHelper;

   procedure TreeToXML(Tree : in Elem_Ptr) is
      file : File_Type;
   begin
      Create(file, Out_File, "tree.xml");
      Put_Line(file, "<binary-tree>");
      if(Tree /= null) then
         Put_Line(file, "<root>");
         TreeToXMLHelper(Tree, file);
         Put_Line(file, "</root>");
      end if;
      Put_Line(file, "</binary-tree>");
      Close(file);
   end TreeToXML;

   procedure erastostheneSieve(N : Integer) is
      a : IntArray(2 .. N);
      multipliler : Integer;
   begin
      for I in a'Range loop
         a(I) := I;
      end loop;
      for I in a'Range loop
         multipliler := 2;
         while (I*multipliler <= N) loop
            a(I*multipliler) := -1;
            multipliler := multipliler + 1;
         end loop;
      end loop;
      Put_Line("Liczby pierwsze w zasiegu do N to:");
      for I in a'Range loop
         if(a(I) /= -1) then
            Put_Line(I'Image);
            end if;
      end loop;
      end erastostheneSieve;

   Tree : Elem_Ptr := null;
   DataFoundInElement : Elem_Ptr := null;
begin
   Insert(Tree, 22);
   Insert(Tree, 5);
   Insert(Tree, 4);
   Insert(Tree, 6);
   Insert(Tree, 21);
   Insert(Tree, 22);
   Insert(Tree, 22);
   Insert(Tree, 22);
   Print(Tree);
   Generate(Tree, 3, 100);
   Insert(Tree, 68);
   Insert(Tree, 22);
   Print(Tree);
   DataFoundInElement := Search(Tree, 68);
   if(DataFoundInElement /= null) then

      Put_Line("Znaleziono obiekcie: " & System.Address_Image(DataFoundInElement.all'address) & " " & DataFoundInElement.Data'Image);
   else
      Put_Line("Nie znaleziono");
      end if;
   Remove(Tree, 22);
   Print(Tree);
   Put_Line("Ilosc elementow w drzewie to: " & CountElements(Tree)'Image);
   BalanceTree(Tree);
   print(Tree);
   TreeToXML(Tree);
   erastostheneSieve(50);
   null;
end Lab4Tree;
