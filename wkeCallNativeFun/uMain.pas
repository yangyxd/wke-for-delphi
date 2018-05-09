/// <summary>
/// Html调用Delphi本地方法 demo
/// by 研究 (QQ:71051699)
/// </summary>

unit uMain;

interface

uses
  WkeBrowser, Wke,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

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
function _Test1(p1, p2, es_: wkeJSState): wkeJSValue; //测试从Html传参数
function test: String;
function test1(msg: String): String;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

function _Test(p1, p2, es_: wkeJSState): wkeJSValue;
begin
  Result := es_.String_(test);
end;

function _Test1(p1, p2, es_: wkeJSState): wkeJSValue;
var
  _msg: String;
begin
  _msg := (es_.ArgToString(es_, 0));  // 获取从Html传入的参数
  Result := es_.String_(test1(_msg));
end;

function test: String;
var
  AMsg: string;
begin
  AMsg := '这是Delphi字符串!!!';
  // ShowMessage(AMsg);
  Result := AMsg;
end;

function test1(msg: String): String;
var
  AMsg: string;
begin
  AMsg := msg + ', 这是Delphi字符串!!!';
  Result := AMsg;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FWkeWebbrowser := TWkeWebbrowser.Create(Self);
  FWkeWebbrowser.Parent := Self;
  FWkeWebbrowser.Align := alClient;

  // 注册本地函数
  JScript.BindFunction('delphi_Test', @_Test, 1);
  JScript.BindFunction('delphi_Test1', @_Test1, 1);
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
