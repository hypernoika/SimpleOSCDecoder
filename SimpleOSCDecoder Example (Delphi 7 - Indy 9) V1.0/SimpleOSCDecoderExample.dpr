program SimpleOSCDecoderExample;

uses
  Forms,
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
