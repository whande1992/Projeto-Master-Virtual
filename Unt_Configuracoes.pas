unit Unt_Configuracoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Menus,IniFiles, Vcl.ExtDlgs, jpeg, Vcl.Buttons,
  Vcl.WinXCtrls, Vcl.Mask,StrUtils ;

type
  TFrm_Config = class(TForm)
    PMenuConfig: TPanel;
    PageConfig: TPageControl;
    Tab_DB: TTabSheet;
    Tab_FTP: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    Grupo_Postgres: TGroupBox;
    Grupo_Mysql: TGroupBox;
    edt_PgsqlHost: TEdit;
    edt_PgsqlPorta: TEdit;
    edt_PgsqlDB: TEdit;
    lbl_PgsqlHost: TLabel;
    lbl_PgsqlPorta: TLabel;
    lbl_PgsqlDB: TLabel;
    lbl_MysqlDB: TLabel;
    edt_MysqlDB: TEdit;
    lbl_MysqlPorta: TLabel;
    edt_MysqlPorta: TEdit;
    lbl_MysqlHost: TLabel;
    edt_MysqlHost: TEdit;
    btn_SalvaConfiguracoes: TButton;
    GroupBox3: TGroupBox;
    FTP_host: TEdit;
    FTP_porta: TEdit;
    FTP_usuario: TEdit;
    FTP_senha: TEdit;
    Label2: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Button4: TButton;
    btn_TesteConexaoPgsql: TButton;
    btn_TesteConexaoMysql: TButton;
    tab_Empresa: TTabSheet;
    Button7: TButton;
    Grupo_Empresa: TGroupBox;
    lbl_CodEmpresa: TLabel;
    edt_CodEmpresa: TEdit;
    edt_MysqlUser: TEdit;
    lbl_MysqlUser: TLabel;
    Label8: TLabel;
    Grupo_Produto: TGroupBox;
    FTP_diretorio: TEdit;
    Label14: TLabel;
    lbl_MysqlPass: TLabel;
    edt_MysqlPass: TEdit;
    lbl_MysqlPrefixo: TLabel;
    edt_MysqlPrefixo: TEdit;
    dlg_imagemnull: TOpenPictureDialog;
    imagemnull: TImage;
    btn_PesImgNull: TButton;
    lbl_imgproduto: TLabel;
    Tab_Pedidos: TTabSheet;
    btn_Pedidos: TButton;
    Grupo_Pedidos: TGroupBox;
    lbl_Observacao: TLabel;
    lbl_FormaPagamento: TLabel;
    lbl_StatusPedidoImportar: TLabel;
    btn_inf_imp_pedido: TSpeedButton;
    edt_Observacao: TEdit;
    edt_Forma_pagamento: TEdit;
    lista_Status_pedido: TComboBoxEx;
    btn_cliente: TButton;
    Tab_Cliente: TTabSheet;
    Grupo_Cliente: TGroupBox;
    lbl_limite_financeiro: TLabel;
    edt_Limite_financeiro: TEdit;
    Sbtn_DicaLimiteFinanceiro: TSpeedButton;
    lbl_AtualizaInfCliente: TLabel;
    to_AtualizaInfCliente: TToggleSwitch;
    sbtn_DicaUpInfCliente: TSpeedButton;
    btn_agendamentos: TButton;
    Tab_Agendamentos: TTabSheet;
    Grupo_Agenda_Produtos: TGroupBox;
    btn_AgePro_adicionar: TSpeedButton;
    btn_AgePro_deletar: TSpeedButton;
    edt_AgendaProdutos_hora: TMaskEdit;
    List_AgendaProdutos: TListBox;
    btn_EnviaImgNull: TButton;
    Grupo_Agenda_Pedidos: TGroupBox;
    edt_AgendaPedido_hora: TMaskEdit;
    Btn_AgePed_adicionar: TSpeedButton;
    Btn_AgePed_deletar: TSpeedButton;
    list_AgendaPedido: TListBox;
    Texto_Exportacao: TMemo;
    Texto_Importacao: TMemo;
    chk_informacoes: TCheckBox;
    ToContinuaProduto: TToggleSwitch;
    lbl_InicioUltPro: TLabel;
    Grupo_Agenda_Duplicatas: TGroupBox;
    List_AgendaDuplicatas: TListBox;
    Edt_AgeDpl_hora: TMaskEdit;
    Btn_AgeDpl_adicionar: TSpeedButton;
    Btn_AgeDpl_Deletar: TSpeedButton;
    Memo1: TMemo;
    RadioProEnviarPendente: TRadioButton;
    RadioProEnviarTodos: TRadioButton;
    RadioProEnviarHoje: TRadioButton;
    ToSoProComImg: TToggleSwitch;
    lbl_ProdutosComImagem: TLabel;
    lbl_CodIdioma: TLabel;
    edt_CodIdioma: TEdit;
    Date_Retroativa: TDateTimePicker;
    chk_DataRetroativa: TCheckBox;
    lblStatusPosImportacao: TLabel;
    Lista_StatusPosImportacao: TComboBoxEx;
    lblMsgStatusEcommerce: TLabel;
    edtMsgStatusPosImportacao: TEdit;
    lblPromocao: TLabel;
    ToPromocao: TToggleSwitch;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btn_SalvaConfiguracoesClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btn_TesteConexaoPgsqlClick(Sender: TObject);
    procedure btn_TesteConexaoMysqlClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btn_PesImgNullClick(Sender: TObject);
    procedure btn_inf_imp_pedidoClick(Sender: TObject);
    procedure btn_PedidosClick(Sender: TObject);
    procedure Sbtn_DicaLimiteFinanceiroClick(Sender: TObject);
    procedure sbtn_DicaUpInfClienteClick(Sender: TObject);
    procedure btn_clienteClick(Sender: TObject);
    procedure btn_AgePro_adicionarClick(Sender: TObject);
    procedure btn_AgePro_deletarClick(Sender: TObject);
    procedure btn_EnviaImgNullClick(Sender: TObject);
    procedure Btn_AgePed_adicionarClick(Sender: TObject);
    procedure Btn_AgePed_deletarClick(Sender: TObject);
    procedure btn_agendamentosClick(Sender: TObject);
    procedure Btn_AgeDpl_adicionarClick(Sender: TObject);
    procedure Btn_AgeDpl_DeletarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Config: TFrm_Config;

implementation

{$R *.dfm}

uses Unt_Postgres, Unt_Mysql, Unt_Principal, Unt_Funcoes_ini;

procedure TFrm_Config.btn_agendamentosClick(Sender: TObject);
begin
 PageConfig.ActivePage:=tab_agendamentos;
end;

procedure TFrm_Config.btn_clienteClick(Sender: TObject);
begin
PageConfig.ActivePage:=tab_cliente;
end;

procedure TFrm_Config.Btn_AgeDpl_adicionarClick(Sender: TObject);
begin
 {Verifica se o item ja esta listado}
  if List_AgendaDuplicatas.Items.IndexOf(Edt_AgeDpl_hora.Text) = -1 Then
  begin
      {Caso não esteja listado verifica se ele tem valor}
      if (Edt_AgeDpl_hora.Text ='  :  ') then
          MessageDlg('Precisa informar um horário para adicionar. ',mtWarning,[mbOk],0)
          {Caso o item possua valor ele é inserido.}
          else
          List_AgendaDuplicatas.Items.Add(Edt_AgeDpl_hora.Text);
end else
            {mensagem caso ja esteja listado}
            MessageDlg('Este horário ja foi adicionado. ',mtWarning,[mbOk],0);
end;

procedure TFrm_Config.Btn_AgeDpl_DeletarClick(Sender: TObject);
begin
{Delete itens do lisbox de importação}
List_AgendaDuplicatas.DeleteSelected;
end;

procedure TFrm_Config.btn_AgePro_adicionarClick(Sender: TObject);
begin
   {Verifica se o item ja esta listado}
  if List_AgendaProdutos.Items.IndexOf(edt_AgendaProdutos_hora.Text) = -1 Then
  begin
      {Caso não esteja listado verifica se ele tem valor}
      if (edt_AgendaProdutos_hora.Text ='  :  ') then
          MessageDlg('Precisa informar um horário para adicionar. ',mtWarning,[mbOk],0)
          {Caso o item possua valor ele é inserido.}
          else
          List_AgendaProdutos.Items.Add(edt_AgendaProdutos_hora.Text);
end else
            {mensagem caso ja esteja listado}
            MessageDlg('Este horário ja foi adicionado. ',mtWarning,[mbOk],0);


end;

procedure TFrm_Config.btn_AgePro_deletarClick(Sender: TObject);
begin

{Deleta itens do lsitbox de exportação}
List_AgendaProdutos.DeleteSelected;
end;

procedure TFrm_Config.btn_PesImgNullClick(Sender: TObject);
begin
    // Seleciona  a imagem para ser enviado ao ftp quando clicar no botao salvar
  if dlg_imagemnull.Execute then
  imagemnull.Picture.LoadFromFile(dlg_imagemnull.FileName);

  // envia imagem para o site
imagemnull.Picture.SaveToFile('.\CFG\imgnull.jpg');
imagemnull.Picture.SaveToFile('.\CFG\imgnull-80x80.jpg');
imagemnull.Picture.SaveToFile('.\CFG\imgnull-500x500.jpg');
imagemnull.Picture.SaveToFile('.\CFG\imgnull-228x228.jpg');
imagemnull.Picture.SaveToFile('.\CFG\imgnull-74x74.jpg');
imagemnull.Picture.SaveToFile('.\CFG\imgnull-47x47.jpg');
imagemnull.Picture.SaveToFile('.\CFG\imgnull-90x90.jpg');
imagemnull.Picture.SaveToFile('.\CFG\imgnull-268x50.jpg')



end;

procedure TFrm_Config.Btn_AgePed_adicionarClick(Sender: TObject);
begin
   {Verifica se o item ja esta listado}
  if list_AgendaPedido.Items.IndexOf(edt_AgendaPedido_hora.Text) = -1 Then
  begin
      {Caso não esteja listado verifica se ele tem valor}
      if (edt_AgendaPedido_hora.Text ='  :  ') then
          MessageDlg('Precisa informar um horário para adicionar. ',mtWarning,[mbOk],0)
          {Caso o item possua valor ele é inserido.}
          else
          list_AgendaPedido.Items.Add(edt_AgendaPedido_hora.Text);
end else
            {mensagem caso ja esteja listado}
            MessageDlg('Este horário ja foi adicionado. ',mtWarning,[mbOk],0);
end;

procedure TFrm_Config.Btn_AgePed_deletarClick(Sender: TObject);
begin
{Delete itens do lisbox de importação}
list_AgendaPedido.DeleteSelected;
end;

procedure TFrm_Config.btn_inf_imp_pedidoClick(Sender: TObject);
begin
MessageDlg('Informe o Status do pedido para ser importado ao SSPlus para faturamento.'+#13+
          ' Ex: Aguardando faturamento '+#13+
          ' O Sistema irá importar todos os pedidos que estiverem com esse status no e-commerce.',mtInformation,[mbOk],0);
end;

procedure TFrm_Config.Button1Click(Sender: TObject);
begin
 PageConfig.ActivePage:=tab_db;
end;

procedure TFrm_Config.Button2Click(Sender: TObject);
begin
 PageConfig.ActivePage:=tab_ftp;
end;
// Cria o arquivo de configuração
procedure TFrm_Config.btn_SalvaConfiguracoesClick(Sender: TObject);
var
ArqIni: TIniFile;
i:integer;
msenha,ftpsenha,tipoatualizacao,expimg,
var_atualiza_cliente, informacoes, cfg_UltProduto:string;

begin
{Escreve a configuração no Arquivo INI}
 ArqIni := TIniFile.Create('.\Arquivo.ini');

 {Configurações do banco de dados}
 try
 // Criptografa senha do mysql
 S := edt_MysqlPass.text;
      For i:=1 to ord(s[0]) do
        c[i] := 23 Xor c[i];
      msenha := s;

 ArqIni.WriteString('Mysql', 'Host'    , edt_MysqlHost.Text);
 ArqIni.WriteString('Mysql', 'Porta'   , edt_MysqlPorta.Text);
 ArqIni.WriteString('Mysql', 'banco'   , edt_MysqlDB.Text);
 ArqIni.WriteString('Mysql', 'Usuario' , edt_Mysqluser.Text);
 ArqIni.WriteString('Mysql', 'Senha'   , msenha);  // criptografado
 ArqIni.WriteString('Mysql', 'Prefixo' , edt_MysqlPrefixo.Text);
 ArqIni.WriteString('Postgres', 'Host' , edt_PgsqlHost.Text);
 ArqIni.WriteString('Postgres', 'Porta', edt_PgsqlPorta.Text);
 ArqIni.WriteString('Postgres' ,'Banco', edt_PgsqlDB.Text);




 {Configuração da TAB Produtos}
 ArqIni.WriteString('Config', 'Empresa'    , edt_CodEmpresa.Text);
 ArqIni.WriteString('Config', 'CodIdioma'  , edt_CodIdioma.Text);

 {Verifica o tipo de atualização dos produtos}
  if RadioProEnviarPendente.Checked=true then
    tipoatualizacao := 'Pendentes' else
  if RadioProEnviarTodos.Checked=true then
    tipoatualizacao := 'Todos' else
  if RadioProEnviarHoje.Checked=true then
    tipoatualizacao := 'Diario'  ;

 ArqIni.WriteString('CONFIG', 'tipo_Atualizacao'    , tipoatualizacao);
 ArqIni.WriteBool('CONFIG', 'EnvioRetroativo'    , chk_DataRetroativa.Checked);
 ArqIni.WriteDate('CONFIG', 'DataEnvioRetroativo'    , Date_Retroativa.Date);

  // configuração de imagem
  case ToSoProComImg.State of
  tssOff : expimg:='N';
  tssOn  : expimg:='S'
  end;

  ArqIni.WriteString('CONFIG', 'ApenasProdutoComImg'  , expimg);

  case ToContinuaProduto.State OF
    tssOn  : cfg_UltProduto:='S' ;
    tssOff : cfg_UltProduto:='N' ;
  end;
  ArqIni.WriteString('CONFIG', 'ATIVA_ULT_PRODUTO' , cfg_UltProduto );

 {Valida se envia a imagem junto com a configuração do produto}
  case chk_informacoes.Checked of
  True  :  informacoes:='true';
  False :  informacoes:='false';
  end;
 ArqIni.WriteString('CONFIG', 'Informacoes'     , informacoes);



    case ToPromocao.State OF
    tssOn  : ArqIni.WriteBool('CONFIG', 'Promocao' , true );
    tssOff : ArqIni.WriteBool('CONFIG', 'Promocao' , false );
  end;







 {Grava configurações da importação de pedidos}
  ArqIni.WriteString('Pedido', 'Obs' , edt_Observacao.Text);
  ArqIni.WriteString('Pedido', 'Forma_PGTO' , edt_Forma_pagamento.Text);
  ArqIni.WriteString('Pedido', 'Status_Pedido' , lista_Status_pedido.Text);
  ArqIni.WriteString('Pedido', 'Status_PedidoRetorno',Lista_StatusPosImportacao.Text);
  ArqIni.WriteString('pedido', 'MsgStatus', edtMsgStatusPosImportacao.Text);



  {Grava configuração dos clientes}
  ArqIni.WriteString('Cliente', 'Limite' , edt_limite_financeiro.Text);

  case to_AtualizaInfCliente.State of
  tssOn  : ArqIni.WriteString('Cliente', 'Atualiza' , 'S');
  tssOff : ArqIni.WriteString('Cliente', 'Atualiza' , 'N');
  end;



  {Grava configurações da agenda}
  ArqIni.WriteString('AGENDA', 'Produtos' , List_AgendaProdutos.Items.DelimitedText);
  ArqIni.WriteString('AGENDA', 'Duplicatas' , List_AgendaDuplicatas.Items.DelimitedText);
  ArqIni.WriteString('AGENDA', 'Pedidos' , list_AgendaPedido.Items.DelimitedText);


   {Grava informações do FTP}


 // Criptografa senha do FTP
 S := FTP_senha.text;
     For i:=1 to ord(s[0]) do
       c[i] := 23 Xor c[i];
     ftpsenha := s;

  ArqIni.WriteString('FTP', 'Host'     , ftp_host.Text);
  ArqIni.WriteString('FTP', 'Porta'    , ftp_porta.Text);
  ArqIni.WriteString('FTP', 'Usuario'  , ftp_usuario.Text);
  ArqIni.WriteString('FTP', 'Senha'    , ftpsenha);// criptografado
  ArqIni.WriteString('FTP', 'Diretorio', ftp_diretorio.Text);

  finally

    ArqIni.Free;

  end;


 ReadIniConfig(true); {Recarrega as configurações na variavel}













  end;

procedure TFrm_Config.Button4Click(Sender: TObject);
begin
      try
      frm_principal.IdFTP1.Quit;
      frm_principal.IdFTP1.Disconnect;
      Frm_principal.IdFTP1.Host := ftp_host.Text;
      frm_principal.IdFTP1.Port :=strtoint(ftp_porta.Text)    ;
      Frm_principal.IdFTP1.Username := ftp_usuario.Text;
      Frm_principal.IdFTP1.Password := ftp_senha.Text;
      Frm_principal.IdFTP1.Connect;
      showmessage('FTP Conectado com sucesso!') ;
      Frm_principal.IdFTP1.Disconnect;
      except
        shOwmessage('Não Foi possivel conectar ao FTP, verifique a configuração e sua conexão com a internet ');
      end;


end;

procedure TFrm_Config.btn_TesteConexaoPgsqlClick(Sender: TObject);
begin
 //faz a conexão com o postgres
  try
    with Data_Postgres.FD_Postgres do
    begin
    Params.Values['DriverID']  := 'PG';
    Params.Values['Database']  := edt_PgsqlDB.Text;
    Params.Values['User_name'] := 'ssecomm';
    Params.Values['Password']  := 'ecomm@2016';
    Params.Values['Server']    :=  edt_PgsqlHost.Text;
    Params.Values['Port']      := edt_PgsqlPorta.Text;
    Connected := True;
    Frm_Principal.ImgStatusPg.Picture.Create.LoadFromFile('.\imagem\DbOn.png');
    ShowMessage('Banco de dados SSplus conectado com sucesso !');
    end;
  except
  Frm_Principal.ImgStatusPg.Picture.Create.LoadFromFile('.\imagem\DbOff.png');
  ShowMessage('Conexão com o banco SSplus falhou !');
  end;

end;

procedure TFrm_Config.btn_TesteConexaoMysqlClick(Sender: TObject);
begin
//faz a conexão com o MYsql
  try
    with Data_Mysql.FDCon_Mysql do
    begin
    Params.Clear;
    Params.Values['DriverID']  := 'MySQL';
    Params.Values['Database']  := edt_MysqlDB.Text;
    Params.Values['User_name'] := edt_MysqlUser.Text;
    Params.Values['Password']  := edt_MysqlPass.Text;
    Params.Values['Server']    := edt_MysqlHost.Text;
    Params.Values['Port']      := edt_MysqlPorta.Text;
    Connected := True;
    Frm_Principal.ImgStatusMysql.Picture.Create.LoadFromFile('.\imagem\DbOn.png');
    ShowMessage('Banco de dados MySQL conectado com sucesso !');
    abertura:=false;
    end;
  except
  Frm_Principal.ImgStatusMysql.Picture.Create.LoadFromFile('.\imagem\DbOff.png');
  ShowMessage('Conexão com o banco MySQL falhou !');
  end;
end;

procedure TFrm_Config.Button7Click(Sender: TObject);
begin
 PageConfig.ActivePage:=tab_empresa;
end;

procedure TFrm_Config.btn_PedidosClick(Sender: TObject);
begin
PageConfig.ActivePage:=tab_pedidos;
end;

procedure TFrm_Config.btn_EnviaImgNullClick(Sender: TObject);
var
IQTDE_TENT_CONEXAO:integer;
begin
IQTDE_TENT_CONEXAO:=1;
  while IQTDE_TENT_CONEXAO <= 3 do
   BEGIN
  //Abre conexão do o FTP para enviar as imagens
   with frm_principal.IdFTP1 do
    try
    frm_principal.IdFTP1.Quit;
    frm_principal.IdFTP1.Disconnect;
    Host     := ftp_host.Text;
    Port     :=strtoint(ftp_porta.Text)    ;
    Username := ftp_usuario.Text;
    Password := ftp_senha.Text;
    Connect;
    if (frm_principal.IdFTP1.Connected=True) then
    showmessage('Imagem enviada com sucesso!');

    except
    IQTDE_TENT_CONEXAO:= IQTDE_TENT_CONEXAO + 1;
    end;

    if frm_principal.IdFTP1.Connected then
    begin
    frm_principal.IdFTP1.ChangeDir(ftp_diretorio.Text + '/image/cache/catalog/');  //image/cache/catalog
    frm_principal.IdFTP1.Put('.\cfg\imgnull-80x80.jpg'   ,'imgnull-80x80.jpg');
    frm_principal.IdFTP1.Put('.\cfg\imgnull-500x500.jpg' ,'imgnull-500x500.jpg');
    frm_principal.IdFTP1.Put('.\cfg\imgnull-228x228.jpg' ,'imgnull-228x228.jpg');
    frm_principal.IdFTP1.Put('.\cfg\imgnull-74x74.jpg'   ,'imgnull-74x74.jpg');
    frm_principal.IdFTP1.Put('.\cfg\imgnull-47x47.jpg'   ,'imgnull-47x47.jpg');
    frm_principal.IdFTP1.Put('.\cfg\imgnull-90x90.jpg'   ,'imgnull-90x90.jpg');
    frm_principal.IdFTP1.Put('.\cfg\imgnull-268x50.jpg'  ,'imgnull-268x50.jpg');

    frm_principal.IdFTP1.ChangeDir(ftp_diretorio.Text +'/image/catalog/'); //image/catalog
    frm_principal.IdFTP1.Put('.\cfg\imgnull.jpg' ,'imgnull.jpg');
     Break    ;
     end;

  END;

end;










procedure TFrm_Config.FormActivate(Sender: TObject);

begin
  try
  imagemnull.Picture.LoadFromFile('.\CFG\imgnull.jpg'); // carrega a imagem
  except

  end;


 edt_PgsqlHost.Text  := PgsqlHost;
 edt_PgsqlPorta.Text := PgsqlPorta;
 edt_PgsqlDB.Text    := PgsqlDB ;

 edt_MysqlHost.Text  := MysqlHost;
 edt_MysqlPorta.Text := MysqlPorta;
 edt_MysqlDB.Text    := MysqlDB;
 edt_MysqlUser.Text  := MysqlUser;
 edt_MysqlPrefixo.Text := MysqlPrefixo;
 edt_MysqlPass.Text   := MysqlPass;

 ftp_host.Text      := FtpHost;
 ftp_porta.Text     := FtpPorta;
 ftp_usuario.Text   := FtpUser;
 ftp_diretorio.Text := FtpDiretorio;
 ftp_senha.Text     := FtpPass;


 edt_CodIdioma.text := cfgCodIdioma  ;
 edt_CodEmpresa.Text:= cfgEmpresa;



 edt_forma_pagamento.Text  := cfgFormPgto ;
 edt_observacao.Text       := cfgObs ;
 lista_Status_pedido.Text  := cfgPedidoStatus ;
 Lista_StatusPosImportacao.Text:=cfgStatusPosImportado;
 edtMsgStatusPosImportacao.Text:=cfgMsgStatus;
 chk_DataRetroativa.Checked:=cfgEnvioRetroativo;
 Date_Retroativa.Date:= cfgDataEnvioRetroativo;

  Edt_limite_financeiro.Text := cfgCliLimFinanceiro ;


  List_AgendaProdutos.Items.DelimitedText:=cfgAgendaProdutos;
  List_AgendaDuplicatas.Items.DelimitedText:=cfgAgendaDuplicatas;
  list_AgendaPedido.Items.DelimitedText:=cfgAgendaPedidos;



  {Verificação dos flags}

  {Tipo de atualizacao}
  case AnsiIndexStr(cfgTipoAtualizacao,['Pendentes','Todos','Diario']) of
  0 : RadioProEnviarPendente.Checked:=true;
  1 : RadioProEnviarTodos.Checked:=true;
  2 : RadioProEnviarHoje.Checked:=true;
  end;

  {Flag que verifica o ultimo produto enviado em uma atualização}
   case AnsiIndexStr(cfgUltProduto, ['S', 'N']) of
  0 : ToContinuaProduto.State:=tssOn;
  1 : ToContinuaProduto.State:=tssOff;
  end;

  {informa se atualiza as informaçoes do cliente na importação do pedido}
  case AnsiIndexStr(cfgUpCliente, ['S', 'N']) of
  0 :  to_AtualizaInfCliente.State:=tssOn;
  1 :  to_AtualizaInfCliente.State:=tssOff;
  end;

  {Verifica se o flag chk_informacoes esta ativado}
  case AnsiIndexStr(cfgApenasInf, ['true', 'false']) of
  0 : chk_informacoes.Checked:=true;
  1 : chk_informacoes.Checked:=false;
  end;


  {Configuração sobre a exportação de imagem}
  case AnsiIndexStr(cfgExportaImg, ['S', 'N']) of
  0 : ToSoProComImg.State:=tssOn ;
  1 : ToSoProComImg.State:=tssOff ;
  end;


  {configuração do envio de promoção dos produtos}
  case cfgPromocaoProduto of
  true : ToPromocao.State:=tssOn;
  false: ToPromocao.State:=tssOff;
  end;

end;

procedure TFrm_Config.Sbtn_DicaLimiteFinanceiroClick(Sender: TObject);
begin
MessageDlg('Limite financeiro aprovado na loja física.'+#13+
          ' Caso não exista, informar zero(0).' , mtInformation,[mbOk],0);
end;

procedure TFrm_Config.sbtn_DicaUpInfClienteClick(Sender: TObject);
begin
MessageDlg('On  - Atualiza as informações cadastrais do cliente no SSPlus com as informações do e-commerce.'+#13+
           'Off - Não atualiza o cliente com as informações do e-commerce.' , mtInformation,[mbOk],0);
end;

end.
