unit StabilityAI.API;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

uses
  System.Classes, System.Net.HttpClient, System.Net.URLClient, System.Net.Mime,
  System.JSON, StabilityAI.Errors, StabilityAI.API.Params, System.SysUtils;

type
  TModelDataReturned = class abstract
  private
    FContentType: string;
    FData: TBytes;
  public
    property Data: TBytes read FData write FData;
    property ContentType: string read FContentType write FContentType;
  end;

  /// <summary>
  /// See at https://console.StabilityAI.com/docs/errors
  /// </summary>
  StabilityAIException = class(Exception)
  private
    FCode: Int64;
    FId: string;
    FName: string;
    FErrors: string;
  public
    constructor Create(const ACode: Int64; const AError: TErrorCore); reintroduce; overload;
    constructor Create(const ACode: Int64; const Value: string); reintroduce; overload;
    property Code: Int64 read FCode write FCode;
    property Id: string read FId write FId;
    property Name: string read FName write FName;
    property Errors: string read FErrors write FErrors;
  end;

  StabilityAIExceptionAPI = class(Exception);

  /// <summary>
  /// The server could not understand the request due to invalid syntax.
  /// Review the request format and ensure it is correct.
  /// </summary>
  StabilityAIExceptionBadRequestError = class(StabilityAIException);

  /// <summary>
  /// The request lacks the required 'Authorization' header, which is needed to authenticate access.
  /// </summary>
  StabilityAIExceptionUnauthorizedError = class(StabilityAIException);

  /// <summary>
  /// The specified engine (ID some-fake-engine) was not found.
  /// </summary>
  StabilityAIExceptionNotFoundError = class(StabilityAIException);

  /// <summary>
  /// The request was well-formed but could not be followed due to semantic errors.
  /// Verify the data provided for correctness and completeness.
  /// </summary>
  StabilityAIExceptionInvalidLanguageError = class(StabilityAIException);

  /// <summary>
  /// Too many requests were sent in a given timeframe. Implement request throttling and respect rate limits.
  /// </summary>
  StabilityAIExceptionRateLimitExceededError = class(StabilityAIException);

  /// <summary>
  /// The request was not successful because it lacks valid authentication credentials for the requested resource.
  /// Ensure the request includes the necessary authentication credentials and the api key is valid.
  /// </summary>
  StabilityAIExceptionContentModerationError = class(StabilityAIException);

  /// <summary>
  /// The requested resource could not be found. Check the request URL and the existence of the resource.
  /// </summary>
  StabilityAIExceptionPayloadTooLargeError = class(StabilityAIException);

  /// <summary>
  /// A generic error occurred on the server. Try the request again later or contact support if the issue persists.
  /// </summary>
  StabilityAIExceptionInternalServerError = class(StabilityAIException);

  StabilityAIExceptionInvalidResponse = class(StabilityAIException);

  TStabilityAIAPI = class
  public
    const
      URL_BASE = 'https://api.stability.ai';
  private
    FToken: string;
    FBaseUrl: string;
    FClientId: string;
    FClientUserId: string;
    FClientVersion: string;
    FCustomHeaders: TNetHeaders;

    procedure SetToken(const Value: string);
    procedure SetBaseUrl(const Value: string);
    procedure RaiseError(Code: Int64; Error: TErrorCore);
    procedure ParseError(const Code: Int64; const ResponseText: string);
    procedure SetCustomHeaders(const Value: TNetHeaders);
    procedure SetClientId(const Value: string);
    procedure SetClientUserId(const Value: string);
    procedure SetClientVersion(const Value: string);
  protected
    function GetHeaderValue(const KeyName: string; const Value: TNetHeaders): string;
    function GetHeaders: TNetHeaders; virtual;
    function GetClient: THTTPClient; virtual;
    function GetRequestURL(const Path: string): string;
    function Get(const Path: string; Response: TStringStream; var ResponseHeader: TNetHeaders): Integer; overload;
    function Get(const Path: string; Response: TStringStream): Integer; overload;
    function Delete(const Path: string; Response: TStringStream): Integer; overload;
    function Post(const Path: string; Response: TStringStream): Integer; overload;
    function Post(const Path: string; Body: TJSONObject; Response: TStringStream; OnReceiveData: TReceiveDataCallback = nil): Integer; overload;
    function Post(const Path: string; Body: TMultipartFormData; Response: TStringStream; var ResponseHeader: TNetHeaders): Integer; overload;
    function ParseResponse<T: class, constructor>(const Code: Int64; const ResponseText: string): T; overload;
    function ParseResponse<T: class, constructor>(const Code: Int64; const Response: TStringStream; const ResponseHeader: TNetHeaders): T; overload;
    function ParseResponse<T: class, constructor>(const Response: TBytes; const ResponseHeader: TNetHeaders): T; overload;
    procedure CheckAPI;
  public
    function GetArray<TResult: class, constructor>(const Path: string): TResult;
    function Get<TResult: class, constructor>(const Path: string): TResult; overload;
    function Get<TResult: class, constructor; TParams: TJSONParam>(const Path: string; ParamProc: TProc<TParams>): TResult; overload;
    procedure GetFile(const Path: string; Response: TStream); overload;
    function Delete<TResult: class, constructor>(const Path: string): TResult; overload;
    function Post<TParams: TJSONParam>(const Path: string; ParamProc: TProc<TParams>; Response: TStringStream; Event: TReceiveDataCallback = nil): Boolean; overload;
    function Post<TResult: class, constructor; TParams: TJSONParam>(const Path: string; ParamProc: TProc<TParams>): TResult; overload;
    procedure Post<TParams: TJSONParam>(const Path: string; ParamProc: TProc<TParams>; Response: TStream; Event: TReceiveDataCallback = nil); overload;       //AJOUT
    function Post<TResult: class, constructor>(const Path: string): TResult; overload;
    function PostForm<TResult: class, constructor; TParams: TMultipartFormData, constructor>(const Path: string; ParamProc: TProc<TParams>): TResult; overload;
    function PostForm<TResult: class, constructor; TParams: TMultipartFormData, constructor>(const Path: string; ParamProc: TProc<TParams>;
      var ResponseHeader: TNetHeaders): TResult; overload;
  public
    constructor Create; overload;
    constructor Create(const AToken: string); overload;
    destructor Destroy; override;
    property Token: string read FToken write SetToken;
    property BaseUrl: string read FBaseUrl write SetBaseUrl;
    property ClientId: string read FClientId write SetClientId;
    property ClientUserId: string read FClientUserId write SetClientUserId;
    property ClientVersion: string read FClientVersion write SetClientVersion;
    property CustomHeaders: TNetHeaders read FCustomHeaders write SetCustomHeaders;
  end;

  TStabilityAIAPIRoute = class
  private
    FAPI: TStabilityAIAPI;
    procedure SetAPI(const Value: TStabilityAIAPI);
  public
    property API: TStabilityAIAPI read FAPI write SetAPI;
    constructor CreateRoute(AAPI: TStabilityAIAPI); reintroduce;
  end;

implementation

uses
  REST.Json, System.NetConsts;

constructor TStabilityAIAPI.Create;
begin
  inherited;
  FToken := '';
  FBaseUrl := URL_BASE;
end;

constructor TStabilityAIAPI.Create(const AToken: string);
begin
  Create;
  Token := AToken;
end;

destructor TStabilityAIAPI.Destroy;
begin
  inherited;
end;

function TStabilityAIAPI.Post(const Path: string; Body: TJSONObject; Response: TStringStream; OnReceiveData: TReceiveDataCallback): Integer;
var
  Headers: TNetHeaders;
  Stream: TStringStream;
  Client: THTTPClient;
begin
  CheckAPI;
  Client := GetClient;
  try
    Headers := GetHeaders + [TNetHeader.Create('Content-Type', 'application/json')];
    Stream := TStringStream.Create;
    Client.ReceiveDataCallBack := OnReceiveData;
    try
      Stream.WriteString(Body.ToJSON);
      Stream.Position := 0;
      Result := Client.Post(GetRequestURL(Path), Stream, Response, Headers).StatusCode;
    finally
      Client.ReceiveDataCallBack := nil;
      Stream.Free;
    end;
  finally
    Client.Free;
  end;
end;

function TStabilityAIAPI.Get(const Path: string; Response: TStringStream; var ResponseHeader: TNetHeaders): Integer;
var
  Client: THTTPClient;
begin
  CheckAPI;
  Client := GetClient;
  try
    var Data := Client.Get(GetRequestURL(Path), Response, GetHeaders);
    ResponseHeader := Data.Headers;
    Result := Data.StatusCode;
  finally
    Client.Free;
  end;
end;

function TStabilityAIAPI.Get(const Path: string;
  Response: TStringStream): Integer;
var
  ResponseHeader: TNetHeaders;
begin
  Result := Get(Path, Response, ResponseHeader);
end;

function TStabilityAIAPI.Post(const Path: string; Body: TMultipartFormData; Response: TStringStream;
  var ResponseHeader: TNetHeaders): Integer;
var
  Client: THTTPClient;
begin
  CheckAPI;
  Client := GetClient;
  try
    var PostResult := Client.Post(GetRequestURL(Path), Body, Response, GetHeaders);
    ResponseHeader := PostResult.Headers;
    Result := PostResult.StatusCode;
  finally
    Client.Free;
  end;
end;

function TStabilityAIAPI.Post(const Path: string; Response: TStringStream): Integer;
var
  Client: THTTPClient;
begin
  CheckAPI;
  Client := GetClient;
  try
    Result := Client.Post(GetRequestURL(Path), TStream(nil), Response, GetHeaders).StatusCode;
  finally
    Client.Free;
  end;
end;

procedure TStabilityAIAPI.Post<TParams>(const Path: string; ParamProc: TProc<TParams>; Response: TStream; Event: TReceiveDataCallback);
var
  Params: TParams;
  Code: Integer;
  Headers: TNetHeaders;
  Stream, Strings: TStringStream;
  Client: THTTPClient;
begin
  Params := TParams.Create;
  try
    if Assigned(ParamProc) then
      ParamProc(Params);

    CheckAPI;
    Client := GetClient;
    try
      Client.ReceiveDataCallBack := Event;
      Headers := GetHeaders + [TNetHeader.Create('Content-Type', 'application/json')];
      Stream := TStringStream.Create;
      try
        Stream.WriteString(Params.JSON.ToJSON);
        Stream.Position := 0;
        Code := Client.Post(GetRequestURL(Path), Stream, Response, Headers).StatusCode;
        case Code of
          200..299:
            ; {success}
        else
          Strings := TStringStream.Create;
          try
            Response.Position := 0;
            Strings.LoadFromStream(Response);
            ParseError(Code, Strings.DataString);
          finally
            Strings.Free;
          end;
        end;
      finally
        Client.ReceiveDataCallBack := nil;
        Stream.Free;
      end;
    finally
      Client.Free;
    end;
  finally
    Params.Free;
  end;
end;

function TStabilityAIAPI.Post<TResult, TParams>(const Path: string; ParamProc: TProc<TParams>): TResult;
var
  Response: TStringStream;
  Params: TParams;
  Code: Integer;
begin
  Response := TStringStream.Create('', TEncoding.UTF8);
  Params := TParams.Create;
  try
    if Assigned(ParamProc) then
      ParamProc(Params);
    Code := Post(Path, Params.JSON, Response);
    Result := ParseResponse<TResult>(Code, Response.DataString);
  finally
    Params.Free;
    Response.Free;
  end;
end;

function TStabilityAIAPI.Post<TParams>(const Path: string; ParamProc: TProc<TParams>; Response: TStringStream; Event: TReceiveDataCallback): Boolean;
var
  Params: TParams;
  Code: Integer;
begin
  Params := TParams.Create;
  try
    if Assigned(ParamProc) then
      ParamProc(Params);
    Code := Post(Path, Params.JSON, Response, Event);
    case Code of
      200..299:
        Result := True;
    else
      Result := False;
    end;
  finally
    Params.Free;
  end;
end;

function TStabilityAIAPI.Post<TResult>(const Path: string): TResult;
var
  Response: TStringStream;
  Code: Integer;
begin
  Response := TStringStream.Create('', TEncoding.UTF8);
  try
    Code := Post(Path, Response);
    Result := ParseResponse<TResult>(Code, Response.DataString);
  finally
    Response.Free;
  end;
end;

function TStabilityAIAPI.Delete(const Path: string; Response: TStringStream): Integer;
var
  Client: THTTPClient;
begin
  CheckAPI;
  Client := GetClient;
  try
    Result := Client.Delete(GetRequestURL(Path), Response, GetHeaders).StatusCode;
  finally
    Client.Free;
  end;
end;

function TStabilityAIAPI.Delete<TResult>(const Path: string): TResult;
var
  Response: TStringStream;
  Code: Integer;
begin
  Response := TStringStream.Create('', TEncoding.UTF8);
  try
    Code := Delete(Path, Response);
    Result := ParseResponse<TResult>(Code, Response.DataString);
  finally
    Response.Free;
  end;
end;

function TStabilityAIAPI.PostForm<TResult, TParams>(const Path: string;
  ParamProc: TProc<TParams>; var ResponseHeader: TNetHeaders): TResult;
begin
  var Response := TStringStream.Create('', TEncoding.UTF8);
  var Params := TParams.Create;
  try
    if Assigned(ParamProc) then
      ParamProc(Params);
    var Code := Post(Path, Params, Response, ResponseHeader);
    Result := ParseResponse<TResult>(Code, Response, ResponseHeader);
  finally
    Params.Free;
    Response.Free;
  end;
end;

function TStabilityAIAPI.PostForm<TResult, TParams>(const Path: string; ParamProc: TProc<TParams>): TResult;
var
  ResponseHeader: TNetHeaders;
begin
  if not TResult.inheritsFrom(TModelDataReturned) then
    CustomHeaders := [TNetHeader.Create('accept', 'application/json')];
  Result := PostForm<TResult, TParams>(Path, ParamProc, ResponseHeader);
end;

function TStabilityAIAPI.Get<TResult, TParams>(const Path: string; ParamProc: TProc<TParams>): TResult;
var
  Response: TStringStream;
  Params: TParams;
  Code: Integer;
begin
  Response := TStringStream.Create('', TEncoding.UTF8);
  Params := TParams.Create;
  try
    if Assigned(ParamProc) then
      ParamProc(Params);
    var Pairs: TArray<string> := [];
    for var Pair in Params.ToStringPairs do
      Pairs := Pairs + [Pair.Key + '=' + Pair.Value];
    var QPath := Path;
    if Length(Pairs) > 0 then
      QPath := QPath + '?' + string.Join('&', Pairs);
    Code := Get(QPath, Response);
    Result := ParseResponse<TResult>(Code, Response.DataString);
  finally
    Params.Free;
    Response.Free;
  end;
end;

function TStabilityAIAPI.Get<TResult>(const Path: string): TResult;
var
  Response: TStringStream;
  Code: Integer;
begin
  CustomHeaders := [TNetHeader.Create('accept', 'application/json')];
  Response := TStringStream.Create('', TEncoding.UTF8);
  try
    Code := Get(Path, Response);
    Result := ParseResponse<TResult>(Code, Response.DataString);
  finally
    Response.Free;
  end;
end;

function TStabilityAIAPI.GetArray<TResult>(const Path: string): TResult;
var
  Response: TStringStream;
  Code: Integer;
begin
  CustomHeaders := [TNetHeader.Create('accept', 'application/json')];
  Response := TStringStream.Create('', TEncoding.UTF8);
  try
    Code := Get(Path, Response);
    var Data := Response.DataString.Trim([#10]);
    if Data.StartsWith('[') then
      Data := Format('{"result":%s}', [Data]);
    Result := ParseResponse<TResult>(Code, Data);
  finally
    Response.Free;
  end;
end;

function TStabilityAIAPI.GetClient: THTTPClient;
begin
  Result := THTTPClient.Create;
  Result.AcceptCharSet := 'utf-8';
end;

procedure TStabilityAIAPI.GetFile(const Path: string; Response: TStream);
var
  Code: Integer;
  Strings: TStringStream;
  Client: THTTPClient;
begin
  CheckAPI;
  Client := GetClient;
  try
    Code := Client.Get(GetRequestURL(Path), Response, GetHeaders).StatusCode;
    case Code of
      200..299:
        ; {success}
    else
      Strings := TStringStream.Create;
      try
        Response.Position := 0;
        Strings.LoadFromStream(Response);
        ParseError(Code, Strings.DataString);
      finally
        Strings.Free;
      end;
    end;
  finally
    Client.Free;
  end;
end;

function TStabilityAIAPI.GetHeaders: TNetHeaders;
begin
  Result := [TNetHeader.Create('authorization', 'Bearer ' + FToken)] + FCustomHeaders;
  if not FClientId.IsEmpty then
    Result := Result + [TNetHeader.Create('stability-client-id', FClientId)];
  if not FClientUserId.IsEmpty then
    Result := Result + [TNetHeader.Create('stability-client-user-id', FClientUserId)];
  if not FClientVersion.IsEmpty then
    Result := Result + [TNetHeader.Create('stability-client-version', FClientVersion)];
end;

function TStabilityAIAPI.GetHeaderValue(const KeyName: string;
  const Value: TNetHeaders): string;
begin
  for var Item in Value do
    if Item.Name.ToLower = KeyName.ToLower then
      begin
        Result := Item.Value;
        Break;
      end;
end;

function TStabilityAIAPI.GetRequestURL(const Path: string): string;
begin
  Result := Format('%s/%s', [FBaseURL, Path]);
end;

procedure TStabilityAIAPI.CheckAPI;
begin
  if FToken.IsEmpty then
    raise StabilityAIExceptionAPI.Create('Token is empty!');
  if FBaseUrl.IsEmpty then
    raise StabilityAIExceptionAPI.Create('Base url is empty!');
end;

procedure TStabilityAIAPI.RaiseError(Code: Int64; Error: TErrorCore);
begin
  case Code of
    {--- Client Error Codes }
    400:
      raise StabilityAIExceptionBadRequestError.Create(Code, Error);
    401:
      raise StabilityAIExceptionUnauthorizedError.Create(Code, Error);
    403:
      raise StabilityAIExceptionContentModerationError.Create(Code, Error);
    404:
      raise StabilityAIExceptionNotFoundError.Create(Code, Error);
    413:
      raise StabilityAIExceptionPayloadTooLargeError.Create(Code, Error);
    422:
      raise StabilityAIExceptionInvalidLanguageError.Create(Code, Error);
    429:
      raise StabilityAIExceptionRateLimitExceededError.Create(Code, Error);
    {--- Server Error Codes }
    500:
      raise StabilityAIExceptionInternalServerError.Create(Code, Error);
  else
    raise StabilityAIException.Create(Code, Error);
  end;
end;

procedure TStabilityAIAPI.ParseError(const Code: Int64; const ResponseText: string);
var
  Error: TErrorCore;
begin
  Error := nil;
  try
    try
      Error := TJson.JsonToObject<TError>(ResponseText);
    except
      Error := nil;
    end;
    if Assigned(Error) and Assigned(Error) then
      RaiseError(Code, Error)
  finally
    if Assigned(Error) then
      Error.Free;
  end;
end;

function TStabilityAIAPI.ParseResponse<T>(const Response: TBytes;
  const ResponseHeader: TNetHeaders): T;
begin
  Result := T.Create;
  with Result as TModelDataReturned do
    begin
      FData := Response;
      FContentType := GetHeaderValue('content-type', ResponseHeader).ToLower;
    end;
end;

function TStabilityAIAPI.ParseResponse<T>(const Code: Int64;
  const Response: TStringStream; const ResponseHeader: TNetHeaders): T;
begin
  if not T.InheritsFrom(TModelDataReturned) then
    Result := ParseResponse<T>(Code, Response.DataString)
  else
    Result := ParseResponse<T>(Response.Bytes, ResponseHeader);
end;

function TStabilityAIAPI.ParseResponse<T>(const Code: Int64; const ResponseText: string): T;
begin
  Result := nil;
  case Code of
    200..299:
      try
        Result := TJson.JsonToObject<T>(ResponseText)
      except
        FreeAndNil(Result);
      end;
  else
    ParseError(Code, ResponseText);
  end;
  if not Assigned(Result) then
    raise StabilityAIExceptionInvalidResponse.Create(Code, 'Empty or invalid response');
end;

procedure TStabilityAIAPI.SetBaseUrl(const Value: string);
begin
  FBaseUrl := Value;
end;

procedure TStabilityAIAPI.SetClientId(const Value: string);
begin
  if Value.Length > 256 then
    raise Exception.CreateFmt('stability-client-id length must be lower than 256 chars : (%d)', [Value.Length]);
  FClientId := Value;
end;

procedure TStabilityAIAPI.SetClientUserId(const Value: string);
begin
  if Value.Length > 256 then
    raise Exception.CreateFmt('stability-client-user-id length must be lower than 256 chars : (%d)', [Value.Length]);
  FClientUserId := Value;
end;

procedure TStabilityAIAPI.SetClientVersion(const Value: string);
begin
  if Value.Length > 256 then
    raise Exception.CreateFmt('stability-client-version length must be lower than 256 chars : (%d)', [Value.Length]);
  FClientVersion := Value;
end;

procedure TStabilityAIAPI.SetCustomHeaders(const Value: TNetHeaders);
begin
  FCustomHeaders := Value;
end;

procedure TStabilityAIAPI.SetToken(const Value: string);
begin
  FToken := Value;
end;

{ TStabilityAIAPIRoute }

constructor TStabilityAIAPIRoute.CreateRoute(AAPI: TStabilityAIAPI);
begin
  inherited Create;
  FAPI := AAPI;
end;

procedure TStabilityAIAPIRoute.SetAPI(const Value: TStabilityAIAPI);
begin
  FAPI := Value;
end;

{ StabilityAIException }

constructor StabilityAIException.Create(const ACode: Int64; const Value: string);
begin
  Code := ACode;
  inherited Create(Format('error %d: %s', [ACode, Value]));
end;

constructor StabilityAIException.Create(const ACode: Int64; const AError: TErrorCore);
begin
  Code := ACode;
  Id := (AError as TError).Id;
  Name := (AError as TError).Name;
  Errors := Errors.Join(#10, (AError as TError).Errors);
  inherited Create(Format('error (%d) - type %s'+ sLineBreak + '%s', [Code, Name, Errors]));
end;

end.

