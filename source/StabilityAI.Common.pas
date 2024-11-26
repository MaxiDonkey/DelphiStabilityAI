unit StabilityAI.Common;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

uses
  System.SysUtils, System.Classes, System.Net.Mime, REST.JsonReflect, System.JSON,
  REST.Json.Types, StabilityAI.API.Params, StabilityAI.Types, StabilityAI.Async.Support;

type
  /// <summary>
  /// The reason the model stopped generating tokens.
  /// </summary>
  TFinishReason = (
    /// <summary>
    /// successful generation.
    /// </summary>
    SUCCESS,
    /// <summary>
    /// Successful generation, however the output violated our content moderation policy and has been blurred as a result.
    /// </summary>
    CONTENT_FILTERED,
    /// <summary>
    /// Only with version 1
    /// </summary>
    ERROR
  );

  TFinishReasonHelper = record helper for TFinishReason
    function ToString: string;
    class function create(const Value: string): TFinishReason; static;
  end;

  /// <summary>
  /// Interceptor class for converting <c>TFinishReason</c> values to and from their string representations in JSON serialization and deserialization.
  /// </summary>
  /// <remarks>
  /// This class is used to facilitate the conversion between the <c>TFinishReason</c> enum and its string equivalents during JSON processing.
  /// It extends the <c>TJSONInterceptorStringToString</c> class to override the necessary methods for custom conversion logic.
  /// </remarks>
  TFinishReasonInterceptor = class(TJSONInterceptorStringToString)
    /// <summary>
    /// Converts the <c>TFinishReason</c> value of the specified field to a string during JSON serialization.
    /// </summary>
    /// <param name="Data">
    /// The object containing the field to be converted.
    /// </param>
    /// <param name="Field">
    /// The field name representing the <c>TFinishReason</c> value.
    /// </param>
    /// <returns>
    /// The string representation of the <c>TFinishReason</c> value.
    /// </returns>
    function StringConverter(Data: TObject; Field: string): string; override;
    /// <summary>
    /// Converts a string back to a <c>TFinishReason</c> value for the specified field during JSON deserialization.
    /// </summary>
    /// <param name="Data">
    /// The object containing the field to be set.
    /// </param>
    /// <param name="Field">
    /// The field name where the <c>TFinishReason</c> value will be set.
    /// </param>
    /// <param name="Arg">
    /// The string representation of the <c>TFinishReason</c> to be converted back.
    /// </param>
    /// <remarks>
    /// This method converts the string argument back to the corresponding <c>TFinishReason</c> value and assigns it to the specified field in the object.
    /// </remarks>
    procedure StringReverter(Data: TObject; Field: string; Arg: string); override;
  end;

  /// <summary>
  /// The <c>TStableImageCommon</c> class inherits from the <c>TMultipartFormData</c> class.
  /// </summary>
  /// <remarks>
  /// The base class <c>TMultipartFormData</c> is enriched with the following methods:
  /// <para>
  /// - function Prompt(const Value: string)
  /// </para>
  /// <para>
  /// - function NegativePrompt(const Value: string)
  /// </para>
  /// <para>
  /// - function Seed(const Value: Int64)
  /// </para>
  /// <para>
  /// - function OutputFormat(const Value: TOutPutFormat)
  /// </para>
  /// </remarks>
  TStableImageCommon = class(TMultipartFormData)
    /// <summary>
    /// What you wish to see in the output image. A strong, descriptive prompt that clearly defines elements, colors, and subjects will lead to better results.
    /// </summary>
    /// <param name="Value">
    /// [1 .. 10000] characters
    /// </param>
    /// <remarks>
    /// To control the weight of a given word use the format (word:weight), where word is the word you'd like to control the weight of and weight is a value between 0 and 1.
    /// <para>
    /// - For example: The sky was a crisp (blue:0.3) and (green:0.8) would convey a sky that was blue and green, but more green than blue.
    /// </para>
    /// </remarks>
    function Prompt(const Value: string): TStableImageCommon;
    /// <summary>
    /// A blurb of text describing what you do not wish to see in the output image.
    /// </summary>
    /// <param name="Value">
    /// [1 .. 10000] characters
    /// </param>
    /// <remarks>
    /// This is an advanced feature.
    /// </remarks>
    function NegativePrompt(const Value: string): TStableImageCommon;
    /// <summary>
    /// A specific value that is used to guide the 'randomness' of the generation
    /// </summary>
    /// <param name="Value">
    /// number [0 .. 4294967294]  (Default: 0)
    /// </param>
    /// <remarks>
    /// Omit this parameter or pass 0 to use a random seed.
    /// </remarks>
    function Seed(const Value: Int64): TStableImageCommon;
    /// <summary>
    /// Dictates the content-type of the generated image.
    /// </summary>
    /// <param name="Value">
    /// Enum: <c>jpeg</c>, <c>png</c>, <c>webp</c>
    /// </param>
    function OutputFormat(const Value: TOutPutFormat): TStableImageCommon;
  end;

  /// <summary>
  /// The <c>TStableImageRatio</c> class inherits from the <c>TStableImageCommon</c> class.
  /// </summary>
  /// <remarks>
  /// The base class <c>TStableImageCommon</c> is enriched with the following methods:
  /// <para>
  /// - function AspectRatio(const Value: TAspectRatioType)
  /// </para>
  /// </remarks>
  TStableImageRatio = class(TStableImageCommon)
    /// <summary>
    /// Controls the aspect ratio of the generated image.
    /// </summary>
    /// <param name="Value">
    /// Enum: 16:9, 1:1, 21:9, 2:3, 3:2, 4:5, 5:4, 9:16, 9:21
    /// </param>
    /// <remarks>
    /// Default: 1:1
    /// </remarks>
    function AspectRatio(const Value: TAspectRatioType): TStableImageRatio;
  end;

  /// <summary>
  /// The <c>TEditCommon</c> class inherits from the <c>TMultipartFormData</c> class.
  /// </summary>
  /// <remarks>
  /// The base class <c>TMultipartFormData</c> is enriched with the following methods:
  /// <para>
  /// - function Image(const FilePath: string)
  /// </para>
  /// <para>
  /// - function Image(const Stream: TStream; StreamFreed: Boolean = False)
  /// </para>
  /// <para>
  /// - function OutputFormat(const Value: TOutPutFormat)
  /// </para>
  /// </remarks>
  TEditCommon = class(TMultipartFormData)
    /// <summary>
    /// The image to use as the starting point for the generation.
    /// </summary>
    /// <param name="FilePath">
    /// Filename with supported format (jpeg, png, webp)
    /// </param>
    /// <remarks>
    /// <para>
    /// - Width must be between 64 and 16,384 pixels
    /// </para>
    /// <para>
    /// - Height must be between 64 and 16,384 pixels
    /// </para>
    /// <para>
    /// - Total pixel count must be at least 4,096 pixels
    /// </para>
    /// <para>
    /// - IMPORTANT: The strength parameter is required when image is provided.
    /// </para>
    /// </remarks>
    function Image(const FilePath: string): TEditCommon; overload;
    /// <summary>
    /// Adds an image to be used as the starting point for the generation process, provided as a stream.
    /// </summary>
    /// <param name="Stream">
    /// The image data in the form of a TStream. The stream must contain the image data in a supported format (e.g., JPEG, PNG, WEBP).
    /// </param>
    /// <param name="StreamFreed">
    /// A boolean value indicating whether the stream should be automatically freed after being processed.
    /// <para>
    /// - Set to <c>True</c> to allow the method to free the stream automatically after reading its contents.
    /// </para>
    /// <para>
    /// - Set to <c>False</c> if you want to manage the lifetime of the stream yourself.
    /// </para>
    /// </param>
    /// <remarks>
    /// <para>
    /// This method is useful when you already have image data in memory, as opposed to working with a file directly.
    /// </para>
    /// <para>
    /// - The image dimensions must meet the following criteria:
    ///   - Width: Between 64 and 16,384 pixels.
    ///   - Height: Between 64 and 16,384 pixels.
    ///   - Total pixel count must be at least 4,096 pixels.
    /// </para>
    /// <para>
    /// - A strength parameter is required when an image is provided for editing.
    /// </para>
    /// </remarks>
    /// <exception cref="Exception">
    /// Throws an exception if the stream is invalid or its contents do not represent a valid image in a supported format.
    /// </exception>
    function Image(const Stream: TStream; StreamFreed: Boolean = False): TEditCommon; overload;
    /// <summary>
    /// Dictates the content-type of the generated image.
    /// </summary>
    /// <param name="Value">
    /// Enum: <c>jpeg</c> <c>png webp</c>
    /// </param>
    function OutputFormat(const Value: TOutPutFormat): TEditCommon;
  end;

  /// <summary>
  /// The <c>TEditSeedCommon</c> class inherits from the <c>TEditCommon</c> class.
  /// </summary>
  /// <remarks>
  /// The base class <c>TEditCommon</c> is enriched with the following methods:
  /// <para>
  /// - function Seed(const Value: Int64)
  /// </para>
  /// </remarks>
  TEditSeedCommon = class(TEditCommon)
    /// <summary>
    /// A specific value that is used to guide the 'randomness' of the generation
    /// </summary>
    /// <param name="Value">
    /// number [0 .. 4294967294]  (Default: 0)
    /// </param>
    /// <remarks>
    /// Omit this parameter or pass 0 to use a random seed.
    /// </remarks>
    function Seed(const Value: Int64): TEditSeedCommon;
  end;

  /// <summary>
  /// The <c>TEditSeedAndGrowMaskCommon</c> class inherits from the <c>TEditSeedCommon</c> class.
  /// </summary>
  /// <remarks>
  /// The base class <c>TEditSeedCommon</c> is enriched with the following methods:
  /// <para>
  /// - function GrowMask(const Value: Integer)
  /// </para>
  /// </remarks>
  TEditSeedAndGrowMaskCommon = class(TEditSeedCommon)
    /// <summary>
    /// Grows the edges of the mask outward in all directions by the specified number of pixels. The expanded area around the mask will be blurred, which can help smooth the transition between inpainted content and the original image.
    /// </summary>
    /// <param name="Value">
    /// number [0 .. 20] (Default: 5)
    /// </param>
    /// <remarks>
    /// Try this parameter if you notice seams or rough edges around the inpainted content.
    /// <para>
    /// - NOTE : Excessive growth may obscure fine details in the mask and/or merge nearby masked regions.
    /// </para>
    /// </remarks>
    function GrowMask(const Value: Integer): TEditSeedAndGrowMaskCommon;
  end;

  /// <summary>
  /// The <c>TEditSeedAndGrowMaskAndPromtCommon</c> class inherits from the <c>TEditSeedAndGrowMaskCommon</c> class.
  /// </summary>
  /// <remarks>
  /// The base class <c>TEditSeedAndGrowMaskCommon</c> is enriched with the following methods:
  /// <para>
  /// - function Prompt(const Value: string)
  /// </para>
  /// </remarks>
  TEditSeedAndGrowMaskAndPromtCommon = class(TEditSeedAndGrowMaskCommon)
    /// <summary>
    /// What you wish to see in the output image. A strong, descriptive prompt that clearly defines elements, colors, and subjects will lead to better results.
    /// </summary>
    /// <param name="Value">
    /// [1 .. 10000] characters
    /// </param>
    /// <remarks>
    /// To control the weight of a given word use the format (word:weight), where word is the word you'd like to control the weight of and weight is a value between 0 and 1.
    /// <para>
    /// - For example: The sky was a crisp (blue:0.3) and (green:0.8) would convey a sky that was blue and green, but more green than blue.
    /// </para>
    /// </remarks>
    function Prompt(const Value: string): TEditSeedAndGrowMaskAndPromtCommon;
  end;

  /// <summary>
  /// The <c>TUpscaleCommon</c> class inherits from the <c>TStableImageCommon</c> class.
  /// </summary>
  /// <remarks>
  /// The base class <c>TStableImageCommon</c> is enriched with the following methods:
  /// <para>
  /// - function Image(const FilePath: string)
  /// </para>
  /// <para>
  /// - function Image(const Stream: TStream; StreamFreed: Boolean = False)
  /// </para>
  /// </remarks>
  TUpscaleCommon = class(TStableImageCommon)
    /// <summary>
    /// The image to use as the starting point for the generation.
    /// </summary>
    /// <param name="FilePath">
    /// Filename with supported format (jpeg, png, webp)
    /// </param>
    /// <returns>
    /// The updated <c>TStableImageUltra</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// - Width must be between 64 and 16,384 pixels
    /// </para>
    /// <para>
    /// - Height must be between 64 and 16,384 pixels
    /// </para>
    /// <para>
    /// - Total pixel count must be at least 4,096 pixels
    /// </para>
    /// <para>
    /// - IMPORTANT: The strength parameter is required when image is provided.
    /// </para>
    /// </remarks>
    function Image(const FilePath: string): TUpscaleCommon; overload;
    /// <summary>
    /// Adds an image to be used as the starting point for the generation process, provided as a stream.
    /// </summary>
    /// <param name="Stream">
    /// The image data in the form of a TStream. The stream must contain the image data in a supported format (e.g., JPEG, PNG, WEBP).
    /// </param>
    /// <param name="StreamFreed">
    /// A boolean value indicating whether the stream should be automatically freed after being processed.
    /// <para>
    /// - Set to <c>True</c> to allow the method to free the stream automatically after reading its contents.
    /// </para>
    /// <para>
    /// - Set to <c>False</c> if you want to manage the lifetime of the stream yourself.
    /// </para>
    /// </param>
    /// <remarks>
    /// <para>
    /// This method is useful when you already have image data in memory, as opposed to working with a file directly.
    /// </para>
    /// <para>
    /// - The image dimensions must meet the following criteria:
    ///   - Width: Between 64 and 16,384 pixels.
    ///   - Height: Between 64 and 16,384 pixels.
    ///   - Total pixel count must be at least 4,096 pixels.
    /// </para>
    /// <para>
    /// - A strength parameter is required when an image is provided for editing.
    /// </para>
    /// </remarks>
    /// <exception cref="Exception">
    /// Throws an exception if the stream is invalid or its contents do not represent a valid image in a supported format.
    /// </exception>
    function Image(const Stream: TStream; StreamFreed: Boolean = False): TUpscaleCommon; overload;
  end;

  /// <summary>
  /// The <c>TJSONStableImage</c> class represents a JSON-serializable object that encapsulates the attributes and properties of a stable image or video generated by a model.
  /// </summary>
  /// <remarks>
  /// The <c>TJSONStableImage</c> class provides a flexible structure for handling the output of image or video generation tasks.
  /// It includes fields for base64-encoded image and video data, the reason the generation finished, and the seed value used for randomization.
  /// </remarks>
  TJSONStableImage = class
  private
    FImage: string;
    FVideo: string;
    [JsonReflectAttribute(ctString, rtString, TFinishReasonInterceptor)]
    [JsonNameAttribute('finish_reason')]
    FFinishReason: TFinishReason;
    FSeed: Int64;
  public
    /// <summary>
    /// The generated image, encoded to base64.
    /// </summary>
    property Image: string read FImage write FImage;
    /// <summary>
    /// The generated video, encoded to base64.
    /// </summary>
    property Video: string read FVideo write FVideo;
    /// <summary>
    /// The reason the generation finished.
    /// </summary>
    property FinishReason: TFinishReason read FFinishReason write FFinishReason;
    /// <summary>
    /// The seed used as random noise for this generation.
    /// </summary>
    property Seed: Int64 read FSeed write FSeed;
  end;

  /// <summary>
  /// Extends the <c>TJSONStableImage</c> class to include additional functionalities for handling stable images.
  /// </summary>
  /// <remarks>
  /// The <c>TStableImage</c> class builds upon <c>TJSONStableImage</c> by adding methods for saving generated images to files and retrieving the image or video as a stream.
  /// It is designed to simplify file and stream operations for generated content while retaining the JSON serialization capabilities of the base class.
  /// </remarks>
  TStableImage = class(TJSONStableImage)
  private
    FFileName: string;
  public
    /// <summary>
    /// Retrieves the generated image or video as a <c>TStream</c>.
    /// </summary>
    /// <returns>
    /// A <c>TStream</c> containing the decoded image or video data.
    /// </returns>
    /// <remarks>
    /// This method decodes the base64-encoded image or video data and returns it as a stream.
    /// The caller is responsible for freeing the returned stream.
    /// </remarks>
    /// <exception cref="Exception">
    /// Raises an exception if both the image and video data are empty.
    /// </exception>
    function GetStream: TStream;
    /// <summary>
    /// Saves the generated image or video to a file.
    /// </summary>
    /// <param name="FileName">
    /// The file path where the image or video will be saved.
    /// </param>
    /// <remarks>
    /// This method decodes the base64-encoded image or video data and saves it to the specified file.
    /// If the video data is not empty, it saves the video; otherwise, it saves the image.
    /// </remarks>
    /// <exception cref="Exception">
    /// Raises an exception if the image or video data cannot be decoded or saved.
    /// </exception>
    procedure SaveToFile(const FileName: string);
    /// <summary>
    /// Gets the file name where the image or video was saved.
    /// </summary>
    /// <value>
    /// The file path as a string.
    /// </value>
    /// <remarks>
    /// This property holds the file name specified in the last call to <c>SaveToFile</c>.
    /// </remarks>
    property FileName: string read FFileName;
  end;

  /// <summary>
  /// Represents the results of a generation process, extending the <c>TStableImage</c> class with additional metadata.
  /// </summary>
  /// <remarks>
  /// The <c>TResults</c> class includes properties for tracking the generation process, such as its unique identifier, status,
  /// and the base64-encoded result. This class is typically used for asynchronous operations where the generation
  /// process may be queried or monitored.
  /// </remarks>
  TResults = class(TStableImage)
  private
    FId: string;
    FStatus: string;
    FResult: string;
  public
    /// <summary>
    /// The id of a generation, typically used for async generations, that can be used to check the status of the generation or retrieve the result.
    /// </summary>
    property Id: string read FId write FId;
    /// <summary>
    /// The status of your generation.
    /// </summary>
    property Status: string read FStatus write FStatus;
    /// <summary>
    /// The result to import, encoded to base64.
    /// </summary>
    property Result: string read FResult write FResult;
  end;

  /// <summary>
  /// Manages asynchronous chat callBacks for a chat request using <c>TStableImage</c> as the response type.
  /// </summary>
  /// <remarks>
  /// The <c>TAsynStableImage</c> type extends the <c>TStableImage;</c> record to handle the lifecycle of an asynchronous chat operation.
  /// It provides event handlers that trigger at various stages, such as when the operation starts, completes successfully, or encounters an error.
  /// This structure facilitates non-blocking chat operations and is specifically tailored for scenarios where multiple choices from a chat model are required.
  /// </remarks>
  TAsynStableImage = TAsynCallBack<TStableImage>;

  /// <summary>
  /// Manages asynchronous chat callBacks for a chat request using <c>TResults</c> as the response type.
  /// </summary>
  /// <remarks>
  /// The <c>TAsynResults</c> type extends the <c>TResults;</c> record to handle the lifecycle of an asynchronous chat operation.
  /// It provides event handlers that trigger at various stages, such as when the operation starts, completes successfully, or encounters an error.
  /// This structure facilitates non-blocking chat operations and is specifically tailored for scenarios where multiple choices from a chat model are required.
  /// </remarks>
  TAsynResults = TAsynCallBack<TResults>;

  function Check(const FieldName, Value: string): string; overload;
  function Check(const FieldName, Value: string; Max: Integer): string; overload;
  function CheckInteger(const FieldName: string; Value, Min, Max: Integer): string; overload;
  function CheckInteger(const FieldName: string; Value, Min, Max: Int64): string; overload;
  function CheckInteger(const Value, Min, Max: Integer): Integer; overload;
  function CheckInteger(const Value, Min, Max: Int64): Int64; overload;
  function CheckFloat(const FieldName: string; Value, Min, Max: Double): string; overload;
  function CheckFloat(const Value, Min, Max: Double): Double; overload;
  function CheckMultipleOf(const Value, Min, MultipleOf: Integer): Integer;

implementation

uses
  System.StrUtils, StabilityAI.NetEncoding.Base64, StabilityAI.Consts, System.Rtti, Rest.Json;

function Check(const FieldName, Value: string): string;
begin
  Result := FieldName;
  if Value.Length > PromptMax then
    raise Exception.CreateFmt(PromptExceptionMessage, [Result, PromptMax, Value.Length]);
end;

function Check(const FieldName, Value: string; Max: Integer): string; overload;
begin
  Result := FieldName;
  if Value.Length > Max then
    raise Exception.CreateFmt(PromptExceptionMessage, [Result, Max, Value.Length]);
end;

function CheckInteger(const FieldName: string; Value, Min, Max: Int64): string; overload;
begin
  Result := FieldName;
  if (Value < Min) or (Value > Max) then
    raise Exception.CreateFmt(IntegerExceptionMessage, [Result, Min, Max, Value]);
end;

function CheckInteger(const FieldName: string; Value, Min, Max: Integer): string;
begin
  Result := FieldName;
  if (Value < Min) or (Value > Max) then
    raise Exception.CreateFmt(IntegerExceptionMessage, [Result, Min, Max, Value]);
end;

function CheckInteger(const Value, Min, Max: Integer): Integer;
begin
  Result := Value;
  if (Result < Min) or (Result > Max) then
    raise Exception.CreateFmt(FloatExceptionMessage, ['The value', Min.ToString, Max.ToString, Result.ToString]);
end;

function CheckInteger(const Value, Min, Max: Int64): Int64;
begin
  Result := Value;
  if (Result < Min) or (Result > Max) then
    raise Exception.CreateFmt(FloatExceptionMessage, ['The value', Min.ToString, Max.ToString, Result.ToString]);
end;

function CheckFloat(const FieldName: string; Value, Min, Max: Double): string; overload;
begin
  Result := FieldName;
  if (Value < Min) or (Value > Max) then
    raise Exception.CreateFmt(FloatExceptionMessage, [Result, Min.ToString, Max.ToString, FormatFloat('0.00', Value, FormatSettings)]);
end;

function CheckFloat(const Value, Min, Max: Double): Double;
begin
  Result := Value;
  if (Result < Min) or (Result > Max) then
    raise Exception.CreateFmt(FloatExceptionMessage, ['The value', Min.ToString, Max.ToString, FormatFloat('0.00', Result, FormatSettings)]);
end;

function CheckMultipleOf(const Value, Min, MultipleOf: Integer): Integer;
begin
  Result := Value;
  if (Result < Min) or (Result mod MultipleOf <> 0) then
    raise Exception.CreateFmt(MultipleOfExceptionMessage, [MultipleOf, Min, Result]);
end;

{ TFinishReasonHelper }

class function TFinishReasonHelper.create(const Value: string): TFinishReason;
begin
  var index := IndexStr(Value.ToUpper, ['SUCCESS', 'CONTENT_FILTERED', 'ERROR']);
  if index = -1 then
    raise Exception.Create(FinishReasonUnknownExceptionMessage);
  Result := TFinishReason(index);
end;

function TFinishReasonHelper.ToString: string;
begin
  case Self of
    SUCCESS:
      Exit('SUCCESS');
    CONTENT_FILTERED:
      Exit('CONTENT_FILTERED');
    {--- Only for version 1 }
    ERROR:
      Exit('ERROR');
  end;
end;

{ TFinishReasonInterceptor }

function TFinishReasonInterceptor.StringConverter(Data: TObject; Field: string): string;
begin
  Result := RTTI.GetType(Data.ClassType).GetField(Field).GetValue(Data).AsType<TFinishReason>.ToString;
end;

procedure TFinishReasonInterceptor.StringReverter(Data: TObject; Field, Arg: string);
begin
  RTTI.GetType(Data.ClassType).GetField(Field).SetValue(Data, TValue.From(TFinishReason.Create(Arg)));
end;

{ TStableImageCommon }

function TStableImageCommon.NegativePrompt(
  const Value: string): TStableImageCommon;
begin
  AddField(Check('negative_prompt', Value), Value);
  Result := Self;
end;

function TStableImageCommon.OutputFormat(
  const Value: TOutPutFormat): TStableImageCommon;
begin
  AddField('output_format', Value.ToString);
  Result := Self;
end;

function TStableImageCommon.Prompt(const Value: string): TStableImageCommon;
begin
  AddField(Check('prompt', Value), Value);
  Result := Self;
end;

function TStableImageCommon.Seed(const Value: Int64): TStableImageCommon;
begin
  AddField(CheckInteger('seed', Value, 0, SeedMax), Value.ToString);
  Result := Self;
end;

{ TStableImageRatio }

function TStableImageRatio.AspectRatio(
  const Value: TAspectRatioType): TStableImageRatio;
begin
  AddField('aspect_ratio', Value.ToString);
  Result := Self;
end;

{ TStableImage }

function TStableImage.GetStream: TStream;
begin
  {--- Create a memory stream to write the decoded content. }
  Result := TMemoryStream.Create;
  try
    {--- Convert the base-64 string directly into the memory stream. }
    if not Image.IsEmpty then
      DecodeBase64ToStream(Image, Result)
    else
    if not Video.IsEmpty then
      DecodeBase64ToStream(Image, Result)
    else
      raise Exception.Create(StreamEmptyExceptionMessage);
  except
    Result.Free;
    raise;
  end;
end;

procedure TStableImage.SaveToFile(const FileName: string);
begin
  try
    Self.FFileName := FileName;

    {--- Perform the decoding operation and save it into the file specified by the FileName parameter. }
    if not Video.IsEmpty then
      DecodeBase64ToFile(Video, FileName)
    else
      DecodeBase64ToFile(Image, FileName);
  except
    raise;
  end;
end;

{ TEditCommon }

function TEditCommon.Image(const FilePath: string): TEditCommon;
begin
  AddBytes('image', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TEditCommon.Image(const Stream: TStream; StreamFreed: Boolean): TEditCommon;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('image', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('image', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

function TEditCommon.OutputFormat(const Value: TOutPutFormat): TEditCommon;
begin
  AddField('output_format', Value.ToString);
  Result := Self;
end;

{ TEditSeedCommon }

function TEditSeedCommon.Seed(const Value: Int64): TEditSeedCommon;
begin
  AddField(CheckInteger('seed', Value, 0, SeedMax), Value.ToString);
  Result := Self;
end;

{ TEditSeedAndGrowMaskCommon }

function TEditSeedAndGrowMaskCommon.GrowMask(
  const Value: Integer): TEditSeedAndGrowMaskCommon;
begin
  AddField(CheckInteger('grow_mask', Value, 0, 20), Value.ToString);
  Result := Self;
end;

{ TEditSeedAndGrowMaskAndPromtCommon }

function TEditSeedAndGrowMaskAndPromtCommon.Prompt(
  const Value: string): TEditSeedAndGrowMaskAndPromtCommon;
begin
  AddField(Check('prompt', Value), Value);
  Result := Self;
end;

{ TUpscaleCommon }

function TUpscaleCommon.Image(const FilePath: string): TUpscaleCommon;
begin
  AddBytes('image', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TUpscaleCommon.Image(const Stream: TStream;
  StreamFreed: Boolean): TUpscaleCommon;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('image', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('image', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

end.
