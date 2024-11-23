unit StabilityAI.Version1.SDXL1AndSD1_6;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

uses
  System.SysUtils, System.Classes, System.Net.Mime, REST.JsonReflect, System.JSON,
  REST.Json.Types, StabilityAI.API, StabilityAI.API.Params, StabilityAI.Types,
  StabilityAI.Common, StabilityAI.Async.Support;

type
  /// <summary>
  /// CLIP guidance preset, use with ancestral sampler for best results.
  /// </summary>
  /// <remarks>
  /// FAST_BLUE, FAST_GREEN, NONE, SIMPLE, SLOW, SLOWER, SLOWEST
  /// </remarks>
  TClipGuidancePresetType = (
    FAST_BLUE,
    FAST_GREEN,
    NONE,
    SIMPLE,
    SLOW,
    SLOWER,
    SLOWEST
  );

  TClipGuidancePresetTypeHelper = record helper for TClipGuidancePresetType
    function ToString: string;
  end;

  /// <summary>
  /// Available Samplers
  /// </summary>
  /// <remarks>
  /// DDIM, DDPM, K_DPMPP_2M, K_DPMPP_2S_ANCESTRAL, K_DPM_2, K_DPM_2_ANCESTRAL, K_EULER, K_EULER_ANCESTRAL, K_HEUN, K_LMS
  /// </remarks>
  TSamplerType = (
    DDIM,
    DDPM,
    K_DPMPP_2M,
    K_DPMPP_2S_ANCESTRAL,
    K_DPM_2,
    K_DPM_2_ANCESTRAL,
    K_EULER,
    K_EULER_ANCESTRAL,
    K_HEUN,
    K_LMS
   );

  TSamplerTypeHelper = record helper for TSamplerType
    function ToString: string;
  end;

  /// <summary>
  /// Used to control how much influence the <c>init_image</c> has on the result
  /// </summary>
  /// <remarks>
  /// IMAGE_STRENGTH, STEP_SCHEDULE
  /// </remarks>
  TInitImageMode = (
    IMAGE_STRENGTH,
    STEP_SCHEDULE
  );

  TInitImageModeHelper = record helper for TInitImageMode
    function ToString: string;
  end;

  /// <summary>
  /// Type of mask to detemines where to source the mask
  /// </summary>
  /// <remarks>
  /// <c>MASK_IMAGE_WHITE</c>, <c>MASK_IMAGE_BLACK</c>, <c>INIT_IMAGE_ALPHA</c>
  /// </remarks>
  TMaskSource = (
    /// <summary>
    /// Use the white pixels of the mask_image as the mask, where white pixels are completely replaced and black pixels are unchanged
    /// </summary>
    MASK_IMAGE_WHITE,
    /// <summary>
    /// Use the black pixels of the mask_image as the mask, where black pixels are completely replaced and white pixels are unchanged
    /// </summary>
    MASK_IMAGE_BLACK,
    /// <summary>
    /// Use the alpha channel of the init_image as the mask, where fully transparent pixels are completely replaced and fully opaque pixels are unchanged
    /// </summary>
    INIT_IMAGE_ALPHA
  );

  TMaskSourceHelper = record helper for TMaskSource
    function ToString: string;
  end;

  /// <summary>
  /// Represents a prompt used in Stable Diffusion APIs for image generation.
  /// </summary>
  /// <remarks>
  /// This class provides methods to define a textual prompt and assign weights to it.
  /// Prompts can influence the content of generated images, where higher weights
  /// increase the prominence of the associated text in the final output.
  /// Use negative weights for negative prompts to reduce the influence of undesired elements.
  /// </remarks>
  TPrompt = class(TJSONParam)
  public
    /// <summary>
    /// The prompt itself.
    /// </summary>
    /// <param name="Value">
    /// string <= 2000 characters
    /// </param>
    function Text(const Value: string): TPrompt;
    /// <summary>
    /// Weight of the prompt (use negative numbers for negative prompts)
    /// </summary>
    /// <param name="Value">
    /// number <float>
    /// </param>
    function Weight(const Value: Double): TPrompt;
    /// <summary>
    /// Creates a new instance of the <c>TPrompt</c> class with the specified text.
    /// </summary>
    /// <param name="Value">
    /// The text of the prompt. Must be a string of 2000 characters or fewer.
    /// </param>
    /// <returns>
    /// A new <c>TPrompt</c> instance with the specified text.
    /// </returns>
    class function New(const Value: string): TPrompt; overload; static;
    /// <summary>
    /// Creates a new instance of the <c>TPrompt</c> class with the specified text and weight.
    /// </summary>
    /// <param name="Weight">
    /// The weight of the prompt. Use positive values to increase the influence
    /// of the prompt and negative values for negative prompts.
    /// </param>
    /// <param name="Value">
    /// The text of the prompt. Must be a string of 2000 characters or fewer.
    /// </param>
    /// <returns>
    /// A new <c>TPrompt</c> instance with the specified text and weight.
    /// </returns>
    class function New(const Weight: Double; const Value: string): TPrompt; overload; static;
  end;

  /// <summary>
  /// Represents a collection of methods and properties for handling parameters used to interact with Stable Diffusion APIs.
  /// </summary>
  /// <remarks>
  /// The <c>TPayload</c> class is designed to encapsulate the different configurations needed to interface with the Stable Diffusion APIs,
  /// such as SDXL 1.0 and SD 1.6. This class allows parameters to be provided in a structured manner using anonymous methods, making it
  /// flexible and reusable when generating prompts for different API requests. It abstracts the complexity of parameter management,
  /// providing a consistent interface for initiating image generation processes.
  /// </remarks>
  TPayload = class(TJSONParam)
  public
    /// <summary>
    /// An array of text prompts to use for generation.
    /// </summary>
    function TextPrompts(const Value: TArray<TPrompt>): TPayload;
    /// <summary>
    /// Height of the image to generate, in pixels, in an increment divisible by 64.
    /// </summary>
    /// <param name="Value">
    /// integer (DiffuseImageHeight) multiple of 64 >= 128
    /// <para>
    /// Default: 512
    /// </para>
    /// </param>
    function Height(const Value: Integer): TPayload;
    /// <summary>
    /// Width of the image to generate, in pixels, in an increment divisible by 64.
    /// </summary>
    /// <param name="Value">
    /// integer (DiffuseImageWidth) multiple of 64 >= 128
    /// <para>
    /// Default: 512
    /// </para>
    /// </param>
    function Width(const Value: Integer): TPayload;
    /// <summary>
    /// How strictly the diffusion process adheres to the prompt text (higher values keep your image closer to your prompt)
    /// </summary>
    /// <param name="Value">
    /// Number: (CfgScale) [0 .. 35]
    /// <para>
    /// Default: 7
    /// </para>
    /// </param>
    function CfgScale(const Value: Double): TPayload;
    /// <summary>
    /// Set the clip guidance preset
    /// </summary>
    /// <param name="Value">
    /// Enum: <c>FAST_BLUE</c>, <c>FAST_GREEN</c>, <c>NONE</c>, <c>SIMPLE</c>, <c>SLOW</c>, <c>SLOWER</c>, <c>SLOWEST</c>
    /// <para>
    /// Default: <c>NONE</c>
    /// </para>
    /// </param>
    function ClipGuidancePreset(const Value: TClipGuidancePresetType): TPayload;
    /// <summary>
    /// Select sampler to use for the diffusion process.
    /// </summary>
    /// <param name="Value">
    /// Enum: DDIM, DDPM, K_DPMPP_2M, K_DPMPP_2S_ANCESTRAL, K_DPM_2, K_DPM_2_ANCESTRAL, K_EULER, K_EULER_ANCESTRAL, K_HEUN, K_LMS
    /// </param>
    /// <remarks>
    /// If this value is omitted it will automatically select an appropriate sampler for you.
    /// </remarks>
    function Sampler(const Value: TSamplerType): TPayload;
    /// <summary>
    /// Number of images to generate
    /// </summary>
    /// <param name="Value">
    /// Integer: [1 .. 10]
    /// <para>
    /// Default: 1
    /// </para>
    /// </param>
    function Samples(const Value: Integer): TPayload;
    /// <summary>
    /// A specific value that is used to guide the 'randomness' of the generation
    /// </summary>
    /// <param name="Value">
    /// number [0 .. 4294967294]  (Default: 0)
    /// </param>
    /// <remarks>
    /// Omit this parameter or pass 0 to use a random seed.
    /// </remarks>
    function Seed(const Value: Int64): TPayload;
    /// <summary>
    /// Number of diffusion steps to run.
    /// </summary>
    /// <param name="Value">
    /// Integer: [10 .. 50]
    /// <para>
    /// Default: 30
    /// </para>
    /// </param>
    function Steps(const Value: Integer): TPayload;
    /// <summary>
    /// Pass in a style preset to guide the image model towards a particular style.
    /// </summary>
    /// <param name="Value">
    /// Enum: <c>3d-model</c> <c>analog-film</c> <c>anime</c> <c>cinematic</c> <c>comic-book</c> <c>digital-art</c> <c>enhance</c> <c>fantasy-art</c> <c>isometric</c> <c>line-art</c> <c>low-poly</c> <c>modeling-compound</c> <c>neon-punk</c> <c>origami</c> <c>photographic</c> <c>pixel-art</c> <c>tile-texture</c>
    /// </param>
    /// <remarks>
    /// This list of style presets is subject to change.
    /// </remarks>
    function StylePreset(const Value: TStylePreset): TPayload;
    /// <summary>
    /// Extra parameters passed to the engine. These parameters are used for in-development or experimental features and may change without warning
    /// </summary>
    /// <param name="Value">
    /// A JSON object
    /// </param>
    /// <remarks>
    /// So please use with caution.
    /// </remarks>
    function Extras(const Value: TJSONObject): TPayload;
  end;

  /// <summary>
  /// Represents a multipart prompt used in Stable Diffusion APIs for image generation.
  /// </summary>
  /// <remarks>
  /// This class allows the definition of text prompts and their associated weights
  /// for use in multipart form submissions. Each prompt influences the generation
  /// process based on its weight, where higher weights emphasize the importance of
  /// the associated text, and negative weights suppress undesired elements.
  /// Use this class for scenarios that require multipart payloads for image generation APIs.
  /// </remarks>
  TPromptMultipart = class
  private
    FText: string;
    FWeight: Double;
  public
    /// <summary>
    /// The prompt itself.
    /// </summary>
    /// <param name="Value">
    /// string <= 2000 characters
    /// </param>
    property Text: string read FText write FText;
    /// <summary>
    /// Weight of the prompt (use negative numbers for negative prompts)
    /// </summary>
    /// <param name="Value">
    /// number <float>
    /// </param>
    property Weight: Double read FWeight write FWeight;
    /// <summary>
    /// Creates a new instance of the <c>TPromptMultipart</c> class with the specified text.
    /// </summary>
    /// <param name="Text">
    /// The text of the prompt. Must be a string of 2000 characters or fewer.
    /// </param>
    /// <returns>
    /// A new <c>TPromptMultipart</c> instance with the specified text.
    /// </returns>
    class function New(const Text: string): TPromptMultipart; overload;
    /// <summary>
    /// Creates a new instance of the <c>TPromptMultipart</c> class with the specified text and weight.
    /// </summary>
    /// <param name="Weight">
    /// The weight of the prompt. Use positive values to increase the influence
    /// of the prompt and negative values for negative prompts.
    /// </param>
    /// <param name="Value">
    /// The text of the prompt. Must be a string of 2000 characters or fewer.
    /// </param>
    /// <returns>
    /// A new <c>TPromptMultipart</c> instance with the specified text and weight.
    /// </returns>
    class function New(const Weight: Double; const Value: string): TPromptMultipart; overload;
  end;

  /// <summary>
  /// Represents a common payload structure for interacting with Stable Diffusion APIs.
  /// </summary>
  /// <remarks>
  /// This class encapsulates common parameters and methods required to generate
  /// images using Stable Diffusion APIs. It supports configurations such as
  /// text prompts, initialization images, sampling methods, and style presets.
  /// The flexible interface allows for detailed customization of the image generation process.
  /// </remarks>
  TPlayloadCommon = class(TMultipartFormData)
    /// <summary>
    /// An array of text prompts to use for generation.
    /// </summary>
    function TextPrompts(const Value: TArray<TPromptMultipart>): TPlayloadCommon;
    /// <summary>
    /// Image used to initialize the diffusion process, in lieu of random noise.
    /// </summary>
    /// <param name="FilePath">
    /// Filename with supported format (jpeg, png, webp)
    /// </param>
    function InitImage(const FilePath: string): TPlayloadCommon; overload;
    /// <summary>
    /// Image used to initialize the diffusion process, in lieu of random noise.
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
    function InitImage(const Stream: TStream; StreamFreed: Boolean = False): TPlayloadCommon; overload;
    /// <summary>
    /// How strictly the diffusion process adheres to the prompt text (higher values keep your image closer to your prompt)
    /// </summary>
    /// <param name="Value">
    /// Number: (CfgScale) [0 .. 35]
    /// <para>
    /// Default: 7
    /// </para>
    /// </param>
    function CfgScale(const Value: Double): TPlayloadCommon;
    /// <summary>
    /// Set the clip guidance preset
    /// </summary>
    /// <param name="Value">
    /// Enum: <c>FAST_BLUE</c>, <c>FAST_GREEN</c>, <c>NONE</c>, <c>SIMPLE</c>, <c>SLOW</c>, <c>SLOWER</c>, <c>SLOWEST</c>
    /// <para>
    /// Default: <c>NONE</c>
    /// </para>
    /// </param>
    function ClipGuidancePreset(const Value: TClipGuidancePresetType): TPlayloadCommon;
    /// <summary>
    /// Number of images to generate
    /// </summary>
    /// <param name="Value">
    /// Integer: [1 .. 10]
    /// <para>
    /// Default: 1
    /// </para>
    /// </param>
    function Sampler(const Value: TSamplerType): TPlayloadCommon;
    /// <summary>
    /// A specific value that is used to guide the 'randomness' of the generation
    /// </summary>
    /// <param name="Value">
    /// number [0 .. 4294967294]  (Default: 0)
    /// </param>
    /// <remarks>
    /// Omit this parameter or pass 0 to use a random seed.
    /// </remarks>
    function Samples(const Value: Integer): TPlayloadCommon;
    /// <summary>
    /// A specific value that is used to guide the 'randomness' of the generation
    /// </summary>
    /// <param name="Value">
    /// number [0 .. 4294967294]  (Default: 0)
    /// </param>
    /// <remarks>
    /// Omit this parameter or pass 0 to use a random seed.
    /// </remarks>
    function Seed(const Value: Int64): TPlayloadCommon;
    /// <summary>
    /// Number of diffusion steps to run.
    /// </summary>
    /// <param name="Value">
    /// Integer: [10 .. 50]
    /// <para>
    /// Default: 30
    /// </para>
    /// </param>
    function Steps(const Value: Integer): TPlayloadCommon;
    /// <summary>
    /// Pass in a style preset to guide the image model towards a particular style.
    /// </summary>
    /// <param name="Value">
    /// Enum: <c>3d-model</c> <c>analog-film</c> <c>anime</c> <c>cinematic</c> <c>comic-book</c> <c>digital-art</c> <c>enhance</c> <c>fantasy-art</c> <c>isometric</c> <c>line-art</c> <c>low-poly</c> <c>modeling-compound</c> <c>neon-punk</c> <c>origami</c> <c>photographic</c> <c>pixel-art</c> <c>tile-texture</c>
    /// </param>
    /// <remarks>
    /// This list of style presets is subject to change.
    /// </remarks>
    function StylePreset(const Value: TStylePreset): TPlayloadCommon;
    /// <summary>
    /// Extra parameters passed to the engine. These parameters are used for in-development or experimental features and may change without warning
    /// </summary>
    /// <param name="Value">
    /// A JSON object
    /// </param>
    /// <remarks>
    /// So please use with caution.
    /// </remarks>
    function Extras(const Value: TJSONObject): TPlayloadCommon;
  end;

  /// <summary>
  /// Represents a payload manager for API prompts used to generate images from existing images using text prompts.
  /// </summary>
  /// <remarks>
  /// This class is designed to facilitate interaction with APIs that generate images based on initial input images and textual prompts.
  /// It supports configuration of strength parameters, such as <c>image_strength</c> or <c>step_schedule</c>, allowing control over how much of the original image is preserved during the generation process.
  /// Use <c>TPayloadPrompt</c> to manage and prepare the necessary parameters, encapsulating them in anonymous methods to be used by other methods interacting with the underlying API.
  /// Note that these APIs only work with Version 1 engines.
  /// </remarks>
  TPayloadPrompt = class(TPlayloadCommon)
    /// <summary>
    /// Whether to use image_strength or step_schedule_* to control how much influence the init_image has on the result.
    /// </summary>
    /// <param name="Value">
    /// Enum: IMAGE_STRENGTH, STEP_SCHEDULE
    /// <para>
    /// Default: IMAGE_STRENGTH
    /// </para>
    /// </param>
    function InitImageMode(const Value: TInitImageMode): TPayloadPrompt;
    /// <summary>
    /// How much influence the init_image has on the diffusion process.
    /// </summary>
    /// <param name="Value">
    /// Number: [0 .. 1]
    /// <para>
    /// Default: 0.35
    /// </para>
    /// </param>
    function ImageStrength(const Value: Double): TPayloadPrompt;
    /// <summary>
    /// Skips a proportion of the start of the diffusion steps, allowing the init_image to influence the final generated image.
    /// </summary>
    /// <param name="Value">
    /// Number: [0 .. 1]
    /// <para>
    /// Default: 0.65
    /// </para>
    /// </param>
    /// <remarks>
    /// Lower values will result in more influence from the init_image, while higher values will result in more influence from the diffusion steps. (e.g. a value of 0 would simply return you the init_image, where a value of 1 would return you a completely different image.)
    /// </remarks>
    function StepScheduleStart(const Value: Double): TPayloadPrompt;
    /// <summary>
    /// Skips a proportion of the end of the diffusion steps, allowing the init_image to influence the final generated image.
    /// </summary>
    /// <param name="Value">
    /// Number: [0 .. 1]
    /// </param>
    /// <remarks>
    /// Lower values will result in more influence from the init_image, while higher values will result in more influence from the diffusion steps.
    /// </remarks>
    function StepScheduleEnd(const Value: Double): TPayloadPrompt;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// Represents the payload required to manage image modifications using a mask for the image-to-image API.
  /// This class is used to encapsulate and manage the parameters for selectively altering portions of an image.
  /// </summary>
  /// <remarks>
  /// The <c>TPayloadMask</c> class facilitates the creation of payload data, which includes managing image and mask parameters.
  /// It is designed to work with Version 1 engines of the image API and allows the parameters to be provided through anonymous methods to the API interaction functions.
  /// The class abstracts the complexity of setting image parameters, ensuring correct format and consistency, especially when dealing with alpha channels and masked image transformations.
  /// </remarks>
  TPayloadMask = class(TPlayloadCommon)
    /// <summary>
    /// For any given pixel, the mask determines the strength of generation on a linear scale. This parameter determines where to source the mask from
    /// </summary>
    /// <param name="Value">
    /// Enum: <c>MASK_IMAGE_WHITE</c>, <c>MASK_IMAGE_BLACK</c>, <c>INIT_IMAGE_ALPHA</c>
    /// </param>
    /// <remarks>
    /// <para>
    /// - <c>MASK_IMAGE_WHITE</c> will use the white pixels of the mask_image as the mask, where white pixels are completely replaced and black pixels are unchanged
    /// </para>
    /// <para>
    /// - <c>MASK_IMAGE_BLACK</c> will use the black pixels of the mask_image as the mask, where black pixels are completely replaced and white pixels are unchanged
    /// </para>
    /// <para>
    /// - <c>INIT_IMAGE_ALPHA</c> will use the alpha channel of the init_image as the mask, where fully transparent pixels are completely replaced and fully opaque pixels are unchanged
    /// </para>
    /// </remarks>
    function MaskSource(const Value: TMaskSource): TPayloadMask;
    /// <summary>
    /// Optional grayscale mask that allows for influence over which pixels are eligible for diffusion and at what strength. Must be the same dimensions as the init_image. Use the <c>mask_source</c> option to specify whether the white or black pixels should be inpainted.
    /// </summary>
    /// <param name="FilePath">
    /// Filename with supported format (jpeg, png, webp)
    /// </param>
    function MaskImage(const FilePath: string): TPayloadMask; overload;
    /// <summary>
    /// Optional grayscale mask that allows for influence over which pixels are eligible for diffusion and at what strength. Must be the same dimensions as the init_image. Use the <c>mask_source</c> option to specify whether the white or black pixels should be inpainted.
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
    function MaskImage(const Stream: TStream; StreamFreed: Boolean = False): TPayloadMask; overload;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// Represents an artifact generated by the Stable Diffusion API.
  /// </summary>
  /// <remarks>
  /// This class <c>TJSONArtifact</c> encapsulates information about an artifact, such as its image data encoded in base64,
  /// the reason for the artifact's creation, and the associated seed. Artifacts are typically generated
  /// as the result of image creation processes.
  /// </remarks>
  TJSONArtifact = class
  private
    FBase64: string;
    [JsonReflectAttribute(ctString, rtString, TFinishReasonInterceptor)]
    FFinishReason: TFinishReason;
    FSeed: Int64;
  public
    /// <summary>
    /// A string containing the Base64-encoded image data.
    /// </summary>
    property Base64: string read FBase64 write FBase64;
    /// <summary>
    /// Values can indicate success, an error, or that content was filtered.
    /// <para>
    /// Enum: <c>CONTENT_FILTERED</c>, <c>ERROR</c>, <c>SUCCESS</c>
    /// </para>
    /// </summary>
    property FinishReason: TFinishReason read FFinishReason write FFinishReason;
    /// <summary>
    /// An <c>Int64</c> representing the seed used in the generation process.
    /// </summary>
    /// <remarks>
    /// This seed can be reused to replicate the artifact during image generation.
    /// </remarks>
    property Seed: Int64 read FSeed write FSeed;
  end;

  /// <summary>
  /// Represents an artifact in the Stable Diffusion API system.
  /// </summary>
  /// <remarks>
  /// This class is designed to handle individual artifacts generated by the Stable Diffusion image generation process.
  /// Each artifact typically corresponds to an image that can be encoded in Base64 format.
  /// </remarks>
  TArtifact = class(TJSONArtifact)
  private
    FFileName: string;
  public
    /// <summary>
    /// Retrieves the artifact's image as a stream.
    /// </summary>
    /// <returns>
    /// A <c>TStream</c> containing the decoded image data.
    /// </returns>
    /// <remarks>
    /// Use this method to manipulate the image data programmatically.
    /// </remarks>
    /// <exception cref="Exception">
    /// Raised if the Base64 content is empty.
    /// </exception>
    function GetStream: TStream;
    /// <summary>
    /// Saves the artifact's image to a specified file.
    /// </summary>
    /// <param name="FileName">
    /// The name of the file to save the image to, including its path and extension.
    /// </param>
    /// <remarks>
    /// This method decodes the Base64-encoded image and writes it to a file.
    /// </remarks>
    /// <exception cref="Exception">
    /// Raised if the Base64 content is empty.
    /// </exception>
    procedure SaveToFile(const FileName: string);
    /// <summary>
    /// The filename associated with this artifact.
    /// </summary>
    /// <remarks>
    /// This property holds the name of the file where the artifact's image is saved or will be saved.
    /// </remarks>
    property FileName: string read FFileName;
  end;

  /// <summary>
  /// Represents a collection of artifacts generated by the Stable Diffusion API system.
  /// </summary>
  /// <remarks>
  /// This class encapsulates a list of artifacts, typically corresponding to multiple images generated in a single API request.
  /// Each artifact is represented by a <c>TArtifact</c> instance.
  /// </remarks>
  TJSONArtifacts = class
  private
    FArtifacts: TArray<TArtifact>;
  public
    /// <summary>
    /// Collection of artifacts generated during the image generation process.
    /// </summary>
    /// <remarks>
    /// Access this property to retrieve the individual artifacts.
    /// </remarks>
    property Artifacts: TArray<TArtifact> read FArtifacts write FArtifacts;
    destructor Destroy; override;
  end;

  /// <summary>
  /// Represents a collection of artifacts generated by the Stable Diffusion API.
  /// </summary>
  /// <remarks>
  /// This class encapsulates a set of artifacts, typically representing multiple generated images.
  /// It provides methods to save all artifacts to files and manage their associated metadata, such as file paths and extensions.
  /// </remarks>
  TArtifacts = class(TJSONArtifacts)
  private
    FFilePath: string;
    FExtension: string;
    FFileName: string;
  protected
    function GetFilePath(index: Integer): string;
    procedure SetFilePath(const Value: string);
  public
    /// <summary>
    /// Saves all artifacts in the collection to files.
    /// </summary>
    /// <param name="FileName">
    /// The base filename for saving the artifacts. Files will be named with indexed suffixes if multiple artifacts exist.
    /// </param>
    /// <remarks>
    procedure SaveToFile(const FileName: string);
    /// <summary>
    /// The file path for a specific artifact by index.
    /// </summary>
    /// <param name="index">
    /// The index of the artifact within the collection.
    /// </param>
    /// <returns>
    property FilePath[index: Integer]: string read GetFilePath;
    /// <summary>
    /// The base filename used for saving artifacts.
    /// </summary>
    /// <remarks>
    /// This property holds the name of the base file used when saving artifacts to disk.
    /// </remarks>
    property FileName: string read FFileName;
  end;

  /// <summary>
  /// Manages asynchronous chat callBacks for a chat request using <c>TArtifacts</c> as the response type.
  /// </summary>
  /// <remarks>
  /// The <c>TAsynArtifacts</c> type extends the <c>TAsynParams&lt;TArtifacts&gt;</c> record to handle the lifecycle of an asynchronous chat operation.
  /// It provides event handlers that trigger at various stages, such as when the operation starts, completes successfully, or encounters an error.
  /// This structure facilitates non-blocking chat operations and is specifically tailored for scenarios where multiple choices from a chat model are required.
  /// </remarks>
  TAsynArtifacts = TAsynCallBack<TArtifacts>;

  TVersion1Route = class(TStabilityAIAPIRoute)
    function TextToImage(const Model: string; ParamProc: TProc<TPayload>): TArtifacts; overload;
    procedure TextToImage(const Model: string; ParamProc: TProc<TPayload>;
      CallBacks: TFunc<TAsynArtifacts>); overload;

    function ImageToImageWithPrompt(const Model: string; ParamProc: TProc<TPayloadPrompt>): TArtifacts; overload;
    procedure ImageToImageWithPrompt(const Model: string; ParamProc: TProc<TPayloadPrompt>;
      CallBacks: TFunc<TAsynArtifacts>); overload;

    function ImageToImageWithMask(const Model: string; ParamProc: TProc<TPayloadMask>): TArtifacts; overload;
    procedure ImageToImageWithMask(const Model: string; ParamProc: TProc<TPayloadMask>;
      CallBacks: TFunc<TAsynArtifacts>); overload;
  end;

implementation

uses
  System.IOUtils, StabilityAI.Consts, StabilityAI.NetEncoding.Base64;

{ TClipGuidancePresetTypeHelper }

function TClipGuidancePresetTypeHelper.ToString: string;
begin
  case Self of
    FAST_BLUE:
      Exit('FAST_BLUE');
    FAST_GREEN:
      Exit('FAST_GREEN');
    NONE:
      Exit('NONE');
    SIMPLE:
      Exit('SIMPLE');
    SLOW:
      Exit('SLOW');
    SLOWER:
      Exit('SLOWER');
    SLOWEST:
      Exit('SLOWEST');
  end;
end;

{ TSamplerTypeHelper }

function TSamplerTypeHelper.ToString: string;
begin
  case Self of
    DDIM:
      Exit('DDIM');
    DDPM:
      Exit('DDPM');
    K_DPMPP_2M:
      Exit('K_DPMPP_2M');
    K_DPMPP_2S_ANCESTRAL:
      Exit('K_DPMPP_2S_ANCESTRAL');
    K_DPM_2:
      Exit('K_DPM_2');
    K_DPM_2_ANCESTRAL:
      Exit('K_DPM_2_ANCESTRAL');
    K_EULER:
      Exit('K_EULER');
    K_EULER_ANCESTRAL:
      Exit('K_EULER_ANCESTRAL');
    K_HEUN:
      Exit('K_HEUN');
    K_LMS:
      Exit('K_LMS');
  end;
end;

{ TPrompt }

class function TPrompt.New(const Value: string): TPrompt;
begin
  Result := TPrompt.Create.Text(Value);
end;

class function TPrompt.New(const Weight: Double;
  const Value: string): TPrompt;
begin
  Result := New(Value).Weight(Weight);
end;

function TPrompt.Text(const Value: string): TPrompt;
begin
  Result := TPrompt(Add(Check('text', Value, 2000), Value));
end;

function TPrompt.Weight(const Value: Double): TPrompt;
begin
  Result := TPrompt(Add('weight', Value));
end;

{ TPayload }

function TPayload.CfgScale(const Value: Double): TPayload;
begin
  Result := TPayload(Add('cfg_scale', CheckFloat(Value, 0.0, 35.0)));
end;

function TPayload.ClipGuidancePreset(
  const Value: TClipGuidancePresetType): TPayload;
begin
  Result := TPayload(Add('clip_guidance_preset', Value.ToString));
end;

function TPayload.Extras(const Value: TJSONObject): TPayload;
begin
  Result := TPayload(Add('extras', Value));
end;

function TPayload.Height(const Value: Integer): TPayload;
begin
  Result := TPayload(Add('height', CheckMultipleOf(Value, 128, 64)));
end;

function TPayload.Sampler(const Value: TSamplerType): TPayload;
begin
  Result := TPayload(Add('sampler', Value.ToString));
end;

function TPayload.Samples(const Value: Integer): TPayload;
begin
  Result := TPayload(Add('samples', CheckInteger(Value, 1, 10)));
end;

function TPayload.Seed(const Value: Int64): TPayload;
begin
  Result := TPayload(Add('seed', CheckInteger(Value, 0, SeedMax)));
end;

function TPayload.Steps(const Value: Integer): TPayload;
begin
  Result := TPayload(Add('steps', CheckInteger(Value, 10, 50)));
end;

function TPayload.StylePreset(const Value: TStylePreset): TPayload;
begin
  Result := TPayload(Add('style_preset', Value.ToString));
end;

function TPayload.TextPrompts(const Value: TArray<TPrompt>): TPayload;
begin
  var JSONArray := TJSONArray.Create;
  for var Item in Value do
    JSONArray.Add(Item.Detach);
  Result := TPayload(Add('text_prompts', JSONArray));
end;

function TPayload.Width(const Value: Integer): TPayload;
begin
  Result := TPayload(Add('width', CheckMultipleOf(Value, 128, 64)));
end;

{ TArtifact }

function TArtifact.GetStream: TStream;
begin
  {--- Create a memory stream to write the decoded content. }
  Result := TMemoryStream.Create;
  try
    {--- Convert the base-64 string directly into the memory stream. }
    if not Base64.IsEmpty then
      DecodeBase64ToStream(Base64, Result)
    else
      raise Exception.Create(StreamEmptyExceptionMessage);
  except
    Result.Free;
    raise;
  end;
end;

procedure TArtifact.SaveToFile(const FileName: string);
begin
  try
    Self.FFileName := FileName;

    {--- Perform the decoding operation and save it into the file specified by the FileName parameter. }
    if not Base64.IsEmpty then
      DecodeBase64ToFile(Base64, FileName)
    else
      raise Exception.Create(DataFileEmptyExceptionMessage);
  except
    raise;
  end;
end;

{ TVersion1Route }

procedure TVersion1Route.ImageToImageWithMask(const Model: string; ParamProc: TProc<TPayloadMask>;
  CallBacks: TFunc<TAsynArtifacts>);
begin
  with TAsynCallBackExec<TAsynArtifacts, TArtifacts>.Create(CallBacks) do
  try
    Sender := Use.Param.Sender;
    OnStart := Use.Param.OnStart;
    OnSuccess := Use.Param.OnSuccess;
    OnError := Use.Param.OnError;
    Run(
      function: TArtifacts
      begin
        Result := Self.ImageToImageWithMask(Model, ParamProc);
      end);
  finally
    Free;
  end;
end;

procedure TVersion1Route.ImageToImageWithPrompt(const Model: string;
  ParamProc: TProc<TPayloadPrompt>;
  CallBacks: TFunc<TAsynArtifacts>);
begin
  with TAsynCallBackExec<TAsynArtifacts, TArtifacts>.Create(CallBacks) do
  try
    Sender := Use.Param.Sender;
    OnStart := Use.Param.OnStart;
    OnSuccess := Use.Param.OnSuccess;
    OnError := Use.Param.OnError;
    Run(
      function: TArtifacts
      begin
        Result := Self.ImageToImageWithPrompt(Model, ParamProc);
      end);
  finally
    Free;
  end;
end;

procedure TVersion1Route.TextToImage(const Model: string;
  ParamProc: TProc<TPayload>; CallBacks: TFunc<TAsynArtifacts>);
begin
  with TAsynCallBackExec<TAsynArtifacts, TArtifacts>.Create(CallBacks) do
  try
    Sender := Use.Param.Sender;
    OnStart := Use.Param.OnStart;
    OnSuccess := Use.Param.OnSuccess;
    OnError := Use.Param.OnError;
    Run(
      function: TArtifacts
      begin
        Result := Self.TextToImage(Model, ParamProc);
      end);
  finally
    Free;
  end;
end;

function TVersion1Route.ImageToImageWithMask(const Model: string;
  ParamProc: TProc<TPayloadMask>): TArtifacts;
begin
  Result := API.PostForm<TArtifacts, TPayloadMask>(Format('v1/generation/%s/image-to-image/masking', [Model]), ParamProc);
end;

function TVersion1Route.ImageToImageWithPrompt(const Model: string;
  ParamProc: TProc<TPayloadPrompt>): TArtifacts;
begin
  Result := API.PostForm<TArtifacts, TPayloadPrompt>(Format('v1/generation/%s/image-to-image', [Model]), ParamProc);
end;

function TVersion1Route.TextToImage(const Model: string;
  ParamProc: TProc<TPayload>): TArtifacts;
begin
  Result := API.Post<TArtifacts, TPayload>(Format('v1/generation/%s/text-to-image', [Model]), ParamProc);
end;

{ TArtifacts }

function TArtifacts.GetFilePath(index: Integer): string;
begin
  if FFilePath.IsEmpty then
    raise Exception.Create(FileNameNotNullExceptionMessage);
  Result := Format('%s%s%s', [FFilePath, index.ToString.PadLeft(2, '0'), FExtension]);
end;

procedure TArtifacts.SaveToFile(const FileName: string);
begin
  {--- Save data to files, indexing them as necessary, for each artifact. }
  SetFilePath(FileName);
  var index := 0;
  for var Item in Artifacts do
    begin
      if index = 0 then
        Item.SaveToFile(FileName) else
        Item.SaveToFile(FilePath[index]);
      Inc(index);
    end;
end;

procedure TArtifacts.SetFilePath(const Value: string);
begin
  FFileName := Value;
  FExtension := ExtractFileExt(Value);
  FFilePath := TPath.ChangeExtension(Value, '');
  FFilePath := FFilePath.Substring(0, FFilePath.Length-1);
end;

{ TPayloadPrompt }

constructor TPayloadPrompt.Create;
begin
  inherited Create(True);
end;

function TPayloadPrompt.ImageStrength(
  const Value: Double): TPayloadPrompt;
begin
  AddField(CheckFloat('image_strength', Value, 0, 1), Value.ToString);
  Result := Self;
end;

function TPayloadPrompt.InitImageMode(
  const Value: TInitImageMode): TPayloadPrompt;
begin
  AddField('init_image_mode', Value.ToString);
  Result := Self;
end;

function TPayloadPrompt.StepScheduleEnd(
  const Value: Double): TPayloadPrompt;
begin
  AddField(CheckFloat('step_schedule_end', Value, 0, 1), Value.ToString);
  Result := Self;
end;

function TPayloadPrompt.StepScheduleStart(
  const Value: Double): TPayloadPrompt;
begin
  AddField(CheckFloat('step_schedule_start', Value, 0, 1), Value.ToString);
  Result := Self;
end;

{ TJSONArtifacts }

destructor TJSONArtifacts.Destroy;
begin
  for var Item in FArtifacts do
    Item.Free;
  inherited;
end;

{ TPromptMultipart }

class function TPromptMultipart.New(const Text: string): TPromptMultipart;
begin
  Result := TPromptMultipart.Create;
  Result.Text := Text;
end;

class function TPromptMultipart.New(const Weight: Double;
  const Value: string): TPromptMultipart;
begin
  Result := New(Value);
  Result.Weight := Weight;
end;

{ TInitImageModeHelper }

function TInitImageModeHelper.ToString: string;
begin
  case Self of
    IMAGE_STRENGTH:
      Exit('IMAGE_STRENGTH');
    STEP_SCHEDULE:
      Exit('STEP_SCHEDULE');
  end;
end;

{ TMaskSourceHelper }

function TMaskSourceHelper.ToString: string;
begin
  case Self of
    MASK_IMAGE_WHITE:
      Exit('MASK_IMAGE_WHITE');
    MASK_IMAGE_BLACK:
      Exit('MASK_IMAGE_BLACK');
    INIT_IMAGE_ALPHA:
      Exit('INIT_IMAGE_ALPHA');
  end;
end;

{ TPayloadMask }

constructor TPayloadMask.Create;
begin
  inherited Create(True);
end;

function TPayloadMask.MaskImage(const FilePath: string): TPayloadMask;
begin
  AddBytes('mask_image', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TPayloadMask.MaskImage(const Stream: TStream;
  StreamFreed: Boolean): TPayloadMask;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('mask_image', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('mask_image', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

function TPayloadMask.MaskSource(const Value: TMaskSource): TPayloadMask;
begin
  AddField('mask_source', Value.ToString);
  Result := Self;
end;

{ TPlayloadCommon }

function TPlayloadCommon.CfgScale(const Value: Double): TPlayloadCommon;
begin
  AddField(CheckFloat('cfg_scale', Value, 0, 35), Value.ToString);
  Result := Self;
end;

function TPlayloadCommon.ClipGuidancePreset(
  const Value: TClipGuidancePresetType): TPlayloadCommon;
begin
  AddField('clip_guidance_preset', Value.ToString);
  Result := Self;
end;

function TPlayloadCommon.Extras(const Value: TJSONObject): TPlayloadCommon;
begin
  AddField('extras', Value.ToString);
  Result := Self;
end;

function TPlayloadCommon.InitImage(const FilePath: string): TPlayloadCommon;
begin
  AddBytes('init_image', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TPlayloadCommon.InitImage(const Stream: TStream;
  StreamFreed: Boolean): TPlayloadCommon;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('init_image', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('init_image', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

function TPlayloadCommon.Sampler(const Value: TSamplerType): TPlayloadCommon;
begin
  AddField('sampler', Value.ToString);
  Result := Self;
end;

function TPlayloadCommon.Samples(const Value: Integer): TPlayloadCommon;
begin
  AddField(CheckInteger('samples', Value, 1, 10), Value.ToString);
  Result := Self;
end;

function TPlayloadCommon.Seed(const Value: Int64): TPlayloadCommon;
begin
  AddField(CheckInteger('seed', Value, 0, SeedMax), Value.ToString);
  Result := Self;
end;

function TPlayloadCommon.Steps(const Value: Integer): TPlayloadCommon;
begin
  AddField(CheckInteger('steps', Value, 10, 50), Value.ToString);
  Result := Self;
end;

function TPlayloadCommon.StylePreset(
  const Value: TStylePreset): TPlayloadCommon;
begin
  AddField('style_preset', Value.ToString);
  Result := Self;
end;

function TPlayloadCommon.TextPrompts(
  const Value: TArray<TPromptMultipart>): TPlayloadCommon;
begin
  var index := 0;
  for var Item in Value do
    begin
      AddField(Format('text_prompts[%d][text]', [index]), Item.Text);
      AddField(Format('text_prompts[%d][weight]', [index]), Item.Weight.ToString);
      Item.Free;
      Inc(Index);
    end;
  Result := Self;
end;

end.
