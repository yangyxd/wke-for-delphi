program Project1;

uses
  ExceptionLog,
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  {$IF RTLVersion>=18}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}
  Application.Initialize;
  {$IF RTLVersion>=18}
  Application.MainFormOnTaskbar := True;
  {$ENDIF}
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
