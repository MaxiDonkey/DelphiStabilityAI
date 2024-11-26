unit StabilityAI.StableImage.Control;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

uses
  System.SysUtils, System.Classes, System.Net.Mime, REST.JsonReflect, System.JSON,
  REST.Json.Types, StabilityAI.API, StabilityAI.Common;

type
  /// <summary>
  /// The <c>TSketch</c> class provides an interface for interacting with sketch enhancement APIs.
  /// It facilitates brainstorming design projects and precise iterations by converting rough sketches into refined outputs.
  /// </summary>
  /// <remarks>
  /// <c>TSketch</c> manages configuration parameters for various sketch-based design APIs, simplifying the creation of hand-drawn sketches or manipulating contours and edges of non-sketch images.
  /// The class utilizes anonymous methods to supply these parameters to functions using the associated APIs, allowing for easy customization and rapid prototyping.
  /// </remarks>
  TSketch = class(TStableImageCommon)
    /// <summary>
    /// An image whose style you wish to use as the foundation for a generation.
    /// </summary>
    /// <param name="FilePath">
    /// Supported format (jpeg, png, webp)
    /// </param>
    /// <remarks>
    /// <para>
    /// - Every side must be at least 64 pixels
    /// </para>
    /// <para>
    /// - The total pixel count cannot exceed 9,437,184 pixels (e.g. 3072x3072, 4096x2304, etc.)
    /// </para>
    /// <para>
    /// Image aspect rotio :
    /// - Must be between 1:2.5 and 2.5:1 (i.e. cannot be too tall or too wide)
    /// </para>
    /// </remarks>
    function Image(const FilePath: string): TSketch; overload;
    /// <summary>
    /// An image whose style you wish to use as the foundation for a generation.
    /// </summary>
    /// <param name="Stream">
    /// A stream containing the image data. Supported formats include JPEG, PNG, and WEBP.
    /// </param>
    /// <param name="StreamFreed">
    /// Indicates whether the stream should be automatically freed after use. Defaults to False.
    /// </param>
    /// <remarks>
    /// <para>
    /// - Every side must be at least 64 pixels.
    /// </para>
    /// <para>
    /// - The total pixel count cannot exceed 9,437,184 pixels (e.g., 3072x3072, 4096x2304, etc.).
    /// </para>
    /// <para>
    /// Image aspect ratio:
    /// - Must be between 1:2.5 and 2.5:1 (i.e., cannot be too tall or too wide).
    /// </para>
    /// </remarks>
    function Image(const Stream: TStream; StreamFreed: Boolean = False): TSketch; overload;
    /// <summary>
    /// How much influence, or control, the image has on the generation.
    /// </summary>
    /// <param name="Value">
    /// Number: [0 .. 1] (Default: 0.7)
    /// </param>
    /// <remarks>
    /// Represented as a float between 0 and 1, where 0 is the least influence and 1 is the maximum.
    /// </remarks>
    function ControlStrength(const Value: Double): TSketch;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// The <c>TStructure</c> class encapsulates a series of APIs that specialize in generating images while preserving the structure of an input image.
  /// This class provides a convenient interface for managing parameters that are crucial for recreating complex scenes or rendering character models.
  /// </summary>
  /// <remarks>
  /// <c>TStructure</c> is designed to facilitate advanced content creation by wrapping API interactions within anonymous methods.
  /// These methods are used to seamlessly supply parameters to other routines that rely on these APIs, ensuring the integrity and structure of the original image are maintained.
  /// The class is especially valuable for scenarios where precise image recreation or character rendering is required, making it an essential tool for high-level creative processes.
  /// </remarks>
  TStructure = TSketch;

  /// <summary>
  /// The <c>TSyle</c> class represent a service that extracts stylistic elements from a control image and guides the generation of an output image accordingly.
  /// </summary>
  /// <remarks>
  /// The <c>TStyle</c> class manages the parameters for the image style extraction and creation service, encapsulating them into an anonymous method.
  /// This approach provides a convenient and modular way to provide the necessary configuration to the API methods that utilize these services.
  /// The generated image maintains the stylistic qualities of the control image while incorporating the visual content based on the given prompt.
  /// </remarks>
  TStyle = class(TStableImageRatio)
    /// <summary>
    /// An image whose style you wish to use as the foundation for a generation.
    /// </summary>
    /// <param name="FilePath">
    /// Supported format (jpeg, png, webp)
    /// </param>
    /// <returns>
    /// The updated <c>TStyle</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// - Every side must be at least 64 pixels
    /// </para>
    /// <para>
    /// - The total pixel count cannot exceed 9,437,184 pixels (e.g. 3072x3072, 4096x2304, etc.)
    /// </para>
    /// <para>
    /// Image aspect rotio :
    /// - Must be between 1:2.5 and 2.5:1 (i.e. cannot be too tall or too wide)
    /// </para>
    /// </remarks>
    function Image(const FilePath: string): TStyle; overload;
    /// <summary>
    /// Sets the image to be used as the foundation for a generation from a stream.
    /// </summary>
    /// <param name="Stream">
    /// A <c>TStream</c> containing the image data.
    /// Supported formats include JPEG, PNG, and WEBP.
    /// </param>
    /// <param name="StreamFreed">
    /// Indicates whether the stream should be automatically freed after use.
    /// Set to <c>True</c> to free the stream automatically, or <c>False</c> to manage the stream's lifecycle manually.
    /// </param>
    /// <returns>
    /// The updated <c>TStyle</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// - Every side of the image must be at least 64 pixels.
    /// </para>
    /// <para>
    /// - The total pixel count cannot exceed 9,437,184 pixels (e.g., 3072x3072, 4096x2304, etc.).
    /// </para>
    /// <para>
    /// - Image aspect ratio must be between 1:2.5 and 2.5:1, meaning the image cannot be excessively tall or wide.
    /// </para>
    /// </remarks>
    function Image(const Stream: TStream; StreamFreed: Boolean = False): TStyle; overload;
    /// <summary>
    /// How closely the output image's style resembles the input image's style.
    /// </summary>
    /// <param name="Value">
    /// Number: [0 .. 1] (Default: 0.5)
    /// </param>
    function Fidelity(const Value: Double): TStyle;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// The <c>TControlRoute</c> class provides an interface for advanced image processing services.
  /// This class wraps the functionality for three core services:
  /// </summary>
  /// <remarks>
  /// <para>
  /// <c>Sketch</c> - Enhances rough sketches into refined images.
  /// </para>
  /// <para>
  /// <c>Structure</c> - Preserves and recreates the structural integrity of input images, ideal for complex scenes or models.
  /// </para>
  /// <para>
  /// <c>Style</c> - Extracts stylistic elements from an image and applies them to new outputs.
  /// </para>
  /// <para>
  /// The <c>TControlRoute</c> class is part of the Stability AI image generation ecosystem, providing an easy-to-use
  /// interface for integrating the platform's advanced image manipulation capabilities.
  /// </para>
  /// <para>
  /// Each method supports both synchronous and asynchronous operations, catering to different programming needs:
  /// </para>
  /// <para>
  /// Synchronous methods return the generated image directly upon completion.
  /// </para>
  /// <para>
  /// Asynchronous methods leverage callbacks to handle success and error states, making them suitable for
  /// applications requiring non-blocking operations.
  /// </para>
  /// </remarks>
  TControlRoute = class(TStabilityAIAPIRoute)
    /// <summary>
    /// This service offers an ideal solution for design projects that require brainstorming and frequent iterations. It upgrades rough hand-drawn sketches to refined outputs with precise control. For non-sketch images, it allows detailed manipulation of the final appearance by leveraging the contour lines and edges within the image.
    /// <para>
    /// NOTE: This method is <c>synchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the prompt etc.
    /// </param>
    /// <returns>
    /// Returns a <c>TStableImage</c> object that contains image base-64 generated.
    /// </returns>
    /// <exception cref="StabilityAIException">
    /// Thrown when there is an error in the communication with the API or other underlying issues in the API call.
    /// </exception>
    /// <exception cref="StabilityAIExceptionBadRequestError">
    /// Thrown when the request is invalid, such as when required parameters are missing or values exceed allowed limits.
    /// </exception>
    /// <remarks>
    /// <code>
    ///   var Stability := TStabilityAIFactory.CreateInstance(BaererKey);
    ///   var Data := Stability.StableImage.Control.Sketch(
    ///     procedure (Params: TSketch)
    ///     begin
    ///       Params.OutputFormat(png);
    ///       // Move on to the other parameters.
    ///     end);
    ///   var Stream := Data.GetStream;
    ///   try
    ///     //--- Save image
    ///     Data.SaveToFile(FileName);
    ///     //--- Display image
    ///     Image1.Picture.LoadFromStream(Stream);
    ///   finally
    ///     Data.Free;
    ///   end;
    /// </code>
    /// </remarks>
    function Sketch(ParamProc: TProc<TSketch>): TStableImage; overload;
    /// <summary>
    /// This service offers an ideal solution for design projects that require brainstorming and frequent iterations. It upgrades rough hand-drawn sketches to refined outputs with precise control. For non-sketch images, it allows detailed manipulation of the final appearance by leveraging the contour lines and edges within the image.
    /// <para>
    /// NOTE: This method is <c>asynchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the prompt etc.
    /// </param>
    /// <param name="CallBacks">
    /// A function that returns a record containing event handlers for asynchronous image creation, such as <c>onSuccess</c> and <c>onError</c>.
    /// </param>
    /// <exception cref="StabilityAIException">
    /// Thrown when there is an error in the communication with the API or other underlying issues in the API call.
    /// </exception>
    /// <exception cref="StabilityAIExceptionBadRequestError">
    /// Thrown when the request is invalid, such as when required parameters are missing or values exceed allowed limits.
    /// </exception>
    /// <remarks>
    /// <code>
    /// // WARNING - Move the following line to the main OnCreate method for maximum scope.
    /// // var Stability := TStabilityAIFactory.CreateInstance(BaererKey);
    /// Stability.StableImage.Control.Sketch(
    ///   procedure (Params: TSketch)
    ///   begin
    ///     // Define parameters
    ///   end,
    ///
    ///   function : TAsynStableImage
    ///   begin
    ///     Result.Sender := Image1;  // Instance passed to callback parameter
    ///
    ///     Result.OnStart := nil;   // If nil then; Can be omitted
    ///
    ///     Result.OnSuccess := procedure (Sender: TObject; Image: TStableImage)
    ///       begin
    ///         // Handle success operation
    ///       end;
    ///
    ///     Result.OnError := procedure (Sender: TObject; Error: string)
    ///       begin
    ///         // Handle error message
    ///       end;
    ///   end);
    /// </code>
    /// </remarks>
    procedure Sketch(ParamProc: TProc<TSketch>; CallBacks: TFunc<TAsynStableImage>); overload;
    /// <summary>
    /// This service excels in generating images by maintaining the structure of an input image, making it especially valuable for advanced content creation scenarios such as recreating scenes or rendering characters from models.
    /// <para>
    /// NOTE: This method is <c>synchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the prompt etc.
    /// </param>
    /// <returns>
    /// Returns a <c>TStableImage</c> object that contains image base-64 generated.
    /// </returns>
    /// <exception cref="StabilityAIException">
    /// Thrown when there is an error in the communication with the API or other underlying issues in the API call.
    /// </exception>
    /// <exception cref="StabilityAIExceptionBadRequestError">
    /// Thrown when the request is invalid, such as when required parameters are missing or values exceed allowed limits.
    /// </exception>
    /// <remarks>
    /// <code>
    ///   var Stability := TStabilityAIFactory.CreateInstance(BaererKey);
    ///   var Data := Stability.StableImage.Control.Structure(
    ///     procedure (Params: TStructure)
    ///     begin
    ///       Params.OutputFormat(png);
    ///       // Move on to the other parameters.
    ///     end);
    ///   var Stream := Data.GetStream;
    ///   try
    ///     //--- Save image
    ///     Data.SaveToFile(FileName);
    ///     //--- Display image
    ///     Image1.Picture.LoadFromStream(Stream);
    ///   finally
    ///     Data.Free;
    ///   end;
    /// </code>
    /// </remarks>
    function Structure(ParamProc: TProc<TStructure>): TStableImage; overload;
    /// <summary>
    /// This service excels in generating images by maintaining the structure of an input image, making it especially valuable for advanced content creation scenarios such as recreating scenes or rendering characters from models.
    /// <para>
    /// NOTE: This method is <c>asynchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the prompt etc.
    /// </param>
    /// <param name="CallBacks">
    /// A function that returns a record containing event handlers for asynchronous image creation, such as <c>onSuccess</c> and <c>onError</c>.
    /// </param>
    /// <exception cref="StabilityAIException">
    /// Thrown when there is an error in the communication with the API or other underlying issues in the API call.
    /// </exception>
    /// <exception cref="StabilityAIExceptionBadRequestError">
    /// Thrown when the request is invalid, such as when required parameters are missing or values exceed allowed limits.
    /// </exception>
    /// <remarks>
    /// <code>
    /// // WARNING - Move the following line to the main OnCreate method for maximum scope.
    /// // var Stability := TStabilityAIFactory.CreateInstance(BaererKey);
    /// Stability.StableImage.Control.Structure(
    ///   procedure (Params: TStructure)
    ///   begin
    ///     // Define parameters
    ///   end,
    ///
    ///   function : TAsynStableImage
    ///   begin
    ///     Result.Sender := Image1;  // Instance passed to callback parameter
    ///
    ///     Result.OnStart := nil;   // If nil then; Can be omitted
    ///
    ///     Result.OnSuccess := procedure (Sender: TObject; Image: TStableImage)
    ///       begin
    ///         // Handle success operation
    ///       end;
    ///
    ///     Result.OnError := procedure (Sender: TObject; Error: string)
    ///       begin
    ///         // Handle error message
    ///       end;
    ///   end);
    /// </code>
    /// </remarks>
    procedure Structure(ParamProc: TProc<TStructure>; CallBacks: TFunc<TAsynStableImage>); overload;
    /// <summary>
    /// This service extracts stylistic elements from an input image (control image) and uses it to guide the creation of an output image based on the prompt. The result is a new image in the same style as the control image.
    /// <para>
    /// NOTE: This method is <c>synchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the prompt etc.
    /// </param>
    /// <returns>
    /// Returns a <c>TStableImage</c> object that contains image base-64 generated.
    /// </returns>
    /// <exception cref="StabilityAIException">
    /// Thrown when there is an error in the communication with the API or other underlying issues in the API call.
    /// </exception>
    /// <exception cref="StabilityAIExceptionBadRequestError">
    /// Thrown when the request is invalid, such as when required parameters are missing or values exceed allowed limits.
    /// </exception>
    /// <remarks>
    /// <code>
    ///   var Stability := TStabilityAIFactory.CreateInstance(BaererKey);
    ///   var Data := Stability.StableImage.Control.Style(
    ///     procedure (Params: TStyle)
    ///     begin
    ///       Params.OutputFormat(png);
    ///       // Move on to the other parameters.
    ///     end);
    ///   var Stream := Data.GetStream;
    ///   try
    ///     //--- Save image
    ///     Data.SaveToFile(FileName);
    ///     //--- Display image
    ///     Image1.Picture.LoadFromStream(Stream);
    ///   finally
    ///     Data.Free;
    ///   end;
    /// </code>
    /// </remarks>
    function Style(ParamProc: TProc<TStyle>): TStableImage; overload;
    /// <summary>
    /// This service extracts stylistic elements from an input image (control image) and uses it to guide the creation of an output image based on the prompt. The result is a new image in the same style as the control image.
    /// <para>
    /// NOTE: This method is <c>asynchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the prompt etc.
    /// </param>
    /// <param name="CallBacks">
    /// A function that returns a record containing event handlers for asynchronous image creation, such as <c>onSuccess</c> and <c>onError</c>.
    /// </param>
    /// <exception cref="StabilityAIException">
    /// Thrown when there is an error in the communication with the API or other underlying issues in the API call.
    /// </exception>
    /// <exception cref="StabilityAIExceptionBadRequestError">
    /// Thrown when the request is invalid, such as when required parameters are missing or values exceed allowed limits.
    /// </exception>
    /// <remarks>
    /// <code>
    /// // WARNING - Move the following line to the main OnCreate method for maximum scope.
    /// // var Stability := TStabilityAIFactory.CreateInstance(BaererKey);
    /// Stability.StableImage.Control.Style(
    ///   procedure (Params: TStyle)
    ///   begin
    ///     // Define parameters
    ///   end,
    ///
    ///   function : TAsynStableImage
    ///   begin
    ///     Result.Sender := Image1;  // Instance passed to callback parameter
    ///
    ///     Result.OnStart := nil;   // If nil then; Can be omitted
    ///
    ///     Result.OnSuccess := procedure (Sender: TObject; Image: TStableImage)
    ///       begin
    ///         // Handle success operation
    ///       end;
    ///
    ///     Result.OnError := procedure (Sender: TObject; Error: string)
    ///       begin
    ///         // Handle error message
    ///       end;
    ///   end);
    /// </code>
    /// </remarks>
    procedure Style(ParamProc: TProc<TStyle>; CallBacks: TFunc<TAsynStableImage>); overload;
  end;

implementation

uses
  System.StrUtils, StabilityAI.NetEncoding.Base64, StabilityAI.Async.Support;

{ TSketch }

function TSketch.ControlStrength(const Value: Double): TSketch;
begin
  AddField(CheckFloat('control_strength', Value, 0, 1), Value.ToString);
  Result := Self;
end;

constructor TSketch.Create;
begin
  inherited Create(True);
end;

function TSketch.Image(const FilePath: string): TSketch;
begin
  AddBytes('image', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TSketch.Image(const Stream: TStream; StreamFreed: Boolean): TSketch;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('image', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('image', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

{ TStyle }

constructor TStyle.Create;
begin
  inherited Create(True);
end;

function TStyle.Fidelity(const Value: Double): TStyle;
begin
  AddField(CheckFloat('fidelity', Value, 0, 1), Value.ToString);
  Result := Self;
end;

function TStyle.Image(const FilePath: string): TStyle;
begin
  AddBytes('image', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TStyle.Image(const Stream: TStream; StreamFreed: Boolean): TStyle;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('image', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('image', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

{ TControlRoute }

function TControlRoute.Sketch(ParamProc: TProc<TSketch>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TSketch>('v2beta/stable-image/control/sketch', ParamProc);
end;

procedure TControlRoute.Sketch(ParamProc: TProc<TSketch>; CallBacks: TFunc<TAsynStableImage>);
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
        Result := Self.Sketch(ParamProc);
      end);
  finally
    Free;
  end;
end;

function TControlRoute.Structure(ParamProc: TProc<TStructure>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TStructure>('v2beta/stable-image/control/structure', ParamProc);
end;

procedure TControlRoute.Structure(ParamProc: TProc<TStructure>; CallBacks: TFunc<TAsynStableImage>);
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
        Result := Self.Structure(ParamProc);
      end);
  finally
    Free;
  end;
end;

function TControlRoute.Style(ParamProc: TProc<TStyle>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TStyle>('v2beta/stable-image/control/style', ParamProc);
end;

procedure TControlRoute.Style(ParamProc: TProc<TStyle>; CallBacks: TFunc<TAsynStableImage>);
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
        Result := Self.Style(ParamProc);
      end);
  finally
    Free;
  end;
end;

end.
