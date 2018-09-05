object Form1: TForm1
  Left = 443
  Top = 261
  Caption = 'Form1'
  ClientHeight = 554
  ClientWidth = 966
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 0
    Top = 0
    Width = 966
    Height = 21
    Align = alTop
    BorderStyle = bsNone
    Color = clSilver
    TabOrder = 0
    OnKeyPress = Edit1KeyPress
  end
  object Panel1: TPanel
    Left = 0
    Top = 21
    Width = 966
    Height = 533
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object WkeWebbrowser1: TWkeWebbrowser
      Left = 0
      Top = 0
      Width = 966
      Height = 533
      DefaultUrl = 'www.baidu.com'
      OnTitleChanged = WkeWebbrowser1TitleChanged
      OnURLChanged = WkeWebbrowser1URLChanged
      Align = alClient
      ParentBackground = False
      PopupMenu = PopupMenu1
      TabOrder = 0
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 176
    Top = 72
    object N1: TMenuItem
      Caption = #25105#26159#21491#38190#33756#21333
      OnClick = N1Click
    end
  end
end
