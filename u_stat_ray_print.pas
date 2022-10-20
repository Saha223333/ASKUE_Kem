unit u_stat_ray_print;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, ActnList, ImgList, RzForms, RzRadChk, DBCtrls,
  RzDBCmbo, StdCtrls, RzLabel, Mask, RzEdit, ComCtrls, RzBckgnd, frxClass,
  u_data, frxDBSet, frxVariables;

type
  TFStatRayPrint = class(TForm)
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RzSeparator1: TRzSeparator;
    RzBitBtn1: TRzBitBtn;
    RzDBLCBAskueSrc: TRzDBLookupComboBox;
    RzDBLCBUchastok: TRzDBLookupComboBox;
    DateTimePicker1: TDateTimePicker;
    RzBitBtn2: TRzBitBtn;
    RzFormState1: TRzFormState;
    IL: TImageList;
    AL: TActionList;
    AExit: TAction;
    APrint: TAction;
    frxDBDataset1: TfrxDBDataset;
    frxRNoCheckPrint: TfrxReport;
    procedure AExitExecute(Sender: TObject);
    procedure APrintExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FStatRayPrint: TFStatRayPrint;

implementation

{$R *.dfm}

uses
  u_main;

procedure TFStatRayPrint.AExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFStatRayPrint.APrintExecute(Sender: TObject);
begin
  if (RzDBLCBAskueSrc.KeyValue = null) or
     (RzDBLCBUchastok.KeyValue = null) then begin
  ShowMessage('Не выбраны обязательные параметры!');
  end else begin
    DM.OQNoCheckPrint.ParamByName('askue_src').AsInteger := RzDBLCBAskueSrc.KeyValue;
    DM.OQNoCheckPrint.ParamByName('otd').AsInteger := FMain.RzRegIniFile1.ReadInteger('Sets', 'Otd', 1);;
    DM.OQNoCheckPrint.ParamByName('uchastok').AsInteger := RzDBLCBUchastok.KeyValue;
    DM.OQNoCheckPrint.ParamByName('dnd').AsDate := DateTimePicker1.Date;
    DM.OQNoCheckPrint.ParamByName('dkd').AsDate := Date;
    DM.OQNoCheckPrint.Open;

    frxRNoCheckPrint.LoadFromFile('rep\no_check_print.fr3',true);
    frxRNoCheckPrint.Variables['DND'] := '''' +
      DateToStr(DateTimePicker1.Date) + '''';
    frxRNoCheckPrint.PrepareReport();
    frxRNoCheckPrint.ShowReport;

    DM.OQNoCheckPrint.Close;
  end;
end;

procedure TFStatRayPrint.FormShow(Sender: TObject);
begin
  DateTimePicker1.Date := Date - 30;
end;

end.
