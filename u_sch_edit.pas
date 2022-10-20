unit u_sch_edit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzCmboBx, RzDBCmbo, Mask, RzEdit, ImgList, RzButton,
  RzLabel, RzBckgnd, u_data, DBCtrls, RzForms;

type
  TFSchEdit = class(TForm)
    RzSeparator1: TRzSeparator;
    RzLLS: TRzLabel;
    RzBitBtn1: TRzBitBtn;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    RzLabel5: TRzLabel;
    RzLabel6: TRzLabel;
    RzLAddr: TRzLabel;
    RzLSchDD: TRzLabel;
    RzESerNum: TRzEdit;
    RzBitBtn2: TRzBitBtn;
    RzDBLCBTypeSch: TRzDBLookupComboBox;
    RzFormState1: TRzFormState;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSchEdit: TFSchEdit;

implementation

{$R *.dfm}

uses
  u_main;

procedure TFSchEdit.FormShow(Sender: TObject);
begin
  RzESerNum.SetFocus;
end;

end.
