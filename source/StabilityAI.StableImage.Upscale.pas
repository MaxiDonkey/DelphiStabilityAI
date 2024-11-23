unit StabilityAI.StableImage.Upscale;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

uses
  System.SysUtils, System.Classes, System.Net.Mime, REST.JsonReflect, System.JSON,
  REST.Json.Types, StabilityAI.API, StabilityAI.Types, StabilityAI.Common;

type
  /// <summary>
  /// The <c>TUpscaleConservative</c> class manages parameters for the Conservative Upscale API, enabling the upscaling of images from small sizes (64x64) to 4K resolution while preserving the original content.
  /// The upscaling factor ranges from approximately 20 to 40 times, ensuring minimal alterations to the source image.
  /// </summary>
  /// <remarks>
  /// TUpscaleConservative is designed to provide efficient parameter handling for the Conservative Upscale API, focusing on maintaining the fidelity and integrity of the original image during the upscaling process.
  /// This class encapsulates the necessary parameters and allows for their reuse through anonymous methods that can be supplied directly to API functions, ensuring a streamlined and precise approach to image enhancement.
  /// This upscaling process is intended for scenarios where accurate reproduction of the original image is critical, and creative modifications are not desired.
  /// </remarks>
  TUpscaleConservative = class(TUpscaleCommon)
    /// <summary>
    /// Controls the likelihood of creating additional details not heavily conditioned by the init image.
    /// </summary>
    /// <param name="Value">
    /// number (Creativity) [0.2 .. 0.5]  (Default: 0.35)
    /// </param>
    function Creativity(const Value: Double): TUpscaleCommon;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// The <c>TUpscaleCreative</c> class manages parameters for the Creative Upscale API, designed to upscale images from a low resolution (between 64x64 and 1 megapixel) to 4K resolution.
  /// It is capable of performing significant upscaling (approximately 20-40 times), while preserving or enhancing image quality, particularly for degraded images.
  /// </summary>
  /// <remarks>
  /// <c>TUpscaleCreative</c> facilitates the handling of parameters for the Creative Upscale API through anonymous methods, simplifying the process of parameter management and reuse.
  /// This class is intended for upscaling images that require heavy reimagining, especially when dealing with highly degraded images. It should not be used for high-quality photographs (1 megapixel or above), as it introduces substantial creative modifications, adjustable through the creativity scale parameter.
  /// </remarks>
  TUpscaleCreative = class(TUpscaleCommon)
    /// <summary>
    /// Indicates how creative the model should be when upscaling an image. Higher values will result in more details being added to the image during upscaling.
    /// </summary>
    /// <param name="Value">
    /// number (Creativity) [0 .. 0.35]  (Default: 0.3)
    /// </param>
    function Creativity(const Value: Double): TUpscaleCommon;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// The <c>TUpscaleFast</c> class is designed to manage and facilitate the parameters for the Fast Upscaler service, which enhances image resolution by 4x using predictive and generative AI.
  /// It is optimized for lightweight, fast processing, suitable for applications where quick enhancement of image quality is required.
  /// </summary>
  /// <remarks>
  /// <c>TUpscaleFast</c> centralizes the handling of parameters for the Fast Upscaler API, enabling efficient reuse by providing these settings through anonymous methods to API-consuming functions.
  /// This class is ideal for scenarios where rapid upscaling is necessary, such as improving the quality of compressed images for social media or similar use cases, without sacrificing performance.
  /// </remarks>
  TUpscaleFast = class(TMultipartFormData)
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
    function Image(const FilePath: string): TUpscaleFast; overload;
    /// <summary>
    /// Sets the image to use as the starting point for the upscaling process from a stream.
    /// </summary>
    /// <param name="Stream">
    /// A <c>TStream</c> containing the image data. Supported formats include JPEG, PNG, and WEBP.
    /// </param>
    /// <param name="StreamFreed">
    /// A Boolean value indicating whether the stream should be automatically freed after use.
    /// If set to <c>True</c>, the stream will be freed; otherwise, you are responsible for managing the stream's memory.
    /// </param>
    /// <returns>
    /// The updated <c>TUpscaleFast</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// - Width must be between 64 and 16,384 pixels.
    /// </para>
    /// <para>
    /// - Height must be between 64 and 16,384 pixels.
    /// </para>
    /// <para>
    /// - Total pixel count must be at least 4,096 pixels.
    /// </para>
    /// <para>
    /// - IMPORTANT: The strength parameter is required when an image is provided.
    /// </para>
    /// </remarks>
    function Image(const Stream: TStream; StreamFreed: Boolean = False): TUpscaleFast; overload;
    /// <summary>
    /// Dictates the content-type of the generated image.
    /// </summary>
    /// <param name="Value">
    /// Enum: <c>jpeg</c> <c>png webp</c>
    /// </param>
    function OutputFormat(const Value: TOutPutFormat): TUpscaleFast;
    constructor Create; reintroduce;
  end;

  TUpscaleRoute = class(TStabilityAIAPIRoute)
    function Conservative(ParamProc: TProc<TUpscaleConservative>): TStableImage; overload;
    procedure Conservative(ParamProc: TProc<TUpscaleConservative>; CallBacks: TFunc<TAsynStableImage>); overload;

    function Creative(ParamProc: TProc<TUpscaleCreative>): TStableImage; overload;
    procedure Creative(ParamProc: TProc<TUpscaleCreative>; CallBacks: TFunc<TAsynStableImage>); overload;

    function Fast(ParamProc: TProc<TUpscaleFast>): TStableImage; overload;
    procedure Fast(ParamProc: TProc<TUpscaleFast>; CallBacks: TFunc<TAsynStableImage>); overload;
  end;

implementation

uses
  StabilityAI.NetEncoding.Base64, StabilityAI.Async.Support;

{ TUpscaleConservative }

constructor TUpscaleConservative.Create;
begin
  inherited Create(True);
end;

function TUpscaleConservative.Creativity(const Value: Double): TUpscaleCommon;
begin
  AddField(CheckFloat('creativity', Value, 0.2, 0.5), Value.ToString);
  Result := Self;
end;

{ TUpscaleCreative }

constructor TUpscaleCreative.Create;
begin
  inherited Create(True);
end;

function TUpscaleCreative.Creativity(const Value: Double): TUpscaleCommon;
begin
  AddField(CheckFloat('creativity', Value, 0, 0.35), Value.ToString);
  Result := Self;
end;

{ TUpscaleFast }

constructor TUpscaleFast.Create;
begin
  inherited Create(True);
end;

function TUpscaleFast.Image(const FilePath: string): TUpscaleFast;
begin
  AddBytes('image', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TUpscaleFast.Image(const Stream: TStream;
  StreamFreed: Boolean): TUpscaleFast;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('image', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('image', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

function TUpscaleFast.OutputFormat(const Value: TOutPutFormat): TUpscaleFast;
begin
  AddField('output_format', Value.ToString);
  Result := Self;
end;

{ TUpscaleRoute }

procedure TUpscaleRoute.Conservative(ParamProc: TProc<TUpscaleConservative>;
  CallBacks: TFunc<TAsynStableImage>);
begin
  with TAsynCallBackExec<TAsynStableImage, TStableImage>.Create(CallBacks) do
  try
    Sender := Use.Param.Sender;
    OnStart := Use.Param.OnStart;
    OnSuccess := Use.Param.OnSuccess;
    OnError := Use.Param.OnError;
    Run(
      function: TStableImage
      begin
        Result := Self.Conservative(ParamProc);
      end);
  finally
    Free;
  end;
end;

procedure TUpscaleRoute.Creative(ParamProc: TProc<TUpscaleCreative>;
  CallBacks: TFunc<TAsynStableImage>);
begin
  with TAsynCallBackExec<TAsynStableImage, TStableImage>.Create(CallBacks) do
  try
    Sender := Use.Param.Sender;
    OnStart := Use.Param.OnStart;
    OnSuccess := Use.Param.OnSuccess;
    OnError := Use.Param.OnError;
    Run(
      function: TStableImage
      begin
        Result := Self.Creative(ParamProc);
      end);
  finally
    Free;
  end;
end;

procedure TUpscaleRoute.Fast(ParamProc: TProc<TUpscaleFast>;
  CallBacks: TFunc<TAsynStableImage>);
begin
  with TAsynCallBackExec<TAsynStableImage, TStableImage>.Create(CallBacks) do
  try
    Sender := Use.Param.Sender;
    OnStart := Use.Param.OnStart;
    OnSuccess := Use.Param.OnSuccess;
    OnError := Use.Param.OnError;
    Run(
      function: TStableImage
      begin
        Result := Self.Fast(ParamProc);
      end);
  finally
    Free;
  end;
end;

function TUpscaleRoute.Conservative(ParamProc: TProc<TUpscaleConservative>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TUpscaleConservative>('v2beta/stable-image/upscale/conservative', ParamProc);
end;

function TUpscaleRoute.Creative(ParamProc: TProc<TUpscaleCreative>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TUpscaleCreative>('v2beta/stable-image/upscale/creative', ParamProc);
end;

function TUpscaleRoute.Fast(ParamProc: TProc<TUpscaleFast>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TUpscaleFast>('v2beta/stable-image/upscale/fast', ParamProc);
end;

end.