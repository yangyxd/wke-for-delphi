{*******************************************************}
{                                                       }
{       Wke Browser ��Ԫ                                }
{                                                       }
{       ��Ȩ���� (C) 2017   by YangYxd                  }
{                                                       }
{*******************************************************}

{
  ��Դ�������� ying32 ����Դ�Ĵ��������޸Ķ�����

  ��ӭ���� WebUI:miniblink/wke/cef/mshtml QQȺ: 178168957

}

unit WkeBrowser;

{$IF RTLVersion>=24}
{$LEGACYIFEND ON}
{$IFEND}

{$IF defined(FPC)}
  {$DEFINE USEINLINE}
{$IFEND}
{$IF RTLVersion>=18}
  {$DEFINE USEINLINE}
{$IFEND}

interface

uses
  Wke,
  Windows, Types, Messages, Classes, SysUtils, Controls, Dialogs, ExtCtrls;

type
  TTitleChangedEvent = procedure(Sender: TObject; const ATitle: string) of object;
  TURLChangedEvent = procedure(Sender: TObject; const AURL: string) of object;
  TPaintUpdatedEvent = procedure(Sender: TObject; DC: HDC; x, y, cx, cy: Integer) of object;
  TAlertBoxEvent = procedure(Sender: TObject; const AMsg: string) of object;
  TConfirmBoxEvent = procedure(Sender: TObject; const AMsg: string; var AResult: Boolean) of object;
  TPromptBoxEvent = procedure(Sender: TObject; const AMsg, ADefaultResult: string; var AResult: string; var AReturn: Boolean) of object;
  TNavigationEvent = procedure(Sender: TObject; ANavigationType: wkeNavigationType; const AURL: string; var AResult: Boolean) of object;
  TCreateViewEvent = procedure(Sender: TObject; ANavigationType: wkeNavigationType; const AURL: string; AWindowFeatures: PwkeWindowFeatures; var AResult: TwkeWebView) of object;
  TDocumentReadyEvent = procedure(Sender: TObject) of object;
  TLoadingFinishEvent = procedure(Sender: TObject; const AURL: string; AResult: wkeLoadingResult; const AFailedReason: string) of object;
  TWindowClosingEvent = procedure(Sender: TObject; var AResult: Boolean) of object;
  TConsoleMessageEvent= procedure(Sender: TObject; var AMessage: wkeConsoleMessage) of object;
  TDownloadEvent = procedure(Sender: TObject; const AURL: string) of object;

type
  // ��ʹ��rmDefaultʹ��ԭ�е�windows���ģʽ��rmDirect�Լ����Ƶ�dui�ؼ���
  TRenderMode = (rmDefault, rmDirect);

type
  /// <summary>
  /// Wke Web Browser
  /// </summary>
  TWkeWebbrowser = class(TWinControl)
  private
    FWebView: TWkeWebView;
    FTimer: TTimer;
    FUserAgent: string;
    FDefaultUrl: string;
    // FIsLayered: Boolean;
    // FNativeCtrl: CNativeControlUI;

    FOnDocumentReady: TDocumentReadyEvent;
    FOnLoadingFinish: TLoadingFinishEvent;
    FOnNavigation: TNavigationEvent;
    FOnWindowClosing: TWindowClosingEvent;
    FOnCreateView: TCreateViewEvent;
    FOnWindowDestroy: TNotifyEvent;
    FOnPaintUpdated: TPaintUpdatedEvent;
    FOnPromptBox: TPromptBoxEvent;
    FOnTitleChanged: TTitleChangedEvent;
    FOnAlertBox: TAlertBoxEvent;
    FOnConfirmBox: TConfirmBoxEvent;
    FOnURLChanged: TURLChangedEvent;
    FOnConsoleMessage: TConsoleMessageEvent;
    FOnDownload: TDownloadEvent;

    procedure SetUserAgent(const Value: string);
    procedure SetDefaultUrl(const Value: string);
//    procedure OnWebBrowserPaint(Sender: CControlUI; DC: HDC; const rcPaint: TRect);
  protected
    procedure DoDownload(const AURL: string); virtual;
    procedure DoTitleChanged(const ATitle: string); virtual;
    procedure DoURLChanged(const AURL: string); virtual;
    procedure DoPaintUpdated(DC: HDC; x, y, cx, cy: Integer); virtual;
    procedure DoAlertBox(const AMsg: string); virtual;
    function DoConfirmBox(const AMsg: string): Boolean; virtual;
    function DoPromptBox(const AMsg, ADefaultResult: string; var AResult: string): Boolean; virtual;
    function DoNavigation(ANavigationType: wkeNavigationType; const AURL: string): Boolean; virtual;
    function DoCreateView(ANavigationType: wkeNavigationType; const AURL: string; AWindowFeatures: PwkeWindowFeatures): wkeWebView; virtual;
    procedure DoDocumentReady; virtual;
    procedure DoLoadingFinish(const AURL: string; AResult: wkeLoadingResult; const AFailedReason: string); virtual;
    function DoWindowClosing: Boolean; virtual;
    procedure DoWindowDestroy; virtual;
    procedure DoConsoleMessage(var AMessage: wkeConsoleMessage); virtual;
    procedure DoTimer(Sender: TObject); 
    procedure InitWkeWebBrowser();
  protected   
    procedure Resize; override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure WndProc(var Msg: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Navigate(const AStr: string);
    procedure Load(const AStr: string);
    procedure LoadURL(const AURL: string);
    procedure LoadFile(const AFileName: string);
    procedure LoadHTML(const AHTML: string);
    procedure StopLoading;
    procedure Reload;

    function CanGoBack: Boolean;
    function GoBack: Boolean;
    function CanGoForward: Boolean;
    function GoForward: Boolean;

    procedure EditorSelectAll;
    procedure EditorCopy;
    procedure EditorCut;
    procedure EditorPaste;
    procedure EditorDelete;
    procedure SetFocus; override;
    procedure KillFocus; 
    
    function RunJS(const AScript: string): wkejsValue;
    function GlobalExec: wkeJSState;
    procedure Sleep;
    procedure Wake;
    function IsAwake: Boolean;
    procedure  MoveWindow;
    procedure RepaintAllNeeded();
    
  published
    property WebView: TWkeWebView read FWebView;
    property UserAgent: string read FUserAgent write SetUserAgent;
    property DefaultUrl: string read FDefaultUrl write SetDefaultUrl;

    property OnTitleChanged: TTitleChangedEvent read FOnTitleChanged write FOnTitleChanged;
    property OnURLChanged: TURLChangedEvent read FOnURLChanged write FOnURLChanged;
    property OnPaintUpdated: TPaintUpdatedEvent read FOnPaintUpdated write FOnPaintUpdated;
    property OnAlertBox: TAlertBoxEvent read FOnAlertBox write FOnAlertBox;
    property OnConfirmBox: TConfirmBoxEvent read FOnConfirmBox write FOnConfirmBox;
    property OnPromptBox: TPromptBoxEvent read FOnPromptBox write FOnPromptBox;
    property OnNavigation: TNavigationEvent read FOnNavigation write FOnNavigation;
    property OnCreateView: TCreateViewEvent read FOnCreateView write FOnCreateView;
    property OnDocumentReady: TDocumentReadyEvent read FOnDocumentReady write FOnDocumentReady;
    property OnLoadingFinish: TLoadingFinishEvent read FOnLoadingFinish write FOnLoadingFinish;
    property OnWindowClosing: TWindowClosingEvent read FOnWindowClosing write FOnWindowClosing;
    property OnWindowDestroy: TNotifyEvent read FOnWindowDestroy write FOnWindowDestroy;
    property OnConsoleMessage: TConsoleMessageEvent read FOnConsoleMessage write FOnConsoleMessage;
    property OnDownload: TDownloadEvent read FOnDownload write FOnDownload;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    {$IFDEF USEINLINE}
    property Padding;
    {$ENDIF}
    property ParentBiDiMode;
    property ParentBackground;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
       
    property OnCanResize;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;

    {$IFDEF USEINLINE}
    property OnMouseActivate;
    property OnMouseEnter;
    property OnMouseLeave;
    {$ENDIF}
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Additional', [TWkeWebbrowser]);
end;

procedure OnwkeTitleChangedCallback(webView: wkeWebView; param: Pointer; title: wkeString); cdecl;
begin
  TWkeWebbrowser(param).DoTitleChanged(webView.GetString(title));
end;

procedure OnwkeURLChangedCallback(webView: wkeWebView; param: Pointer; url: wkeString); cdecl;
begin
  TWkeWebbrowser(param).DoURLChanged(webView.GetString(url));
end;

procedure OnwkeDownloadCallback(webView: wkeWebView; param: Pointer; url: wkeString); cdecl;
begin
  TWkeWebbrowser(param).DoDownload(webView.GetString(url));
end;

procedure OnwkePaintUpdatedCallback(webView: wkeWebView; param: Pointer; DC: HDC;
   x: Integer; y: Integer; cx: Integer; cy: Integer); cdecl;
begin
//  TWkeWebbrowser(param).FWebView.MoveWindow(0,0,cx, cy);
//  TWkeWebbrowser(param).DoPaintUpdated(DC, x, y, cx, cy);
//  if TWkeWebbrowser(param).FIsLayered then
//    TWkeWebbrowser(param).FNativeCtrl.Invalidate;
end;

procedure OnwkeAlertBoxCallback(webView: wkeWebView; param: Pointer; msg: wkeString); cdecl;
begin
  TWkeWebbrowser(param).DoAlertBox(webView.GetString(msg));
end;

function OnwkeConfirmBoxCallback(webView: wkeWebView; param: Pointer; msg: wkeString): Boolean; cdecl;
begin
  Result := TWkeWebbrowser(param).DoConfirmBox(webView.GetString(msg));
end;

function OnwkePromptBoxCallback(webView: wkeWebView; param: Pointer; msg: wkeString;
  defaultResult: wkeString; AResult: wkeString): Boolean; cdecl;
var
  AValue: string;
begin
  AValue := webView.GetString(AResult);
  Result := TWkeWebbrowser(param).DoPromptBox(webView.GetString(msg),
    webView.GetString(defaultResult), AValue);
  if Result then
    webView.SetString(AResult, AValue);
end;

function OnwkeNavigationCallback(webView: wkeWebView; param: Pointer;
  navigationType: wkeNavigationType; url: wkeString): Boolean; cdecl;
begin
  Result := TWkeWebbrowser(param).DoNavigation(navigationType, webView.GetString(url));
end;

function OnwkeCreateViewCallback(webView: wkeWebView; param: Pointer; info: PwkeNewViewInfo): wkeWebView; cdecl;
begin
  Result := nil;
  //Result := TWkeWebbrowser(param).DoCreateView(navigationType, webView.GetString(url), windowFeatures);
end;

procedure OnwkeDocumentReadyCallback(webView: wkeWebView; param: Pointer); cdecl;
begin
  TWkeWebbrowser(param).DoDocumentReady;
end;

procedure OnwkeLoadingFinishCallback(webView: wkeWebView; param: Pointer; url: wkeString;
  result: wkeLoadingResult; failedReason: wkeString); cdecl;
begin
  TWkeWebbrowser(param).DoLoadingFinish(webView.GetString(url),
    result, webView.GetString(failedReason));
end;

function OnwkeWindowClosingCallback(webWindow: wkeWebView; param: Pointer): Boolean; cdecl;
begin
  Result := TWkeWebbrowser(param).DoWindowClosing;
end;

procedure OnwkeWindowDestroyCallback(webWindow: wkeWebView; param: Pointer); cdecl;
begin
  TWkeWebbrowser(param).DoWindowDestroy;
end;

procedure OnwkeConsoleMessageCallback(webView: wkeWebView; param: Pointer; var AMessage: wkeConsoleMessage); cdecl;
begin
  TWkeWebbrowser(param).DoConsoleMessage(AMessage);
end;

{ TWkeWebbrowser }

function TWkeWebbrowser.CanGoBack: Boolean;
begin
  if Assigned(FWebView) then
    Result := FWebView.CanGoBack
  else
    Result := False;
end;

function TWkeWebbrowser.CanGoForward: Boolean;
begin
  if Assigned(FWebView) then
    Result := FWebView.CanGoForward
  else
    Result := False;
end;

constructor TWkeWebbrowser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTimer := TTimer.Create(Self);
  FTimer.Interval := 45;
  FTimer.OnTimer := DoTimer;
end;

procedure TWkeWebbrowser.CreateWnd;
begin
  inherited CreateWnd;
  if HandleAllocated then begin
    InitWkeWebBrowser();
    FTimer.Enabled := Assigned(FWebView);
    if FDefaultUrl <> '' then begin
      LoadURL(FDefaultUrl);
    end;
  end;
end;

destructor TWkeWebbrowser.Destroy;
begin
  FWebView.SetOnWindowDestroy(nil, nil);
  inherited Destroy;
end;

procedure TWkeWebbrowser.DestroyWnd;
begin
  FTimer.Enabled := False;
  if Assigned(FWebView) then
    FWebView.DestroyWebWindow;
  inherited DestroyWnd;
end;

procedure TWkeWebbrowser.DoAlertBox(const AMsg: string);
begin
  if Assigned(FOnAlertBox) then
    FOnAlertBox(Self, AMsg)
  else
    MessageBox(Handle, PChar(AMsg), 'Alert', 64);
end;

function TWkeWebbrowser.DoConfirmBox(const AMsg: string): Boolean;
begin
  Result := True;
  if Assigned(FOnConfirmBox) then
    FOnConfirmBox(Self, AMsg, Result)
  else begin
    Result := MessageBox(Handle, PChar(AMsg), 'Confirm', 64+4) = 6;
  end;
end;

procedure TWkeWebbrowser.DoConsoleMessage(var AMessage: wkeConsoleMessage);
begin
  if Assigned(FOnConsoleMessage) then
    FOnConsoleMessage(Self, AMessage)
  else
    OutputDebugString(PChar(WebView.GetString(AMessage.Message_)));
end;

function TWkeWebbrowser.DoCreateView(ANavigationType: wkeNavigationType;
  const AURL: string; AWindowFeatures: PwkeWindowFeatures): wkeWebView;
begin
  Result := FWebView;
  if Assigned(FOnCreateView) then
    FOnCreateView(Self, ANavigationType, AURL, AWindowFeatures, Result);
end;

procedure TWkeWebbrowser.DoDocumentReady;
begin
  if Assigned(FOnDocumentReady) then
    FOnDocumentReady(Self);
end;

procedure TWkeWebbrowser.DoDownload(const AURL: string);
begin
  if Assigned(FOnDownload) then
    FOnDownload(Self, AURL);
end;

procedure TWkeWebbrowser.DoLoadingFinish(const AURL: string;
  AResult: wkeLoadingResult; const AFailedReason: string);
begin
  if Assigned(FOnLoadingFinish) then
    FOnLoadingFinish(Self, AURL, AResult, AFailedReason);
end;

function TWkeWebbrowser.DoNavigation(ANavigationType: wkeNavigationType;
  const AURL: string): Boolean;
begin
  Result := True;
  if Assigned(FOnNavigation) then
    FOnNavigation(Self, ANavigationType, AURL, Result);
end;

procedure TWkeWebbrowser.DoPaintUpdated(DC: HDC; x, y, cx, cy: Integer);
begin
  if Assigned(FOnPaintUpdated) then
    FOnPaintUpdated(Self, DC, x, y, cx, cy);
end;

function TWkeWebbrowser.DoPromptBox(const AMsg, ADefaultResult: string;
  var AResult: string): Boolean;
begin
  Result := True;
  if Assigned(FOnPromptBox) then
    FOnPromptBox(Self, AMsg, ADefaultResult, AResult, Result)
  else begin
    AResult := InputBox('������', AMsg, ADefaultResult);
    Result := ADefaultResult <> AResult;
  end;
end;

procedure TWkeWebbrowser.DoTimer(Sender: TObject);
begin
  if Visible and Assigned(FWebView) then  
    RepaintAllNeeded;
end;

procedure TWkeWebbrowser.DoTitleChanged(const ATitle: string);
begin
  if Assigned(FOnTitleChanged) then
    FOnTitleChanged(Self, ATitle);
end;

procedure TWkeWebbrowser.DoURLChanged(const AURL: string);
begin
  if Assigned(FOnURLChanged) then
    FOnURLChanged(Self, AURL);
end;

function TWkeWebbrowser.DoWindowClosing: Boolean;
begin
  Result := True;
  if Assigned(FOnWindowClosing) then
    FOnWindowClosing(Self, Result);
end;

procedure TWkeWebbrowser.DoWindowDestroy;
begin
  try
    if Assigned(FOnWindowDestroy) then
      FOnWindowDestroy(Self);
    Free;
  except
  end;
end;

procedure TWkeWebbrowser.EditorCopy;
begin
  if FWebView <> nil then
    FWebView.EditorCopy;
end;

procedure TWkeWebbrowser.EditorCut;
begin
  if FWebView <> nil then
    FWebView.EditorCut;
end;

procedure TWkeWebbrowser.EditorDelete;
begin
  if FWebView <> nil then
    FWebView.EditorDelete;
end;

procedure TWkeWebbrowser.EditorPaste;
begin
  if FWebView <> nil then
    FWebView.EditorPaste;
end;

procedure TWkeWebbrowser.EditorSelectAll;
begin
  if FWebView <> nil then
    FWebView.EditorSelectAll;
end;

function TWkeWebbrowser.GlobalExec: wkeJSState;
begin
  if FWebView <> nil then
    Result := FWebView.GlobalExec
  else
    Result := nil;
end;

function TWkeWebbrowser.GoBack: Boolean;
begin
  if FWebView <> nil then
    Result := FWebView.GoBack
  else
    Result := False;
end;

function TWkeWebbrowser.GoForward: Boolean;
begin
  if FWebView <> nil then
    Result := FWebView.GoForward
  else
    Result := False;
end;

procedure TWkeWebbrowser.InitWkeWebBrowser();
begin
  if not Assigned(wkeCreateWebWindow) then
    Exit;
  FWebView := wkeCreateWebWindow(WKE_WINDOW_TYPE_CONTROL, Handle, 0, 0, Width, Height);
  FWebView.SetOnTitleChanged(OnwkeTitleChangedCallback, Self);
  FWebView.SetOnURLChanged(OnwkeURLChangedCallback, Self);
  //FWebView.SetOnPaintUpdated(OnwkePaintUpdatedCallback, Self);
  FWebView.SetOnAlertBox(OnwkeAlertBoxCallback, Self);
  FWebView.SetOnConfirmBox(OnwkeConfirmBoxCallback, Self);
  FWebView.SetOnPromptBox(OnwkePromptBoxCallback, Self);
  FWebView.SetOnNavigation(OnwkeNavigationCallback, Self);
  //FWebView.SetOnCreateView(OnwkeCreateViewCallback, Self);
  FWebView.SetOnLoadingFinish(OnwkeLoadingFinishCallback, Self);
  FWebView.SetOnWindowClosing(OnwkeWindowClosingCallback, Self);
  FWebView.SetOnWindowDestroy(OnwkeWindowDestroyCallback, Self);
  //FWebView.SetOnDocumentReady(OnwkeDocumentReadyCallback, Self);
  FWebView.SetOnConsoleMessage(OnwkeConsoleMessageCallback, Self);
  //FWebView.SetOnDownload(OnwkeDownloadCallback, Self);
  //FWebView.DefaultHandler(0, 0, ClientWidth, ClientHeight);
end;

function TWkeWebbrowser.IsAwake: Boolean;
begin
  if FWebView <> nil then
    Result := FWebView.IsAwake
  else
    Result := False;
end;

procedure TWkeWebbrowser.KillFocus;
begin
  if FWebView <> nil then
    FWebView.KillFocus
end;

procedure TWkeWebbrowser.Load(const AStr: string);
begin
  if Assigned(FWebView) then
    FWebView.Load(AStr);
end;

procedure TWkeWebbrowser.LoadFile(const AFileName: string);
begin
  if Assigned(FWebView) then
    FWebView.LoadFile(AFileName);
end;

procedure TWkeWebbrowser.LoadHTML(const AHTML: string);
begin
  if Assigned(FWebView) then
    FWebView.LoadHTML(AHTML);
end;

procedure TWkeWebbrowser.LoadURL(const AURL: string);
begin
  if Assigned(FWebView) then begin
    try
      FWebView.LoadURL(AURL);
      FWebView.ShowWindow(True);
    except
    end;
  end;
end;

procedure TWkeWebbrowser.MoveWindow;
begin
  if Assigned(FWebView) then        
    FWebView.MoveWindow(0, 0, Width, Height);
end;

procedure TWkeWebbrowser.Navigate(const AStr: string);
begin
  Load(AStr);
end;

procedure TWkeWebbrowser.Reload;
begin
  if FWebView <> nil then
    FWebView.Reload;
end;

procedure TWkeWebbrowser.RepaintAllNeeded;
begin
  TWkeWebView.RepaintAllNeeded;
end;

procedure TWkeWebbrowser.Resize;
begin
  inherited Resize;
  MoveWindow;
end;

function TWkeWebbrowser.RunJS(const AScript: string): wkejsValue;
begin
  Result := 0;
  if FWebView <> nil then
    Result := FWebView.RunJS(AScript);
end;

procedure TWkeWebbrowser.SetDefaultUrl(const Value: string);
begin
  FDefaultUrl := Value;
end;

procedure TWkeWebbrowser.SetFocus;
begin
  inherited SetFocus;
  if FWebView <> nil then
    FWebView.SetFocus;
end;

procedure TWkeWebbrowser.SetUserAgent(const Value: string);
begin
  if FUserAgent <> Value then begin
    if Assigned(FWebView) then begin
      FUserAgent := Value;
      FWebView.UserAgent := FUserAgent;
    end;
  end;
end;

procedure TWkeWebbrowser.Sleep;
begin
  if FWebView <> nil then
    FWebView.Sleep;
end;

procedure TWkeWebbrowser.StopLoading;
begin
  if FWebView <> nil then
    FWebView.StopLoading;
end;

procedure TWkeWebbrowser.Wake;
begin
  if FWebView <> nil then
    FWebView.Wake;
end;

procedure TWkeWebbrowser.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  if Assigned(FWebView) then
    Message.Result := 0
  else
    inherited;
end;

procedure TWkeWebbrowser.WndProc(var Msg: TMessage);
begin
  case Msg.Msg of 
  WM_RBUTTONDOWN:
    begin
      if Assigned(PopupMenu) then 
        PopupMenu.Popup(TWMRButtonDown(Msg).XPos, TWMRButtonDown(Msg).YPos);
    end
  else
    inherited WndProc(Msg);
  end;
end;

initialization
  if Assigned(wkeInitialize) then begin
    try
      wkeInitialize;
    except
    end;
  end;

finalization
  if Assigned(wkeFinalize) then
    wkeFinalize;

end.
