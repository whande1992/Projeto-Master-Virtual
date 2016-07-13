unit CadastroSerialPhp;

interface

type
TiposPhp = (phpCPF=1, phpRG=2, phpCNPJ=3, phpInscricao=4, phpRazaoSocia=5, phpDataNascimento=6, phpNumero=7);
  TRegistroPhp = record
    Tipo: TiposPhp;
    Conteudo: string;
  end;

  TRegistrosPhp = array of TRegistroPhp;

function CamposParaRegistros(const Campos: string): TRegistrosPhp;
function LinhaParaRegistros(const Linha: string): TRegistrosPhp;

implementation

uses
  SysUtils, Classes, JclStrings;

function ListaParaRegistros(Lista: TStringList): TRegistrosPhp;
var
  I: Integer;
  S: string;
begin
  SetLength(Result, Lista.Count);
  for I := 0 to Lista.Count-1 do begin
      S := Lista[I];
      Result[I].Tipo := TiposPhp(StrToInt(S[1]));

      // TamanhoStr := StrBetween(S, ':', ':');
      Result[I].Conteudo := StrBetween(S, '"', '"');
  end;
end;

function CamposParaRegistros(const Campos: string): TRegistrosPhp;
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

function LinhaParaRegistros(const Linha: string): TRegistrosPhp;
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

  Result := CamposParaRegistros(Campos);
  Assert(StrToIntSafe(NumeroStr) = Length(Result));
end;

end.
