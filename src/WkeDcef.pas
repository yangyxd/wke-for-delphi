{*******************************************************}
{                                                       }
{       Wke Dcef 使用接口统一单元                       }
{                                                       }
{       版权所有 (C) 2017   by YangYxd                  }
{                                                       }
{*******************************************************}

{
  本单元与 wke 无关。
  本单元为 dcef3 的辅助单元，目的是让dcef与wke保持相同的使用方式
  同时本单元对decf3的js绑定做了处理
  本单元需要使用 YxdJson 库
  https://github.com/yangyxd/YxdJson
}

unit WkeDcef;

interface

uses
  YxdJson,
  Windows, Types, SysUtils, Classes, ceflib;

type
  TJsState = class(JSONObject)
  private
    function GetArgCount: Integer;
    function GetArgs: JSONArray;
    procedure SetArgCount(const Value: Integer);
    procedure SetArgs(const Value: JSONArray);
  public
    constructor Create; override;
    function ToInt(const Value: PJSONValue): Integer;
    function Arg(const Index: Integer): PJSONValue;
    property ArgCount: Integer read GetArgCount write SetArgCount;
    property Args: JSONArray read GetArgs write SetArgs;
  end;

  TJsValue = JSONValue;
  TNativeFunction = function (es: TJsState): TJsValue;

  TCefExtension = class(TCefv8HandlerOwn)
  private
    FProc: TNativeFunction;
    es: TJsState;
    rs: TJsValue;
    procedure SyncProc;
  protected
    function Execute(const name: ustring; const obj: ICefv8Value;
      const arguments: TCefv8ValueArray; var retval: ICefv8Value;
      var exception: ustring): Boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

  TCustomRenderProcessHandler = class(TCefRenderProcessHandlerOwn)
  protected
    procedure OnWebKitInitialized; override;
  end;

  wkeJSState = TJsState;
  wkeJSValue = TJsValue;  

  JScript = class
    class function ArgToString(es: TJsState; Index: Integer): string;
    class function BindFunction(const Name: string; const fn: TNativeFunction; ArgCount: Integer = 0): Boolean;

    class procedure ClearJsValue(es: wkeJSState; var v: wkeJSValue);
    class procedure SetJsValue(es: wkeJSState; var v: wkeJSValue; const Value: string); overload;
    class procedure SetJsValue(es: wkeJSState; var v: wkeJSValue; const Value: Double); overload;
    class procedure SetJsValue(es: wkeJSState; var v: wkeJSValue; const Value: Int64); overload;
    class procedure SetJsValue(es: wkeJSState; var v: wkeJSValue; const Value: Boolean); overload;
  end;

type
  TBindFunctionCallBack = procedure (Sneder: TObject);

var
  // 设置此回调函数，绑定Js原生函数
  CefBindFunctionCallBack: TBindFunctionCallBack = nil;

implementation

procedure BindFunctions(Sender: TObject);
begin
  if Assigned(CefBindFunctionCallBack) then
    CefBindFunctionCallBack(Sender);
end; 

{ TCefExtension }

constructor TCefExtension.Create;
begin
  inherited;
  es := TJsState.Create;
end;

destructor TCefExtension.Destroy;
begin
  FreeAndNil(es);
  inherited;
end;

function TCefExtension.Execute(const name: ustring; const obj: ICefv8Value;
  const arguments: TCefv8ValueArray; var retval: ICefv8Value;
  var exception: ustring): Boolean;
var    
  args: JSONArray;
  I: Integer;
begin
  Result := True;
  if Assigned(FProc) then begin
    rs.Clear;
    es.Clear;
    es.ArgCount := Length(arguments);
    args := es.AddChildArray('args');
    for I := 0 to High(arguments) do begin
      if arguments[I].IsInt then
        Args.Add(arguments[I].GetIntValue)
      else if arguments[I].IsDouble then
        Args.Add(arguments[I].GetDoubleValue)
      else if arguments[I].IsBool then
        Args.Add(arguments[I].GetBoolValue)
      else
        Args.Add(arguments[I].GetStringValue);
    end;
    TThread.Synchronize(nil, SyncProc);
    case rs.FType of
      jdtFloat:
        retval := TCefv8ValueRef.NewDouble(rs.AsDouble);
      jdtString, jdtDateTime:
        retval := TCefv8ValueRef.NewString(rs.AsString);
      jdtInteger:
        retval := TCefv8ValueRef.NewInt(rs.AsInteger);
      jdtBoolean:
        retval := TCefv8ValueRef.NewBool(rs.AsBoolean);
    else
      retval := TCefv8ValueRef.NewNull;
    end;
  end else
    Result := False;
end;

procedure TCefExtension.SyncProc;
begin
  rs := FProc(es);
end;

{ TCustomRenderProcessHandler }

procedure TCustomRenderProcessHandler.OnWebKitInitialized;
begin
  BindFunctions(Self);
end;

{ TJsState }

function TJsState.Arg(const Index: Integer): PJSONValue;
begin
  if (Index >= 0) and (Index < ArgCount) then
    Result := Args.Items[index]
  else
    Result := nil;
end;

constructor TJsState.Create;
begin
  inherited Create;
  AddChildArray('args');
end;

function TJsState.GetArgCount: Integer;
begin
  Result := Self.I['argcount'];
end;

function TJsState.GetArgs: JSONArray;
begin
  Result := Self.A['args'];
end;

procedure TJsState.SetArgCount(const Value: Integer);
begin
  Self.I['argcount'] := Value;
end;

procedure TJsState.SetArgs(const Value: JSONArray);
begin
  Self.A['args'].Assign(Value);
end;

function TJsState.ToInt(const Value: PJSONValue): Integer;
begin
  if Assigned(Value) then
    Result := Value.AsInteger
  else
    Result := 0;
end;

{ JScript }

class function JScript.ArgToString(es: TJsState; Index: Integer): string;
var
  Item: PJSONValue;
begin
  if Assigned(es) then begin
    Item := es.Arg(Index);
    if Item <> nil then
      Result := Item.AsString
    else
      Result := '';
  end else
    Result := '';
end;

class function JScript.BindFunction(const Name: string;
  const fn: TNativeFunction; ArgCount: Integer): Boolean;
var
  h: TCefExtension;
  code, args: ustring;
  I: Integer;
begin
  h := TCefExtension.Create();
  h.FProc := fn;
  args := '';
  if ArgCount > 0 then begin
    for I := 0 to ArgCount - 1 do begin
      if I > 0 then
        args := args + ',v' + IntToStr(i)
      else
        args := 'v';
    end;  
  end;
  code := Format('var %s = function(%s) { native function %0:s(); return %0:s(%1:s); };',
    [Name, args]);
  Result := CefRegisterExtension('v8/' + name, code, h);    
end;

class procedure JScript.ClearJsValue(es: wkeJSState; var v: wkeJSValue);
begin
  v.Clear;
end;

class procedure JScript.SetJsValue(es: wkeJSState; var v: wkeJSValue;
  const Value: Double);
begin
  v.AsDouble := Value;
end;

class procedure JScript.SetJsValue(es: wkeJSState; var v: wkeJSValue;
  const Value: string);
begin
  v.AsString := Value;
end;

class procedure JScript.SetJsValue(es: wkeJSState; var v: wkeJSValue;
  const Value: Boolean);
begin
  v.AsBoolean := Value;
end;

class procedure JScript.SetJsValue(es: wkeJSState; var v: wkeJSValue;
  const Value: Int64);
begin
  v.AsInt64 := Value;
end;

initialization
  CefRenderProcessHandler := TCustomRenderProcessHandler.Create;

finalization

end.
