with Ada.Text_IO, Ada.Streams, Ada.Text_IO.Text_Streams;
use Ada.Text_IO, Ada.Streams, Ada.Text_IO.Text_Streams;

procedure Main is

   -- Zadanie na 4.0

   type matrix is array(Integer range<>, Integer range<>) of Float;

   procedure Pisz(mat: matrix) is
      File: File_Type;
      Name: String := "tmp.txt";
      MyStream: Stream_Access;
   begin
      Create(File, Out_File, Name);
      MyStream := Stream(File);
      matrix'Output(MyStream, mat);
      Close(File);
   end Pisz;

   procedure Czytaj(mat: in out matrix) is
      File: File_Type;
      Name: String := "tmp.txt";
      MyStream: Stream_Access;
   begin
      Open(File, In_File, Name);
      MyStream := Stream(File);
      mat := matrix'Input(MyStream);
      Close(File);
   end Czytaj;

   procedure displayMatrix(mat: matrix) is
   begin
      Put("[");
      for row in 1..mat'Length(1) loop
         Put("[");
         for col in 1..mat'Length(2) loop
            if(col = mat'Length(2)) then
               Put(mat(row, col)'Image);
            else
               Put(mat(row, col)'Image & ", ");
            end if;
         end loop;
         if(row = mat'Length(1)) then
            Put("]");
         else
            Put_Line("],");
         end if;
      end loop;
      Put_Line("]");
   end displayMatrix;

   inputMatrix: matrix := ((1.0, 2.0, 3.0), (4.0, 5.0, 6.0));
   outputMatrix: matrix(1..inputMatrix'Length(1),1..inputMatrix'Length(2));

   -- Zadanie na 5.0

   function matrixAdd(mat: matrix; number: Float) return matrix is
      resultMatrix: matrix(1..mat'Length(1), 1..mat'Length(2));
   begin
      for row in 1..mat'Length(1) loop
         for col in 1..mat'Length(2) loop
            resultMatrix(row, col) := mat(row, col) + number;
         end loop;
      end loop;
      return resultMatrix;
   end matrixAdd;

   function matrixSubtract(mat: matrix; number: Float) return matrix is
   begin
      return matrixAdd(mat, -1.0*number);
   end matrixSubtract;

   function matrixMultiply(mat: matrix; number: Float) return matrix is
      resultMatrix: matrix(1..mat'Length(1), 1..mat'Length(2));
   begin
      for row in 1..mat'Length(1) loop
         for col in 1..mat'Length(2) loop
            resultMatrix(row, col) := mat(row, col) * number;
         end loop;
      end loop;
      return resultMatrix;
   end matrixMultiply;

   function matrixAdd(mat1: matrix; mat2: matrix) return matrix is
      resultMatrix: matrix(1..mat1'Length(1), 1..mat1'Length(2));
   begin
      if(mat1'Length(1) /= mat2'Length(1) or mat1'Length(2) /= mat2'Length(2)) then
         Put_Line("Wymiary macierzy sie nie zgadzaja");
         return resultMatrix;
      end if;
      for row in 1..resultMatrix'Length(1) loop
         for col in 1..resultMatrix'Length(2) loop
            resultMatrix(row, col) := mat1(row, col) + mat2(row, col);
         end loop;
      end loop;
      return resultMatrix;
   end matrixAdd;

   function matrixSubtract(mat1: matrix; mat2: matrix) return matrix is
   begin
      return matrixAdd(mat1, matrixMultiply(mat2, -1.0));
   end matrixSubtract;

   workMatrix: matrix(1..inputMatrix'Length(1),1..inputMatrix'Length(2));

begin
   -- Zadanie na 4.0
   Pisz(inputMatrix);
   Czytaj(outputMatrix);
   displayMatrix(outputMatrix);

   -- Zadanie na 5.0
   Pisz(inputMatrix);
   Czytaj(workMatrix);

   Put_Line("Odjecie skalaru");
   workMatrix := matrixSubtract(workMatrix, 5.2);
   Pisz(workMatrix);
   Czytaj(outputMatrix);
   displayMatrix(outputMatrix);

   Put_Line("Mnozenie przez skalar");
   workMatrix := matrixMultiply(workMatrix, 0.0);
   Pisz(workMatrix);
   Czytaj(outputMatrix);
   displayMatrix(outputMatrix);

   Put_Line("Dodanie skalaru");
   workMatrix := matrixAdd(workMatrix, 2.0);
   Pisz(workMatrix);
   Czytaj(outputMatrix);
   displayMatrix(outputMatrix);

   Put_Line("Sumowanie macierzy");
   workMatrix := matrixAdd(workMatrix, workMatrix);
   Pisz(workMatrix);
   Czytaj(outputMatrix);
   displayMatrix(outputMatrix);

   Put_Line("Odejmowanie macierzy");
   workMatrix := matrixSubtract(workMatrix, workMatrix);
   Pisz(workMatrix);
   Czytaj(outputMatrix);
   displayMatrix(outputMatrix);

end Main;
