program Cadastro;

uses
  Forms,
  uLkJSON in 'uLkJSON.pas',
  Global in 'Global.pas',
  JsonObject in 'JsonObject.pas',
  Charset in 'Charset.pas',
  frmCadCliente in 'frmCadCliente.pas' {CadCliente};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TCadCliente, CadCliente);
  Application.Run;
end.
