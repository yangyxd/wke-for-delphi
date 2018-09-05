{*******************************************************}
{                                                       }
{       Wke Lib 单元                                    }
{                                                       }
{       版权所有 (C) 2017   by YangYxd                  }
{                                                       }
{*******************************************************}

{
  本源码由网友 ying32 所开源的代码整理修改而来。

  欢迎加入 WebUI:miniblink/wke/cef/mshtml QQ群: 178168957

}

unit Wke;

interface

{$IF RTLVersion>=24}
{$LEGACYIFEND ON}
{$IFEND}

{$IF defined(FPC)}
  {$DEFINE SupportInline}
{$IFEND}
{$IF RTLVersion>=18}
  {$DEFINE SupportInline}
{$IFEND}

{$WARNINGS OFF}

{.$DEFINE UseVcFastCall}

{$DEFINE UseMB2018}  // 使用2018年新的mb链接库dll如果异常，启用这个

uses
  Windows, Types, SysUtils;

const
  // wkeMouseFlags
  WKE_LBUTTON = $01;
  WKE_RBUTTON = $02;
  WKE_SHIFT   = $04;
  WKE_CONTROL = $08;
  WKE_MBUTTON = $10;
  
  // wkeKeyFlags
  WKE_EXTENDED = $0100;
  WKE_REPEAT   = $4000;
  
  // wkeMouseMsg
  WKE_MSG_MOUSEMOVE     = $0200;
  WKE_MSG_LBUTTONDOWN   = $0201;
  WKE_MSG_LBUTTONUP     = $0202;
  WKE_MSG_LBUTTONDBLCLK = $0203;
  WKE_MSG_RBUTTONDOWN   = $0204;
  WKE_MSG_RBUTTONUP     = $0205;
  WKE_MSG_RBUTTONDBLCLK = $0206;
  WKE_MSG_MBUTTONDOWN   = $0207;
  WKE_MSG_MBUTTONUP     = $0208;
  WKE_MSG_MBUTTONDBLCLK = $0209;
  WKE_MSG_MOUSEWHEEL    = $020A;

type
  UTF8 = AnsiChar;
  PUTF8 = PAnsiChar;
  WChar_T = WideChar;
  PWchar_T = PWideChar;

  wkeJSValue = Int64;
  PwkeJSValue = ^wkeJSValue;
  wkeString = Pointer;

  wkeWebView = class;
  JScript = class;

  wkeJSState = JScript;

  wkeProxyType = (
    WKE_PROXY_NONE,
    WKE_PROXY_HTTP,
    WKE_PROXY_SOCKS4,
    WKE_PROXY_SOCKS4A,
    WKE_PROXY_SOCKS5,
    WKE_PROXY_SOCKS5HOSTNAME
  );
  TwkeProxyType = wkeProxyType;

  wkeSettingMask = (
    WKE_SETTING_PROXY = 1
  );
  TwkeSettingMask = wkeSettingMask;

  wkeNavigationType = (
    WKE_NAVIGATION_TYPE_LINKCLICK,
    WKE_NAVIGATION_TYPE_FORMSUBMITTE,
    WKE_NAVIGATION_TYPE_BACKFORWARD,
    WKE_NAVIGATION_TYPE_RELOAD,
    WKE_NAVIGATION_TYPE_FORMRESUBMITT,
    WKE_NAVIGATION_TYPE_OTHER
  );
  TwkeNavigationType = wkeNavigationType;

  wkeLoadingResult = (
    WKE_LOADING_SUCCEEDED,
    WKE_LOADING_FAILED,
    WKE_LOADING_CANCELED
  );
  TwkeLoadingResult = wkeLoadingResult;

  wkeWindowType = (
    WKE_WINDOW_TYPE_POPUP,
    WKE_WINDOW_TYPE_TRANSPARENT,
    WKE_WINDOW_TYPE_CONTROL
  );
  TwkeWindowType = wkeWindowType;

  wkeJSType = (
    JSTYPE_NUMBER,
    JSTYPE_STRING,
    JSTYPE_BOOLEAN,
    JSTYPE_OBJECT,
    JSTYPE_FUNCTION,
    JSTYPE_UNDEFINED
  );
  TwkeJSType = wkeJSType;

  PwkeJsExceptionInfo = ^wkeJsExceptionInfo;
  wkeJsExceptionInfo = packed record
    Message: PUTF8;
    SourceLine: PUTF8;
    ScriptResourceName: PUTF8;
    LineNumber: Integer;
    StartPosition: Integer;
    EndPosition: Integer;
    StartColumn: Integer;
    EndColumn: Integer;
    CallStackString: PUTF8;
  end;

  wkeRect = packed record
    x: Integer;
    y: Integer;
    w: Integer;
    h: Integer;
  end;
  PwkeRect = ^TwkeRect;
  TwkeRect = wkeRect;

  wkeProxy = packed record
    AType: wkeProxyType;
    HostName: array[0..99] of AnsiChar;
    Port: Word;
    UserName: array[0..49] of AnsiChar;
    PassWord: array[0..49] of AnsiChar;
  end;
  PwkeProxy = ^TwkeProxy;
  TwkeProxy = wkeProxy;

  wkeSettings = packed record
    Proxy: wkeProxy;
    Mask: Longint;
  end;
  PwkeSettings = ^TwkeSettings;
  TwkeSettings = wkeSettings;

  wkeWindowFeatures = packed record
    X: Integer;
    Y: Integer;
    Width: Integer;
    Height: Integer;
    MenuBarVisible: Boolean;
    StatusBarVisible: Boolean;
    ToolBarVisible: Boolean;
    LocationBarVisible: Boolean;
    ScrollbarsVisible: Boolean;
    Resizable: Boolean;
    FullScreen: Boolean;
  end;
  PwkeWindowFeatures = ^TwkeWindowFeatures;
  TwkeWindowFeatures = wkeWindowFeatures;

  wkeMessageLevel = (
    WKE_MESSAGE_LEVEL_TIP,
    WKE_MESSAGE_LEVEL_LOG,
    WKE_MESSAGE_LEVEL_WARNING,
    WKE_MESSAGE_LEVEL_ERROR,
    WKE_MESSAGE_LEVEL_DEBUG
  );

  wkeMessageSource = (
    WKE_MESSAGE_SOURCE_HTML,
    WKE_MESSAGE_SOURCE_XML,
    WKE_MESSAGE_SOURCE_JS,
    WKE_MESSAGE_SOURCE_NETWORK,
    WKE_MESSAGE_SOURCE_CONSOLE_API,
    WKE_MESSAGE_SOURCE_OTHER
  );

  wkeMessageType = (
    WKE_MESSAGE_TYPE_LOG,
    WKE_MESSAGE_TYPE_DIR,
    WKE_MESSAGE_TYPE_DIR_XML,
    WKE_MESSAGE_TYPE_TRACE,
    WKE_MESSAGE_TYPE_START_GROUP,
    WKE_MESSAGE_TYPE_START_GROUP_COLLAPSED,
    WKE_MESSAGE_TYPE_END_GROUP,
    WKE_MESSAGE_TYPE_ASSERT
  );

  PwkeConsoleMessage = ^wkeConsoleMessage;
  wkeConsoleMessage = packed record
    Source: wkeMessageSource;
    Type_: wkeMessageType;
    Level: wkeMessageLevel;
    Message_: wkeString;
    Url: wkeString;
    LineNumber: LongInt;
  end;

  PwkeNewViewInfo = ^wkeNewViewInfo;
  wkeNewViewInfo = record
    NavigationType: wkeNavigationType;
    Url: wkeString;
    Target: wkeString;

    X: Integer;
    Y: Integer;
    Width: Integer;
    Height: Integer;
    MenuBarVisible: Boolean;
    StatusBarVisible: bool ;
    ToolBarVisible: Boolean;
    LocationBarVisible: Boolean;
    ScrollbarsVisible: Boolean;
    Resizable: Boolean;
    FullScreen: Boolean;
  end;
  TwkeNewViewInfo = wkeNewViewInfo;

  PwkeDocumentReadyInfo = ^wkeDocumentReadyInfo;
  wkeDocumentReadyInfo = record
    Url: wkeString;
    FrameJSState: wkeJSState;
    MainFrameJSState: wkeJSState;
  end;
  TwkeDocumentReadyInfo = wkeDocumentReadyInfo;

  {$IF not Declared(SIZE_T)}
  SIZE_T = Cardinal;
  {$IFEND}

  //typedef void* (*FILE_OPEN) (const char* path);
  FILE_OPEN = function(path: PAnsiChar): Pointer; cdecl;
  //typedef void (*FILE_CLOSE) (void* handle);
  FILE_CLOSE = procedure(handle: Pointer); cdecl;
  //typedef size_t (*FILE_SIZE) (void* handle);
  FILE_SIZE = function(handle: Pointer): size_t; cdecl;
  //typedef int (*FILE_READ) (void* handle, void* buffer, size_t size);
  FILE_READ = function(handle: Pointer; buffer: Pointer; size: size_t): Integer; cdecl;
  //typedef int (*FILE_SEEK) (void* handle, int offset, int origin);
  FILE_SEEK = function(handle: Pointer; offset, origin: Integer): Integer; cdecl;

  //typedef void (*wkeTitleChangedCallback)(wkeWebView webView, void* param, const wkeString title);
  //typedef void (*wkeURLChangedCallback)(wkeWebView webView, void* param, const wkeString url);
  //typedef void (*wkePaintUpdatedCallback)(wkeWebView webView, void* param, const HDC hdc, int x, int y, int cx, int cy);
  //typedef void (*wkeAlertBoxCallback)(wkeWebView webView, void* param, const wkeString msg);
  //typedef bool (*wkeConfirmBoxCallback)(wkeWebView webView, void* param, const wkeString msg);
  //typedef bool (*wkePromptBoxCallback)(wkeWebView webView, void* param, const wkeString msg, const wkeString defaultResult, wkeString result);
  //typedef bool (*wkeNavigationCallback)(wkeWebView webView, void* param, wkeNavigationType navigationType, const wkeString url);
  //typedef wkeWebView (*wkeCreateViewCallback)(wkeWebView webView, void* param, wkeNavigationType navigationType, const wkeString url, const wkeWindowFeatures* windowFeatures);
  //typedef void (*wkeDocumentReadyCallback)(wkeWebView webView, void* param);
  //typedef void (*wkeLoadingFinishCallback)(wkeWebView webView, void* param, const wkeString url, wkeLoadingResult result, const wkeString failedReason);
  //typedef bool (*wkeWindowClosingCallback)(wkeWebView webWindow, void* param);
  //typedef void (*wkeWindowDestroyCallback)(wkeWebView webWindow, void* param);
  wkeTitleChangedCallback = procedure(webView: wkeWebView; param: Pointer; title: wkeString); cdecl;
  wkeURLChangedCallback = procedure(webView: wkeWebView; param: Pointer; url: wkeString); cdecl;
  wkePaintUpdatedCallback = procedure(webView: wkeWebView; param: Pointer; hdc: HDC; x: Integer; y: Integer; cx: Integer; cy: Integer); cdecl;
  wkeAlertBoxCallback = procedure(webView: wkeWebView; param: Pointer; msg: wkeString); cdecl;
  wkeConfirmBoxCallback = function(webView: wkeWebView; param: Pointer; msg: wkeString): Boolean; cdecl;
  wkePromptBoxCallback = function(webView: wkeWebView; param: Pointer; msg: wkeString; defaultResult: wkeString; result: wkeString): Boolean; cdecl;
  wkeNavigationCallback = function(webView: wkeWebView; param: Pointer; navigationType: wkeNavigationType; url: wkeString): Boolean; cdecl;
  wkeCreateViewCallback = function(webView: wkeWebView; param: Pointer; info: PwkeNewViewInfo): wkeWebView; cdecl;

  wkeDocumentReadyCallback = procedure(webView: wkeWebView; param: Pointer; info: PwkeDocumentReadyInfo); cdecl;
  wkeLoadingFinishCallback = procedure(webView: wkeWebView; param: Pointer; url: wkeString; result: wkeLoadingResult; failedReason: wkeString); cdecl;
  wkeWindowClosingCallback = function(webWindow: wkeWebView; param: Pointer): Boolean; cdecl;
  wkeWindowDestroyCallback = procedure(webWindow: wkeWebView; param: Pointer); cdecl;
  wkeDownloadCallback = procedure(webWindow: wkeWebView; param: Pointer; url: wkeString); cdecl;
  
  //typedef void (*wkeConsoleMessageCallback)(wkeWebView webView, void* param, const wkeConsoleMessage* message);
  wkeConsoleMessageCallback = procedure(webView: wkeWebView; param: Pointer; var AMessage: wkeConsoleMessage); cdecl;


  PwkeJSData = ^TwkeJSData;

  //typedef jsValue (*wkeJSGetPropertyCallback)(jsExecState es, jsValue object, const char* propertyName);
  wkeJSGetPropertyCallback = function(es: wkeJSState; AObject: wkeJSValue; propertyName: PAnsiChar): wkeJSValue; cdecl;
  //typedef bool (*wkeJSSetPropertyCallback)(jsExecState es, jsValue object, const char* propertyName, jsValue value);
  wkeJSSetPropertyCallback = function(es: wkeJSState; AObject: wkeJSValue; propertyName: PAnsiChar; value: wkeJSValue): Boolean; cdecl;
  //typedef jsValue (*wkeJSCallAsFunctionCallback)(jsExecState es, jsValue object, jsValue* args, int argCount);
  wkeJSCallAsFunctionCallback = function(es: wkeJSState; AObject: wkeJSValue; args: PwkeJSValue; argCount: Integer): wkeJSValue; cdecl;
  //typedef void (*wkeJSFinalizeCallback)(struct tagjsData* data);
  wkeJSFinalizeCallback = procedure(data: PwkeJSData); cdecl;

  wkeJSData = packed record
    typeName: array[0..99] of AnsiChar; //char
    propertyGet: wkeJSGetPropertyCallback;
    propertySet: wkeJSSetPropertyCallback;
    finalize: wkeJSFinalizeCallback;
    callAsFunction: wkeJSCallAsFunctionCallback;
  end;
  TwkeJSData = wkeJSData;

  //#define JS_CALL __fastcall
  //typedef jsValue (JS_CALL *jsNativeFunction) (jsExecState es);
  // 这里有两种写法，按照vc __fastcall的约定与delphi register约定的不一样
  {$IFDEF UseVcFastCall}
  jsNativeFunction = function(es: wkeJSState): wkeJSValue; cdecl; 
  {$ELSE}
  //jsNativeFunction = function(p1, p2, es: wkeJSState): wkeJSValue;  // 前两个参数用来占位用
  jsNativeFunction = function(p1, p2, es: wkeJSState): wkeJSValue; cdecl;
  {$ENDIF}

  /// <summary>
  /// WKE WebView
  /// </summary>
  wkeWebView = class
  private
    class function GetVersion: Integer;
    class function GetVersionString: string;
    function GetName: string;
    procedure SetName(const AName: string);
    function IsTransparent: Boolean;
    procedure SetTransparent(ATransparent: Boolean);
    procedure SetUserAgent(const AUserAgent: string);
    function IsLoadingSucceeded: Boolean;
    function IsLoadingFailed: Boolean;
    function IsLoadingCompleted: Boolean;
    function IsDocumentReady: Boolean;
    function GetTitle: string;
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetContentWidth: Integer;
    function GetContentHeight: Integer;
    procedure SetDirty(dirty: Boolean);
    function IsDirty: Boolean;
    function GetViewDC: HDC;
    function GetCookie: string;
    procedure SetCookieEnabled(enable: Boolean);
    function IsCookieEnabled: Boolean;
    procedure SetMediaVolume(volume: Single);
    function GetMediaVolume: Single;
    function GetCaretRect: wkeRect;
    procedure SetZoomFactor(factor: Single);
    function GetZoomFactor: Single;
    procedure SetEditable(editable: Boolean);
    function GetWindowHandle: HWND;
    procedure SetWindowTitle(const ATitle: string);
  public
    class procedure Initialize;
    class procedure InitializeEx(settings: PwkeSettings);
    class procedure Configure(settings: PwkeSettings);
    class procedure Finalize;
    class procedure Update;
    class procedure SetFileSystem(pfn_open: FILE_OPEN; pfn_close: FILE_CLOSE; pfn_size: FILE_SIZE; pfn_read: FILE_READ; pfn_seek: FILE_SEEK);
    class function CreateWebView: wkeWebView;
    class function CreateWebWindow(AType: wkeWindowType; parent: HWND; x: Integer; y: Integer; width: Integer; height: Integer): wkeWebView;
    class function RepaintAllNeeded: Boolean;
    class function RunMessageLoop(var quit: Boolean): Boolean;

    procedure DestroyWebWindow;
    procedure DestroyWebView;
    procedure LoadURL(const AURL: string);
    procedure PostURL(const AURL, APostData: string; PostLen: Integer);
    procedure LoadHTML(const AHTML: string);
    procedure LoadFile(const AFileName: string);
    procedure Load(const AStr: string);
    procedure StopLoading;
    procedure Reload;
    procedure Resize(w: Integer; h: Integer);
    procedure AddDirtyArea(x: Integer; y: Integer; w: Integer; h: Integer);
    procedure LayoutIfNeeded;
    procedure Paint(bits: Pointer; bufWid: Integer; bufHei: Integer; xDst: Integer; yDst: Integer; w: Integer; h: Integer; xSrc: Integer; ySrc: Integer; bCopyAlpha: Boolean);
    procedure Paint2(bits: Pointer; pitch: Integer);
    procedure RepaintIfNeeded;
    function CanGoBack: Boolean;
    function GoBack: Boolean;
    function CanGoForward: Boolean;
    function GoForward: Boolean;
    procedure EditorSelectAll;
    procedure EditorCopy;
    procedure EditorCut;
    procedure EditorPaste;
    procedure EditorDelete;
    function FireMouseEvent(AMessage: LongInt; x: Integer; y: Integer; flags: LongInt): Boolean;
    function FireContextMenuEvent(x: Integer; y: Integer; flags: LongInt): Boolean;
    function FireMouseWheelEvent(x: Integer; y: Integer; delta: Integer; flags: LongInt): Boolean;
    function FireKeyUpEvent(virtualKeyCode: LongInt; flags: LongInt; systemKey: Boolean): Boolean;
    function FireKeyDownEvent(virtualKeyCode: LongInt; flags: LongInt; systemKey: Boolean): Boolean;
    function FireKeyPressEvent(charCode: LongInt; flags: LongInt; systemKey: Boolean): Boolean;
    procedure SetFocus;
    procedure KillFocus;
    function RunJS(const AScript: string): wkeJSValue;
    function GlobalExec: wkeJSState;
    procedure Sleep;
    procedure Wake;

    function GetWebView(name: AnsiString): wkeWebView;
    function IsLoading(webView: wkeWebView): Boolean;

    procedure SetHostWindow(hostWindow: HWND);
    function GetHostWindow: HWND;
    procedure SetRepaintInterval(ms: Integer);
    function GetRepaintInterval: Integer;
    function RepaintIfNeededAfterInterval: Boolean;


    function IsAwake: Boolean;
    class function GetString(AString: wkeString): string;
    class procedure SetString(AString: wkeString; const AStr: string);
    procedure SetOnTitleChanged(callback: wkeTitleChangedCallback; callbackParam: Pointer);
    procedure SetOnURLChanged(callback: wkeURLChangedCallback; callbackParam: Pointer);
    procedure SetOnPaintUpdated(callback: wkePaintUpdatedCallback; callbackParam: Pointer);
    procedure SetOnAlertBox(callback: wkeAlertBoxCallback; callbackParam: Pointer);
    procedure SetOnConfirmBox(callback: wkeConfirmBoxCallback; callbackParam: Pointer);
    procedure SetOnPromptBox(callback: wkePromptBoxCallback; callbackParam: Pointer);
    procedure SetOnNavigation(callback: wkeNavigationCallback; param: Pointer);
    procedure SetOnCreateView(callback: wkeCreateViewCallback; param: Pointer);
    procedure SetOnConsoleMessage(callback: wkeConsoleMessageCallback; callbackParam: Pointer);
    procedure SetOnDocumentReady(callback: wkeDocumentReadyCallback; param: Pointer);
    procedure SetOnLoadingFinish(callback: wkeLoadingFinishCallback; param: Pointer);
    procedure SetOnWindowClosing(callback: wkeWindowClosingCallback; param: Pointer);
    procedure SetOnWindowDestroy(callback: wkeWindowDestroyCallback; param: Pointer);
    procedure SetOnDownload(callback: wkeDownloadCallback; param: Pointer);
    procedure ShowWindow(show: Boolean);
    procedure EnableWindow(enable: Boolean);
    procedure MoveWindow(x: Integer; y: Integer; width: Integer; height: Integer);
    procedure MoveToCenter;
    procedure ResizeWindow(width: Integer; height: Integer);
  public
    property Name: string read GetName write SetName;
    property Version: Integer read GetVersion;
    property VersionString: string read GetVersionString;
    property Transparent:Boolean read IsTransparent write SetTransparent;
    property UserAgent: string write SetUserAgent;
    property LoadingSucceeded: Boolean read IsLoadingSucceeded;
    property LoadingFailed: Boolean read IsLoadingFailed;
    property LoadingCompleted: Boolean read IsLoadingCompleted;
    property DocumentReady: Boolean read IsDocumentReady;
    property Title: string read GetTitle;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
    property ContentWidth: Integer read GetContentWidth;
    property ContentHeight: Integer read GetContentHeight;
    property Dirty: Boolean read IsDirty write SetDirty;
    property ViewDC: HDC read GetViewDC;
    property Cookie: string read GetCookie;
    property CookieEnabled: Boolean read IsCookieEnabled write SetCookieEnabled;
    property MediaVolume: Single read GetMediaVolume write SetMediaVolume;
    property CaretRect: wkeRect read GetCaretRect;
    property ZoomFactor: Single read GetZoomFactor write SetZoomFactor;
    property Editable: Boolean write SetEditable;
    property WindowHandle: HWND read GetWindowHandle;
    property WindowTitle: string write SetWindowTitle;
  end;
  TWkeWebView = wkeWebView;

  JScript = class
  public
    class procedure BindFunction(const AName: string; fn: jsNativeFunction; AArgCount: LongInt);{$IFDEF SupportInline}inline;{$ENDIF}
    class procedure BindGetter(const AName: string; fn: jsNativeFunction); {$IFDEF SupportInline}inline;{$ENDIF}
    class procedure BindSetter(const AName: string; fn: jsNativeFunction); {$IFDEF SupportInline}inline;{$ENDIF}
    function ArgCount: Integer; {$IFDEF SupportInline}inline;{$ENDIF}
    function ArgType(argIdx: Integer): wkeJSType; {$IFDEF SupportInline}inline;{$ENDIF}
    function Arg(argIdx: Integer): wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function TypeOf(v: wkeJSValue): wkeJSType; {$IFDEF SupportInline}inline;{$ENDIF}
    function IsNumber(v: wkeJSValue): Boolean; {$IFDEF SupportInline}inline;{$ENDIF}
    function IsString(v: wkeJSValue): Boolean; {$IFDEF SupportInline}inline;{$ENDIF}
    function IsBoolean(v: wkeJSValue): Boolean; {$IFDEF SupportInline}inline;{$ENDIF}
    function IsObject(v: wkeJSValue): Boolean; {$IFDEF SupportInline}inline;{$ENDIF}
    function IsFunction(v: wkeJSValue): Boolean; {$IFDEF SupportInline}inline;{$ENDIF}
    function IsUndefined(v: wkeJSValue): Boolean; {$IFDEF SupportInline}inline;{$ENDIF}
    function IsNull(v: wkeJSValue): Boolean; {$IFDEF SupportInline}inline;{$ENDIF}
    function IsArray(v: wkeJSValue): Boolean; {$IFDEF SupportInline}inline;{$ENDIF}
    function IsTrue(v: wkeJSValue): Boolean; {$IFDEF SupportInline}inline;{$ENDIF}
    function IsFalse(v: wkeJSValue): Boolean; {$IFDEF SupportInline}inline;{$ENDIF}
    function ToInt(v: wkeJSValue): Integer; {$IFDEF SupportInline}inline;{$ENDIF}
    function ToFloat(v: wkeJSValue): Single; {$IFDEF SupportInline}inline;{$ENDIF}
    function ToDouble(v: wkeJSValue): Double; {$IFDEF SupportInline}inline;{$ENDIF}
    function ToBoolean(v: wkeJSValue): Boolean; {$IFDEF SupportInline}inline;{$ENDIF}
    function ToTempString(v: wkeJSValue): string; {$IFDEF SupportInline}inline;{$ENDIF}
    function Int(n: Integer): wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function Float(f: Single): wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function Double(d: Double): wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function Boolean(b: Boolean): wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function Undefined: wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function Null: wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function True_: wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function False_: wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function String_(const AStr: string): wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function EmptyObject: wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function EmptyArray: wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function Object_(obj: PwkeJSData): wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function Function_(obj: PwkeJSData): wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function GetData(AObject: wkeJSValue): PwkeJSData; {$IFDEF SupportInline}inline;{$ENDIF}
    function Get(AObject: wkeJSValue; const prop: string): wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    procedure Set_(AObject: wkeJSValue; const prop: string; v: wkeJSValue); {$IFDEF SupportInline}inline;{$ENDIF}
    function GetAt(AObject: wkeJSValue; index: Integer): wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    procedure SetAt(AObject: wkeJSValue; index: Integer; v: wkeJSValue); {$IFDEF SupportInline}inline;{$ENDIF}
    function GetLength(AObject: wkeJSValue): Integer; {$IFDEF SupportInline}inline;{$ENDIF}
    procedure SetLength(AObject: wkeJSValue; length: Integer); {$IFDEF SupportInline}inline;{$ENDIF}
    function GlobalObject: wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function GetWebView: wkeWebView; {$IFDEF SupportInline}inline;{$ENDIF}
    function Eval(const AStr: string): wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function Call(func: wkeJSValue; thisObject: wkeJSValue; args: PwkeJSValue; argCount: Integer): wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function CallGlobal(func: wkeJSValue; args: PwkeJSValue; argCount: Integer): wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    function GetGlobal(const prop: string): wkeJSValue; {$IFDEF SupportInline}inline;{$ENDIF}
    procedure SetGlobal(const prop: string; v: wkeJSValue); {$IFDEF SupportInline}inline;{$ENDIF}
    procedure AddRef(v: wkeJSValue); {$IFDEF SupportInline}inline;{$ENDIF}
    procedure ReleaseRef(v: wkeJSValue); {$IFDEF SupportInline}inline;{$ENDIF}
    procedure CollectGarbge; {$IFDEF SupportInline}inline;{$ENDIF}
    class function ArgToString(const wke: JScript; argIdx: Integer): string;
    
    class procedure ClearJsValue(es: wkeJSState; var v: wkeJSValue);
    class procedure SetJsValue(es: wkeJSState; var v: wkeJSValue; const Value: string); overload;
    class procedure SetJsValue(es: wkeJSState; var v: wkeJSValue; const Value: Double); overload;
    class procedure SetJsValue(es: wkeJSState; var v: wkeJSValue; const Value: Int64); overload;
    class procedure SetJsValue(es: wkeJSState; var v: wkeJSValue; const Value: Boolean); overload;
  end;

{$IFDEF UseVcFastCall}
procedure ProcessVcFastCall;
{$ENDIF UseVcFastCall}

// 初始化 WKE
function InitWke(const DllName: string = 'wke.dll'): Boolean;
// 反初始化
procedure UninitWke();

var
//================================wkeWebView============================
  wkeInitialize: procedure(); cdecl;
  wkeInitializeEx: procedure(settings: PwkeSettings); cdecl;
  wkeConfigure: procedure(settings: PwkeSettings); cdecl;
  wkeFinalize: procedure(); cdecl;
  wkeUpdate: procedure(); cdecl;
  wkeGetVersion: function(): Integer; cdecl;
  wkeGetVersionString: function(): putf8; cdecl;
  wkeSetFileSystem: procedure(pfn_open: FILE_OPEN; pfn_close: FILE_CLOSE; pfn_size: FILE_SIZE; pfn_read: FILE_READ; pfn_seek: FILE_SEEK); cdecl;
  wkeCreateWebView: function(): wkeWebView; cdecl;
  wkeGetWebView: function (name: PAnsiChar): wkeWebView; cdecl;
  wkeDestroyWebView: procedure(webView: wkeWebView); cdecl;
  wkeGetName: function (webView: wkeWebView): PAnsiChar; cdecl;
  wkeSetName: procedure(webView: wkeWebView; name: PAnsiChar); cdecl;
  wkeIsTransparent: function (webView: wkeWebView): Boolean; cdecl;
  wkeSetTransparent: procedure(webView: wkeWebView; transparent: Boolean); cdecl;
  wkeSetUserAgent: procedure(webView: wkeWebView; userAgent: Putf8); cdecl;
  wkeSetUserAgentW: procedure(webView: wkeWebView; userAgent: Pwchar_t); cdecl;
  wkeLoadURL: procedure(webView: wkeWebView; url: Putf8); cdecl;
  wkeLoadURLW: procedure(webView: wkeWebView; url: Pwchar_t); cdecl;
  wkePostURL: procedure(wkeView: wkeWebView; url: Putf8; postData: PAnsiChar; postLen: Integer); cdecl;
  wkePostURLW: procedure(wkeView: wkeWebView; url: Pwchar_t; postData: PAnsiChar; postLen: Integer); cdecl;
  wkeLoadHTML: procedure(webView: wkeWebView; html: Putf8); cdecl;
  wkeLoadHTMLW: procedure(webView: wkeWebView; html: Pwchar_t); cdecl;
  wkeLoadFile: procedure(webView: wkeWebView; filename: Putf8); cdecl;
  wkeLoadFileW: procedure(webView: wkeWebView; filename: Pwchar_t); cdecl;
  wkeLoad: procedure(webView: wkeWebView; str: Putf8); cdecl;
  wkeLoadW: procedure(webView: wkeWebView; str: Pwchar_t); cdecl;
  wkeIsLoading: function (webView: wkeWebView): Boolean; cdecl;
  wkeIsLoadingSucceeded: function (webView: wkeWebView): Boolean; cdecl;
  wkeIsLoadingFailed: function (webView: wkeWebView): Boolean; cdecl;
  wkeIsLoadingCompleted: function (webView: wkeWebView): Boolean; cdecl;
  wkeIsDocumentReady: function (webView: wkeWebView): Boolean; cdecl;
  wkeStopLoading: procedure(webView: wkeWebView); cdecl;
  wkeReload: procedure(webView: wkeWebView); cdecl;
  wkeGetTitle: function (webView: wkeWebView): putf8; cdecl;
  wkeGetTitleW: function (webView: wkeWebView): pwchar_t; cdecl;
  wkeResize: procedure(webView: wkeWebView; w: Integer; h: Integer); cdecl;
  wkeGetWidth: function (webView: wkeWebView): Integer; cdecl;
  wkeGetHeight: function (webView: wkeWebView): Integer; cdecl;
  wkeGetContentWidth: function (webView: wkeWebView): Integer; cdecl;
  wkeGetContentHeight: function (webView: wkeWebView): Integer; cdecl;
  wkeSetDirty: procedure(webView: wkeWebView; dirty: Boolean); cdecl;
  wkeIsDirty: function (webView: wkeWebView): Boolean; cdecl;
  wkeAddDirtyArea: procedure(webView: wkeWebView; x: Integer; y: Integer; w: Integer; h: Integer); cdecl;
  wkeAddPluginDirectory:procedure(webView:wkeWebView; const path:PWideChar);cdecl;
  wkeLayoutIfNeeded: procedure(webView: wkeWebView); cdecl;
  wkePaint: procedure(webView: wkeWebView; bits: Pointer; bufWid: Integer; bufHei: Integer; xDst: Integer; yDst: Integer; w: Integer; h: Integer; xSrc: Integer; ySrc: Integer; bCopyAlpha: Boolean); cdecl;
  wkePaint2: procedure(webView: wkeWebView; bits: Pointer; pitch: Integer); cdecl;
  wkeRepaintIfNeeded: procedure(webView: wkeWebView); cdecl;
  wkeGetViewDC: function (webView: wkeWebView): HDC; cdecl;

  wkeSetRepaintInterval: procedure(webView: wkeWebView; ms: Integer); cdecl;
  wkeGetRepaintInterval: function (webView: wkeWebView): Integer; cdecl;
  wkeRepaintIfNeededAfterInterval: function (webView: wkeWebView): Boolean; cdecl;
  wkeRepaintAllNeeded: function(): Boolean; cdecl;
  wkeRunMessageLoop: function (var quit: Boolean): Boolean; cdecl;

  wkeCanGoBack: function (webView: wkeWebView): Boolean; cdecl;
  wkeGoBack: function (webView: wkeWebView): Boolean; cdecl;
  wkeCanGoForward: function (webView: wkeWebView): Boolean; cdecl;
  wkeGoForward: function (webView: wkeWebView): Boolean; cdecl;
  wkeEditorSelectAll: procedure(webView: wkeWebView); cdecl;
  wkeEditorCopy: procedure(webView: wkeWebView); cdecl;
  wkeEditorCut: procedure(webView: wkeWebView); cdecl;
  wkeEditorPaste: procedure(webView: wkeWebView); cdecl;
  wkeEditorDelete: procedure(webView: wkeWebView); cdecl;
  wkeGetCookieW: function (webView: wkeWebView): pwchar_t; cdecl;
  wkeGetCookie: function (webView: wkeWebView): putf8; cdecl;
  wkeSetCookieEnabled: procedure(webView: wkeWebView; enable: Boolean); cdecl;
  wkeIsCookieEnabled: function (webView: wkeWebView): Boolean; cdecl;
  wkeSetMediaVolume: procedure(webView: wkeWebView; volume: Single); cdecl;
  wkeGetMediaVolume: function (webView: wkeWebView): Single; cdecl;
  wkeFireMouseEvent: function (webView: wkeWebView; AMessage: LongInt; x: Integer; y: Integer; flags: LongInt): Boolean; cdecl;
  wkeFireContextMenuEvent: function (webView: wkeWebView; x: Integer; y: Integer; flags: LongInt): Boolean; cdecl;
  wkeFireMouseWheelEvent: function (webView: wkeWebView; x: Integer; y: Integer; delta: Integer; flags: LongInt): Boolean; cdecl;
  wkeFireKeyUpEvent: function (webView: wkeWebView; virtualKeyCode: LongInt; flags: LongInt; systemKey: Boolean): Boolean; cdecl;
  wkeFireKeyDownEvent: function (webView: wkeWebView; virtualKeyCode: LongInt; flags: LongInt; systemKey: Boolean): Boolean; cdecl;
  wkeFireKeyPressEvent: function (webView: wkeWebView; charCode: LongInt; flags: LongInt; systemKey: Boolean): Boolean; cdecl;
  wkeSetFocus: procedure(webView: wkeWebView); cdecl;
  wkeKillFocus: procedure(webView: wkeWebView); cdecl;
  wkeGetCaretRect: function (webView: wkeWebView): wkeRect; cdecl;
  wkeRunJS: function (webView: wkeWebView; script: Putf8): wkeJSValue; cdecl;
  wkeRunJSW: function (webView: wkeWebView; script: Pwchar_t): wkeJSValue; cdecl;
  wkeGlobalExec: function (webView: wkeWebView): wkeJSState; cdecl;
  wkeSleep: procedure(webView: wkeWebView); cdecl;
  wkeWake: procedure(webView: wkeWebView); cdecl;
  wkeIsAwake: function (webView: wkeWebView): Boolean; cdecl;
  wkeSetZoomFactor: procedure(webView: wkeWebView; factor: Single); cdecl;
  wkeGetZoomFactor: function (webView: wkeWebView): Single; cdecl;
  wkeSetEditable: procedure(webView: wkeWebView; editable: Boolean); cdecl;
  wkeGetString: function (AString: wkeString): putf8; cdecl;
  wkeGetStringW: function (AString: wkeString): pwchar_t; cdecl;
  wkeSetString: procedure(AString: wkeString; str: Putf8; len: size_t); cdecl;
  wkeSetStringW: procedure(AString: wkeString; str: Pwchar_t; len: size_t); cdecl;
  wkeOnTitleChanged: procedure(webView: wkeWebView; callback: wkeTitleChangedCallback; callbackParam: Pointer); cdecl;
  wkeOnURLChanged: procedure(webView: wkeWebView; callback: wkeURLChangedCallback; callbackParam: Pointer); cdecl;
  wkeOnPaintUpdated: procedure(webView: wkeWebView; callback: wkePaintUpdatedCallback; callbackParam: Pointer); cdecl;
  wkeOnAlertBox: procedure(webView: wkeWebView; callback: wkeAlertBoxCallback; callbackParam: Pointer); cdecl;
  wkeOnConfirmBox: procedure(webView: wkeWebView; callback: wkeConfirmBoxCallback; callbackParam: Pointer); cdecl;
  wkeOnPromptBox: procedure(webView: wkeWebView; callback: wkePromptBoxCallback; callbackParam: Pointer); cdecl;
  wkeOnNavigation: procedure(webView: wkeWebView; callback: wkeNavigationCallback; param: Pointer); cdecl;
  wkeOnCreateView: procedure(webView: wkeWebView; callback: wkeCreateViewCallback; param: Pointer); cdecl;
  wkeOnDocumentReady: procedure(webView: wkeWebView; callback: wkeDocumentReadyCallback; param: Pointer); cdecl;
  wkeOnLoadingFinish: procedure(webView: wkeWebView; callback: wkeLoadingFinishCallback; param: Pointer); cdecl;
  wkeOnDownload: procedure(webView: wkeWebView; callback: wkeDownloadCallback; param: Pointer); cdecl;
  wkeOnConsoleMessage: procedure(webView: wkeWebView; callback: wkeConsoleMessageCallback; callbackParam: Pointer); cdecl;
  wkeCreateWebWindow: function (AType: wkeWindowType; parent: HWND; x: Integer; y: Integer; width: Integer; height: Integer): wkeWebView; cdecl;
  wkeDestroyWebWindow: procedure(webWindow: wkeWebView); cdecl;
  wkeGetWindowHandle: function (webWindow: wkeWebView): HWND; cdecl;
  wkeOnWindowClosing: procedure(webWindow: wkeWebView; callback: wkeWindowClosingCallback; param: Pointer); cdecl;
  wkeOnWindowDestroy: procedure(webWindow: wkeWebView; callback: wkeWindowDestroyCallback; param: Pointer); cdecl;
  wkeShowWindow: procedure(webWindow: wkeWebView; show: Boolean); cdecl;
  wkeEnableWindow: procedure(webWindow: wkeWebView; enable: Boolean); cdecl;
  wkeMoveWindow: procedure(webWindow: wkeWebView; x: Integer; y: Integer; width: Integer; height: Integer); cdecl;
  wkeMoveToCenter: procedure(webWindow: wkeWebView); cdecl;
  wkeResizeWindow: procedure(webWindow: wkeWebView; width: Integer; height: Integer); cdecl;
  wkeSetWindowTitle: procedure(webWindow: wkeWebView; title: Putf8); cdecl;
  wkeSetWindowTitleW: procedure(webWindow: wkeWebView; title: Pwchar_t); cdecl;

  wkeSetHostWindow: procedure(webWindow: wkeWebView; hostWindow: HWND); cdecl;
  wkeGetHostWindow: function (webWindow: wkeWebView): HWND; cdecl;

  //================================JScript============================

  wkeJSBindFunction: procedure(name: PAnsiChar; fn: jsNativeFunction; AArgCount: LongInt); cdecl;
  wkeJSBindGetter: procedure(name: PAnsiChar; fn: jsNativeFunction); cdecl;
  wkeJSBindSetter: procedure(name: PAnsiChar; fn: jsNativeFunction); cdecl;
  wkeJSParamCount: function (es: wkeJSState): Integer; cdecl;
  wkeJSParamType: function (es: wkeJSState; argIdx: Integer): wkeJSType; cdecl;
  wkeJSParam: function (es: wkeJSState; argIdx: Integer): wkeJSValue; cdecl;
  wkeJSTypeOf: function ({$IFNDEF UseMB2018}es: wkeJSState;{$ENDIF} v: wkeJSValue): wkeJSType; cdecl;
  wkeJSIsNumber: function ({$IFNDEF UseMB2018}es: wkeJSState;{$ENDIF} v: wkeJSValue): Boolean; cdecl;
  wkeJSIsString: function ({$IFNDEF UseMB2018}es: wkeJSState;{$ENDIF} v: wkeJSValue): Boolean; cdecl;
  wkeJSIsBool: function ({$IFNDEF UseMB2018}es: wkeJSState;{$ENDIF} v: wkeJSValue): Boolean; cdecl;
  wkeJSIsObject: function ({$IFNDEF UseMB2018}es: wkeJSState;{$ENDIF} v: wkeJSValue): Boolean; cdecl;
  wkeJSIsFunction: function ({$IFNDEF UseMB2018}es: wkeJSState;{$ENDIF} v: wkeJSValue): Boolean; cdecl;
  wkeJSIsUndefined: function ({$IFNDEF UseMB2018}es: wkeJSState;{$ENDIF} v: wkeJSValue): Boolean; cdecl;
  wkeJSIsNull: function ({$IFNDEF UseMB2018}es: wkeJSState;{$ENDIF} v: wkeJSValue): Boolean; cdecl;
  wkeJSIsArray: function ({$IFNDEF UseMB2018}es: wkeJSState;{$ENDIF} v: wkeJSValue): Boolean; cdecl;
  wkeJSIsTrue: function ({$IFNDEF UseMB2018}es: wkeJSState;{$ENDIF} v: wkeJSValue): Boolean; cdecl;
  wkeJSIsFalse: function ({$IFNDEF UseMB2018}es: wkeJSState;{$ENDIF} v: wkeJSValue): Boolean; cdecl;
  wkeJSToInt: function (es: wkeJSState; v: wkeJSValue): Integer; cdecl;
  wkeJSToFloat: function (es: wkeJSState; v: wkeJSValue): Single; cdecl;
  wkeJSToDouble: function (es: wkeJSState; v: wkeJSValue): Double; cdecl;
  wkeJSToBool: function (es: wkeJSState; v: wkeJSValue): Boolean; cdecl;
  wkeJSToTempString: function (es: wkeJSState; v: wkeJSValue): putf8; cdecl;
  wkeJSToTempStringW: function (es: wkeJSState; v: wkeJSValue): pwchar_t; cdecl;
  wkeJSInt: function ({$IFNDEF UseMB2018}es: wkeJSState;{$ENDIF} n: Integer): wkeJSValue; cdecl;
  wkeJSFloat: function ({$IFNDEF UseMB2018}es: wkeJSState;{$ENDIF} f: Single): wkeJSValue; cdecl;
  wkeJSDouble: function ({$IFNDEF UseMB2018}es: wkeJSState;{$ENDIF} d: Double): wkeJSValue; cdecl;
  wkeJSBool: function ({$IFNDEF UseMB2018}es: wkeJSState;{$ENDIF} b: Boolean): wkeJSValue; cdecl;
  wkeJSUndefined: function ({$IFNDEF UseMB2018}es: wkeJSState{$ENDIF}): wkeJSValue; cdecl;
  wkeJSNull: function ({$IFNDEF UseMB2018}es: wkeJSState{$ENDIF}): wkeJSValue; cdecl;
  wkeJSTrue: function ({$IFNDEF UseMB2018}es: wkeJSState{$ENDIF}): wkeJSValue; cdecl;
  wkeJSFalse: function ({$IFNDEF UseMB2018}es: wkeJSState{$ENDIF}): wkeJSValue; cdecl;
  wkeJSString: function (es: wkeJSState; str: Putf8): wkeJSValue; cdecl;
  wkeJSStringW: function (es: wkeJSState; str: Pwchar_t): wkeJSValue; cdecl;
  wkeJSEmptyObject: function (es: wkeJSState): wkeJSValue; cdecl;
  wkeJSEmptyArray: function (es: wkeJSState): wkeJSValue; cdecl;

  wkeJSObject: function (es: wkeJSState; obj: PwkeJSData): wkeJSValue; cdecl;
  wkeJSFunction: function (es: wkeJSState; obj: PwkeJSData): wkeJSValue; cdecl;
  wkeJSGetData: function (es: wkeJSState; AObject: wkeJSValue): PwkeJSData; cdecl;
  wkeJSGet: function (es: wkeJSState; AObject: wkeJSValue; prop: PAnsiChar): wkeJSValue; cdecl;
  wkeJSSet: procedure(es: wkeJSState; AObject: wkeJSValue; prop: PAnsiChar; v: wkeJSValue); cdecl;
  wkeJSGetAt: function (es: wkeJSState; AObject: wkeJSValue; index: Integer): wkeJSValue; cdecl;
  wkeJSSetAt: procedure(es: wkeJSState; AObject: wkeJSValue; index: Integer; v: wkeJSValue); cdecl;
  wkeJSGetLength: function (es: wkeJSState; AObject: wkeJSValue): Integer; cdecl;
  wkeJSSetLength: procedure(es: wkeJSState; AObject: wkeJSValue; length: Integer); cdecl;
  wkeJSGlobalObject: function (es: wkeJSState): wkeJSValue; cdecl;
  wkeJSGetWebView: function (es: wkeJSState): wkeWebView; cdecl;
  wkeJSEval: function (es: wkeJSState; str: Putf8): wkeJSValue; cdecl;
  wkeJSEvalW: function (es: wkeJSState; str: Pwchar_t): wkeJSValue; cdecl;
  wkeJSCall: function (es: wkeJSState; func: wkeJSValue; thisObject: wkeJSValue; args: PwkeJSValue; argCount: Integer): wkeJSValue; cdecl;
  wkeJSCallGlobal: function (es: wkeJSState; func: wkeJSValue; args: PwkeJSValue; argCount: Integer): wkeJSValue; cdecl;
  wkeJSGetGlobal: function (es: wkeJSState; prop: PAnsiChar): wkeJSValue; cdecl;
  wkeJSSetGlobal: procedure(es: wkeJSState; prop: PAnsiChar; v: wkeJSValue); cdecl;

  wkeJSAddRef: procedure(es: wkeJSState; v: wkeJSValue); cdecl;
  wkeJSReleaseRef: procedure(es: wkeJSState; v: wkeJSValue); cdecl;
  wkeJSCollectGarbge: procedure(); cdecl;

implementation

var
  DLLHandle: THandle = 0;


{$IFDEF UseVcFastCall}
 // 必须放在函数开始的第一行位置，否则会破坏ecx寄存器
procedure ProcessVcFastCall;
asm
  {$IFDEF DEBUG}
  MOV [EBP-4], ECX
  {$ELSE}
  MOV EBX, ECX
  {$ENDIF DEBUG}
end;
{$ENDIF UseVcFastCall}

function GetProcAddressEx(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall;
var
  S: string;
begin
  Result := GetProcAddress(hModule, lpProcName);
  if (Result = nil) then begin
    if (StrLIComp(lpProcName, 'wkeJS', 5) = 0) then begin
      Inc(lpProcName, 5);
      S := 'js' + lpProcName;
      Result := GetProcAddress(hModule, PChar(S));
    end;
    {$IFNDEF UNICODE}
    if Result = nil then
      OutputDebugString(lpProcName);
    {$ENDIF}
  end;
end;

function InitWke(const DllName: string = 'wke.dll'): Boolean;
begin
  Result := True;
  if DLLHandle <> 0 then
    Exit;

  try
    DLLHandle := LoadLibrary(PChar(DllName));
    if DLLHandle = 0 then
      DLLHandle := LoadLibrary(PChar('node.dll'));
    if DLLHandle <> 0 then begin
      @wkeInitialize := GetProcAddressEx(DLLHandle, 'wkeInitialize'); //procedure(); cdecl;
      @wkeInitializeEx := GetProcAddressEx(DLLHandle, 'wkeInitializeEx'); //procedure(settings: PwkeSettings); cdecl;
      @wkeConfigure := GetProcAddressEx(DLLHandle, 'wkeConfigure'); //procedure(settings: PwkeSettings); cdecl;
      @wkeFinalize := GetProcAddressEx(DLLHandle, 'wkeFinalize'); //procedure(); cdecl;
      @wkeUpdate := GetProcAddressEx(DLLHandle, 'wkeUpdate'); //procedure(); cdecl;
      @wkeGetVersion := GetProcAddressEx(DLLHandle, 'wkeGetVersion'); //function(): Integer; cdecl;
      @wkeGetVersionString := GetProcAddressEx(DLLHandle, 'wkeGetVersionString'); //function(): putf8; cdecl;
      @wkeSetFileSystem := GetProcAddressEx(DLLHandle, 'wkeSetFileSystem'); //procedure(pfn_open: FILE_OPEN; pfn_close: FILE_CLOSE; pfn_size: FILE_SIZE; pfn_read: FILE_READ; pfn_seek: FILE_SEEK); cdecl;
      @wkeCreateWebView := GetProcAddressEx(DLLHandle, 'wkeCreateWebView'); //function(): wkeWebView; cdecl;
      @wkeGetWebView := GetProcAddressEx(DLLHandle, 'wkeGetWebView'); //function (name: PAnsiChar): wkeWebView; cdecl;
      @wkeDestroyWebView := GetProcAddressEx(DLLHandle, 'wkeDestroyWebView'); //procedure(webView: wkeWebView); cdecl;
      @wkeGetName := GetProcAddressEx(DLLHandle, 'wkeGetName'); //function (webView: wkeWebView): PAnsiChar; cdecl;
      @wkeSetName := GetProcAddressEx(DLLHandle, 'wkeSetName'); //procedure(webView: wkeWebView; name: PAnsiChar); cdecl;
      @wkeIsTransparent := GetProcAddressEx(DLLHandle, 'wkeIsTransparent'); //function (webView: wkeWebView): Boolean; cdecl;
      @wkeSetTransparent := GetProcAddressEx(DLLHandle, 'wkeSetTransparent'); //procedure(webView: wkeWebView; transparent: Boolean); cdecl;
      @wkeSetUserAgent := GetProcAddressEx(DLLHandle, 'wkeSetUserAgent'); //procedure(webView: wkeWebView; userAgent: Putf8); cdecl;
      @wkeSetUserAgentW := GetProcAddressEx(DLLHandle, 'wkeSetUserAgentW'); //procedure(webView: wkeWebView; userAgent: Pwchar_t); cdecl;
      @wkeLoadURL := GetProcAddressEx(DLLHandle, 'wkeLoadURL'); //procedure(webView: wkeWebView; url: Putf8); cdecl;
      @wkeLoadURLW := GetProcAddressEx(DLLHandle, 'wkeLoadURLW'); //procedure(webView: wkeWebView; url: Pwchar_t); cdecl;
      @wkePostURL := GetProcAddressEx(DLLHandle, 'wkePostURL'); //procedure(wkeView: wkeWebView; url: Putf8; postData: PAnsiChar; postLen: Integer); cdecl;
      @wkePostURLW := GetProcAddressEx(DLLHandle, 'wkePostURLW'); //procedure(wkeView: wkeWebView; url: Pwchar_t; postData: PAnsiChar; postLen: Integer); cdecl;
      @wkeLoadHTML := GetProcAddressEx(DLLHandle, 'wkeLoadHTML'); //procedure(webView: wkeWebView; html: Putf8); cdecl;
      @wkeLoadHTMLW := GetProcAddressEx(DLLHandle, 'wkeLoadHTMLW'); //procedure(webView: wkeWebView; html: Pwchar_t); cdecl;
      @wkeLoadFile := GetProcAddressEx(DLLHandle, 'wkeLoadFile'); //procedure(webView: wkeWebView; filename: Putf8); cdecl;
      @wkeLoadFileW := GetProcAddressEx(DLLHandle, 'wkeLoadFileW'); //procedure(webView: wkeWebView; filename: Pwchar_t); cdecl;
      @wkeLoad := GetProcAddressEx(DLLHandle, 'wkeLoad'); //procedure(webView: wkeWebView; str: Putf8); cdecl;
      @wkeLoadW := GetProcAddressEx(DLLHandle, 'wkeLoadW'); //procedure(webView: wkeWebView; str: Pwchar_t); cdecl;
      @wkeIsLoading := GetProcAddressEx(DLLHandle, 'wkeIsLoading'); //function (webView: wkeWebView): Boolean; cdecl;
      @wkeIsLoadingSucceeded := GetProcAddressEx(DLLHandle, 'wkeIsLoadingSucceeded'); //function (webView: wkeWebView): Boolean; cdecl;
      @wkeIsLoadingFailed := GetProcAddressEx(DLLHandle, 'wkeIsLoadingFailed'); //function (webView: wkeWebView): Boolean; cdecl;
      @wkeIsLoadingCompleted := GetProcAddressEx(DLLHandle, 'wkeIsLoadingCompleted'); //function (webView: wkeWebView): Boolean; cdecl;
      @wkeIsDocumentReady := GetProcAddressEx(DLLHandle, 'wkeIsDocumentReady'); //function (webView: wkeWebView): Boolean; cdecl;
      @wkeStopLoading := GetProcAddressEx(DLLHandle, 'wkeStopLoading'); //procedure(webView: wkeWebView); cdecl;
      @wkeReload := GetProcAddressEx(DLLHandle, 'wkeReload'); //procedure(webView: wkeWebView); cdecl;
      @wkeGetTitle := GetProcAddressEx(DLLHandle, 'wkeGetTitle'); //function (webView: wkeWebView): putf8; cdecl;
      @wkeGetTitleW := GetProcAddressEx(DLLHandle, 'wkeGetTitleW'); //function (webView: wkeWebView): pwchar_t; cdecl;
      @wkeResize := GetProcAddressEx(DLLHandle, 'wkeResize'); //procedure(webView: wkeWebView; w: Integer; h: Integer); cdecl;
      @wkeGetWidth := GetProcAddressEx(DLLHandle, 'wkeGetWidth'); //function (webView: wkeWebView): Integer; cdecl;
      @wkeGetHeight := GetProcAddressEx(DLLHandle, 'wkeGetHeight'); //function (webView: wkeWebView): Integer; cdecl;
      @wkeGetContentWidth := GetProcAddressEx(DLLHandle, 'wkeGetContentWidth'); //function (webView: wkeWebView): Integer; cdecl;
      @wkeGetContentHeight := GetProcAddressEx(DLLHandle, 'wkeGetContentHeight'); //function (webView: wkeWebView): Integer; cdecl;
      @wkeSetDirty := GetProcAddressEx(DLLHandle, 'wkeSetDirty'); //procedure(webView: wkeWebView; dirty: Boolean); cdecl;
      @wkeIsDirty := GetProcAddressEx(DLLHandle, 'wkeIsDirty'); //function (webView: wkeWebView): Boolean; cdecl;
      @wkeAddDirtyArea := GetProcAddressEx(DLLHandle, 'wkeAddDirtyArea'); //procedure(webView: wkeWebView; x: Integer; y: Integer; w: Integer; h: Integer); cdecl;
      @wkeLayoutIfNeeded := GetProcAddressEx(DLLHandle, 'wkeLayoutIfNeeded'); //procedure(webView: wkeWebView); cdecl;
      @wkePaint := GetProcAddressEx(DLLHandle, 'wkePaint'); //procedure(webView: wkeWebView; bits: Pointer; bufWid: Integer; bufHei: Integer; xDst: Integer; yDst: Integer; w: Integer; h: Integer; xSrc: Integer; ySrc: Integer; bCopyAlpha: Boolean); cdecl;
      @wkePaint := GetProcAddressEx(DLLHandle, 'wkePaint'); //procedure2(webView: wkeWebView; bits: Pointer; pitch: Integer); cdecl;
      @wkeAddPluginDirectory:=GetProcAddressEx(DLLHandle, 'wkeAddPluginDirectory');
      @wkeRepaintIfNeeded := GetProcAddressEx(DLLHandle, 'wkeRepaintIfNeeded'); //procedure(webView: wkeWebView); cdecl;
      @wkeGetViewDC := GetProcAddressEx(DLLHandle, 'wkeGetViewDC'); //function (webView: wkeWebView): HDC; cdecl;

      @wkeSetRepaintInterval := GetProcAddressEx(DLLHandle, 'wkeSetRepaintInterval'); //procedure(webView: wkeWebView; ms: Integer); cdecl;
      @wkeGetRepaintInterval := GetProcAddressEx(DLLHandle, 'wkeGetRepaintInterval'); //function (webView: wkeWebView): Integer; cdecl;
      @wkeRepaintIfNeededAfterInterval := GetProcAddressEx(DLLHandle, 'wkeRepaintIfNeededAfterInterval'); //function (webView: wkeWebView): Boolean; cdecl;
      @wkeRepaintAllNeeded := GetProcAddressEx(DLLHandle, 'wkeRepaintAllNeeded'); //function(): Boolean; cdecl;
      @wkeRunMessageLoop := GetProcAddressEx(DLLHandle, 'wkeRunMessageLoop'); //function (var quit: Boolean): Boolean; cdecl;

      @wkeCanGoBack := GetProcAddressEx(DLLHandle, 'wkeCanGoBack'); //function (webView: wkeWebView): Boolean; cdecl;
      @wkeGoBack := GetProcAddressEx(DLLHandle, 'wkeGoBack'); //function (webView: wkeWebView): Boolean; cdecl;
      @wkeCanGoForward := GetProcAddressEx(DLLHandle, 'wkeCanGoForward'); //function (webView: wkeWebView): Boolean; cdecl;
      @wkeGoForward := GetProcAddressEx(DLLHandle, 'wkeGoForward'); //function (webView: wkeWebView): Boolean; cdecl;
      @wkeEditorSelectAll := GetProcAddressEx(DLLHandle, 'wkeEditorSelectAll'); //procedure(webView: wkeWebView); cdecl;
      @wkeEditorCopy := GetProcAddressEx(DLLHandle, 'wkeEditorCopy'); //procedure(webView: wkeWebView); cdecl;
      @wkeEditorCut := GetProcAddressEx(DLLHandle, 'wkeEditorCut'); //procedure(webView: wkeWebView); cdecl;
      @wkeEditorPaste := GetProcAddressEx(DLLHandle, 'wkeEditorPaste'); //procedure(webView: wkeWebView); cdecl;
      @wkeEditorDelete := GetProcAddressEx(DLLHandle, 'wkeEditorDelete'); //procedure(webView: wkeWebView); cdecl;
      @wkeGetCookieW := GetProcAddressEx(DLLHandle, 'wkeGetCookieW'); //function (webView: wkeWebView): pwchar_t; cdecl;
      @wkeGetCookie := GetProcAddressEx(DLLHandle, 'wkeGetCookie'); //function (webView: wkeWebView): putf8; cdecl;
      @wkeSetCookieEnabled := GetProcAddressEx(DLLHandle, 'wkeSetCookieEnabled'); //procedure(webView: wkeWebView; enable: Boolean); cdecl;
      @wkeIsCookieEnabled := GetProcAddressEx(DLLHandle, 'wkeIsCookieEnabled'); //function (webView: wkeWebView): Boolean; cdecl;
      @wkeSetMediaVolume := GetProcAddressEx(DLLHandle, 'wkeSetMediaVolume'); //procedure(webView: wkeWebView; volume: Single); cdecl;
      @wkeGetMediaVolume := GetProcAddressEx(DLLHandle, 'wkeGetMediaVolume'); //function (webView: wkeWebView): Single; cdecl;
      @wkeFireMouseEvent := GetProcAddressEx(DLLHandle, 'wkeFireMouseEvent'); //function (webView: wkeWebView; AMessage: LongInt; x: Integer; y: Integer; flags: LongInt): Boolean; cdecl;
      @wkeFireContextMenuEvent := GetProcAddressEx(DLLHandle, 'wkeFireContextMenuEvent'); //function (webView: wkeWebView; x: Integer; y: Integer; flags: LongInt): Boolean; cdecl;
      @wkeFireMouseWheelEvent := GetProcAddressEx(DLLHandle, 'wkeFireMouseWheelEvent'); //function (webView: wkeWebView; x: Integer; y: Integer; delta: Integer; flags: LongInt): Boolean; cdecl;
      @wkeFireKeyUpEvent := GetProcAddressEx(DLLHandle, 'wkeFireKeyUpEvent'); //function (webView: wkeWebView; virtualKeyCode: LongInt; flags: LongInt; systemKey: Boolean): Boolean; cdecl;
      @wkeFireKeyDownEvent := GetProcAddressEx(DLLHandle, 'wkeFireKeyDownEvent'); //function (webView: wkeWebView; virtualKeyCode: LongInt; flags: LongInt; systemKey: Boolean): Boolean; cdecl;
      @wkeFireKeyPressEvent := GetProcAddressEx(DLLHandle, 'wkeFireKeyPressEvent'); //function (webView: wkeWebView; charCode: LongInt; flags: LongInt; systemKey: Boolean): Boolean; cdecl;
      @wkeSetFocus := GetProcAddressEx(DLLHandle, 'wkeSetFocus'); //procedure(webView: wkeWebView); cdecl;
      @wkeKillFocus := GetProcAddressEx(DLLHandle, 'wkeKillFocus'); //procedure(webView: wkeWebView); cdecl;
      @wkeGetCaretRect := GetProcAddressEx(DLLHandle, 'wkeGetCaretRect'); //function (webView: wkeWebView): wkeRect; cdecl;
      @wkeRunJS := GetProcAddressEx(DLLHandle, 'wkeRunJS'); //function (webView: wkeWebView; script: Putf8): wkeJSValue; cdecl;
      @wkeRunJSW := GetProcAddressEx(DLLHandle, 'wkeRunJSW'); //function (webView: wkeWebView; script: Pwchar_t): wkeJSValue; cdecl;
      @wkeGlobalExec := GetProcAddressEx(DLLHandle, 'wkeGlobalExec'); //function (webView: wkeWebView): wkeJSState; cdecl;
      @wkeSleep := GetProcAddressEx(DLLHandle, 'wkeSleep'); //procedure(webView: wkeWebView); cdecl;
      @wkeWake := GetProcAddressEx(DLLHandle, 'wkeWake'); //procedure(webView: wkeWebView); cdecl;
      @wkeIsAwake := GetProcAddressEx(DLLHandle, 'wkeIsAwake'); //function (webView: wkeWebView): Boolean; cdecl;
      @wkeSetZoomFactor := GetProcAddressEx(DLLHandle, 'wkeSetZoomFactor'); //procedure(webView: wkeWebView; factor: Single); cdecl;
      @wkeGetZoomFactor := GetProcAddressEx(DLLHandle, 'wkeGetZoomFactor'); //function (webView: wkeWebView): Single; cdecl;
      @wkeSetEditable := GetProcAddressEx(DLLHandle, 'wkeSetEditable'); //procedure(webView: wkeWebView; editable: Boolean); cdecl;
      @wkeGetString := GetProcAddressEx(DLLHandle, 'wkeGetString'); //function (AString: wkeString): putf8; cdecl;
      @wkeGetStringW := GetProcAddressEx(DLLHandle, 'wkeGetStringW'); //function (AString: wkeString): pwchar_t; cdecl;
      @wkeSetString := GetProcAddressEx(DLLHandle, 'wkeSetString'); //procedure(AString: wkeString; str: Putf8; len: size_t); cdecl;
      @wkeSetStringW := GetProcAddressEx(DLLHandle, 'wkeSetStringW'); //procedure(AString: wkeString; str: Pwchar_t; len: size_t); cdecl;
      @wkeOnTitleChanged := GetProcAddressEx(DLLHandle, 'wkeOnTitleChanged'); //procedure(webView: wkeWebView; callback: wkeTitleChangedCallback; callbackParam: Pointer); cdecl;
      @wkeOnURLChanged := GetProcAddressEx(DLLHandle, 'wkeOnURLChanged'); //procedure(webView: wkeWebView; callback: wkeURLChangedCallback; callbackParam: Pointer); cdecl;
      @wkeOnPaintUpdated := GetProcAddressEx(DLLHandle, 'wkeOnPaintUpdated'); //procedure(webView: wkeWebView; callback: wkePaintUpdatedCallback; callbackParam: Pointer); cdecl;
      @wkeOnAlertBox := GetProcAddressEx(DLLHandle, 'wkeOnAlertBox'); //procedure(webView: wkeWebView; callback: wkeAlertBoxCallback; callbackParam: Pointer); cdecl;
      @wkeOnConfirmBox := GetProcAddressEx(DLLHandle, 'wkeOnConfirmBox'); //procedure(webView: wkeWebView; callback: wkeConfirmBoxCallback; callbackParam: Pointer); cdecl;
      @wkeOnPromptBox := GetProcAddressEx(DLLHandle, 'wkeOnPromptBox'); //procedure(webView: wkeWebView; callback: wkePromptBoxCallback; callbackParam: Pointer); cdecl;
      @wkeOnNavigation := GetProcAddressEx(DLLHandle, 'wkeOnNavigation'); //procedure(webView: wkeWebView; callback: wkeNavigationCallback; param: Pointer); cdecl;
      @wkeOnCreateView := GetProcAddressEx(DLLHandle, 'wkeOnCreateView'); //procedure(webView: wkeWebView; callback: wkeCreateViewCallback; param: Pointer); cdecl;
      @wkeOnDocumentReady := GetProcAddressEx(DLLHandle, 'wkeOnDocumentReady'); //procedure(webView: wkeWebView; callback: wkeDocumentReadyCallback; param: Pointer); cdecl;
      @wkeOnLoadingFinish := GetProcAddressEx(DLLHandle, 'wkeOnLoadingFinish'); //procedure(webView: wkeWebView; callback: wkeLoadingFinishCallback; param: Pointer); cdecl;
      @wkeOnDownload := GetProcAddressEx(DLLHandle, 'wkeOnDownload'); // void wkeOnDownload(wkeWebView webView, wkeDownloadCallback callback, void* param);
      @wkeOnConsoleMessage := GetProcAddressEx(DLLHandle, 'wkeOnConsoleMessage'); //procedure(webView: wkeWebView; callback: wkeConsoleMessageCallback; callbackParam: Pointer); cdecl;
      @wkeCreateWebWindow := GetProcAddressEx(DLLHandle, 'wkeCreateWebWindow'); //function (AType: wkeWindowType; parent: HWND; x: Integer; y: Integer; width: Integer; height: Integer): wkeWebView; cdecl;
      @wkeDestroyWebWindow := GetProcAddressEx(DLLHandle, 'wkeDestroyWebWindow'); //procedure(webWindow: wkeWebView); cdecl;
      @wkeGetWindowHandle := GetProcAddressEx(DLLHandle, 'wkeGetWindowHandle'); //function (webWindow: wkeWebView): HWND; cdecl;
      @wkeOnWindowClosing := GetProcAddressEx(DLLHandle, 'wkeOnWindowClosing'); //procedure(webWindow: wkeWebView; callback: wkeWindowClosingCallback; param: Pointer); cdecl;
      @wkeOnWindowDestroy := GetProcAddressEx(DLLHandle, 'wkeOnWindowDestroy'); //procedure(webWindow: wkeWebView; callback: wkeWindowDestroyCallback; param: Pointer); cdecl;
      @wkeShowWindow := GetProcAddressEx(DLLHandle, 'wkeShowWindow'); //procedure(webWindow: wkeWebView; show: Boolean); cdecl;
      @wkeEnableWindow := GetProcAddressEx(DLLHandle, 'wkeEnableWindow'); //procedure(webWindow: wkeWebView; enable: Boolean); cdecl;
      @wkeMoveWindow := GetProcAddressEx(DLLHandle, 'wkeMoveWindow'); //procedure(webWindow: wkeWebView; x: Integer; y: Integer; width: Integer; height: Integer); cdecl;
      @wkeMoveToCenter := GetProcAddressEx(DLLHandle, 'wkeMoveToCenter'); //procedure(webWindow: wkeWebView); cdecl;
      @wkeResizeWindow := GetProcAddressEx(DLLHandle, 'wkeResizeWindow'); //procedure(webWindow: wkeWebView; width: Integer; height: Integer); cdecl;
      @wkeSetWindowTitle := GetProcAddressEx(DLLHandle, 'wkeSetWindowTitle'); //procedure(webWindow: wkeWebView; title: Putf8); cdecl;
      @wkeSetWindowTitleW := GetProcAddressEx(DLLHandle, 'wkeSetWindowTitleW'); //procedure(webWindow: wkeWebView; title: Pwchar_t); cdecl;

      @wkeSetHostWindow := GetProcAddressEx(DLLHandle, 'wkeSetHostWindow'); //procedure(webWindow: wkeWebView; hostWindow: HWND); cdecl;
      @wkeGetHostWindow := GetProcAddressEx(DLLHandle, 'wkeGetHostWindow'); //function (webWindow: wkeWebView): HWND; cdecl;

      //================================JScript============================

      @wkeJSBindFunction := GetProcAddressEx(DLLHandle, 'wkeJSBindFunction'); //procedure(name: PAnsiChar; fn: jsNativeFunction; AArgCount: LongInt); cdecl;
      @wkeJSBindGetter := GetProcAddressEx(DLLHandle, 'wkeJSBindGetter'); //procedure(name: PAnsiChar; fn: jsNativeFunction); cdecl;
      @wkeJSBindSetter := GetProcAddressEx(DLLHandle, 'wkeJSBindSetter'); //procedure(name: PAnsiChar; fn: jsNativeFunction); cdecl;
      @wkeJSParamCount := GetProcAddressEx(DLLHandle, 'wkeJSParamCount'); //function (es: wkeJSState): Integer; cdecl;
      @wkeJSParamType := GetProcAddressEx(DLLHandle, 'wkeJSParamType'); //function (es: wkeJSState; argIdx: Integer): wkeJSType; cdecl;
      @wkeJSParam := GetProcAddressEx(DLLHandle, 'wkeJSParam'); //function (es: wkeJSState; argIdx: Integer): wkeJSValue; cdecl;
      @wkeJSTypeOf := GetProcAddressEx(DLLHandle, 'wkeJSTypeOf'); //function (es: wkeJSState; v: wkeJSValue): wkeJSType; cdecl;
      @wkeJSIsNumber := GetProcAddressEx(DLLHandle, 'wkeJSIsNumber'); //function (es: wkeJSState; v: wkeJSValue): Boolean; cdecl;
      @wkeJSIsString := GetProcAddressEx(DLLHandle, 'wkeJSIsString'); //function (es: wkeJSState; v: wkeJSValue): Boolean; cdecl;
      @wkeJSIsBool := GetProcAddressEx(DLLHandle, 'wkeJSIsBool'); //function (es: wkeJSState; v: wkeJSValue): Boolean; cdecl;
      @wkeJSIsObject := GetProcAddressEx(DLLHandle, 'wkeJSIsObject'); //function (es: wkeJSState; v: wkeJSValue): Boolean; cdecl;
      @wkeJSIsFunction := GetProcAddressEx(DLLHandle, 'wkeJSIsFunction'); //function (es: wkeJSState; v: wkeJSValue): Boolean; cdecl;
      @wkeJSIsUndefined := GetProcAddressEx(DLLHandle, 'wkeJSIsUndefined'); //function (es: wkeJSState; v: wkeJSValue): Boolean; cdecl;
      @wkeJSIsNull := GetProcAddressEx(DLLHandle, 'wkeJSIsNull'); //function (es: wkeJSState; v: wkeJSValue): Boolean; cdecl;
      @wkeJSIsArray := GetProcAddressEx(DLLHandle, 'wkeJSIsArray'); //function (es: wkeJSState; v: wkeJSValue): Boolean; cdecl;
      @wkeJSIsTrue := GetProcAddressEx(DLLHandle, 'wkeJSIsTrue'); //function (es: wkeJSState; v: wkeJSValue): Boolean; cdecl;
      @wkeJSIsFalse := GetProcAddressEx(DLLHandle, 'wkeJSIsFalse'); //function (es: wkeJSState; v: wkeJSValue): Boolean; cdecl;
      @wkeJSToInt := GetProcAddressEx(DLLHandle, 'wkeJSToInt'); //function (es: wkeJSState; v: wkeJSValue): Integer; cdecl;
      @wkeJSToFloat := GetProcAddressEx(DLLHandle, 'wkeJSToFloat'); //function (es: wkeJSState; v: wkeJSValue): Single; cdecl;
      @wkeJSToDouble := GetProcAddressEx(DLLHandle, 'wkeJSToDouble'); //function (es: wkeJSState; v: wkeJSValue): Double; cdecl;
      @wkeJSToBool := GetProcAddressEx(DLLHandle, 'wkeJSToBool'); //function (es: wkeJSState; v: wkeJSValue): Boolean; cdecl;
      @wkeJSToTempString := GetProcAddressEx(DLLHandle, 'wkeJSToTempString'); //function (es: wkeJSState; v: wkeJSValue): putf8; cdecl;
      @wkeJSToTempStringW := GetProcAddressEx(DLLHandle, 'wkeJSToTempStringW'); //function (es: wkeJSState; v: wkeJSValue): pwchar_t; cdecl;
      @wkeJSInt := GetProcAddressEx(DLLHandle, 'wkeJSInt'); //function (es: wkeJSState; n: Integer): wkeJSValue; cdecl;
      @wkeJSFloat := GetProcAddressEx(DLLHandle, 'wkeJSFloat'); //function (es: wkeJSState; f: Single): wkeJSValue; cdecl;
      @wkeJSDouble := GetProcAddressEx(DLLHandle, 'wkeJSDouble'); //function (es: wkeJSState; d: Double): wkeJSValue; cdecl;
      @wkeJSBool := GetProcAddressEx(DLLHandle, 'wkeJSBool'); //function (es: wkeJSState; b: Boolean): wkeJSValue; cdecl;
      @wkeJSUndefined := GetProcAddressEx(DLLHandle, 'wkeJSUndefined'); //function (es: wkeJSState): wkeJSValue; cdecl;
      @wkeJSNull := GetProcAddressEx(DLLHandle, 'wkeJSNull'); //function (es: wkeJSState): wkeJSValue; cdecl;
      @wkeJSTrue := GetProcAddressEx(DLLHandle, 'wkeJSTrue'); //function (es: wkeJSState): wkeJSValue; cdecl;
      @wkeJSFalse := GetProcAddressEx(DLLHandle, 'wkeJSFalse'); //function (es: wkeJSState): wkeJSValue; cdecl;
      @wkeJSString := GetProcAddressEx(DLLHandle, 'wkeJSString'); //function (es: wkeJSState; str: Putf8): wkeJSValue; cdecl;
      @wkeJSStringW := GetProcAddressEx(DLLHandle, 'wkeJSStringW'); //function (es: wkeJSState; str: Pwchar_t): wkeJSValue; cdecl;
      @wkeJSEmptyObject := GetProcAddressEx(DLLHandle, 'wkeJSEmptyObject'); //function (es: wkeJSState): wkeJSValue; cdecl;
      @wkeJSEmptyArray := GetProcAddressEx(DLLHandle, 'wkeJSEmptyArray'); //function (es: wkeJSState): wkeJSValue; cdecl;

      @wkeJSObject := GetProcAddressEx(DLLHandle, 'wkeJSObject'); //function (es: wkeJSState; obj: PwkeJSData): wkeJSValue; cdecl;
      @wkeJSFunction := GetProcAddressEx(DLLHandle, 'wkeJSFunction'); //function (es: wkeJSState; obj: PwkeJSData): wkeJSValue; cdecl;
      @wkeJSGetData := GetProcAddressEx(DLLHandle, 'wkeJSGetData'); //function (es: wkeJSState; AObject: wkeJSValue): PwkeJSData; cdecl;
      @wkeJSGet := GetProcAddressEx(DLLHandle, 'wkeJSGet'); //function (es: wkeJSState; AObject: wkeJSValue; prop: PAnsiChar): wkeJSValue; cdecl;
      @wkeJSSet := GetProcAddressEx(DLLHandle, 'wkeJSSet'); //procedure(es: wkeJSState; AObject: wkeJSValue; prop: PAnsiChar; v: wkeJSValue); cdecl;
      @wkeJSGetAt := GetProcAddressEx(DLLHandle, 'wkeJSGetAt'); //function (es: wkeJSState; AObject: wkeJSValue; index: Integer): wkeJSValue; cdecl;
      @wkeJSSetAt := GetProcAddressEx(DLLHandle, 'wkeJSSetAt'); //procedure(es: wkeJSState; AObject: wkeJSValue; index: Integer; v: wkeJSValue); cdecl;
      @wkeJSGetLength := GetProcAddressEx(DLLHandle, 'wkeJSGetLength'); //function (es: wkeJSState; AObject: wkeJSValue): Integer; cdecl;
      @wkeJSSetLength := GetProcAddressEx(DLLHandle, 'wkeJSSetLength'); //procedure(es: wkeJSState; AObject: wkeJSValue; length: Integer); cdecl;
      @wkeJSGlobalObject := GetProcAddressEx(DLLHandle, 'wkeJSGlobalObject'); //function (es: wkeJSState): wkeJSValue; cdecl;
      @wkeJSGetWebView := GetProcAddressEx(DLLHandle, 'wkeJSGetWebView'); //function (es: wkeJSState): wkeWebView; cdecl;
      @wkeJSEval := GetProcAddressEx(DLLHandle, 'wkeJSEval'); //function (es: wkeJSState; str: Putf8): wkeJSValue; cdecl;
      @wkeJSEvalW := GetProcAddressEx(DLLHandle, 'wkeJSEvalW'); //function (es: wkeJSState; str: Pwchar_t): wkeJSValue; cdecl;
      @wkeJSCall := GetProcAddressEx(DLLHandle, 'wkeJSCall'); //function (es: wkeJSState; func: wkeJSValue; thisObject: wkeJSValue; args: PwkeJSValue; argCount: Integer): wkeJSValue; cdecl;
      @wkeJSCallGlobal := GetProcAddressEx(DLLHandle, 'wkeJSCallGlobal'); //function (es: wkeJSState; func: wkeJSValue; args: PwkeJSValue; argCount: Integer): wkeJSValue; cdecl;
      @wkeJSGetGlobal := GetProcAddressEx(DLLHandle, 'wkeJSGetGlobal'); //function (es: wkeJSState; prop: PAnsiChar): wkeJSValue; cdecl;
      @wkeJSSetGlobal := GetProcAddressEx(DLLHandle, 'wkeJSSetGlobal'); //procedure(es: wkeJSState; prop: PAnsiChar; v: wkeJSValue); cdecl;

      @wkeJSAddRef := GetProcAddressEx(DLLHandle, 'wkeJSAddRef'); //procedure(es: wkeJSState; v: wkeJSValue); cdecl;
      @wkeJSReleaseRef := GetProcAddressEx(DLLHandle, 'wkeJSReleaseRef'); //procedure(es: wkeJSState; v: wkeJSValue); cdecl;
      @wkeJSCollectGarbge := GetProcAddressEx(DLLHandle, 'wkeJSCollectGarbge'); //procedure(); cdecl;

      if not Assigned(@wkeGetWebView) then
        @wkeGetWebView := @wkeJSGetWebView;
      if not Assigned(@wkeJSParam) then
        @wkeJSParam := GetProcAddressEx(DLLHandle, 'wkeJsArg');
      if not Assigned(@wkeJSParamCount) then
        @wkeJSParamCount := GetProcAddressEx(DLLHandle, 'wkeJsArgCount');
      if not Assigned(@wkeJSParamType) then
        @wkeJSParamType := GetProcAddressEx(DLLHandle, 'wkeJsArgType');

      if not Assigned(@wkeGetVersion) then
        Result := False
      else begin
        //OutputDebugString(PChar('Wke Version: ' + IntToStr(wkeGetVersion())));
      end;
    end else
      Result := False;    
  except
    Result := False;
  end;
end;

procedure UninitWke();
begin
  if DLLHandle = 0 then
    Exit;
  FreeLibrary(DLLHandle);
  DLLHandle := 0;
end;    

{ wkeWebView }

class procedure wkeWebView.Initialize;
begin
  wkeInitialize;
end;

class procedure wkeWebView.InitializeEx(settings: PwkeSettings);
begin
  wkeInitializeEx(settings);
end;

class procedure wkeWebView.Configure(settings: PwkeSettings);
begin
  wkeConfigure(settings);
end;

class procedure wkeWebView.Finalize;
begin
  wkeFinalize;
end;

class procedure wkeWebView.Update;
begin
  wkeUpdate;
end;

class function wkeWebView.GetVersion: Integer;
begin
  Result := wkeGetVersion;
end;

class function wkeWebView.GetVersionString: string;
begin
  Result := string(AnsiString(wkeGetVersionString));
end;

class procedure wkeWebView.SetFileSystem(pfn_open: FILE_OPEN; pfn_close: FILE_CLOSE; pfn_size: FILE_SIZE; pfn_read: FILE_READ; pfn_seek: FILE_SEEK);
begin
  wkeSetFileSystem(pfn_open, pfn_close, pfn_size, pfn_read, pfn_seek);
end;

class function wkeWebView.CreateWebView: wkeWebView;
begin
  Result := wkeCreateWebView;
end;

procedure wkeWebView.DestroyWebView;
begin
  wkeDestroyWebView(Self);
end;

function wkeWebView.GetName: string;
begin
  Result := string(AnsiString(wkeGetName(Self)));
end;

procedure wkeWebView.SetName(const AName: string);
begin
  wkeSetName(Self, PAnsiChar(AnsiString(AName)));
end;

function wkeWebView.IsTransparent: Boolean;
begin
  Result := wkeIsTransparent(Self);
end;

procedure wkeWebView.SetTransparent(ATransparent: Boolean);
begin
  wkeSetTransparent(Self, ATransparent);
end;

procedure wkeWebView.SetUserAgent(const AUserAgent: string);
begin
  {$IFDEF UNICODE}
  wkeSetUserAgentW(Self, PChar(AUserAgent));
  {$ELSE}
  wkeSetUserAgent(Self, PChar({$IFDEF FPC}AUserAgent{$ELSE}AnsiToUtf8(AUserAgent){$ENDIF}));
  {$ENDIF}
end;

procedure wkeWebView.LoadURL(const AURL: string);
begin
  {$IFDEF UNICODE}
  wkeLoadURLW(Self, PChar(AURL));
  {$ELSE}
  wkeLoadURL(Self, PChar(AURL));
  {$ENDIF}
end;

procedure wkeWebView.PostURL(const AURL, APostData: string; PostLen: Integer);
begin
  {$IFDEF UNICODE}
  wkePostURLW(Self, PChar(AURL), PAnsiChar(AnsiString(APostData)), PostLen);
  {$ELSE}
  wkePostURL(Self, PChar({$IFDEF FPC}AURL{$ELSE}AnsiToUtf8(AURL){$ENDIF}),
     PAnsiChar(AnsiString({$IFDEF FPC}Utf8ToAnsi(APostData){$ELSE}APostData{$ENDIF})), PostLen);
  {$ENDIF}
end;

procedure wkeWebView.LoadHTML(const AHTML: string);
begin
  {$IFDEF UNICODE}
  wkeLoadHTMLW(Self, PChar(AHTML));
  {$ELSE}
  wkeLoadHTML(Self, PChar({$IFDEF FPC}AHTML{$ELSE}AnsiToUtf8(AHTML){$ENDIF}));
  {$ENDIF}
end;

procedure wkeWebView.LoadFile(const AFileName: string);
begin
  {$IFDEF UNICODE}
  wkeLoadFileW(Self, PChar(AFileName));
  {$ELSE}
  wkeLoadFile(Self, PChar({$IFDEF FPC}AFileName{$ELSE}AnsiToUtf8(AFileName){$ENDIF}));
  {$ENDIF}
end;

procedure wkeWebView.Load(const AStr: string);

  {$IFNDEF UNICODE}
  procedure LoadW(const AStr: WideString);
  begin
    wkeLoadW(Self, PWideChar(AStr))
  end;
  {$ENDIF}

begin
  {$IFDEF UNICODE}
  wkeLoadW(Self, PChar(AStr))
  {$ELSE}
  if Assigned(@wkeLoad) then
    wkeLoad(Self, PChar({$IFDEF FPC}AStr{$ELSE}AnsiToUTf8(AStr){$ENDIF}))
  else if Assigned(wkeLoadW) then begin
    LoadW(WideString(AStr));
  end;
  {$ENDIF}
end;

function wkeWebView.IsLoadingSucceeded: Boolean;
begin
  Result := wkeIsLoadingSucceeded(Self);
end;

function wkeWebView.IsLoadingFailed: Boolean;
begin
  Result := wkeIsLoadingFailed(Self);
end;

procedure wkeWebView.SetHostWindow(hostWindow: HWND);
begin
  wkeSetHostWindow(Self, hostWindow);
end;

function wkeWebView.GetHostWindow: HWND;
begin
  Result := wkeGetHostWindow(Self);
end;

procedure wkeWebView.SetRepaintInterval(ms: Integer);
begin
  wkeSetRepaintInterval(Self, ms);
end;

function wkeWebView.GetRepaintInterval: Integer;
begin
  Result := wkeGetRepaintInterval(Self);
end;

function wkeWebView.RepaintIfNeededAfterInterval: Boolean;
begin
  Result := wkeRepaintIfNeededAfterInterval(Self);
end;


function wkeWebView.IsLoading(webView: wkeWebView): Boolean;
begin
  //Result := True;
  Result := wkeIsLoading(webView);
end;

function wkeWebView.IsLoadingCompleted: Boolean;
begin
  Result := wkeIsLoadingCompleted(Self);
end;

function wkeWebView.IsDocumentReady: Boolean;
begin
  Result := wkeIsDocumentReady(Self);
end;

procedure wkeWebView.StopLoading;
begin
  wkeStopLoading(Self);
end;

procedure wkeWebView.Reload;
begin
  wkeReload(Self);
end;

function wkeWebView.GetTitle: string;
begin
  {$IFDEF UNICODE}
  Result := wkeGetTitleW(Self);
  {$ELSE}
  Result := {$IFDEF FPC}wkeGetTitle(Self){$ELSE}Utf8ToAnsi(wkeGetTitle(Self)){$ENDIF};
  {$ENDIF}
end;

procedure wkeWebView.Resize(w: Integer; h: Integer);
begin
  wkeResize(Self, w, h);
end;

function wkeWebView.GetWebView(name: AnsiString): wkeWebView;
begin
  Result := wkeGetWebView(PAnsiChar(name));
end;

function wkeWebView.GetWidth: Integer;
begin
  Result := wkeGetWidth(Self);
end;

function wkeWebView.GetHeight: Integer;
begin
  Result := wkeGetHeight(Self);
end;

function wkeWebView.GetContentWidth: Integer;
begin
  Result := wkeGetContentWidth(Self);
end;

function wkeWebView.GetContentHeight: Integer;
begin
  Result := wkeGetContentHeight(Self);
end;

procedure wkeWebView.SetDirty(dirty: Boolean);
begin
  wkeSetDirty(Self, dirty);
end;

function wkeWebView.IsDirty: Boolean;
begin
  Result := wkeIsDirty(Self);
end;

procedure wkeWebView.AddDirtyArea(x: Integer; y: Integer; w: Integer; h: Integer);
begin
  wkeAddDirtyArea(Self, x, y, w, h);
end;

procedure wkeWebView.LayoutIfNeeded;
begin
  wkeLayoutIfNeeded(Self);
end;

procedure wkeWebView.Paint(bits: Pointer; bufWid: Integer; bufHei: Integer; xDst: Integer; yDst: Integer; w: Integer; h: Integer; xSrc: Integer; ySrc: Integer; bCopyAlpha: Boolean);
begin
  wkePaint(Self, bits, bufWid, bufHei, xDst, yDst, w, h, xSrc, ySrc, bCopyAlpha);
end;

procedure wkeWebView.Paint2(bits: Pointer; pitch: Integer);
begin
  wkePaint2(Self, bits, pitch);
end;

class function wkeWebView.RepaintAllNeeded: Boolean;
begin
  if Assigned(@wkeRepaintAllNeeded) then
    Result := wkeRepaintAllNeeded
  else
    Result := False;
end;

procedure wkeWebView.RepaintIfNeeded;
begin
  if Assigned(@wkeRepaintIfNeeded) then
    wkeRepaintIfNeeded(Self);
end;

function wkeWebView.GetViewDC: HDC;
begin
  Result := wkeGetViewDC(Self);
end;

function wkeWebView.CanGoBack: Boolean;
begin
  Result := wkeCanGoBack(Self);
end;

function wkeWebView.GoBack: Boolean;
begin
  Result := wkeGoBack(Self);
end;

function wkeWebView.CanGoForward: Boolean;
begin
  Result := wkeCanGoForward(Self);
end;

function wkeWebView.GoForward: Boolean;
begin
  Result := wkeGoForward(Self);
end;

procedure wkeWebView.EditorSelectAll;
begin
  wkeEditorSelectAll(Self);
end;

procedure wkeWebView.EditorCopy;
begin
  wkeEditorCopy(Self);
end;

procedure wkeWebView.EditorCut;
begin
  wkeEditorCut(Self);
end;

procedure wkeWebView.EditorPaste;
begin
  wkeEditorPaste(Self);
end;

procedure wkeWebView.EditorDelete;
begin
  wkeEditorDelete(Self);
end;

function wkeWebView.GetCookie: string;
begin
  {$IFDEF UNICODE}
  Result := wkeGetCookieW(Self);
  {$ELSE}
  Result := {$IFDEF FPC}wkeGetCookie(Self){$ELSE}Utf8ToAnsi(wkeGetCookie(Self)){$ENDIF};
  {$ENDIF}
end;

procedure wkeWebView.SetCookieEnabled(enable: Boolean);
begin
  wkeSetCookieEnabled(Self, enable);
end;

function wkeWebView.IsCookieEnabled: Boolean;
begin
  Result := wkeIsCookieEnabled(Self);
end;

procedure wkeWebView.SetMediaVolume(volume: Single);
begin
  wkeSetMediaVolume(Self, volume);
end;

function wkeWebView.GetMediaVolume: Single;
begin
  Result := wkeGetMediaVolume(Self);
end;

function wkeWebView.FireMouseEvent(AMessage: LongInt; x: Integer; y: Integer; flags: LongInt): Boolean;
begin
  Result := wkeFireMouseEvent(Self, AMessage, x, y, flags);
end;

function wkeWebView.FireContextMenuEvent(x: Integer; y: Integer; flags: LongInt): Boolean;
begin
  Result := wkeFireContextMenuEvent(Self, x, y, flags);
end;

function wkeWebView.FireMouseWheelEvent(x: Integer; y: Integer; delta: Integer; flags: LongInt): Boolean;
begin
  Result := wkeFireMouseWheelEvent(Self, x, y, delta, flags);
end;

function wkeWebView.FireKeyUpEvent(virtualKeyCode: LongInt; flags: LongInt; systemKey: Boolean): Boolean;
begin
  Result := wkeFireKeyUpEvent(Self, virtualKeyCode, flags, systemKey);
end;

function wkeWebView.FireKeyDownEvent(virtualKeyCode: LongInt; flags: LongInt; systemKey: Boolean): Boolean;
begin
  Result := wkeFireKeyDownEvent(Self, virtualKeyCode, flags, systemKey);
end;

function wkeWebView.FireKeyPressEvent(charCode: LongInt; flags: LongInt; systemKey: Boolean): Boolean;
begin
  Result := wkeFireKeyPressEvent(Self, charCode, flags, systemKey);
end;

procedure wkeWebView.SetFocus;
begin
  wkeSetFocus(Self);
end;

procedure wkeWebView.KillFocus;
begin
  wkeKillFocus(Self);
end;

function wkeWebView.GetCaretRect: wkeRect;
begin
  Result := wkeGetCaretRect(Self);
end;

function wkeWebView.RunJS(const AScript: string): wkeJSValue;
begin
  {$IFDEF UNICODE}
  Result := wkeRunJSW(Self, PChar(AScript));
  {$ELSE}
  Result := wkeRunJS(Self, PChar({$IFDEF FPC}AScript{$ELSE}AnsiToUtf8(AScript){$ENDIF}));
  {$ENDIF}
end;

class function wkeWebView.RunMessageLoop(var quit: Boolean): Boolean;
begin
  Result := wkeRunMessageLoop(quit);
end;

function wkeWebView.GlobalExec: wkeJSState;
begin
  Result := wkeGlobalExec(Self);
end;

procedure wkeWebView.Sleep;
begin
  wkeSleep(Self);
end;

procedure wkeWebView.Wake;
begin
  wkeWake(Self);
end;

function wkeWebView.IsAwake: Boolean;
begin
  Result := wkeIsAwake(Self);
end;

procedure wkeWebView.SetZoomFactor(factor: Single);
begin
  wkeSetZoomFactor(Self, factor);
end;

function wkeWebView.GetZoomFactor: Single;
begin
  Result := wkeGetZoomFactor(Self);
end;

procedure wkeWebView.SetEditable(editable: Boolean);
begin
  wkeSetEditable(Self, editable);
end;

{$IFNDEF UNICODE}
function Utf8Decode(p: PAnsiChar; l: Integer): WideString;
var
  ps: PByte;
begin
  if l<=0 then begin
    if (p = nil) or (p^ = #0) then begin
      Result := '';
      Exit;
    end; 
    ps := PByte(p);
    while ps^<>0 do Inc(ps);
    l := Integer(ps) - Integer(p);
  end;
  SetLength(Result, l);
  SetLength(Result, MultiByteToWideChar(CP_UTF8, 8, p, l, PWideChar(Result), l)); // 8==>MB_ERR_INVALID_CHARS
end;

function DecodeUtf8Str(const P: PAnsiChar): string;
begin
  try
    Result := Utf8Decode(P, 0);
  except
    Result := '';
  end;
end;
{$ENDIF}

class function wkeWebView.GetString(AString: wkeString): string;
begin
{$IFDEF UNICODE}
  Result := wkeGetStringW(AString);
{$ELSE}
  Result := {$IFDEF FPC}wkeGetString(AString){$ELSE}DecodeUtf8Str(wkeGetString(AString)){$ENDIF};
{$ENDIF}
end;

class procedure wkeWebView.SetString(AString: wkeString; const AStr: string);
begin
{$IFDEF UNICODE}
  wkeSetStringW(AString, PChar(AStr), Length(AStr));
{$ELSE}
  wkeSetString(AString, PChar({$IFDEF FPC}AStr{$ELSE}AnsiToUtf8(AStr){$ENDIF}), Length(AStr));
{$ENDIF}
end;

procedure wkeWebView.SetOnTitleChanged(callback: wkeTitleChangedCallback; callbackParam: Pointer);
begin
  if Assigned(@wkeOnTitleChanged) then
    wkeOnTitleChanged(Self, callback, callbackParam);
end;

procedure wkeWebView.SetOnURLChanged(callback: wkeURLChangedCallback; callbackParam: Pointer);
begin
  if Assigned(@wkeOnURLChanged) then
    wkeOnURLChanged(Self, callback, callbackParam);
end;

procedure wkeWebView.SetOnPaintUpdated(callback: wkePaintUpdatedCallback; callbackParam: Pointer);
begin
  if Assigned(@wkeOnPaintUpdated) then
    wkeOnPaintUpdated(Self, callback, callbackParam);
end;

procedure wkeWebView.SetOnAlertBox(callback: wkeAlertBoxCallback; callbackParam: Pointer);
begin
  if Assigned(@wkeOnAlertBox) then
    wkeOnAlertBox(Self, callback, callbackParam);
end;

procedure wkeWebView.SetOnConfirmBox(callback: wkeConfirmBoxCallback; callbackParam: Pointer);
begin
  if Assigned(@wkeOnConfirmBox) then
    wkeOnConfirmBox(Self, callback, callbackParam);
end;

procedure wkeWebView.SetOnConsoleMessage(callback: wkeConsoleMessageCallback;
  callbackParam: Pointer);
begin
  if Assigned(@wkeOnConsoleMessage) then
    wkeOnConsoleMessage(Self, callback, callbackParam);
end;

procedure wkeWebView.SetOnPromptBox(callback: wkePromptBoxCallback; callbackParam: Pointer);
begin
  if Assigned(@wkeOnPromptBox) then
    wkeOnPromptBox(Self, callback, callbackParam);
end;

procedure wkeWebView.SetOnNavigation(callback: wkeNavigationCallback; param: Pointer);
begin
  if Assigned(@wkeOnNavigation) then
    wkeOnNavigation(Self, callback, param);
end;

procedure wkeWebView.SetOnCreateView(callback: wkeCreateViewCallback; param: Pointer);
begin
  wkeOnCreateView(Self, callback, param);
end;

procedure wkeWebView.SetOnDocumentReady(callback: wkeDocumentReadyCallback; param: Pointer);
begin
  wkeOnDocumentReady(Self, callback, param);
end;

procedure wkeWebView.SetOnLoadingFinish(callback: wkeLoadingFinishCallback; param: Pointer);
begin
  if Assigned(@wkeOnLoadingFinish) then
    wkeOnLoadingFinish(Self, callback, param);
end;

class function wkeWebView.CreateWebWindow(AType: wkeWindowType; parent: HWND; x: Integer; y: Integer; width: Integer; height: Integer): wkeWebView;
begin
  Result := wkeCreateWebWindow(AType, parent, x, y, width, height);
end;

procedure wkeWebView.DestroyWebWindow;
begin
  wkeDestroyWebWindow(Self);
end;

function wkeWebView.GetWindowHandle: HWND;
begin
  Result := wkeGetWindowHandle(Self);
end;

procedure wkeWebView.SetOnWindowClosing(callback: wkeWindowClosingCallback; param: Pointer);
begin
  if Assigned(@wkeOnWindowClosing) then
    wkeOnWindowClosing(Self, callback, param);
end;

procedure wkeWebView.SetOnWindowDestroy(callback: wkeWindowDestroyCallback; param: Pointer);
begin
  if Assigned(@wkeOnWindowDestroy) then
    wkeOnWindowDestroy(Self, callback, param);
end;

procedure wkeWebView.ShowWindow(show: Boolean);
begin
  wkeShowWindow(Self, show);
end;

procedure wkeWebView.EnableWindow(enable: Boolean);
begin
  wkeEnableWindow(Self, enable);
end;

procedure wkeWebView.MoveWindow(x: Integer; y: Integer; width: Integer; height: Integer);
begin
  wkeMoveWindow(Self, x, y, width, height);
end;

procedure wkeWebView.MoveToCenter;
begin
  wkeMoveToCenter(Self);
end;

procedure wkeWebView.ResizeWindow(width: Integer; height: Integer);
begin
  wkeResizeWindow(Self, width, height);
end;

procedure wkeWebView.SetWindowTitle(const ATitle: string);
begin
  {$IFDEF UNICODE}
  wkeSetWindowTitleW(Self, PChar(ATitle));
  {$ELSE}
  wkeSetWindowTitle(Self, PChar({$IFDEF FPC}ATitle{$ELSE}AnsiToUtf8(ATitle){$ENDIF}));
  {$ENDIF}
end;

procedure wkeWebView.SetOnDownload(callback: wkeDownloadCallback;
  param: Pointer);
begin
  if Assigned(@wkeOnDownload) then
    wkeOnDownload(Self, callback, param);
end;

{ JScript }

class procedure JScript.BindFunction(const AName: string; fn: jsNativeFunction; AArgCount: LongInt);
begin
  wkeJSBindFunction(PAnsiChar(AnsiString({$IFDEF FPC}Utf8ToAnsi(AName){$ELSE}AName{$ENDIF})), fn, AArgCount);
end;

class procedure JScript.BindGetter(const AName: string; fn: jsNativeFunction);
begin
  wkeJSBindGetter(PAnsiChar(AnsiString({$IFDEF FPC}Utf8ToAnsi(AName){$ELSE}AName{$ENDIF})), fn);
end;

class procedure JScript.BindSetter(const AName: string; fn: jsNativeFunction);
begin
  wkeJSBindSetter(PAnsiChar(AnsiString({$IFDEF FPC}Utf8ToAnsi(AName){$ELSE}AName{$ENDIF})), fn);
end;

function JScript.ArgCount: Integer;
begin
  if Assigned(@wkeJSParamCount) then
    Result := wkeJSParamCount(Self)
  else
    Result := 0;
end;

function JScript.ArgType(argIdx: Integer): wkeJSType;
begin
  if Assigned(wkeJSParamType) then
    Result := wkeJSParamType(Self, argIdx)
  else
    Result := JSTYPE_STRING;
end;

procedure JScript.AddRef(v: wkeJSValue);
begin
  wkeJSAddRef(self, v);
end;

function JScript.Arg(argIdx: Integer): wkeJSValue;
begin
  if Assigned(@wkeJSParam) then
    Result := wkeJSParam(Self, argIdx)
  else
    Result := 0;
end;

class function JScript.ArgToString(const wke: JScript; argIdx: Integer): string;
var
  LType: wkeJSType;
  V: wkeJSValue;
begin
  LType := wke.ArgType(argIdx);
  V := wke.Arg(argIdx);
  case LType of
    JSTYPE_NUMBER:
      Result := FloatToStr(wke.ToDouble(V));
    JSTYPE_STRING:
      Result := wke.ToTempString(V);
    JSTYPE_BOOLEAN:
      Result := BoolToStr(wke.ToBoolean(V));
    JSTYPE_OBJECT:
      Result := '(object)';
    JSTYPE_FUNCTION:
      Result := '(function)';
  else
    Result := '(undefined)';
  end;
end;

class procedure JScript.ClearJsValue(es: wkeJSState; var v: wkeJSValue);
begin
  v := es.String_('');
end;

class procedure JScript.SetJsValue(es: wkeJSState; var v: wkeJSValue;
  const Value: Double);
begin
  v := es.Double(value);
end;

class procedure JScript.SetJsValue(es: wkeJSState; var v: wkeJSValue;
  const Value: string);
begin
  v := es.String_(Value);
end;

class procedure JScript.SetJsValue(es: wkeJSState; var v: wkeJSValue;
  const Value: Boolean);
begin
  v := es.Boolean(Value);
end;

class procedure JScript.SetJsValue(es: wkeJSState; var v: wkeJSValue;
  const Value: Int64);
begin
  v := es.Int(Integer(Value));
end;

function JScript.TypeOf(v: wkeJSValue): wkeJSType;
begin
  Result := wkeJSTypeOf({$IFNDEF UseMB2018}Self, {$ENDIF}v);
end;

function JScript.IsNumber(v: wkeJSValue): Boolean;
begin
  Result := wkeJSIsNumber({$IFNDEF UseMB2018}Self, {$ENDIF}v);
end;

function JScript.IsString(v: wkeJSValue): Boolean;
begin
  Result := wkeJSIsString({$IFNDEF UseMB2018}Self, {$ENDIF}v);
end;

function JScript.IsBoolean(v: wkeJSValue): Boolean;
begin
  Result := wkeJSIsBool({$IFNDEF UseMB2018}Self, {$ENDIF}v);
end;

function JScript.IsObject(v: wkeJSValue): Boolean;
begin
  Result := wkeJSIsObject({$IFNDEF UseMB2018}Self, {$ENDIF}v);
end;

function JScript.IsFunction(v: wkeJSValue): Boolean;
begin
  Result := wkeJSIsFunction({$IFNDEF UseMB2018}Self, {$ENDIF}v);
end;

function JScript.IsUndefined(v: wkeJSValue): Boolean;
begin
  Result := wkeJSIsUndefined({$IFNDEF UseMB2018}Self, {$ENDIF}v);
end;

function JScript.IsNull(v: wkeJSValue): Boolean;
begin
  Result := wkeJSIsNull({$IFNDEF UseMB2018}Self, {$ENDIF}v);
end;

function JScript.IsArray(v: wkeJSValue): Boolean;
begin
  Result := wkeJSIsArray({$IFNDEF UseMB2018}Self, {$ENDIF}v);
end;

function JScript.IsTrue(v: wkeJSValue): Boolean;
begin
  Result := wkeJSIsTrue({$IFNDEF UseMB2018}Self, {$ENDIF}v);
end;

function JScript.IsFalse(v: wkeJSValue): Boolean;
begin
  Result := wkeJSIsFalse({$IFNDEF UseMB2018}Self, {$ENDIF}v);
end;

function JScript.ToInt(v: wkeJSValue): Integer;
begin
  Result := wkeJSToInt(Self, v);
end;

function JScript.ToFloat(v: wkeJSValue): Single;
begin
  Result := wkeJSToFloat(Self, v);
end;

function JScript.ToDouble(v: wkeJSValue): Double;
begin
  Result := wkeJSToDouble(Self, v);
end;

function JScript.ToBoolean(v: wkeJSValue): Boolean;
begin
  Result := wkeJSToBool(Self, v);
end;

function JScript.ToTempString(v: wkeJSValue): string;
begin
  {$IFDEF UNICODE}
  Result := wkeJSToTempStringW(Self, v);
  {$ELSE}
  Result := {$IFDEF FPC}wkeJSToTempString(Self, v){$ELSE}Utf8ToAnsi(wkeJSToTempString(Self, v)){$ENDIF};
  {$ENDIF}
end;

function JScript.Int(n: Integer): wkeJSValue;
begin
  Result := wkeJSInt({$IFNDEF UseMB2018}Self, {$ENDIF}n);
end;

function JScript.Float(f: Single): wkeJSValue;
begin
  Result := wkeJSFloat({$IFNDEF UseMB2018}Self, {$ENDIF}f);
end;

function JScript.Double(d: Double): wkeJSValue;
begin
  Result := wkeJSDouble({$IFNDEF UseMB2018}Self, {$ENDIF}d);
end;

function JScript.Boolean(b: Boolean): wkeJSValue;
begin
  Result := wkeJSBool({$IFNDEF UseMB2018}Self, {$ENDIF}b);
end;

function JScript.Undefined: wkeJSValue;
begin
  Result := wkeJSUndefined({$IFNDEF UseMB2018}Self{$ENDIF});
end;

function JScript.Null: wkeJSValue;
begin
  Result := wkeJSNull({$IFNDEF UseMB2018}Self{$ENDIF});
end;

function JScript.True_: wkeJSValue;
begin
  Result := wkeJSTrue({$IFNDEF UseMB2018}Self{$ENDIF});
end;

function JScript.False_: wkeJSValue;
begin
  Result := wkeJSFalse({$IFNDEF UseMB2018}Self{$ENDIF});
end;

function JScript.String_(const AStr: string): wkeJSValue;
begin
{$IFDEF UNICODE}
  Result := wkeJSStringW(Self, PChar(AStr));
{$ELSE}
  Result := wkeJSString(Self, PChar({$IFDEF FPC}AStr{$ELSE}AnsiToUtf8(AStr){$ENDIF}));
{$ENDIF}
end;

function JScript.EmptyObject: wkeJSValue;
begin
  Result := wkeJSEmptyObject(Self);
end;

function JScript.EmptyArray: wkeJSValue;
begin
  Result := wkeJSEmptyArray(Self);
end;

function JScript.Object_(obj: PwkeJSData): wkeJSValue;
begin
  Result := wkeJSObject(Self, obj);
end;

procedure JScript.ReleaseRef(v: wkeJSValue);
begin
  wkeJSReleaseRef(Self, v);
end;

function JScript.Function_(obj: PwkeJSData): wkeJSValue;
begin
  Result := wkeJSFunction(Self, obj);
end;

function JScript.GetData(AObject: wkeJSValue): PwkeJSData;
begin
  Result := wkeJSGetData(Self, AObject);
end;

function JScript.Get(AObject: wkeJSValue; const prop: string): wkeJSValue;
begin
  Result := wkeJSGet(Self, AObject, PAnsiChar(AnsiString({$IFDEF FPC}Utf8ToAnsi(prop){$ELSE}prop{$ENDIF})));
end;

procedure JScript.Set_(AObject: wkeJSValue; const prop: string; v: wkeJSValue);
begin
  wkeJSSet(Self, AObject, PAnsiChar(AnsiString({$IFDEF FPC}Utf8ToAnsi(prop){$ELSE}prop{$ENDIF})), v);
end;

function JScript.GetAt(AObject: wkeJSValue; index: Integer): wkeJSValue;
begin
  Result := wkeJSGetAt(Self, AObject, index);
end;

procedure JScript.SetAt(AObject: wkeJSValue; index: Integer; v: wkeJSValue);
begin
  wkeJSSetAt(Self, AObject, index, v);
end;

function JScript.GetLength(AObject: wkeJSValue): Integer;
begin
  Result := wkeJSGetLength(Self, AObject);
end;

procedure JScript.SetLength(AObject: wkeJSValue; length: Integer);
begin
  wkeJSSetLength(Self, AObject, length);
end;

function JScript.GlobalObject: wkeJSValue;
begin
  Result := wkeJSGlobalObject(Self);
end;

function JScript.GetWebView: wkeWebView;
begin
  Result := wkeJSGetWebView(Self);
end;

function JScript.Eval(const AStr: string): wkeJSValue;
begin
{$IFDEF UNICODE}
  Result := wkeJSEvalW(Self, PChar(AStr));
{$ELSE}
  Result := wkeJSEval(Self, PChar({$IFDEF FPC}AStr{$ELSE}AnsiToUtf8(AStr){$ENDIF}));
{$ENDIF}
end;

function JScript.Call(func: wkeJSValue; thisObject: wkeJSValue; args: PwkeJSValue; argCount: Integer): wkeJSValue;
begin
  Result := wkeJSCall(Self, func, thisObject, args, argCount);
end;

function JScript.CallGlobal(func: wkeJSValue; args: PwkeJSValue; argCount: Integer): wkeJSValue;
begin
  Result := wkeJSCallGlobal(Self, func, args, argCount);
end;

procedure JScript.CollectGarbge;
begin
  wkeJSCollectGarbge;
end;

function JScript.GetGlobal(const prop: string): wkeJSValue;
begin
  Result := wkeJSGetGlobal(Self, PAnsiChar(AnsiString({$IFDEF FPC}Utf8ToAnsi(prop){$ELSE}prop{$ENDIF})));
end;

procedure JScript.SetGlobal(const prop: string; v: wkeJSValue);
begin
  wkeJSSetGlobal(Self, PAnsiChar(AnsiString({$IFDEF FPC}Utf8ToAnsi(prop){$ELSE}prop{$ENDIF})), v);
end;

{$IFDEF MSWINDOWS}
{$WARN SYMBOL_PLATFORM OFF}
// 屏掉浮点异常，暂时没办法的办法
var
  {$IFDEF FPC}uOldFPU, {$ENDIF}uOld8087CW: Word;
{$ENDIF}


initialization
  InitWke();
  {$IFDEF MSWINDOWS}
  uOld8087CW := Default8087CW;
  Set8087CW($133F);
  {$ENDIF}

finalization
  UninitWke();
  {$IFDEF MSWINDOWS}
  Set8087CW(uOld8087CW);
  {$IFDEF FPC}
  SetSSECSR(uOldFPU);
  {$ENDIF FPC}
  {$ENDIF}


end.
