unit Unt_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,DB,JPEG,
  IdBaseComponent, IdCoder, IdCoder3to4, IdCoderMIME, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdFTP,IniFiles,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage,WinInet,  Vcl.ComCtrls,
  Vcl.AppEvnts, Vcl.WinXCtrls, Vcl.Buttons, frxClass, frxDBSet, frxExportPDF,
  IdMessageClient, IdSMTPBase, IdSMTP,StrUtils,
  IdSSLOpenSSL, IdMessage, IdText, IdAttachmentFile, FireDAC.Phys.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Intf, FireDAC.Comp.Client, JvGIF,
  JvExControls, JvAnimatedImage, JvGIFCtrl;

type
  TFrm_Principal = class(TForm)
    IdDecoderMIME1: TIdDecoderMIME;
    Timer_Atualiza: TTimer;
    Timer_painel: TTimer;
    TrayIcon1: TTrayIcon;
    ApplicationEvents1: TApplicationEvents;
    SV_principal: TSplitView;
    GroupBox3: TGroupBox;
    ImgStatusMysql: TImage;
    Label_ecommerce: TLabel;
    ImgStatusPg: TImage;
    lbl_SSPlus: TLabel;
    ImgStatusNet: TImage;
    lbl_internet: TLabel;
    btn_painel: TToggleSwitch;
    GroupBox4: TGroupBox;
    lbl_configuracoes: TLabel;
    IMG_Config: TImage;
    Group_Produtos: TGroupBox;
    Plbl_Produtos_total: TLabel;
    Slbl_Produtos_enviados: TLabel;
    Group_Pedidos: TGroupBox;
    StatusBar1: TStatusBar;
    BTN_Importa_pedidos: TButton;
    lbl_clientes: TLabel;
    lbl_pedido: TLabel;
    lbl_pedidos_importados: TLabel;
    lbl_total_pedidos: TLabel;
    lbl_Produto_1: TLabel;
    Btn_Rel_Pedidos_exportados: TButton;
    DST_Pedidos_enviados: TfrxDBDataset;
    Pedidos_enviados: TfrxReport;
    PDFexport: TfrxPDFExport;
    Email: TButton;
    IdSMTP: TIdSMTP;
    IdFTP1: TIdFTP;
    Img_UltimoProduto: TImage;
    GroupBox1: TGroupBox;
    BTN_Duplicatas: TButton;
    indDuplicatas: TActivityIndicator;
    lblDuplicatas_CliAll: TLabel;
    lblDuplicatas_CliDpl: TLabel;
    lblDuplicatas_1: TLabel;
    Plbl_pencontrados: TLabel;
    BTN_envia_produtos: TButton;
    Slbl_numero: TLabel;
    indProdutos: TActivityIndicator;
    Label1: TLabel;
    lbl_Produto_2: TLabel;
    lbl_mostra_ped: TLabel;
    indPedidos: TActivityIndicator;
    lbl_mostra_ped_enviados: TLabel;
    procedure Enviardados1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure Timer_AtualizaTimer(Sender: TObject);
    procedure Timer_painelTimer(Sender: TObject);
    procedure ImgStatusMysqlClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure btn_painelClick(Sender: TObject);
    procedure BTN_Importa_pedidosClick(Sender: TObject);
    procedure Btn_Rel_Pedidos_exportadosClick(Sender: TObject);
    procedure EmailClick(Sender: TObject);
    procedure BTN_DuplicatasClick(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure BTN_envia_produtosClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Img_UltimoProdutoDblClick(Sender: TObject);


  private
    { Private declarations }
  public
  var







  end;

var
  Frm_Principal: TFrm_Principal;
   buff: array [0 .. 6553600] of longint;
   var_horafinal,horaAtual:ttime;
   ftp_usuario, ftp_host,ftp_porta,  ftp_senha:string;
   Tpg:Tthread;
   {Variavel que informa sobre abertura do aplicativo, ela é destruida após a conexão com o banco}
   abertura:boolean;
   StatusThreadProdutos:boolean;

// Variaveis para Encriptar e Desencriptar dados  'c' e 's'
s: string[255];
c: array[0..255] of Byte absolute s ;


implementation


{$R *.dfm}

uses Unt_Exporta_Registros, Unt_Postgres, Unt_Mysql, Unt_Thread_comunicador,
  Unt_Configuracoes, Unt_Thread_pedidos,
  Unt_Thread_Dupluicatas, Unt_Funcoes_ini;


procedure TFrm_Principal.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
OutputDebugString(PChar(E.Message));
end;

procedure TFrm_Principal.ApplicationEvents1Minimize(Sender: TObject);
begin       // Escondendo a aplicação ao minimizar
self.Hide();
Self.WindowState := wsMinimized;
//self.WindowState:= wsNormal;
TrayIcon1.Visible := True;
TrayIcon1.Animate := True;
TrayIcon1.ShowBalloonHint;

//Leia mais em: Utilizando o componente TTrayIcon no Delphi
//www.devmedia.com.br/utilizando-o-componente-ttrayicon-no-delphi/25088#ixzz3uTutYG4I
end;

procedure TFrm_Principal.Btn_Rel_Pedidos_exportadosClick(Sender: TObject);
begin
Pedidos_enviados.ShowReport();
end;



procedure TFrm_Principal.Button1Click(Sender: TObject);

begin
tpg.Free;
end;

procedure TFrm_Principal.BTN_DuplicatasClick(Sender: TObject);
Var
TDuplicatas:thread_duplicatas;
begin
//Se os bancos estão ativos, iniciar a transferencia
              TDuplicatas:=  thread_duplicatas.Create(true);
              TDuplicatas.FreeOnTerminate:=true;
              TDuplicatas.Start;

end;

procedure TFrm_Principal.BTN_envia_produtosClick(Sender: TObject);

begin
//Se os bancos estão ativos, iniciar a transferencia


                Tpg:=  Thread.Create(true);
                tpg.FreeOnTerminate:=true;
                tpg.Start;


end;

procedure TFrm_Principal.BTN_Importa_pedidosClick(Sender: TObject);
VAR
Tpedidos:thread_pedidos;
begin
//Se os bancos estão ativos, iniciar a transferencia
              Tpedidos:=  thread_pedidos.Create(true);
              Tpedidos.FreeOnTerminate:=true;
              Tpedidos.Start;


end;

procedure TFrm_Principal.Configuraes1Click(Sender: TObject);
begin
Frm_Config.ShowModal;
end;

procedure TFrm_Principal.EmailClick(Sender: TObject);
VAR
 // variáveis e objetos necessários para o envio
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  IdText: TIdText;
  sAnexo: string;
  dataAtual,data:Tdatetime;


  valor, recebimentoDplVncHj:string;
begin
dataAtual     := now;

data:=  dataAtual+1;

{Seleciona as duplicatas que vencem no dia}
Data_Postgres.receberhj.Close;
Data_Postgres.receberhj.SQL.Clear;
Data_Postgres.receberhj.SQL.Add('select sum(saldov) as pagar from pcfnpag0 where dtvcto= current_date + interval ''1'' day;');
Data_Postgres.receberhj.Open();

valor:=Data_Postgres.receberhj.FieldByName('pagar').AsString;



 {Seleciona o valor pago de duplicatas que venceram no dia}
Data_Postgres.receberhj.Close;
Data_Postgres.receberhj.SQL.Clear;
Data_Postgres.receberhj.SQL.Add('select sum(saldov) as receber from pcfnrec0 where dtvcto= current_date + interval ''1'' day');
Data_Postgres.receberhj.Open();

recebimentoDplVncHj:=Data_Postgres.receberhj.FieldByName('receber').AsString;



 // instanciação dos objetos
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(Self);
  IdSMTP := TIdSMTP.Create(Self);
  IdMessage := TIdMessage.Create(Self);
  try

// Configuração do protocolo SSL (TIdSSLIOHandlerSocketOpenSSL)
    IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
    IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;

 // Configuração do servidor SMTP (TIdSMTP)
    IdSMTP.IOHandler := IdSSLIOHandlerSocket;
    //IdSMTP.UseTLS := utUseImplicitTLS;
    IdSMTP.AuthType := satDefault;
    IdSMTP.Port := 587;
    IdSMTP.Host := 'smtp.autmaster.com.br';
    IdSMTP.Username := 'wanderlei@autmaster.com.br';
    IdSMTP.Password := '@@aut456';

 // Configuração da mensagem (TIdMessage)
    IdMessage.From.Address := 'wanderlei@autmaster.com.br';
    IdMessage.From.Name := 'Virtual Master 2.0';
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    IdMessage.Recipients.Add.Text := 'wanderlei@autmaster.com.br';
    IdMessage.Recipients.Add.Text := 'fernando.bettega@autmaster.com.br';
    IdMessage.Recipients.Add.Text := 'acm@autmaster.com.br';
    IdMessage.Subject := 'Previsões para o dia '+ DateToStr(data)  ;
    IdMessage.Encoding := meMIME;

 // Configuração do corpo do email (TIdText)
    IdText := TIdText.Create(IdMessage.MessageParts);

    IdText := TIdText.Create(IdMessage.MessageParts);
    IdText.Body.Add('<html>');
    IdText.Body.Add('<style type="text/css">' +
                    '.titulo {' +
                    '	color: #06F;' +
                    '	font-weight: bold;' +
                    '	font-size: 24px;' +
                    '	text-align: center;' +
                    '	font-family: "Lucida Sans Unicode", "Lucida Grande", ' +
                    ' sans-serif; }' +
                    '.descricao {' +
                    '	font-family: "Lucida Sans Unicode", "Lucida Grande",' +
                    'sans-serif; }' +
                    '.css .descricao {' +
                    '	color: #333;' +
                    '	text-align: center; }' +
                    '.css table {' +
                    '	text-align: center;' +
                    '	font-family: Arial, Helvetica, sans-serif;' +
                    '	color: #06F;' +
                    '	font-weight: bold;' +
                    '	font-size: 24;}' +
                    '.footer {' +
                    '	text-align: center; }' +
                    '.css .footer {' +
                    '	font-family: Verdana, Geneva, sans-serif;' +
                    '	color: #333; }' +
                    '</style>'    );

    IdText.Body.Add('<body class="css">');

    IdText.Body.Add('<p class="titulo">Assistente de gestão corporativa Master Virtual</p>' +
                    '<p>&nbsp;</p>' +
                    '<p class="descricao">Através deste e-mail você poderá prever algumas informações referente o contas a pagar e receber </p>' +
                    '<p class="descricao">da sua empresa, com base nos lançamentos ja efetuados no sistema SSPlus.</p>' +
                    '<p>&nbsp;</p>' +
                    '<table width="586" border="0" align="center" cellspacing="1">' +
                    '<tr>' +
                    '<td width="236" height="37" bgcolor="#EEEEEE">Contas a receber</td>' +
                    '<td width="220" bgcolor="#EEEEEE">R$ '+recebimentoDplVncHj+'</td>' +
                    '<td width="120" bgcolor="#EEEEEE"> '+DateToStr(data)+'</td>' +
                    '</tr>' +
                    '<tr>' +
                    '    <td height="40" bgcolor="#EEEEEE">Contas a pagar</td>' +
                    '    <td bgcolor="#EEEEEE">R$ '+valor+' </td>' +
                    '    <td bgcolor="#EEEEEE">'+DateToStr(data)+'</td>' +
                    '  </tr>' +
                    '</table>' +
                    '<p>&nbsp;</p>' +
                    '<p class="footer">Este é mais um produto Autmaster.</p>' +
                    '<p class="footer">Para maiores informações ou sugestões acesse o site www.autmaster.com.br</p>' +
                    '<p>&nbsp;</p>' +
                    '<p>&nbsp;</p>' +
                    '<p>&nbsp;</p> ' ) ;







    IdText.Body.Add('</body>');
    IdText.Body.Add('</html>');
    IdText.ContentType := 'text/html; charset="utf-8"';



 // Conexão e autenticação
    try
      IdSMTP.Connect;
      IdSMTP.Authenticate;
    except
      on E:Exception do
      begin
        MessageDlg('Erro na conexão ou autenticação: ' +
          E.Message, mtWarning, [mbOK], 0);
        Exit;
      end;
    end;


 // Envio da mensagem
    try
      IdSMTP.Send(IdMessage);
      MessageDlg('Mensagem enviada com sucesso!', mtInformation, [mbOK], 0);
    except
      On E:Exception do
      begin
        MessageDlg('Erro ao enviar a mensagem: ' +
          E.Message, mtWarning, [mbOK], 0);
      end;
    end;

   finally
    // desconecta do servidor
    IdSMTP.Disconnect;
    // liberação da DLL
    UnLoadOpenSSLLibrary;
    // liberação dos objetos da memória
    FreeAndNil(IdMessage);
    FreeAndNil(IdSSLIOHandlerSocket);
    FreeAndNil(IdSMTP);
  end;
end;



procedure TFrm_Principal.Enviardados1Click(Sender: TObject);
begin
   Frm_exporta_Registros.ShowModal;
   Data_postgres.Query_produtos.Close;
Data_postgres.Query_produtos.SQL.Clear;
end;

        //FUNCAO PARA VERIFICAR SE VARIAVEL É NULL
        function Empty(Value:Variant): Boolean;
        begin
          Result:= False;

              case VarType(Value) of
              varEmpty,
              varNull:Result:=True;
              varSmallInt,
              varInteger,
              varShortInt,
              varByte,
              varWord,
              varInt64:Result:=(Value=0);

              varSingle,
              varDouble,
              varCurrency:Result:=(Value=0.00);

              varBoolean:Result:=not Value;

              varDate:Result:=(Value=0);

              varOleStr,
              varString:Result:=(Value='');
              end;
        end;






 // =========================================
//PROCEDURE INICIA QUANDO ABRE O APLICATIVO
//==========================================
procedure TFrm_Principal.FormActivate(Sender: TObject);
VAR
Tpg,Tpgl:Thread;
t,m,i,IQTDE_TENT_CONEXAO:integer;
begin
{Define valor de abertura para true, ela é destruida após a conexão com o banco de dados}
Abertura:=true;
ReadIniConfig(true);

{Mostra imagens de banco desconectado antes da conexão.}
ImgStatusPg.Picture.Create.LoadFromFile('.\imagem\DbOff.png'); // P= Postgres
ImgStatusMysql.Picture.Create.LoadFromFile('.\imagem\DbOff.png'); // M= Mysql
ImgStatusNet.Picture.Create.LoadFromFile('.\imagem\IntOn.png');   // Net= Internet

{Carrega o driver dos bancos}
Data_Postgres.Driver_Postgres.VendorHome :=PgsqlDriver  ;
Data_MySQL.Driver_Mysql.VendorHome       :=MysqlDriver  ;
Data_Mysql.Driver_Mysql.VendorLib:='libmysql.dll';
Data_Postgres.Driver_Postgres.VendorLib:='libpq.dll';


{Verifica a conexão com a internet.}
 if  InternetCheckConnection('http://www.google.com/',  1,  0)  then
  Begin
  ImgStatusNet.Picture.Create.LoadFromFile('.\imagem\IntOn.png'); {Internet on}

  //faz a conexão com o postgres
    try
      with Data_Postgres.FD_Postgres do
      begin
      Params.Values['Applicationname']:= Applicationname;
      Params.Values['DriverID']   := 'PG';
      Params.Values['Database']   := PgsqlDB;
      Params.Values['User_name']  := PgsqUser;
      Params.Values['Password']   := PgsqlPass;
      Params.Values['Server']     := PgsqlHost;
      Params.Values['Port']       := PgsqlPorta;
      Params.Values['LoginTimeout']:=LoginTimeout;
      Connected := True;
      ImgStatusPg.Picture.Create.LoadFromFile('.\imagem\DbOn.png');
      end
    except
    ImgStatusPg.Picture.Create.LoadFromFile('.\imagem\DbOff.png');
    ShowMessage('Conexão com o banco SSplus falhou, verifique o servidor e a configuração !');
    end;

    //faz a conexão com o MYsql

    try
      with Data_Mysql.FDCon_Mysql do
      begin
      Params.Values['Applicationname']:= Applicationname;
      Params.Values['DriverID']    := 'MySQL';
      Params.Values['Database']    := MysqlDB;
      Params.Values['User_name']   := MysqlUser;
      Params.Values['Password']    := MysqlPass;
      Params.Values['Server']      :=  MysqlHost;
      Params.Values['Port']        := MysqlPorta;
      Params.Values['LoginTimeout']:=LoginTimeout;
      Connected := True;
      ImgStatusMysql.Picture.Create.LoadFromFile('.\imagem\DbOn.png');
      end ;
    except
    ImgStatusMysql.Picture.Create.LoadFromFile('.\imagem\DbOff.png');
    ShowMessage('Conexão com o banco MySQL falhou, verifique a internet e a configuração !');
    end

  End

  Else

  begin
  ImgStatusNet.Picture.Create.LoadFromFile('.\imagem\IntOff.png');
  ShowMessage(' Verifique a conexão com a internet.');
  end;

  {Verifica se ambos os bancos de dados estão ativos para definir a variavel de abertura para false.}
  if Data_Mysql.FDCon_Mysql.State = csConnected then
  begin
    if Data_Postgres.FD_Postgres.State = csConnected then
    begin
    abertura:=false;
    BTN_envia_produtos.Enabled          :=true;
    Btn_Rel_Pedidos_exportados.Enabled  :=true;
    BTN_Importa_pedidos.Enabled         :=true;
    end;

  end
     else
  begin
  Abertura:=true;
  BTN_envia_produtos.Enabled          :=false;
  Btn_Rel_Pedidos_exportados.Enabled  :=false;
  BTN_Importa_pedidos.Enabled         :=false;
  end;

end;



procedure TFrm_Principal.FormCreate(Sender: TObject);
Var FileName : PChar;


begin


ShowWindow(Application.Handle, SW_HIDE) ;
SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW ) ;
ShowWindow(Application.Handle, SW_SHOW) ;
end;

procedure TFrm_Principal.ImgStatusMysqlClick(Sender: TObject);
begin
frm_config.showmodal;
end;

procedure TFrm_Principal.Img_UltimoProdutoDblClick(Sender: TObject);
var
ArqIni:Tinifile;
begin
 ArqIni:= TIniFile.Create('.\Arquivo.ini');
ArqIni.WriteBool('ATUALIZACAO','UpCompleto',true);
showmessage('Histórico excluido com sucesso.')
end;



// VERIFICA OS AGENDAMENTOS PARA IMPORTAR OU EXPORTAR.
procedure TFrm_Principal.Timer_AtualizaTimer(Sender: TObject);
var

Hora,UltimoUpPro, UltimoUpDpl, UltimoUpPed:string;
Tpg,Tpgl:Thread;
Tpedidos:thread_pedidos;
TDuplicatas:thread_duplicatas;
ArqIni:Tinifile;
begin
{IMPORTA E EXPORTA DE ACORDO COM O AGENDAMENTO}

  ArqIni  := TIniFile.Create('.\Arquivo.ini');
  Hora:= FormatDateTime('hh:mm',Now);

  {EXPORTA OS PRODUTOS}
    if pos(Hora,cfgAgendaProdutos)<> 0 then
    begin
    UltimoUpPro:= ArqIni.ReadString('Atualizacao','HoraUltAtualizaPro','');
    if  (Hora <> UltimoUpPro) then
      Begin
      ArqIni.WriteString('Atualizacao', 'HoraUltAtualizaPro' , hora);
      Data_Mysql.FDCon_Mysql.Ping;
      Data_Postgres.FD_Postgres.Ping;
      Tpg:=  Thread.Create(true);
      tpg.FreeOnTerminate:=true;
      tpg.Resume;
      End;
    end;


      {IMPORTA OS PEDIDOS E CLIENTES}
    if pos(Hora,cfgAgendaPedidos)<> 0 then
    begin
    UltimoUpPed:= ArqIni.ReadString('Atualizacao','HoraUltAtualizaPed','');
    if  (Hora <> UltimoUpPed) then
      begin
      ArqIni.WriteString('Atualizacao', 'HoraUltAtualizaPed' , hora);
      Tpedidos:=  thread_pedidos.Create(true);
      Tpedidos.FreeOnTerminate:=true;
      Tpedidos.Start;
      end;
    end;


    {Exporta duplicatas e bloquetos da loja fisica para e-commerce}
    if pos(Hora,cfgAgendaDuplicatas)<> 0 then
    begin
    UltimoUpDpl:= ArqIni.ReadString('Atualizacao','HoraUltAtualizaDpl','');
    if  (Hora <> UltimoUpDpl) then
      Begin
      ArqIni.WriteString('Atualizacao', 'HoraUltAtualizaDpl' , hora);
      TDuplicatas:=  thread_duplicatas.Create(true);
      TDuplicatas.FreeOnTerminate:=true;
      TDuplicatas.Start;
      End;
    end;





end;






procedure TFrm_Principal.Timer_painelTimer(Sender: TObject);
var
Flags   : Cardinal;
maxtime : TTime;
Timeout : integer ;
tempo   : integer;
begin
 {Impede a verificação do status do banco na abertura do programa para não criar um loop de verificação}
  if abertura = false then
  begin
  Data_mysql.FDCon_Mysql.Ping;
  Data_Postgres.FD_Postgres.Ping;
  end;



end;


procedure TFrm_Principal.btn_painelClick(Sender: TObject);
begin
if (btn_painel.State = tssoff) then
SV_principal.Close;
if (btn_painel.State= tsson) then
SV_principal.Open;
end;

procedure TFrm_Principal.TrayIcon1DblClick(Sender: TObject);
begin  //Tornando a aplicação novamente visível
TrayIcon1.Visible := False;
Show();
//WindowState:=wsMaximized  ;
Application.BringToFront();
application.Restore;

//Leia mais em: Utilizando o componente TTrayIcon no Delphi
//www.devmedia.com.br/utilizando-o-componente-ttrayicon-no-delphi/25088#ixzz3uTvahbWE
end;

end.
