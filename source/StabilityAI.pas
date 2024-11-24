unit StabilityAI;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, StabilityAI.API,
  {--- Version 2 beta }
  StabilityAI.StableImage.Generate, StabilityAI.StableImage.Upscale,
  StabilityAI.StableImage.Results, StabilityAI.StableImage.Edit,
  StabilityAI.StableImage.Control, StabilityAI.VideoAnd3D.Stable3D,
  StabilityAI.VideoAnd3D.Video,
  {--- Version 1 }
  StabilityAI.Version1.Engines, StabilityAI.Version1.SDXL1AndSD1_6,
  StabilityAI.Version1.User;

type
  TStableImage = class;
  TVideoAnd3D = class;
  TVersion1 = class;

  /// <summary>
  /// The <c>IStabilityAI</c> interface provides access to the various features and routes of the StabilityAI AI API.
  /// This interface allows interaction with different services such as agents, chat, code completion,
  /// embeddings, file management, fine-tuning, and model information.
  /// </summary>
  /// <remarks>
  /// This interface should be implemented by any class that wants to provide a structured way of accessing
  /// the StabilityAI AI services. It includes methods and properties for authenticating with an API key,
  /// configuring the base URL, and accessing different API routes.
  ///
  /// To use this interface, instantiate a class that implements it, set the required properties such as
  /// <see cref="Token"/> and <see cref="BaseURL"/>, and call the relevant methods for the desired operations.
  /// <code>
  ///   var StabilityAI: IStabilityAI := TStabilityAI.Create(API_TOKEN);
  /// </code>
  /// <seealso cref="TStabilityAI"/>
  /// </remarks>
  IStabilityAI = interface
    ['{6C323A77-2CD8-429B-BAA3-871CFF307C90}']
    function GetAPI: TStabilityAIAPI;
    procedure SetToken(const Value: string);
    function GetToken: string;
    function GetBaseUrl: string;
    procedure SetBaseUrl(const Value: string);

    function GetStableImage: TStableImage;
    function GetVideoAnd3D: TVideoAnd3D;
    function GetVersion1: TVersion1;

    /// <summary>
    /// the main API object used for making requests.
    /// </summary>
    /// <returns>
    /// An instance of TStabilityAIAPI for making API calls.
    /// </returns>
    property API: TStabilityAIAPI read GetAPI;
    /// Sets or retrieves the API token for authentication.
    /// </summary>
    /// <param name="Value">
    /// The API token as a string.
    /// </param>
    /// <returns>
    /// The current API token.
    /// </returns>
    property Token: string read GetToken write SetToken;
    /// <summary>
    /// Sets or retrieves the base URL for API requests.
    /// Default is https://api.StabilityAI.com/v1
    /// </summary>
    /// <param name="Value">
    /// The base URL as a string.
    /// </param>
    /// <returns>
    /// The current base URL.
    /// </returns>
    property BaseURL: string read GetBaseUrl write SetBaseUrl;
    /// <summary>
    /// REST v2beta API service
    /// </summary>
    /// <remarks>
    /// The REST v2beta API service is becoming the primary API service for the Stability Platform. All AI services available through other APIs (gRPC, REST v1, REST v2alpha) will continue to be maintained; however, these APIs will no longer receive new features or parameters.
    /// </remarks>
    property StableImage: TStableImage read GetStableImage;
    /// <summary>
    /// API for 3D and ultra-short videos.
    /// </summary>
    /// <remarks>
    /// These APIs enable 3D creation in the gLTF format from an image or the production of a 5-second video, also based on an image.
    /// </remarks>
    property VideoAnd3D: TVideoAnd3D read GetVideoAnd3D;
    /// <summary>
    /// REST v1 API service
    /// </summary>
    /// <remarks>
    /// Eventually these APIs should disappear.
    /// </remarks>
    property Version1: TVersion1 read GetVersion1;
  end;

  /// <summary>
  /// The <c>TStabilityAIFactory</c> class is responsible for creating instances of
  /// the <see cref="IStabilityAI"/> interface. It provides a factory method to instantiate
  /// the interface with a provided API token and optional header configuration.
  /// </summary>
  /// <remarks>
  /// This class provides a convenient way to initialize the <see cref="IStabilityAI"/> interface
  /// by encapsulating the necessary configuration details, such as the API token and header options.
  /// By using the factory method, users can quickly create instances of <see cref="IStabilityAI"/> without
  /// manually setting up the implementation details.
  /// </remarks>
  TStabilityAIFactory = class
    /// <summary>
    /// Creates an instance of the <see cref="IStabilityAI"/> interface with the specified API token
    /// and optional header configuration.
    /// </summary>
    /// <param name="AToken">
    /// The API token as a string, required for authenticating with StabilityAI API services.
    /// </param>
    /// <param name="Option">
    /// An optional header configuration of type <see cref="THeaderOption"/> to customize the request headers.
    /// The default value is <c>THeaderOption.none</c>.
    /// </param>
    /// <returns>
    /// An instance of <see cref="IStabilityAI"/> initialized with the provided API token and header option.
    /// </returns>
    /// <remarks>
    /// Code example
    /// <code>
    /// var StabilityAICloud := TStabilityAIFactory.CreateInstance(BaererKey);
    ///
    /// </code>
    /// WARNING : Please take care to adjust the SCOPE of the <c>StabilityAICloud</c> interface in you application.
    /// </remarks>
    class function CreateInstance(const AToken: string): IStabilityAI;
  end;

  TStabilityAI = class;

  TStableImageCore = class
  private
    FOwner: TStabilityAI;
  public
    constructor Create(const AOwner: TStabilityAI);
  end;

  /// <summary>
  /// The <c>TStableImage</c> class provides tools and methods for image generation, editing, upscaling,
  /// and controlled variation using StabilityAI's Stable Diffusion models. This class acts as a core
  /// component for image-based operations within the StabilityAI API.
  /// </summary>
  /// <remarks>
  /// This class includes features to generate new images, upscale existing images, edit images using
  /// various techniques, and apply precise control over variations.
  /// It supports different models for diverse creative needs, from photorealistic outputs to quick
  /// concept ideation.
  /// <para>
  /// - Image Generation: Generate photorealistic or concept images using text prompts.
  /// </para>
  /// <para>
  /// - Image Upscaling: Enhance image resolution using multiple upscaling techniques.
  /// </para>
  /// <para>
  /// - Image Editing: Modify images with tools such as inpainting, outpainting, object erasure,
  /// and color manipulation.
  /// </para>
  /// <para>
  /// - Controlled Variations: Generate precise variations of images using sketching, structure, or
  /// style-based approaches.
  /// </para>
  /// This class relies on API routes provided by <c>TStabilityAI</c> for all operations.
  /// </remarks>
  TStableImage = class(TStableImageCore)
  private
    FGenerateRoute: TGenerateRoute;
    FUpscaleRoute: TUpscaleRoute;
    FEditRoute: TEditRoute;
    FControlRoute: TControlRoute;
    FResultsRoute: TResultsRoute;
    function GetGenerateRoute: TGenerateRoute;
    function GetUpscaleRoute: TUpscaleRoute;
    function GetEditRoute: TEditRoute;
    function GetControlRoute: TControlRoute;
    function GetResultsRoute: TResultsRoute;
  public
    /// <summary>
    /// Tools designed to create fresh images from text descriptions or to produce variations of existing images.
    /// </summary>
    /// <remarks>
    /// <para>
    /// - Stable Image Ultra: Photorealistic outputs for professional and large-scale use.
    /// </para>
    /// <para>
    /// - Stable Image Core: Fast, affordable generation for quick concept ideation.
    /// </para>
    /// <para>
    /// - Stable Diffusion 3 et 3.5: Versatile models for high-quality, high-volume digital assets.
    /// </para>
    /// </remarks>
    property Generate: TGenerateRoute read GetGenerateRoute;
    /// <summary>
    /// Versatile upscaling solutions: fast, precise, and creatively enhanced results.
    /// </summary>
    /// <remarks>
    /// <para>
    /// - Fast Upscaler: Quick 4x resolution boost for compressed images.
    /// </para>
    /// <para>
    /// - Conservative Upscaler: Precise upscale to 4 megapixels with minimal changes.
    /// </para>
    /// <para>
    /// - Creative Upscaler: Enhances degraded images creatively to high resolution.
    /// </para>
    /// </remarks>
    property Upscale: TUpscaleRoute read GetUpscaleRoute;
    /// <summary>
    /// Tools for modifying your own images and those that are generated.
    /// </summary>
    /// <remarks>
    /// <para>
    /// - Erase: Removes unwanted objects using image masks.
    /// </para>
    /// <para>
    /// - Outpaint: Extends images by adding content in any direction.
    /// </para>
    /// <para>
    /// - Inpaint: Replaces specified areas with content based on a mask.
    /// </para>
    /// <para>
    /// - Search and Replace: Replaces objects using prompts, no mask needed.
    /// </para>
    /// <para>
    /// - Search and Recolor: Changes object colors based on prompts
    /// </para>
    /// <para>
    /// - Remove Background: Segments and removes backgrounds accurately.
    /// </para>
    /// </remarks>
    property Edit: TEditRoute read GetEditRoute;
    /// <summary>
    /// Tools designed to create precise and controlled variations of existing images or sketches.
    /// </summary>
    /// <remarks>
    /// <para>
    /// - Sketch: Refines sketches or manipulates images using contours.
    /// </para>
    /// <para>
    /// - Structure: Preserves image structure for recreations or character rendering
    /// </para>
    /// <para>
    /// - Style: Applies control image styles to guided image creation
    /// </para>
    /// </remarks>
    property Control: TControlRoute read GetControlRoute;
    /// <summary>
    /// Methods for retrieving the outcomes of your asynchronous processes.
    /// </summary>
    property Results: TResultsRoute read GetResultsRoute;
    destructor Destroy; override;
  end;

  /// <summary>
  /// The <c>TVideoAnd3D</c> class provides advanced tools and methods for generating 3D models and
  /// creating short videos based on images using StabilityAI's cutting-edge AI capabilities.
  /// This class extends the StabilityAI API's functionality to include 3D and video-based outputs.
  /// </summary>
  /// <remarks>
  /// This class enables the creation of realistic 3D assets and high-quality short video sequences
  /// using input images or prompts. It supports various formats and techniques to deliver outputs
  /// optimized for creative and professional use cases.
  /// <para>
  /// - 3D Model Generation: Generate 3D assets in glTF binary format, ready for integration into
  /// compatible 3D applications.
  /// </para>
  /// <para>
  /// - Video Creation: Create short, high-quality video clips from images or text-based prompts using
  /// advanced video diffusion models.
  /// </para>
  /// The generated outputs are suitable for applications in game development, animation, virtual
  /// reality, and creative content production. This class relies on StabilityAI's <c>TStabilityAI</c>
  /// API routes for all its operations.
  /// </remarks>
  TVideoAnd3D = class(TStableImageCore)
  private
    FModel3DRoute: TModel3DRoute;
    FVideoRoute: TVideoRoute;
    function GetModel3DRoute: TModel3DRoute;
    function GetVideoRoute: TVideoRoute;
  public
    /// <summary>
    /// Advanced 3D Asset Generation from 2D Input
    /// </summary>
    /// <remarks>
    /// The files generated through "Advanced 3D Asset Generation from 2D Input" are in the model/gltf-binary format. The output is a binary blob containing a fully integrated glTF asset, ready for use in compatible 3D applications and platforms.
    /// </remarks>
    property Model3D: TModel3DRoute read GetModel3DRoute;
    /// <summary>
    /// Creating a short video starting from an initial image using Stable Video Diffusion, a latent video diffusion model.
    /// </summary>
    /// <remarks>
    /// Using Stable Video Diffusion the cutting-edge latent video diffusion model for high-resolution text-to-video and image-to-video generation, emphasizing systematic training stages and high-quality dataset curation for superior video synthesis.
    /// </remarks>
    property ImageToVideo: TVideoRoute read GetVideoRoute;
    destructor Destroy; override;
  end;

  /// <summary>
  /// The <c>TVersion1</c> class provides access to StabilityAI's Version 1 API endpoints,
  /// including tools for image generation, engine enumeration, and user account management.
  /// This class supports legacy features and models like SDXL 1.0 and SD1.6 for generating high-quality
  /// images.
  /// </summary>
  /// <remarks>
  /// This class enables interaction with StabilityAI's Version 1 REST API, allowing users to:
  /// <para>
  /// - Image Generation: Create images using the SDXL 1.0 and SD1.6 models, suitable for diverse use cases
  /// such as concept design and photorealistic rendering.
  /// </para>
  /// <para>
  /// - Engine Enumeration: Discover and manage available engines compatible with Version 1 endpoints.
  /// </para>
  /// <para>
  /// - User Account Management: Access account information, view balances, and manage organization-level
  /// settings.
  /// </para>
  /// While this API is considered legacy, it remains a reliable choice for projects leveraging older models
  /// or requiring specific features only available in Version 1. For newer features, consider transitioning
  /// to Version 2 APIs.
  /// </remarks>
  TVersion1 = class(TStableImageCore)
  private
    FVersion1Route: TVersion1Route;
    FEnginesRoute: TEnginesRoute;
    FUserRoute: TUserRoute;
    function GetVersion1Route: TVersion1Route;
    function GetEnginesRoute: TEnginesRoute;
    function GetUserRoute: TUserRoute;
  public
    /// <summary>
    /// Generate images using SDXL 1.0 or SD1.6.
    /// </summary>
    property SDXLAndSDL: TVersion1Route read GetVersion1Route;
    /// <summary>
    /// Enumerate engines that work with 'Version 1' REST API endpoints.
    /// </summary>
    property Engines: TEnginesRoute read GetEnginesRoute;
    /// <summary>
    /// Manage your Stability account, and view account/organization balances.
    /// </summary>
    property User:TUserRoute read GetUserRoute;
    destructor Destroy; override;
  end;

  /// <summary>
  /// The TStabilityAI class provides access to the various features and routes of the StabilityAI AI API.
  /// This class allows interaction with different services such as agents, chat, code completion,
  /// embeddings, file management, fine-tuning, and model information.
  /// </summary>
  /// <remarks>
  /// This class should be implemented by any class that wants to provide a structured way of accessing
  /// the StabilityAI AI services. It includes methods and properties for authenticating with an API key,
  /// configuring the base URL, and accessing different API routes.
  /// <seealso cref="TStabilityAI"/>
  /// </remarks>
  TStabilityAI = class(TInterfacedObject, IStabilityAI)
  strict private

  private
    FAPI: TStabilityAIAPI;
    FStableImage: TStableImage;
    FVideoAnd3D: TVideoAnd3D;
    FVersion1: TVersion1;

    function GetAPI: TStabilityAIAPI;
    function GetToken: string;
    procedure SetToken(const Value: string);
    function GetBaseUrl: string;
    procedure SetBaseUrl(const Value: string);
    function GetStableImage: TStableImage;
    function GetVideoAnd3D: TVideoAnd3D;
    function GetVersion1: TVersion1;
  public
    /// <summary>
    /// the main API object used for making requests.
    /// </summary>
    /// <returns>
    /// An instance of TStabilityAIAPI for making API calls.
    /// </returns>
    property API: TStabilityAIAPI read GetAPI;
    /// <summary>
    /// Sets or retrieves the API token for authentication.
    /// </summary>
    /// <param name="Value">
    /// The API token as a string.
    /// </param>
    /// <returns>
    /// The current API token.
    /// </returns>
    property Token: string read GetToken write SetToken;
    /// <summary>
    /// Sets or retrieves the base URL for API requests.
    /// Default is https://api.stability.ai
    /// </summary>
    /// <param name="Value">
    /// The base URL as a string.
    /// </param>
    /// <returns>
    /// The current base URL.
    /// </returns>
    property BaseURL: string read GetBaseUrl write SetBaseUrl;

  public
    /// <summary>
    /// Initializes a new instance of the <see cref="TStabilityAI"/> class with optional header configuration.
    /// </summary>
    /// <param name="Option">
    /// An optional parameter of type <see cref="THeaderOption"/> to configure the request headers.
    /// The default value is <c>THeaderOption.none</c>.
    /// </param>
    /// <remarks>
    /// This constructor is typically used when no API token is provided initially.
    /// The token can be set later via the <see cref="Token"/> property.
    /// </remarks>
    constructor Create; overload;
    /// <summary>
    /// Initializes a new instance of the <see cref="TStabilityAI"/> class with the provided API token and optional header configuration.
    /// </summary>
    /// <param name="AToken">
    /// The API token as a string, required for authenticating with the StabilityAI AI API.
    /// </param>
    /// <param name="Option">
    /// An optional parameter of type <see cref="THeaderOption"/> to configure the request headers.
    /// The default value is <c>THeaderOption.none</c>.
    /// </param>
    /// <remarks>
    /// This constructor allows the user to specify an API token at the time of initialization.
    /// </remarks>
    constructor Create(const AToken: string); overload;
    /// <summary>
    /// Releases all resources used by the current instance of the <see cref="TStabilityAI"/> class.
    /// </summary>
    /// <remarks>
    /// This method is called to clean up any resources before the object is destroyed.
    /// It overrides the base <see cref="TInterfacedObject.Destroy"/> method.
    /// </remarks>
    destructor Destroy; override;
  end;

implementation

{ TStabilityAI }

constructor TStabilityAI.Create;
begin
  inherited Create;
  FAPI := TStabilityAIAPI.Create;
  FStableImage := TStableImage.Create(Self);
  FVideoAnd3D := TVideoAnd3D.Create(Self);
  FVersion1 := TVersion1.Create(Self);
end;

constructor TStabilityAI.Create(const AToken: string);
begin
  Create;
  Token := AToken;
end;

destructor TStabilityAI.Destroy;
begin
  FAPI.Free;

  FStableImage.Free;
  FVideoAnd3D.Free;
  FVersion1.Free;
  inherited;
end;

function TStabilityAI.GetAPI: TStabilityAIAPI;
begin
  Result := FAPI;
end;

function TStabilityAI.GetBaseUrl: string;
begin
  Result := FAPI.BaseURL;
end;

function TStabilityAI.GetStableImage: TStableImage;
begin
  Result := FStableImage;
end;

function TStabilityAI.GetToken: string;
begin
  Result := FAPI.Token;
end;

function TStabilityAI.GetVersion1: TVersion1;
begin
  Result := FVersion1;
end;

function TStabilityAI.GetVideoAnd3D: TVideoAnd3D;
begin
  Result := FVideoAnd3D;
end;

procedure TStabilityAI.SetBaseUrl(const Value: string);
begin
  FAPI.BaseURL := Value;
end;

procedure TStabilityAI.SetToken(const Value: string);
begin
  FAPI.Token := Value;
end;

{ TStabilityAIFactory }

class function TStabilityAIFactory.CreateInstance(const AToken: string): IStabilityAI;
begin
  Result := TStabilityAI.Create(AToken);
end;

{ TStableImage }

destructor TStableImage.Destroy;
begin
  FGenerateRoute.Free;
  FUpscaleRoute.Free;
  FEditRoute.Free;
  FControlRoute.Free;
  FResultsRoute.Free;
  inherited;
end;

function TStableImage.GetControlRoute: TControlRoute;
begin
  if not Assigned(FControlRoute) then
    FControlRoute := TControlRoute.CreateRoute(FOwner.API);
  Result := FControlRoute;
end;

function TStableImage.GetEditRoute: TEditRoute;
begin
  if not Assigned(FEditRoute) then
    FEditRoute := TEditRoute.CreateRoute(FOwner.API);
  Result := FEditRoute;
end;

function TStableImage.GetGenerateRoute: TGenerateRoute;
begin
  if not Assigned(FGenerateRoute) then
    FGenerateRoute := TGenerateRoute.CreateRoute(FOwner.API);
  Result := FGenerateRoute;
end;

function TStableImage.GetResultsRoute: TResultsRoute;
begin
  if not Assigned(FResultsRoute) then
    FResultsRoute := TResultsRoute.CreateRoute(FOwner.API);
  Result := FResultsRoute;
end;

function TStableImage.GetUpscaleRoute: TUpscaleRoute;
begin
  if not Assigned(FUpscaleRoute) then
    FUpscaleRoute := TUpscaleRoute.CreateRoute(FOwner.API);
  Result := FUpscaleRoute;
end;

{ TStableImageCore }

constructor TStableImageCore.Create(const AOwner: TStabilityAI);
begin
  inherited Create;
  FOwner := AOwner;
end;

{ TVideoAnd3D }

destructor TVideoAnd3D.Destroy;
begin
  FModel3DRoute.Free;
  FVideoRoute.Free;
  inherited;
end;

function TVideoAnd3D.GetModel3DRoute: TModel3DRoute;
begin
  if not Assigned(FModel3DRoute) then
    FModel3DRoute := TModel3DRoute.CreateRoute(FOwner.API);
  Result := FModel3DRoute;
end;

function TVideoAnd3D.GetVideoRoute: TVideoRoute;
begin
  if not Assigned(FVideoRoute) then
    FVideoRoute := TVideoRoute.CreateRoute(FOwner.API);
  Result := FVideoRoute;
end;

{ TVersion1 }

destructor TVersion1.Destroy;
begin
  FVersion1Route.Free;
  FEnginesRoute.Free;
  FUSerRoute.Free;
  inherited;
end;

function TVersion1.GetEnginesRoute: TEnginesRoute;
begin
  if not Assigned(FEnginesRoute) then
    FEnginesRoute := TEnginesRoute.CreateRoute(FOwner.API);
  Result := FEnginesRoute;
end;

function TVersion1.GetUserRoute: TUserRoute;
begin
  if not Assigned(FUSerRoute) then
    FUSerRoute := TUSerRoute.CreateRoute(FOwner.API);
  Result := FUSerRoute;
end;

function TVersion1.GetVersion1Route: TVersion1Route;
begin
  if not Assigned(FVersion1Route) then
    FVersion1Route := TVersion1Route.CreateRoute(FOwner.API);
  Result := FVersion1Route;
end;

end.
