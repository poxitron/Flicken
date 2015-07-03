program Flicken;

uses
  Vcl.Forms,
  frmMain in 'frmMain.pas' {Form2},
  MyFunctions in 'MyFunctions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Flicken';
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
