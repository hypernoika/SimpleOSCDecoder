program SimpleOSCDecoderExample;

{$mode objfpc}{$H+}
{$DEFINE UNIX}
{$DEFINE UseCThreads}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads} //UseCThreads is undefined?
  cthreads,
  {$ENDIF}{$ENDIF}
  Forms, Interfaces,
  UFormMain in 'UFormMain.pas' {FormMain},
  UFormAbout in 'UFormAbout.pas' {FormAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SimpleOSCDecoder';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.Run;
end.