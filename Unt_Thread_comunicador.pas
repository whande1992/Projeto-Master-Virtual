unit Unt_Thread_comunicador;

interface


uses
  System.Classes, System.SysUtils,StrUtils,FireDAC.Stan.Param,FireDAC.Comp.Client,IdCoderMIME;

type

  Thread = class(TThread)
  protected
    procedure Execute; override;


  end;



implementation



uses Unt_Mysql, Unt_Postgres,Vcl.Graphics,
Unt_Principal, Unt_Exporta_Registros,IniFiles,JPEG,DB,Winapi.Messages,
  Unt_Configuracoes, Unt_Funcoes, Unt_Funcoes_ini,IdFTP,Pngimage;

{ Thread }
procedure Thread.Execute;


  VAR


log_desc, log_query,foto2_sql,foto3_sql,foto4_sql:string;

//VARIAVEIS PARA TABELA DESCRIÇÃO NO MYSQL
NOME, SS_BASICO:STRING;
ss_codigo:string;
SQL_Update1,SQL_Update2, sql_similar:STRING;

SR: TSearchRec;
I: integer;

// VARIAVEIS PARA TABELA PRODUTO NO MYSQL (algumas variaveis estão a cima)
quantity:Currency;
codigo_similar,price,marca,pricePromo:STRING;
weight, length,width,height:String;
date_modified,data_atualizacao,DataPesquisaProduto, PromoIni, PromoFim:TDate;
sql_produto1, sql_produto2,sql_produto3:string;
ver_prodesc, pro_store:string;
secao_descricao,grupo_descricao,subgrupo:string  ;
subgrupo_descricao,cfg_UltProduto:string;
category_secao,category_grupo:integer;
//i: integer;
status,secao,grupo,grusec:String;
aplicacao:String;
ver_D_secao,ver_D_grupo,Ver_produto_G:string;
secao_path, grupo_path, gru_se_path, level:integer;
foto_1,foto_2,foto_3,foto_4,img2,UltMetUpdate:String;imagem:String;
excluir_site,envia_site,UpCompleto, EncontrouProduto:boolean;
CodProAtual,UltimoPro:integer;
  //ftp_usuario, ftp_host,ftp_porta,  ftp_senha,ftp_senhacrip,

vJPEG: TJPEGImage;
vPng:TPNGObject;
vBmp:TBitmap;



vImageStream : TMemoryStream;
IQTDE_TENT_CONEXAO,numero,Uregistro,RegistroA,id_marca, ProdutosEncontrados:integer;
script,dt,script2:string;
vldimagem,formatoImg1,formatoImg2,formatoImg3,formatoImg4:string;

// Variaveis da versão 2.0
secao_ecommerce, secao_ecommerce_descricao, produto_mestre:string;
tabela_ecommerce, des_secao_ecommerce, codigo_secao:string;

// Variaveis da versão 2.0  caracteristicas dos produtos
codigo_caracteristica, descricao_caracteristica, valor_caracteristica:string;
filter_id:string;
filtro_ecommerce:Variant;
resposta_filtro:string[60];

category_id:integer;
{Componentes em tempo de execução}

PgsqlConnProduto, Mysqlcon:TFDConnection;
Query_VWprodutos,produtos_similares,produtos_caracteristicas:TFDQuery;
oc_manufacturer,oc_product,oc_product_to_category,oc_product_image,
oc_manufacturer_to_store,oc_product_description,oc_product_to_store,oc_category,
oc_category_to_store,oc_category_description, oc_category_path,oc_product_related,
oc_product_attribute,oc_product_filter,oc_attribute_group,oc_attribute_group_description,
oc_attribute, oc_attribute_description,oc_filter_group,oc_filter_group_description,
oc_filter,oc_filter_description,oc_category_filter,oc_product_special:TFDQuery;

ArqIni:tinifile;
FTPConexao:TIdFTP;
converteImg:TIdDecoderMIME;


function uniExtractImageType(const T: TStream): string;
var
S : RawByteString;
begin
Result := '';

if T.size<=4 then Exit;

SetLength(S, 4);
T.Position := 0;
T.Read(S[1], 4);
T.Position := T.Position-4;

if Copy(S, 1, 3) = 'GIF' then
Result := 'GIF'
else if Copy(S, 1, 3) = #$FF#$D8#$FF then
Result := 'JPG'
else if Copy(S, 2, 3) = 'PNG' then
Result := 'PNG'
else if Copy(S, 1, 2) = 'BM' then
Result := 'BMP'
else if Copy(S, 1, 4) = #$00#$00#$01#$00 then
Result := 'ICO';
end;





begin
  NameThreadForDebugging('Thread_comunicador');


  { Colocar o codigo para usar a thread aqui }

  Synchronize(  procedure
  begin
  frm_Principal.BTN_envia_produtos.Enabled:=false;
  frm_Principal.BTN_envia_produtos.Caption:='Enviando..' ;
  frm_principal.lbl_Produto_1.Caption:='Iniciando processo de atualização dos produtos';
  frm_principal.lbl_Produto_2.Caption:='Aguarde..' ;
  frm_principal.Plbl_pencontrados.Caption:='0';
  frm_principal.Slbl_numero.Caption:='0';
  frm_principal.indProdutos.Animate:=true;
  end   );

  ArqIni:= TIniFile.Create('.\Arquivo.ini');


 {Ajusta o painel de informações}
 numero:=1;

  //valida se seleciona somente produtos com imagem
    case AnsiIndexStr(cfgExportaImg, ['S', 'N']) of
  0 :  script2:=' and foto_1 IS NOT NULL ';
  1 :  script2:='  ';
  end;

  if cfgEnvioRetroativo = true then
  DataPesquisaProduto:=cfgDataEnvioRetroativo else
  DataPesquisaProduto:=now;

  {Determina a forma que será selecionado os produtos para atualização}
  case AnsiIndexStr(cfgTipoAtualizacao, ['Pendentes', 'Todos','Diario']) of
  0 : script:='select * from produtos_ecommerce where codigo_empresa= :codigo_empresa  '+script2+' order by data_atualizacao asc ' ;
  1 : script:='select * from produtos_ecommerce where codigo_empresa= :codigo_empresa  '+script2+ 'order by data_atualizacao asc' ;
  2 : script:='select * from produtos_ecommerce where codigo_empresa=:codigo_empresa and  data_atualizacao BETWEEN :data_retroativa and CURRENT_DATE  '+script2+ 'order by data_atualizacao asc' ;
  end;






  data_atualizacao := now;
  dt:= dateToStr(data_atualizacao);


    {MYSQL - Faz a conexão com o banco de dados em tempo de execução}
 IQTDE_TENT_CONEXAO:=1;
 while IQTDE_TENT_CONEXAO <= 10 do
  Begin
    Try
    Mysqlcon := TFDConnection.Create(nil);
      with Mysqlcon do
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
      Frm_principal.lbl_Produto_1.caption:='MySql' ;
      frm_principal.lbl_Produto_2.Caption:='Tentando conectar, tentativa '+IntToStr(IQTDE_TENT_CONEXAO)+' de 10..'
      end   );

    end;
    sleep(3000);
    if Mysqlcon.Connected=true then Break
  end;


  {PGSql - Faz a conexão com o banco de dados em tempo de execução}
    IQTDE_TENT_CONEXAO:=1;
  while IQTDE_TENT_CONEXAO <= 10 do
  begin
    try
    PgsqlConnProduto := TFDConnection.Create(nil);
    with PgsqlConnProduto do
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
        frm_principal.lbl_Produto_1.Caption:='SSPlus' ;
        frm_principal.lbl_Produto_2.Caption:='Procurando conexão, tentativa '+IntToStr(IQTDE_TENT_CONEXAO)+' de 10..'
        end   );

    end;
    sleep(3000);
    if PgsqlConnProduto.Connected=true then Break
    end;


  // faz o select dos produtos modificados no SS
  Try
  Query_VWprodutos := TFDQuery.Create(nil);
  Query_VWprodutos.Connection:= PgsqlConnProduto;
  Query_VWprodutos.Connection.Connected;
  Query_VWprodutos.Close;
  Query_VWprodutos.SQL.Clear;
  Query_VWprodutos.SQL.Add(script);

  Query_VWprodutos.parambyname('codigo_empresa').Asstring:=cfgEmpresa  ;
  if cfgTipoAtualizacao='Diario' then
  Query_VWprodutos.parambyname('data_retroativa').AsDate:=DataPesquisaProduto;


    Synchronize(procedure
    begin
    frm_principal.lbl_Produto_1.Caption:='Aguarde, esse processo pode demorar.'   ;
    frm_principal.lbl_Produto_2.Caption:='Pesquisando produtos.';
      end);
   Query_VWprodutos.Open();

  Except
  Synchronize(procedure
    begin
    frm_principal.lbl_Produto_1.Caption:='Atenção!';
    frm_principal.lbl_Produto_2.Caption:='Não foi possivel selecionar os produtos, tente novamente.';
    end);
    Query_VWprodutos.Free;
  End;

  {Verifica se existem produtos para enviar}
    if (Query_VWprodutos.RecordCount <> 0) then
  begin
  // Verifica o codigo do ultimo produto
   Query_VWprodutos.Last;
   Uregistro:=Query_VWprodutos.FieldByName('codigo_interno').Value ;
   ProdutosEncontrados:=Query_VWprodutos.RecordCount;
    Synchronize(procedure begin
    frm_principal.Plbl_pencontrados.Caption:= IntToStr(ProdutosEncontrados);
    end);
   Query_VWprodutos.First;

  end;

  EncontrouProduto:=false;

UltimoPro :=ArqIni.ReadInteger('ATUALIZACAO','UltimoPro',0) ;
cfg_UltProduto:= ArqIni.ReadString('CONFIG','ATIVA_ULT_PRODUTO','N') ;
 UltMetUpdate:= ArqIni.ReadString('ATUALIZACAO','UltMetUpdate','');


  //Equanto não acabar os produtos, o codigo continua rodando.
  While not Query_VWprodutos.eof do
 Begin

 //Atribui valor nas variaveis com dados da viewer
 CodProAtual:= Query_VWprodutos.FieldbyName('codigo_interno').AsInteger;
 UpCompleto:= ArqIni.ReadBool('ATUALIZACAO','UpCompleto',True);

 if UltMetUpdate = cfgTipoAtualizacao then
  begin
   if (cfg_UltProduto='S') then
    Begin
    if (EncontrouProduto=false) then
      Begin
      if UpCompleto=False then
        Begin
          if (CodProAtual <> UltimoPro) then
          begin
          numero:=numero+1;
          Query_VWprodutos.Next;
          continue ;
          end;
        End;
      End;
    End;
  end;

  EncontrouProduto:=true;
 ArqIni.WriteBool('ATUALIZACAO','UpCompleto',False);
 ArqIni.WriteInteger('ATUALIZACAO','UltimoPro', CodProAtual);
 ArqIni.WriteString('ATUALIZACAO','UltMetUpdate',cfgTipoAtualizacao);
 ss_codigo         := Query_VWprodutos.FieldbyName('codigo_interno').AsString;
 NOME              := Query_VWprodutos.FieldbyName('descricao').AsString;
 RegistroA         := StrToInt(ss_codigo);
 SS_BASICO         := Query_VWprodutos.FieldbyName('codigo_fabricante').value;
 if (ss_basico ='') then ss_basico:= '0000';

 marca             := Query_VWprodutos.FieldbyName('marca').AsString;
 if marca='' then marca:='Padrão';

 quantity          := Query_VWprodutos.FieldbyName('estoque_disponivel').AsCurrency;
 quantity := TRUNC(quantity);

 price             := Query_VWprodutos.FieldbyName('preco_venda').AsString;
 pricePromo            := Query_VWprodutos.FieldbyName('preco_promocao').AsString;
 weight            := Query_VWprodutos.FieldbyName('peso_bruto').AsString;
 if(weight = '')then  weight:='1'  else weight := TrocaVirgPPto(weight) ;
 length            := Query_VWprodutos.FieldbyName('comprimento').AsString;
 if (length  = '') then length:='1' else length            :=TrocaVirgPPto(length) ;
 width             := Query_VWprodutos.FieldbyName('largura').AsString;
 if ( width = '') then  width:='1' else width             :=TrocaVirgPPto(width) ;
 height            := Query_VWprodutos.FieldbyName('altura').AsString;
 if (height  = '') then height:='1'  else height            :=TrocaVirgPPto(height) ;

 PromoIni            :=Query_VWprodutos.FieldbyName('data_inicio_promocao').AsDateTime;
 PromoFim            :=Query_VWprodutos.FieldbyName('data_fim_promocao').AsDateTime;

 secao             := Query_VWprodutos.FieldbyName('secao').AsString;
 secao_descricao   := Query_VWprodutos.FieldbyName('secao_descricao').AsString;
 grupo             := Query_VWprodutos.FieldbyName('grupo').AsString;
 grupo_descricao   := Query_VWprodutos.FieldbyName('grupo_descricao').AsString;
 secao_ecommerce    :=Query_VWprodutos.FieldByName('codigo_secao_ecommerce').AsString;
 secao_ecommerce_descricao :=Query_VWprodutos.FieldByName('descricao_secao_ecommerce').AsString;

 excluir_site      := Query_VWprodutos.FieldbyName('excluir_site').AsBoolean;
 aplicacao         := Query_VWprodutos.FieldbyName('aplicacao').Value;
 aplicacao         := StringReplace( aplicacao, #10 , '&nbsp;<br>', [rfReplaceAll]);
 aplicacao         := StringReplace( aplicacao, #13 , '&nbsp;<br>', [rfReplaceAll]);

 date_modified     := now; //CAPTURA A DATA ATUAL DO COMPUTADOR
 foto_1            :=Query_VWprodutos.FieldByName('foto_1').AsString;//.SaveToFile('C:\IMG\'+ss_codigo+'.jpg');
 foto_2            :=Query_VWprodutos.FieldByName('foto_2').AsString;//.SaveToFile('C:\IMG\'+ss_codigo+'.jpg');
 foto_3            :=Query_VWprodutos.FieldByName('foto_3').AsString;//.SaveToFile('C:\IMG\'+ss_codigo+'.jpg');
 foto_4            :=Query_VWprodutos.FieldByName('foto_4').AsString;//.SaveToFile('C:\IMG\'+ss_codigo+'.jpg');
 produto_mestre            :=Query_VWprodutos.FieldByName('produto_mestre').AsString;
 grusec :=           grupo+secao;


   Synchronize(procedure begin
   frm_principal.lbl_Produto_1.Caption:='Produto - '+SS_CODIGO+' - '+NOME ;
   frm_principal.Slbl_numero.Caption:=IntToStr(numero);
   end);

   if secao_ecommerce <> '' then
   begin
   des_secao_ecommerce:=secao_ecommerce_descricao;
   tabela_ecommerce:='ss_secao_ecommerce';
   codigo_secao := secao_ecommerce;
   end
    else
   begin
   des_secao_ecommerce:= secao_descricao;
   tabela_ecommerce:='ss_secao';
   codigo_secao:=secao;
   end;

   { Verifica qual seção do ssplus será usado, existe o cadastro normal e
   existe o cadastro da seção padrão do ecommerce, caso o usuario não cadastre
  a seção padrão, será cadastrado a do cadastro de produtos.}



  {Determina um codigo unico para o grupo cadastrado dentro de cada seção}



  {Verifica se o produto esta ativo ou nao}
  if (excluir_site = true) then
  begin
   numero:=numero+1;
   Synchronize(procedure begin
   frm_principal.lbl_Produto_2.Caption:='Inativando no e-commerce';
   end);

   Oc_product:= TFDQuery.Create(nil);
   Oc_product.Connection:=Mysqlcon;
   Oc_product.Close;
   Oc_product.SQL.Clear;
   Oc_product.SQL.Add('UPDATE `'+MysqlPrefixo+'product` SET `status` = :status' +
                     ' WHERE `product_id` = :product_id' );
   Oc_product.ParamByName('product_id').AsString:=ss_codigo;
   Oc_product.ParamByName('status').AsString:='0';
   Oc_product.ExecSQL();
   Oc_product.Free;

   Query_VWprodutos.Next;
   Continue ;
  end else

  begin
  if excluir_site = false then status:='1';

    // Verifica se é para enviar somente os produtos não existentes no site
    if (cfgTipoAtualizacao='Pendentes') then
    begin
    oc_product_to_category:=TFDQuery.Create(nil);
    oc_product_to_category.Connection:=Mysqlcon;
    oc_product_to_category.Close;
    oc_product_to_category.SQL.Clear;
    oc_product_to_category.SQL.Add('SELECT `product_id` FROM `'+MysqlPrefixo+'product_to_category` WHERE `product_id` = :product_id' );
    oc_product_to_category.ParamByName('product_id').AsString:=SS_CODIGO;
    oc_product_to_category.Open;

    if(oc_product_to_category.RecordCount <> 0 )then
      Begin
      numero:=numero+1;
      oc_product_to_category.Free;
      Query_VWprodutos.Next;
      Continue ;
      End;

    end else

    begin
    oc_product_to_category.Free;
    numero:=numero+1;

    {Verifica se esta configurado para enviar a imagem do produto na atualização}
      if cfgApenasInf= 'false' then
      begin
        try
          Synchronize(procedure begin
          frm_principal.lbl_Produto_2.Caption:='Carregando as imagens do produto(Pode demorar)';
          end);

            // Verifica se existe a foto principal no postgres
          if (foto_1 = '') then else
          begin
          // Converte a foto principal do produto
          vImageStream := TMemoryStream.Create;
          converteImg:=TIdDecoderMIME.Create(nil);
          converteImg.DecodeStream(foto_1,vImageStream);
          vImageStream.Position := 0;
                 
          formatoImg1:= uniExtractImageType(vImageStream);
          
            if formatoImg1='JPG' then
            begin
            vJPEG := TJPEGImage.Create;
            vJPEG.LoadFromStream(vImageStream);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-80x80.'+formatoImg1);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-500x500.'+formatoImg1);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-228x228.'+formatoImg1);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-74x74.'+formatoImg1);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-90x90.'+formatoImg1);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-47x47.'+formatoImg1);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-268x50.'+formatoImg1);
            vJPEG.SaveToFile('.\TEMP\image\catalog\'+SS_CODIGO+'_1.'+formatoImg1);
            vJPEG.Free;
            end else if formatoImg1='PNG' then

            begin
            vPng := TPngImage.Create;
            vPng.LoadFromStream(vImageStream);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-80x80.'+formatoImg1);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-500x500.'+formatoImg1);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-228x228.'+formatoImg1);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-74x74.'+formatoImg1);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-90x90.'+formatoImg1);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-47x47.'+formatoImg1);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-268x50.'+formatoImg1);
            vPng.SaveToFile('.\TEMP\image\catalog\'+SS_CODIGO+'_1.'+formatoImg1);
            vPng.Free;
            end else if formatoImg1='BMP' then

            begin
            vBmp := TBitmap.Create;
            vBmp.LoadFromStream(vImageStream);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-80x80.'+formatoImg1);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-500x500.'+formatoImg1);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-228x228.'+formatoImg1);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-74x74.'+formatoImg1);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-90x90.'+formatoImg1);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-47x47.'+formatoImg1);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-268x50.'+formatoImg1);
            vBmp.SaveToFile('.\TEMP\image\catalog\'+SS_CODIGO+'_1.'+formatoImg1);
            vBmp.Free;
            end;
            
          converteImg.Free;
          vImageStream.Free;
           end ;
          except
            On E:Exception do Begin
            log_desc:='Não foi possivel salvar a imagem principal do produto '+ ss_codigo ;
              Synchronize(procedure begin
              erros_log(ss_codigo, 410, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
              end);
             converteImg.Free;
             vImageStream.Free;
              case AnsiIndexStr(formatoImg1, ['JPG', 'PNG','BMP']) of
              0 : vJPEG.Free;
              1 : vPng.Free;
              2 : vBmp.Free;
              end;
            end;
        end;



        try
        // Verifica se existe uma segunda imagem no postgres
        if (foto_2 = '') then else
          begin
          // Converte a segunda imagem do produto
          vImageStream := TMemoryStream.Create;
          converteImg:=TIdDecoderMIME.Create(nil);
          converteImg.DecodeStream(foto_2,vImageStream);
          vImageStream.Position := 0;

             formatoImg2:= uniExtractImageType(vImageStream);

            if formatoImg2='JPG' then
            begin
            vJPEG := TJPEGImage.Create;
            vJPEG.LoadFromStream(vImageStream);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-80x80.'+formatoImg2);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-500x500.'+formatoImg2);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-228x228.'+formatoImg2);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-74x74.'+formatoImg2);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-90x90.'+formatoImg2);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-47x47.'+formatoImg2);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-268x50.'+formatoImg2);
            vJPEG.SaveToFile('.\TEMP\image\catalog\demo\'+SS_CODIGO+'_2.'+formatoImg2);
            vJPEG.Free;
            end else if formatoImg2='PNG' then

            begin
            vPng := TPngImage.Create;
            vPng.LoadFromStream(vImageStream);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-80x80.'+formatoImg2);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-500x500.'+formatoImg2);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-228x228.'+formatoImg2);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-74x74.'+formatoImg2);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-90x90.'+formatoImg2);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-47x47.'+formatoImg2);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-268x50.'+formatoImg2);
            vPng.SaveToFile('.\TEMP\image\catalog\demo\'+SS_CODIGO+'_2.'+formatoImg2);
            vPng.Free;
            end else if formatoImg2='BMP' then

            begin
            vBmp := TBitmap.Create;
            vBmp.LoadFromStream(vImageStream);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-80x80.'+formatoImg2);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-500x500.'+formatoImg2);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-228x228.'+formatoImg2);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-74x74.'+formatoImg2);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-90x90.'+formatoImg2);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-47x47.'+formatoImg2);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-268x50.'+formatoImg2);
            vBmp.SaveToFile('.\TEMP\image\catalog\demo\'+SS_CODIGO+'_2.'+formatoImg2);
            vBmp.Free;
            end;

          converteImg.Free;
          vImageStream.Free;
          end;
          except
            On E:Exception do Begin
            log_desc:='Não foi possivel salvar a imagem 2 do produto '+ ss_codigo ;
              Synchronize(procedure begin
              erros_log(ss_codigo, 440, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
              end);
                converteImg.Free;
              vImageStream.Free;
              case AnsiIndexStr(formatoImg2, ['JPG', 'PNG','BMP']) of
              0 : vJPEG.Free;
              1 : vPng.Free;
              2 : vBmp.Free;
              end;

            end;
           end;

        try
        // Verifica se existe uma terceira imagem do produto
        if (foto_3 = '') then else
          begin
          // Converte a terceira imagem do produto
          vJPEG := TJPEGImage.Create;
          vImageStream := TMemoryStream.Create;
          converteImg:=TIdDecoderMIME.Create(nil);
          converteImg.DecodeStream(foto_3,vImageStream);
          vImageStream.Position := 0;

            formatoImg3:=uniExtractImageType(vImageStream);


            if formatoImg3='JPG' then
            begin
            vJPEG := TJPEGImage.Create;
            vJPEG.LoadFromStream(vImageStream);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-80x80.'+formatoImg3);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-500x500.'+formatoImg3);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-228x228.'+formatoImg3);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-74x74.'+formatoImg3);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-90x90.'+formatoImg3);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-47x47.'+formatoImg3);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-268x50.'+formatoImg3);
            vJPEG.SaveToFile('.\TEMP\image\catalog\demo\'+SS_CODIGO+'_3.'+formatoImg3);

            vJPEG.Free;
            end else if formatoImg3='PNG' then

            begin
            vPng := TPngImage.Create;
            vPng.LoadFromStream(vImageStream);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-80x80.'+formatoImg3);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-500x500.'+formatoImg3);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-228x228.'+formatoImg3);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-74x74.'+formatoImg3);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-90x90.'+formatoImg3);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-47x47.'+formatoImg3);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-268x50.'+formatoImg3);
            vPng.SaveToFile('.\TEMP\image\catalog\demo\'+SS_CODIGO+'_3.'+formatoImg3);
            vPng.Free;
            end else if formatoImg3='BMP' then

            begin
            vBmp := TBitmap.Create;
            vBmp.LoadFromStream(vImageStream);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-80x80.'+formatoImg3);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-500x500.'+formatoImg3);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-228x228.'+formatoImg3);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-74x74.'+formatoImg3);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-90x90.'+formatoImg3);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-47x47.'+formatoImg3);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-268x50.'+formatoImg3);
            vBmp.SaveToFile('.\TEMP\image\catalog\demo\'+SS_CODIGO+'_3.'+formatoImg3);
            vBmp.Free;
            end;

          converteImg.Free;
          vImageStream.Free;
          end;
          except
          On E:Exception do Begin
          log_desc:='Não foi possivel salvar a 3º imagem do produto '+ ss_codigo ;
            Synchronize(procedure begin
            erros_log(ss_codigo, 460, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
            end);

            converteImg.Free;
            vImageStream.Free;
             case AnsiIndexStr(formatoImg3, ['JPG', 'PNG','BMP']) of
              0 : vJPEG.Free;
              1 : vPng.Free;
              2 : vBmp.Free;
              end;

          end;
        end;

        try
        // Verifica se existe aquarta imagem do produto
         if (foto_4 = '') then  else
          begin
          // Converte a quarta imagem do produto
          vJPEG := TJPEGImage.Create;
          vImageStream := TMemoryStream.Create;
          converteImg:=TIdDecoderMIME.Create(nil);
          converteImg.DecodeStream(foto_4,vImageStream);
          vImageStream.Position := 0;

          formatoImg4:=uniExtractImageType(vImageStream);

            if formatoImg4='JPG' then
            begin
            vJPEG := TJPEGImage.Create;
            vJPEG.LoadFromStream(vImageStream);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-80x80.'+formatoImg4);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-500x500.'+formatoImg4);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-228x228.'+formatoImg4);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-74x74.'+formatoImg4);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-90x90.'+formatoImg4);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-47x47.'+formatoImg4);
            vJPEG.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-268x50.'+formatoImg4);
            vJPEG.SaveToFile('.\TEMP\image\catalog\demo\'+SS_CODIGO+'_4.'+formatoImg4);
            vJPEG.Free;
            end else if formatoImg4='PNG' then

            begin
            vPng := TPngImage.Create;
            vPng.LoadFromStream(vImageStream);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-80x80.'+formatoImg4);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-500x500.'+formatoImg4);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-228x228.'+formatoImg4);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-74x74.'+formatoImg4);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-90x90.'+formatoImg4);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-47x47.'+formatoImg4);
            vPng.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-268x50.'+formatoImg4);
            vPng.SaveToFile('.\TEMP\image\catalog\demo\'+SS_CODIGO+'_4.'+formatoImg4);
            vPng.Free;
            end else if formatoImg4='BMP' then

            begin
            vBmp := TBitmap.Create;
            vBmp.LoadFromStream(vImageStream);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-80x80.'+formatoImg4);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-500x500.'+formatoImg4);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-228x228.'+formatoImg4);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-74x74.'+formatoImg4);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-90x90.'+formatoImg4);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-47x47.'+formatoImg4);
            vBmp.SaveToFile('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-268x50.'+formatoImg4);
            vBmp.SaveToFile('.\TEMP\image\catalog\demo\'+SS_CODIGO+'_4.'+formatoImg4);
            vBmp.Free;
            end;

          converteImg.Free;
          vImageStream.Free;
          end;
          except
          On E:Exception do Begin
          log_desc:='Não foi possivel salvar a 4º imagem do produto'+ ss_codigo ;
            Synchronize(procedure begin
            erros_log(ss_codigo, 480, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
            end);

            converteImg.Free;
            vImageStream.Free;
            case AnsiIndexStr(formatoImg4, ['JPG', 'PNG','BMP']) of
            0 : vJPEG.Free;
            1 : vPng.Free;
            2 : vBmp.Free;
            end;

          end;
        end;


         //Abre conexão do o FTP para enviar as imagens
         IQTDE_TENT_CONEXAO:=1;

        {conectando ao ftp}
        while IQTDE_TENT_CONEXAO <= 7 do
        BEGIN
          TRY
          FTPConexao:= TidFtp.Create(nil);
          FTPConexao.Quit;
          FTPConexao.Disconnect;
          FTPConexao.ConnectTimeout:=120000;
          FTPConexao.Host     := FtpHost;
          FTPConexao.Username := FtpUser;
          FTPConexao.Password := FtpPass;
          FTPConexao.Port     :=strtoint(FtpPorta);
          FTPConexao.Passive  :=TRUE;

          FTPConexao.TransferTimeout:=120000;

          FTPConexao.Connect;
          EXCEPT
            On E:Exception do Begin
             Synchronize(procedure begin
             erros_log(ss_codigo, 510, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,'Não foi possivel acessar o FTP( '+IntToStr(IQTDE_TENT_CONEXAO)+' de 7)' , E.Message);
             end);
             FTPConexao.Free;
            IQTDE_TENT_CONEXAO:= IQTDE_TENT_CONEXAO + 1;
            END;
          END;

         {Caso a conexão seja efetuada com sucesso dai do loop}

         if FTPConexao.Connected then
         Break ;
        END;


        try

        // Verifica se a primeira foto é nula, se não for ela é enviada para o FTP
         if (foto_1 = '') then else
          begin
          IQTDE_TENT_CONEXAO:=1;
            while IQTDE_TENT_CONEXAO <= 3 do
            BEGIN

              try

              //Informa o caminho onde será salvo a imagem principal do produto
              FTPConexao.ChangeDir(FtpDiretorio+'/image/cache/catalog/');  //image/cache/catalog

              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-80x80.'+formatoImg1 ,SS_CODIGO+'_1-80x80.'+formatoImg1);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-500x500.'+formatoImg1 ,SS_CODIGO+'_1-500x500.'+formatoImg1);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-228x228.'+formatoImg1 ,SS_CODIGO+'_1-228x228.'+formatoImg1);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-74x74.'+formatoImg1 ,SS_CODIGO+'_1-74x74.'+formatoImg1);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-90x90.'+formatoImg1 ,SS_CODIGO+'_1-90x90.'+formatoImg1);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-47x47.'+formatoImg1 ,SS_CODIGO+'_1-47x47.'+formatoImg1);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_1-268x50.'+formatoImg1 ,SS_CODIGO+'_1-268x50.'+formatoImg1);

              FTPConexao.ChangeDir(FtpDiretorio+'/image/catalog/'); //image/catalog
              FTPConexao.Put('.\TEMP\image\catalog\'+SS_CODIGO+'_1.'+formatoImg1 ,SS_CODIGO+'_1.'+formatoImg1);
              EXCEPT
                On E:Exception do Begin
                log_desc:= 'Não foi possivel enviar a imagem 1 para o FTP, tentativa '+IntToStr(IQTDE_TENT_CONEXAO);
                  Synchronize(procedure begin
                  erros_log(ss_codigo, 550, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                  end);
                IQTDE_TENT_CONEXAO:= IQTDE_TENT_CONEXAO + 1;
                Continue
    			      end;
              end;

             Break
            END;
          end;

        // Verifica se a SEGUNDA foto é nula, se não for ela é enviada para o FTP

        if (foto_2 = '') then else
          begin
           IQTDE_TENT_CONEXAO:=1;
           while IQTDE_TENT_CONEXAO <= 3 do
            BEGIN

              TRY

              //Informa o caminho onde será salvo a SEGUNDA imagem do produto
              FTPConexao.ChangeDir(FtpDiretorio+'/image/cache/catalog/');

              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-80x80.'+formatoImg2 ,SS_CODIGO+'_2-80x80.'+formatoImg2);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-500x500.'+formatoImg2 ,SS_CODIGO+'_2-500x500.'+formatoImg2);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-228x228.'+formatoImg2 ,SS_CODIGO+'_2-228x228.'+formatoImg2);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-74x74.'+formatoImg2 ,SS_CODIGO+'_2-74x74.'+formatoImg2);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-90x90.'+formatoImg2 ,SS_CODIGO+'_2-90x90.'+formatoImg2);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-47x47.'+formatoImg2 ,SS_CODIGO+'_2-47x47.'+formatoImg2);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_2-268x50.'+formatoImg2 ,SS_CODIGO+'_2-268x50.'+formatoImg2);

              FTPConexao.ChangeDir(FtpDiretorio+'/image/catalog/demo/');
              FTPConexao.Put('.\TEMP\image\catalog\demo\'+SS_CODIGO+'_2.'+formatoImg2 ,SS_CODIGO+'_2.'+formatoImg2);

               except
                On E:Exception do Begin
                log_desc:= 'Não foi possivel enviar a imagem 2 para o FTP, tentativa '+IntToStr(IQTDE_TENT_CONEXAO);
                  Synchronize(procedure begin
                  erros_log(ss_codigo, 580, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                  end);
                IQTDE_TENT_CONEXAO:= IQTDE_TENT_CONEXAO + 1;

                Continue
          		  end;
              end;
              Break
             end;
            end;

            // Verifica se a TERCEIRA foto é nula, se não for ela é enviada para o FTP

          if (foto_3 = '') then else
          begin
            IQTDE_TENT_CONEXAO:=1;
            while IQTDE_TENT_CONEXAO <= 3 do
            BEGIN
              try

              //Informa o caminho onde será salvo a TERCEIRA imagem do produto
              FTPConexao.ChangeDir(FtpDiretorio+'/image/cache/catalog/');

              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-80x80.'+formatoImg3 ,SS_CODIGO+'_3-80x80.'+formatoImg3);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-500x500.'+formatoImg3 ,SS_CODIGO+'_3-500x500.'+formatoImg3);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-228x228.'+formatoImg3 ,SS_CODIGO+'_3-228x228.'+formatoImg3);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-74x74.'+formatoImg3 ,SS_CODIGO+'_3-74x74.'+formatoImg3);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-90x90.'+formatoImg3 ,SS_CODIGO+'_3-90x90.'+formatoImg3);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-47x47.'+formatoImg3 ,SS_CODIGO+'_3-47x47.'+formatoImg3);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_3-268x50.'+formatoImg3 ,SS_CODIGO+'_3-268x50.'+formatoImg3);

              FTPConexao.ChangeDir(FtpDiretorio+'/image/catalog/demo/');
              FTPConexao.Put('.\TEMP\image\catalog\demo\'+SS_CODIGO+'_3.'+formatoImg3 ,SS_CODIGO+'_3.'+formatoImg3);
              except
                On E:Exception do Begin
                log_desc:= 'Não foi possivel enviar a imagem 3 para o FTP, tentativa '+IntToStr(IQTDE_TENT_CONEXAO);
                  Synchronize(procedure begin
                  erros_log(ss_codigo, 610, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                  end);
                IQTDE_TENT_CONEXAO:= IQTDE_TENT_CONEXAO + 1;
                Continue
			          end;
              end;
             Break
            end;
          end;

          // Verifica se a QUARTA foto é nula, se não for ela é enviada para o FTP

          if (foto_4 = '') then else
          begin
           IQTDE_TENT_CONEXAO:=1;
           while IQTDE_TENT_CONEXAO <= 3 do
            BEGIN

              try

              //Informa o caminho onde será salvo a QUARTA imagem do produto
              FTPConexao.ChangeDir(FtpDiretorio+'/image/cache/catalog/');

              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-80x80.'+formatoImg4 ,SS_CODIGO+'_4-80x80.'+formatoImg4);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-500x500.'+formatoImg4 ,SS_CODIGO+'_4-500x500.'+formatoImg4);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-228x228.'+formatoImg4 ,SS_CODIGO+'_4-228x228.'+formatoImg4);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-74x74.'+formatoImg4 ,SS_CODIGO+'_4-74x74.'+formatoImg4);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-90x90.'+formatoImg4 ,SS_CODIGO+'_4-90x90.'+formatoImg4);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-47x47.'+formatoImg4 ,SS_CODIGO+'_4-47x47.'+formatoImg4);
              FTPConexao.Put('.\TEMP\image\cache\catalog\'+SS_CODIGO+'_4-268x50.'+formatoImg4 ,SS_CODIGO+'_4-268x50.'+formatoImg4);

              FTPConexao.ChangeDir(FtpDiretorio+'/image/catalog/demo/');
              FTPConexao.Put('.\TEMP\image\catalog\demo\'+SS_CODIGO+'_4.'+formatoImg4 ,SS_CODIGO+'_4.'+formatoImg4);
              except
                On E:Exception do Begin
                log_desc:= 'Não foi possivel enviar a imagem 4 para o FTP, tentativa '+IntToStr(IQTDE_TENT_CONEXAO);
                  Synchronize(procedure begin
                  erros_log(ss_codigo, 650, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                  end);
                IQTDE_TENT_CONEXAO:= IQTDE_TENT_CONEXAO + 1;
                Continue
        			  end;
              end;
            Break
            end;
          end;

          finally
          FTPConexao.Disconnect;
          FTPConexao.Free;
          end;
          {Termina transferencias e conexões com o FTP}

        // Deleta e insere o caminho das fotos no banco de dados
        TRY
          // Se não existe imagem, é deletado o caminho no banco
        oc_product_image:=TFDQuery.Create(nil);
        oc_product_image.Connection:=Mysqlcon;
        oc_product_image.Close;
        oc_product_image.SQL.Add('DELETE FROM `'+MysqlPrefixo+'product_image` WHERE `product_id` = :product_id ');
        oc_product_image.ParamByName('product_id').AsString:=SS_CODIGO;
        oc_product_image.ExecSQL;

          if (foto_2 <> '') then
          begin
          if (foto_3 <> '') then foto3_sql:= ' , (:product_id, :image3, ''1'') ' else foto3_sql:='';
          if (foto_4 <> '') then foto4_sql:= ' , (:product_id, :image4, ''2'') ' else foto4_sql:='';

          oc_product_image.Close;
          oc_product_image.SQL.Clear;
          oc_product_image.SQL.Add(' INSERT INTO `'+MysqlPrefixo+'product_image` ') ;
          oc_product_image.SQL.Add(' (`product_id`,`image`,`sort_order`) VALUES  ') ;
          oc_product_image.SQL.Add(' (:product_id, :image2, ''0'') ');
          oc_product_image.SQL.Add( foto3_sql );
          oc_product_image.SQL.Add( foto4_sql );
          oc_product_image.ParamByName('product_id').AsString:=SS_CODIGO;
          if (foto_2 <> '') then oc_product_image.ParamByName('image2').AsString:='catalog/demo/'+SS_CODIGO+'_2.'+formatoImg2;
          if (foto_3 <> '') then oc_product_image.ParamByName('image3').AsString:='catalog/demo/'+SS_CODIGO+'_3.'+formatoImg3;
          if (foto_4 <> '') then oc_product_image.ParamByName('image4').AsString:='catalog/demo/'+SS_CODIGO+'_4.'+formatoImg4;;
          oc_product_image.ExecSQL;
          oc_product_image.Free
          end;

        EXCEPT
          On E:Exception do Begin
          log_desc:= 'Não foi possivel cadastrar o caminho das imagens no banco de dados';
            Synchronize(procedure begin
            erros_log(ss_codigo, 700, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
            end);
            oc_product_image.Free;
          end;
        end;
       END; {Finaliza begin do envio da imagem}


    // MARCA DO PRODUTO
      TRY
        Synchronize(procedure begin
        frm_principal.lbl_Produto_2.Caption:='Configurando a marca.';
        end);

      // Verifica a existencia da marca no mysql
      oc_manufacturer := TFDQuery.Create(nil);
      oc_manufacturer.Connection:= Mysqlcon;
      oc_manufacturer.Connection.Connected;
      oc_manufacturer.SQL.Clear;
      oc_manufacturer.SQL.Add('SELECT `manufacturer_id` FROM `'+MysqlPrefixo+'manufacturer` WHERE `name` = :marca');
      oc_manufacturer.ParamByName('marca').AsString:=marca;
      oc_manufacturer.Open();

      oc_manufacturer.Close;
      oc_manufacturer.SQL.Clear;
      oc_manufacturer.SQL.Add('INSERT INTO `'+MysqlPrefixo+'manufacturer` (`name`,`sort_order`) VALUES (:marca,:sort_order) ' +
                                                          ' ON DUPLICATE KEY UPDATE `name`=:marca, `sort_order`=:sort_order ');
      oc_manufacturer.ParamByName('marca').AsString:=marca;
      oc_manufacturer.ParamByName('sort_order').AsInteger:=0;
      oc_manufacturer.ExecSQL;
      oc_manufacturer.Free;

      Except
        On E:Exception do Begin
        log_desc:= 'Não foi possivel configurar a Marca do produto '+SS_CODIGO ;
          Synchronize(procedure begin
          erros_log(ss_codigo, 750, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
          frm_principal.lbl_Produto_2.Caption:=log_desc;
          end);
          oc_manufacturer.Free;

        End;
      END;


      // Capturar ID da Marca
      TRY
      oc_manufacturer := TFDQuery.Create(nil);
      oc_manufacturer.Connection:= Mysqlcon;
      oc_manufacturer.Close;
      oc_manufacturer.SQL.Clear;
      oc_manufacturer.SQL.Add('SELECT `manufacturer_id` FROM `'+MysqlPrefixo+'manufacturer` WHERE `name`= :marca');
      oc_manufacturer.ParamByName('marca').AsString:=marca;
      oc_manufacturer.Open;
      id_marca:= oc_manufacturer.FieldByName('manufacturer_id').Value;
      oc_manufacturer.Free;
      Except
        On E:Exception do Begin
			  log_desc:= 'Não foi possivel verificar o codigo da marca '+IntToStr(id_marca)+'-'+marca +' do produto '+SS_CODIGO;
          Synchronize(procedure begin
          erros_log(ss_codigo, 780, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
          frm_principal.lbl_Produto_1.Caption:=log_desc ;
          end);
          oc_manufacturer.Free;

        End;
      END;

      // CADASTRA A MARCA NA LOJA
      TRY
      // Relacionando a Marca na empresa
      oc_manufacturer_to_store:= TFDQuery.Create(nil);
      oc_manufacturer_to_store.Connection:=Mysqlcon;
      oc_manufacturer_to_store.Close;
      oc_manufacturer_to_store.SQL.Clear;
      oc_manufacturer_to_store.SQL.Add('INSERT INTO `'+MysqlPrefixo+'manufacturer_to_store` (`manufacturer_id`,`store_id`)'+
                                      ' VALUES (:marca,:store_id) ON DUPLICATE KEY UPDATE `manufacturer_id`= :marca, `store_id`= :store_id ');
      oc_manufacturer_to_store.ParamByName('marca').Value:=id_marca;
      oc_manufacturer_to_store.ParamByName('store_id').AsString:='0';
      oc_manufacturer_to_store.ExecSQL;
      oc_manufacturer_to_store.Free;

      Except
       On E:Exception do Begin
			 log_desc:='Não foi possivel relacionar a marca '+IntToStr(id_marca)+'-'+marca +' na empresa' ;
        Synchronize(procedure begin
        erros_log(ss_codigo, 800, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
        frm_principal.lbl_Produto_2.Caption:=log_desc ;
        End);
        oc_manufacturer_to_store.Free;
       end
      END;
     // FIM CADASTRO DA MARCA


      //VERIFICA SE PRODUTO JA EXISTE NO BANCO DE DADOS MYSQL NA TABELA   '+MysqlPrefixo+'product
      TRY
       Synchronize(procedure begin
       frm_principal.lbl_Produto_2.Caption:='Atualizando informações principais do produto';
       end);

      if (foto_1 = '') then vldimagem:='catalog/imgnull.jpg' else
      vldimagem:='catalog/'+SS_CODIGO+'_1.'+formatoImg1;
      oc_product:=TFDQuery.Create(nil);
      oc_product.Connection:=Mysqlcon;
      oc_product.Close;
      oc_product.SQL.Clear;
      oc_product.SQL.Add('INSERT INTO `'+MysqlPrefixo+'product` (' +
          '`product_id`, `model`, `sku`, `upc`, `ean`, `jan`, `isbn`, `mpn`, `location`, `quantity`,' +
          '`stock_status_id`, `image`, `manufacturer_id`, `shipping`, `price`, `points`, `tax_class_id`,' +
          '`date_available`, `weight`, `weight_class_id`, `length`, `width`, `height`,`length_class_id`,' +
          '`subtract`, `minimum`, `sort_order`, `status`, `viewed`, `date_added`, `date_modified`, `ss_codigo`, `ss_basico`)' +
          ' VALUES (' +
          ' :product_id,  :model,  :sku,  :upc,  :ean,  :jan,  :isbn,  :mpn,  :location,  :quantity,' +
          ' :stock_status_id,  :image,  :manufacturer_id,  :shipping,  :price,  :points,  :tax_class_id,' +
          ' :date_available,  :weight,  :weight_class_id,  :length,  :width,  :height,  :length_class_id,' +
          ' :subtract, :minimum, :sort_order, :status, :viewed, :date_added, :date_added, :ss_codigo,  :ss_basico)'+
          '   ON DUPLICATE KEY UPDATE '+
          ' `model`= :model, `quantity`= :quantity, `price`= :price, `weight`= :weight, `image`=:image,'+
          ' `manufacturer_id`= :manufacturer_id, `length`= :length, `date_modified`= :date_modified, `width`= :width, `height`= :height,'+
          ' `status`= :status, `ss_basico`= :ss_basico, `weight_class_id`= :weight_class_id, `length_class_id`= :length_class_id ');
      oc_product.ParamByName('product_id').AsInteger:=StrToInt(SS_CODIGO);
      oc_product.ParamByName('model').AsString:=ss_basico;
      oc_product.ParamByName('sku').AsString:='';
      oc_product.ParamByName('upc').AsString:='';
      oc_product.ParamByName('ean').AsString:='';
      oc_product.ParamByName('jan').AsString:='';
      oc_product.ParamByName('isbn').AsString:='';
      oc_product.ParamByName('mpn').AsString:='';
      oc_product.ParamByName('location').AsString:='';
      oc_product.ParamByName('quantity').AsCurrency:=quantity;
      oc_product.ParamByName('stock_status_id').AsInteger:=7;
      oc_product.ParamByName('image').AsString:= vldimagem;
      oc_product.ParamByName('manufacturer_id').Value:=id_marca;
      oc_product.ParamByName('shipping').AsInteger:=1;
      oc_product.ParamByName('price').AsString:=StringReplace(price, ',', '.', []);
      oc_product.ParamByName('points').AsInteger:=0;
      oc_product.ParamByName('tax_class_id').AsInteger:=0;
      oc_product.ParamByName('date_available').AsDatetime:=now;
      oc_product.ParamByName('weight').AsString:=weight;
      oc_product.ParamByName('weight_class_id').AsInteger:=1;
      oc_product.ParamByName('length').AsString:=length;
      oc_product.ParamByName('date_modified').AsDateTime:=now;
      oc_product.ParamByName('width').AsString:=width;
      oc_product.ParamByName('height').AsString:=height;
      oc_product.ParamByName('length_class_id').AsInteger:=1;
      oc_product.ParamByName('subtract').AsInteger:=1;
      oc_product.ParamByName('minimum').AsInteger:=1;
      oc_product.ParamByName('sort_order').AsInteger:=0;
      oc_product.ParamByName('status').AsString:='1';
      oc_product.ParamByName('viewed').AsInteger:=0;
      oc_product.ParamByName('date_added').AsDateTime:=now;
      oc_product.ParamByName('ss_codigo').AsString:=ss_codigo;
      oc_product.ParamByName('ss_basico').AsString:=Tamanho_Maximo_string(SS_BASICO,10);
      oc_product.ExecSQL;
      oc_product.Free;

        EXCEPT
        On E:Exception do Begin
			  log_desc:= 'Não foi possivel modificar os dados principais do produto '+ss_codigo;
        Synchronize(procedure begin
        erros_log(ss_codigo, 840, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
        frm_principal.lbl_Produto_2.Caption:=log_desc;
        end );
        oc_product.Free;
        End;
      END;



      //EXECUTA ROTINAS DA DESCRIÇÃO DO PRODUTO
      TRY
      oc_product_description:= TFDQuery.Create(nil);
      oc_product_description.Connection:=Mysqlcon;
      oc_product_description.SQL.Add('INSERT INTO `'+MysqlPrefixo+'product_description` (`product_id`, `name`,`description`, `language_id`, `tag`, `meta_title`, `meta_description`, `meta_keyword`, `ss_codigo`, `ss_basico`)'+
                                    ' VALUES (:ss_codigo, :produto, :description, :idioma, :produto, :produto, :produto, :produto, :ss_basico, :ss_basico)'+
                                    ' ON DUPLICATE KEY UPDATE `name`=:produto, `description`=:description, `language_id`=:idioma, `tag`=:produto, `meta_title`=:produto, '+
                                    ' `meta_description`=:produto, `meta_keyword`=:produto, `ss_basico`=:ss_basico  ');
      oc_product_description.ParamByName('produto').AsString:=NOME;
      oc_product_description.ParamByName('ss_codigo').AsString:=SS_CODIGO ;
      oc_product_description.ParamByName('ss_basico').AsString:=Tamanho_Maximo_string(ss_basico,10) ;
      oc_product_description.ParamByName('description').AsString:='<br>' + aplicacao + '<br><br><h5><span style="color: rgb(255, 255, 255);">'+nome+'</span></h5><br><br><br>' ;
      oc_product_description.ParamByName('idioma').AsString:=cfgCodIdioma ;
      oc_product_description.ExecSQL;
      oc_product_description.Free;

       EXCEPT
        On E:Exception do Begin
			  log_desc:= 'Não foi possivel modificar a descrição do produto '+ss_codigo;
          Synchronize(procedure begin
          frm_principal.lbl_Produto_2.Caption:=log_desc;
          erros_log(ss_codigo, 880, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
          end);
          oc_product_description.Free;
        End;
      END;


      //Vincula o produto na empresa dentro do e-commerce.
      TRY
      oc_product_to_store:=TFDQuery.Create(nil);
      oc_product_to_store.Connection:=Mysqlcon;
      oc_product_to_store.close;
      oc_product_to_store.SQL.Clear;
      oc_product_to_store.SQL.Add('INSERT INTO `'+MysqlPrefixo+'product_to_store` (`product_id`, `store_id`)' +
                    ' VALUES (:ss_codigo, :store_id) ON DUPLICATE KEY UPDATE `product_id`=:ss_codigo, `store_id`=:store_id');
      oc_product_to_store.ParamByName('ss_codigo').AsString:=ss_codigo;
      oc_product_to_store.ParamByName('store_id').AsString:='0';
      oc_product_to_store.ExecSQL;
      oc_product_to_store.Free;

       EXCEPT
          On E:Exception do Begin
			    log_desc:= 'Não foi possivel relacionar na loja o produto '+ss_codigo;
          erros_log(ss_codigo, 860, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
          oc_product_to_store.Free;
          End;
      END;

      try

       if pricePromo <> '0' then
       begin
        {Deleta as promoções existentes do produto e depois cadastra, caso possua preço promocional}
        if cfgPromocaoProduto=true then
         begin
         oc_product_special:=TFDQuery.Create(nil);
         oc_product_special.Connection:=Mysqlcon;
         oc_product_special.Close;
         oc_product_special.SQL.Clear;
         oc_product_special.SQL.Add('DELETE FROM '+MysqlPrefixo+'product_special WHERE `product_id`=:product_id ');
         oc_product_special.ParamByName('product_id').AsInteger:=StrToInt(ss_codigo);
         oc_product_special.ExecSQL;
         oc_product_special.Free;


         oc_product_special:=TFDQuery.Create(nil);
         oc_product_special.Connection:=Mysqlcon;
         oc_product_special.Close;
         oc_product_special.SQL.Clear;
         oc_product_special.SQL.Add('INSERT INTO '+MysqlPrefixo+'product_special (`product_id`,`customer_group_id`, `price`, `date_start`, `date_end`) VALUES' +
                                  ' (:product_id,:fisica, :price, :date_start, :date_end)  ,'+
                                  ' (:product_id,:juridica, :price, :date_start, :date_end)  ');
         oc_product_special.ParamByName('product_id').AsInteger:=StrToInt(ss_codigo);
         oc_product_special.ParamByName('fisica').AsInteger:=1;
         oc_product_special.ParamByName('juridica').AsInteger:=2;
         oc_product_special.ParamByName('price').AsString:=StringReplace(pricePromo, ',', '.', []);
         oc_product_special.ParamByName('date_start').AsDate:=PromoIni;
         oc_product_special.ParamByName('date_end').AsDate:=PromoFim;
         oc_product_special.ExecSQL;
         oc_product_special.Free;
         end

       end;

      except
        On E:Exception do Begin
			  log_desc:= 'Não foi possivel cadastrar as promoções do produto '+ss_codigo;
        erros_log(ss_codigo, 890, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
        End;
      end;




       {Inicio do cadastro de categorias}

      //SEÇÃO -> cadastro
      TRY
        Synchronize(procedure begin
        frm_principal.lbl_Produto_2.Caption:='Configurando seção e grupo do produto';
        end);

      oc_category:= TFDQuery.Create(nil);
      oc_category.Connection:=Mysqlcon;
      oc_category.Close;
      oc_category.SQL.Clear;
      oc_category.SQL.Add('SELECT `category_id` FROM `'+MysqlPrefixo+'category` WHERE '+tabela_ecommerce+'= :codigo_secao and parent_id=''0'' ' );
       oc_category.ParamByName('codigo_secao').AsInteger:=StrToInt(codigo_secao);
      oc_category.Open();
      category_id:= oc_category.FieldByName('category_id').AsInteger;

      oc_category.Close;
      oc_category.SQL.Clear;
      oc_category.SQL.Add('INSERT INTO `'+MysqlPrefixo+'category` (' +
           ' `category_id`,`parent_id`, `top`, `column`, `sort_order`, `status`,' +
           '`date_added`, `date_modified`, `ss_secao`, `ss_secao_ecommerce` ) VALUES (' +
           ' :category_id, :parent_id, :top, :column, :sort_order, :status, :date_added,' +
           ' :date_modified, :ss_secao, :ss_secao_ecommerce)ON DUPLICATE KEY UPDATE '+
           ' `sort_order` =:sort_order, `status` =:status, `date_modified` =:date_modified ' );
      oc_category.ParamByName('category_id').AsInteger:=category_id;
      oc_category.ParamByName('parent_id').AsInteger:=0;
      oc_category.ParamByName('top').AsInteger:=1;
      oc_category.ParamByName('column').AsInteger:=1;
      oc_category.ParamByName('sort_order').AsInteger:=1;
      oc_category.ParamByName('status').AsInteger:=1;
      oc_category.ParamByName('date_added').AsDateTime:=date_modified;
      oc_category.ParamByName('date_modified').AsDateTime:=now;
      if secao_ecommerce <> '' then
        begin
        oc_category.ParamByName('ss_secao').DataType:=ftInteger;
        oc_category.ParamByName('ss_secao').Clear;
        oc_category.ParamByName('ss_secao_ecommerce').AsInteger:= StrToInt(secao_ecommerce);
        end
        else
        begin
        oc_category.ParamByName('ss_secao').AsInteger:= StrToInt(secao);
        oc_category.ParamByName('ss_secao_ecommerce').DataType:=ftInteger;
        oc_category.ParamByName('ss_secao_ecommerce').Clear;
        end ;
      oc_category.ExecSQL;
      oc_category.Free;

       EXCEPT
        On E:Exception do Begin
		   	log_desc:= 'Não foi possivel alterar a secao '+codigo_secao+'-'+des_secao_ecommerce;
        erros_log(ss_codigo, 930, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
        oc_category.Free;
        end;

      END;


      { Verifica novamente a ID da seção de produtos no e-commerce para vincurar com o grupo }
      TRY
      // Pega o IP da seção para informar no cadastro do grupo
      oc_category:=TFDQuery.Create(nil);
      oc_category.Connection:=Mysqlcon;
      oc_category.Close;
      oc_category.SQL.Clear;
      oc_category.SQL.Add('SELECT `category_id` FROM `'+MysqlPrefixo+'category` WHERE '+tabela_ecommerce+'= :codigo_secao and parent_id=''0'' ' );
       oc_category.ParamByName('codigo_secao').AsInteger:=StrToInt(codigo_secao);
      oc_category.Open();
      category_secao:= oc_category.FieldByName('category_id').AsInteger;


      //Verifica se o grupo ja existe
      oc_category.Close;
      oc_category.SQL.Clear;
      oc_category.SQL.Add('SELECT `category_id` FROM `'+MysqlPrefixo+'category` WHERE `ss_grupo` =:ss_grupo and '+tabela_ecommerce+'= :codigo_secao and parent_id=:parent_id ');
      oc_category.ParamByName('ss_grupo').AsInteger:=StrToInt(grupo);
      oc_category.ParamByName('codigo_secao').AsInteger:=StrToInt(codigo_secao);
      oc_category.ParamByName('parent_id').AsInteger:=category_secao;
      oc_category.Open();
      category_id:= oc_category.FieldByName('category_id').AsInteger;

      // GRUPO -> Cadasto
      oc_category.Close;
      oc_category.SQL.Clear;
      oc_category.SQL.Add('INSERT INTO `'+MysqlPrefixo+'category` ');
      oc_category.SQL.Add(' ( `category_id`, `parent_id`, `top`, `column`, `sort_order`,`status`,`date_added`,`date_Modified`,`ss_grupo`,'+tabela_ecommerce+') VALUES ');
      oc_category.SQL.Add(' (:category_id ,:parent_id, :top, :column,  :sort_order, :status, :date_added,:date_Modified, :ss_grupo, :codigo_ecommerce)'+
      ' ON DUPLICATE KEY UPDATE `parent_id` =:parent_id, `top` =:top,`column` =:column, `sort_order` =:sort_order,'+
      ' `status` =:status, `date_Modified` =:date_Modified ');
      oc_category.ParamByName('category_id').AsInteger:=category_id;
      oc_category.ParamByName('parent_id').AsInteger:=category_secao;
      oc_category.ParamByName('top').AsString:='0';
      oc_category.ParamByName('column').AsString:='0';
      oc_category.ParamByName('sort_order').AsString:='0';
      oc_category.ParamByName('status').AsString:='1';
      oc_category.ParamByName('date_added').AsDateTime:=now;
      oc_category.ParamByName('date_modified').AsDateTime:=now;
      oc_category.ParamByName('ss_grupo').AsInteger:=StrToInt(grupo);
      oc_category.ParamByName('codigo_ecommerce').AsInteger:=StrToInt(codigo_secao);
      oc_category.ExecSQL;
      oc_category.Free;

        EXCEPT
        On E:Exception do Begin
			  log_desc:= 'Não foi possivel alterar o grupo '+grupo;
          Synchronize(procedure begin
          erros_log(ss_codigo, 990, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
          end);

        oc_category.Free;
        End;
      END;


      {SEÇÃO -> DESCRIÇÃO  }
      TRY
      oc_category_description:=TFDQuery.Create(nil);
      oc_category_description.Connection:=Mysqlcon;
      oc_category_description.Close;
      oc_category_description.SQL.Clear;
      oc_category_description.SQL.Add('INSERT INTO `'+MysqlPrefixo+'category_description` (' +
          ' `category_id`,`language_id`,`name`,`description`,`meta_title`,' +
          ' `meta_description`, `meta_keyword`, '+tabela_ecommerce+', `ss_grupo`)' +
          'VALUES (' +
          ' :category_id, :language_id, :name, :description, :meta_title,' +
          ' :meta_description, :meta_keyword, :secao_ecommerce, :ss_grupo)' +
          ' ON DUPLICATE KEY UPDATE `language_id` =:language_id, `name` =:name, `meta_title`=:name, `meta_description`=:name, `meta_keyword`=:name');
      oc_category_description.ParamByName('category_id').AsInteger:=category_secao;
      oc_category_description.ParamByName('language_id').AsInteger:=StrToInt(cfgCodIdioma);
      oc_category_description.ParamByName('name').AsString:=des_secao_ecommerce;
      oc_category_description.ParamByName('description').AsString:='';
      oc_category_description.ParamByName('meta_title').AsString:=des_secao_ecommerce;
      oc_category_description.ParamByName('meta_description').AsString:=des_secao_ecommerce;
      oc_category_description.ParamByName('meta_keyword').AsString:=des_secao_ecommerce;
      oc_category_description.ParamByName('secao_ecommerce').AsInteger:=StrToInt(codigo_secao);
      oc_category_description.ParamByName('ss_grupo').AsInteger:=0;
      oc_category_description.ExecSQL;
      oc_category_description.Free;
        EXCEPT
        On E:Exception do Begin
			  log_desc:='Não foi Possivel cadastrar a descrição seção'+codigo_secao+'-'+des_secao_ecommerce+' do produto '+SS_CODIGO ;
          Synchronize(procedure begin
          erros_log(ss_codigo, 1020, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
          end);
          oc_category_description.Free;
        End;
      END;

      //VERIFICA SE EXISTE DESCRIÇÃO DO GRUPO DE PRODUTOS
      TRY
      {Primeiro retorna qual a ID do grupo}
      oc_category:=TFDQuery.Create(nil);
      oc_category.Connection:=Mysqlcon;
      oc_category.Close;
      oc_category.SQL.Clear;
      oc_category.SQL.Add('SELECT `category_id` FROM `'+MysqlPrefixo+'category` WHERE `ss_grupo` =:ss_grupo and '+tabela_ecommerce+'=:secao_ecommerce and `parent_id`=:parent_id ');
      oc_category.ParamByName('ss_grupo').AsInteger:=StrToInt(grupo) ;
      oc_category.ParamByName('secao_ecommerce').AsInteger:=StrToInt(codigo_secao) ;
      oc_category.ParamByName('parent_id').AsInteger:=category_secao ;
      oc_category.Open;
      {ID do grupo cadastrado no ecommerce}
      category_grupo:= oc_category.FieldByName('category_id').AsInteger;

      // GRUPO -> Descrição
      oc_category_description:=TFDQuery.Create(nil);
      oc_category_description.Connection:=Mysqlcon;
      oc_category_description.Close;
      oc_category_description.SQL.Clear;
      oc_category_description.SQL.Add('INSERT INTO `'+MysqlPrefixo+'category_description` '+
      ' (`category_id`,`language_id`,`name`,`description`,`ss_grupo`,'+tabela_ecommerce+',`meta_title`,'+
        '`meta_description`,`meta_keyword`) VALUES  (:category,:language,:name, :name,'+
      ' :ss_grupo,:secao_ecommerce,:name,:name,:name) ON DUPLICATE KEY UPDATE '+
      ' `language_id`= :language, `name`= :name, `description`= :name,'+
      '`meta_title`= :name,`meta_description`= :name,`meta_keyword`= :name');
      oc_category_description.ParamByName('language').AsInteger:=StrToInt(cfgCodIdioma);
      oc_category_description.ParamByName('category').AsInteger:=category_grupo;
      oc_category_description.ParamByName('name').AsString:=grupo_descricao;
      oc_category_description.ParamByName('ss_grupo').AsInteger:=StrToInt(grupo);
      oc_category_description.ParamByName('secao_ecommerce').AsInteger:=StrToInt(codigo_secao);
      oc_category_description.ExecSQL;
      oc_category.Free;
      oc_category_description.free;

       EXCEPT
       On E:Exception do Begin
			 log_desc:='Não foi Possivel cadastrar a descrição do grupo do produto '+SS_CODIGO ;
         Synchronize(procedure begin
         erros_log(ss_codigo, 1060, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
         end);
         oc_category.Free;
         oc_category_description.free;
       End;
      END;

      //SEÇÃO -> Empresa
      TRY
      oc_category_to_store:=TFDQuery.Create(nil);
      oc_category_to_store.Connection:=Mysqlcon;
      oc_category_to_store.SQL.Add('INSERT INTO `'+MysqlPrefixo+'category_to_store`');
      oc_category_to_store.SQL.Add(' (`category_id`, `store_id`) VALUES (:secao, :store_id)');
      oc_category_to_store.SQL.Add(' ON DUPLICATE KEY UPDATE store_id= :store_id ');
      oc_category_to_store.ParamByName('secao').AsInteger:= category_secao;
      oc_category_to_store.ParamByName('store_id').AsString:='0';
      oc_category_to_store.ExecSQL;
      oc_category_to_store.Free;

        EXCEPT
        On E:Exception do Begin
			  log_desc:='Não foi possivel relacionar a seção'+IntToStr(category_secao)+'-'+des_secao_ecommerce+' na empresa principal';
          Synchronize(procedure begin
          erros_log(ss_codigo, 1090, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
          end);
          oc_category_to_store.Free;
        End;
      END;

      //GRUPO -> Empresa
      TRY
      oc_category_to_store:=TFDQuery.Create(nil);
      oc_category_to_store.Connection:=Mysqlcon;
      oc_category_to_store.Close;
      oc_category_to_store.SQL.Clear;
      oc_category_to_store.SQL.Add('INSERT INTO `'+MysqlPrefixo+'category_to_store`');
      oc_category_to_store.SQL.Add(' (`category_id`, `store_id`) VALUES (:grupo, :store_id)');
      oc_category_to_store.SQL.Add(' ON DUPLICATE KEY UPDATE store_id= :store_id ');
      oc_category_to_store.ParamByName('grupo').AsInteger:= category_grupo;
      oc_category_to_store.ParamByName('store_id').AsString:='0';
      oc_category_to_store.ExecSQL;
      oc_category_to_store.Free;
      Except
       On E:Exception do Begin
       log_desc:='Não foi possivel relacionar o grupo na empresa principal';
         Synchronize(procedure begin
         erros_log(ss_codigo, 1110, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
         end);
         oc_category_to_store.Free;
       end;
      end;



      // SEÇÃO -> Patch
      TRY
      oc_category_path:= TFDQuery.Create(nil);
      oc_category_path.Connection:=Mysqlcon;
      oc_category_path.Close;
      oc_category_path.SQL.Clear;
      oc_category_path.SQL.Add('INSERT INTO `'+MysqlPrefixo+'category_path` (`category_id`,`path_id`,`level`) VALUES  ');
      oc_category_path.SQL.Add(' (:category_id, :path_id, :level) ');
      oc_category_path.SQL.Add(' ON DUPLICATE KEY UPDATE category_id=:category_id,path_id=:path_id, level=:level ');
      oc_category_path.ParamByName('path_id').AsInteger:=category_secao;
      oc_category_path.ParamByName('level').AsInteger:=0;
      oc_category_path.ParamByName('category_id').AsInteger:=category_secao;
      oc_category_path.ExecSQL;
      oc_category_path.Free;

       EXCEPT
        On E:Exception do Begin
			  log_desc:='Erro no patch da seção'+IntToStr(category_secao)+'-'+des_secao_ecommerce;
          Synchronize(procedure begin
          erros_log(ss_codigo, 1130, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
          end);
          oc_category_path.Free;
        End;
      END;





      //GRUPO -> Patch
      TRY
      oc_category_path:=TFDQuery.Create(nil);
      oc_category_path.Connection:=Mysqlcon;
      oc_category_path.Close;
      oc_category_path.SQL.Clear;
      oc_category_path.SQL.Add('SELECT category_id FROM `'+MysqlPrefixo+'category_path` WHERE `category_id` = :category_id AND `path_id`=:category_id ');
      oc_category_path.ParamByName('category_id').AsInteger:=category_grupo;
      oc_category_path.Open;
      grupo_path:=oc_category_path.FieldByName('category_id').AsInteger;

      oc_category_path.Close;
      oc_category_path.SQL.Clear;
      oc_category_path.SQL.Add('INSERT INTO `'+MysqlPrefixo+'category_path` (`category_id`,`path_id`,`level`) VALUES  ');
      oc_category_path.SQL.Add(' (:category_id, :path_id, :level) ');
      oc_category_path.SQL.Add(' ON DUPLICATE KEY UPDATE `category_id`= :category_id,`path_id`= :path_id,`level`= :level ');
      oc_category_path.ParamByName('category_id').AsInteger:=category_grupo;
      oc_category_path.ParamByName('path_id').AsInteger:=category_grupo;
      oc_category_path.ParamByName('level').AsInteger:=1;
      oc_category_path.ExecSQL;
      oc_category_path.Free;

      EXCEPT
        On E:Exception do Begin
	    	log_desc:='Erro no patch do grupo';
         Synchronize(procedure begin
         erros_log(ss_codigo, 1160, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
         end);
         oc_category_path.Free;
        End;
      END;







      // GRUPO X SEÇÃO -> Patch
      TRY
      oc_category_path:=TFDQuery.Create(nil);
      oc_category_path.Connection:=Mysqlcon;
      oc_category_path.Close;
      oc_category_path.SQL.Clear;
      oc_category_path.SQL.Add('SELECT `category_id`,`level` FROM `'+MysqlPrefixo+'category_path` WHERE `category_id`=:category_id AND `path_id`=:path_id ORDER BY LEVEL DESC LIMIT 1');
      oc_category_path.ParamByName('category_id').AsInteger:=category_grupo;
      oc_category_path.ParamByName('path_id').AsInteger:=category_secao;
      oc_category_path.Open;

      gru_se_path:= oc_category_path.FieldByName('category_id').AsInteger;
      level      := oc_category_path.FieldByName('level').AsInteger;

       if  (level > 0) then level := level + 1
       else level:=0;

      oc_category_path.Close;
      oc_category_path.SQL.Clear;
      oc_category_path.SQL.Add('INSERT INTO `'+MysqlPrefixo+'category_path` (`category_id`,`path_id`,`level`) VALUES');
      oc_category_path.SQL.ADD(' (:category_id, :path_id, :level) ON DUPLICATE KEY UPDATE ');
      oc_category_path.SQL.ADD('`category_id`= :category_id,`path_id`= :path_id,`level`= :level');
      oc_category_path.ParamByName('category_id').AsInteger:=category_grupo;
      oc_category_path.ParamByName('path_id').AsInteger:=category_secao;
      oc_category_path.ParamByName('level').AsInteger:=level;
      oc_category_path.ExecSQL;
      oc_category_path.Free;

      EXCEPT
        On E:Exception do Begin
			  log_desc:= 'Não foi Possivel vincular grupo - '+IntToStr(category_grupo)+' na seção - '+IntToStr(category_secao);
         Synchronize(procedure begin
         erros_log(ss_codigo, 1200, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
         end );
         oc_category_path.Free
        End;
      end;

      // PRODTUO -> Grupo
       TRY
      oc_product_to_category:=TFDQuery.Create(nil);
      oc_product_to_category.Connection:=Mysqlcon;
      oc_product_to_category.Close;
      oc_product_to_category.SQL.Clear;
      oc_product_to_category.SQL.Add('INSERT INTO `'+MysqlPrefixo+'product_to_category` ');
      oc_product_to_category.SQL.Add(' (`product_id`, `category_id`) VALUES (:product_id,:category_id ) ');
      oc_product_to_category.SQL.Add(' ON DUPLICATE KEY UPDATE `category_id` =:category_id ');
      oc_product_to_category.ParamByName('product_id').AsInteger:=StrToInt(SS_CODIGO);
      oc_product_to_category.ParamByName('category_id').AsInteger:=category_grupo;
      oc_product_to_category.ExecSQL;
      oc_product_to_category.Free;

      EXCEPT
        On E:Exception do Begin
			  log_desc:= 'Não foi Possivel vincular produto ao grupo- '+IntToStr(category_grupo);
          Synchronize(procedure begin
          erros_log(ss_codigo, 1230, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
          end);
          oc_product_to_category.Free;
        End;
      END;


       //////////////////////////////////////////////////
      {Verifica se o produto mestre esta cadastrado no ssplus, caso não esteja
      o bloco de conteudo a baixo não é executado}

        Synchronize(procedure begin
        frm_principal.lbl_Produto_2.Caption:='Excluindo produtos similares antigos';
        end);


       // Deleta os produtos similares  do produto

        if produto_mestre = '' then
        begin
          try
          oc_product_related:=TFDQuery.Create(nil);
          oc_product_related.Connection:=Mysqlcon;
          oc_product_related.Close;
          oc_product_related.SQL.Clear;
          oc_product_related.SQL.Add('DELETE FROM `'+MysqlPrefixo+'product_related` WHERE ' +
                                   ' `product_id`= :product_id OR `related_id`= :product_id');
          oc_product_related.ParamByName('product_id').AsString:=ss_codigo;
          oc_product_related.ExecSQL;
          oc_product_related.Free;
          except
            On E:Exception do Begin

			      log_desc:= 'Deletar produtos similares oc_product_related - '+produto_mestre ;
              Synchronize(procedure begin
              erros_log(ss_codigo, 1310, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
              end);
              oc_product_related.Free;

            End;

          end;
        end

        ELSE
        // Deleta os produtos similares  do produto
        begin
          try
          oc_product_related:=TFDQuery.Create(nil);
          oc_product_related.Connection:=Mysqlcon;
          oc_product_related.Close;
          oc_product_related.SQL.Clear;
          oc_product_related.SQL.Add('DELETE FROM `'+MysqlPrefixo+'product_related` WHERE ' +
              ' `product_id`= :CodInterno OR `related_id`= :CodInterno OR ' +
              ' `product_id`= :mestre     OR `related_id`= :mestre');
          oc_product_related.ParamByName('CodInterno').AsString:=ss_codigo;
          oc_product_related.ParamByName('mestre').AsString:=produto_mestre;
          oc_product_related.ExecSQL;
          oc_product_related.Free;
          except
               On E:Exception do Begin

			      log_desc:= 'Deletar produtos similares - '+produto_mestre ;
              Synchronize(procedure begin
              erros_log(ss_codigo, 1340, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
              end);
              oc_product_related.Free;

            End;
          end;

        // Pesquisa todos os produtos similares
          Synchronize(procedure begin
          frm_principal.lbl_Produto_2.Caption:='Pesquisando similares do produto '+ss_codigo+' (Pode demorar)';
          end);

          Try
          produtos_similares:= TFDQuery.Create(nil);
          produtos_similares.Connection:=PgsqlConnProduto;
          produtos_similares.close;
          produtos_similares.SQL.Clear;
          produtos_similares.SQL.Add('SELECT codigo_interno from produtos_ecommerce where produto_mestre= :produto_mestre and codigo_empresa= :codigo_empresa');
          produtos_similares.ParamByName('produto_mestre').AsString:=produto_mestre;
          produtos_similares.ParamByName('codigo_empresa').AsString:=cfgEmpresa;
          produtos_similares.Open;
            Except
            On E:Exception do Begin

			      log_desc:= 'Selecionar similares no postgres - '+produto_mestre ;
              Synchronize(procedure begin
              erros_log(ss_codigo, 1350, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
              end);
              produtos_similares.free;

            End;
          End;


        {Executa essa rotina até acabar os produtos similares do produto mestre}
          While not produtos_similares.eof do
          begin
            try
            codigo_similar := produtos_similares.FieldByName('codigo_interno').AsString;
            except
              On E:Exception do Begin

			        log_desc:= 'Atribuir valor a variavel codigo_similar - '+produto_mestre ;
                Synchronize(procedure begin
                erros_log(ss_codigo, 1380, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                end);

              End;
            end;

            Try

            if codigo_similar = ss_codigo then
              begin
              {Cadastra os produtos similares}
              oc_product_related:=TFDQuery.Create(nil);
              oc_product_related.Connection:=Mysqlcon;
              oc_product_related.Close;
              oc_product_related.SQL.Clear;
              oc_product_related.SQL.Add(' INSERT INTO `'+MysqlPrefixo+'product_related`' +
                                                  ' (`product_id`, `related_id`) VALUES' +
                                                  ' (:produto , :Mestre)     ,' +
                                                  ' (:Mestre  , :produto)    ,' +
                                                  ' (:Mestre  , :Mestre)    ,' +
                                                  ' (:produto , :CodInterno) ' +
                                                  ' ON DUPLICATE KEY UPDATE '+
                                                  ' `product_id`=VALUES(product_id), `related_id`=VALUES(related_id) ');
              oc_product_related.ParamByName('produto').AsString:=codigo_similar;
              oc_product_related.ParamByName('Mestre').AsString:=produto_mestre;
              oc_product_related.ParamByName('CodInterno').AsString:=ss_codigo;
              oc_product_related.ExecSQL;
              oc_product_related.Free;
              end
                else
              begin
              oc_product_related:=TFDQuery.Create(nil);
              oc_product_related.Connection:=Mysqlcon;
              oc_product_related.Close;
              oc_product_related.SQL.Clear;
              oc_product_related.SQL.Add(' INSERT INTO `'+MysqlPrefixo+'product_related`' +
                                                  ' (`product_id`, `related_id`) VALUES' +
                                                  ' (:produto , :Mestre)     ,' +
                                                  ' (:Mestre  , :produto)    ,' +
                                                  ' (:produto , :CodInterno) ,'  +
                                                  ' (:CodInterno, :produto)' +
                                                  ' ON DUPLICATE KEY UPDATE ' +
                                                  ' `product_id`=VALUES(product_id), `related_id`=VALUES(related_id)'  );
              oc_product_related.ParamByName('produto').AsString:=codigo_similar;
              oc_product_related.ParamByName('Mestre').AsString:=produto_mestre;
              oc_product_related.ParamByName('CodInterno').AsString:=ss_codigo;
              oc_product_related.ExecSQL;
              oc_product_related.Free;
              end;

            except
              On E:Exception do Begin
			        log_desc:= '(1395-1423)Não foi possivel cadastrar o similar '+codigo_similar+' do produtos '+produto_mestre ;
                Synchronize(procedure begin
                erros_log(ss_codigo, 1410, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                end);
                oc_product_related.Free;

			        end;
            End;


          produtos_similares.Next;
          Continue          ;
          end;

        end;




      {Final do cadastro de produto similares}




      { ** Caracteristicas dos produtos

       Os dadis de caracteristicas de produtos são disponibilizados através de um
       objeto de visualização do banco de daods (view). O nome do objeto
       produtos_ecommerce_catacteristicas. As caracteristicas são cadastradas de
       acordo com cada clinete e produto.
      }


      {Antes de entrar no cadastro de caracteristicas
      elas são deletadas do produto}
      Synchronize(procedure begin
      frm_principal.lbl_Produto_2.Caption:='Configurando as caracteristicas do produto (Pode demorar)';
      end);

      try
      oc_product_attribute:=TFDQuery.Create(nil);
      oc_product_attribute.Connection:=Mysqlcon;
      oc_product_attribute.Close;
      oc_product_attribute.SQL.Clear;
      oc_product_attribute.SQL.Add('DELETE FROM `'+MysqlPrefixo+'product_attribute` where `product_id`= :product_id');
      oc_product_attribute.ParamByName('product_id').AsString:=ss_codigo;
      oc_product_attribute.ExecSQL;
      oc_product_attribute.Free;
      except
        On E:Exception do Begin
			  log_desc:= 'Não foi possivel excluir as caracteristicas do produto' ;
          Synchronize(procedure begin
          erros_log(ss_codigo, 1390, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
			    end);
          oc_product_attribute.Free;
			  end;
      end;



            {Deleta os filtros do produto}
      Try
      {Verifica se o filtro esta relacionado no produto}
      oc_product_filter:=TFDQuery.Create(nil);
      oc_product_filter.Connection:=Mysqlcon;
      oc_product_filter.Close;
      oc_product_filter.SQL.Clear;
      oc_product_filter.SQL.Add(' DELETE FROM `'+MysqlPrefixo+'product_filter` WHERE `product_id`= :product_id'  );
      oc_product_filter.ParamByName('product_id').AsString:=ss_codigo;
      oc_product_filter.ExecSQL;
      oc_product_filter.Free;
      except
        On E:Exception do Begin
			  log_desc:= 'Não foi possivel deletar os atributos do produto cod: '+SS_CODIGO ;
          Synchronize(procedure begin
          erros_log(ss_codigo, 1410, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
          end);
          oc_product_filter.Free;
        end;
      End;




      {Pesquisa todas as caracteristicas do produto para cadastra-las.
      (Não vincula ao produto ainda.)}
      Synchronize(procedure begin
      frm_principal.lbl_Produto_2.Caption:='Configurando as caracteristicas do produto(Pode demorar)';
      end);

       try
      produtos_caracteristicas:= TFDQuery.Create(nil);
      produtos_caracteristicas.Connection:=PgsqlConnProduto;
      produtos_caracteristicas.Close;
      produtos_caracteristicas.SQL.Clear;
      produtos_caracteristicas.SQL.Add('SELECT * FROM produtos_ecommerce_caracteristicas where ' +
                                                               ' codigo_interno= :ss_codigo' );
      produtos_caracteristicas.ParamByName('ss_codigo').AsString:=ss_codigo;
      produtos_caracteristicas.Open;
      except
        On E:Exception do Begin
        log_desc:= 'Não foi possivel fazer select na produtos_ecommerce_caracteristicas : '+SS_CODIGO ;
          Synchronize(procedure begin
          erros_log(ss_codigo, 1520, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
          end );
          produtos_caracteristicas.Free;
			  end;
      end;

      {Executo rotinas até acabar as caracteristicas do produto}
      //try
        if (produtos_caracteristicas.RecordCount <> 0) then
        begin
          While not produtos_caracteristicas.Eof do
          begin


          {Pega os valores da caracteristica dos produtos e atribui nas variaveis}
          codigo_caracteristica   := produtos_caracteristicas.FieldByName('codigo_caracteristica').AsString;
          descricao_caracteristica:= produtos_caracteristicas.FieldByName('descricao_caracteristica').AsString;
          valor_caracteristica    :=Tamanho_Maximo_string(produtos_caracteristicas.FieldByName('valor_caracteristica').AsString, 50) ;
          filtro_ecommerce        := produtos_caracteristicas.FieldByName('filtro_ecommerce').AsString;

            try
            oc_attribute_group:=TFDQuery.Create(nil);
            oc_attribute_group.Connection:=Mysqlcon;
            oc_attribute_group.Close;
            oc_attribute_group.SQL.Clear;
            oc_attribute_group.SQL.Add('INSERT INTO `'+MysqlPrefixo+'attribute_group` (`attribute_group_id`,`sort_order`) VALUES ' +
                                                    ' (:attribute_group_id, :sort_order) ON DUPLICATE KEY UPDATE ' +
                                                    ' `attribute_group_id`=:attribute_group_id, `sort_order`=:sort_order');
            oc_attribute_group.ParamByName('attribute_group_id').AsString:='100';
            oc_attribute_group.ParamByName('sort_order').AsString:='1';
            oc_attribute_group.ExecSQL;
            oc_attribute_group.Free;

             except
              On E:Exception do Begin
              log_desc:= 'Não foi possivel cadastrar o grupo de atributos do produto: '+SS_CODIGO ;
                Synchronize(procedure begin
                erros_log(ss_codigo, 1460, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                end );
                oc_attribute_group.Free;
			        end;
            end;

          {Cadastra a descrição do grupo de atributos}
            try
            oc_attribute_group_description:=TFDQuery.Create(nil);
            oc_attribute_group_description.Connection:=Mysqlcon;
            oc_attribute_group_description.Close;
            oc_attribute_group_description.SQL.Clear;
            oc_attribute_group_description.SQL.Add('INSERT INTO `'+MysqlPrefixo+'attribute_group_description` ' +
                                                    ' (`attribute_group_id`, `language_id`, `name`) ' +
                                                    ' VALUES (:attribute_group_id, :language_id, :name) ' +
                                                    ' ON DUPLICATE KEY UPDATE  ' +
                  '`attribute_group_id`=:attribute_group_id, `language_id`= :language_id,`name`= :name');
            oc_attribute_group_description.ParamByName('attribute_group_id').AsString:='100' ;
            oc_attribute_group_description.ParamByName('language_id').AsString:=cfgCodIdioma;
            oc_attribute_group_description.ParamByName('name').AsString:='Características do produto' ;
            oc_attribute_group_description.ExecSQL;
            oc_attribute_group_description.Free;

             except
              On E:Exception do Begin
			        log_desc:= 'Não foi possivel cadastrar a descrição do grupo de atributos do produto: '+ss_codigo; ;
                 Synchronize(procedure begin
                erros_log(ss_codigo, 1490, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                end);
                oc_attribute_group_description.Free;
			        end;
             end;


          {Depois de ter cadastrado o grupo de atributos
          agora é cadastrado os atributos e vinculados ao grupo
          para depois relacionar ao cadastro de produtos.}

          {Verifica se o atributo ja esta cadastrado}
            try
            oc_attribute:=TFDQuery.Create(nil);
            oc_attribute.Connection:=Mysqlcon;
            oc_attribute.Close;
            oc_attribute.SQL.Clear;
            oc_attribute.SQL.Add('INSERT INTO `'+MysqlPrefixo+'attribute` (`attribute_id`,`attribute_group_id`,`sort_order`) ' +
                                                    ' VALUES (:attribute_id, :attribute_group_id, :sort_order )  ' +
                                                    ' ON DUPLICATE KEY UPDATE `attribute_id`=:attribute_id ,  ' +
                                                    ' `attribute_group_id`=:attribute_group_id,`sort_order`= :sort_order ' );
            oc_attribute.ParamByName('attribute_group_id').AsString:='100' ;
            oc_attribute.ParamByName('sort_order').AsString:='1' ;
            oc_attribute.ParamByName('attribute_id').AsString:=codigo_caracteristica ;
            oc_attribute.ExecSQL;
            oc_attribute.Free;

             except
              On E:Exception do Begin
			        log_desc:= 'Atributos '+codigo_caracteristica+' do produto não foi concluido. cod. produto: '+SS_CODIGO ;
                Synchronize(procedure begin
                erros_log(ss_codigo, 1520, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                end);
                oc_attribute.Free;
			        end;

            end;

            try
            {Cadastra a descrição de cada atributo}
            oc_attribute_description:= TFDQuery.Create(nil);
            oc_attribute_description.Connection:=Mysqlcon;
            oc_attribute_description.Close;
            oc_attribute_description.SQL.Clear;
            oc_attribute_description.SQL.Add('INSERT INTO `'+MysqlPrefixo+'attribute_description` ' +
                  ' (`attribute_id`,`language_id`,`name`) VALUES (:attribute_id, :language_id, :name ) ' +
                    ' ON DUPLICATE KEY UPDATE `attribute_id`= :attribute_id,  ' +
                        '`language_id`= :language_id,`name`= :name' );
            oc_attribute_description.ParamByName('attribute_id').AsString:=codigo_caracteristica ;
            oc_attribute_description.ParamByName('language_id').AsString:=cfgCodIdioma ;
            oc_attribute_description.ParamByName('name').AsString:=descricao_caracteristica ;
            oc_attribute_description.ExecSQL;
            oc_attribute_description.Free;

             except
              On E:Exception do Begin
			        log_desc:= 'Descrição dos atributos'+codigo_caracteristica+'-'+descricao_caracteristica+' não foi concluido. cod. produto: '+SS_CODIGO ;
                Synchronize(procedure begin
                erros_log(ss_codigo, 1540, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                end);
                oc_attribute_description.Free;
			        end;
            end;


            Try
            {Insere o atributo no produto.
            Antes de entrar no bloco de codigos da view de caracteristicas, os atributos dos produtos
            são deletados, depois são recadastrados para que não fiquem no produto
            atributos antigos.}

            {Cadastra o atributo no produto}
            oc_product_attribute:=TFDQuery.Create(nil);
            oc_product_attribute.Connection:=Mysqlcon;
            oc_product_attribute.Close;
            oc_product_attribute.SQL.Clear;
            oc_product_attribute.SQL.Add('INSERT INTO `'+MysqlPrefixo+'product_attribute` '  +
                                                  ' (`product_id`,`attribute_id`,`language_id`,`text`) '  +
                                                  ' VALUES ' +
                                                  ' (:product_id,:attribute_id,:language_id,:text) ');
            oc_product_attribute.ParamByName('language_id').AsString:=cfgCodIdioma;
            oc_product_attribute.ParamByName('text').AsString:=valor_caracteristica;
            oc_product_attribute.ParamByName('product_id').AsString:=ss_codigo;
            oc_product_attribute.ParamByName('attribute_id').AsString:=codigo_caracteristica;
            oc_product_attribute.ExecSQL;
            oc_product_attribute.Free;

            except
              On E:Exception do Begin
			        log_desc:= 'Os atributos'+codigo_caracteristica+'-'+descricao_caracteristica+' não foram concluidos. cod. produto: '+SS_CODIGO ;
                 Synchronize(procedure begin
                 erros_log(ss_codigo, 1570, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                 end);
                 oc_product_attribute.Free;
			        end;

            End;


           {======================================}
           {=== Cadastra o filtro dos produtos ===}
           {======================================}


           {Se a caracteristica do produto
           também for um filtro, executa o bloco a baixo}

           if (filtro_ecommerce = 'S') then
            begin
                 Synchronize(procedure begin
                 frm_principal.lbl_Produto_2.Caption:='Configurando filtros do produto';
                 end);
              Try
              oc_filter_group:= TFDQuery.Create(nil);
              oc_filter_group.Connection:=Mysqlcon;
              oc_filter_group.Close;
              oc_filter_group.SQL.Clear;
              oc_filter_group.SQL.Add('INSERT INTO `'+MysqlPrefixo+'filter_group` (`filter_group_id`,`sort_order`) VALUES ' +
                                           '(:filter_group_id, :sort_order) ON DUPLICATE KEY UPDATE ' +
                                           ' `filter_group_id`=:filter_group_id,`sort_order`= :sort_order' ) ;
              oc_filter_group.ParamByName('filter_group_id').AsString:=codigo_caracteristica;
              oc_filter_group.ParamByName('sort_order').AsString:='0';
              oc_filter_group.ExecSQL;
              oc_filter_group.Free;

              except
                On E:Exception do Begin
			          log_desc:= 'Grupo de filtros '+codigo_caracteristica+' não foi cadastrado. Produto cod. '+SS_CODIGO ;
                  Synchronize(procedure begin
                  erros_log(ss_codigo, 1610, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                  end);
                  oc_filter_group.Free;
			          end;
              End;

            {==Cadastra a descrição do grupo de filtros}
              Try
              oc_filter_group_description:=TFDQuery.Create(nil);
              oc_filter_group_description.Connection:=Mysqlcon;
              oc_filter_group_description.Close;
              oc_filter_group_description.SQL.Clear;
              oc_filter_group_description.SQL.Add('INSERT INTO `'+MysqlPrefixo+'filter_group_description` (`filter_group_id`,`name`,`language_id`) ' +
                                         ' VALUES (:filter_group_id, :name, :language_id ) ON DUPLICATE KEY UPDATE ' +
                                         ' `filter_group_id`= :filter_group_id,`name`= :name,`language_id`= :language_id ') ;
              oc_filter_group_description.ParamByName('filter_group_id').AsString:=codigo_caracteristica ;
              oc_filter_group_description.ParamByName('name').AsString:=descricao_caracteristica ;
              oc_filter_group_description.ParamByName('language_id').AsString:=cfgCodIdioma ;
              oc_filter_group_description.ExecSQL;
              oc_filter_group_description.Free;
              except
                On E:Exception do Begin
			          log_desc:= 'Grupo de atributos '+codigo_caracteristica+'-'+descricao_caracteristica+' não foi cadastrado. Produto cod. '+SS_CODIGO ;
                  Synchronize(procedure begin
                  erros_log(ss_codigo, 1630, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                  end);
                  oc_filter_group_description.Free;
			          end;
              End;


              {=== Cadastro o valor dos filtros ===}
              Try
              {Seleciona os filtros da tabela filter}
              oc_filter:=TFDQuery.Create(nil);
              oc_filter.Connection:=Mysqlcon;
              oc_filter.Close;
              oc_filter.SQL.Clear;
              oc_filter.SQL.Add('SELECT `filter_id` FROM `'+MysqlPrefixo+'filter` WHERE `name` = :name');
              oc_filter.ParamByName('name').AsString:=valor_caracteristica;
              oc_filter.Open();

              resposta_filtro:= oc_filter.FieldByName('filter_id').AsString;




              oc_filter.Close;
              oc_filter.SQL.Clear;
              oc_filter.SQL.Add( ' INSERT INTO `'+MysqlPrefixo+'filter` (`filter_id`,`filter_group_id`,`sort_order`,`name`) VALUES ' +
                                           ' (:filter_id, :filter_group_id, :sort_order, :name) ON DUPLICATE KEY UPDATE ' +
                                           '`filter_id`=:filter_id,`filter_group_id`= :filter_group_id,`sort_order`= :sort_order,`name`= :name ');
              oc_filter.Params[0].DataType := ftAutoInc;
              if resposta_filtro=''  then
              oc_filter.ParamByName('filter_id').Clear //esse campo vem NULL quando não existe registro
              else
              oc_filter.ParamByName('filter_id').Value:=resposta_filtro;
              oc_filter.ParamByName('filter_group_id').AsString:=codigo_caracteristica;
              oc_filter.ParamByName('sort_order').AsString:='0';
              oc_filter.ParamByName('name').AsString:=valor_caracteristica;
              oc_filter.ExecSQL;
              oc_filter.Free;

              //Atribui a ID do filtro novamente para cadastros de baixo;
              oc_filter:=TFDQuery.Create(nil);
              oc_filter.Connection:=Mysqlcon;
              oc_filter.Close;
              oc_filter.SQL.Clear;
              oc_filter.SQL.Add('SELECT `filter_id` FROM `'+MysqlPrefixo+'filter` WHERE `name` = :name');
              oc_filter.ParamByName('name').AsString:=valor_caracteristica;
              oc_filter.Open();

              resposta_filtro:= oc_filter.FieldByName('filter_id').asstring;
              oc_filter.Free;

              Except
                On E:Exception do Begin
			          log_desc:= 'Atributos '+codigo_caracteristica+'-'+descricao_caracteristica+' Valor:'+valor_caracteristica+' não foi cadastrado. Produto cod. '+SS_CODIGO ;
                  Synchronize(procedure begin
                  erros_log(ss_codigo, 1660, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                  end);
                  oc_filter.Free;
			          end;
              End;

              Try
              {Cadastra ou atualiza a descrição do filtro}
              oc_filter_description:=TFDQuery.Create(nil);
              oc_filter_description.Connection:=Mysqlcon;
              oc_filter_description.Close;
              oc_filter_description.SQL.Clear;
              oc_filter_description.SQL.Add( ' INSERT INTO `'+MysqlPrefixo+'filter_description` ' +
                                           ' (`filter_id`,`language_id`,`filter_group_id`,`name`) VALUES ' +
                                           ' (:filter_id, :language_id, :filter_group_id, :name) ON DUPLICATE KEY UPDATE '+
                                           '`filter_id`=:filter_id,`language_id`= :language_id,`filter_group_id`= :filter_group_id,`name`= :name');
              oc_filter_description.ParamByName('filter_id').Value :=resposta_filtro; // Recebe o valor na query de cima.
              oc_filter_description.ParamByName('language_id').AsString:=cfgCodIdioma;
              oc_filter_description.ParamByName('filter_group_id').AsString:=codigo_caracteristica;
              oc_filter_description.ParamByName('name').AsString:=Tamanho_Maximo_string(valor_caracteristica,50);
              oc_filter_description.ExecSQL;
              oc_filter_description.Free;

              except
                On E:Exception do Begin
			          log_desc:= 'Descrição do filtro '+filter_id+'-'+codigo_caracteristica+' Valor:'+valor_caracteristica+' não foi cadastrado. Produto cod. '+SS_CODIGO ;
                  Synchronize(procedure begin
                  erros_log(ss_codigo, 1690, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                  end);
                  oc_filter_description.Free;
			          end;
               End;

             {Captura o id do filtro}
              Try

              {=== Relaciona o filtro no produto === }
              oc_product_filter:=TFDQuery.Create(nil);
              oc_product_filter.Connection:=Mysqlcon;
              oc_product_filter.Close;
              oc_product_filter.SQL.Clear;
              oc_product_filter.SQL.Add('INSERT INTO `'+MysqlPrefixo+'product_filter` (`product_id`,`filter_id`) VALUES ' +
                                            ' (:product_id, :filter_id) ON DUPLICATE KEY UPDATE  ' +
                                            ' `product_id`=:product_id,`filter_id`=:filter_id' ) ;
              oc_product_filter.ParamByName('product_id').AsString:=ss_codigo;
              oc_product_filter.ParamByName('filter_id').Value:=resposta_filtro;
              oc_product_filter.ExecSQL;
              oc_product_filter.Free;
              Except
                On E:Exception do Begin
			          log_desc:= 'Filtro '+filter_id+'-'+codigo_caracteristica+' não foi cadastrado no produto cod. '+SS_CODIGO ;
                  Synchronize(procedure begin
                  erros_log(ss_codigo, 1720, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                  end);
                  oc_product_filter.Free;
			          end;
              End;


            { === Relaciona o filtro no departamento === }
              Try
              oc_category_filter:=TFDQuery.Create(nil);
              oc_category_filter.Connection:=Mysqlcon;

              oc_category_filter.Close;
              oc_category_filter.SQL.Clear;
              oc_category_filter.SQL.Add('INSERT INTO `'+MysqlPrefixo+'category_filter` (`category_id`,`filter_id`) ' +
                                            ' VALUES (:category_id,:filter_id) ON DUPLICATE KEY UPDATE ' +
                                            ' `category_id`= :category_id,`filter_id`=:filter_id  '  );
              oc_category_filter.ParamByName('category_id').AsInteger:= category_grupo;
              oc_category_filter.ParamByName('filter_id').Value:= resposta_filtro;
              oc_category_filter.ExecSQL;
              oc_category_filter.Free;

              Except
                On E:Exception do Begin
			          log_desc:= 'Filtro '+filter_id+'-'+codigo_caracteristica+' não vinculado ao departamento '+IntToStr(category_grupo)+' produto cod. '+SS_CODIGO ;
                  Synchronize(procedure begin
                  erros_log(ss_codigo, 1740, nome, grupo+'-'+grupo_descricao, secao+'-'+secao_descricao,log_desc, E.Message );
                  end);
                  oc_category_filter.Free;
			          end;
              End;
            END;

          { passa para o proximo atributo}
          produtos_caracteristicas.Next;

          Continue          ;
          end;


        end;





    end;


              Query_VWprodutos.Next; // passa para o proximo produto,
              Continue          ;

  end;

 end;

   if (Query_VWprodutos.RecordCount <> 0) then
  Begin
    if (StrToInt(SS_CODIGO) = Uregistro) then
    begin
    ArqIni.WriteBool('ATUALIZACAO','UpCompleto',true);
      Synchronize(procedure begin
      frm_principal.lbl_Produto_1.Caption:='Proutos atualizados com sucesso';
      Frm_Principal.lbl_Produto_2.Caption:='Ultima atualização '+TimeToStr(time());
      Frm_Principal.BTN_envia_produtos.Enabled:=true;
      Frm_Principal.BTN_envia_produtos.Caption:='Enviar';
      frm_principal.indProdutos.Animate:=false;
      Query_VWprodutos.Free;
      end );


     I := FindFirst('.\TEMP\*.*', faAnyFile, SR);
      while I = 0 do
      begin
       DeleteFile('.\TEMP\' + SR.Name);
      I := FindNext(SR);
      end;

    end;

    end else

    begin
    ArqIni.WriteBool('ATUALIZACAO','UpCompleto',true);
      Synchronize(procedure begin
      frm_principal.lbl_Produto_1.Caption:='Nenum produto encontrado para atualizar';
      Frm_Principal.lbl_Produto_2.Caption:='Ultima verificação '+TimeToStr(time());
      Frm_Principal.BTN_envia_produtos.Enabled:=true;
      Frm_Principal.BTN_envia_produtos.Caption:='Enviar';
      frm_principal.indProdutos.Animate:=false;
      Query_VWprodutos.Free;
      end);


  end;





 end;

 end.



