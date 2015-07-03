object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Flicken'
  ClientHeight = 202
  ClientWidth = 434
  Color = clBtnFace
  Constraints.MaxHeight = 240
  Constraints.MinHeight = 240
  Constraints.MinWidth = 360
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000040040000130B0000130B000000000000000000002626
    2664262626CD262626CF262626CF262626CF262626CF262626CF262626CF2626
    26CF262626CF262626CF262626CF262626CF262626CF262626CD262626642828
    28DC282828FF282828FF282828FF282828FF282828FF282828FF282828FF2828
    28FF282828FF282828FF282828FF282828FF282828FF282828FF282828DC2C2C
    2CDF2C2C2CFF2C2C2CFF7B7B7BFFBBBBBBFF999999FF363636FF2C2C2CFF2C2C
    2CFF363636FF999999FFBBBBBBFF7C7C7CFF2C2C2CFF2C2C2CFF2C2C2CDF3030
    30DF303030FF7E7E7EFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCFFF3B3B3BFF3B3B
    3BFFCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FFF303030FF303030DF3535
    35DF353535FFBFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFECECECFF5D5D5DFFD0D0
    D0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBFFF353535FF353535DF3A3A
    3ADF3A3A3AFFA1A1A1FFFFFFFFFFFFFFFFFFECECECFF656565FFCBCBCBFFF8F8
    F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2A2A2FF3A3A3AFF3A3A3ADF3F3F
    3FDF3F3F3FFF484848FFD5D5D5FFEDEDEDFF686868FFCBCBCBFFD1D1D1FFD0D0
    D0FFF7F7F7FFFFFFFFFFFFFFFFFFD5D5D5FF484848FF3F3F3FFF3F3F3FDF4444
    44DF444444FF444444FF4F4F4FFF6A6A6AFFCDCDCDFFD2D2D2FFD0D0D0FFCFCF
    CFFFD1D1D1FFF8F8F8FFD6D6D6FF4F4F4FFF444444FF444444FF444444DF4A4A
    4ADF4A4A4AFF4A4A4AFF535353FFD5D5D5FFF7F7F7FFD2D2D2FFD2D2D2FFD2D2
    D2FFD4D4D4FFD0D0D0FF6D6D6DFF535353FF4A4A4AFF4A4A4AFF4A4A4ADF4F4F
    4FDF4F4F4FFF575757FFD6D6D6FFFFFFFFFFFFFFFFFFF6F6F6FFD4D4D4FFD5D5
    D5FFD0D0D0FF747474FFEDEDEDFFD7D7D7FF575757FF4F4F4FFF4F4F4FDF5454
    54DF545454FFADADADFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8F8FFD2D2
    D2FF787878FFEEEEEEFFFFFFFFFFFFFFFFFFADADADFF545454FF545454DF5A5A
    5ADF5A5A5AFFCACACAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDADADAFF7A7A
    7AFFEEEEEEFFFFFFFFFFFFFFFFFFFFFFFFFFCACACAFF5A5A5AFF5A5A5ADF5E5E
    5EDF5E5E5EFF9B9B9BFFFFFFFFFFFFFFFFFFFFFFFFFFDBDBDBFF676767FF6767
    67FFDADADAFFFFFFFFFFFFFFFFFFFFFFFFFF9C9C9CFF5E5E5EFF5E5E5EDF6262
    62DF626262FF626262FF9E9E9EFFCDCDCDFFB5B5B5FF6A6A6AFF626262FF6262
    62FF6A6A6AFFB5B5B5FFCDCDCDFF9E9E9EFF626262FF626262FF626262DF6666
    66DE666666FF666666FF666666FF666666FF666666FF666666FF666666FF6666
    66FF666666FF666666FF666666FF666666FF666666FF666666FF666666DE6868
    687E696969DF696969DF696969DF696969DF696969DF696969DF696969DF6969
    69DF696969DF696969DF696969DF696969DF696969DF696969DF6868687E0000
    6F0000004E00000078000000430000005C000000690000006400000077000000
    5C0000007900000000040000190000007729000000000000CF2700000000}
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    434
    202)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 13
    Width = 128
    Height = 13
    Caption = 'Parche comprimido en .zip:'
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
    Width = 371
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object Zip_Button: TButton
    Left = 385
    Top = 30
    Width = 41
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 1
    OnClick = Zip_ButtonClick
  end
  object RutaOrigen_Edit: TEdit
    Left = 8
    Top = 78
    Width = 371
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object Origen_Button: TButton
    Left = 385
    Top = 76
    Width = 41
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 3
    OnClick = Origen_ButtonClick
  end
  object RutaDestino_Edit: TEdit
    Left = 8
    Top = 124
    Width = 371
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
  end
  object RutaDestino_Button: TButton
    Left = 385
    Top = 122
    Width = 41
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 5
    OnClick = RutaDestino_ButtonClick
  end
  object Parchear_Button: TButton
    Left = 351
    Top = 162
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Iniciar'
    TabOrder = 6
    OnClick = Parchear_ButtonClick
  end
  object Zip_OpenDialog: TOpenDialog
    Filter = 'Archivo .zip|*.zip'
    Left = 200
    Top = 152
  end
end