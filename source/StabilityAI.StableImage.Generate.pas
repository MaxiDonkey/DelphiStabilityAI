unit StabilityAI.StableImage.Generate;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

uses
  System.SysUtils, System.Classes, System.Net.Mime, REST.JsonReflect, System.JSON,
  REST.Json.Types, StabilityAI.API, StabilityAI.API.Params, StabilityAI.Types,
  StabilityAI.Common;

type
  /// <summary>
  /// The <c>TStableImageUltra</c> class is designed to manage and streamline the parameters for the most advanced text-to-image generation service, Stable Image Ultra.
  /// This class facilitates the creation of high-quality images by providing seamless integration with the Stable Diffusion 3.5 model and beyond.
  /// </summary>
  /// <remarks>
  /// <c>TStableImageUltra</c> centralizes the parameter handling for the Stable Image Ultra API suite. By encapsulating parameters into a structured class, it enables efficient reuse through anonymous methods that can be directly passed to API-consuming functions.
  /// This design approach improves cohesion, reduces boilerplate code, and makes managing complex prompt settings for typography, lighting, and composition more intuitive.
  /// </remarks>
  TStableImageUltra = class(TStableImageRatio)
  public
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
    function Image(const FilePath: string): TStableImageUltra; overload;
    /// <summary>
    /// Sets the image to use as the starting point for the generation using a stream.
    /// </summary>
    /// <param name="Stream">
    /// A <c>TStream</c> containing the image data in a supported format (JPEG, PNG, WEBP).
    /// </param>
    /// <param name="StreamFreed">
    /// A <c>Boolean</c> indicating whether the stream should be automatically freed after use.
    /// Defaults to <c>False</c>.
    /// </param>
    /// <returns>
    /// The updated <c>TStableImageUltra</c> instance.
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
    /// - <strong>IMPORTANT:</strong> The <c>strength</c> parameter is required when an image is provided.
    /// </para>
    /// </remarks>
    function Image(const Stream: TStream; StreamFreed: Boolean = False): TStableImageUltra; overload;
    /// <summary>
    /// Sometimes referred to as denoising, this parameter controls how much influence the image parameter has on the generated image.
    /// </summary>
    /// <param name="paramname">
    /// number [0 .. 1]
    /// </param>
    /// <returns>
    /// The updated <c>TStableImageUltra</c> instance.
    /// </returns>
    /// <remarks>
    /// A value of 0 would yield an image that is identical to the input. A value of 1 would be as if you passed in no image at all.
    /// <para>
    /// - Important: This parameter is required when image is provided.
    /// </para>
    /// </remarks>
    function Strength(const Value: Double): TStableImageUltra;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// The <c>TStableImageCore</c> class is designed to manage and streamline the parameters for the Stable Image Core text-to-image generation service.
  /// It provides access to high-quality, fast image generation without requiring extensive prompt engineering.
  /// </summary>
  /// <remarks>
  /// <c>TStableImageCore</c> centralizes parameter management for the Stable Image Core API suite, allowing easy reuse through anonymous methods that can be supplied directly to API-consuming functions.
  /// This approach facilitates simple and intuitive usage, enabling rapid scene, style, or character creation without requiring the user to manually adjust intricate settings.
  /// </remarks>
  TStableImageCore = class(TStableImageRatio)
  public
    /// <summary>
    /// Guides the image model towards a particular style.
    /// </summary>
    /// <param name="paramname">
    /// Enum: <c>3d-model</c> <c>analog-film</c> <c>anime</c> <c>cinematic</c> <c>comic-book</c> <c>digital-art</c> <c>enhance</c> <c>fantasy-art</c> <c>isometric</c> <c>line-art</c> <c>low-poly</c> <c>modeling-compound</c> <c>neon-punk</c> <c>origami</c> <c>photographic</c> <c>pixel-art</c> <c>tile-texture</c>
    /// </param>
    /// <returns>
    /// The updated <c>TStableImageCore</c> instance.
    /// </returns>
    function StylePreset(const Value: TStylePreset): TStableImageCore;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// The <c>TStableImageDiffusion</c> class is designed to manage and streamline parameter handling for Stable Diffusion 3.0 and 3.5 models, enabling efficient text-to-image generation through APIs.
  /// This class supports various versions, including Stable Diffusion 3.5 Large, Large Turbo, and Medium, providing flexibility for high-quality, performance-oriented image generation tasks.
  /// </summary>
  /// <remarks>
  /// <c>TStableImageDiffusion</c> centralizes parameter management for Stable Diffusion APIs, enabling the creation of efficient anonymous methods that integrate seamlessly with API-consuming functions.
  /// The class allows users to easily access capabilities across Stable Diffusion 3.5 and 3.0 models, including the highly detailed 8 billion parameter models and faster Turbo versions.
  /// This design ensures optimal control over prompt adherence, generation speed, and image quality, tailored to different professional use cases at various resolutions.
  /// </remarks>
  TStableImageDiffusion = class(TStableImageUltra)
  public
    /// <summary>
    /// Controls whether this is a text-to-image or image-to-image generation
    /// </summary>
    /// <param name="Value">
    /// Enum: image-to-image text-to-image (Default: text-to-image)
    /// </param>
    /// <returns>
    /// The updated <c>TStableImageDiffusion</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// - <c>text-to-image</c> requires only the <c>prompt</c> parameter
    /// </para>
    /// <para>
    /// - <c>image-to-image</c> requires the <c>prompt</c>, <c>image</c>, and <c>strength</c> parameters
    /// </para>
    /// </remarks>
    function Mode(const Value: TGenerationMode): TStableImageDiffusion;
    /// <summary>
    /// The model to use for generation.
    /// </summary>
    /// <param name="Value">
    /// Enum: sd3-large, sd3-large-turbo, sd3-medium, sd3.5-large, sd3.5-large-turbo, sd3.5-medium
    /// </param>
    /// <returns>
    /// The updated <c>TStableImageDiffusion</c> instance.
    /// </returns>
    /// <remarks>
    /// Default: sd3.5-large
    /// <para>
    /// - <c>sd3.5-large</c> requires 6.5 credits per generation
    /// </para>
    /// <para>
    /// - <c>sd3.5-large-turbo</c> requires 4 credits per generation
    /// </para>
    /// <para>
    /// - <c>sd3.5-medium</c> requires 3.5 credits per generation
    /// </para>
    /// <para>
    /// - <c>sd3-large</c> requires 6.5 credits per generation
    /// </para>
    /// <para>
    /// - <c>sd3-large-turbo</c> requires 4 credits per generation
    /// </para>
    /// <para>
    /// - <c>sd3-medium</c> requires 3.5 credits per generation
    /// </para>
    /// </remarks>
    function Model(const Value: TDiffusionModelType): TStableImageDiffusion;
    /// <summary>
    /// How strictly the diffusion process adheres to the prompt text
    /// </summary>
    /// <param name="Value">
    /// number [1 .. 10]
    /// </param>
    /// <returns>
    /// The updated <c>TStableImageDiffusion</c> instance.
    /// </returns>
    /// <remarks>
    /// Higher values keep your image closer to your prompt
    /// </remarks>
    function CfgScale(const Value: Integer): TStableImageDiffusion;
    constructor Create; reintroduce;
  end;

  TGenerateRoute = class(TStabilityAIAPIRoute)
    function ImageUltra(ParamProc: TProc<TStableImageUltra>): TStableImage; overload;
    procedure ImageUltra(ParamProc: TProc<TStableImageUltra>; CallBacks: TFunc<TAsynStableImage>); overload;

    function ImageCore(ParamProc: TProc<TStableImageCore>): TStableImage; overload;
    procedure ImageCore(ParamProc: TProc<TStableImageCore>; CallBacks: TFunc<TAsynStableImage>); overload;

    function Diffusion(ParamProc: TProc<TStableImageDiffusion>): TStableImage; overload;
    procedure Diffusion(ParamProc: TProc<TStableImageDiffusion>; CallBacks: TFunc<TAsynStableImage>); overload;
  end;

implementation

uses
  System.StrUtils, StabilityAI.NetEncoding.Base64, StabilityAI.Consts,
  StabilityAI.Async.Support;

{ TStableImageUltra }

constructor TStableImageUltra.Create;
begin
  inherited Create(True);
end;

function TStableImageUltra.Image(const FilePath: string): TStableImageUltra;
begin
  AddBytes('image', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TStableImageUltra.Image(const Stream: TStream;
  StreamFreed: Boolean): TStableImageUltra;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('image', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('image', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

function TStableImageUltra.Strength(const Value: Double): TStableImageUltra;
begin
  AddField(CheckFloat('strength', Value, 0, 1), Value.ToString);
  Result := Self;
end;

{ TGenerateRoute }

procedure TGenerateRoute.Diffusion(ParamProc: TProc<TStableImageDiffusion>;
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
        Result := Self.Diffusion(ParamProc);
      end);
  finally
    Free;
  end;
end;

procedure TGenerateRoute.ImageCore(ParamProc: TProc<TStableImageCore>;
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
        Result := Self.ImageCore(ParamProc);
      end);
  finally
    Free;
  end;
end;

procedure TGenerateRoute.ImageUltra(ParamProc: TProc<TStableImageUltra>;
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
        Result := Self.ImageUltra(ParamProc);
      end);
  finally
    Free;
  end;
end;

function TGenerateRoute.Diffusion(ParamProc: TProc<TStableImageDiffusion>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TStableImageDiffusion>('v2beta/stable-image/generate/sd3', ParamProc);
end;

function TGenerateRoute.ImageCore(ParamProc: TProc<TStableImageCore>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TStableImageCore>('v2beta/stable-image/generate/core', ParamProc);
end;

function TGenerateRoute.ImageUltra(ParamProc: TProc<TStableImageUltra>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TStableImageUltra>('v2beta/stable-image/generate/ultra', ParamProc);
end;

{ TStableImageCore }

constructor TStableImageCore.Create;
begin
  inherited Create(True);
end;

function TStableImageCore.StylePreset(
  const Value: TStylePreset): TStableImageCore;
begin
  AddField('style_preset', Value.ToString);
  Result := Self;
end;

{ TStableImageDiffusion }

function TStableImageDiffusion.CfgScale(
  const Value: Integer): TStableImageDiffusion;
begin
  AddField(CheckInteger('cfg_scale', Value, 0, 10), Value.ToString);
  Result := Self;
end;

constructor TStableImageDiffusion.Create;
begin
  inherited Create;
end;

function TStableImageDiffusion.Mode(
  const Value: TGenerationMode): TStableImageDiffusion;
begin
  AddField('mode', Value.ToString);
  Result := Self;
end;

function TStableImageDiffusion.Model(
  const Value: TDiffusionModelType): TStableImageDiffusion;
begin
  AddField('model', Value.ToString);
  Result := Self;
end;

end.
