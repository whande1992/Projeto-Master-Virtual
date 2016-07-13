object frm_Exporta_Registros: Tfrm_Exporta_Registros
  Left = 0
  Top = 0
  Caption = 'Exportar registros'
  ClientHeight = 600
  ClientWidth = 1100
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object PN_Consulta: TPanel
    Left = 0
    Top = 0
    Width = 1100
    Height = 113
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Align = alTop
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    TabOrder = 0
    object Group_Consulta: TGroupBox
      Left = 11
      Top = 11
      Width = 1078
      Height = 88
      Align = alTop
      Caption = 'Consulta Produtos'
      TabOrder = 0
      object Label1: TLabel
        Left = 559
        Top = 27
        Width = 117
        Height = 13
        Caption = 'Situa'#231#227'o no E-commerce'
      end
      object Edit_descricao: TEdit
        Left = 16
        Top = 24
        Width = 353
        Height = 21
        TabOrder = 0
        TextHint = 'Pesquise pela descri'#231#227'o, codigo fabricante, barras ou interno.'
      end
      object Button1: TButton
        Left = 384
        Top = 22
        Width = 75
        Height = 25
        Caption = 'OK'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Combo_Ativo: TComboBox
        Left = 682
        Top = 24
        Width = 145
        Height = 21
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TextHint = 'Inativos'
        Items.Strings = (
          'Ativos'
          'Inativos')
      end
    end
  end
  object PN_Altera_Produto: TPanel
    Left = 0
    Top = 113
    Width = 1100
    Height = 232
    Align = alTop
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 11
      Top = 6
      Width = 369
      Height = 211
      Caption = 'Ajuste de produtos do site'
      TabOrder = 0
      object Label2: TLabel
        Left = 16
        Top = 29
        Width = 87
        Height = 13
        Caption = 'Nome do produto:'
      end
      object Label3: TLabel
        Left = 16
        Top = 75
        Width = 74
        Height = 13
        Caption = 'Meta Tag T'#237'tulo'
      end
      object Label4: TLabel
        Left = 16
        Top = 121
        Width = 34
        Height = 13
        Caption = 'Modelo'
      end
      object Edit_Nome_Produto: TEdit
        Left = 16
        Top = 48
        Width = 337
        Height = 21
        TabOrder = 0
        TextHint = 'Nome do produto'
      end
      object Edit_Meta_Tag: TEdit
        Left = 16
        Top = 94
        Width = 121
        Height = 21
        TabOrder = 1
        TextHint = 'Meta Tag t'#237'tulo'
      end
      object Edit_Modelo_produto: TEdit
        Left = 16
        Top = 140
        Width = 121
        Height = 21
        TabOrder = 2
        TextHint = 'Modelo do produto'
      end
    end
    object GroupBox2: TGroupBox
      Left = 386
      Top = 6
      Width = 223
      Height = 211
      Caption = 'Embalagem'
      TabOrder = 1
      object Label5: TLabel
        Left = 19
        Top = 122
        Width = 109
        Height = 13
        Caption = 'Dimens'#245'es (C x L x A):'
      end
      object Label6: TLabel
        Left = 16
        Top = 75
        Width = 27
        Height = 13
        Caption = 'Peso:'
      end
      object Label7: TLabel
        Left = 16
        Top = 29
        Width = 58
        Height = 13
        Caption = 'Localiza'#231#227'o:'
      end
      object Edit1: TEdit
        Left = 16
        Top = 48
        Width = 193
        Height = 21
        TabOrder = 0
        TextHint = 'Localiza'#231#227'o: (Ex: A1 B4 H6)'
      end
      object Edit_Peso: TEdit
        Left = 16
        Top = 93
        Width = 81
        Height = 21
        TabOrder = 1
        TextHint = 'Peso'
      end
      object Edit_C: TEdit
        Left = 16
        Top = 141
        Width = 49
        Height = 21
        Alignment = taCenter
        TabOrder = 2
        TextHint = 'C'
      end
      object Edit_L: TEdit
        Left = 71
        Top = 141
        Width = 49
        Height = 21
        Alignment = taCenter
        TabOrder = 3
        TextHint = 'L'
      end
      object Edit_A: TEdit
        Left = 126
        Top = 141
        Width = 49
        Height = 21
        Alignment = taCenter
        TabOrder = 4
        TextHint = 'A'
      end
    end
    object Button2: TButton
      Left = 615
      Top = 201
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 2
      OnClick = Button2Click
    end
    object GroupBox3: TGroupBox
      Left = 615
      Top = 6
      Width = 314
      Height = 105
      Caption = 'Pre'#231'os'
      TabOrder = 3
      object Label8: TLabel
        Left = 11
        Top = 29
        Width = 45
        Height = 13
        Caption = 'Desconto'
      end
      object Edit_desconto: TEdit
        Left = 9
        Top = 48
        Width = 121
        Height = 21
        TabOrder = 0
        TextHint = '% desconto no site'
      end
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 345
    Width = 1100
    Height = 255
    Align = alClient
    DataSource = Data_Postgres.DTSource_Produtos
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgMultiSelect]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'codigo'
        Width = 57
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'basico'
        Width = 82
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'marca'
        Width = 77
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'descr1'
        Width = 316
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'prvist'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'desconto_ecommerce'
        Width = 92
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'localiza'
        Width = 64
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'secao'
        Width = 58
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'grupo'
        Width = 53
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'subgru'
        Width = 63
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'codire'
        Width = 140
        Visible = True
      end>
  end
end
