program Project1;

{$IF RTLVersion>=24}
{$LEGACYIFEND ON}
{$IFEND}

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  {$IF RTLVersion>=18}
  ReportMemoryLeaksOnShutdown := True;
  {$IFEND}
  Application.Initialize;
  {$IF RTLVersion>=18}
  Application.MainFormOnTaskbar := True;
  {$IFEND}
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
