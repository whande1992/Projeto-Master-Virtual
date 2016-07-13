unit Unt_Mysql;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.VCLUI.Wait, FireDAC.Moni.Base, FireDAC.Moni.FlatFile, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.Comp.UI, Vcl.Dialogs, IniFiles;

type
  TData_Mysql = class(TDataModule)
    Driver_Mysql: TFDPhysMySQLDriverLink;
    Query_DescricaoM: TFDQuery;
    Query_ProdutosMm: TFDQuery;
    Query_VerificaProM: TFDQuery;
    QryUP_ProdutoM: TFDQuery;
    QryUP_ProDescM: TFDQuery;
    Query_Pro_store: TFDQuery;
    Query_VCategoria: TFDQuery;
    Query_IMG: TFDQuery;
    duplicata: TFDQuery;
    marca: TFDQuery;
    oc_product_related: TFDQuery;
    caracteristicas_ecommerce: TFDQuery;
    pedidos_ecommerce: TFDQuery;
    order_product: TFDQuery;
    Filtro_produtos: TFDQuery;
    filtro_id: TFDQuery;
    secao: TFDQuery;
    grupo: TFDQuery;
    cliente: TFDQuery;
    NewDuplicata: TFDQuery;
    oc_ss_erros_log: TFDQuery;
    FDCon_Mysql: TFDConnection;
    Query_ProdutosM: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure FDCon_MysqlRecover(ASender, AInitiator: TObject;
      AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
    procedure FDCon_MysqlRestored(Sender: TObject);
    procedure FDCon_MysqlError(ASender, AInitiator: TObject;
      var AException: Exception);
    procedure FDCon_MysqlLost(Sender: TObject);
      var
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Data_Mysql: TData_Mysql;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses Unt_Principal, Unt_Thread_comunicador;

{$R *.dfm}





procedure TData_Mysql.FDCon_MysqlError(ASender, AInitiator: TObject;
  var AException: Exception);
begin
{ 1 º
Caso ocorra um erro de conexão do mysql ativa o temporizador de tentativa de reconexão}
Frm_Principal.ImgStatusMysql.Picture.Create.LoadFromFile('.\imagem\DbOff.png');
Frm_Principal.Label_ecommerce.Caption:='e-commerce'+#13+'Desconectado..';
Frm_Principal.Timer_painel.Enabled:=true;
end;

procedure TData_Mysql.FDCon_MysqlLost(Sender: TObject);
begin
Frm_Principal.Timer_painel.Enabled:=true;
end;

procedure TData_Mysql.FDCon_MysqlRecover(ASender, AInitiator: TObject;
 AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
Var
ArqIni:Tinifile;
Mbanco,Mhost,Mporta,Musuario,Msenha:string;
i:integer;
begin
{2º
Se consegueir reconectar passa para o terceiro, senão ocorre o erro}
Frm_Principal.ImgStatusMysql.Picture.Create.LoadFromFile('.\imagem\DbRecurring.png');
Frm_Principal.Label_ecommerce.Caption:='e-commerce'+#13+'reconectando..';

end;

procedure TData_Mysql.FDCon_MysqlRestored(Sender: TObject);
VAR
Tpg,Tpgl:Thread;
begin
{3º
 Reconecta no banco de dados, reinicia a thread e para o temporizador de reconexão
}
Frm_Principal.Timer_painel.Enabled:=false;
Frm_Principal.ImgStatusMysql.Picture.Create.LoadFromFile('.\imagem\DbOn.png');
Frm_Principal.Label_ecommerce.Caption:='e-commerce';


              Tpg:=  Thread.Create(true);
              tpg.FreeOnTerminate:=true;
              tpg.Start;




end;

end.
