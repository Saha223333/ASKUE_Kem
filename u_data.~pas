unit u_data;

interface

uses
  SysUtils, Classes, DB, Ora, MemDS, DBAccess, OraSmart, DBTables, Dialogs;

type
  TDM = class(TDataModule)
    OS: TOraSession;
    OTAskueSrc: TOraTable;
    ODSAskueSrc: TOraDataSource;
    ODSSchVal: TOraDataSource;
    ODSRoll: TOraDataSource;
    OQRoll: TOraQuery;
    OQSchVal: TOraQuery;
    OSQLRoll: TOraSQL;
    OSPRoll: TOraStoredProc;
    OQSchValSER_NUM: TStringField;
	 OQSchValVAL_DATE: TDateTimeField;
	 OQSchValSCH_VAL1: TFloatField;
	 OQSchValSCH_VAL2: TFloatField;
	 OQSchValSCH_VAL3: TFloatField;
    OQSchValSCH_STAT_EXT: TFloatField;
    OQSchValNAME: TStringField;
    OQSchValLS_SCH: TFloatField;
    OQSchValADDR_SCH: TStringField;
    OSPGetPoslPok: TOraStoredProc;
    OQSchValID: TFloatField;
    OQSchValSCH_NUM: TFloatField;
    OQSchValADD_VAL_STEP: TFloatField;
    OQSchValSCH_ZON: TFloatField;
    OSPProvPokaz: TOraStoredProc;
    OSQLIns: TOraSQL;
    OSQLUpd: TOraSQL;
    OQSchValADD_VAL_LOG: TStringField;
    OQNotLocate: TOraQuery;
    OQSchTu: TOraQuery;
    ODSSchTu: TOraDataSource;
    OQSchTuNSCHETCH: TFloatField;
    OQSchTuLS: TIntegerField;
    OQSchTuTYPE_STREET: TStringField;
    OQSchTuNAME_STREET: TStringField;
    OQSchTuDOM: TIntegerField;
    OQSchTuKORP: TStringField;
    OQSchTuFLAT: TStringField;
    OQSchTuZAV_NOM: TStringField;
    OQSchTuDND: TDateTimeField;
    OQSchTuDKD: TDateTimeField;
    OQSchTuNAME: TStringField;
    OQSchTuZNACHN: TIntegerField;
    OQSchTuTYPE_SCH: TIntegerField;
    OQSchValSCH_TYPE: TFloatField;
    OQSchValVAL_NUM: TFloatField;
    OSQL: TOraSQL;
    OQ: TOraQuery;
    OQSchValASKUE_SRC: TFloatField;
    OQSchValINTER_TYPE: TFloatField;
    OQNoCheckPrint: TOraQuery;
    OQNoCheckPrintNAME: TStringField;
    OQNoCheckPrintNAME_STREET: TStringField;
    OQNoCheckPrintDK: TStringField;
    OQNoCheckPrintFLAT: TStringField;
    OQNoCheckPrintLS: TIntegerField;
    OQNoCheckPrintZAV_NOM: TStringField;
    OQNoCheckPrintNAME_1: TStringField;
    OQNoCheckPrintKOMMENT: TStringField;
    OTUchastok: TOraTable;
    ODSUchastok: TOraDataSource;
    ODSTypeSchList: TOraDataSource;
    OQTypeSchList: TOraQuery;
    OQSchValSCH_DATE: TDateTimeField;
    OQSchValSCH_NPOK: TFloatField;
    OQSchValSCH_NPOKN: TFloatField;
    OQStatRayPrint: TOraQuery;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    IntegerField1: TIntegerField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    ODSRepStatUch: TDataSource;
    OQRepStatUch: TOraQuery;
    OQRepStatUchNAME: TStringField;
    OQRepStatUchNAME_STREET: TStringField;
    OQRepStatUchDOM: TIntegerField;
    OQRepStatUchKORP: TStringField;
    OQRepStatUchFLAT: TStringField;
    OQRepStatUchNAME_1: TStringField;
    OQRepStatUchSER_NUM: TStringField;
    OQRepStatUchFAZA: TStringField;
    OQRepStatUchZAV_NOM: TStringField;
    OQRepStatUchSCH_STAT_EXT: TFloatField;
    OQStreet: TOraQuery;
    DSStreet: TDataSource;
    OTTypeSch: TOraTable;
    ODSTypeSch: TDataSource;
    OQRepStatUchTYPE_STREET: TStringField;
    OQNoCheckPrintTYPE_STREET: TStringField;
    Get_BQRK_PROC: TOraStoredProc;
    OQPar: TOraQuery;
    OQParACCOUNT_ID: TFloatField;
	 OQParDATE_M: TDateTimeField;
    OQParW_: TFloatField;
    OQParTID: TFloatField;
    OQParNUMB: TFloatField;
    OQ2: TOraQuery;
    Update_RMS_PROC: TOraStoredProc;
    OTAskueSrcID: TFloatField;
    OTAskueSrcNAME: TStringField;
    OTAskueSrcEXT_MOD: TStringField;
    OQNoCheckPrintDefault: TOraQuery;
    Get_MEDIA_PROC: TOraStoredProc;
    OTAskueDistricts: TOraTable;
    ODSDistricts: TOraDataSource;
    procedure OTAskueSrcAfterScroll(DataSet: TDataSet);
    procedure OQRollAfterScroll(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

uses
  u_main;

procedure TDM.OTAskueSrcAfterScroll(DataSet: TDataSet);
begin
FMain.RzBitBtn2.Enabled := true;
FMain.DbGridEhDistricts.Visible:=false;
 Case DM.OTAskueSrc.FieldByName('id').AsInteger of
  4:FMain.RzBitBtn2.Enabled := false;
  6:FMain.DbGridEhDistricts.Visible:=true;
 end;
 FMain.ASetListFilterExecute(FMain);
end;

procedure TDM.OQRollAfterScroll(DataSet: TDataSet);
begin
 FMain.ASetListFilterExecute(FMain);
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
 OTAskueSrc.Active:=true;
 OQRoll.Active:=true;
 OQSchVal.Active:=true;
 OQNotLocate.Active:=true;
 OQSchTu.Active:=true;
 OQNoCheckPrint.Active:=true;
 OQStatRayPrint.Active:=true;
 OQNoCheckPrintDefault.Active:=true;
 OQRepStatUch.Active:=true;
 OQStreet.Active:=true;
 OTTypeSch.Active:=true;
 OTUchastok.Active:=true;
 OQTypeSchList.Active:=true;
 OTAskueDistricts.Active:=true;
end;

end.
