unit Unt_Thread_pedidos;

interface

uses
  System.Classes,IniFiles,Vcl.Graphics,System.SysUtils,FireDAC.Stan.Param,DB,FireDAC.Comp.Client;

type

  TiposPhpCadastro = (phpCPF=1, phpRG, phpCNPJ, phpInscricao, phpRazaoSocial, phpDataNascimento, phpNumero);

  thread_pedidos = class(TThread)
  protected
    procedure Execute; override;
  end;

implementation

{ 
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);  

  and UpdateCaption could look like,

    procedure thread_pedidos.UpdateCaption;
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

uses Unt_Mysql, Unt_Principal, CadastroSerialPhp, EnderecoSerialPhp,
  Unt_Postgres, Unt_Funcoes, Unt_Funcoes_ini;

{ thread_pedidos }

procedure thread_pedidos.Execute;
VAR

{Arquivo de configuração}
ArqIni:Tinifile;
token, resposta:string;
{Pedidos}
 customer_id, order_status_id, observacao, pago, forma_pagamento:string;
data_ped:tdatetime;
order_id, pedidos_total, pedidos_enviados:integer;

{Produtos}
cod_produto:string;
produto:integer;
quantidade, IQTDE_TENT_CONEXAO:integer;
valor:Currency;


{Variaveis do cadastro de clientes}
razao_social, nome_completo, primeiro_nome, segundo_nome, cpf, cnpj,cpf_cnpj,email,telefone_principal,situacao_cadastral, endereco_cadastral, numero_endereco,
cidade_residencial,cep_residencial, pais, estado, inscricao_estadual, rg, limite_financeiro, bairro, tipoPessoa,
PedidoStatus,StatusPosImportado:string;
cadastros_php, endereco_php,endereco_serializado,atualiza,resposta_cliente:string;
Registro_cadastro: TRegistrosPhp;
Registro_endereco: TRegistros_enderecoPhp;

MysqlPedConn, PgSqlPenConn:TFDConnection;
oc_order,oc_order_product,oc_order_history:TFDQuery;
f_ecommerce_cliente,f_ecommerce_insere_pedido:TFDQuery;
Transaction_pedido:TFDTransaction;
{Dados principais}

begin
  NameThreadForDebugging('pedidos');

  Synchronize(procedure begin
  Frm_principal.lbl_pedido.Caption    :='Carregando conexões, aguarde..';
  frm_principal.indPedidos.Animate:=true;
  end);


  {MYSQL - Faz a conexão com o banco de dados em tempo de execução}
 IQTDE_TENT_CONEXAO:=1;
 while IQTDE_TENT_CONEXAO <= 10 do
  Begin
    Try
    MysqlPedConn := TFDConnection.Create(nil);
      with MysqlPedConn do
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
      On E:Exception do Begin
      IQTDE_TENT_CONEXAO:=IQTDE_TENT_CONEXAO+1;
       Synchronize(  procedure
        begin
        frm_principal.lbl_pedido.Caption:='Tentando conectar, tentativa '+IntToStr(IQTDE_TENT_CONEXAO)+' de 10..' ;
        erros_log('', 119, '', '', '','Conexão Mysql', E.Message );
        end);
      end;
    end;
    sleep(3000);
    if MysqlPedConn.Connected=true then Break
  end;


  {PGSql - Faz a conexão com o banco de dados em tempo de execução}
    IQTDE_TENT_CONEXAO:=1;
  while IQTDE_TENT_CONEXAO <= 10 do
  begin
    try
    PgSqlPenConn := TFDConnection.Create(nil);
    with PgSqlPenConn do
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
      On E:Exception do Begin
      IQTDE_TENT_CONEXAO:=IQTDE_TENT_CONEXAO+1;
        Synchronize(  procedure
        begin
        frm_principal.lbl_pedido.Caption:='Procurando conexão, tentativa '+IntToStr(IQTDE_TENT_CONEXAO)+' de 10..';
        erros_log('', 140, '', '', '','Conexão Postgres', E.Message );
        end);

      end;
    end;
    sleep(3000);
    if PgSqlPenConn.Connected=true then Break
    end;

   Try
    Transaction_pedido:=TFDTransaction.Create(nil);
    Transaction_pedido.Connection:=PgSqlPenConn;
    f_ecommerce_insere_pedido:=TFDQuery.Create(nil);
    f_ecommerce_insere_pedido.Connection:=PgSqlPenConn;
    f_ecommerce_insere_pedido.Transaction:=Transaction_pedido;
   except
    On E:Exception do Begin
    erros_log('', 165, '', '', '','Cria transaction e F_ecommerce_insere_pedido', E.Message );
    end ;
   end;


  { Inserir o codigo do conteudo a baixo. }

  {Faz a leitura do arquivo de configuração}


  {Verifica em qual status o pedido será importado}
  if Pos('Aguardando pagamento'   , cfgPedidoStatus) <> 0 then PedidoStatus:='1';
  if Pos('Pagamento confirmado'   , cfgPedidoStatus) <> 0 then PedidoStatus:='2';
  if Pos('Aguardando faturamento' , cfgPedidoStatus) <> 0 then PedidoStatus:='3';
  if Pos('Nota fiscal emitida'    , cfgPedidoStatus) <> 0 then PedidoStatus:='4';
  if Pos('Preparado para envio'   , cfgPedidoStatus) <> 0 then PedidoStatus:='5';
  if Pos('Enviado para transportadora' , cfgPedidoStatus) <> 0 then PedidoStatus:='6';

    {Verifica em qual status o pedido será depois de importado}
  if Pos('Aguardando pagamento'   , cfgStatusPosImportado) <> 0 then StatusPosImportado:='1';
  if Pos('Pagamento confirmado'   , cfgStatusPosImportado) <> 0 then StatusPosImportado:='2';
  if Pos('Aguardando faturamento' , cfgStatusPosImportado) <> 0 then StatusPosImportado:='3';
  if Pos('Nota fiscal emitida'    , cfgStatusPosImportado) <> 0 then StatusPosImportado:='4';
  if Pos('Preparado para envio'   , cfgStatusPosImportado) <> 0 then StatusPosImportado:='5';
  if Pos('Enviado para transportadora' , cfgStatusPosImportado) <> 0 then StatusPosImportado:='6';
  if Pos('Não atualizar status no e-commerce' , cfgStatusPosImportado) <> 0 then StatusPosImportado:='9999';



  try
 {Faz a seleção dos pedidos no e-commerce}
 oc_order:= TFDQuery.Create(nil);
 oc_order.Connection:=MysqlPedConn;
 oc_order.Close;
 oc_order.SQL.Clear;
 oc_order.SQL.Add('SELECT * FROM '+MysqlPrefixo+'order where order_status_id= :order_status_id');
 oc_order.ParamByName('order_status_id').AsString:=PedidoStatus ;
 oc_order.Open;
 except
  On E:Exception do Begin
  erros_log('', 190, 'Selecina os pedidos do e-commerce', '', '','Select  Oc_order', E.Message );
  end;
 end;
 {mostra os pedidos que ja foram enviados.}
 pedidos_enviados:=0;

 {mostra o total de pedidos no painel}
 Synchronize(procedure begin
 frm_principal.lbl_mostra_ped.caption:=IntToStr(oc_order.RecordCount);
 frm_principal.lbl_clientes.caption:='Pesquisando pedidos e clientes no e-commerce..';
 frm_principal.lbl_mostra_ped_enviados.Caption:= inttostr(pedidos_enviados)
 end);



 if (oc_order.RecordCount < 1 ) then
 begin
 {caso não encontre pedidos para importar}
  Synchronize(procedure begin
  frm_principal.lbl_clientes.Caption:='Nenhum pedido disponivel para importação.';
  Frm_principal.lbl_pedido.Caption    :='Ultima verificação'+TimetoStr(time());
  frm_principal.indPedidos.Animate:=false;
  end);
 end else

 begin
 {Codigo quando retornar registros do ecommerce.}
 {Enquanto não terminar os registros executa o codigo a baixo.}
 While not oc_order.eof do
  begin

   try
    {CADASTRO - Pega os valores dos campos persinalizados do e-commerce.}
    cadastros_php      := oc_order.FieldByName('custom_field').AsString;
    Registro_cadastro  := LinhaParaRegistros(cadastros_php) ;
    cpf                := Registro_cadastro[0].Conteudo;
    cnpj               := Registro_cadastro[1].Conteudo;
    inscricao_estadual := Registro_cadastro[2].Conteudo;
    rg                 := Registro_cadastro[4].Conteudo;
    razao_social       := Registro_cadastro[5].Conteudo;
   except
    On E:Exception do Begin
    erros_log('', 230, '', '', '','Dados serializados cadastro', E.Message );
    end;
   end;


   try
    endereco_serializado := oc_order.FieldByName('shipping_custom_field').AsString;
    Registro_endereco  := LinhaRegistrosEndereco(endereco_serializado);
    numero_endereco    := Registro_endereco[0].Conteudo_endereco;
   except
    On E:Exception do begin
     erros_log('', 245, '', '', '','Dados serializados endereço', E.Message );
    end;
   end;




   try
   primeiro_nome       := oc_order.FieldByName('firstname').AsString;
   segundo_nome        := oc_order.FieldByName('lastname').AsString;
   email               := oc_order.FieldByName('email').AsString;
   telefone_principal  := oc_order.FieldByName('telephone').AsString;
   endereco_cadastral  := oc_order.FieldByName('shipping_address_1').AsString;
   cidade_residencial  := oc_order.FieldByName('shipping_city').AsString;
   cep_residencial     := oc_order.FieldByName('shipping_postcode').AsString;
   bairro              := oc_order.FieldByName('shipping_address_2').AsString;
   pais                := oc_order.FieldByName('shipping_country').AsString;
   estado              := oc_order.FieldByName('shipping_zone').AsString;
   tipoPessoa:= oc_order.FieldByName('customer_group_id').AsString;

   except
    On E:Exception do Begin
    erros_log('', 260, '', '', '','Atribui valor as variaveis com dados do pedido', E.Message );
    end;
   end;

   try
   {Remove caracteres especiais}
   rg  :=TrocaCaracterEspecial(rg,true,true) ;
   telefone_principal  :=TrocaCaracterEspecial(telefone_principal,true,true) ;
   cidade_residencial  :=TrocaCaracterEspecial(cidade_residencial,true,false) ;
   cep_residencial  :=TrocaCaracterEspecial(cep_residencial,true,true) ;
   bairro  :=TrocaCaracterEspecial(bairro,true,false) ;
   except
    On E:Exception do Begin
    erros_log('', 280, '', '', '','Executa funções para ajustar variaveis', E.Message );
    end;
    end;


    if Pos('Brasil',pais)<> 0  then pais:='BRA';
    if Pos('Acre'                 , estado) <> 0 then estado:='AC';
    if Pos('Alagoas'              , estado) <> 0 then estado:='AL';
    if Pos('Amazonas'             , estado) <> 0 then estado:='AM';
    if Pos('Amapá'                , estado) <> 0 then estado:='AP';
    if Pos('Bahia'                , estado) <> 0 then estado:='BA';
    if Pos('Ceará'                , estado) <> 0 then estado:='CE';
    if Pos('Distrito Federal'     , estado) <> 0 then estado:='DF';
    if Pos('Espírito Santo'       , estado) <> 0 then estado:='ES';
    if Pos('Goiás'                , estado) <> 0 then estado:='GO';
    if Pos('Maranhão'             , estado) <> 0 then estado:='MA';
    if Pos('Minas Gerais'         , estado) <> 0 then estado:='MG';
    if Pos('Mato Grosso do Sul'   , estado) <> 0 then estado:='MS';
    if Pos('Mato Grosso'          , estado) <> 0 then estado:='MT';
    if Pos('Pará'                 , estado) <> 0 then estado:='PA';
    if Pos('Paraíba'              , estado) <> 0 then estado:='PB';
    if Pos('Pernambuco'           , estado) <> 0 then estado:='PE';
    if Pos('Piauí'                , estado) <> 0 then estado:='PI';
    if Pos('Paraná'               , estado) <> 0 then estado:='PR';
    if Pos('Rio de Janeiro'       , estado) <> 0 then estado:='RJ';
    if Pos('Rio Grande do Norte'  , estado) <> 0 then estado:='RN';
    if Pos('Rondônia'             , estado) <> 0 then estado:='RO';
    if Pos('Roraima'              , estado) <> 0 then estado:='RR';
    if Pos('Rio Grande do Sul'    , estado) <> 0 then estado:='RS';
    if Pos('Santa Catarina'       , estado) <> 0 then estado:='SC';
    if Pos('Sergipe'              , estado) <> 0 then estado:='SE';
    if Pos('São Paulo'            , estado) <> 0 then estado:='SP';
    if Pos('Tocantis'             , estado) <> 0 then estado:='TO';

  // Verifica se é pessoa fisica(1) ou juridica(2)

  if (tipoPessoa='1') then
    begin
    nome_completo:= primeiro_nome+' '+ Segundo_nome;
    cpf_cnpj     := cpf;
    {remove os caracteres especiais}
    nome_completo:=TrocaCaracterEspecial(nome_completo,true,false);
    cpf_cnpj  :=TrocaCaracterEspecial(cpf_cnpj,true,true) ;
    end
        else if tipoPessoa='2' then

    begin
    nome_completo:= razao_social;
    cpf_cnpj     := cnpj;
    {remove os caracteres especiais}
    nome_completo:=TrocaCaracterEspecial(nome_completo,true,false);
    cpf_cnpj  :=TrocaCaracterEspecial(cpf_cnpj,true,true) ;
    end;


   try
    {ABRE UMA TRANSAÇÃO}
   f_ecommerce_cliente:=TFDQuery.Create(nil);
   f_ecommerce_cliente.Connection:=PgSqlPenConn;
   f_ecommerce_cliente.close;
   f_ecommerce_cliente.SQL.Clear;
   f_ecommerce_cliente.SQL.Add('begin transaction');   // Abre uma transação no postgres
   f_ecommerce_cliente.ExecSQL;
   except
    On E:Exception do Begin
    erros_log('', 340, '', '', '','Abre transação para cadastrar o cliente', E.Message );
    end;
   end;

   try
    {Captura o token para cadastrar o cliente}
    f_ecommerce_cliente.SQL.Clear;
    f_ecommerce_cliente.SQL.Add(' SELECT f_ecommerce_token() ');
    f_ecommerce_cliente.Open();
    Token:= f_ecommerce_cliente.FieldByName('f_ecommerce_token').AsString;
    except
    On E:Exception do Begin
    erros_log('', 360, '', '', '','Gera o token para cadastrar cliente', E.Message );
    end;
    end;


    Synchronize(procedure begin
        frm_principal.lbl_clientes.Caption:='Enviando informações do cliente para o SSPlus';
    end);

   Try
   {Cadastra o cliente no SSPlus}
    f_ecommerce_cliente.SQL.Clear;
    f_ecommerce_cliente.SQL.Add(' SELECT f_ecommerce_cliente(' +
                                             ':token        ,' +
                                             ':nome_razao   ,' +
                                             ':cfp_cnpj     ,' +
                                             ':email        ,' +
                                             ':telefone     ,' +
                                             ':situacao     ,' +
                                             ':endereco     ,' +
                                             ':numero_end   ,' +
                                             ':cidade       ,' +
                                             ':cep          ,' +
                                             ':pais         ,' +
                                             ':estado       ,' +
                                             ':ie           ,' +
                                             ':rg           ,' +
                                             ':limite_fin   ,' +
                                             ':telefone2      ,' +
                                             ':bairro       ,' +
                                             ':atualiza )'    );
   f_ecommerce_cliente.ParamByName('token').AsString:=Token;
   f_ecommerce_cliente.ParamByName('nome_razao').AsString:=nome_completo;
   f_ecommerce_cliente.ParamByName('cfp_cnpj').AsString:=cpf_cnpj;
   f_ecommerce_cliente.ParamByName('email').AsString:=email;
   f_ecommerce_cliente.ParamByName('telefone').AsString:=telefone_principal;
   f_ecommerce_cliente.ParamByName('situacao').AsString:='A';
   f_ecommerce_cliente.ParamByName('endereco').AsString:=endereco_cadastral;
   f_ecommerce_cliente.ParamByName('numero_end').AsInteger:=StrToInt(numero_endereco);
   f_ecommerce_cliente.ParamByName('cidade').AsString:=cidade_residencial;
   f_ecommerce_cliente.ParamByName('cep').AsString:=cep_residencial;
   f_ecommerce_cliente.ParamByName('pais').AsString:=pais;
   f_ecommerce_cliente.ParamByName('estado').AsString:=estado;
   f_ecommerce_cliente.ParamByName('ie').AsString:=inscricao_estadual;
   f_ecommerce_cliente.ParamByName('rg').AsString:=Rg;
   f_ecommerce_cliente.ParamByName('limite_fin').AsInteger:=StrToInt(cfgCliLimFinanceiro);
   f_ecommerce_cliente.ParamByName('bairro').AsString:=bairro;
   f_ecommerce_cliente.ParamByName('telefone2').AsString:=telefone_principal;
   f_ecommerce_cliente.ParamByName('atualiza').AsString:=cfgUpCliente;
   f_ecommerce_cliente.open;


   Resposta_cliente:=f_ecommerce_cliente.FieldByName('f_ecommerce_cliente').AsString;
   {mensagem se o cliente foi cadastrado com sucesso}
            if pos('SSECOM+0001',resposta_cliente)<> 0 then
            begin
              Synchronize(procedure begin
             Frm_principal.lbl_clientes.Caption:='Cliente cadastrado com sucesso.';
             end);
             f_ecommerce_cliente.SQL.Clear;
             f_ecommerce_cliente.SQL.Add(' commit ');
             f_ecommerce_cliente.ExecSQL;
             f_ecommerce_cliente.Free;
            end    else
  {mensagem se o cliente foi atualizado com sucesso}
            if pos('SSECOM+0002',resposta_cliente)<> 0 then
            begin
              Synchronize(procedure begin
             Frm_principal.lbl_clientes.Caption:='Cliente atualizado com sucesso.';
             end);
             f_ecommerce_cliente.SQL.Clear;
             f_ecommerce_cliente.SQL.Add(' commit ');
             f_ecommerce_cliente.ExecSQL;
             f_ecommerce_cliente.Free;

            end  else
  {Erro não catalogado}  {===passa para o proximo pedido===}
           if pos('SSECOM-9999',resposta_cliente)<> 0 then
            begin
              Synchronize(procedure begin
              Frm_principal.lbl_clientes.Caption:='Não foi possivel cadastrar o cliente';
              end);
            f_ecommerce_cliente.SQL.Clear;
            f_ecommerce_cliente.SQL.Add(' rollback ');
            f_ecommerce_cliente.ExecSQL;
            f_ecommerce_cliente.Free;
            oc_order.Next;
            continue
            end else
  {Quando o token é invalido}   {===passa para o proximo pedido===}
             if pos('SSECOM-1022',resposta_cliente)<>0 then
            begin
              Synchronize(procedure begin
              Frm_principal.lbl_clientes.Caption:='Token inválido, informe ao suporte.';
              end);
            f_ecommerce_cliente.SQL.Clear;
            f_ecommerce_cliente.SQL.Add(' rollback ');
            f_ecommerce_cliente.ExecSQL;
            f_ecommerce_cliente.Free;
            oc_order.Next;
            continue
            end else
  {Quando o cliente foi configurado para não ser atualizado}
            if pos('SSECOM+0003',resposta_cliente)<>0 then
            begin
              Synchronize(procedure begin
             Frm_principal.lbl_clientes.Caption:='Cliente validado com sucesso.';
             end);
             f_ecommerce_cliente.SQL.Clear;
             f_ecommerce_cliente.SQL.Add(' commit ');
             f_ecommerce_cliente.ExecSQL;
             f_ecommerce_cliente.Free;
            end;


   {Inicia o caadastro do pedido no SSplus}

   {Recebe o valor da tabela OC_ORDER, (Foi feito select no inicio)
   agora só recebe os parametros}
   order_id   := oc_order.FieldByName('order_id').Value;
   pago       := oc_order.FieldByName('payment_method').Value;
   data_ped   := oc_order.FieldByName('date_added').AsDateTime;

   {Caso ocorra algum problema para executar o cadastro do cliente}
    except
     On E:Exception do Begin
     erros_log('380-480', 380, '', '', '','Cadastra o cliente', E.Message );
     f_ecommerce_cliente.SQL.Clear;
     f_ecommerce_cliente.SQL.Add(' rollback ');
     f_ecommerce_cliente.ExecSQL;
     f_ecommerce_cliente.Free;
     {passa para o proximo pedido}
     oc_order.Next;
     continue
     end;
    End;




   try
    {Pesquisa os produtos do pedido no e-commerce}
    oc_order_product:=TFDQuery.Create(nil);
    oc_order_product.Connection:=MysqlPedConn;
    oc_order_product.close;
    oc_order_product.SQL.Clear;
    oc_order_product.SQL.Add('SELECT * FROM '+MysqlPrefixo+'order_product WHERE' +
                                              ' order_id= :order_id ' );
    oc_order_product.ParamByName('order_id').AsInteger:=order_id;
    oc_order_product.Open();
   except
    On E:Exception do Begin
    erros_log('', 500, '', '', '','Pesquisa os produtos do pedido', E.Message );
    end;
   end;

    {cadastra todos os produtos do pedido,
    não para de inserir enquanto não acabar os produtos}





    {Abre uma transação}









    {Data_Postgres.f_ecommerce_insere_pedido.Close;
    Data_Postgres.f_ecommerce_insere_pedido.SQL.Clear;
    Data_Postgres.f_ecommerce_insere_pedido.SQL.Add(' begin transaction ');
    Data_Postgres.f_ecommerce_insere_pedido.ExecSQL;   }



    {Gera um novo Token para o pedido}
   try
    Transaction_pedido.Active;
    Transaction_pedido.StartTransaction;

    f_ecommerce_insere_pedido.SQL.Clear;
    f_ecommerce_insere_pedido.SQL.Add(' SELECT F_ecommerce_token() ') ;
    f_ecommerce_insere_pedido.Open;

    Token:= f_ecommerce_insere_pedido.FieldByName('f_ecommerce_token').AsString;
    except
    On E:Exception do Begin
    erros_log('', 540, '', '', '','Gera o token para cadastrar produtos no pedido', E.Message );
    end;
    end ;
    if oc_order_product.RecordCount < 1 then oc_order_product.Free;


    While not oc_order_product.eof do
    begin
      Synchronize(procedure begin
      frm_principal.lbl_pedido.Caption:='Importando pedido para o SSplus';
      end);
    {Captura os dados dos produtos inseridos no pedido
    do e-commerce para cadastrar no postgres.}

      produto     := oc_order_product.FieldByName('product_id').asinteger;
      quantidade  := oc_order_product.FieldByName('quantity').AsInteger;
      valor       := oc_order_product.FieldByName('price').AsCurrency;

    {Deixa o codigo do produto com 6 digitos.}
    cod_produto:=FormatFloat(StringofChar('0', 6), produto);


    {Insere o pedido}
      try
     {inicia o processo}
     f_ecommerce_insere_pedido.SQL.Clear;
     f_ecommerce_insere_pedido.SQL.Add('select f_ecommerce_insere_pedido (' +
                                                   ' :token     ,' +
                                                   ' :empresa   ,' +   {Cod. empresa no SSplus}
                                                   ' :pedido    ,' +
                                                   ' :cpf_cnpj  ,' +
                                                   ' :produto   ,' +
                                                   ' :quantidade,' +
                                                   ' :valor_unt ,' +
                                                   ' :obs       ,' +
                                                   ' :pago      ,' +    {Informações textuais sobre pagamento}
                                                   ' :forma_pag ,' +    {Forma de pagamento no SSplus}
                                                   ' :data_ped  ); ' ) ;  {Data realização do pedido no e-commerce}
     f_ecommerce_insere_pedido.ParamByName('token').AsString:=token;
     f_ecommerce_insere_pedido.ParamByName('empresa').AsString:=cfgEmpresa;
     f_ecommerce_insere_pedido.ParamByName('pedido').AsInteger:=order_id;
     f_ecommerce_insere_pedido.ParamByName('cpf_cnpj').AsString:=cpf_cnpj;
     f_ecommerce_insere_pedido.ParamByName('produto').asstring:=cod_produto;
     f_ecommerce_insere_pedido.ParamByName('quantidade').AsInteger:=quantidade;
     f_ecommerce_insere_pedido.ParamByName('valor_unt').DataType:=ftBCD;
     f_ecommerce_insere_pedido.ParamByName('valor_unt').AsBCD:=valor;
     f_ecommerce_insere_pedido.ParamByName('obs').AsString:=cfgObs;
     f_ecommerce_insere_pedido.ParamByName('pago').AsString:=pago;
     f_ecommerce_insere_pedido.ParamByName('forma_pag').AsString:=cfgFormPgto;
     f_ecommerce_insere_pedido.ParamByName('data_ped').AsDate:=data_ped;
     f_ecommerce_insere_pedido.Prepare;
     f_ecommerce_insere_pedido.Open();
     except
        On E:Exception do Begin
        erros_log('', 360, '', '', '','cadastra produtos do pedido', E.Message );
        end;
     end;


     resposta:= f_ecommerce_insere_pedido.FieldByName('f_ecommerce_insere_pedido').AsString;

     Synchronize(procedure begin
     Frm_principal.lbl_pedido.Caption:=resposta;
     end);

      {Tratamento de excessões}

  {Caso ocorra algum erro inesperado ou que não possua tratamento de exceção.}
      if Pos('SSECOM-9999', resposta) <> 0 then
      begin
      Transaction_pedido.Rollback;
        Synchronize(procedure begin
        Frm_principal.lbl_pedido.Caption:='Evento não identificado, chame o suporte tecnico.';
        end);
      oc_order_product.Free;
      oc_order.Next;
      continue

      end else

  {Caso exista mais de um CPF ou CNPJ na base de dados do ssplus}
       if Pos('SSECOM-1048', resposta) <> 0 then
      begin
      Transaction_pedido.Rollback;
       Synchronize(procedure begin
       Frm_principal.lbl_pedido.Caption:='Cliente com CPF ou CPNJ duplicado.';
       end);
      oc_order_product.Free;
      oc_order.Next;
      continue
      end else


  {Cliente inexistente na base de dados}
            if Pos('SSECOM-7648', resposta) <> 0 then
      begin
      Transaction_pedido.Rollback;
        Synchronize(procedure begin
        Frm_principal.lbl_pedido.Caption:='Cliente inexistente na base de dados';
        end);
      oc_order_product.Free;
      oc_order.Next;
      continue

      end else


  {Cliente inativo}
            if Pos('SSECOM-1448', resposta) <> 0 then
      begin
      Transaction_pedido.Rollback;
        Synchronize(procedure begin
        Frm_principal.lbl_pedido.Caption:='Cliente inativo na base de dados';
        end);
      oc_order_product.Free;
      oc_order.Next;
      continue

      end else


  {Empresa inexistente na base de dados}
            if Pos('SSECOM-1449', resposta) <> 0 then
      begin
      Transaction_pedido.Rollback;
        Synchronize(procedure begin
        Frm_principal.lbl_pedido.Caption:='Empresa inexistente';
        end);
      oc_order_product.Free;
      oc_order.Next;
      continue

      end else


  {Quantidade negativa ou igual a zero}
            if Pos('SSECOM-1347', resposta) <> 0 then
      begin
      Transaction_pedido.Rollback;
        Synchronize(procedure begin
        Frm_principal.lbl_pedido.Caption:='Quantidade do produto negativo ou igual a zero';
        end);
      oc_order_product.Free;
      oc_order.Next;
      continue

      end else



    {Preço do produto negativo ou igual a zero}
            if Pos ('SSECOM-1932', resposta) <> 0 then
      begin
      Transaction_pedido.Rollback;
        Synchronize(procedure begin
        Frm_principal.lbl_pedido.Caption:='O Valor do produto cod.'+inttostr(produto)+' não pode ser zero ou negativo. valor informado: R$ '+CurrToStr(valor);
        end);

      oc_order_product.Free;
      oc_order.Next;
      Continue

      end else


    {Produto não possui cadastro no ssplus}
            if Pos ('SSECOM-2330', resposta) <> 0 then
      Begin
      Transaction_pedido.Rollback;
        Synchronize(procedure begin
        Frm_principal.lbl_pedido.Caption:='Produto '+inttostr(produto)+' não possui cadastro no SSPlus';
        end);
      oc_order_product.Free;
      oc_order.Next;
      continue
      End else



    {Número do pedido não pode ser superior a 999999}
            if Pos ('SSECOM-2731', resposta) <> 0 then
      Begin
      Transaction_pedido.Rollback;
        Synchronize(procedure begin
        Frm_principal.lbl_pedido.Caption:='Número do pedido não pode ser superior a 999999';
        end);
      oc_order_product.Free;
      oc_order.Next;
      Continue

      End else



    {Quando o produto ja esta informado no Pedio}
            if Pos ('SSECOM-3147', resposta) <> 0 then
      begin

        Synchronize(procedure begin
        Frm_principal.lbl_pedido.Caption:='Verificando produtos.';
        end);
      oc_order_product.Next;
      Continue
      end  else


    {Caso não ocorra nenhuma  exceção e o produto for vinculado}
        if Pos ('SSECOM+0004', resposta) <> 0 then
        begin
          Synchronize(procedure begin
          Frm_principal.lbl_pedido.Caption:='Produtos validados com sucesso, finalizando..';
          end);
        end;



        oc_order_product.Next;
        continue




    End;

      {Quando terminar de enviar os produtos}
      Transaction_pedido.Commit;
      pedidos_enviados:= pedidos_enviados+1;

      Synchronize(procedure begin
      frm_principal.lbl_mostra_ped_enviados.Caption:= inttostr(pedidos_enviados);
     end);

   {Cadastra o histórico e muda o status do pedido}
   try
    if Pos ('SSECOM+0004', resposta) <> 0 then
    begin
        if StatusPosImportado <> '9999' then
      begin
      oc_order_history:=TFDQuery.Create(nil);
      oc_order_history.Connection:=MysqlPedConn;
      oc_order_history.Close;
      oc_order_history.SQL.Clear;
      oc_order_history.SQL.Add('INSERT INTO '+MysqlPrefixo+'order_history (`order_id`, `order_status_id`, `notify`, `comment`, `date_added`) '+
                               ' values (:order_id, :order_status_id, :notify, :comment, :date_added) ');
      oc_order_history.ParamByName('order_id').AsInteger:=order_id;
      oc_order_history.ParamByName('order_status_id').AsString:=StatusPosImportado;
      oc_order_history.ParamByName('notify').AsInteger:=0;
      oc_order_history.ParamByName('comment').AsString:=cfgMsgStatus;
      oc_order_history.ParamByName('date_added').AsDateTime:=now;
      oc_order_history.ExecSQL;
      oc_order_history.Free;

      //muda o status do pedido
      oc_order_history:=TFDQuery.Create(nil);
      oc_order_history.Connection:=MysqlPedConn;
      oc_order_history.Close;
      oc_order_history.SQL.Clear;
      oc_order_history.SQL.Add('UPDATE '+MysqlPrefixo+'order SET `order_status_id`=:order_status_id where `order_id`=:order_id ');
      oc_order_history.ParamByName('order_id').AsInteger:=order_id;
      oc_order_history.ParamByName('order_status_id').AsInteger:=StrToInt(StatusPosImportado);
      oc_order_history.ExecSQL;
      oc_order_history.Free;
      end;

    end;
   except
       On E:Exception do Begin
    erros_log('', 810, '', '', '','Atulizar historico e status do pedido', E.Message );
    end;

   end;


    {passa para o proximo pedido}
     oc_order_product.Free;
     oc_order.Next;
    {Fim do bloco do select dos pedidos}
     end;

      Synchronize(procedure begin
      Frm_principal.lbl_pedido.Caption    :=' Importação concluida com sucesso';
      Frm_principal.lbl_clientes.Caption  :=' Ultima importação '+TimeToStr(time());
      frm_principal.indPedidos.Animate:=false;
      end);



 {Fim do bloco de codigo quando retorna registro de ecommerce}
 end;








end;

end.
