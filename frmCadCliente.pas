unit frmCadCliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uLkJSON, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP,IdSMTP, IdMessage, IdEMailAddress, ExtCtrls, DB,
  DBClient, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase,
  IdAntiFreezeBase, IdAntiFreeze,IdAttachmentFile,IdAttachment;


type
 TParametrosEmail = record
    SMTPHost, SMTPUsername, SMTPPassword,NomeAnexo: string;
    SMTPConta, SMTPNomeExibicao, SMTPDestinatarios: string;
    SMTPAutenticacao, SMTPSSL: boolean;
    SMTPPorta: integer;
  end;

  TCadCliente = class(TForm)
    Memo1: TMemo;
    IdHTTP1: TIdHTTP;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtNome: TEdit;
    edtIdentidade: TEdit;
    edtCPF: TEdit;
    edttelefone: TEdit;
    edtEmail: TEdit;
    Panel2: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    edtCEP: TEdit;
    EdtLogradouro: TEdit;
    edtComplemento: TEdit;
    edtBairro: TEdit;
    edtNumero: TEdit;
    edtCidade: TEdit;
    edtEstado: TEdit;
    edtpais: TEdit;
    btnBuscarCEP: TButton;
    btnEnviar: TButton;
    cdsDados: TClientDataSet;
    cdsDadosNome: TStringField;
    cdsDadosIdentidade: TStringField;
    dsDados: TDataSource;
    cdsDadosCPF: TStringField;
    cdsDadosTelefone: TStringField;
    cdsDadosEmail: TStringField;
    cdsDadosCEP: TStringField;
    cdsDadosLogradouro: TStringField;
    cdsDadosNumero: TStringField;
    cdsDadosComplemento: TStringField;
    cdsDadosBairro: TStringField;
    cdsDadosCidade: TStringField;
    cdsDadosUF: TStringField;
    cdsDadosPais: TStringField;
    ClienteSMTP: TIdSMTP;
    SSLHandlerSMTP: TIdSSLIOHandlerSocketOpenSSL;
    IdMessage1: TIdMessage;
    IdAntiFreeze1: TIdAntiFreeze;
    btnSair: TButton;
    procedure Button2Click(Sender: TObject);
    procedure btnEnviarClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure btnBuscarCEPClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
  private
    { Private declarations }
    FParametrosEmail: TParametrosEmail; // declaracao da vari?vel
    procedure BuscarCEP(sCep:String);
    procedure ConfiguraEnviaEmail();
    function ValidaCampos():boolean;
    function GravaXML():boolean;
    procedure EnviarEmail();

  public
    { Public declarations }
  end;

var
  CadCliente: TCadCliente;

implementation

uses Global, JsonObject, Charset,unFuncoes;

{$R *.dfm}

procedure TCadCliente.Button2Click(Sender: TObject);
var
   Str :String;
   lhttp :TIdHTTP;
   json: HCkJsonObject;
   success: Boolean;
   retorno,url:string;
   charset: HCkCharset;
   js: TlkJSONobject;
begin
  lhttp := TIdHTTP.Create;
  url := 'http://viacep.com.br/ws/'+ edtCEP.Text +'/json/';
  Str := lhttp.get(url);
  //memo1.Lines.Add(  converter_utf8_ansi(str));
  js := TlkJSON.ParseText(str) as TlkJSONobject;
  Memo1.Lines.Add( VarToStr(js.Field['cep'].Value));
  EdtLogradouro.Text := VarToStr(js.Field['logradouro'].Value);
  EdtBairro.Text := VarToStr(js.Field['bairro'].Value);
  EdtCidade.Text := VarToStr(js.Field['localidade'].Value);
  edtEstado.Text := VarToStr(js.Field['uf'].Value);
  edtcomplemento.Text := VarToStr(js.Field['complemento'].Value);

//CkJsonObject_Dispose(json);

end;
procedure TCadCliente.btnEnviarClick(Sender: TObject);
begin

   if GravaXML then begin
      ConfiguraEnviaEmail();
      enviarEmail;
   end;
end;

procedure TCadCliente.Button5Click(Sender: TObject);
var
  AutenticouSMTP: boolean;
begin

  FParametrosEmail.SMTPConta := 'claudio de figueiredo batista';
  FParametrosEmail.SMTPNomeExibicao := 'Claudio Figueiredo';
  FParametrosEmail.SMTPPassword := 'Awabi714520#!####';
  FParametrosEmail.SMTPUsername := 'claudiodefigueiredo@gmail.com';

  FParametrosEmail.SMTPHost := 'smtp.gmail.com';
  FParametrosEmail.SMTPPorta := 587;
  FParametrosEmail.SMTPAutenticacao := True; // requer autenticacao
  FParametrosEmail.SMTPSSL := True; // requer conexao segura

  // destinatarios separados por virgula
  FParametrosEmail.SMTPDestinatarios := 'claudiofigueiredo@gmail.com';


  if ClienteSMTP.Connected then
    try
      ClienteSMTP.Disconnect;
    except
   end;
  ClienteSMTP.Host := FParametrosEmail.SMTPHost; // atribui o host (pop.gmail.com)
  ClienteSMTP.Port := FParametrosEmail.SMTPPorta; // atribui a porta (465)

  if FParametrosEmail.SMTPAutenticacao then // se requer autenticacao
  begin
    ClienteSMTP.Username := FParametrosEmail.SMTPUsername; // atribui o nome do usuario
    ClienteSMTP.Password := FParametrosEmail.SMTPPassword; // atribui a senha
  end
  else
  begin // se n?o requer autenticacao
    ClienteSMTP.Username := ''; // limpa o usuario
    ClienteSMTP.Password := ''; // limpa a senha
  end;

   if FParametrosEmail.SMTPSSL then // se requer conexao segura
  begin
   ClienteSMTP.IOHandler := SSLHandlerSMTP; // vincula o manipulador de SMTP ao cliente SMTP
   ClienteSMTP.UseTLS := utUseImplicitTLS; // atribui ao cliente SMTP o suporte impl?cito a TLS

//   ClienteSMTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
//   TIdSSLIOHandlerSocketOpenSSL(ClienteSMTP.IOHandler).SSLOptions.SSLVersions := [sslvTLSv1_2]

    SSLHandlerSMTP.SSLOptions.Method := sslvSSLv2;
    SSLHandlerSMTP.SSLOptions.Mode := sslmClient;

    SSLHandlerSMTP.Port := ClienteSMTP.Port; // atribui a porta ao manipulador (igual a do cliente FTP)
    SSLHandlerSMTP.Destination := ClienteSMTP.Host + ':' + IntToStr(ClienteSMTP.Port); // indica o destino da conex?o (pop.gmail.com:465)
    SSLHandlerSMTP.Host := ClienteSMTP.Host; // atribui o host (pop.gmail.com)
  end
  else
  begin // se n?o requer conexao segura
    ClienteSMTP.IOHandler := nil; // desvincula o manipulador de SMTP
    ClienteSMTP.UseTLS := utNoTLSSupport; // indica que nao ha suporte a TLS
  end;
AutenticouSMTP := False; // variavel para indicar se a autenticacao foi bem sucedida

  // *** montagem da mensagem ***
  // ****************************
  // cabecalho
  IdMessage1.Clear;
  IdMessage1.ContentType := 'text/html';
  IdMessage1.From.Address := FParametrosEmail.SMTPConta; // conta do remetente
  IdMessage1.From.Name := FParametrosEmail.SMTPNomeExibicao; // nome do remetente
  IdMessage1.Recipients.EMailAddresses := FParametrosEmail.SMTPDestinatarios; // destinatarios (separados por v?rgula! n?o ? ponto e v?rgula!)
  IdMessage1.Subject := 'Envio de email automatico'; // assunto

  // corpo
  IdMessage1.Body.Clear;
  IdMessage1.Body.Add('<html>');
  IdMessage1.Body.Add('    <body>');
  IdMessage1.Body.Add('        <h4>SISTEMA DE EMAIL AUTOMATICO</h4>');
  IdMessage1.Body.Add('        <font face="Verdana" size=2>');
  IdMessage1.Body.Add('        Envio de informa??es cadastrais');
  IdMessage1.Body.Add('        <hr size=1 noshade>');
  IdMessage1.Body.Add('        <font face="Courier New" size=2>');
  IdMessage1.Body.Add('Foi enviado automaticamente um XML com as informa??es cadastrais');
  IdMessage1.Body.Add('        </font>');
  IdMessage1.Body.Add('        <b><font face="Tahoma" size=2 color="black">');
  IdMessage1.Body.Add('        <hr size=1 noshade>');
  IdMessage1.Body.Add('        EMITIDO AUTOMATICAMENTE PELO SISTEMA<br>');
  IdMessage1.Body.Add('        <font color="blue">');
  IdMessage1.Body.Add('        Bom dia');
  IdMessage1.Body.Add('        </font>');
  IdMessage1.Body.Add('        </font></b>');
  IdMessage1.Body.Add('    </body>');
  IdMessage1.Body.Add('</html>');

 // efetua a conexao ao servidor SMTP
  if not ClienteSMTP.Connected then
    try
      ClienteSMTP.Connect; // conecta ao SMTP
      if FParametrosEmail.SMTPAutenticacao then // se requer autenticacao
        AutenticouSMTP := ClienteSMTP.Authenticate // efetua a atenticacao e retorna o resultado para a vari?vel
      else // se nao requer autenticacao
        AutenticouSMTP := True; // assume que a conexao foi bem sucedida
    except
      on E:Exception do begin // em caso de erro gera um log com a mensagem de erro
        ShowMessage('N?o foi poss?vel conectar ao servidor SMTP: '+E.Message);
        end;
    end;

  // se a conexao foi bem sucedida, envia a mensagem
  if AutenticouSMTP and ClienteSMTP.Connected then
    ClienteSMTP.Send(IdMessage1);

  // depois de tudo pronto, desconecta do servidor SMTP
  if ClienteSMTP.Connected then
    ClienteSMTP.Disconnect;


end;

procedure TCadCliente.ConfiguraEnviaEmail;
begin

  FParametrosEmail.SMTPConta := 'claudio de figueiredo batista';
  FParametrosEmail.SMTPNomeExibicao := 'Claudio Figueiredo';
  FParametrosEmail.SMTPPassword := 'Awabi714520#!####';
  FParametrosEmail.SMTPUsername := 'claudiodefigueiredo@gmail.com';

  FParametrosEmail.SMTPHost := 'smtp.gmail.com';
  FParametrosEmail.SMTPPorta := 587;
  FParametrosEmail.SMTPAutenticacao := True; // requer autenticacao
  FParametrosEmail.SMTPSSL := True; // requer conexao segura
  FParametrosEmail.NomeAnexo:= 'CADASTRO.XML';

  // destinatarios separados por virgula
  FParametrosEmail.SMTPDestinatarios := 'claudiofigueiredo@gmail.com';
  enviarEmail;
  end;
procedure TCadCliente.Button6Click(Sender: TObject);
begin
//    AuthenticationType := atLogin;
   ClienteSMTP.Host := 'smtp.gmail.com';
   ClienteSMTP.IOHandler := SSLHandlerSMTP;
   ClienteSMTP.Password := 'senha#!####';
   ClienteSMTP.Port := 465;
   ClienteSMTP.Username := 'claudiodefigueiredo@gmail.com'; //n?o esque?a o @gmail.com!!

   SSLHandlerSMTP.SSLOptions.Method := sslvSSLv2;
   SSLHandlerSMTP.SSLOptions.Mode := sslmClient;

   IdMessage1.Body.Add('corpo da mensagem');
   IdMessage1.From.Address := 'claudiodefigueiredo@gmail.com'; //opcional
   IdMessage1.From.Name := 'Claudio de Figueiredo'; //opcional
   IdMessage1.Recipients.Add;
   IdMessage1.Recipients.Items[0].Address := 'claudiodefigueiredo@yahoo.com';
   IdMessage1.Recipients.Items[0].Name := 'claudiodefigueiredo@gmail.com'; //opcional
   IdMessage1.Subject := 'Envio de Cadastro';
  try
    ClienteSMTP.Connect();
    ClienteSMTP.Send(IdMessage1);
    ClienteSMTP.Disconnect;
  except
    ShowMessage('Falha no envio!');
    exit;
  end;
  ShowMessage('Mensagem enviada com sucesso!');
end;

procedure TCadCliente.BuscarCEP(sCep:String);
var
   Str,erro :String;
   lhttp :TIdHTTP;
   json: HCkJsonObject;
   success: Boolean;
   retorno,url:string;
   js: TlkJSONobject;

begin

  lhttp := TIdHTTP.Create;
  url := 'http://viacep.com.br/ws/'+ sCep +'/json/';
  Str := lhttp.get(url);
  memo1.Lines.Add(converter_utf8_ansi(str));

  try
     js := TlkJSON.ParseText(str) as TlkJSONobject;
     if (js.Count > 1) then begin
        EdtLogradouro.Text := VarToStr(js.Field['logradouro'].Value);
//        Memo1.Lines.Add( VarToStr(js.Field['cep'].Value));
        EdtBairro.Text := VarToStr(js.Field['bairro'].Value);
        EdtCidade.Text := VarToStr(js.Field['localidade'].Value);
        edtEstado.Text := VarToStr(js.Field['uf'].Value);
        edtcomplemento.Text := VarToStr(js.Field['complemento'].Value);
      end
      else begin
           Application.MessageBox( Pchar(sCep), 'CEP n?o encontrado', MB_OK);
      end;
  except
  on Exception do
   raise; // Exception.Create('CEP n?o encontrado');
  end;
  lhttp.Free;
  js.Free;
end;

procedure TCadCliente.btnBuscarCEPClick(Sender: TObject);
begin
   if ValidaCampos then
      BuscarCEP(SoNumero(edtCEP.text));
end;

function TCadCliente.ValidaCampos: boolean;
var
   Lista  :string;
begin
   Lista :='';

   if length(trim(edtCPF.text)) > 0 then begin
      if not validarCPF(edtCPF.text) then begin
         Lista := 'CPF Inv?lido';
      end;
   end;

  if length(trim(edtEmail.text)) > 0 then begin
      if not validarEmail(edtEmail.text) then begin
         Lista := 'Email Inv?lido';
      end;
  end;

   if length(trim(edtNome.text)) = 0 then begin
      Lista := 'Nome';
   end;

   if length(trim(edtIdentidade.text)) = 0 then  begin
      Lista := Lista +  #13 + 'Identidade';
   end;

   if length(trim(SoNumero(edtCEP.text))) <> 8 then  begin
      Lista := Lista +  #13 + 'CEP';
   end;


   if Lista='' then
      result := True
   else
   begin
      Application.MessageBox( Pchar(Lista), 'Campos obrigat?rios ou inv?lidos:', MB_OK);
      result := False;
   end;


end;

function TCadCliente.GravaXML: boolean;
begin

if not(cdsDados.Active) then
begin

  try
     cdsDados.CreateDataSet;
     cdsDados.EmptyDataSet;
     cdsDados.Open;
     cdsDados.edit;
     cdsDados.FieldByName('Nome').AsString:= edtNome.text;
     cdsDados.FieldByName('Identidade').AsString:= edtIdentidade.text;
     cdsDados.FieldByName('CPF').AsString:= edtCPF.text;
     cdsDados.FieldByName('Telefone').AsString:= edtTelefone.text;
     cdsDados.FieldByName('Email').AsString:= edtEmail.text;

     cdsDados.FieldByName('CEP').AsString:= edtCEP.text;
     cdsDados.FieldByName('Logradouro').AsString:= edtLogradouro.text;
     cdsDados.FieldByName('Numero').AsString:= edtNumero.text;
     cdsDados.FieldByName('Complemento').AsString:= edtComplemento.text;
     cdsDados.FieldByName('Bairro').AsString:= edtBairro.text;
     cdsDados.FieldByName('Cidade').AsString:= edtCidade.text;
     cdsDados.FieldByName('UF').AsString:= edtEstado.text;
     cdsDados.FieldByName('Pais').AsString:= edtPais.text;
     try
       cdsDados.post;
     except
          on E:Exception do begin // em caso de erro gera um log com a mensagem de erro
            ShowMessage('N?o foi poss?vel gravar ao XML: '+E.Message);
            result:=False;
          end;
     end;

  finally
     cdsDados.close;
     result:=True;
  end;
end;


end;

procedure TCadCliente.EnviarEmail();
var
  AutenticouSMTP: boolean;
begin
  if ClienteSMTP.Connected then
    try
      ClienteSMTP.Disconnect;
    except

   end;
  ClienteSMTP.Host := FParametrosEmail.SMTPHost; // atribui o host (pop.gmail.com)
  ClienteSMTP.Port := FParametrosEmail.SMTPPorta; // atribui a porta (465)

  if FParametrosEmail.SMTPAutenticacao then // se requer autenticacao
  begin
    ClienteSMTP.Username := FParametrosEmail.SMTPUsername; // atribui o nome do usuario
    ClienteSMTP.Password := FParametrosEmail.SMTPPassword; // atribui a senha
  end
  else
  begin // se n?o requer autenticacao
    ClienteSMTP.Username := ''; // limpa o usuario
    ClienteSMTP.Password := ''; // limpa a senha
  end;

   if FParametrosEmail.SMTPSSL then // se requer conexao segura
   begin
     ClienteSMTP.IOHandler := SSLHandlerSMTP; // vincula o manipulador de SMTP ao cliente SMTP
     ClienteSMTP.UseTLS := utUseImplicitTLS; // atribui ao cliente SMTP o suporte impl?cito a TLS
     SSLHandlerSMTP.SSLOptions.Method := sslvSSLv2;
     SSLHandlerSMTP.SSLOptions.Mode := sslmClient;
     SSLHandlerSMTP.Port := ClienteSMTP.Port; // atribui a porta ao manipulador (igual a do cliente FTP)
     SSLHandlerSMTP.Destination := ClienteSMTP.Host + ':' + IntToStr(ClienteSMTP.Port); // indica o destino da conex?o (pop.gmail.com:465)
     SSLHandlerSMTP.Host := ClienteSMTP.Host; // atribui o host (pop.gmail.com)
  end
  else
  begin // se n?o requer conexao segura
    ClienteSMTP.IOHandler := nil; // desvincula o manipulador de SMTP
    ClienteSMTP.UseTLS := utNoTLSSupport; // indica que nao ha suporte a TLS
  end;
AutenticouSMTP := False; // variavel para indicar se a autenticacao foi bem sucedida

  // cabecalho
  IdMessage1.Clear;
  IdMessage1.ContentType := 'text/html';
  IdMessage1.From.Address := FParametrosEmail.SMTPConta; // conta do remetente
  IdMessage1.From.Name := FParametrosEmail.SMTPNomeExibicao; // nome do remetente
  IdMessage1.Recipients.EMailAddresses := FParametrosEmail.SMTPDestinatarios; // destinatarios (separados por v?rgula! n?o ? ponto e v?rgula!)
  IdMessage1.Subject := 'Envio de email automatico'; // assunto

  // corpo
  IdMessage1.Body.Clear;
  IdMessage1.Body.Add('<html>');
  IdMessage1.Body.Add('    <body>');
  IdMessage1.Body.Add('        <h4>SISTEMA DE EMAIL AUTOMATICO</h4>');
  IdMessage1.Body.Add('        <font face="Verdana" size=2>');
  IdMessage1.Body.Add('        Confirma??o cadastral');
  IdMessage1.Body.Add('        <hr size=1 noshade>');
  IdMessage1.Body.Add('        <font face="Courier New" size=2>');
  IdMessage1.Body.Add('Foi enviado automaticamente um XML com as informa??es cadastrais');
  IdMessage1.Body.Add('        </font>');
  IdMessage1.Body.Add('        <b><font face="Tahoma" size=2 color="black">');
  IdMessage1.Body.Add('        <hr size=1 noshade>');
  IdMessage1.Body.Add('        EMITIDO AUTOMATICAMENTE PELO SISTEMA<br>');
  IdMessage1.Body.Add('        <font color="blue">');
  IdMessage1.Body.Add('        Favor nao responder');
  IdMessage1.Body.Add('        </font>');
  IdMessage1.Body.Add('        </font></b>');
  IdMessage1.Body.Add('    </body>');
  IdMessage1.Body.Add('</html>');

  // anexo
 TIdAttachmentFile.Create(IdMessage1.MessageParts, FParametrosEmail.NomeAnexo);


 // efetua a conexao ao servidor SMTP
  if not ClienteSMTP.Connected then
    try
      ClienteSMTP.Connect; // conecta ao SMTP
      if FParametrosEmail.SMTPAutenticacao then // se requer autenticacao
        AutenticouSMTP := ClienteSMTP.Authenticate // efetua a atenticacao e retorna o resultado para a vari?vel
      else // se nao requer autenticacao
        AutenticouSMTP := True; // assume que a conexao foi bem sucedida
    except
      on E:Exception do // em caso de erro gera um log com a mensagem de erro
        ShowMessage('N?o foi poss?vel conectar ao servidor SMTP: '+E.Message);
    end;

  // se a conexao foi bem sucedida, envia a mensagem
  if AutenticouSMTP and ClienteSMTP.Connected then
    ClienteSMTP.Send(IdMessage1);

  // depois de tudo pronto, desconecta do servidor SMTP
  if ClienteSMTP.Connected then
    ClienteSMTP.Disconnect;
end;
procedure TCadCliente.FormShow(Sender: TObject);
begin
  edtNome.SetFocus;
end;

procedure TCadCliente.btnSairClick(Sender: TObject);
begin
   close;
end;

end.
