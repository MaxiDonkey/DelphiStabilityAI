unit StabilityAI.Version1.Engines;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

uses
  System.SysUtils, System.Classes, System.Net.Mime, REST.JsonReflect, System.JSON,
  REST.Json.Types, StabilityAI.API, StabilityAI.API.Params, StabilityAI.Async.Support;

type
  /// <summary>
  /// Model specialization.
  /// </summary>
  TTypeKind = (
    AUDIO,
    CLASSIFICATION,
    PICTURE,
    STORAGE,
    TEXT,
    VIDEO
  );

  FTypeKindHelper = record helper for TTypeKind
    function ToString: string;
    class function Create(const Value: string): TTypeKind; static;
  end;

  /// <summary>
  /// Interceptor class for converting <c>TTypeKind</c> values to and from their string representations in JSON serialization and deserialization.
  /// </summary>
  /// <remarks>
  /// This class is used to facilitate the conversion between the <c>TTypeKind</c> enum and its string equivalents during JSON processing.
  /// It extends the <c>TJSONInterceptorStringToString</c> class to override the necessary methods for custom conversion logic.
  /// </remarks>
  TTypeKindInterceptor = class(TJSONInterceptorStringToString)
    /// <summary>
    /// Converts the <c>TTypeKind</c> value of the specified field to a string during JSON serialization.
    /// </summary>
    /// <param name="Data">
    /// The object containing the field to be converted.
    /// </param>
    /// <param name="Field">
    /// The field name representing the <c>TTypeKind</c> value.
    /// </param>
    /// <returns>
    /// The string representation of the <c>TTypeKind</c> value.
    /// </returns>
    function StringConverter(Data: TObject; Field: string): string; override;
    /// <summary>
    /// Converts a string back to a <c>TTypeKind</c> value for the specified field during JSON deserialization.
    /// </summary>
    /// <param name="Data">
    /// The object containing the field to be set.
    /// </param>
    /// <param name="Field">
    /// The field name where the <c>TTypeKind</c> value will be set.
    /// </param>
    /// <param name="Arg">
    /// The string representation of the <c>TTypeKind</c> to be converted back.
    /// </param>
    /// <remarks>
    /// This method converts the string argument back to the corresponding <c>TTypeKind</c> value and assigns it to the specified field in the object.
    /// </remarks>
    procedure StringReverter(Data: TObject; Field: string; Arg: string); override;
  end;

  /// <summary>
  /// Represents an engine with its unique identifier, name, description, and type.
  /// </summary>
  /// <remarks>
  /// The <c>TEngine</c> class encapsulates metadata about an engine, including its unique identifier,
  /// display name, description, and the type of content it produces.
  /// It is commonly used for managing engine information within StabilityAI integrations.
  /// </remarks>
  TEngine = class
  private
    FId: string;
    FName: string;
    FDescription: string;
    [JsonReflectAttribute(ctString, rtString, TTypeKindInterceptor)]
    FType: TTypeKind;
  public
    /// <summary>
    /// Unique identifier for the engine
    /// </summary>
    property Id: string read FId write FId;
    /// <summary>
    /// Name of the engine
    /// </summary>
    property Name: string read FName write FName;
    /// <summary>
    /// Description of th model
    /// </summary>
    property Description: string read FDescription write FDescription;
    /// <summary>
    /// The type of content this engine produces
    /// </summary>
    /// <remarks>
    /// Enum: <c>AUDIO</c>, <c>CLASSIFICATION</c>, <c>PICTURE</c>, <c>STORAGE</c>, <c>TEXT</c>, <c>VIDEO</c>
    /// </remarks>
    property &Type: TTypeKind read FType write FType;
  end;

  /// <summary>
  /// Represents a collection of engines.
  /// </summary>
  /// <remarks>
  /// The <c>TEngines</c> class is a container for multiple <c>TEngine</c> instances.
  /// It is typically used to store and manage the results of queries or operations that retrieve multiple engines.
  /// </remarks>
  TEngines = class
  private
    FResult: TArray<TEngine>;
  public
    /// <summary>
    /// Gets or sets the array of engines contained in this collection.
    /// </summary>
    /// <remarks>
    /// The <c>Result</c> property provides access to the list of <c>TEngine</c> objects stored in this collection.
    /// Each object in the array represents an individual engine with its respective metadata.
    /// </remarks>
    property Result: TArray<TEngine> read FResult write FResult;
  end;

  /// <summary>
  /// Manages asynchronous callBacks for a request using <c>TEngines</c> as the response type.
  /// </summary>
  /// <remarks>
  /// The <c>TAsynEngines</c> type extends the <c>TAsynParams&lt;TEngines&gt;</c> record to handle the lifecycle of an asynchronous chat operation.
  /// It provides event handlers that trigger at various stages, such as when the operation starts, completes successfully, or encounters an error.
  /// This structure facilitates non-blocking chat operations and is specifically tailored for scenarios where multiple choices from a chat model are required.
  /// </remarks>
  TAsynEngines = TAsynCallBack<TEngines>;

  TEnginesRoute = class(TStabilityAIAPIRoute)
    function List: TEngines; overload;
    procedure List(CallBacks: TFunc<TAsynEngines>); overload;
  end;

implementation

uses
  System.StrUtils, System.Rtti, Rest.Json;

{ FTypeKindHelper }

class function FTypeKindHelper.Create(const Value: string): TTypeKind;
begin
  var index := IndexStr(Value.ToUpper, ['AUDIO', 'CLASSIFICATION', 'PICTURE', 'STORAGE', 'TEXT', 'VIDEO']);
  if index = -1 then
    raise Exception.Create('Type kind unknown.');
  Result := TTypeKind(index);
end;

function FTypeKindHelper.ToString: string;
begin
  case Self of
    AUDIO:
      Exit('AUDIO');
    CLASSIFICATION:
      Exit('CLASSIFICATION');
    PICTURE:
      Exit('PICTURE');
    STORAGE:
      Exit('STORAGE');
    TEXT:
      Exit('TEXT');
    VIDEO:
      Exit('VIDEO');
  end;
end;

{ TTypeKindInterceptor }

function TTypeKindInterceptor.StringConverter(Data: TObject; Field: string): string;
begin
  Result := RTTI.GetType(Data.ClassType).GetField(Field).GetValue(Data).AsType<TTypeKind>.ToString;
end;

procedure TTypeKindInterceptor.StringReverter(Data: TObject; Field, Arg: string);
begin
  RTTI.GetType(Data.ClassType).GetField(Field).SetValue(Data, TValue.From(TTypeKind.Create(Arg)));
end;

{ TEnginesRoute }

procedure TEnginesRoute.List(CallBacks: TFunc<TAsynEngines>);
begin
  with TAsynCallBackExec<TAsynEngines, TEngines>.Create(CallBacks) do
  try
    Sender := Use.Param.Sender;
    OnStart := Use.Param.OnStart;
    OnSuccess := Use.Param.OnSuccess;
    OnError := Use.Param.OnError;
    Run(
      function: TEngines
      begin
        Result := Self.List;
      end);
  finally
    Free;
  end;
end;

function TEnginesRoute.List: TEngines;
begin
  Result := API.GetArray<TEngines>('v1/engines/list');
end;

end.
