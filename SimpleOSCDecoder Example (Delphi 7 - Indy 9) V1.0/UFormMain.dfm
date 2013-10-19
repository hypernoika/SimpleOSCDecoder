object FormMain: TFormMain
  Left = 403
  Top = 118
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'SimpleOSCDecoder // Example application'
  ClientHeight = 327
  ClientWidth = 667
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid: TStringGrid
    Left = 2
    Top = 36
    Width = 663
    Height = 289
    ColCount = 3
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goThumbTracking]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    OnMouseDown = StringGridMouseDown
    ColWidths = (
      360
      94
      186)
  end
  object Panel1: TPanel
    Left = 2
    Top = 2
    Width = 663
    Height = 33
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 10
      Width = 66
      Height = 13
      Caption = 'Listening port:'
    end
    object BtnQuit: TButton
      Left = 584
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Quit'
      TabOrder = 5
      OnClick = BtnQuitClick
    end
    object EditUDPPort: TEdit
      Left = 78
      Top = 6
      Width = 43
      Height = 21
      TabOrder = 0
      Text = '7001'
      OnKeyPress = EditUDPPortKeyPress
    end
    object BtnStartOSCMonitoring: TButton
      Left = 126
      Top = 4
      Width = 117
      Height = 25
      Caption = 'Start OSC Monitoring'
      TabOrder = 1
      OnClick = BtnStartOSCMonitoringClick
    end
    object BtnAbout: TButton
      Left = 520
      Top = 4
      Width = 61
      Height = 25
      Caption = 'About'
      TabOrder = 4
      OnClick = BtnAboutClick
    end
    object BtnClear: TButton
      Left = 246
      Top = 4
      Width = 61
      Height = 25
      Caption = 'Clear'
      Enabled = False
      TabOrder = 2
      OnClick = BtnClearClick
    end
    object BtnExporttotxt: TButton
      Left = 310
      Top = 4
      Width = 79
      Height = 25
      Caption = 'Export to .txt'
      Enabled = False
      TabOrder = 3
      OnClick = BtnExporttotxtClick
    end
  end
  object IdUDPServer: TIdUDPServer
    Bindings = <>
    DefaultPort = 7001
    OnUDPRead = IdUDPServerUDPRead
    Left = 72
    Top = 62
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.txt'
    FileName = 'OSCLOG'
    Filter = 'Text file (*.txt)|*.txt'
    Left = 8
    Top = 62
  end
  object PopupMenu: TPopupMenu
    Left = 40
    Top = 62
    object Copy1: TMenuItem
      Caption = 'Copy'
      ShortCut = 16451
      OnClick = Copy1Click
    end
  end
end
