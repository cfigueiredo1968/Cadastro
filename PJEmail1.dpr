program PJEmail1;

uses
  Forms,
  email in 'email.pas' {Form1},
  IdText in 'IdText.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
