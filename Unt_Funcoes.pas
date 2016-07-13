unit Unt_Funcoes;

interface
function EscreveLOG(Desc: string; Query:string):string;
function EventosLOG(Desc: string; Query:string):string;
function RemoveZeros(S: string): string;
Function tirapontos(texto : String) : String;
function TrocaVirgPPto(Valor: string): String;
function erros_log(produto:string; linha:integer; descricao,grupo, secao,dados_analise, outros : string):string;
function TrocaCaracterEspecial(aTexto : string; aLimExt,espaco : boolean) : string;
function Tamanho_Maximo_string(texto_original:string;tam_max:integer):string;

implementation
uses SysUtils, Unt_Mysql;

function EscreveLOG(Desc: string; Query:string):string;
Var
 NomeDoLog: string;
Arquivo: TextFile;

BEGIN

 {Gerar log}
NomeDoLog := '.\log.log';
AssignFile(Arquivo, NomeDoLog);
if FileExists(NomeDoLog) then
Append(Arquivo) { se existir, apenas adiciona linhas }
else
ReWrite(Arquivo); { cria um novo se não existir }
try
WriteLn(arquivo, DateToStr(Date)+'-'+TimeToStr(time)+' - ' + Desc );
WriteLn(arquivo, DateToStr(Date)+'-'+TimeToStr(time)+' - ' + Query );
finally
CloseFile(arquivo) ;

end;
END;

 {Escreve todos os eventos}
function EventosLOG(Desc: string; Query:string):string;
Var
 NomeDoLog: string;
Arquivo: TextFile;

BEGIN

 {Gerar log}
NomeDoLog := '.\Eventos.log';
AssignFile(Arquivo, NomeDoLog);
if FileExists(NomeDoLog) then
Append(Arquivo) { se existir, apenas adiciona linhas }
else
ReWrite(Arquivo); { cria um novo se não existir }
try
WriteLn(arquivo, DateToStr(Date)+'-'+TimeToStr(time)+' - ' + Desc );
WriteLn(arquivo, DateToStr(Date)+'-'+TimeToStr(time)+' - ' + Query );
finally
CloseFile(arquivo) ;

end;
END;



//Remove zeros a esquerda e espaço em branco na direita e
//esquerda
FUNCTION RemoveZeros(S: string): string;
var
I, J : Integer;
begin
I := Length(S);
while (I > 0) and (S[I] <= ' ') do
      begin
      Dec(I);
      end;
J := 1;
while (J < I) and ((S[J] <= ' ') or (S[J] = '0')) do
      begin
      Inc(J);
      end;
Result := Copy(S, J, (I-J)+1);
end;



{Função para remover pontos e traços}
Function tirapontos(texto : String) : String;
Begin

  While pos('-', Texto) <> 0 Do
    delete(Texto,pos('-', Texto),1);

  While pos('.', Texto) <> 0 Do
    delete(Texto,pos('.', Texto),1);

  While pos('/', Texto) <> 0 Do
    delete(Texto,pos('/', Texto),1);

  While pos(',', Texto) <> 0 Do
    delete(Texto,pos(',', Texto),1);

  Result := Texto;
End;






{Troca virgula por ponto}

function TrocaVirgPPto(Valor: string): String;
   var i:integer;
begin
     if Valor <> '' then begin
        for i := 0 to Length(Valor) do begin
            if Valor[i]='.' then begin
                Valor[i]:=',';
            end
            else if Valor[i] = ',' then begin
                Valor[i]:='.';
            end;
        end;
     end;
     Result := valor;
end ;



{cadastra os logs de erros na tabela de log.}
function erros_log(produto:string; linha:integer; descricao,grupo, secao,dados_analise, outros : string):string;
Begin
Data_Mysql.oc_ss_erros_log.Close;
Data_Mysql.oc_ss_erros_log.SQL.Clear;
Data_Mysql.oc_ss_erros_log.SQL.Add('INSERT INTO oc_ss_erros_log (produto, linha, descricao, grupo, secao, dados_analise, outros, data) ' +
                                   ' VALUES (:produto, :linha, :descricao, :grupo, :secao, :dados_analise, :outros, :data) ');
Data_Mysql.oc_ss_erros_log.ParamByName('produto').AsInteger:= strtoint(produto) ;
Data_Mysql.oc_ss_erros_log.ParamByName('linha').AsInteger:= linha  ;
Data_Mysql.oc_ss_erros_log.ParamByName('descricao').AsString:= descricao ;
Data_Mysql.oc_ss_erros_log.ParamByName('grupo').AsString:= grupo ;
Data_Mysql.oc_ss_erros_log.ParamByName('secao').AsString:= secao ;
Data_Mysql.oc_ss_erros_log.ParamByName('dados_analise').AsString:= dados_analise ;
Data_Mysql.oc_ss_erros_log.ParamByName('outros').AsString:= outros ;
Data_Mysql.oc_ss_erros_log.ParamByName('data').AsDateTime :=now  ;
Data_Mysql.oc_ss_erros_log.ExecSQL;
End;



//Função para substituir caracteres especiais.

function TrocaCaracterEspecial(aTexto : string; aLimExt,espaco : boolean ) : string;
const
  //Lista de caracteres especiais
  xCarEsp: array[1..38] of String = ('á', 'à', 'ã', 'â', 'ä','Á', 'À', 'Ã', 'Â', 'Ä',
                                     'é', 'è','É', 'È','í', 'ì','Í', 'Ì',
                                     'ó', 'ò', 'ö','õ', 'ô','Ó', 'Ò', 'Ö', 'Õ', 'Ô',
                                     'ú', 'ù', 'ü','Ú','Ù', 'Ü','ç','Ç','ñ','Ñ');
  //Lista de caracteres para troca
  xCarTro: array[1..38] of String = ('a', 'a', 'a', 'a', 'a','A', 'A', 'A', 'A', 'A',
                                     'e', 'e','E', 'E','i', 'i','I', 'I',
                                     'o', 'o', 'o','o', 'o','O', 'O', 'O', 'O', 'O',
                                     'u', 'u', 'u','u','u', 'u','c','C','n', 'N');
  //Lista de Caracteres Extras
  xCarExt: array[1..52] of string = ('<','>','!','@','#','$','%','¨','&','*',
                                     '(',')','_','+','=','{','}','[',']','?',
                                     ';',':','.','-',',','|','*','"','~','^','´','`',
                                     '¨','æ','Æ','ø','£','Ø','ƒ','ª','º','¿',
                                     '®','½','¼','ß','µ','þ','ý','Ý','\','/');

    //Lista de Caracteres Extras
  xespaco: array[1..1] of string = (' ');

var
  xTexto : string;
  i : Integer;
begin
   xTexto := aTexto;
   for i:=1 to 38 do
     xTexto := StringReplace(xTexto, xCarEsp[i], xCarTro[i], [rfreplaceall]);
   //De acordo com o parâmetro aLimExt, elimina caracteres extras.
   if (aLimExt) then
     for i:=1 to 52 do
       xTexto := StringReplace(xTexto, xCarExt[i], '', [rfreplaceall]);
   // Elimina espaços
   if (espaco) then
     for i:=1 to 1 do
       xTexto := StringReplace(xTexto, xespaco[i], '', [rfreplaceall]);

   Result := xTexto;
end;



{Limita o tamanho dos caracteres}
function Tamanho_Maximo_string(texto_original:string;tam_max:integer):string;
var
  i,n:integer; // variavel contadora
  texto_final:string; // variavel auxiliar para retorno da string
begin

n:= length(texto_original);
if n > tam_max  then
  begin

    texto_final:=''; // inicializa variavel
    for I:=1 to tam_max do
    begin
    texto_final:=texto_final+texto_original[i]; // armazena caracteres até o num. X de caracteres
    end;
    result:=( Utf8Encode(texto_final)); // retorna variavel do tamanho desejado

    end else
    result:= texto_original;

end;






end.
