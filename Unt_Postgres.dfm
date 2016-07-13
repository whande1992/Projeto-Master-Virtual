object Data_Postgres: TData_Postgres
  OldCreateOrder = False
  Height = 526
  Width = 756
  object Driver_Postgres: TFDPhysPgDriverLink
    VendorHome = 
      'E:\Opencart\Opencart\Comunicador\LojaMaster 2.0\Win32\Debug\Driv' +
      'ers\PGSql'
    VendorLib = 'libpq.dll'
    Left = 616
    Top = 8
  end
  object Query_produtos: TFDQuery
    Connection = FD_Postgres
    SQL.Strings = (
      
        'select codigo,ativo, marca,descr1,secao,grupo, subgru,dessub,cod' +
        'ire, prvist, basico, ualter_a, localiza, cancelado, aplica,envia' +
        '_site, desconto_ecommerce from PCCDITE0 where codigo= :codigo or' +
        ' codire= :codire or basico= :basico or descr1 like :descr1')
    Left = 40
    Top = 176
    ParamData = <
      item
        Name = 'CODIGO'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'CODIRE'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'BASICO'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'DESCR1'
        DataType = ftString
        ParamType = ptInput
      end>
    object Query_produtoscodigo: TStringField
      DisplayLabel = 'C'#243'd.'
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      FixedChar = True
      Size = 6
    end
    object Query_produtosbasico: TStringField
      DisplayLabel = 'C'#243'd. Fabricante'
      FieldName = 'basico'
      Origin = 'basico'
      FixedChar = True
      Size = 16
    end
    object Query_produtosmarca: TStringField
      DisplayLabel = 'Marca'
      FieldName = 'marca'
      Origin = 'marca'
      FixedChar = True
      Size = 5
    end
    object Query_produtosdescr1: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'descr1'
      Origin = 'descr1'
      Size = 120
    end
    object Query_produtosprvist: TBCDField
      DisplayLabel = 'Pre'#231'o'
      FieldName = 'prvist'
      Origin = 'prvist'
      DisplayFormat = 'R$ ###,###,##0.00'
      Precision = 12
      Size = 3
    end
    object Query_produtosdesconto_ecommerce: TBCDField
      DisplayLabel = 'Desconto Site'
      FieldName = 'desconto_ecommerce'
      Origin = 'desconto_ecommerce'
      Precision = 7
      Size = 2
    end
    object Query_produtoslocaliza: TStringField
      Alignment = taCenter
      DisplayLabel = 'Localiza'#231#227'o'
      FieldName = 'localiza'
      Origin = 'localiza'
      FixedChar = True
      Size = 9
    end
    object Query_produtossecao: TStringField
      DisplayLabel = 'Se'#231#227'o'
      FieldName = 'secao'
      Origin = 'secao'
      FixedChar = True
      Size = 4
    end
    object Query_produtosgrupo: TStringField
      DisplayLabel = 'Grupo'
      FieldName = 'grupo'
      Origin = 'grupo'
      FixedChar = True
      Size = 4
    end
    object Query_produtossubgru: TStringField
      DisplayLabel = 'Subgrupo'
      FieldName = 'subgru'
      Origin = 'subgru'
      FixedChar = True
      Size = 4
    end
    object Query_produtoscodire: TStringField
      DisplayLabel = 'C'#243'd. Barras'
      FieldName = 'codire'
      Origin = 'codire'
      FixedChar = True
      Size = 15
    end
  end
  object FDGUI_Postgres: TFDGUIxWaitCursor
    Provider = 'Console'
    Left = 528
    Top = 8
  end
  object DTSource_Produtos: TDataSource
    DataSet = Query_VWprodutos
    Left = 216
    Top = 16
  end
  object DS_VW_Produtos: TClientDataSet
    Aggregates = <>
    MasterSource = DTSource_Produtos
    PacketRecords = 0
    Params = <>
    Left = 320
    Top = 16
  end
  object UPdate_Produtos: TFDQuery
    MasterSource = DTSource_Produtos
    Connection = FD_Postgres
    Left = 144
    Top = 112
  end
  object Query_VWprodutos: TFDQuery
    Connection = FD_Postgres
    Left = 40
    Top = 112
  end
  object FD_Postgres: TFDConnection
    Params.Strings = (
      'User_Name=ssecomm'
      'Password=ecomm@2016'
      'LoginTimeout=10'
      'ApplicationName=Master Virtual'
      'UnknownFormat=BYTEA'
      'CharacterSet=LATIN1'
      'Server='
      'DriverID=PG')
    FetchOptions.AssignedValues = [evMode, evRowsetSize, evCache, evAutoClose, evRecordCountMode, evLiveWindowFastFirst]
    FetchOptions.Mode = fmAll
    FetchOptions.RowsetSize = 300
    FetchOptions.RecordCountMode = cmFetched
    FetchOptions.LiveWindowFastFirst = True
    ResourceOptions.AssignedValues = [rvDefaultParamType, rvAutoConnect, rvAutoReconnect]
    ResourceOptions.AutoReconnect = True
    UpdateOptions.AssignedValues = [uvUpdateMode, uvAutoCommitUpdates]
    UpdateOptions.UpdateMode = upWhereAll
    UpdateOptions.AutoCommitUpdates = True
    TxOptions.StopOptions = [xoIfCmdsInactive, xoIfAutoStarted, xoFinishRetaining]
    LoginPrompt = False
    OnError = FD_PostgresError
    OnRestored = FD_PostgresRestored
    OnRecover = FD_PostgresRecover
    Left = 48
    Top = 16
  end
  object Query_Relatorio_produtos: TFDQuery
    Connection = FD_Postgres
    Left = 48
    Top = 232
  end
  object Qry_Erros: TFDQuery
    Connection = FD_Postgres
    SQL.Strings = (
      
        'select codigo,ativo, marca,descr1,secao,grupo, subgru,dessub,cod' +
        'ire, prvist, basico, ualter_a, localiza, cancelado, aplica,envia' +
        '_site, desconto_ecommerce from PCCDITE0 where codigo= :codigo or' +
        ' codire= :codire or basico= :basico or descr1 like :descr1')
    Left = 152
    Top = 240
    ParamData = <
      item
        Name = 'CODIGO'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'CODIRE'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'BASICO'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'DESCR1'
        DataType = ftString
        ParamType = ptInput
      end>
    object StringField1: TStringField
      DisplayLabel = 'C'#243'd.'
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      FixedChar = True
      Size = 6
    end
    object StringField2: TStringField
      DisplayLabel = 'C'#243'd. Fabricante'
      FieldName = 'basico'
      Origin = 'basico'
      FixedChar = True
      Size = 16
    end
    object StringField3: TStringField
      DisplayLabel = 'Marca'
      FieldName = 'marca'
      Origin = 'marca'
      FixedChar = True
      Size = 5
    end
    object StringField4: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'descr1'
      Origin = 'descr1'
      Size = 120
    end
    object BCDField1: TBCDField
      DisplayLabel = 'Pre'#231'o'
      FieldName = 'prvist'
      Origin = 'prvist'
      DisplayFormat = 'R$ ###,###,##0.00'
      Precision = 12
      Size = 3
    end
    object BCDField2: TBCDField
      DisplayLabel = 'Desconto Site'
      FieldName = 'desconto_ecommerce'
      Origin = 'desconto_ecommerce'
      Precision = 7
      Size = 2
    end
    object StringField5: TStringField
      Alignment = taCenter
      DisplayLabel = 'Localiza'#231#227'o'
      FieldName = 'localiza'
      Origin = 'localiza'
      FixedChar = True
      Size = 9
    end
    object StringField6: TStringField
      DisplayLabel = 'Se'#231#227'o'
      FieldName = 'secao'
      Origin = 'secao'
      FixedChar = True
      Size = 4
    end
    object StringField7: TStringField
      DisplayLabel = 'Grupo'
      FieldName = 'grupo'
      Origin = 'grupo'
      FixedChar = True
      Size = 4
    end
    object StringField8: TStringField
      DisplayLabel = 'Subgrupo'
      FieldName = 'subgru'
      Origin = 'subgru'
      FixedChar = True
      Size = 4
    end
    object StringField9: TStringField
      DisplayLabel = 'C'#243'd. Barras'
      FieldName = 'codire'
      Origin = 'codire'
      FixedChar = True
      Size = 15
    end
  end
  object Qry_Con_Dupli: TFDQuery
    Connection = FD_Postgres
    Left = 152
    Top = 176
  end
  object marca: TFDQuery
    Connection = FD_Postgres
    SQL.Strings = (
      
        'select codigo,ativo, marca,descr1,secao,grupo, subgru,dessub,cod' +
        'ire, prvist, basico, ualter_a, localiza, cancelado, aplica,envia' +
        '_site, desconto_ecommerce from PCCDITE0 where codigo= :codigo or' +
        ' codire= :codire or basico= :basico or descr1 like :descr1')
    Left = 32
    Top = 312
    ParamData = <
      item
        Name = 'CODIGO'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'CODIRE'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'BASICO'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'DESCR1'
        DataType = ftString
        ParamType = ptInput
      end>
    object StringField10: TStringField
      DisplayLabel = 'C'#243'd.'
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      FixedChar = True
      Size = 6
    end
    object StringField11: TStringField
      DisplayLabel = 'C'#243'd. Fabricante'
      FieldName = 'basico'
      Origin = 'basico'
      FixedChar = True
      Size = 16
    end
    object StringField12: TStringField
      DisplayLabel = 'Marca'
      FieldName = 'marca'
      Origin = 'marca'
      FixedChar = True
      Size = 5
    end
    object StringField13: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'descr1'
      Origin = 'descr1'
      Size = 120
    end
    object BCDField3: TBCDField
      DisplayLabel = 'Pre'#231'o'
      FieldName = 'prvist'
      Origin = 'prvist'
      DisplayFormat = 'R$ ###,###,##0.00'
      Precision = 12
      Size = 3
    end
    object BCDField4: TBCDField
      DisplayLabel = 'Desconto Site'
      FieldName = 'desconto_ecommerce'
      Origin = 'desconto_ecommerce'
      Precision = 7
      Size = 2
    end
    object StringField14: TStringField
      Alignment = taCenter
      DisplayLabel = 'Localiza'#231#227'o'
      FieldName = 'localiza'
      Origin = 'localiza'
      FixedChar = True
      Size = 9
    end
    object StringField15: TStringField
      DisplayLabel = 'Se'#231#227'o'
      FieldName = 'secao'
      Origin = 'secao'
      FixedChar = True
      Size = 4
    end
    object StringField16: TStringField
      DisplayLabel = 'Grupo'
      FieldName = 'grupo'
      Origin = 'grupo'
      FixedChar = True
      Size = 4
    end
    object StringField17: TStringField
      DisplayLabel = 'Subgrupo'
      FieldName = 'subgru'
      Origin = 'subgru'
      FixedChar = True
      Size = 4
    end
    object StringField18: TStringField
      DisplayLabel = 'C'#243'd. Barras'
      FieldName = 'codire'
      Origin = 'codire'
      FixedChar = True
      Size = 15
    end
  end
  object produtos_ecommerce_caracteristicas: TFDQuery
    Connection = FD_Postgres
    Left = 88
    Top = 408
  end
  object token: TFDQuery
    Connection = FD_Postgres
    SQL.Strings = (
      'select f_ecommerce_token()')
    Left = 616
    Top = 224
  end
  object f_ecommerce_cliente: TFDQuery
    AggregatesActive = True
    MasterSource = DataSource1
    Connection = FD_Postgres
    Left = 520
    Top = 224
  end
  object f_ecommerce_insere_pedido: TFDQuery
    Connection = FD_Postgres
    Transaction = Transaction_pedido
    UpdateTransaction = Transaction_pedido
    UpdateOptions.AssignedValues = [uvLockWait]
    UpdateOptions.LockWait = True
    Left = 520
    Top = 312
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    MasterSource = DTSource_Produtos
    PacketRecords = 0
    Params = <>
    Left = 592
    Top = 416
  end
  object DataSource1: TDataSource
    Left = 664
    Top = 424
  end
  object Transaction_pedido: TFDTransaction
    Options.Isolation = xiUnspecified
    Options.AutoStart = False
    Options.AutoStop = False
    Options.StopOptions = [xoIfCmdsInactive, xoFinishRetaining]
    Options.DisconnectAction = xdNone
    Connection = FD_Postgres
    Left = 288
    Top = 192
  end
  object pedido_status: TFDQuery
    Connection = FD_Postgres
    Transaction = Transaction_pedido
    UpdateTransaction = Transaction_pedido
    UpdateOptions.AssignedValues = [uvLockWait]
    UpdateOptions.LockWait = True
    Left = 640
    Top = 312
  end
  object Pedidos_enviados: TFDQuery
    Connection = FD_Postgres
    SQL.Strings = (
      'select * from ecommerce_pedido_status_faturamento_view')
    Left = 480
    Top = 104
  end
  object DT_pedidos_enviados: TClientDataSet
    Aggregates = <>
    MasterSource = DS_pedidos_enviados
    PacketRecords = 0
    Params = <>
    Left = 576
    Top = 104
  end
  object DS_pedidos_enviados: TDataSource
    DataSet = Pedidos_enviados
    Left = 680
    Top = 104
  end
  object similares: TFDQuery
    MasterSource = DTSource_Produtos
    Connection = FD_Postgres
    Left = 264
    Top = 120
  end
  object duplicatas: TFDQuery
    Connection = FD_Postgres
    Left = 320
    Top = 368
  end
  object receberhj: TFDQuery
    Connection = FD_Postgres
    Left = 288
    Top = 480
  end
  object boleto: TFDQuery
    Connection = FD_Postgres
    Left = 376
    Top = 376
  end
end
