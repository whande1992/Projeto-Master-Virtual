unit Unt_Thread_Dupluicatas;

interface

uses
  System.Classes,IniFiles;

type
  Thread_duplicatas = class(TThread)
  protected
    procedure Execute; override;
  end;

implementation

{ 
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);  

  and UpdateCaption could look like,

    procedure Thread_duplicatas.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; 
    
    or 
    
    Synchronize( 
      procedure 
      begin
        Form1.Caption := 'Updated in thread via an anonymous method' 
      end
      )
    );
    
  where an anonymous method is passed.
  
  Similarly, the developer can call the Queue method with similar parameters as 
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.
    
}

uses Unt_Mysql, CadastroSerialPhp, Unt_Postgres, Unt_Funcoes, Unt_Principal,FireDAC.Comp.Client,
  Unt_Funcoes_ini,StrUtils,System.SysUtils,FireDAC.Stan.Param,DB;

{ Thread_duplicatas }

procedure Thread_duplicatas.Execute;
Var
{Arquivo de configuração}

empresa, pesquisa_cliente:string;

IQTDE_TENT_CONEXAO, Clientes_Atualizados,Clientes_restantes:Integer;

Registro_cadastro: TRegistrosPhp;

{Dados clientes ecommerce}
customer_id, customer_group_id, custom_field,cpf,cnpj:string;
cpf_cnpj:string;

{Dados do cliente ssplus}
nrodpl, letdpl, nronff, serie, clifor, valor, saldov,situacao:string;
dtemis, dtvcto:tdatetime;
dtpgto:TDate;

{Dados dos boletos vindos do ssplus}
codbanco, nosnum, localpagamento, cepsacado, ufsacado, linhadigitavel,
cidadesacado, codbarras, enderecosacado, cedente, nomesacado, agenciacodcedente,
instrucao3, datadocumento, instrucao2, documento, instrucao1, especie,
valordocumento, aceite, especiemoeda, dataprocessamento, carteira, instrucao4,
numparc, endereco_cedente, cnpj_cedente, agrupamento:string;
cobrancacorrespondente:boolean;

{Coenexao banco Mysql e Postgres}
MysqlDuplicatas, PgSqlDuplicatas:TFDConnection;

oc_customer, oc_ss_duplicatas_receber,oc_ss_duplicatas_new,oc_ss_boleto_new:TFDQuery   ;

contas_receber_view, ssplus_bloquetos:TFDQuery;

begin
  NameThreadForDebugging('Thread_duplicatas');
  { Place thread code here }

   Synchronize(
      procedure
      begin
       Frm_Principal.indDuplicatas.Animate := true;
       Frm_principal.lblDuplicatas_1.Caption:='Preparando conexão, aguarde..';
      end   );


   {MYSQL - Faz a conexão com o banco de dados em tempo de execução}
 IQTDE_TENT_CONEXAO:=1;
 while IQTDE_TENT_CONEXAO <= 10 do
  Begin
    Try
    MysqlDuplicatas := TFDConnection.Create(nil);
      with MysqlDuplicatas do
      begin
      Params.Values['Applicationname']:= Applicationname;
      Params.Values['DriverID']   := 'MySQL';
      Params.Values['Database']   := MysqlDB;
      Params.Values['User_name']  := MysqlUser;
      Params.Values['Password']   := MysqlPass;
      Params.Values['Server']     := MysqlHost;
      Params.Values['Port']       := MysqlPorta;
      Params.Values['LoginTimeout']:=LoginTimeout;
      Connected := True;
      end;
    except
     IQTDE_TENT_CONEXAO:=IQTDE_TENT_CONEXAO+1;
     Synchronize(  procedure
      begin
      frm_principal.lblDuplicatas_1.Caption:='Tentando conectar, tentativa '+IntToStr(IQTDE_TENT_CONEXAO)+' de 10..'
      end   );

    end;
    sleep(3000);
    if MysqlDuplicatas.Connected=true then Break
  end;


  {PGSql - Faz a conexão com o banco de dados em tempo de execução}
    IQTDE_TENT_CONEXAO:=1;
  while IQTDE_TENT_CONEXAO <= 10 do
  begin
    try
    PgSqlDuplicatas := TFDConnection.Create(nil);
    with PgSqlDuplicatas do
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
      end;
    except
    IQTDE_TENT_CONEXAO:=IQTDE_TENT_CONEXAO+1;
        Synchronize(  procedure
        begin
        frm_principal.lblDuplicatas_1.Caption:='Procurando conexão, tentativa '+IntToStr(IQTDE_TENT_CONEXAO)+' de 10..'
        end   );

    end;
    sleep(3000);
    if PgSqlDuplicatas.Connected=true then Break
    end;

   Synchronize(
      procedure
      begin
       Frm_principal.lblDuplicatas_1.Caption:='Pesquisando clientes com duplicatas para enviar';
       Frm_principal.lblDuplicatas_CliAll.Caption:='Clientes a verificar: 0';
       Frm_principal.lblDuplicatas_CliDpl.Caption:='Clientes com duplicatas: 0'
      end   );

   Clientes_Atualizados :=0;

   {Pesquisa os clientes cadastrados no ecommerce}
 oc_customer:=TFDQuery.Create(nil);
 oc_customer.Connection:=MysqlDuplicatas;
 oc_customer.Close;
 oc_customer.SQL.Clear;
 oc_customer.SQL.Add(' SELECT `customer_id`,`customer_group_id`, ' +
                            ' `custom_field`, `status` FROM '+MysqlPrefixo+'customer' +
                            ' WHERE `status`=''1''  ');
oc_customer.Open;

Clientes_restantes :=oc_customer.RecordCount;

Synchronize( procedure
      begin
       Frm_principal.lblDuplicatas_CliAll.Caption:='Clientes a verificar: '+IntToStr(Clientes_restantes);
      end   );

 {Executa o comando até acabar os clientes selecionados}
  While not oc_customer.eof do
begin
 Clientes_restantes:=Clientes_restantes-1;
Synchronize( procedure
      begin
       Frm_principal.lblDuplicatas_CliAll.Caption:='Clientes a verificar: '+IntToStr(Clientes_restantes);
      end   );

  {Atribui valor as variaveis}
  customer_id       := oc_customer.FieldByName('customer_id').AsString;
  customer_group_id := oc_customer.FieldByName('customer_group_id').AsString;
  custom_field      := oc_customer.FieldByName('custom_field').AsString;


  Registro_cadastro  := LinhaParaRegistros(custom_field);
  cpf                := Registro_cadastro[0].conteudo;
  cnpj               := Registro_cadastro[1].Conteudo;

  {Verifica se o cliente é pessoa fisica ou juridica
  1 = Pessoa fisica
  2 = Pessoa Jurifica }



  if customer_group_id ='1' then
  begin
  cpf_cnpj:= cpf;

  pesquisa_cliente:= ' SELECT nrodpl, letdpl, nronff, serie, clifor, dtemis, dtvcto, valor, ' +
                                   ' saldov, dtpgto FROM contas_receber_view WHERE  dupmov=''D'' AND  ' +
                                   ' dtemis > current_date - interval ''730 days'' AND empfil= :empfil AND' +
                                   ' clifor = (SELECT codigo from PCCDCLI0 where CONCAT(cgc1, cgc3) = :cpf_cnpj) '
  end
    else
  begin
  cpf_cnpj:=cnpj;

    pesquisa_cliente:= ' SELECT nrodpl, letdpl, nronff, serie, clifor, dtemis, dtvcto, valor, ' +
                                   ' saldov, dtpgto FROM contas_receber_view WHERE  dupmov=''D'' AND  ' +
                                   ' dtemis > current_date - interval ''730 days'' AND empfil= :empfil AND' +
                                   ' clifor = (SELECT codigo from PCCDCLI0 where CONCAT(cgc1,cgc2, cgc3) = :cpf_cnpj) '
  end;

  cpf_cnpj:= Unt_funcoes.RemoveZeros(cpf_cnpj) ;
  cpf_cnpj:= Unt_funcoes.tirapontos(cpf_cnpj) ;


   {Deleta duplicatas cadastradas do cliente para que não fique valores antigos}
 oc_ss_duplicatas_receber:=TFDQuery.Create(nil);
 oc_ss_duplicatas_receber.Connection:=MysqlDuplicatas;
 oc_ss_duplicatas_receber.Close;
 oc_ss_duplicatas_receber.SQL.Clear;
 oc_ss_duplicatas_receber.SQL.Add('DELETE FROM '+MysqlPrefixo+'ss_duplicatas_receber WHERE customer_id= :customer_id') ;
 oc_ss_duplicatas_receber.ParamByName('customer_id').AsString:=customer_id;
 oc_ss_duplicatas_receber.ExecSQL;




  {Pesquisa as duplicatas do cliente}
  contas_receber_view:=TFDQuery.Create(nil);
  contas_receber_view.Connection:=PgSqlDuplicatas;
  contas_receber_view.Close;
  contas_receber_view.SQL.Clear;
  contas_receber_view.SQL.Add(pesquisa_cliente);
  contas_receber_view.ParamByName('cpf_cnpj').AsString:=cpf_cnpj;
  contas_receber_view.ParamByName('empfil').AsString:=cfgEmpresa;
  contas_receber_view.Open();

  if (contas_receber_view.RecordCount = 0) then
  begin
  oc_customer.Next;
  continue;
  end;
  Clientes_Atualizados:= Clientes_Atualizados+1;

Synchronize( procedure
      begin
       Frm_principal.lblDuplicatas_1.Caption:='Atualizando duplicatas e bloquetos do cliente - '+customer_id;
       Frm_principal.lblDuplicatas_CliDpl.Caption:='Clientes com duplicatas:'+IntToStr(Clientes_Atualizados);
      end   );

  While not contas_receber_view.eof do
  Begin

  {Atribui valor das duplicatas em variaveis}
  nrodpl := contas_receber_view.FieldByName('nrodpl').AsString;
  letdpl := contas_receber_view.FieldByName('letdpl').AsString;
  nronff := contas_receber_view.FieldByName('nronff').AsString;
  serie  := contas_receber_view.FieldByName('serie').AsString;
  clifor := contas_receber_view.FieldByName('clifor').AsString;
  valor  := contas_receber_view.FieldByName('valor').AsString;
  saldov := contas_receber_view.FieldByName('saldov').AsString;
  dtemis := contas_receber_view.FieldByName('dtemis').AsDatetime;
  dtvcto := contas_receber_view.FieldByName('dtvcto').AsDatetime;
  dtpgto := contas_receber_view.FieldByName('dtpgto').AsDateTime;




  valor:=   TrocaVirgPPto(valor);


  {Se a duplicata estiver paga, o satatus fica como pago, senão pendente}
  if saldov > '0' then
  situacao:='Pendente'
  else
  situacao:='Pago';

  {Deleta duplicatas cadastradas do cliente}
  oc_ss_duplicatas_new:=TFDQuery.Create(nil);
  oc_ss_duplicatas_new.Connection:=MysqlDuplicatas;
  oc_ss_duplicatas_new.Close;
  oc_ss_duplicatas_new.SQL.Clear;
  oc_ss_duplicatas_new.SQL.Add(' INSERT INTO '+MysqlPrefixo+'ss_duplicatas_receber  ' +
  ' (customer_id, duplicata, serie, emissao, valor, vencimento, pagamento, situacao, cod_cliente_ss) ' +
                              ' VALUES  ' +
  ' (:customer_id, :duplicata, :serie, :emissao, :valor, :vencimento, :pagamento, :situacao, :cod_cliente_ss)');
  oc_ss_duplicatas_new.ParamByName('customer_id').AsString:=customer_id;
  oc_ss_duplicatas_new.ParamByName('duplicata').AsString:=nrodpl;
  oc_ss_duplicatas_new.ParamByName('serie').AsString:=letdpl;
  oc_ss_duplicatas_new.ParamByName('emissao').AsDateTime:=dtemis;
  oc_ss_duplicatas_new.ParamByName('valor').AsString:=valor;
  oc_ss_duplicatas_new.ParamByName('vencimento').AsDateTime:=dtvcto;
    if(dtpgto =0)then
    begin
    oc_ss_duplicatas_new.ParamByName('pagamento').DataType:=ftDate;
    oc_ss_duplicatas_new.ParamByName('pagamento').Clear;
   end else
  oc_ss_duplicatas_new.ParamByName('pagamento').AsDate:= dtpgto;

  oc_ss_duplicatas_new.ParamByName('situacao').AsString:=situacao;
  oc_ss_duplicatas_new.ParamByName('cod_cliente_ss').AsString:=clifor;
  oc_ss_duplicatas_new.ExecSQL;


  {Insere os dados para imprimir o boleto das duplicatas}
  ssplus_bloquetos:=TFDQuery.Create(nil);
  ssplus_bloquetos.Connection:=PgSqlDuplicatas;
  ssplus_bloquetos.Close;
  ssplus_bloquetos.SQL.Clear;
  ssplus_bloquetos.SQL.Add(' SELECT * FROM bloquetos_cliente_site WHERE ' +
                               ' nrodpl= :nrodpl and letdpl= :letdpl ');
  ssplus_bloquetos.ParamByName('nrodpl').AsString:=nrodpl;
  ssplus_bloquetos.ParamByName('letdpl').AsString:=letdpl;
  ssplus_bloquetos.Open;


   if(ssplus_bloquetos.RecordCount <> 0)then
  begin
  {Cptura os dados do boleto}
  codbanco          := ssplus_bloquetos.FieldByName('codbanco').AsString;
  nosnum            := ssplus_bloquetos.FieldByName('nosnum').AsString;
  localpagamento    := ssplus_bloquetos.FieldByName('localpagamento').AsString;
  cepsacado         := ssplus_bloquetos.FieldByName('cepsacado').AsString;
  ufsacado          := ssplus_bloquetos.FieldByName('ufsacado').AsString;
  linhadigitavel    := ssplus_bloquetos.FieldByName('linhadigitavel').AsString;
  cidadesacado      := ssplus_bloquetos.FieldByName('cidadesacado').AsString;
  codbarras         := ssplus_bloquetos.FieldByName('codbarras').AsString;
  enderecosacado    := ssplus_bloquetos.FieldByName('enderecosacado').AsString;
  cedente           := ssplus_bloquetos.FieldByName('cedente').AsString;
  nomesacado        := ssplus_bloquetos.FieldByName('nomesacado').AsString;
  agenciacodcedente := ssplus_bloquetos.FieldByName('agenciacodcedente').AsString;
  instrucao3        := ssplus_bloquetos.FieldByName('instrucao3').AsString;
  datadocumento     := ssplus_bloquetos.FieldByName('datadocumento').AsString;
  instrucao2        := ssplus_bloquetos.FieldByName('instrucao2').AsString;
  documento         := ssplus_bloquetos.FieldByName('documento').AsString;
  instrucao1        := ssplus_bloquetos.FieldByName('instrucao1').AsString;
  especie           := ssplus_bloquetos.FieldByName('especie').AsString;
  valordocumento    := ssplus_bloquetos.FieldByName('valordocumento').AsString;
  aceite            := ssplus_bloquetos.FieldByName('aceite').AsString;
  especiemoeda      := ssplus_bloquetos.FieldByName('especiemoeda').AsString;
  dataprocessamento := ssplus_bloquetos.FieldByName('dataprocessamento').AsString;
  carteira          := ssplus_bloquetos.FieldByName('carteira').AsString;
  instrucao4        := ssplus_bloquetos.FieldByName('instrucao4').AsString;
  numparc           := ssplus_bloquetos.FieldByName('numparc').AsString;
  endereco_cedente  := ssplus_bloquetos.FieldByName('endereco_cedente').AsString;
  cnpj_cedente      := ssplus_bloquetos.FieldByName('cnpj_cedente').AsString;
  agrupamento       := ssplus_bloquetos.FieldByName('agrupamento').AsString;
  cobrancacorrespondente:= ssplus_bloquetos.FieldByName('cobrancacorrespondente').AsBoolean;

  {Atualiza a tabela de duplictas}
  oc_ss_boleto_new:=TFDQuery.Create(nil);
  oc_ss_boleto_new.Connection:=MysqlDuplicatas;
  oc_ss_boleto_new.Close;
  oc_ss_boleto_new.SQL.Clear;
  oc_ss_boleto_new.SQL.Add('UPDATE '+MysqlPrefixo+'ss_duplicatas_receber SET ' +
  ' codbanco = :codbanco , nosnum = :nosnum , localpagamento = :localpagamento   , cepsacado = :cepsacado , ' +
  ' ufsacado = :ufsacado , linhadigitavel = :linhadigitavel , cidadesacado = :cidadesacado , ' +
  ' codbarras = :codbarras , enderecosacado = :enderecosacado , cedente = :cedente , ' +
  ' nomesacado = :nomesacado , agenciacodcedente = :agenciacodcedente , instrucao3 = :instrucao3 ,' +
  ' datadocumento = :datadocumento , instrucao2 = :instrucao2 , documento = :documento , ' +
  ' instrucao1 = :instrucao1 , especie = :especie , valordocumento = :valordocumento , ' +
  ' aceite = :aceite , especiemoeda = :especiemoeda , dataprocessamento = :dataprocessamento ,' +
  ' carteira = :carteira , instrucao4 = :instrucao4 , numparc = :numparc , ' +
  ' endereco_cedente = :endereco_cedente , cnpj_cedente = :cnpj_cedente , agrupamento = :agrupamento ,' +
  ' cobrancacorrespondente = :cobrancacorrespondente, vencimento= :vencimento' +
  ' WHERE duplicata= :nrodpl and serie= :letdpl ' );
  oc_ss_boleto_new.ParamByName('codbanco').AsString:=codbanco     ;
  oc_ss_boleto_new.ParamByName('nosnum').AsString:= nosnum   ;
  oc_ss_boleto_new.ParamByName('localpagamento').AsString:=localpagamento    ;
  oc_ss_boleto_new.ParamByName('cepsacado').AsString:= cepsacado   ;
  oc_ss_boleto_new.ParamByName('ufsacado').AsString:= ufsacado   ;
  oc_ss_boleto_new.ParamByName('linhadigitavel').AsString:=linhadigitavel    ;
  oc_ss_boleto_new.ParamByName('cidadesacado').AsString:= cidadesacado   ;
  oc_ss_boleto_new.ParamByName('codbarras').AsString:= codbarras   ;
  oc_ss_boleto_new.ParamByName('enderecosacado').AsString:= enderecosacado   ;
  oc_ss_boleto_new.ParamByName('cedente').AsString:=cedente    ;
  oc_ss_boleto_new.ParamByName('nomesacado').AsString:=nomesacado    ;
  oc_ss_boleto_new.ParamByName('agenciacodcedente').AsString:=agenciacodcedente    ;
  oc_ss_boleto_new.ParamByName('instrucao3').AsString:=instrucao3    ;
  oc_ss_boleto_new.ParamByName('datadocumento').AsString:= datadocumento   ;
  oc_ss_boleto_new.ParamByName('instrucao2').AsString:=instrucao2    ;
  oc_ss_boleto_new.ParamByName('documento').AsString:= documento   ;
  oc_ss_boleto_new.ParamByName('instrucao1').AsString:=instrucao1    ;
  oc_ss_boleto_new.ParamByName('especie').AsString:= especie   ;
  oc_ss_boleto_new.ParamByName('valordocumento').AsString:=valordocumento    ;
  oc_ss_boleto_new.ParamByName('aceite').AsString:=aceite    ;
  oc_ss_boleto_new.ParamByName('especiemoeda').AsString:=especiemoeda    ;
  oc_ss_boleto_new.ParamByName('dataprocessamento').AsString:=dataprocessamento    ;
  oc_ss_boleto_new.ParamByName('carteira').AsString:=carteira    ;
  oc_ss_boleto_new.ParamByName('instrucao4').AsString:= instrucao4   ;
  oc_ss_boleto_new.ParamByName('numparc').AsString:= numparc   ;
  oc_ss_boleto_new.ParamByName('endereco_cedente').AsString:=endereco_cedente    ;
  oc_ss_boleto_new.ParamByName('cnpj_cedente').AsString:=cnpj_cedente    ;
  oc_ss_boleto_new.ParamByName('agrupamento').AsString:= agrupamento   ;
  oc_ss_boleto_new.ParamByName('cobrancacorrespondente').AsBoolean:= cobrancacorrespondente   ;
  oc_ss_boleto_new.ParamByName('vencimento').AsDateTime:= dtvcto   ;
  oc_ss_boleto_new.ParamByName('nrodpl').AsString:= nrodpl   ;
  oc_ss_boleto_new.ParamByName('letdpl').AsString:= letdpl   ;
  oc_ss_boleto_new.ExecSQL;


  end;


  {Passa para proxima duplicata}
  contas_receber_view.Next;
   continue;




  End;

{Após cadastrar as duplicata do cliente, passa para o proximo cliente}
oc_customer.Next;
 continue;


end;


  Synchronize(
      procedure
      begin
        frm_principal.lblDuplicatas_1.Caption:='Ultima atualização '+TimeToStr(time()) ;
        Frm_Principal.indDuplicatas.Animate := false;

      end
      );











end;

end.
