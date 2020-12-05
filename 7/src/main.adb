with Ada.Text_IO, genericBuffer;
use Ada.Text_IO;

procedure Main is

   type IntegerList is array(Integer range <>) of Integer;

      protected type MyBuffer(N: Integer) is
         procedure Insert(val: in Integer);
         procedure Take(val: in out Integer);
      private
         values: IntegerList(1..N);
         writeIndex: Integer := 1;
         readIndex: Integer := 1;
         size: Integer := N;
      end MyBuffer;

      protected body MyBuffer is

         procedure Insert(val: in Integer) is
         begin
            values(writeIndex) := val;
            writeIndex := writeIndex + 1;
            if(writeIndex > size) then
               writeIndex := 1;
            end if;
         end Insert;

         procedure Take(val: in out Integer) is
         begin
            val := values(readIndex);
            values(readIndex) := 0;
            readIndex := readIndex + 1;
            if(readIndex > size) then
               readIndex := 1;
            end if;
         end Take;

   end MyBuffer;

   type MyBufferPtr is access MyBuffer;

   task type Consumer is
      entry Start(Buffer: MyBufferPtr; N: Integer);
      entry Stop;
   end Consumer;

   task body Consumer is
      val: Integer;
   begin
      loop
         select
            accept Start(Buffer: MyBufferPtr; N: Integer) do
               for I in 1..N loop
                  Buffer.Take(val);
                  Put_Line("Konsumer wartosc: " & val'Image);
               end loop;
            end Start;
           or
             accept Stop;
            exit;
         end select;
      end loop;

   end Consumer;

   task type Producer is
      entry Start(Buffer: MyBufferPtr; N: Integer);
      entry Stop;
   end Producer;

   task body Producer is
   begin
      loop
         select
            accept Start(Buffer: MyBufferPtr; N: Integer) do
               for I in 1..N loop
                  Buffer.Insert(I);
                  Put_Line("Producent: " & I'Image);
               end loop;
            end Start;
           or
             accept Stop;
            exit;
         end select;
      end loop;
   end Producer;

   type ProducerPtr is access Producer;
   type ConsumerPtr is access Consumer;

   N: Integer := 10;
   Buffer: MyBufferPtr := new MyBuffer(N);
   prod: ProducerPtr;
   cons: ConsumerPtr;

-- Zadanie 3

   procedure useGeneric is
      package gen is new genericBuffer (Size => 10, Element_Type => Integer);
      value : Integer;
   begin
      Put_Line("Generic Test");
      gen.Insert(12);
      gen.Insert(23);
      gen.Take(value);
      Put_Line("Wartosc z buffora: " & value'Image);
      gen.Take(value);
      Put_Line("Wartosc z buffora: " & value'Image);
   end useGeneric;

   -- Zadanie 4
   task type countingSemaphoreTask(N : Integer := 1) is
      entry Take(Decision: in out Boolean);
      entry Free;
      entry Stop;
   end countingSemaphoreTask;

   task body countingSemaphoreTask is
      Resource: Integer := N;
   begin
      loop
         select
            accept Take(Decision: in out Boolean) do
               if(Resource > 0) then
                  Resource := Resource - 1;
                  Decision := True;
               else
                  Decision := False;
               end if;
            end Take;
         or
            accept Free do
               Resource := Resource + 1;
            end Free;
         or
              accept Stop; exit;
         end select;
      end loop;
   end countingSemaphoreTask;

   type countingSemaphoreTaskPtr is access countingSemaphoreTask;

   protected type countingSemaphoreProtected(N : Integer) is
      entry Take;
      procedure Free;
   private
      Resource: Integer := N;
   end countingSemaphoreProtected;

   protected body countingSemaphoreProtected is

      entry Take when Resource > 0 is
      begin
         Resource := Resource - 1;
      end Take;

      procedure Free is
      begin
         Resource := Resource + 1;
      end Free;

   end countingSemaphoreProtected;

   countingSemaphoreTaskPtrVar : countingSemaphoreTaskPtr;

   semaphoreDecision1: Boolean := False;
   semaphoreDecision2: Boolean := False;

   countingSemaphoreProtectedRef : countingSemaphoreProtected(1);

   --Zadanie 5
   type countingSemaphoreProtectedPtr is access countingSemaphoreProtected;
   countingSemaphoreVar : countingSemaphoreProtectedPtr;

   sharedResource : Integer := 0;

   task type T1(Number : Integer; semaphore : countingSemaphoreProtectedPtr);

   task body T1 is
   begin
               delay 1.0;
               semaphore.Take;
               Put_Line("T" & Number'Image & ": " & sharedResource'Image);
               sharedResource := 1 * Number;
               semaphore.Free;
               delay 0.1;
               semaphore.Take;
               Put_Line("T" & Number'Image & ": " & sharedResource'Image);
               sharedResource := 2 * Number;
               semaphore.Free;
               delay 0.1;
               semaphore.Take;
                Put_Line("T" & Number'Image & ": " & sharedResource'Image);
               sharedResource := 3 * Number;
               semaphore.Free;
               delay 0.1;
   end T1;

   type T1Ptr is access T1;
   TVar1 : T1Ptr;
   TVar2 : T1Ptr;


begin
   -- Zadanie 1 i 2
   prod := new Producer;
   cons := new Consumer;
   prod.Start(Buffer, N);
   cons.Start(Buffer, N);
   prod.Stop;
   cons.Stop;
   -- Zadanie 3
   useGeneric;
   -- Zadanie 4 - Testy dzialania
   countingSemaphoreTaskPtrVar := new countingSemaphoreTask(1);
   while(not semaphoreDecision1) loop
      countingSemaphoreTaskPtrVar.Take(semaphoreDecision1);
   end loop;
   --while(not semaphoreDecision2) loop
      --countingSemaphoreTaskPtrVar.Take(semaphoreDecision2);
   --end loop;
   Put_Line("SemaphoreTask - Works");
   countingSemaphoreTaskPtrVar.Stop;
   semaphoreDecision1 := False;
   semaphoreDecision2 := False;

   countingSemaphoreProtectedRef.Take;
   --countingSemaphoreProtectedRef.Take;

   Put_Line("SemaphoreProtected - Works");
   -- Zadanie 5
   countingSemaphoreVar := new countingSemaphoreProtected(1);
   TVar1 := new T1(1,countingSemaphoreVar);
   TVar2 := new T1(2,countingSemaphoreVar);

end Main;
