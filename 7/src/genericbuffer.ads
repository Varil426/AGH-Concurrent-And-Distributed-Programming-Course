generic
      Size: Natural;
      type Element_Type is (<>);
package genericBuffer is
   
   type TBuf is array(Integer range 1..Size) of Element_Type;
   procedure Insert(ele: Element_Type);
   procedure Take(ele: in out Element_Type);

private
   elements: TBuf;
   writeIndex: Integer := 1;
   readIndex: Integer := 1;

end genericBuffer;
