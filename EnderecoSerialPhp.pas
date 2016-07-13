unit EnderecoSerialPhp;

interface

type
  TiposPhp = (phpNumero=7);
  TRegistroEnderecoPhp = record
    Tipo: TiposPhp;
    Conteudo_endereco: string;
  end;

  TRegistros_enderecoPhp = array of TRegistroEnderecoPhp;

function CamposRegistrosEndereco(const Campos: string): TRegistros_enderecoPhp;
function LinhaRegistrosEndereco(const Linha: string): TRegistros_enderecoPhp;

implementation

uses
  SysUtils, Classes, JclStrings;

function ListaParaRegistros(Lista: TStringList): TRegistros_enderecoPhp;
var
  I: Integer;
  S: string;
begin
  SetLength(Result, Lista.Count);
  for I := 0 to Lista.Count-1 do begin
      S := Lista[I];
      Result[I].Tipo := TiposPhp(StrToInt(S[1]));

      // TamanhoStr := StrBetween(S, ':', ':');
      Result[I].Conteudo_endereco := StrBetween(S, '"', '"');
  end;
end;

function CamposRegistrosEndereco(const Campos: string): TRegistros_enderecoPhp;
var
  Lista: TStringList;
begin
  Lista := TStringList.Create;
  try
    StrToStrings(Campos, 'i:', Lista, False);
    Result := ListaParaRegistros(Lista);
  finally
    Lista.Free;
  end;
end;

function LinhaRegistrosEndereco(const Linha: string): TRegistros_enderecoPhp;
var
  A, Campos, Letra, NumeroStr: string;
begin
  // Separa o conteúdo de a:N e os campos {}
  A := StrBefore(':{', Linha);
  Campos := StrAfter(':{', Linha);
  Delete(Campos, Length(Campos), 1);

  // Obtém o número de registros em a:N
  Letra := StrBefore(':', A);
  NumeroStr := StrAfter(':', A);

  Result := CamposRegistrosEndereco(Campos);
  Assert(StrToIntSafe(NumeroStr) = Length(Result));
end;

end.
