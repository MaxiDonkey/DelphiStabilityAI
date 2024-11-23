unit StabilityAI.StableImage.Edit;

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
  /// <c>TErase</c> is a class designed to manage parameters for the Erase image manipulation service.
  /// This service is used to remove unwanted objects from images by utilizing image masks.
  /// </summary>
  /// <remarks>
  /// <c>TErase</c> centralizes parameter handling for the Erase API, allowing for efficient reuse through anonymous methods that can be directly passed to API-consuming functions.
  /// The masks used to remove unwanted elements can be provided either explicitly via a separate image or derived from the alpha channel of the main image parameter.
  /// This class simplifies the process of configuring and managing mask-related parameters for consistent image editing operations.
  /// </remarks>
  TErase = class(TEditSeedAndGrowMaskCommon)
    /// <summary>
    /// Controls the strength of the inpainting process on a per-pixel basis, either via a second image (passed into this parameter) or via the alpha channel of the image parameter.
    /// </summary>
    /// <param name="FilePath">
    /// Filename provided
    /// </param>
    /// <remarks>
    /// <para>
    /// - <c>Mask Input Overview</c>
    /// The mask should be a black-and-white image where pixel brightness determines inpainting strength: black means no effect, white means full strength. If the mask size differs from the image, it will be resized automatically.
    /// </para>
    /// <para>
    /// - <c>Alpha Channel Support</c>
    /// If no mask is provided, the alpha channel of the image will be used to create one. Transparent areas will be inpainted, and opaque areas will remain unchanged. If both an alpha channel and a mask are given, the mask takes priority.
    /// </para>
    /// </remarks>
    function Mask(const FilePath: string): TErase; overload;
    /// <summary>
    /// An image stream containing the mask used to control the strength of the inpainting process.
    /// </summary>
    /// <param name="Stream">
    /// A <c>TStream</c> containing the mask image. Supported formats include JPEG, PNG, and WEBP.
    /// </param>
    /// <param name="StreamFreed">
    /// Indicates whether the stream should be automatically freed after processing.
    /// Set to <c>True</c> if the method should take ownership and free the stream,
    /// or <c>False</c> if the caller will manage the stream's lifecycle.
    /// Default is <c>False</c>.
    /// </param>
    /// <returns>
    /// The updated <c>TErase</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// <c>Mask Input Overview:</c>
    /// The mask should be a black-and-white image where pixel brightness determines inpainting strength:
    /// black means no effect, white means full strength. If the mask size differs from the image, it will be resized automatically.
    /// </para>
    /// <para>
    /// <c>Alpha Channel Support:</c>
    /// If no mask is provided, the alpha channel of the image will be used to create one.
    /// Transparent areas will be inpainted, and opaque areas will remain unchanged.
    /// If both an alpha channel and a mask are given, the mask takes priority.
    /// </para>
    /// <para>
    /// If <c>StreamFreed</c> is set to <c>True</c>, the method will automatically free the stream after processing.
    /// If set to <c>False</c>, the caller is responsible for freeing the stream to prevent memory leaks.
    /// </para>
    /// </remarks>
    function Mask(const Stream: TStream; StreamFreed: Boolean = False): TErase; overload;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// <c>TInpaint</c> is a class that facilitates intelligent modification of images by filling in or replacing specified areas with contextually relevant content.
  /// It uses a mask image to determine which areas of the original image should be altered.
  /// </summary>
  /// <remarks>
  /// <c>TInpaint</c> manages the parameters required for image inpainting operations, providing a structured way to supply these parameters via anonymous methods to functions utilizing the inpainting API.
  /// The mask used for inpainting can be provided explicitly through a separate image or derived from the alpha channel of the original image. This approach supports seamless integration with inpainting services, ensuring precise and effective modifications to selected image areas.
  /// </remarks>
  TInpaint = class(TEditSeedAndGrowMaskAndPromtCommon)
    /// <summary>
    /// A blurb of text describing what you do not wish to see in the output image.
    /// </summary>
    /// <param name="Value">
    /// string [1 .. 10000] characters
    /// </param>
    /// <remarks>
    /// This is an advanced feature.
    /// </remarks>
    function NegativePrompt(const Value: string): TInpaint;
    /// <summary>
    /// Controls the strength of the inpainting process on a per-pixel basis, either via a second image (passed into this parameter) or via the alpha channel of the image parameter.
    /// </summary>
    /// <param name="FilePath">
    /// Filename provided
    /// </param>
    /// <remarks>
    /// <para>
    /// - <c>Mask Input Overview</c>
    /// The mask should be a black-and-white image where pixel brightness determines inpainting strength: black means no effect, white means full strength. If the mask size differs from the image, it will be resized automatically.
    /// </para>
    /// <para>
    /// - <c>Alpha Channel Support</c>
    /// If no mask is provided, the alpha channel of the image will be used to create one. Transparent areas will be inpainted, and opaque areas will remain unchanged. If both an alpha channel and a mask are given, the mask takes priority.
    /// </para>
    /// </remarks>
    function Mask(const FilePath: string): TInpaint; overload;
    /// <summary>
    /// Controls the strength of the inpainting process using an image stream.
    /// </summary>
    /// <param name="Stream">
    /// A <c>TStream</c> containing the mask image. Supported formats include JPEG, PNG, and WEBP.
    /// </param>
    /// <param name="StreamFreed">
    /// Indicates whether the stream should be automatically freed after processing.
    /// Set to <c>True</c> if the method should take ownership and free the stream,
    /// or <c>False</c> if the caller will manage the stream's lifecycle.
    /// Default is <c>False</c>.
    /// </param>
    /// <returns>
    /// The updated <c>TInpaint</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// <c>Mask Input Overview:</c>
    /// </para>
    /// <para>
    /// The mask should be a black-and-white image where pixel brightness determines inpainting strength:
    /// black means no effect, white means full strength. If the mask size differs from the image, it will be resized automatically.
    /// </para>
    /// <para>
    /// <c>Alpha Channel Support:</c>
    /// If no mask is provided, the alpha channel of the image will be used to create one.
    /// Transparent areas will be inpainted, and opaque areas will remain unchanged.
    /// If both an alpha channel and a mask are given, the mask takes priority.
    /// </para>
    /// <para>
    /// If <c>StreamFreed</c> is set to <c>True</c>, the method will automatically free the stream after processing.
    /// If set to <c>False</c>, the caller is responsible for freeing the stream to prevent memory leaks.
    /// </para>
    /// </remarks>
    function Mask(const Stream: TStream; StreamFreed: Boolean = False): TInpaint; overload;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// <c>TOutpaint</c> is a class designed to manage and configure parameters for the Outpaint service, which extends existing images by filling additional space seamlessly in any direction.
  /// This class aims to facilitate efficient expansion of images while minimizing visible artifacts or signs of modification.
  /// </summary>
  /// <remarks>
  /// <c>TOutpaint</c> centralizes the handling of parameters for the Outpaint API, enabling the use of anonymous methods to pass these parameters to API-consuming functions.
  /// The approach ensures that extending an image's boundaries can be performed with minimal manual configuration, preserving consistency and visual integrity in the output.
  /// </remarks>
  TOutpaint = class(TEditSeedCommon)
    /// <summary>
    /// The number of pixels to outpaint on the left side of the image.
    /// </summary>
    /// <param name="Value">
    /// integer [ 0 .. 2000 ] (Default: 0)
    /// </param>
    /// <remarks>
    /// At least one outpainting direction must be supplied with a non-zero value.
    /// </remarks>
    function Left(const Value: Integer): TOutpaint;
    /// <summary>
    /// The number of pixels to outpaint on the right side of the image.
    /// </summary>
    /// <param name="Value">
    /// integer [ 0 .. 2000 ] (Default: 0)
    /// </param>
    /// <remarks>
    /// At least one outpainting direction must be supplied with a non-zero value.
    /// </remarks>
    function Right(const Value: Integer): TOutpaint;
    /// <summary>
    /// The number of pixels to outpaint on the top of the image.
    /// </summary>
    /// <param name="Value">
    /// integer [ 0 .. 2000 ] (Default: 0)
    /// </param>
    /// <remarks>
    /// At least one outpainting direction must be supplied with a non-zero value.
    /// </remarks>
    function Up(const Value: Integer): TOutpaint;
    /// <summary>
    /// The number of pixels to outpaint on the bottom of the image.
    /// </summary>
    /// <param name="Value">
    /// integer [ 0 .. 2000 ] (Default: 0)
    /// </param>
    /// <remarks>
    /// At least one outpainting direction must be supplied with a non-zero value.
    /// </remarks>
    function Down(const Value: Integer): TOutpaint;
    /// <summary>
    /// Controls the likelihood of creating additional details not heavily conditioned by the init image.
    /// </summary>
    /// <param name="Value">
    /// Number: [0 .. 1]  (Default: 0.5)
    /// </param>
    function Creativity(const Value: Double): TOutpaint;
    /// <summary>
    /// What you wish to see in the output image. A strong, descriptive prompt that clearly defines elements, colors, and subjects will lead to better results.
    /// </summary>
    /// <param name="Value">
    /// string [1 .. 10000] characters
    /// </param>
    /// <remarks>
    /// To control the weight of a given word use the format (word:weight), where word is the word you'd like to control the weight of and weight is a value between 0 and 1.
    /// <para>
    /// - For example: The sky was a crisp (blue:0.3) and (green:0.8) would convey a sky that was blue and green, but more green than blue.
    /// </para>
    /// </remarks>
    function Prompt(const Value: string): TOutpaint;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// <c>TSearchAndReplace</c> is a class designed to manage the parameters for the Search and Replace image inpainting service.
  /// This service allows users to locate and replace objects in an image using simple language, without requiring manual masking.
  /// </summary>
  /// <remarks>
  /// <c>TSearchAndReplace</c> centralizes the parameter management for the Search and Replace API suite. By encapsulating these parameters into a structured class, the parameters can be efficiently reused and supplied as anonymous methods to API-consuming functions.
  /// This design approach simplifies the process of object replacement in images, enabling users to use a search prompt to specify objects for automatic segmentation and replacement.
  /// </remarks>
  TSearchAndReplace = class(TEditSeedAndGrowMaskAndPromtCommon)
    /// <summary>
    /// Short description of what to inpaint in the image.
    /// </summary>
    /// <param name="Value">
    /// string [1 .. 10000] characters
    /// </param>
    function SearchPrompt(const Value: string): TSearchAndReplace;
    /// <summary>
    /// A blurb of text describing what you do not wish to see in the output image.
    /// </summary>
    /// <param name="Value">
    /// string [1 .. 10000] characters
    /// </param>
    /// <remarks>
    /// This is an advanced feature.
    /// </remarks>
    function NegativePrompt(const Value: string): TSearchAndReplace;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// <c>TSearchAndRecolor</c> is a class designed to manage and provide parameters for the Search and Recolor service, enabling automated object segmentation and color modification within an image.
  /// This service offers an inpainting-like functionality without requiring manual masks, allowing recoloring of specific image elements based solely on a textual prompt.
  /// </summary>
  /// <remarks>
  /// <c>TSearchAndRecolor</c> encapsulates the parameters required by the Search and Recolor API suite. The class enables straightforward reuse of parameters by wrapping them into anonymous methods, which can be directly passed to functions that interact with the API.
  /// By automating object segmentation and recoloring, this service allows users to specify desired colors for particular image elements efficiently, enhancing usability without manual mask creation.
  /// </remarks>
  TSearchAndRecolor = TSearchAndReplace;

  /// <summary>
  /// <c>TRemoveBackground</c> is a class designed to manage parameters for the Remove Background service, which accurately segments the foreground from an image and removes or modifies the background as required.
  /// </summary>
  /// <remarks>
  /// <c>TRemoveBackground</c> provides a structured approach to managing the parameters required by the Remove Background API. By encapsulating these parameters into a cohesive class, it facilitates seamless reuse and efficient integration with functions that utilize these APIs through anonymous methods.
  /// This design aims to simplify the handling of image segmentation tasks while ensuring accurate control over background removal and modification processes.
  /// </remarks>
  TRemoveBackground = class(TEditCommon)
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// <c>TRemoveBackground</c> is a class that manages the parameters for the Replace Background and Relight image editing service.
  /// It enables background replacement, AI background generation, and lighting adjustments to create cohesive and visually enhanced images.
  /// </summary>
  /// <remarks>
  /// TRemoveBackground centralizes parameter handling for the Replace Background and Relight API suite, allowing efficient use of these services through anonymous methods.
  /// This class provides a flexible framework for background removal, replacement, and relighting operations, supporting various input options such as uploaded images or AI-generated backgrounds.
  /// Additionally, it includes features for refining light direction, strength, and reference to achieve realistic and visually consistent results.
  /// </remarks>
  TReplaceBackgroundAndRelight = class(TMultipartFormData)
    /// <summary>
    /// An image containing the subject that you wish to change background and relight.
    /// </summary>
    /// <param name="FilePath">
    /// Filename with supported format (jpeg, png, webp)
    /// </param>
    /// <returns>
    /// The updated <c>TStableImageUltra</c> instance.
    /// </returns>
    /// <remarks>
    /// Validation Rules:
    /// <para>
    /// - Every side must be at least 64 pixels
    /// </para>
    /// <para>
    /// - Total pixel count must be between 4,096 and 9,437,184 pixels
    /// </para>
    /// <para>
    /// - The aspect ratio must be between 1:2.5 and 2.5:1
    /// </para>
    /// </remarks>
    function SubjectImage(const FilePath: string): TReplaceBackgroundAndRelight; overload;
    /// <summary>
    /// An image stream containing the subject that you wish to change the background and relight.
    /// </summary>
    /// <param name="Stream">
    /// A <c>TStream</c> containing the subject image. Supported formats include JPEG, PNG, and WEBP.
    /// </param>
    /// <param name="StreamFreed">
    /// Indicates whether the stream should be automatically freed after processing.
    /// Set to <c>True</c> if the method should take ownership and free the stream,
    /// or <c>False</c> if the caller will manage the stream's lifecycle.
    /// Default is <c>False</c>.
    /// </param>
    /// <returns>
    /// The updated <c>TReplaceBackgroundAndRelight</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// <c>Validation Rules:</c>
    /// </para>
    /// <para>
    /// - Every side of the image must be at least 64 pixels.
    /// </para>
    /// <para>
    /// - Total pixel count must be between 4,096 and 9,437,184 pixels.
    /// </para>
    /// <para>
    /// - The aspect ratio must be between 1:2.5 and 2.5:1.
    /// </para>
    /// <para>
    /// If <c>StreamFreed</c> is set to <c>True</c>, the method will automatically free the stream after processing.
    /// If set to <c>False</c>, the caller is responsible for freeing the stream to prevent memory leaks.
    /// </para>
    /// </remarks>
    function SubjectImage(const Stream: TStream; StreamFreed: Boolean = False): TReplaceBackgroundAndRelight; overload;
    /// <summary>
    /// An image whose style you wish to use in the background. Similar to the Control: Style API, stylistic elements from this image are added to the background.
    /// </summary>
    /// <param name="FilePath">
    /// Filename with supported format (jpeg, png, webp)
    /// </param>
    /// <returns>
    /// The updated <c>TStableImageUltra</c> instance.
    /// </returns>
    /// <remarks>
    /// Validation Rules:
    /// <para>
    /// - Every side must be at least 64 pixels
    /// </para>
    /// <para>
    /// - Total pixel count must be between 4,096 and 9,437,184 pixels
    /// </para>
    /// </remarks>
    function BackgroundReference(const FilePath: string): TReplaceBackgroundAndRelight; overload;
    /// <summary>
    /// An image stream whose style you wish to use in the background. Similar to the Control: Style API, stylistic elements from this image are added to the background.
    /// </summary>
    /// <param name="Stream">
    /// A <c>TStream</c> containing the background reference image. Supported formats include JPEG, PNG, and WEBP.
    /// </param>
    /// <param name="StreamFreed">
    /// Indicates whether the stream should be automatically freed after processing.
    /// Set to <c>True</c> if the method should take ownership and free the stream,
    /// or <c>False</c> if the caller will manage the stream's lifecycle.
    /// Default is <c>False</c>.
    /// </param>
    /// <returns>
    /// The updated <c>TReplaceBackgroundAndRelight</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// <c>Validation Rules:</c>
    /// </para>
    /// <para>
    /// - Every side of the image must be at least 64 pixels.
    /// </para>
    /// <para>
    /// - Total pixel count must be between 4,096 and 9,437,184 pixels.
    /// </para>
    /// </remarks>
    function BackgroundReference(const Stream: TStream; StreamFreed: Boolean = False): TReplaceBackgroundAndRelight; overload;
    /// <summary>
    /// What you wish to see in the background of the output image.
    /// </summary>
    /// <param name="Value">
    /// [1 .. 10000] characters
    /// </param>
    /// <remarks>
    /// This could be a description of the desired background scene, or just a description of the lighting if modifying the light source through light_source_direction or light_reference.
    /// <para>
    /// - IMPORTANT : either <c>background_reference</c> or <c>background_prompt</c> must be provided.
    /// </para>
    /// </remarks>
    function BackgroundPrompt(const Value: string): TReplaceBackgroundAndRelight;
    /// <summary>
    /// Description of the subject. Use this to prevent elements of the background from bleeding into the subject.
    /// </summary>
    /// <param name="Value">
    /// [1 .. 10000] characters
    /// </param>
    /// <remarks>
    ///  For example, if you find your subject is turning green with a forest in the background, try putting a short description of the subject in this field.
    /// </remarks>
    function ForegroundPrompt(const Value: string): TReplaceBackgroundAndRelight;
    /// <summary>
    /// A blurb of text describing what you do not wish to see in the output image.
    /// </summary>
    /// <param name="Value">
    /// [1 .. 10000] characters
    /// </param>
    /// <remarks>
    /// This is an advanced feature.
    /// </remarks>
    function NegativePrompt(const Value: string): TReplaceBackgroundAndRelight;
    /// <summary>
    /// How much to overlay the original subject to exactly match the original image.
    /// </summary>
    /// <param name="Value">
    /// Number: [0 .. 1] (Default 0.6)
    /// </param>
    /// <remarks>
    /// A 1.0 is an exact pixel match for the subject, and 0.0 is a close match but will have new lighting qualities. This is an advanced feature.
    /// </remarks>
    function PreserveOriginalSubject(const Value: Double): TReplaceBackgroundAndRelight;
    /// <summary>
    /// Controls the generated background to have the same depth as the original subject image.
    /// </summary>
    /// <param name="Value">
    /// Number: [0 .. 1] (Default 0.5)
    /// </param>
    /// <remarks>
    /// This is an advanced feature.
    /// </remarks>
    function OriginalBackgroundDepth(const Value: Double): TReplaceBackgroundAndRelight;
    /// <summary>
    /// Whether to keep the background of the original image.
    /// </summary>
    /// <param name="Value">
    /// Enum: false, true (Default false)
    /// </param>
    /// <remarks>
    /// When this is on, the background will have different lighting than the original image that changes based on the other parameters in this API.
    /// </remarks>
    function KeepOriginalBackground(const Value: Boolean): TReplaceBackgroundAndRelight;
    /// <summary>
    /// Direction of the light source.
    /// </summary>
    /// <param name="Value">
    /// Enum: <c>above</c>, <c>below</c>, <c>left</c>, <c>right</c>,
    /// </param>
    function LightSourceDirection(const Value: TLightSourceDirection): TReplaceBackgroundAndRelight;
    /// <summary>
    /// An image with the desired lighting. Lighter sections of the light_reference image will correspond to sections with brighter lighting in the output image.
    /// </summary>
    /// <param name="FilePath">
    /// Filename with supported format (jpeg, png, webp)
    /// </param>
    /// <returns>
    /// The updated <c>TStableImageUltra</c> instance.
    /// </returns>
    /// <remarks>
    /// Validation Rules:
    /// <para>
    /// - Every side must be at least 64 pixels
    /// </para>
    /// <para>
    /// - Total pixel count must be between 4,096 and 9,437,184 pixels
    /// </para>
    /// </remarks>
    function LightReference(const FilePath: string): TReplaceBackgroundAndRelight; overload;
    /// <summary>
    /// An image stream providing the desired lighting reference for the output image.
    /// </summary>
    /// <param name="Stream">
    /// A <c>TStream</c> containing the lighting reference image. Supported formats include JPEG, PNG, and WEBP.
    /// </param>
    /// <param name="StreamFreed">
    /// Indicates whether the stream should be automatically freed after processing.
    /// Set to <c>True</c> if the method should take ownership and free the stream,
    /// or <c>False</c> if the caller will manage the stream's lifecycle.
    /// Default is <c>False</c>.
    /// </param>
    /// <returns>
    /// The updated <c>TReplaceBackgroundAndRelight</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// <c>Validation Rules:</c>
    /// </para>
    /// <para>
    /// - Every side of the image must be at least 64 pixels.
    /// </para>
    /// <para>
    /// - Total pixel count must be between 4,096 and 9,437,184 pixels.
    /// </para>
    /// <para>
    /// - The aspect ratio must be between 1:2.5 and 2.5:1.
    /// </para>
    /// <para>
    /// If <c>StreamFreed</c> is set to <c>True</c>, the method will automatically free the stream after processing.
    /// If set to <c>False</c>, the caller is responsible for freeing the stream to prevent memory leaks.
    /// </para>
    /// </remarks>
    function LightReference(const Stream: TStream; StreamFreed: Boolean = False): TReplaceBackgroundAndRelight; overload;
    /// <summary>
    /// If using <c>light_reference_image</c> or <c>light_source_direction</c>, controls the strength of the light source. 1.0 is brighter and 0.0 is dimmer. This is an advanced feature.
    /// </summary>
    /// <param name="Value">
    /// Number: [0 .. 1] (Default 0.3)
    /// </param>
    /// <remarks>
    /// IMPORTANT : Use of this parameter requires <c>light_reference</c> or <c>light_source_direction</c> to be provided.
    /// </remarks>
    function LightSourceStrength(const Value: Double): TReplaceBackgroundAndRelight;
    /// <summary>
    /// A specific value that is used to guide the 'randomness' of the generation
    /// </summary>
    /// <param name="Value">
    /// number [0 .. 4294967294]  (Default: 0)
    /// </param>
    /// <remarks>
    /// Omit this parameter or pass 0 to use a random seed.
    /// </remarks>
    function Seed(const Value: Int64): TReplaceBackgroundAndRelight;
    /// <summary>
    /// Dictates the content-type of the generated image.
    /// </summary>
    /// <param name="Value">
    /// Enum: <c>jpeg</c>, <c>png</c>, <c>webp</c>
    /// </param>
    function OutputFormat(const Value: TOutPutFormat): TReplaceBackgroundAndRelight;
    constructor Create; reintroduce;
  end;

  TEditRoute = class(TStabilityAIAPIRoute)
    function Erase(ParamProc: TProc<TErase>): TStableImage; overload;
    procedure Erase(ParamProc: TProc<TErase>; CallBacks: TFunc<TAsynStableImage>); overload;

    function Inpaint(ParamProc: TProc<TInpaint>): TStableImage; overload;
    procedure Inpaint(ParamProc: TProc<TInpaint>; CallBacks: TFunc<TAsynStableImage>); overload;

    function Outpaint(ParamProc: TProc<TOutpaint>): TStableImage; overload;
    procedure Outpaint(ParamProc: TProc<TOutpaint>; CallBacks: TFunc<TAsynStableImage>); overload;

    function SearchAndReplace(ParamProc: TProc<TSearchAndReplace>): TStableImage; overload;
    procedure SearchAndReplace(ParamProc: TProc<TSearchAndReplace>; CallBacks: TFunc<TAsynStableImage>); overload;

    function SearchAndRecolor(ParamProc: TProc<TSearchAndRecolor>): TStableImage; overload;
    procedure SearchAndRecolor(ParamProc: TProc<TSearchAndRecolor>; CallBacks: TFunc<TAsynStableImage>); overload;

    function RemoveBackground(ParamProc: TProc<TRemoveBackground>): TStableImage; overload;
    procedure RemoveBackground(ParamProc: TProc<TRemoveBackground>; CallBacks: TFunc<TAsynStableImage>); overload;

    function ReplaceBackgroundAndRelight(ParamProc: TProc<TReplaceBackgroundAndRelight>): TStableImage; overload;
    procedure ReplaceBackgroundAndRelight(ParamProc: TProc<TReplaceBackgroundAndRelight>; CallBacks: TFunc<TAsynStableImage>); overload;
  end;

implementation

uses
  StabilityAI.NetEncoding.Base64, StabilityAI.Consts, StabilityAI.Async.Support;

{ TEditRoute }

procedure TEditRoute.Erase(ParamProc: TProc<TErase>; CallBacks: TFunc<TAsynStableImage>);
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
        Result := Self.Erase(ParamProc);
      end);
  finally
    Free;
  end;
end;

procedure TEditRoute.Inpaint(ParamProc: TProc<TInpaint>; CallBacks: TFunc<TAsynStableImage>);
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
        Result := Self.Inpaint(ParamProc);
      end);
  finally
    Free;
  end;
end;

procedure TEditRoute.Outpaint(ParamProc: TProc<TOutpaint>; CallBacks: TFunc<TAsynStableImage>);
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
        Result := Self.Outpaint(ParamProc);
      end);
  finally
    Free;
  end;
end;

procedure TEditRoute.RemoveBackground(ParamProc: TProc<TRemoveBackground>; CallBacks: TFunc<TAsynStableImage>);
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
        Result := Self.RemoveBackground(ParamProc);
      end);
  finally
    Free;
  end;
end;

procedure TEditRoute.ReplaceBackgroundAndRelight(
  ParamProc: TProc<TReplaceBackgroundAndRelight>;
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
        Result := Self.ReplaceBackgroundAndRelight(ParamProc);
      end);
  finally
    Free;
  end;
end;

procedure TEditRoute.SearchAndRecolor(ParamProc: TProc<TSearchAndRecolor>;
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
        Result := Self.SearchAndRecolor(ParamProc);
      end);
  finally
    Free;
  end;
end;

procedure TEditRoute.SearchAndReplace(ParamProc: TProc<TSearchAndReplace>;
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
        Result := Self.SearchAndReplace(ParamProc);
      end);
  finally
    Free;
  end;
end;

function TEditRoute.Erase(ParamProc: TProc<TErase>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TErase>('v2beta/stable-image/edit/erase', ParamProc);
end;

function TEditRoute.Inpaint(ParamProc: TProc<TInpaint>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TInpaint>('v2beta/stable-image/edit/inpaint', ParamProc);
end;

function TEditRoute.Outpaint(ParamProc: TProc<TOutpaint>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TOutpaint>('v2beta/stable-image/edit/outpaint', ParamProc);
end;

function TEditRoute.RemoveBackground(ParamProc: TProc<TRemoveBackground>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TRemoveBackground>('v2beta/stable-image/edit/remove-background', ParamProc);
end;

function TEditRoute.ReplaceBackgroundAndRelight(
  ParamProc: TProc<TReplaceBackgroundAndRelight>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TReplaceBackgroundAndRelight>('v2beta/stable-image/edit/replace-background-and-relight', ParamProc);
end;

function TEditRoute.SearchAndRecolor(ParamProc: TProc<TSearchAndRecolor>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TSearchAndRecolor>('v2beta/stable-image/edit/search-and-recolor', ParamProc);
end;

function TEditRoute.SearchAndReplace(ParamProc: TProc<TSearchAndReplace>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TSearchAndReplace>('v2beta/stable-image/edit/search-and-replace', ParamProc);
end;

{ TRemoveBackground }

constructor TRemoveBackground.Create;
begin
  inherited Create(True);
end;

{ TErase }

constructor TErase.Create;
begin
  inherited Create;
end;

function TErase.Mask(const FilePath: string): TErase;
begin
  AddBytes('mask', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TErase.Mask(const Stream: TStream; StreamFreed: Boolean): TErase;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('mask', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('mask', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

{ TInpaint }

constructor TInpaint.Create;
begin
  inherited Create(True);
end;

function TInpaint.Mask(const FilePath: string): TInpaint;
begin
  AddBytes('mask', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TInpaint.Mask(const Stream: TStream; StreamFreed: Boolean): TInpaint;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('mask', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('mask', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

function TInpaint.NegativePrompt(const Value: string): TInpaint;
begin
  AddField(Check('negative_prompt', Value), Value);
  Result := Self;
end;

{ TOutpaint }

constructor TOutpaint.Create;
begin
  inherited Create(True);
end;

function TOutpaint.Creativity(const Value: Double): TOutpaint;
begin
  AddField(CheckFloat('creativity', Value, 0, 1), Value.ToString);
  Result := Self;
end;

function TOutpaint.Down(const Value: Integer): TOutpaint;
begin
  AddField(CheckInteger('down', Value, 0 ,2000), Value.ToString);
  Result := Self;
end;

function TOutpaint.Left(const Value: Integer): TOutpaint;
begin
  AddField(CheckInteger('left', Value, 0 ,2000), Value.ToString);
  Result := Self;
end;

function TOutpaint.Prompt(const Value: string): TOutpaint;
begin
  AddField(Check('prompt', Value), Value);
  Result := Self;
end;

function TOutpaint.Right(const Value: Integer): TOutpaint;
begin
  AddField(CheckInteger('right', Value, 0 ,2000), Value.ToString);
  Result := Self;
end;

function TOutpaint.Up(const Value: Integer): TOutpaint;
begin
  AddField(CheckInteger('up', Value, 0 ,2000), Value.ToString);
  Result := Self;
end;

{ TSearchAndReplace }

constructor TSearchAndReplace.Create;
begin
  inherited Create(True);
end;

function TSearchAndReplace.NegativePrompt(
  const Value: string): TSearchAndReplace;
begin
  AddField(Check('negative_prompt', Value), Value);
  Result := Self;
end;

function TSearchAndReplace.SearchPrompt(const Value: string): TSearchAndReplace;
begin
  AddField(Check('search_prompt', Value), Value);
  Result := Self;
end;

{ TReplaceBackgroundAndRelight }

function TReplaceBackgroundAndRelight.BackgroundPrompt(
  const Value: string): TReplaceBackgroundAndRelight;
begin
  AddField(Check('background_prompt', Value), Value);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.BackgroundReference(
  const FilePath: string): TReplaceBackgroundAndRelight;
begin
  AddBytes('background_reference', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.BackgroundReference(const Stream: TStream;
  StreamFreed: Boolean): TReplaceBackgroundAndRelight;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('background_reference', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('background_reference', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

constructor TReplaceBackgroundAndRelight.Create;
begin
  inherited Create(True);
end;

function TReplaceBackgroundAndRelight.ForegroundPrompt(
  const Value: string): TReplaceBackgroundAndRelight;
begin
  AddField(Check('foreground_prompt', Value), Value);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.KeepOriginalBackground(
  const Value: Boolean): TReplaceBackgroundAndRelight;
begin
  AddField('keep_original_background', BoolToStr(Value, True).ToLower);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.LightReference(
  const FilePath: string): TReplaceBackgroundAndRelight;
begin
  AddBytes('light_reference', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.LightReference(const Stream: TStream;
  StreamFreed: Boolean): TReplaceBackgroundAndRelight;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('light_reference', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('light_reference', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

function TReplaceBackgroundAndRelight.LightSourceDirection(
  const Value: TLightSourceDirection): TReplaceBackgroundAndRelight;
begin
  AddField('light_source_direction', Value.ToString);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.LightSourceStrength(
  const Value: Double): TReplaceBackgroundAndRelight;
begin
  AddField(CheckFloat('light_source_strength', Value, 0 ,1), Value.ToString);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.NegativePrompt(
  const Value: string): TReplaceBackgroundAndRelight;
begin
  AddField(Check('negative_prompt', Value), Value);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.OriginalBackgroundDepth(
  const Value: Double): TReplaceBackgroundAndRelight;
begin
  AddField(CheckFloat('original_background_depth', Value, 0 ,1), Value.ToString);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.OutputFormat(
  const Value: TOutPutFormat): TReplaceBackgroundAndRelight;
begin
  AddField('output_format', Value.ToString);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.PreserveOriginalSubject(
  const Value: Double): TReplaceBackgroundAndRelight;
begin
  AddField(CheckFloat('preserve_original_subject', Value, 0 ,1), Value.ToString);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.Seed(
  const Value: Int64): TReplaceBackgroundAndRelight;
begin
  AddField(CheckInteger('seed', Value, 0, SeedMax), Value.ToString);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.SubjectImage(
  const FilePath: string): TReplaceBackgroundAndRelight;
begin
  AddBytes('subject_image', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.SubjectImage(const Stream: TStream;
  StreamFreed: Boolean): TReplaceBackgroundAndRelight;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('subject_image', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('subject_image', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

end.
