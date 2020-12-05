package body genericBuffer is

   procedure Insert(ele: Element_Type) is 
   begin
      elements(writeIndex) := ele;
      writeIndex := writeIndex + 1;
      if(writeIndex > size) then
         writeIndex := 1;
      end if;
   end Insert;
   
   procedure Take(ele: in out Element_Type) is
   begin
      ele := elements(readIndex);
      readIndex := readIndex + 1;
      if(readIndex > size) then
          readIndex := 1;
      end if;
   end Take; 

end genericBuffer;
