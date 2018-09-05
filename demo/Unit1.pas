unit Unit1;

interface

uses     
  Wke,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WkeBrowser, ExtCtrls, StdCtrls, Menus;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Panel1: TPanel;
    WkeWebbrowser1: TWkeWebbrowser;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure WkeWebbrowser1TitleChanged(Sender: TObject; const ATitle: string);
    procedure WkeWebbrowser1URLChanged(Sender: TObject; const AURL: string);
    procedure N1Click(Sender: TObject);
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

procedure TForm1.N1Click(Sender: TObject);
begin
  ShowMessage('hello');
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
