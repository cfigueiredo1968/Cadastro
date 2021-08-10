unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP;

type
  TForm1 = class(TForm)
    IdHTTP1: TIdHTTP;
    Button1: TButton;
    reResp: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);

var lURL : String;
lResponse : TStringStream;
begin
lResponse := TStringStream.Create('');

try
lURL := 'http://www.google.com.br/search?' +
'hl=pt-BR&' +
'q=balaio%20tecnologico';
idHttp1.Get(lURL, lResponse);
lResponse.Position := 0;
{ Exemplo de uso do response : carregar o conteúdo num RichEdit : }
reResp.Lines.LoadFromStream(lResponse);
finally
lResponse.Free();
end;
end;

end.
