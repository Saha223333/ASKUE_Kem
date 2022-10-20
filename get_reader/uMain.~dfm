object FMain: TFMain
  Left = 465
  Top = 309
  BorderStyle = bsToolWindow
  Caption = #1052#1086#1076#1091#1083#1100' '#1095#1090#1077#1085#1080#1103' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1056#1052#1056#1052' 2055!!!'
  ClientHeight = 368
  ClientWidth = 351
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RzPB: TRzProgressBar
    Left = 8
    Top = 264
    Width = 329
    BackColor = clBtnFace
    BorderInner = fsFlat
    BorderOuter = fsNone
    BorderWidth = 1
    InteriorOffset = 0
    PartsComplete = 0
    Percent = 0
    TotalParts = 0
  end
  object RzLabel1: TRzLabel
    Left = 8
    Top = 320
    Width = 106
    Height = 13
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' COM-'#1087#1086#1088#1090' '
  end
  object RzCBFlush: TRzCheckBox
    Left = 8
    Top = 296
    Width = 153
    Height = 17
    Action = AFlushFlag
    FrameColor = 8409372
    HighlightColor = 2203937
    HotTrack = True
    HotTrackColor = 3983359
    HotTrackColorType = htctActual
    State = cbUnchecked
    TabOrder = 1
  end
  object RzMTest: TRzMemo
    Left = 8
    Top = 8
    Width = 329
    Height = 249
    TabStop = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object RzBitBtn1: TRzBitBtn
    Left = 264
    Top = 296
    Action = AExit
    Caption = #1054#1090#1084#1077#1085#1072
    Color = 15791348
    HighlightColor = 16026986
    HotTrack = True
    HotTrackColor = 3983359
    TabOrder = 2
  end
  object RzButton1: TRzButton
    Left = 176
    Top = 296
    Default = True
    ModalResult = 6
    Action = AStart
    Color = 15791348
    HighlightColor = 16026986
    HotTrack = True
    HotTrackColor = 3983359
    TabOrder = 0
  end
  object cb: TRzComboBox
    Left = 8
    Top = 336
    Width = 145
    Height = 21
    Ctl3D = False
    FrameVisible = True
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 4
  end
  object BCP: TBComPort
    BaudRate = br9600
    ByteSize = bs8
    InBufSize = 2048
    OutBufSize = 2048
    Parity = paMark
    Port = 'COM1'
    SyncMethod = smNone
    StopBits = sb1
    Timeouts.ReadInterval = -1
    Timeouts.ReadTotalMultiplier = 0
    Timeouts.ReadTotalConstant = 0
    Timeouts.WriteTotalMultiplier = 100
    Timeouts.WriteTotalConstant = 1000
    Left = 144
    Top = 96
  end
  object AL: TActionList
    Left = 184
    Top = 96
    object AVer: TAction
      Caption = #1042#1077#1088#1089#1080#1103' '#1055#1054
      OnExecute = AVerExecute
    end
    object AConnect: TAction
      Caption = 'Connect'
      OnExecute = AConnectExecute
    end
    object ADisconnect: TAction
      Caption = 'Disconnect'
      OnExecute = ADisconnectExecute
    end
    object AExit: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = AExitExecute
    end
    object AGetDate: TAction
      Caption = #1063#1090#1077#1085#1080#1077' '#1076#1072#1090#1099
      OnExecute = AGetDateExecute
    end
    object ASetDate: TAction
      Caption = #1057#1080#1085#1093#1088#1086#1085#1080#1079#1072#1094#1080#1103' '#1074#1088#1077#1084#1077#1085#1080
      OnExecute = ASetDateExecute
    end
    object AGetPokaz: TAction
      Caption = #1057#1095#1080#1090#1072#1090#1100' '#1087#1086#1082#1072#1079#1072#1085#1080#1103
      OnExecute = AGetPokazExecute
    end
    object AFlushFlag: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1072#1084#1103#1090#1100' '#1088#1080#1076#1077#1088#1072
      OnExecute = AFlushFlagExecute
    end
    object AStart: TAction
      Caption = #1057#1090#1072#1088#1090
      OnExecute = AStartExecute
    end
    object AOraConnect: TAction
      Caption = 'AOraConnect'
      OnExecute = AOraConnectExecute
    end
    object AOraDisconnect: TAction
      Caption = 'AOraDisconnect'
      OnExecute = AOraDisconnectExecute
    end
    object AFlushBase: TAction
      Caption = 'AFlushBase'
      OnExecute = AFlushBaseExecute
    end
  end
  object XPManifest1: TXPManifest
    Left = 224
    Top = 96
  end
  object RzIni: TRzRegIniFile
    Path = 'get_reader.ini'
    Left = 264
    Top = 96
  end
end
