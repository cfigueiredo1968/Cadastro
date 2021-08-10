unit unFuncoes;

interface


   function converter_utf8_ansi(const Source: string):string;
   function SoNumero(fField : String): String;
   function ValidarEMail(aStr: string): Boolean;
   function ValidarCPF(pCPF: string): boolean;

implementation

uses SysUtils,Math;

function converter_utf8_ansi(const Source: string): string;
var
   Iterator, SourceLength, FChar, NChar: Integer;
begin
   Result := '';
   Iterator := 0;
   SourceLength := Length(Source);
   while Iterator < SourceLength do
   begin
      Inc(Iterator);
      FChar := Ord(Source[Iterator]);
      if FChar >= $80 then
      begin
         Inc(Iterator);
         if Iterator > SourceLength then break;
         FChar := FChar and $3F;
         if (FChar and $20) <> 0 then
         begin
            FChar := FChar and $1F;
            NChar := Ord(Source[Iterator]);
            if (NChar and $C0) <> $80 then break;
            FChar := (FChar shl 6) or (NChar and $3F);
            Inc(Iterator);
            if Iterator > SourceLength then break;
         end;
         NChar := Ord(Source[Iterator]);
         if (NChar and $C0) <> $80 then break;
         Result := Result + WideChar((FChar shl 6) or (NChar and $3F));
      end
      else
         Result := Result + WideChar(FChar);
   end;
end;

 function SoNumero(fField : String): String;
var
  I : Byte;
begin
   Result := '';
   for I := 1 To Length(fField) do
       if fField [I] In ['0'..'9'] Then
            Result := Result + fField [I];
end;

function ValidarEMail(aStr: string): Boolean;
begin
 aStr := Trim(UpperCase(aStr));
 if Pos('@', aStr) > 1 then
 begin
   Delete(aStr, 1, pos('@', aStr));
   Result := (Length(aStr) > 0) and (Pos('.', aStr) > 2);
 end
 else
   Result := False;
end;

function ValidarCPF(pCPF: string): boolean;
var
  v: array [0 .. 1] of Word;
  cpf: array [0 .. 10] of Byte;
  I: Byte;
begin
  Result := False;

  { Verificando se tem 11 caracteres }
  if Length(pCPF) <> 11 then
  begin
    Exit;
  end;

  { Conferindo se todos dígitos são iguais }
  if pCPF = StringOfChar('0', 11) then
    Exit;
 
  if pCPF = StringOfChar('1', 11) then
    Exit;
 
  if pCPF = StringOfChar('2', 11) then
    Exit;
 
  if pCPF = StringOfChar('3', 11) then
    Exit;
 
  if pCPF = StringOfChar('4', 11) then
    Exit;
 
  if pCPF = StringOfChar('5', 11) then
    Exit;
 
  if pCPF = StringOfChar('6', 11) then
    Exit;
 
  if pCPF = StringOfChar('7', 11) then
    Exit;
 
  if pCPF = StringOfChar('8', 11) then
    Exit;
 
  if pCPF = StringOfChar('9', 11) then
    Exit;
 
  try
    for I := 1 to 11 do
      cpf[I - 1] := StrToInt(pCPF[I]);
    // Nota: Calcula o primeiro dígito de verificação.
    v[0] := 10 * cpf[0] + 9 * cpf[1] + 8 * cpf[2];
    v[0] := v[0] + 7 * cpf[3] + 6 * cpf[4] + 5 * cpf[5];
    v[0] := v[0] + 4 * cpf[6] + 3 * cpf[7] + 2 * cpf[8];
    v[0] := 11 - v[0] mod 11;
    v[0] := IfThen(v[0] >= 10, 0, v[0]);
    // Nota: Calcula o segundo dígito de verificação.
    v[1] := 11 * cpf[0] + 10 * cpf[1] + 9 * cpf[2];
    v[1] := v[1] + 8 * cpf[3] + 7 * cpf[4] + 6 * cpf[5];
    v[1] := v[1] + 5 * cpf[6] + 4 * cpf[7] + 3 * cpf[8];
    v[1] := v[1] + 2 * v[0];
    v[1] := 11 - v[1] mod 11;
    v[1] := IfThen(v[1] >= 10, 0, v[1]);
    // Nota: Verdadeiro se os dígitos de verificação são os esperados.
    Result := ((v[0] = cpf[9]) and (v[1] = cpf[10]));
  except
    on E: Exception do
      Result := False;
  end;
end;
end.
