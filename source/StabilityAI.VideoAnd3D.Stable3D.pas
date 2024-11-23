unit StabilityAI.VideoAnd3D.Stable3D;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

uses
  System.SysUtils, System.Classes, System.Net.Mime, REST.JsonReflect, System.JSON,
  REST.Json.Types, StabilityAI.API, StabilityAI.Types, StabilityAI.Async.Support;

type
  /// <summary>
  /// <c>TStable3D</c> is a class that manages parameters for generating high-quality 3D assets from a single 2D input image.
  /// This class acts as a configuration layer, simplifying interaction with the Stable Fast 3D APIs.
  /// </summary>
  /// <remarks>
  /// The <c>TStable3D</c> class is designed to handle the setup of parameters required for invoking the API methods.
  /// It encapsulates these parameters and provides them as anonymous methods to ensure seamless integration
  /// with functions that leverage the Stable Fast 3D API. This approach enhances reusability and abstracts
  /// the complexity involved in preparing the input data, making it easier to adapt and extend the model generation pipeline.
  /// </remarks>
  TStable3D = class(TMultipartFormData)
    /// <summary>
    /// The image to generate a 3D model from.
    /// </summary>
    /// <param name="FilePath">
    /// Filename with supported format (jpeg, png, webp)
    /// </param>
    /// <returns>
    /// The updated <c>TStableImageUltra</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// - Every side must be at least 64 pixels
    /// </para>
    /// <para>
    /// - Total pixel count must be between 4,096 and 4,194,304 pixels
    /// </para>
    /// </remarks>
    function Image(const FilePath: string): TStable3D; overload;
    /// <summary>
    /// The image to generate a 3D model from.
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
    ///   - Every side must be at least 64 pixels
    ///   - Total pixel count must be between 4,096 and 4,194,304 pixels
    /// </para>
    /// <para>
    /// - A strength parameter is required when an image is provided for editing.
    /// </para>
    /// </remarks>
    /// <exception cref="Exception">
    /// Throws an exception if the stream is invalid or its contents do not represent a valid image in a supported format.
    /// </exception>
    function Image(const Stream: TStream; StreamFreed: Boolean = False): TStable3D; overload;
    /// <summary>
    /// Determines the resolution of the textures used for both the albedo (color) map and the normal map.
    /// </summary>
    /// <param name="Value">
    /// Enum: 1024, 2048, 512 (Default: 1024)
    /// </param>
    /// <remarks>
    /// The resolution is specified in pixels, and a higher value corresponds to a higher level of detail in the textures, allowing for more intricate and precise rendering of surfaces. However, increasing the resolution also results in larger asset sizes, which may impact loading times and performance. 1024 is a good default value and rarely requires changing.
    /// </remarks>
    function TextureResolution(const Value: TTextureResolutionType): TStable3D;
    /// <summary>
    /// Controls the amount of padding around the object to be processed within the frame.
    /// </summary>
    /// <param name="Value">
    /// Number: [0.1 .. 1] (Default: 0.85)
    /// </param>
    /// <remarks>
    /// This ratio determines the relative size of the object compared to the total frame size. A higher ratio means less padding and a larger object, while a lower ratio increases the padding, effectively reducing the object’s size within the frame. This can be useful when a long and narrow object, such as a car or bus, is viewed from the front (the narrow side). Here, lowering the foreground ratio might help prevent the generated 3D assets from appearing squished or distorted. The default value of 0.85 is good for most objects.
    /// </remarks>
    function ForegroundRatio(const Value: Double): TStable3D;
    /// <summary>
    /// Controls the remeshing algorithm used to generate the 3D model.
    /// </summary>
    /// <param name="Value">
    /// Enum: <c>none</c>, <c>quad</c>, triangle</c>  (Default: <c>none</c>)
    /// </param>
    /// <remarks>
    /// The remeshing algorithm determines how the 3D model is constructed from the input image. The default value of "none" means that the model is generated without remeshing, which is suitable for most use cases. The "triangle" option generates a model with triangular faces, while the "quad" option generates a model with quadrilateral faces. The "quad" option is useful when the 3D model will be used in DCC tools such as Maya or Blender.
    /// </remarks>
    function Remesh(const Value: TRemeshType): TStable3D;
    /// <summary>
    /// If specified, the result will have approximately this many vertices (and consequently fewer faces) in the simplified mesh.
    /// </summary>
    /// <param name="paramname">
    /// Number: [-1 .. 20000] (Default: -1)
    /// </param>
    /// <remarks>
    /// Setting this value to -1 (the default value) means that a limit is not set.
    /// </remarks>
    function VertexCount(const Value: Double): TStable3D;
    constructor Create; reintroduce;
  end;

  TModel3D = class(TModelDataReturned)
  private
    FFileName: string;
  public
    function SaveToFile(const FileName: string): string;
    property FileName: string read FFileName;
  end;

  TAsynModel3D = TAsynCallBack<TModel3D>;

  TModel3DRoute = class(TStabilityAIAPIRoute)
    function Fast3D(ParamProc: TProc<TStable3D>): TModel3D; overload;
    procedure Fast3D(ParamProc: TProc<TStable3D>; CallBacks: TFunc<TAsynModel3D>); overload;
  end;

implementation

uses
  StabilityAI.NetEncoding.Base64, StabilityAI.Consts, StabilityAI.Common;

{ TStable3D }

constructor TStable3D.Create;
begin
  inherited Create(True);
end;

function TStable3D.ForegroundRatio(const Value: Double): TStable3D;
begin
  AddField(CheckFloat('foreground_ratio', Value, 0.1, 1), Value.ToString);
  Result := Self;
end;

function TStable3D.Image(const FilePath: string): TStable3D;
begin
  AddBytes('image', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TStable3D.Image(const Stream: TStream;
  StreamFreed: Boolean): TStable3D;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('image', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('image', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

function TStable3D.Remesh(const Value: TRemeshType): TStable3D;
begin
  AddField('remesh', Value.ToString);
  Result := Self;
end;

function TStable3D.TextureResolution(
  const Value: TTextureResolutionType): TStable3D;
begin
  AddField('texture_resolution', Value.ToString);
  Result := Self;
end;

function TStable3D.VertexCount(const Value: Double): TStable3D;
begin
  AddField(CheckFloat('vertex_count', Value, -1, 20000), Value.ToString);
  Result := Self;
end;

{ TModel3D }

function TModel3D.SaveToFile(const FileName: string): string;
begin
  if ContentType <> 'model/gltf-binary' then
    raise Exception.CreateFmt('Incompatible format return : (%s)', [ContentType]);

  try
    FFileName := FileName;
    SaveBytesToFile(Data, FileName);
  except
    raise;
  end;
end;

{ TModel3DRoute }

procedure TModel3DRoute.Fast3D(
  ParamProc: TProc<TStable3D>; CallBacks: TFunc<TAsynModel3D>);
begin
  with TAsynCallBackExec<TAsynModel3D, TModel3D>.Create(CallBacks) do
  try
    Sender := Use.Param.Sender;
    OnStart := Use.Param.OnStart;
    OnSuccess := Use.Param.OnSuccess;
    OnError := Use.Param.OnError;
    Run(
      function: TModel3D
      begin
        Result := Self.Fast3D(ParamProc);
      end);
  finally
    Free;
  end;
end;

function TModel3DRoute.Fast3D(ParamProc: TProc<TStable3D>): TModel3D;
begin
  Result := API.PostForm<TModel3D, TStable3D>('v2beta/3d/stable-fast-3d', ParamProc);
end;

end.
