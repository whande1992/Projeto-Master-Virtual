unit Unt_Exporta_Registros;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids;

type
  Tfrm_Exporta_Registros = class(TForm)
    PN_Consulta: TPanel;
    Group_Consulta: TGroupBox;
    Edit_descricao: TEdit;
    Button1: TButton;
    Combo_Ativo: TComboBox;
    Label1: TLabel;
    PN_Altera_Produto: TPanel;
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    Edit_Nome_Produto: TEdit;
    Label2: TLabel;
    Edit_Meta_Tag: TEdit;
    Label3: TLabel;
    Edit_Modelo_produto: TEdit;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Edit1: TEdit;
    Edit_Peso: TEdit;
    Edit_C: TEdit;
    Edit_L: TEdit;
    Edit_A: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Button2: TButton;
    GroupBox3: TGroupBox;
    Label8: TLabel;
    Edit_desconto: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Exporta_Registros: Tfrm_Exporta_Registros;

implementation

{$R *.dfm}

uses Unt_Postgres;

procedure Tfrm_Exporta_Registros.Button1Click(Sender: TObject);
VAR
ativo,sql1,sql2,sql3:STRING;


begin
 //Ativos no e-commerce ou não
  if (Combo_Ativo.Text = 'Ativos') then
  sql2:=' envia_site= ''t'' ' else
  sql2:=' envia_site= ''f'' ';

sql1:='SELECT codigo,ativo, marca, descr1, secao, grupo, subgru, dessub, codire, prvist, basico, ualter_a, localiza, cancelado, aplica,envia_site, desconto_ecommerce FROM PCCDITE0 WHERE ';
sql3:= ' AND (codigo= :codigo OR codire= :codire OR basico= :basico OR descr1 LIKE :descr1)';
Data_postgres.Query_produtos.Close;
Data_postgres.Query_produtos.SQL.Clear;
Data_postgres.Query_produtos.SQL.Add(sql1 + sql2 + SQL3);
//Data_postgres.Query_produtos.ParamByName('ativo').AsBoolean:=ativo;
Data_postgres.Query_produtos.ParamByName('codigo').ASstring:= Edit_descricao.Text;
Data_postgres.Query_produtos.ParamByName('codire').ASstring:= Edit_descricao.text;
Data_postgres.Query_produtos.ParamByName('basico').ASstring:= Edit_descricao.text;
Data_postgres.Query_produtos.ParamByName('descr1').ASstring:= '%'+Edit_descricao.text+'%';
Data_postgres.Query_produtos.Open;




end;

procedure Tfrm_Exporta_Registros.Button2Click(Sender: TObject);
VAR
AUX:STRING;
begin
Data_postgres.Query_produtos.First;
While not Data_postgres.Query_produtos.Eof do
begin
if DBGrid1.SelectedRows.IndexOf(Data_postgres.Query_produtos.BookMark) >= 0 then
AUX:=Data_postgres.Query_produtos.FieldByName('codigo').AsString;
ShowMessage('Registro selecionado' + AUX);
Data_postgres.Query_produtos.Next;




//VAR
//i: Integer; aux: string;
//begin
//for i := 0 to DBGrid1.SelectedRows.Count - 1 do
//begin

//Data_postgres.Query_produtos.GotoBookmark(pointer(DBGrid1.SelectedRows.Items[i]));
//aux := aux + '''' + Data_postgres.Query_produtos.FieldByName('codigo').AsString + '''' + ','  ;
//end; ShowMessage('Linhas selecionadas: ' + #13 + aux);
// PEGA LINHAS DO DB GRID
//Leia mais em: Utilizando MultiSelect no DBGrid em Delphi http://www.devmedia.com.br/utilizando-multiselect-no-dbgrid-em-delphi/3161#ixzz3k2Lkpef1

//ATUALIZA DADOS NO POSTGRES
//Data_postgres.UPdate_Produtos.Close;
//Data_postgres.UPdate_Produtos.SQL.Clear;
//Data_postgres.UPdate_Produtos.SQL.Add('UPDATE PCCDITE0 SET localiza= :DESCONTO WHERE CODIGO IN (:codigo)');
//Data_postgres.UPdate_Produtos.ParamByName('DESCONTO').Value:=Edit_desconto.Text;
//Data_postgres.UPdate_Produtos.ParamByName('codigo').AsString:=aux;
//Data_postgres.UPdate_Produtos.ExecSQL;
//SHOWMESSAGE(aux);


           end;


end;

procedure Tfrm_Exporta_Registros.FormActivate(Sender: TObject);
begin
Data_postgres.Query_produtos.Close;
Data_postgres.Query_produtos.SQL.Clear;
edit_descricao.Clear;
end;

end.
