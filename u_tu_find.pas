unit u_tu_find;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, RzButton, Grids, DBGridEh, RzBckgnd, StdCtrls, RzLabel,
  Buttons, RzSpnEdt, Mask, RzEdit, u_data, ImgList, ActnList, u_sch_edit, DB,
  RzForms, ComCtrls, HTTPApp, HTTPProd, OleCtrls, SHDocVw, ExtCtrls,
  RzPanel, StrUtils, u_chng_num, GridsEh;

type
  TFTUFind = class(TForm)
    XPManifest1: TXPManifest;
    RzLabel1: TRzLabel;
    RzSeparator1: TRzSeparator;
    DBGridEhSchVal: TDBGridEh;
    RzBitBtn1: TRzBitBtn;
    RzLabel2: TRzLabel;
    RzEdit1: TRzEdit;
    AL: TActionList;
    ASchTuEdit: TAction;
    ImageList1: TImageList;
    AExit: TAction;
    RzBitBtn2: TRzBitBtn;
    RzBitBtn3: TRzBitBtn;
    RzFormState1: TRzFormState;
    RzPanel1: TRzPanel;
    RzLabel3: TRzLabel;
    procedure RzEdit1Change(Sender: TObject);
    procedure DBGridEhSchValKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AExitExecute(Sender: TObject);
    procedure ASchTuEditExecute(Sender: TObject);
    procedure RzBitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGridEhSchValDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumnEh;
      State: TGridDrawState);
  private
    { Private declarations }
  public
    sFind: String;
    iTypeSch: Integer;
  end;

var
  FTUFind: TFTUFind;

implementation

{$R *.dfm}

uses
  u_main;

procedure TFTUFind.RzEdit1Change(Sender: TObject);
begin
  DM.OQSchTu.FilterSQL := 'zav_nom like ''%' + RzEdit1.Text + '''';
end;

procedure TFTUFind.DBGridEhSchValKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = $0D then begin
    ASchTuEdit.Execute;
  end;
end;

procedure TFTUFind.AExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFTUFind.ASchTuEditExecute(Sender: TObject);
var
  sAddr: String;
  nSch: Integer;
begin
  if sFind = '' then begin
    FSchEdit.RzLLS.Caption := DM.OQSchTu.FieldByName('ls').AsString;
    sAddr := DM.OQSchTu.FieldByName('type_street').AsString + ' ' +
             DM.OQSchTu.FieldByName('name_street').AsString + ', ' +
             DM.OQSchTu.FieldByName('dom').AsString;
    if DM.OQSchTu.FieldByName('korp').AsString <> '-' then
      sAddr := sAddr + '/' + DM.OQSchTu.FieldByName('korp').AsString;
    sAddr := sAddr + ', ' + DM.OQSchTu.FieldByName('flat').AsString;
    FSchEdit.RzLAddr.Caption := sAddr;
    FSchEdit.RzLSchDD.Caption := DM.OQSchTu.FieldByName('dnd').AsString + ' - ' +
                                 DM.OQSchTu.FieldByName('dkd').AsString;
    FSchEdit.RzESerNum.Text := DM.OQSchTu.FieldByName('zav_nom').AsString;
    FSchEdit.RzDBLCBTypeSch.KeyValue := DM.OQSchTu.FieldByName('type_sch').AsInteger;
    if FSchEdit.ShowModal = mrOk then begin
      DM.OSQLUpd.SQL.Clear;
      DM.OSQLUpd.SQL.Add('UPDATE esbp.schetch SET zav_nom = :zav_nom, type_sch = :type_sch WHERE nschetch = :nschetch');
      DM.OSQLUpd.ParamByName('zav_nom').AsString := Trim(FSchEdit.RzESerNum.Text);
      DM.OSQLUpd.ParamByName('type_sch').AsInteger := FSchEdit.RzDBLCBTypeSch.KeyValue;
      DM.OSQLUpd.ParamByName('nschetch').AsInteger := DM.OQSchTu.FieldByName('nschetch').AsInteger;
      nSch := DM.OQSchTu.FieldByName('nschetch').AsInteger;
      DM.OSQLUpd.Execute;
      DM.OS.Commit;
      DM.OQSchTu.Refresh;
      DM.OQSchTu.Locate('nschetch', nSch, [loCaseInsensitive])
    end;
  end else begin
    FChngNum.RzLNFrom.Caption := DM.OQSchTu.FieldByName('zav_nom').AsString;
    FChngNum.RzLTFrom.Caption := DM.OQSchTu.FieldByName('name').AsString;
    FChngNum.RzLNTo.Caption := sFind;
    FChngNum.RzLTTo.Caption := DM.OQSchVal.FieldByName('name').AsString;
    if FChngNum.ShowModal = mrOk then begin
      DM.OSQLUpd.SQL.Clear;
      DM.OSQLUpd.SQL.Add('UPDATE esbp.schetch SET zav_nom = :zav_nom, type_sch = :type_sch WHERE nschetch = :nschetch');
      DM.OSQLUpd.ParamByName('zav_nom').AsString := sFind;
      DM.OSQLUpd.ParamByName('type_sch').AsInteger := DM.OQSchVal.FieldByName('sch_type').AsInteger;
      DM.OSQLUpd.ParamByName('nschetch').AsInteger := DM.OQSchTu.FieldByName('nschetch').AsInteger;
      DM.OSQLUpd.Execute;
      DM.OS.Commit;
      DM.OQSchTu.Refresh;
      Close;
    end;
  end;
end;

procedure TFTUFind.RzBitBtn3Click(Sender: TObject);
begin
  DM.OQSchTu.FilterSQL := '';
end;

procedure TFTUFind.FormShow(Sender: TObject);
begin
  RzPanel1.Top := 9;
  if sFind = '' then begin
    RzEdit1.Text := '';
    RzLabel3.Caption := '';
    RzEdit1.Enabled := true;
    RzBitBtn3.Enabled := true;
    RzBitBtn2.Enabled := true;
    RzPanel1.Visible := false;
    RzEdit1.SetFocus;
  end else begin
    RzEdit1.Text := RightStr(sFind, 4);
    RzLabel3.Caption := '»щем сч-к є   ' + sFind +
                        '      тип:   ' + DM.OQSchVal.FieldByName('name').AsString;
    RzEdit1.Enabled := false;
    RzBitBtn3.Enabled := false;
    RzBitBtn2.Enabled := false;
    RzPanel1.Visible := true;
    DBGridEhSchVal.SetFocus;
  end;
end;

procedure TFTUFind.DBGridEhSchValDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  if not((DM.OQSchTu.FieldByName('dnd').AsDateTime <= Date()) and
         (DM.OQSchTu.FieldByName('dkd').AsDateTime >= Date())) then begin
    DBGridEhSchVal.Canvas.Font.Color := clRed;
//    if gdFocused in State then begin
//      DBGridEhSchVal.Canvas.Brush.Color := clRed;
//      DBGridEhSchVal.Canvas.Font.Color  := clWhite;
//    end;
    DBGridEhSchVal.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

end.
