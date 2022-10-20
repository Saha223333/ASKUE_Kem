unit u_rep_stat_uch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, StdCtrls, RzLabel, u_data, RzRadChk, Mask, RzEdit,
  RzCmboBx, RzDBCmbo, DBCtrls, GridsEh, DBGridEh, ImgList, RzDBLbl,
  RzStatus, RzDBStat, frxClass, frxDBSet, frxExportXLS, frxExportXML;

type
  TFRepStatUch = class(TForm)
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    RzBitBtn1: TRzBitBtn;
    RzBitBtn2: TRzBitBtn;
    RzDBLCBUchastok: TRzDBLookupComboBox;
    RzBitBtn3: TRzBitBtn;
    RzBitBtn4: TRzBitBtn;
    RzLabel5: TRzLabel;
    ImageList1: TImageList;
    RzBitBtn5: TRzBitBtn;
    RzDBLCBTypeSch: TRzDBLookupComboBox;
    RzCount: TRzLabel;
    frxDBDataset1: TfrxDBDataset;
    DBGridEh2: TDBGridEh;
    RzNEStat: TEdit;
    str_lookup: TRzDBLookupComboBox;
    frxReport1: TfrxReport;
    procedure RzBitBtn1Click(Sender: TObject);
    procedure RzBitBtn2Click(Sender: TObject);
    procedure RzBitBtn4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CBStreetExit(Sender: TObject);
    procedure CBStreetCloseUp(Sender: TObject);
    procedure RzBitBtn5Click(Sender: TObject);
    procedure RzBitBtn3Click(Sender: TObject);
    procedure RzDBLCBUchastokCloseUp(Sender: TObject);
    procedure RzNEStatChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRepStatUch: TFRepStatUch;

implementation

{$R *.dfm}

procedure TFRepStatUch.RzBitBtn1Click(Sender: TObject);
begin
if RzDBLCBUchastok.Text<>''
then begin

  RzDBLCBUchastok.ClearKeyValue;
  // Удаление условия связи улиц по участкам
  DM.OQStreet.Close;
  DM.OQStreet.SQL.Delete(3);
  DM.OQStreet.Open;

  // Список улиц
  str_lookup.KeyValue:=-1;
  DM.OQStreet.First;
  {While DM.OQStreet.Eof=false
  do begin
		CBStreet.Items.Add(DM.OQStreet.FieldByName('Name_Street').AsString);
      DM.OQStreet.Next;
  end; } 

end;
end;

procedure TFRepStatUch.RzBitBtn2Click(Sender: TObject);
begin
//str_lookup.ClearKeyValue;
str_lookup.KeyValue := null;
end;

procedure TFRepStatUch.RzBitBtn4Click(Sender: TObject);
begin
Close;
end;

procedure TFRepStatUch.FormShow(Sender: TObject);
begin
DM.OQRepStatUch.Close;
RzDBLCBUchastok.KeyValue:=-1;
RzDBLCBTypeSch.KeyValue:=0;
//CBStreet.Text:='';
RzNEStat.Text:='0';

RzDBLCBUchastok.SetFocus;


//Заполнение списка улиц
DM.OQStreet.First;
{While DM.OQStreet.Eof=false
do begin
	 CBStreet.Items.Add(DM.OQStreet.FieldByName('Name_Street').AsString);
    DM.OQStreet.Next;
end; }

end;

procedure TFRepStatUch.CBStreetExit(Sender: TObject);
begin
//if DM.OQStreet.Locate('Name_Street', CBStreet.Text,  [])=false
//then CBStreet.Text:='';
end;

procedure TFRepStatUch.CBStreetCloseUp(Sender: TObject);
begin
//if DM.OQStreet.Locate('Name_Street', CBStreet.Text, [])=false
//then CBStreet.Text:='';
end;

procedure TFRepStatUch.RzBitBtn5Click(Sender: TObject);
var
str,uch:string;
begin

DM.OQRepStatUch.Close;
DM.OQRepStatUch.SQL.Clear;

// По участку
if DM.OTUchastok.Locate('Name',RzDBLCBUchastok.Text,[])=true
then uch:=
		  //	 DM.OTUchastok.FieldByName('Uchastok').Value
	RzDBLCBUchastok.Text
else 
  uch:='%';

if str_lookup.KeyValue=null then
	str:='%' 
else
  //str:=str_lookup.KeyValue;
  str:=str_lookup.Text;

// По типу счетчика
DM.OQTypeSchList.Locate('Name',RzDBLCBTypeSch.Text,[]);
//DM.OQRepStatUch.ParamByName('tsch').AsInteger:=DM.OQTypeSchList.FieldByName('Type_Sch').AsInteger;
 DM.OQRepStatUch.SQL.Text:=
'select distinct u.NAME, s.Type_Street, s.NAME_STREET, l.DOM, l.KORP,'+
' l.FLAT, ts.NAME, asv.SER_NUM, d1.FAZA, d1.ZAV_NOM, asv.SCH_STAT_EXT'+
' from esbp.ls l'+
' left join (select d.LS, d.ZAV_NOM, d.FAZA'+
' from esbp.datch_m_ls d where d.DKD>sysdate) d1 on d1.ls=l.ls,'+
' esbp.street s, esbp.bilds b, esbp.uchastok u,  esbp.type_sch ts,'+
' esbp.schetch sch, askue.sch_type_ext ast, askue.sch_val_rep asv'+

//' right join (select asv.SER_NUM, max(asv.VAL_DATE) dat  from askue.sch_val asv'+
//' group by asv.SER_NUM) q on asv.SER_NUM=q.ser_num and asv.VAL_DATE=q.dat'+

' where l.TAUN=b.TAUN and l.STREET=b.STREET and l.DOM=b.DOM'+
' and l.KORP=b.KORP and b.UCHASTOK=u.UCHASTOK and b.TAUN=s.TAUN'+
' and b.STREET=s.STREET and l.LS=sch.LS and sch.TYPE_SCH=ts.TYPE_SCH'+
' and sch.ZAV_NOM=asv.SER_NUM and asv.INTER_TYPE=ast.INTER_TYPE'+
' and sch.TYPE_SCH=ast.SCH_TYPE and l.DKD>sysdate'+
' and sch.DKD>sysdate and ts.type_sch like '''+ DM.OQTypeSchList.FieldByName('Type_Sch').AsString +''''+
//' and u.uchastok like '''+uch+'''' +
' and u.name like '''+uch+'''' +
//' and s.street = '''+str+''''
' and s.name_street like '''+str+''''
+' and asv.SCH_STAT_EXT in ('+RzNEStat.text+') ORDER BY u.NAME, s.NAME_STREET,'+
'l.DOM, l.KORP, l.FLAT ';

DM.OQRepStatUch.Open;

DM.OQRepStatUch.Last;
RzCount.Caption:=IntToStr(DM.OQRepStatUch.RecordCount);
DM.OQRepStatUch.First;

end;

procedure TFRepStatUch.RzBitBtn3Click(Sender: TObject);
begin
DBGridEh2.DataSource.DataSet.DisableControls;
frxReport1.LoadFromFile(copy(application.ExeName,1,pos('\askue.exe',application.ExeName)-1)+'\rep\stat_tsch.fr3',true);
frxReport1.PrepareReport();
frxReport1.ShowReport;
DM.OQRepStatUch.Close;
DM.OQRepStatUch.Open;
DBGridEh2.DataSource.DataSet.EnableControls;
end;

procedure TFRepStatUch.RzDBLCBUchastokCloseUp(Sender: TObject);
begin

if RZDBLCBUchastok.Text<>''
then begin
  // Связь улиц по участкам
  DM.OQStreet.Close;
  DM.OQStreet.SQL.Add('and b.uchastok=:uch');
  if DM.OTUchastok.Locate('Name',RzDBLCBUchastok.Text,[])=true
  then DM.OQStreet.ParamByName('uch').AsInteger:=
          DM.OTUchastok.FieldByName('Uchastok').AsInteger;
  DM.OQStreet.Open;
  // Заполнение списка улиц
  //CBStreet.Clear;
  DM.OQStreet.First;
  {While DM.OQStreet.Eof=false
  do begin
		CBStreet.Items.Add(DM.OQStreet.FieldByName('Name_Street').AsString);
      DM.OQStreet.Next;
  end; }

end;

end;

procedure TFRepStatUch.RzNEStatChange(Sender: TObject);
begin
{if StrToInt(RzNEStat.Text)>999
then begin
    Application.MessageBox('Статус задан не верно!','Ошибка!',MB_OK);
    RzNEStat.Text:='0';
end; }
end;

end.
