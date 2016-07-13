object Frm_Principal: TFrm_Principal
  AlignWithMargins = True
  Left = 431
  Top = 138
  BorderStyle = bsSingle
  Caption = ' Virtual Master 2.5.0.0  13/07/2016'
  ClientHeight = 630
  ClientWidth = 951
  Color = clMenuHighlight
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SV_principal: TSplitView
    Left = 0
    Top = 0
    Width = 100
    Height = 611
    AnimationDelay = 9
    AnimationStep = 5
    BorderStyle = bsSingle
    Color = clHighlight
    OpenedWidth = 100
    Placement = svpLeft
    TabOrder = 0
    object GroupBox3: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 280
      Width = 90
      Height = 324
      Align = alBottom
      Caption = 'Servidores'
      TabOrder = 0
      DesignSize = (
        90
        324)
      object ImgStatusMysql: TImage
        Left = 20
        Top = 25
        Width = 49
        Height = 49
        OnClick = ImgStatusMysqlClick
      end
      object Label_ecommerce: TLabel
        Left = 3
        Top = 79
        Width = 84
        Height = 35
        Alignment = taCenter
        Anchors = []
        AutoSize = False
        BiDiMode = bdRightToLeftReadingOnly
        Caption = 'e-commerce'
        Color = clHighlight
        DragMode = dmAutomatic
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBiDiMode = False
        ParentColor = False
        ParentFont = False
        WordWrap = True
      end
      object ImgStatusPg: TImage
        Left = 20
        Top = 130
        Width = 49
        Height = 49
        OnClick = ImgStatusMysqlClick
      end
      object lbl_SSPlus: TLabel
        Left = 3
        Top = 184
        Width = 84
        Height = 33
        Align = alCustom
        Alignment = taCenter
        AutoSize = False
        Caption = 'SSPlus'
        WordWrap = True
      end
      object ImgStatusNet: TImage
        Left = 20
        Top = 237
        Width = 49
        Height = 49
      end
      object lbl_internet: TLabel
        Left = 3
        Top = 290
        Width = 84
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Internet'
        WordWrap = True
      end
    end
    object GroupBox4: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 169
      Width = 90
      Height = 105
      Align = alBottom
      Caption = 'Configura'#231#227'o'
      TabOrder = 1
      object lbl_configuracoes: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 77
        Width = 84
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Configura'#231#227'o'
      end
      object IMG_Config: TImage
        Left = 20
        Top = 24
        Width = 49
        Height = 49
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000300000
          003008060000005702F987000007594944415478DACD9A7F68556518C7DFF7B2
          C6100991182222122111112346C86ED41C32AC0C454A6A94A448226946624344
          44C8CC1F53A76269345D35CDF0478510F8C7E61F6D8449414484F8978C101943
          C61835C67DFA3CE79C7BEFB9E79E5FF7EEB63CE3DD79CF7B9EF3BCCFF7799EF3
          BCCFFB9C6B4D8D8EB62159C6E9335A9DD0AC3B9C739AD01890E275F740D61EAB
          C5BCB68600D620D8850247F173F75F68DF7CD8DF92D9F5A001788DD3F994E41F
          F7B7D81D3306A06D501AD05BBBB56692CB6B4C9E0B01D02146FAACB82CC58A71
          FAE1331C80476784229688C8A3D6DAABD08CD506C0506E3DA4BB00D1805C9B78
          4A994F05267E83D3978EF0FCD918D622E630EFC0B6C0F37A6AA67DCEFD0528EB
          24FD3DC1792A0600E315CA94D6E80DDD66AA4E1EFCDECF1CBAB7389D715DDCE3
          ECB93E02196B0BC26BFF18CF6E0D08FF0CED08ADC5A319A7AFEFC98938109100
          603A8BE93AE8EE55E18BAFA1F37F84B693D693670EFD664EC723746E4A5E6231
          67FBB3997545E16539F755F8C703F40AE2189707FBB3F67E8500721BD0C42E7C
          7161B84BC8288F6F43A51751D72424E721599D64514FBE3FA0CD22E60457AD56
          E4383C1647D0DE37AE3BED0EB3442800D76D04B7B18D26FE1861821B70D1D8DE
          C679561A0BB8EB81BDEE69B8893B0BCB43AD8F5EEC382E15EA4E250034DA103A
          701BBB8F071BC359561379A385ABA0AF608F727570C0179D4A010CA92F9A4F68
          8BFC6E93145566F0C06D1D573A1105A085532FEDB1DACE5B130B6877140FD9C2
          2A7E2E0A809E5A8D1BCE9A6A224B7EC019B355F759138739EF20A87CED7F0FCA
          FC021019085BB973C6382F570806C293F5027B623F6411A8A23F467F0B32217C
          66D22F4B54145210AB417D048205212A9DC9639CD9F730BB2E7E93C19BD1EBC0
          602E03FA55C65D9CE617D56F925D5584B067EF79317C8A817A783DCCF57C7CB8
          21B5DBA07982C76E787C8AF07F87C919AB562CD160DC977A8D7F3CCA6D98710A
          8E3719EC63F02623C3C65DAC66D31610CDDA48F05642D3044D5DA20B197303FE
          2B07B299BB5132C60318943AB2CA3EEB00487021910948CE42A716BB1591B1D6
          1B37C26922B7DE241F3FD15E86D748240098BEC8F91124A8E3527DBFCEE95BAB
          5ACB72BD0CC11A8A829A32B7414B93584173A3A349D9A30724631CD794F5F068
          8871A729AC761337FA81ABFB1867CAAA4B1AAF89195700BF224153E1C1142F6B
          990B197B957FAF46F969B875730B61A25BD0F66944A7BB2E8060CC7770C40676
          3F9851C0BC8EF0D7D20AEF02C00A963D8490855A33B792677D73970310CF7CD6
          4658A20C977CCBBF4D00B89B346188151A09D5DF61C125D52C7018E2EEF45CC8
          253F44676770814905C05DF97B61B8F6FF72A12977CFE06CD22B953F0F623FA7
          0FAA79D6E742E20128DBB494839092F129C22CABA4FD282C6CA60230285DB07A
          BF2AF405175200E2B910EA742D941732B0C9CD571A44F2B04EE04E9D0098A842
          FB1A4EB514B3265261317D317E0029224EC4D14F5B07803B550058C4749798EE
          E92AD3EC69BB90D67F34F66F1C68C97C5191F083B97AB86CC67A7B8C9B6A547E
          4CDF850AFDDFE8BCD09FB57FA59D7BE990345BA7961A65FDB42E34C81ED89A79
          5E72451A412A21E621C66633B684B166672C49192267D1E6F6B8BCA5A0FD2199
          C31C57E83EC73C991821B558F027DDEB46530923FF58278D70D2150D1A6389D9
          28ACCE43B42ACA85FC9331C18F80D8071A22BC1D1BC8DA203F565CDDB69222BB
          55B82417F905D62B51CA7014491200AC21BD507524B850A10F887B84555667F3
          33ED0E034427998D257577F73CA46D562DEE9332DA55349DB62FA188E86C3446
          78E5D10EC5292E17256AABF450F38EC3608C2958A1358DB6738CF3B256E4E7A3
          743B354D8FCA72A3B694C62DF7996E4816973095541317FBD3DF898E8A6EE68D
          F4F46733C995395FA15537F54FA48C42D17D5B5D84298936624660B3D1040ACA
          51009A5DCD9B9669EBAE70D4A02E24E636BADBEE55C50B694BB02EA49AD74DC6
          53318C2A9BB8B6C50C4DD9DF01C0E52800FA2DE014269B5FE14266FE4B170AD4
          47B5B478380A805697372811ADAA5D52F85113E1351C9FA6BFD7BF588656E688
          E51D566C377B82B9B12E648D7E74F85D37F59C9F65A43E950B89E4B0CC0D4FA3
          4FD2E699F843F32D1648738074A564DF1D5D9933E63D04EBC4031A8BA43E1772
          27D74AC439062758792F31BC3CA50BDDA2BFD4B8958615907499B20A6089DBF4
          E87A10143E1280074233C4B73D2183EEA4F579CD224FE62B116D43B97761D71D
          CEAD4CB0AF78EECDA2C5CD2BDC3D680AB5D802BDF23ECDE55E84BF17C6392995
          70DDC911CC75273436CCFF9DC6AD124FFA68D73A6947BA2814FCC8E7149499AB
          8B5C2ABFBDD50DD2FE30B7490DA0C09CBC9DD6A9452826D98AC9BF096EE2970E
          E514685F1A17C2350F0F6433C1CFAC19C65B01A0A94B23E43D9C77C4099F0A80
          27DC2C84D30F782AF4E5B0BCC4F9A9813117C239947D233BC406687B198F41FD
          7466F537175A7EBC982635AFD932C30665B515B994D28566F6A706690E2CA07B
          862B6E984D8A42FA630FFBC0FDD8A39D53AF78D50AFD28E87C1CD42DAA29B34B
          17000ED562DE7F01BE132871209F090C0000000049454E44AE426082}
        OnClick = ImgStatusMysqlClick
      end
    end
  end
  object btn_painel: TToggleSwitch
    Left = 14
    Top = 21
    Width = 72
    Height = 20
    Hint = 'Clique para ativar ou desativar o painel lateral.'
    ParentShowHint = False
    ShowHint = False
    State = tssOn
    TabOrder = 1
    OnClick = btn_painelClick
  end
  object Group_Produtos: TGroupBox
    AlignWithMargins = True
    Left = 127
    Top = 21
    Width = 624
    Height = 156
    Caption = 'Envio de produtos para e-commerce'
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    ParentShowHint = False
    ShowHint = False
    TabOrder = 2
    object Plbl_Produtos_total: TLabel
      Left = 144
      Top = 32
      Width = 113
      Height = 13
      Caption = 'Produtos encontrados: '
    end
    object Slbl_Produtos_enviados: TLabel
      Left = 345
      Top = 32
      Width = 104
      Height = 13
      Caption = 'Produtos atualizados:'
    end
    object lbl_Produto_1: TLabel
      Left = 144
      Top = 76
      Width = 42
      Height = 13
      Caption = 'Produto:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Img_UltimoProduto: TImage
      Left = 585
      Top = 120
      Width = 32
      Height = 32
      Hint = 
        'Clique duas vezes para excluir o hist'#243'rico do ultimo produto e i' +
        'niciar o envio do inicio.'
      AutoSize = True
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
        00200806000000737A7AF4000000A64944415478DA63641860C038EA8021E780
        FFFFFF0B00A9FD406C80267501881D1919193F50C501408BFE53D5A740404D07
        5C046207986FA1A1720088F5A9E6006447E0D24C0810A37FD40143CB0194F247
        1D30EA8051078C3A60D401143B805430EA006A3800D4E4E2076243A0191748B4
        1CD4683D0FC40F817A15C875400390AA27C7F748A011E88006B21C80E4880420
        9627D1E28740BC009FE5443980D660D40103EE0000E1F63D30644A1571000000
        0049454E44AE426082}
      Proportional = True
      OnDblClick = Img_UltimoProdutoDblClick
    end
    object Plbl_pencontrados: TLabel
      Left = 271
      Top = 32
      Width = 50
      Height = 13
      AutoSize = False
      Caption = '0'
    end
    object Slbl_numero: TLabel
      Left = 455
      Top = 32
      Width = 66
      Height = 13
      AutoSize = False
      Caption = '0'
    end
    object Label1: TLabel
      Left = 418
      Top = 130
      Width = 161
      Height = 13
      Caption = 'Limpar hist'#243'rico do ultimo produto'
    end
    object lbl_Produto_2: TLabel
      Left = 144
      Top = 101
      Width = 79
      Height = 13
      Caption = 'Status de envio:'
    end
    object BTN_envia_produtos: TButton
      AlignWithMargins = True
      Left = 14
      Top = 28
      Width = 110
      Height = 23
      Caption = 'Enviar'
      TabOrder = 0
      OnClick = BTN_envia_produtosClick
    end
    object indProdutos: TActivityIndicator
      Left = 47
      Top = 74
      FrameDelay = 150
      IndicatorColor = aicWhite
      IndicatorType = aitSectorRing
    end
  end
  object Group_Pedidos: TGroupBox
    AlignWithMargins = True
    Left = 127
    Top = 183
    Width = 624
    Height = 154
    Ctl3D = True
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    ParentCtl3D = False
    TabOrder = 3
    object lbl_clientes: TLabel
      Left = 144
      Top = 76
      Width = 88
      Height = 13
      Caption = 'Dados de clientes:'
    end
    object lbl_pedido: TLabel
      Left = 144
      Top = 103
      Width = 114
      Height = 13
      Caption = 'Importa'#231#227'o de pedidos:'
    end
    object lbl_pedidos_importados: TLabel
      Left = 345
      Top = 25
      Width = 47
      Height = 13
      Caption = 'Enviados:'
    end
    object lbl_total_pedidos: TLabel
      Left = 144
      Top = 23
      Width = 41
      Height = 13
      Caption = 'Pedidos:'
    end
    object lbl_mostra_ped: TLabel
      Left = 191
      Top = 24
      Width = 24
      Height = 13
      AutoSize = False
      Caption = '0'
    end
    object lbl_mostra_ped_enviados: TLabel
      Left = 398
      Top = 25
      Width = 31
      Height = 13
      AutoSize = False
      Caption = '0'
    end
    object BTN_Importa_pedidos: TButton
      AlignWithMargins = True
      Left = 13
      Top = 13
      Width = 111
      Height = 25
      BiDiMode = bdLeftToRight
      Caption = 'Importar pedidos'
      ParentBiDiMode = False
      TabOrder = 0
      OnClick = BTN_Importa_pedidosClick
    end
    object Btn_Rel_Pedidos_exportados: TButton
      AlignWithMargins = True
      Left = 13
      Top = 44
      Width = 110
      Height = 25
      BiDiMode = bdLeftToRight
      Caption = 'Pedidos exportados'
      ParentBiDiMode = False
      TabOrder = 1
      Visible = False
      OnClick = Btn_Rel_Pedidos_exportadosClick
    end
    object indPedidos: TActivityIndicator
      Left = 47
      Top = 79
      FrameDelay = 150
      IndicatorColor = aicWhite
      IndicatorType = aitSectorRing
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 611
    Width = 951
    Height = 19
    Panels = <>
  end
  object Email: TButton
    Left = 141
    Top = 519
    Width = 110
    Height = 25
    Caption = 'E-mail'
    TabOrder = 5
    Visible = False
    OnClick = EmailClick
  end
  object GroupBox1: TGroupBox
    Left = 127
    Top = 343
    Width = 624
    Height = 156
    Caption = 'Duplicatas e Bloquetos'
    TabOrder = 6
    object lblDuplicatas_CliAll: TLabel
      Left = 144
      Top = 32
      Width = 105
      Height = 13
      Caption = 'Clientes encontrados:'
      Color = clInactiveBorder
      ParentColor = False
    end
    object lblDuplicatas_CliDpl: TLabel
      Left = 337
      Top = 32
      Width = 115
      Height = 13
      Caption = 'Clientes com duplicatas:'
      Color = clInactiveBorder
      ParentColor = False
    end
    object lblDuplicatas_1: TLabel
      Left = 144
      Top = 75
      Width = 247
      Height = 13
      Caption = 'Disponibilizar duplicatas e bloquetos no e-commerce'
    end
    object BTN_Duplicatas: TButton
      Left = 12
      Top = 24
      Width = 111
      Height = 25
      Caption = 'Enviar duplicatas'
      TabOrder = 0
      OnClick = BTN_DuplicatasClick
    end
    object indDuplicatas: TActivityIndicator
      Left = 47
      Top = 66
      FrameDelay = 150
      IndicatorColor = aicWhite
      IndicatorType = aitSectorRing
    end
  end
  object IdDecoderMIME1: TIdDecoderMIME
    FillChar = '='
    Left = 800
    Top = 72
  end
  object Timer_Atualiza: TTimer
    Interval = 15000
    OnTimer = Timer_AtualizaTimer
    Left = 792
    Top = 136
  end
  object Timer_painel: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = Timer_painelTimer
    Left = 792
    Top = 208
  end
  object TrayIcon1: TTrayIcon
    OnDblClick = TrayIcon1DblClick
    Left = 800
    Top = 336
  end
  object ApplicationEvents1: TApplicationEvents
    OnException = ApplicationEvents1Exception
    OnMinimize = ApplicationEvents1Minimize
    Left = 800
    Top = 272
  end
  object DST_Pedidos_enviados: TfrxDBDataset
    UserName = 'DST_Pedidos_enviados'
    CloseDataSource = False
    BCDToCurrency = False
    Left = 800
    Top = 408
  end
  object Pedidos_enviados: TfrxReport
    Version = '5.3.14'
    DataSet = DST_Pedidos_enviados
    DataSetName = 'DST_Pedidos_enviados'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 42438.377065312510000000
    ReportOptions.LastChange = 42438.656975972200000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 800
    Top = 472
    Datasets = <
      item
        DataSet = DST_Pedidos_enviados
        DataSetName = 'DST_Pedidos_enviados'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        Height = 119.472480000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object Memo2: TfrxMemoView
          Align = baCenter
          Left = 151.055350000000000000
          Top = 57.543290000000000000
          Width = 416.000000000000000000
          Height = 43.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Relat'#243'rio de pedidos enviados para faturamento')
          ParentFont = False
        end
        object Date: TfrxMemoView
          Align = baRight
          Left = 638.740569999999900000
          Top = 2.102350000000001000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            '[Date]')
          ParentFont = False
        end
        object Memo1: TfrxMemoView
          Align = baLeft
          Top = 7.559059999999999000
          Width = 317.480520000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Virtual Master - Sistema de e-commerce integrado.')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Height = 94.488250000000000000
        Top = 200.315090000000000000
        Width = 718.110700000000000000
        DataSet = DST_Pedidos_enviados
        DataSetName = 'DST_Pedidos_enviados'
        RowCount = 0
        object DST_Pedidos_enviadostoken: TfrxMemoView
          Left = 102.047310000000000000
          Top = 48.456709999999990000
          Width = 260.787570000000000000
          Height = 18.897650000000000000
          DataSet = DST_Pedidos_enviados
          DataSetName = 'DST_Pedidos_enviados'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[DST_Pedidos_enviados."token"]')
          ParentFont = False
        end
        object DST_Pedidos_enviadosstatus: TfrxMemoView
          Left = 102.047310000000000000
          Top = 25.779529999999990000
          Width = 291.023810000000000000
          Height = 18.897650000000000000
          DataSet = DST_Pedidos_enviados
          DataSetName = 'DST_Pedidos_enviados'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[DST_Pedidos_enviados."status"]')
          ParentFont = False
        end
        object Memo6: TfrxMemoView
          Top = 25.779529999999990000
          Width = 98.267780000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Fill.BackColor = clMoneyGreen
          Memo.UTF8W = (
            'Status:')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          Top = 48.456709999999990000
          Width = 98.267780000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Fill.BackColor = clMoneyGreen
          Memo.UTF8W = (
            'Token: ')
          ParentFont = False
        end
        object Memo9: TfrxMemoView
          Width = 98.267780000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Fill.BackColor = clMoneyGreen
          Memo.UTF8W = (
            'Pedido [DST_Pedidos_enviados."pedido"]')
          ParentFont = False
        end
        object Memo10: TfrxMemoView
          Left = 98.267780000000000000
          Width = 396.850650000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Fill.BackColor = clMoneyGreen
          Memo.UTF8W = (
            '   Cliente: [DST_Pedidos_enviados."cliente"]')
          ParentFont = False
        end
        object Memo11: TfrxMemoView
          Left = 487.559370000000000000
          Width = 226.771800000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Fill.BackColor = clMoneyGreen
          Memo.UTF8W = (
            'Valor do pedido: R$ [DST_Pedidos_enviados."total_pedido"]')
          ParentFont = False
        end
        object DST_Pedidos_enviadosnronff: TfrxMemoView
          Left = 491.338900000000000000
          Top = 45.354360000000010000
          Width = 49.133890000000000000
          Height = 18.897650000000000000
          DataSet = DST_Pedidos_enviados
          DataSetName = 'DST_Pedidos_enviados'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[DST_Pedidos_enviados."nronff"]')
          ParentFont = False
        end
        object DST_Pedidos_enviadosserie: TfrxMemoView
          Left = 551.811380000000000000
          Top = 45.354360000000010000
          Width = 30.236240000000000000
          Height = 18.897650000000000000
          DataField = 'serie'
          DataSet = DST_Pedidos_enviados
          DataSetName = 'DST_Pedidos_enviados'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[DST_Pedidos_enviados."serie"]')
          ParentFont = False
        end
        object Memo3: TfrxMemoView
          Left = 377.953000000000000000
          Top = 45.354360000000010000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Fill.BackColor = clMoneyGreen
          Memo.UTF8W = (
            'Faturamento: ')
          ParentFont = False
        end
        object DST_Pedidos_enviadosdtemis: TfrxMemoView
          Left = 491.338900000000000000
          Top = 22.677179999999990000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          DataField = 'dtemis'
          DataSet = DST_Pedidos_enviados
          DataSetName = 'DST_Pedidos_enviados'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[DST_Pedidos_enviados."dtemis"]')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          Left = 377.953000000000000000
          Top = 22.677179999999990000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Fill.BackColor = clMoneyGreen
          Memo.UTF8W = (
            'Emiss'#227'o: ')
          ParentFont = False
        end
        object DST_Pedidos_enviadosdtfaturamento: TfrxMemoView
          Left = 604.724800000000000000
          Top = 45.354360000000010000
          Width = 105.826840000000000000
          Height = 18.897650000000000000
          DataField = 'dtfaturamento'
          DataSet = DST_Pedidos_enviados
          DataSetName = 'DST_Pedidos_enviados'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[DST_Pedidos_enviados."dtfaturamento"]')
          ParentFont = False
        end
      end
    end
  end
  object PDFexport: TfrxPDFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Quality = 95
    Transparency = True
    Author = 'Virtual Master 2.0'
    Subject = 'FastReport PDF export'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    PdfA = False
    Left = 800
    Top = 536
  end
  object IdSMTP: TIdSMTP
    SASLMechanisms = <>
    Left = 880
    Top = 544
  end
  object IdFTP1: TIdFTP
    IPVersion = Id_IPv4
    ConnectTimeout = 10000
    TransferType = ftBinary
    TransferTimeout = 60000
    NATKeepAlive.UseKeepAlive = False
    NATKeepAlive.IdleTimeMS = 0
    NATKeepAlive.IntervalMS = 0
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 800
    Top = 24
  end
end
