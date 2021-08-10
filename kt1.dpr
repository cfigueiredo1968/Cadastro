program kt1;

uses
  Forms,
  kk in 'kk.pas' {Form1},
  uLkJSON in 'uLkJSON.pas',
  Global in 'Global.pas',
  JsonObject in 'JsonObject.pas',
  Charset in 'Charset.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
