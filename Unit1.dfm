object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 66
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 8
    Width = 101
    Height = 13
    Caption = #1048#1089#1093#1086#1076#1085#1099#1081' '#1087#1083#1077#1081#1083#1080#1089#1090
  end
  object Edit1: TEdit
    Left = 107
    Top = 5
    Width = 342
    Height = 21
    TabOrder = 0
    OnClick = Edit1Click
  end
  object Button1: TButton
    Left = 208
    Top = 32
    Width = 75
    Height = 25
    Caption = #1055#1091#1089#1082
    TabOrder = 1
    OnClick = Button1Click
  end
  object OpenDialog1: TOpenDialog
    Ctl3D = False
    InitialDir = 'C:\'
    Left = 136
    Top = 8
  end
end
