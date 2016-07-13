unit Unt_Funcoes_ini;

interface
function LoadComponenteConfig(Func:boolean):boolean;
function ReadIniConfig(Func:boolean):boolean;




  var
  Applicationname,LoginTimeout:string;
   {Conexão Mysql}
   MysqlDB, MysqlHost, MysqlPorta, MysqlUser, MysqlPass, MysqlPrefixo, MysqlDriver:String;

   {Conexão Postgres}
   PgSqlDB, PgsqlHost, PgsqlPorta, PgsqUser,PgsqlPass, PgsqlDriver:String;

   {Conexão FTP}
   FtpHost, FtpPorta, FtpUser, FtpPass, FtpDiretorio:String;

   {Configurações do Master Virtual}
   cfgEmpresa,cfgCodIdioma,cfgTipoAtualizacao,cfgUltProduto,cfgExportaImg,cfgApenasInf,cfgFormPgto, cfgObs ,
   cfgPedidoStatus,cfgCliLimFinanceiro,cfgUpCliente,cfgAgendaProdutos ,cfgAgendaDuplicatas ,cfgAgendaPedidos,
   cfgStatusPosImportado,cfgMsgStatus:string;
   cfgEnviarImagem, cfgEnvioRetroativo, cfgPromocaoProduto:boolean;
   cfgDataEnvioRetroativo:tDateTime;


implementation

uses System.SysUtils,IniFiles;


{Carrega as configurações do arquivo INI em variaveis}
function ReadIniConfig(Func:boolean):boolean;
var
ArquivoINI:TIniFile;

{Senhas com criptografia}
MysqlPassCrip, FtpPassCrip:string;

// Variaveis para Encriptar e Desencriptar dados  'c' e 's'
s: string[255];
c: array[0..255] of Byte absolute s ;
i: integer;


begin
Applicationname:='Master Virtual';
LoginTimeout:='5000';


ArquivoINI  := TIniFile.Create('.\Arquivo.ini');
  try

  {Configurações do MYSql}
  MysqlPrefixo  := ArquivoINI.ReadString('Mysql','Prefixo' ,'') ;
  MysqlDB       := ArquivoINI.ReadString('Mysql','Banco'   ,'') ;
  MysqlHost     := ArquivoINI.ReadString('Mysql','Host'    ,'') ;
  MysqlPorta    := ArquivoINI.ReadString('Mysql','Porta'   ,'') ;
  MysqlUser     := ArquivoINI.ReadString('Mysql','Usuario' ,'') ;
  MysqlPassCrip := ArquivoINI.ReadString('Mysql','Senha'   ,'') ;
  MysqlDriver   := ExtractFilePath(ParamStr(0))+'lib\Mysql\'    ;

  // Tira criptografia das senhas  mysql
  S := MysqlPassCrip ;
     For i:=1 to Length(s) do
         s[i] := Ansichar(23 Xor ord(c[i]));
     MysqlPass:=s;


  {Configurações  do Postgres}
  PgsqlDB     := ArquivoINI.ReadString('Postgres','Banco' ,'') ;
  PgsqlHost   := ArquivoINI.ReadString('Postgres','Host'  ,'') ;
  PgsqlPorta  := ArquivoINI.ReadString('Postgres','porta' ,'') ;
  PgsqUser    := 'ssecomm';
  PgsqlPass   := 'ecomm@2016';
  PgsqlDriver := ExtractFilePath(ParamStr(0))+'lib\PGSql\'     ;

  {Configurações do FTP}
  FtpHost     := ArquivoINI.ReadString('FTP','Host'      ,'') ;
  FtpPorta    := ArquivoINI.ReadString('FTP','Porta'     ,'') ;
  FtpUser     := ArquivoINI.ReadString('FTP','Usuario'   ,'') ;
  FtpPassCrip := ArquivoINI.ReadString('FTP','Senha'     ,'') ;
  FtpDiretorio:= ArquivoINI.ReadString('FTP','Diretorio' ,'') ;

  // Tira criptografia das senhas FTP
   S := FtpPassCrip ;
      For i:=1 to Length(s) do
        s[i] := Ansichar(23 Xor ord(c[i]));
      FtpPass:=s;



  {Configurações do Master Virtual}
  cfgEmpresa      := ArquivoINI.ReadString('Config','Empresa','');
  cfgEnviarImagem := ArquivoINI.ReadBool('Config','EnviarImagem',true);
  cfgCodIdioma    := ArquivoINI.ReadString('Config','CodIdioma','');
  cfgTipoAtualizacao := ArquivoINI.ReadString('Config','tipo_Atualizacao','');
  cfgUltProduto   := ArquivoINI.ReadString('Config', 'ATIVA_ULT_PRODUTO' , 'S' );
  cfgExportaImg   := ArquivoINI.ReadString('Config'  , 'ApenasProdutoComImg'  , 'S' );
  cfgApenasInf    := ArquivoINI.ReadString('Config'  , 'Informacoes', '' );
  cfgEnvioRetroativo := ArquivoINI.ReadBool('Config' , 'EnvioRetroativo', false);
  cfgDataEnvioRetroativo := ArquivoINI.ReadDate('Config' , 'DataEnvioRetroativo', now);
  cfgPromocaoProduto    :=ArquivoINI.ReadBool('CONFIG', 'Promocao' , true );


  cfgFormPgto  :=   ArquivoINI.ReadString('Pedido'  , 'Forma_pgto'    ,'' ) ;
  cfgObs       :=   ArquivoINI.ReadString('Pedido'  , 'OBS'           ,'' ) ;
  cfgPedidoStatus :=ArquivoINI.ReadString('Pedido'  , 'Status_Pedido' ,'' ) ;
  cfgStatusPosImportado:=ArquivoINI.ReadString('Pedido','Status_PedidoRetorno','');
  cfgMsgStatus:=  ArquivoINI.ReadString('pedido', 'MsgStatus', '');

  cfgCliLimFinanceiro := ArquivoINI.ReadString('Cliente' , 'Limite'    , '0') ;
  cfgUpCliente        := ArquivoINI.ReadString('Cliente' , 'Atualiza'  , '' ) ;

  cfgAgendaProdutos   :=ArquivoINI.ReadString('Agenda', 'Produtos' , '');
  cfgAgendaDuplicatas :=ArquivoINI.ReadString('Agenda', 'Duplicatas','');
  cfgAgendaPedidos    :=ArquivoINI.ReadString('Agenda', 'Pedidos' , '');

  finally
    ArquivoINI.Free;
  end;


end;


function LoadComponenteConfig(Func:boolean):boolean;
Begin


End;


end.
