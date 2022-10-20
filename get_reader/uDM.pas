unit uDM;

interface

uses
  SysUtils, Classes, DB, MemDS, DBAccess, Ora, OraSmart;

type
  TDM = class(TDataModule)
    OS: TOraSession;
    OSQL: TOraSQL;
    OQ: TOraQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

end.
