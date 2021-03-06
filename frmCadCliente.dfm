object CadCliente: TCadCliente
  Left = 274
  Top = 135
  Width = 634
  Height = 552
  Caption = 'Cadastro de clientes'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 616
    Top = 168
    Width = 105
    Height = 169
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 609
    Height = 481
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 8
      Width = 34
      Height = 13
      Caption = 'Nome :'
    end
    object Label2: TLabel
      Left = 24
      Top = 56
      Width = 56
      Height = 13
      Caption = 'Identidade :'
    end
    object Label3: TLabel
      Left = 224
      Top = 54
      Width = 26
      Height = 13
      Caption = 'CPF :'
    end
    object Label4: TLabel
      Left = 24
      Top = 104
      Width = 48
      Height = 13
      Caption = 'Telefone :'
    end
    object Label5: TLabel
      Left = 24
      Top = 152
      Width = 31
      Height = 13
      Caption = 'Email :'
    end
    object edtNome: TEdit
      Left = 24
      Top = 24
      Width = 281
      Height = 21
      TabOrder = 0
    end
    object edtIdentidade: TEdit
      Left = 24
      Top = 72
      Width = 105
      Height = 21
      TabOrder = 1
    end
    object edtCPF: TEdit
      Left = 224
      Top = 69
      Width = 81
      Height = 21
      MaxLength = 11
      TabOrder = 2
    end
    object edttelefone: TEdit
      Left = 24
      Top = 120
      Width = 281
      Height = 21
      TabOrder = 3
    end
    object edtEmail: TEdit
      Left = 24
      Top = 168
      Width = 281
      Height = 21
      TabOrder = 4
    end
    object Panel2: TPanel
      Left = 1
      Top = 208
      Width = 569
      Height = 233
      Alignment = taLeftJustify
      TabOrder = 5
      object Label6: TLabel
        Left = 24
        Top = 8
        Width = 27
        Height = 13
        Caption = 'CEP :'
      end
      object Label7: TLabel
        Left = 24
        Top = 56
        Width = 60
        Height = 13
        Caption = 'Logradouro :'
      end
      object Label8: TLabel
        Left = 424
        Top = 56
        Width = 70
        Height = 13
        Caption = 'Complemento :'
      end
      object Label9: TLabel
        Left = 24
        Top = 104
        Width = 33
        Height = 13
        Caption = 'Bairro :'
      end
      object Label10: TLabel
        Left = 320
        Top = 56
        Width = 43
        Height = 13
        Caption = 'N'#250'mero :'
      end
      object Label11: TLabel
        Left = 24
        Top = 144
        Width = 39
        Height = 13
        Caption = 'Cidade :'
      end
      object Label12: TLabel
        Left = 320
        Top = 144
        Width = 39
        Height = 13
        Caption = 'Estado :'
      end
      object Label13: TLabel
        Left = 24
        Top = 188
        Width = 28
        Height = 13
        Caption = 'Pa'#237's :'
      end
      object Label14: TLabel
        Left = 128
        Top = 208
        Width = 39
        Height = 13
        Caption = 'Cidade :'
      end
      object edtCEP: TEdit
        Left = 24
        Top = 24
        Width = 73
        Height = 21
        MaxLength = 9
        TabOrder = 0
      end
      object EdtLogradouro: TEdit
        Left = 24
        Top = 72
        Width = 281
        Height = 21
        TabOrder = 1
      end
      object edtComplemento: TEdit
        Left = 424
        Top = 72
        Width = 113
        Height = 21
        TabOrder = 3
      end
      object edtBairro: TEdit
        Left = 24
        Top = 116
        Width = 281
        Height = 21
        TabOrder = 4
      end
      object edtNumero: TEdit
        Left = 320
        Top = 72
        Width = 81
        Height = 21
        MaxLength = 11
        TabOrder = 2
      end
      object edtCidade: TEdit
        Left = 24
        Top = 156
        Width = 281
        Height = 21
        TabOrder = 5
      end
      object edtEstado: TEdit
        Left = 320
        Top = 156
        Width = 49
        Height = 21
        TabOrder = 6
      end
      object edtpais: TEdit
        Left = 24
        Top = 204
        Width = 281
        Height = 21
        TabOrder = 7
      end
      object btnBuscarCEP: TButton
        Left = 104
        Top = 24
        Width = 75
        Height = 25
        Caption = 'Buscar CEP'
        TabOrder = 8
        OnClick = btnBuscarCEPClick
      end
    end
    object btnEnviar: TButton
      Left = 224
      Top = 448
      Width = 75
      Height = 25
      Caption = '&Enviar'
      TabOrder = 6
      OnClick = btnEnviarClick
    end
    object btnSair: TButton
      Left = 328
      Top = 448
      Width = 75
      Height = 25
      Caption = '&Sair'
      TabOrder = 7
      OnClick = btnSairClick
    end
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 576
    Top = 152
  end
  object cdsDados: TClientDataSet
    Aggregates = <>
    FileName = 'C:\Programas\Exemplos\Json\CADASTRO.XML'
    Params = <>
    Left = 576
    Top = 24
    object cdsDadosNome: TStringField
      FieldName = 'Nome'
    end
    object cdsDadosIdentidade: TStringField
      FieldName = 'Identidade'
    end
    object cdsDadosCPF: TStringField
      FieldName = 'CPF'
    end
    object cdsDadosTelefone: TStringField
      FieldName = 'Telefone'
    end
    object cdsDadosEmail: TStringField
      FieldName = 'Email'
      Size = 100
    end
    object cdsDadosCEP: TStringField
      FieldName = 'CEP'
    end
    object cdsDadosLogradouro: TStringField
      FieldName = 'Logradouro'
    end
    object cdsDadosNumero: TStringField
      FieldName = 'Numero'
    end
    object cdsDadosComplemento: TStringField
      FieldName = 'Complemento'
    end
    object cdsDadosBairro: TStringField
      FieldName = 'Bairro'
    end
    object cdsDadosCidade: TStringField
      FieldName = 'Cidade'
    end
    object cdsDadosUF: TStringField
      FieldKind = fkCalculated
      FieldName = 'UF'
      Calculated = True
    end
    object cdsDadosPais: TStringField
      FieldKind = fkCalculated
      FieldName = 'Pais'
      Calculated = True
    end
  end
  object dsDados: TDataSource
    DataSet = cdsDados
    Left = 552
    Top = 24
  end
  object ClienteSMTP: TIdSMTP
    SASLMechanisms = <>
    Left = 576
    Top = 56
  end
  object SSLHandlerSMTP: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Method = sslvSSLv2
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 576
    Top = 80
  end
  object IdMessage1: TIdMessage
    AttachmentEncoding = 'UUE'
    BccList = <>
    CCList = <>
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 576
    Top = 104
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 576
    Top = 136
  end
end
