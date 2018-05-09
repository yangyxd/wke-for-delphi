/// <summary>
/// Html调用Delphi本地方法 demo
/// by 研究 (QQ:71051699)
/// </summary>

unit uMain;

interface

uses
  WkeBrowser, Wke,
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs;

type
  TfrmMain = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FWkeWebbrowser: TWkeWebbrowser;
  public
    { Public declarations }
  end;

function _Test(p1, p2, es_: wkeJSState): wkeJSValue;
function test: String;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

function _Test(p1, p2, es_: wkeJSState): wkeJSValue;
begin
  Result := es_.String_(test);
end;

function test: String;
var
  AMsg: string;
begin
  AMsg := '这是Delphi字符串!!!';
  // ShowMessage(AMsg);
  Result := AMsg;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FWkeWebbrowser := TWkeWebbrowser.Create(Self);
  FWkeWebbrowser.Parent := Self;
  FWkeWebbrowser.Align := alClient;

  // 注册本地函数
  JScript.BindFunction('delphi_Test', @_Test, 1);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FWkeWebbrowser.Free;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  FWkeWebbrowser.Show;
  FWkeWebbrowser.LoadFile('index.html');
  FWkeWebbrowser.WebView.ShowWindow(True); // 注意: 如果没用使用过LoadURL方法,必须保证执行一次wke的ShowWindow方法!!!
end;

end.
