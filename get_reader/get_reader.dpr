program get_reader;

uses
  Forms,
  uMain in 'uMain.pas' {FMain},
  uRidThread in 'uRidThread.pas',
  uDM in 'uDM.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
