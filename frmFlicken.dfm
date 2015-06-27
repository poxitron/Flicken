object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Flicken'
  ClientHeight = 202
  ClientWidth = 420
  Color = clBtnFace
  Constraints.MinHeight = 240
  Constraints.MinWidth = 360
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  DesignSize = (
    420
    202)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 13
    Width = 61
    Height = 13
    Caption = 'Parche (.zip)'
  end
  object Label2: TLabel
    Left = 8
    Top = 59
    Width = 177
    Height = 13
    Caption = 'Carpeta con los archivos a parchear:'
  end
  object Label3: TLabel
    Left = 8
    Top = 105
    Width = 160
    Height = 13
    Caption = 'Guardar archivos parcheados en:'
  end
  object Estado_Label: TLabel
    Left = 8
    Top = 174
    Width = 125
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Estado: Esperando datos.'
    ExplicitTop = 212
  end
  object ArchivoZip_Edit: TEdit
    Left = 8
    Top = 32
    Width = 357
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    ExplicitWidth = 391
  end
  object Zip_Button: TButton
    Left = 371
    Top = 30
    Width = 41
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 1
    OnClick = Zip_ButtonClick
    ExplicitLeft = 405
  end
  object RutaOrigen_Edit: TEdit
    Left = 8
    Top = 78
    Width = 357
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    ExplicitWidth = 391
  end
  object Origen_Button: TButton
    Left = 371
    Top = 76
    Width = 41
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 3
    OnClick = Origen_ButtonClick
    ExplicitLeft = 405
  end
  object RutaDestino_Edit: TEdit
    Left = 8
    Top = 124
    Width = 357
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    ExplicitWidth = 391
  end
  object RutaDestino_Button: TButton
    Left = 371
    Top = 122
    Width = 41
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 5
    OnClick = RutaDestino_ButtonClick
    ExplicitLeft = 405
  end
  object Parchear_Button: TButton
    Left = 337
    Top = 162
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Inicar'
    TabOrder = 6
    OnClick = Parchear_ButtonClick
    ExplicitLeft = 371
    ExplicitTop = 201
  end
  object Memo1: TMemo
    Left = 8
    Top = 151
    Width = 311
    Height = 17
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 7
    Visible = False
    ExplicitWidth = 345
    ExplicitHeight = 54
  end
  object Zip_OpenDialog: TOpenDialog
    Filter = 'Archivo .zip|*.zip'
    Left = 280
    Top = 160
  end
end
