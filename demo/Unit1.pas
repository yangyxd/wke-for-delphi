unit Unit1;

interface

uses     
  Wke,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WkeBrowser, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    WkeWebbrowser1: TWkeWebbrowser;
    Edit1: TEdit;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure WkeWebbrowser1TitleChanged(Sender: TObject; const ATitle: string);
    procedure WkeWebbrowser1URLChanged(Sender: TObject; const AURL: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    WkeWebbrowser1.LoadURL(Edit1.Text);
end;

procedure TForm1.WkeWebbrowser1TitleChanged(Sender: TObject;
  const ATitle: string);
begin
  Caption := ATitle;
end;

procedure TForm1.WkeWebbrowser1URLChanged(Sender: TObject; const AURL: string);
begin
  Edit1.Text := AURL;
end;

end.
