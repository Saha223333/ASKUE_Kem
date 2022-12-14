unit u_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzSplit, RzGroupBar, RzStatus, ExtCtrls, RzPanel, Grids,
  DBGridEh, RzButton, u_data, RzBckgnd, StdCtrls, RzLabel, XPMan, ImgList,
  ActnList, Mask, RzEdit, RzDBEdit, ComCtrls, RzLaunch, DB, DBTables, u_tu_find,
  RzCommon, RzForms, RzRadChk, StrUtils, frxClass, frxDBSet, frxExportXLS,
  RzSpnEdt, u_no_check_print, DBCtrls, RzDBCmbo, u_stat_ray_print, GridsEh,
  frxExportXML, frxExportRTF, RzRadGrp, RzCmboBx;

type
  TFMain = class(TForm)
    RzSB: TRzStatusBar;
    RzClockStatus1: TRzClockStatus;
    RzGB: TRzGroupBar;
    RzPanel1: TRzPanel;
    RzGroup1: TRzGroup;
    RzGroup2: TRzGroup;
    RzGroup3: TRzGroup;
    RzBitBtn1: TRzBitBtn;
    DBGridEhSchVal: TDBGridEh;
    DBGridEhAskueSrc: TDBGridEh;
    RzBitBtn2: TRzBitBtn;
    DBGridEhRoll: TDBGridEh;
    RzBitBtn5: TRzBitBtn;
    RzLabel1: TRzLabel;
    RzSeparator1: TRzSeparator;
    XPM: TXPManifest;
    AL: TActionList;
    AGetRoll: TAction;
    IL: TImageList;
    AExit: TAction;
    AAddSchVal: TAction;
    DTPRoll: TDateTimePicker;
    RzL: TRzLauncher;
    ATUFind: TAction;
    ATUFindParam: TAction;
    RzFormState1: TRzFormState;
    RzRegIniFile1: TRzRegIniFile;
    RzLabel2: TRzLabel;
    RzSeparator2: TRzSeparator;
    RzCheckBox1: TRzCheckBox;
    RzCheckBox2: TRzCheckBox;
    RzCheckBox3: TRzCheckBox;
    RzCheckBox4: TRzCheckBox;
    RzCheckBox5: TRzCheckBox;
    RzCheckBox6: TRzCheckBox;
    RzCheckBox7: TRzCheckBox;
    RzCheckBox8: TRzCheckBox;
    RzBitBtn3: TRzBitBtn;
    APrintList: TAction;
    ASetListFilter: TAction;
    frxDBDSList: TfrxDBDataset;
    RzLabel3: TRzLabel;
    RzCheckBox9: TRzCheckBox;
    RNEStat: TRzNumericEdit;
    ANoCheckPrint: TAction;
    RzSPRecCount: TRzStatusPane;
    frxRList: TfrxReport;
    RzDBLCBTypeSch: TRzDBLookupComboBox;
    RzCheckBox10: TRzCheckBox;
    RzLabel4: TRzLabel;
    AStatRayPrint: TAction;
    frxXLSExport1: TfrxXLSExport;
    DBGridEhDistricts: TDBGridEh;
    NomSchEdit: TRzEdit;
    NomSchEditLabel: TRzLabel;
    ErrorTypeCombo: TRzComboBox;
    NomSchCheck: TRzCheckBox;
    procedure AExitExecute(Sender: TObject);
    procedure DTPRollChange(Sender: TObject);
    procedure AGetRollExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RzLFinished(Sender: TObject);
    procedure AAddSchValExecute(Sender: TObject);
    procedure ATUFindExecute(Sender: TObject);
    procedure ATUFindParamExecute(Sender: TObject);
    procedure DBGridEhSchValKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ASetListFilterExecute(Sender: TObject);
    procedure APrintListExecute(Sender: TObject);
    procedure ANoCheckPrintExecute(Sender: TObject);
    procedure RzDBLCBTypeSchCloseUp(Sender: TObject);
    procedure AStatRayPrintExecute(Sender: TObject);
	 procedure RzBitBtn4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  
var
  FMain: TFMain;

implementation

uses U_Rep_Stat_Uch;

{$R *.dfm}

procedure TFMain.AExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFMain.DTPRollChange(Sender: TObject);
begin
  DM.OQRoll.ParamByName('roll_date').AsDate := DTPRoll.Date;
  DM.OQRoll.Refresh;
end;

procedure TFMain.AGetRollExecute(Sender: TObject);
var
 inter_type:integer;
 val_date,ser_num:string;
 sch_val1,val_num:integer; 
 NewRoll: Integer;
begin
Screen.Cursor:= crHourGlass;
//???????? Media
if DM.OTAskueSrc.FieldByName('id').AsInteger=6 then
 begin
	DM.OSPRoll.StoredProcName := 'askue.askue_proc.get_roll_id';
	DM.OSPRoll.Execute;
	NewRoll := DM.OSPRoll.ParamByName('result').AsInteger;

  DM.OSQLRoll.SQL.Clear;
  DM.OSQLRoll.SQL.Add('INSERT INTO askue.roll(id, roll_date, askue_src) VALUES(:id, :roll_date, 6)');
  DM.OSQLRoll.ParamByName('id').AsInteger := NewRoll;
  DM.OSQLRoll.ParamByName('roll_date').AsDate := Now;
  DM.OSQLRoll.Execute;
  DM.OQRoll.Refresh;
  DM.OQRoll.Locate('id', NewRoll, [loCaseInsensitive]);

  DM.OS.Commit;

  DM.Get_MEDIA_PROC.ParamByName('pdistrict').AsString:=DM.OTAskueDistricts.FieldByName('name').AsString;//???????? ?????

  try
	 DM.Get_MEDIA_PROC.Execute;	 
  except
	 ShowMessage('?????? ?????????? ???????? ?????????');
  end;
	
// ============= ?????? ?????? ? =============
  DM.OQ.SQL.Clear;
  DM.OQ.SQL.Add('SELECT count(id) c_id FROM askue.sch_val WHERE roll = :roll');
  DM.OQ.ParamByName('roll').AsInteger := NewRoll;
  DM.OQ.Open;
  if DM.OQ.FieldByName('c_id').AsInteger = 0 then 
   begin
	 DM.OSQL.SQL.Clear;
	 DM.OSQL.SQL.Add('DELETE FROM askue.roll WHERE id = :roll');
	 DM.OSQL.ParamByName('roll').AsInteger := NewRoll;
	 DM.OSQL.Execute;
	 DM.OS.Commit;
	 DM.OQRoll.Refresh;
  end;  
 end;

//???????? ???
if DM.OTAskueSrc.FieldByName('id').AsInteger=4 then
 begin
	DM.OSPRoll.StoredProcName := 'askue.askue_proc.get_roll_id';
	DM.OSPRoll.Execute;
	NewRoll := DM.OSPRoll.ParamByName('result').AsInteger;
  
  DM.OSQLRoll.SQL.Clear;
  DM.OSQLRoll.SQL.Add('INSERT INTO askue.roll(id, roll_date, askue_src) VALUES(:id, :roll_date, 4)');
  DM.OSQLRoll.ParamByName('id').AsInteger := NewRoll;
  DM.OSQLRoll.ParamByName('roll_date').AsDate := Now;
  DM.OSQLRoll.Execute;
  DM.OQRoll.Refresh;
  DM.OQRoll.Locate('id', NewRoll, [loCaseInsensitive]);

  DM.OS.Commit;

  DM.OSPRoll.StoredProcName := 'askue.get_rms';
  DM.OSPRoll.Execute;

  DM.Update_RMS_PROC.ParamByName('pid_roll').AsInteger:=NewRoll;
  DM.Update_RMS_Proc.Execute;	 
	
// ============= ?????? ?????? ? =============
  DM.OQ.SQL.Clear;
  DM.OQ.SQL.Add('SELECT count(id) c_id FROM askue.sch_val WHERE roll = :roll');
  DM.OQ.ParamByName('roll').AsInteger := NewRoll;
  DM.OQ.Open;
  if DM.OQ.FieldByName('c_id').AsInteger = 0 then 
	begin
	 DM.OSQL.SQL.Clear;
	 DM.OSQL.SQL.Add('DELETE FROM askue.roll WHERE id = :roll');
	 DM.OSQL.ParamByName('roll').AsInteger := NewRoll;
	 DM.OSQL.Execute;
	 DM.OS.Commit;
	 DM.OQRoll.Refresh;
  end;  
 end;

//???????? ???????????
if DM.OTAskueSrc.FieldByName('id').AsInteger=7 then
 begin
	DM.OSPRoll.StoredProcName := 'askue.askue_proc.get_roll_id';
	DM.OSPRoll.Execute;
	NewRoll := DM.OSPRoll.ParamByName('result').AsInteger;
  
  DM.OSQLRoll.SQL.Clear;
  DM.OSQLRoll.SQL.Add('INSERT INTO askue.roll(id, roll_date, askue_src) VALUES (:id, :roll_date, 7)');
  DM.OSQLRoll.ParamByName('id').AsInteger := NewRoll;
  DM.OSQLRoll.ParamByName('roll_date').AsDate := Now;
  DM.OSQLRoll.Execute;
  DM.OQRoll.Refresh;
  DM.OQRoll.Locate('id', NewRoll, [loCaseInsensitive]);

  DM.OS.Commit;

  DM.OSPRoll.StoredProcName := '';
  DM.OSPRoll.Execute;

  DM.Update_RMS_PROC.ParamByName('pid_roll').AsInteger:=NewRoll;
  DM.Update_RMS_Proc.Execute;	 
	
// ============= ?????? ?????? ? =============
  DM.OQ.SQL.Clear;
  DM.OQ.SQL.Add('SELECT count(id) c_id FROM askue.sch_val WHERE roll = :roll');
  DM.OQ.ParamByName('roll').AsInteger := NewRoll;
  DM.OQ.Open;
  if DM.OQ.FieldByName('c_id').AsInteger = 0 then 
	begin
	 DM.OSQL.SQL.Clear;
	 DM.OSQL.SQL.Add('DELETE FROM askue.roll WHERE id = :roll');
	 DM.OSQL.ParamByName('roll').AsInteger := NewRoll;
	 DM.OSQL.Execute;
	 DM.OS.Commit;
	 DM.OQRoll.Refresh;
  end;  
 end;

//???????? ?????????
if DM.OTAskueSrc.FieldByName('id').AsInteger=3 then
 begin
	DM.OSPRoll.StoredProcName := 'askue.askue_proc.get_roll_id';
	DM.OSPRoll.Execute;
	NewRoll := DM.OSPRoll.ParamByName('result').AsInteger;

  DM.OSQLRoll.SQL.Clear;
  DM.OSQLRoll.SQL.Add('INSERT INTO askue.roll(id, roll_date, askue_src) VALUES(:id, :roll_date, 3)');
  DM.OSQLRoll.ParamByName('id').AsInteger := NewRoll;
  DM.OSQLRoll.ParamByName('roll_date').AsDate := Now;
  DM.OSQLRoll.Execute;
  DM.OQRoll.Refresh;
  DM.OQRoll.Locate('id', NewRoll, [loCaseInsensitive]);

  DM.OS.Commit;	 

  RzL.FileName := DM.OTAskueSrc.FieldByName('ext_mod').AsString;
  RzL.Launch;
	
// ============= ?????? ?????? ? =============
  DM.OQ.SQL.Clear;
  DM.OQ.SQL.Add('SELECT count(id) c_id FROM askue.sch_val WHERE roll = :roll');
  DM.OQ.ParamByName('roll').AsInteger := NewRoll;
  DM.OQ.Open;
  if DM.OQ.FieldByName('c_id').AsInteger = 0 then 
	begin
	 DM.OSQL.SQL.Clear;
	 DM.OSQL.SQL.Add('DELETE FROM askue.roll WHERE id = :roll');
	 DM.OSQL.ParamByName('roll').AsInteger := NewRoll;
	 DM.OSQL.Execute;
	 DM.OS.Commit;
	 DM.OQRoll.Refresh;
  end;  
 end;

//???????? ?????
if  DM.OTAskueSrc.FieldByName('id').AsInteger=1 then
 begin
  DM.OSPRoll.StoredProcName := 'askue.askue_proc.get_roll_id';
  DM.OSPRoll.Execute;
  NewRoll := DM.OSPRoll.ParamByName('result').AsInteger;
  DM.OSQLRoll.SQL.Clear;
  DM.OSQLRoll.SQL.Add('INSERT INTO askue.roll(id, roll_date, askue_src) VALUES(:id, :roll_date, :askue_src)');
  DM.OSQLRoll.ParamByName('id').AsInteger := NewRoll;
  DM.OSQLRoll.ParamByName('roll_date').AsDate := Now;
  DM.OSQLRoll.ParamByName('askue_src').AsInteger := DM.OTAskueSrc.FieldByName('id').AsInteger;
  DM.OSQLRoll.Execute;
  DM.OQRoll.Refresh;
  DM.OQRoll.Locate('id', NewRoll, [loCaseInsensitive]);

  DM.OS.Commit;

  RzL.FileName := DM.OTAskueSrc.FieldByName('ext_mod').AsString;
  RzL.Parameters := DM.OS.Server + ' "' +
						  DM.OS.Username + '" "' +
						  DM.OS.Password + '" ' +
						  IntToStr(NewRoll) + ' ' +
						  DM.OTAskueSrc.FieldByName('id').AsString;
  RzL.Launch;

// ============= ?????? ?????? ? =============
  DM.OQ.SQL.Clear;
  DM.OQ.SQL.Add('SELECT count(id) c_id FROM askue.sch_val WHERE roll = :roll');
  DM.OQ.ParamByName('roll').AsInteger := NewRoll;
  DM.OQ.Open;
  if DM.OQ.FieldByName('c_id').AsInteger = 0 then begin
	 DM.OSQL.SQL.Clear;
	 DM.OSQL.SQL.Add('DELETE FROM askue.roll WHERE id = :roll');
	 DM.OSQL.ParamByName('roll').AsInteger := NewRoll;
	 DM.OSQL.Execute;
	 DM.OS.Commit;
	 DM.OQRoll.Refresh;
	end;
 end;
DM.OQSchVal.Refresh;
ASetListFilterExecute(self);
Screen.Cursor:= crArrow;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  DTPRoll.Date := Date;
  DM.OQRoll.ParamByName('roll_date').AsDate := DTPRoll.Date;
  DM.OQRoll.Refresh;
end;

procedure TFMain.RzLFinished(Sender: TObject);
begin
  DM.OQSchVal.Refresh;
end;

procedure TFMain.AAddSchValExecute(Sender: TObject);
var
  ResStep: Integer;
  MessLog: String;
  PrevNote: String;
  StatStr: String;
  BPos, EPos: Integer;
begin
  DM.OQSchVal.First;
  while not DM.OQSchVal.Eof do begin
    ResStep := 0;
    MessLog := '';
    if (DM.OQSchVal.FieldByName('sch_num').AsInteger > 0) and
       (DM.OQSchVal.FieldByName('add_val_step').AsInteger = 0) and
       (DM.OQSchVal.FieldByName('add_val_step').AsInteger = 0) then begin
      // ==== ??????? ?????? ? ????????? ?? ????????? ====
      DM.OSPGetPoslPok.ParamByName('PLS').Value := DM.OQSchVal.FieldByName('sch_ls').AsInteger;
      DM.OSPGetPoslPok.ParamByName('PNSCHETCH').Value := DM.OQSchVal.FieldByName('sch_num').AsInteger;
      DM.OSPGetPoslPok.ParamByName('PDAT_UST').Value := DM.OQSchVal.FieldByName('sch_date').AsDateTime;
      DM.OSPGetPoslPok.ParamByName('PNPOK').Value := DM.OQSchVal.FieldByName('sch_npok').AsFloat;
      DM.OSPGetPoslPok.ParamByName('PNPOKN').Value := DM.OQSchVal.FieldByName('sch_npokn').AsFloat;
      DM.OSPGetPoslPok.Execute;
      ResStep := 1;
      if DM.OSPGetPoslPok.ParamByName('PKZ').AsInteger > 0 then begin
        case DM.OSPGetPoslPok.ParamByName('PKZ').AsInteger of
          1: MessLog := MessLog + '?????? ????? ?? ??????????; ';
          2: MessLog := MessLog + '?????? ????? ?? ?? ????????; ';
          3: MessLog := MessLog + '?? ?????????? ???????; ';
        else
          MessLog := MessLog + '?????? ?????????? ?????????; ';
        end;
      end else begin
        if DM.OSPGetPoslPok.ParamByName('pdat_ppok').AsDateTime >=
           DM.OQSchVal.FieldByName('val_date').AsDateTime then begin
          MessLog := MessLog + '????????? ?? ?????????; ';
        end else begin
          DM.OSPProvPokaz.ParamByName('PLS').Value := DM.OQSchVal.FieldByName('sch_ls').AsInteger;
          DM.OSPProvPokaz.ParamByName('PNSCHETCH').Value := DM.OQSchVal.FieldByName('sch_num').AsInteger;
          DM.OSPProvPokaz.ParamByName('PZONN').Value := DM.OQSchVal.FieldByName('sch_zon').AsInteger;
//          DM.OSPProvPokaz.ParamByName('PZNACHN').Value := 0;  // ???? ????????? ? ???????????
          if DM.OSPGetPoslPok.ParamByName('pdat_ppok').Value = DM.OQSchVal.FieldByName('sch_date').AsDateTime then
            DM.OSPProvPokaz.ParamByName('PNDAT_POK').Value := DM.OSPGetPoslPok.ParamByName('pdat_ppok').AsDateTime
          else
            DM.OSPProvPokaz.ParamByName('PNDAT_POK').Value := DM.OSPGetPoslPok.ParamByName('pdat_ppok').AsDateTime + 1;
          DM.OSPProvPokaz.ParamByName('PNPOK').Value := DM.OSPGetPoslPok.ParamByName('PKPOK').Value;
          DM.OSPProvPokaz.ParamByName('PCNPOK').Value := DM.OSPGetPoslPok.ParamByName('PCKPOK').Value;
          DM.OSPProvPokaz.ParamByName('PNPOKN').Value := DM.OSPGetPoslPok.ParamByName('PKPOK_N').Value;
          DM.OSPProvPokaz.ParamByName('PCNPOKN').Value := DM.OSPGetPoslPok.ParamByName('PCKPOK_N').Value;
          DM.OSPProvPokaz.ParamByName('PKDAT_POK').Value := DM.OQSchVal.FieldByName('val_date').AsDateTime;
          DM.OSPProvPokaz.ParamByName('PKPOK').Value := DM.OQSchVal.FieldByName('sch_val1').AsFloat;
          DM.OSPProvPokaz.ParamByName('PKPOKN').Value := DM.OQSchVal.FieldByName('sch_val2').AsFloat;
          DM.OSPProvPokaz.Execute;
          ResStep := 2;
          if (DM.OSPProvPokaz.ParamByName('PKZ').AsInteger > 1) then begin
            case DM.OSPProvPokaz.ParamByName('PKZ').AsInteger of
              3: MessLog := MessLog + '?????? ?? ????????? ?????????????; ';
              4: MessLog := MessLog + '????????? ????????? ?????????; ';
              8: MessLog := MessLog + '????????? ????????? ?????? 2000 ????; ';
            else
              MessLog := MessLog + '?????? ???????? ?????????; ';
            end;
          end else begin
//+++++++++++++++++++++++++ ??? ????????? ??????? ????????? ++++++++++++++++++++++++
            DM.OSQLIns.SQL.Clear;
            DM.OSQLIns.SQL.Add('INSERT INTO esbp.POKAZ(LS, NSCHETCH, DND, DKD, IST_POK, NPOK, CNPOK, KPOK, CKPOK, NPOK_N, CNPOK_N, KPOK_N, CKPOK_N, STAT)');
            DM.OSQLIns.SQL.Add('VALUES(:ls, :nschetch, :dnd, :dkd, :ist_pok, :npok, :cnpok, :kpok, :ckpok, :npok_n, :cnpok_n, :kpok_n, :ckpok_n, :stat_n)');
            DM.OSQLIns.ParamByName('ls').Value := DM.OQSchVal.FieldByName('sch_ls').AsInteger;
            DM.OSQLIns.ParamByName('nschetch').Value := DM.OQSchVal.FieldByName('sch_num').AsInteger;
            if DM.OSPGetPoslPok.ParamByName('pdat_ppok').Value = DM.OQSchVal.FieldByName('sch_date').AsDateTime then
              DM.OSQLIns.ParamByName('dnd').Value := DM.OSPGetPoslPok.ParamByName('pdat_ppok').Value
            else
              DM.OSQLIns.ParamByName('dnd').Value := DM.OSPGetPoslPok.ParamByName('pdat_ppok').Value + 1;
            DM.OSQLIns.ParamByName('dkd').Value := DM.OQSchVal.FieldByName('val_date').AsDateTime;
            DM.OSQLIns.ParamByName('ist_pok').Value := 6;  // ?????
            DM.OSQLIns.ParamByName('npok').Value := DM.OSPGetPoslPok.ParamByName('PKPOK').AsFloat;
            DM.OSQLIns.ParamByName('cnpok').Value := DM.OSPGetPoslPok.ParamByName('PCKPOK').AsInteger;
            DM.OSQLIns.ParamByName('kpok').Value := DM.OQSchVal.FieldByName('sch_val1').AsFloat;
            DM.OSQLIns.ParamByName('ckpok').Value := DM.OSPProvPokaz.ParamByName('PCKPOK').AsInteger;
            DM.OSQLIns.ParamByName('npok_n').Value := DM.OSPGetPoslPok.ParamByName('PKPOK_N').AsFloat;
            DM.OSQLIns.ParamByName('cnpok_n').Value := DM.OSPGetPoslPok.ParamByName('PCKPOK_N').AsInteger;
            DM.OSQLIns.ParamByName('kpok_n').Value := DM.OQSchVal.FieldByName('sch_val2').AsFloat;
            DM.OSQLIns.ParamByName('ckpok_n').Value := DM.OSPProvPokaz.ParamByName('PCKPOKN').AsInteger;

            DM.OSQLIns.ParamByName('stat_n').Value := DM.OQSchVal.FieldByName('SCH_STAT_EXT').AsString;
            try
              ResStep := 3;
              DM.OSQLIns.Execute;
            except
              on E: Exception do
                begin
                  if Pos('?????. ?????. ??????????? ???????? ??????. ????????', E.Message) <> 0 then
                  begin
                    ResStep := 2;
                    MessLog := MessLog + '?????. ?????. ??????????? ???????? ??????. ????????; ';
                  end;
                end;
            end;

// =========== ??????? 3 ????????? ??????? ===========
            {DM.OQ.SQL.Clear;
            DM.OQ.SQL.Add('SELECT komment FROM esbp.schetch ' +
              'WHERE nschetch = :nschetch');
            DM.OQ.ParamByName('nschetch').Value := DM.OQSchVal.FieldByName('sch_num').AsInteger;
            DM.OQ.Open;
            PrevNote := DM.OQ.FieldByName('komment').AsString;
            DM.OQ.Close;}
// =========== ?????? ?????? ??????? ===========
            //BPos := Pos('{', PrevNote);
            //EPos := Pos('}', PrevNote);
            {if (BPos <> 0) and (EPos <> 0) and (BPos < EPos) then
              PrevNote := LeftStr(PrevNote, BPos - 1) +
                RightStr(PrevNote, Length(PrevNote) - EPos);}

            {DM.OQ.SQL.Clear;
            DM.OQ.SQL.Add('SELECT sch_stat_ext FROM askue.sch_val ' +
              'WHERE val_num = 0 AND askue_src = :askue_src AND ' +
              'inter_type = :inter_type AND ser_num = :ser_num ' +
              'ORDER BY val_date');
            DM.OQ.ParamByName('askue_src').Value := DM.OQSchVal.FieldByName('askue_src').AsInteger;
            DM.OQ.ParamByName('inter_type').Value := DM.OQSchVal.FieldByName('inter_type').AsInteger;
            DM.OQ.ParamByName('ser_num').Value := DM.OQSchVal.FieldByName('ser_num').AsString;
            DM.OQ.Open;
            DM.OQ.First;
            StatStr := '';
            while not DM.OQ.Eof do begin
              StatStr := StatStr + DM.OQ.FieldByName('sch_stat_ext').AsString + ';';
              DM.OQ.Next;
            end;
            DM.OQ.Close;}
            //PrevNote := '{' + LeftStr(StatStr, Length(StatStr) - 1) + //'}' + PrevNote;
            {DM.OSQLUpd.SQL.Clear;
            DM.OSQLUpd.SQL.Add('UPDATE esbp.schetch SET komment = :komment WHERE nschetch = :nschetch');
            DM.OSQLUpd.ParamByName('nschetch').Value := DM.OQSchVal.FieldByName('sch_num').AsInteger;
            DM.OSQLUpd.ParamByName('komment').AsString := Trim(LeftStr(PrevNote, 60));
            DM.OSQLUpd.Execute;}
// =====================================================

          end;  // ???? ?????????
        end;  // ???????????? ?????????
      end;  // ????????? ?????????? ?????????
      DM.OSQLUpd.SQL.Clear;
      DM.OSQLUpd.SQL.Add('UPDATE askue.sch_val SET add_val_step = :add_val_step, add_val_log = :add_val_log WHERE id = :id');
      DM.OSQLUpd.ParamByName('add_val_step').AsInteger := ResStep;
      DM.OSQLUpd.ParamByName('add_val_log').AsString := Trim(MessLog);
      DM.OSQLUpd.ParamByName('id').AsInteger := DM.OQSchVal.FieldByName('id').AsInteger;
      DM.OSQLUpd.Execute;
    end;  // ??????-?? ???????
    DM.OQSchVal.Next;
  end;
  DM.OS.Commit;
  DM.OQSchVal.Refresh;
end;

procedure TFMain.ATUFindExecute(Sender: TObject);
begin
  FTUFind.sFind := '';
  FTUFind.Show;
end;

procedure TFMain.ATUFindParamExecute(Sender: TObject);
var
  id: Integer;
begin
  if DM.OQSchVal.FieldByName('sch_ls').AsInteger = -1 then begin
    FTUFind.sFind := DM.OQSchVal.FieldByName('ser_num').AsString;
    FTUFind.ShowModal;
    id := DM.OQSchVal.FieldByName('id').AsInteger;
    DM.OQSchVal.Refresh;
    DM.OQSchVal.Locate('id', id, [loCaseInsensitive])
  end;
end;

procedure TFMain.DBGridEhSchValKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = $0D then begin
    ATUFindParam.Execute;
  end;
end;

procedure TFMain.ASetListFilterExecute(Sender: TObject);

var
  FilterStr: Array[1..8] of String;
  FilterGrp: Array[1..3] of String;
  i: Integer;
  SumFilter: String;

begin
  if RzCheckBox1.Checked then
    FilterStr[1] := 'sch_ls <> -1'
  else
    FilterStr[1] := '';

  if RzCheckBox2.Checked then
    FilterStr[2] := 'sch_ls = -1'
  else
    FilterStr[2] := '';

  if RzCheckBox3.Checked then
    FilterStr[3] := 'add_val_step = 0'
  else
    FilterStr[3] := '';

  if RzCheckBox4.Checked then
    FilterStr[4] := 'add_val_step = 1'
  else
    FilterStr[4] := '';

  if RzCheckBox5.Checked then
	begin
	 FilterStr[5] := 'add_val_step = 2 and add_val_log like ''' + ErrorTypeCombo.Text + '*''';
	 //ErrorTypeCombo.Enabled := true;
	end
  else
	begin
	 FilterStr[5] := '';
	 //ErrorTypeCombo.Enabled := false;
	end;

  if RzCheckBox6.Checked then
    FilterStr[6] := 'add_val_step = 3'
  else
    FilterStr[6] := '';

  if RzCheckBox7.Checked then
    FilterStr[7] := 'val_num = 0'
  else
    FilterStr[7] := '';

  if RzCheckBox8.Checked then
    FilterStr[8] := 'val_num = 1'
  else
    FilterStr[8] := '';

  FilterGrp[1] := '';
  for i := 1 to 2 do begin
    if FilterStr[i] <> '' then FilterGrp[1] := FilterGrp[1] + FilterStr[i] + ' or ';
  end;
  if FilterGrp[1] <> '' then begin
    FilterGrp[1] := '(' + LeftStr(FilterGrp[1], Length(FilterGrp[1]) - 4) + ')';
  end;

  FilterGrp[2] := '';
  for i := 3 to 6 do begin
    if FilterStr[i] <> '' then FilterGrp[2] := FilterGrp[2] + FilterStr[i] + ' or ';
  end;
  if FilterGrp[2] <> '' then begin
    FilterGrp[2] := '(' + LeftStr(FilterGrp[2], Length(FilterGrp[2]) - 4) + ')';
  end;

  FilterGrp[3] := '';
  for i := 7 to 8 do begin
    if FilterStr[i] <> '' then FilterGrp[3] := FilterGrp[3] + FilterStr[i] + ' or ';
  end;
  if FilterGrp[3] <> '' then begin
    FilterGrp[3] := '(' + LeftStr(FilterGrp[3], Length(FilterGrp[3]) - 4) + ')';
  end;

  SumFilter := '';
  for i := 1 to 3 do begin
    if FilterGrp[i] <> '' then SumFilter := SumFilter + FilterGrp[i] + ' and ';
  end;

  if SumFilter <> '' then begin
    SumFilter := LeftStr(SumFilter, Length(SumFilter) - 5);
  end;

// ========== ??? ??????? ==========
  if RzCheckBox9.Checked then begin
    if SumFilter = '' then
      SumFilter := SumFilter + '(sch_stat_ext = ' + RNEStat.Text + ')'
    else
      SumFilter := SumFilter + ' and (sch_stat_ext = ' + RNEStat.Text + ')';
	 RNEStat.Enabled := false;
  end else
    RNEStat.Enabled := true;

// ========== ??? ???? ??-?? ==========
  if RzCheckBox10.Checked then begin
	 if SumFilter = '' then
		SumFilter := SumFilter + '(inter_type = ' + IntToStr(RzDBLCBTypeSch.KeyValue) + ')'
	 else
      SumFilter := SumFilter + ' and (inter_type = ' + IntToStr(RzDBLCBTypeSch.KeyValue) + ')';
	 RzDBLCBTypeSch.Enabled := false;
  end else
	 RzDBLCBTypeSch.Enabled := true;
// ========== ??? ?????? ??-?? ==========
  if NomSchCheck.Checked then 
	begin
	 if  NomSchEdit.Text <> '' then
	  begin
		if SumFilter = '' then
		 SumFilter := SumFilter + '(ser_num = ' + NomSchEdit.Text + ')'
	  else
		SumFilter := SumFilter + ' and (ser_num = ' + NomSchEdit.Text + ')';
		//NomSchCheck.Enabled := false;
     end
	end 
	else
	 NomSchCheck.Enabled := true;

  DM.OQSchVal.Filter := SumFilter;

  RzSPRecCount.Caption := '??????? ???????: ' +
    IntToStr(DM.OQSchVal.RecordCount);

end;

procedure TFMain.APrintListExecute(Sender: TObject);
begin
  frxRList.LoadFromFile(copy(application.ExeName,1,pos('\askue.exe',application.ExeName)-1)+'\rep\list.fr3',true);
  frxRList.ShowReport;
end;

procedure TFMain.ANoCheckPrintExecute(Sender: TObject);
begin
  FNoCheckPrint.ShowModal;
end;

procedure TFMain.RzDBLCBTypeSchCloseUp(Sender: TObject);
begin
  if RzDBLCBTypeSch.KeyValue <> null then
    RzCheckBox10.Enabled := true
  else
    RzCheckBox10.Enabled := false;
end;

procedure TFMain.AStatRayPrintExecute(Sender: TObject);
begin
  FRepStatUch.ShowModal;
end;

procedure TFMain.RzBitBtn4Click(Sender: TObject);
begin
showmessage('????????? ????? ?? ???????????? ??????. ????????? ????????? ????????? ? ?????????? ?????????');
end;



end.
