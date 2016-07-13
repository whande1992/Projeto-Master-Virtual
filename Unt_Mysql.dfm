object Data_Mysql: TData_Mysql
  OldCreateOrder = False
  Height = 556
  Width = 835
  object Driver_Mysql: TFDPhysMySQLDriverLink
    Left = 560
    Top = 48
  end
  object Query_DescricaoM: TFDQuery
    Connection = FDCon_Mysql
    Left = 40
    Top = 128
  end
  object Query_ProdutosMm: TFDQuery
    Connection = FDCon_Mysql
    UpdateOptions.AssignedValues = [uvCheckReadOnly]
    Left = 128
    Top = 184
  end
  object Query_VerificaProM: TFDQuery
    AutoCalcFields = False
    Connection = FDCon_Mysql
    Left = 232
    Top = 184
  end
  object QryUP_ProdutoM: TFDQuery
    FieldOptions.AutoCreateMode = acCombineComputed
    Connection = FDCon_Mysql
    UpdateOptions.AssignedValues = [uvCheckRequired]
    Left = 336
    Top = 184
  end
  object QryUP_ProDescM: TFDQuery
    Connection = FDCon_Mysql
    Left = 280
    Top = 264
  end
  object Query_Pro_store: TFDQuery
    Connection = FDCon_Mysql
    Left = 384
    Top = 264
  end
  object Query_VCategoria: TFDQuery
    Connection = FDCon_Mysql
    Left = 520
    Top = 264
  end
  object Query_IMG: TFDQuery
    Connection = FDCon_Mysql
    Left = 24
    Top = 208
  end
  object duplicata: TFDQuery
    Connection = FDCon_Mysql
    Left = 784
    Top = 488
  end
  object marca: TFDQuery
    Connection = FDCon_Mysql
    Left = 136
    Top = 272
  end
  object oc_product_related: TFDQuery
    Connection = FDCon_Mysql
    Left = 48
    Top = 472
  end
  object caracteristicas_ecommerce: TFDQuery
    Connection = FDCon_Mysql
    Left = 208
    Top = 480
  end
  object pedidos_ecommerce: TFDQuery
    Connection = FDCon_Mysql
    Left = 576
    Top = 440
  end
  object order_product: TFDQuery
    Connection = FDCon_Mysql
    Left = 648
    Top = 392
  end
  object Filtro_produtos: TFDQuery
    Connection = FDCon_Mysql
    Left = 704
    Top = 280
  end
  object filtro_id: TFDQuery
    Connection = FDCon_Mysql
    Left = 704
    Top = 232
  end
  object secao: TFDQuery
    Connection = FDCon_Mysql
    Left = 32
    Top = 280
  end
  object grupo: TFDQuery
    Connection = FDCon_Mysql
    Left = 32
    Top = 352
  end
  object cliente: TFDQuery
    Connection = FDCon_Mysql
    Left = 728
    Top = 488
  end
  object NewDuplicata: TFDQuery
    Connection = FDCon_Mysql
    Left = 640
    Top = 496
  end
  object oc_ss_erros_log: TFDQuery
    Connection = FDCon_Mysql
    Left = 752
    Top = 64
  end
  object FDCon_Mysql: TFDConnection
    Params.Strings = (
      'WriteTimeout=3000'
      'ReadTimeout=3000'
      'DriverID=MySQL')
    FetchOptions.AssignedValues = [evMode, evRowsetSize, evCache, evAutoClose, evRecordCountMode, evCursorKind, evLiveWindowFastFirst]
    FetchOptions.Mode = fmAll
    FetchOptions.CursorKind = ckDefault
    FetchOptions.RowsetSize = 250
    FetchOptions.AutoClose = False
    FetchOptions.RecordCountMode = cmFetched
    FetchOptions.LiveWindowFastFirst = True
    FormatOptions.AssignedValues = [fvSE2Null, fvDefaultParamDataType, fvStrsTrim2Len]
    ResourceOptions.AssignedValues = [rvCmdExecTimeout, rvAutoConnect, rvAutoReconnect, rvKeepConnection]
    ResourceOptions.AutoReconnect = True
    UpdateOptions.AssignedValues = [uvRefreshMode, uvCheckRequired, uvCheckReadOnly]
    UpdateOptions.RefreshMode = rmAll
    UpdateOptions.CheckRequired = False
    TxOptions.StopOptions = []
    OnError = FDCon_MysqlError
    OnLost = FDCon_MysqlLost
    OnRestored = FDCon_MysqlRestored
    OnRecover = FDCon_MysqlRecover
    Left = 40
    Top = 32
  end
  object Query_ProdutosM: TFDQuery
    Connection = FDCon_Mysql
    Left = 160
    Top = 104
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 448
    Top = 56
  end
end
