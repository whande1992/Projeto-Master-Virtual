unit Unt_Postgres;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, Datasnap.DBClient, FireDAC.Moni.Base,
  FireDAC.Moni.FlatFile, FireDAC.ConsoleUI.Wait;

type
  TData_Postgres = class(TDataModule)
    Driver_Postgres: TFDPhysPgDriverLink;
    Query_produtos: TFDQuery;
    FDGUI_Postgres: TFDGUIxWaitCursor;
    DTSource_Produtos: TDataSource;
    Query_produtoscodigo: TStringField;
    Query_produtosmarca: TStringField;
    Query_produtosdescr1: TStringField;
    Query_produtossecao: TStringField;
    Query_produtosgrupo: TStringField;
    Query_produtossubgru: TStringField;
    Query_produtoscodire: TStringField;
    Query_produtosprvist: TBCDField;
    Query_produtosbasico: TStringField;
    Query_produtoslocaliza: TStringField;
    Query_produtosdesconto_ecommerce: TBCDField;
    DS_VW_Produtos: TClientDataSet;
    UPdate_Produtos: TFDQuery;
    Query_VWprodutos: TFDQuery;
    FD_Postgres: TFDConnection;
    Query_Relatorio_produtos: TFDQuery;
    Qry_Erros: TFDQuery;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    BCDField1: TBCDField;
    BCDField2: TBCDField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    StringField9: TStringField;
    Qry_Con_Dupli: TFDQuery;
    marca: TFDQuery;
    StringField10: TStringField;
    StringField11: TStringField;
    StringField12: TStringField;
    StringField13: TStringField;
    BCDField3: TBCDField;
    BCDField4: TBCDField;
    StringField14: TStringField;
    StringField15: TStringField;
    StringField16: TStringField;
    StringField17: TStringField;
    StringField18: TStringField;
    produtos_ecommerce_caracteristicas: TFDQuery;
    token: TFDQuery;
    f_ecommerce_cliente: TFDQuery;
    f_ecommerce_insere_pedido: TFDQuery;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    Transaction_pedido: TFDTransaction;
    pedido_status: TFDQuery;
    Pedidos_enviados: TFDQuery;
    DT_pedidos_enviados: TClientDataSet;
    DS_pedidos_enviados: TDataSource;
    similares: TFDQuery;
    duplicatas: TFDQuery;
    receberhj: TFDQuery;
    boleto: TFDQuery;
    procedure FD_PostgresRecover(ASender, AInitiator: TObject;
      AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
    procedure FD_PostgresError(ASender, AInitiator: TObject;
      var AException: Exception);
    procedure FD_PostgresRestored(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Data_Postgres: TData_Postgres;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses Unt_Principal, Unt_Thread_comunicador;

{$R *.dfm}

procedure TData_Postgres.FD_PostgresError(ASender, AInitiator: TObject;
  var AException: Exception);
begin
{ 1 º
Caso ocorra um erro de conexão do mysql ativa o temporizador de tentativa de reconexão}

  Frm_Principal.ImgStatusPg.Picture.Create.LoadFromFile('.\imagem\DbOff.png');
  Frm_Principal.lbl_SSPlus.Caption:='SSPlus'+#13+'Desconectado..';
  Frm_Principal.Timer_painel.Enabled:=true;

end;

procedure TData_Postgres.FD_PostgresRecover(ASender, AInitiator: TObject;
  AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
begin
{2º
Se consegueir reconectar passa para o terceiro, senão ocorre o erro}

  Frm_Principal.ImgStatusPg.Picture.Create.LoadFromFile('.\imagem\DbRecurring.png');
  Frm_Principal.lbl_SSPlus.Caption:='SSPlus'+#13+'reconectando..';

end;

procedure TData_Postgres.FD_PostgresRestored(Sender: TObject);
VAR
Tpg,Tpgl:Thread;
begin
{3º
 Reconecta no banco de dados, reinicia a thread e para o temporizador de reconexão
}


    Frm_Principal.Timer_painel.Enabled:=false;
    Frm_Principal.ImgStatusPg.Picture.Create.LoadFromFile('.\imagem\DbOn.png');
    Frm_Principal.lbl_SSPlus.Caption:='SSPlus';

              Tpg:=  Thread.Create(true);
              tpg.FreeOnTerminate:=true;
              tpg.Start;





end;

end.
