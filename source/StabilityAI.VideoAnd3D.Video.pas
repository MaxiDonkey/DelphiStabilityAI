unit StabilityAI.VideoAnd3D.Video;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

uses
  System.SysUtils, System.Classes, System.Net.Mime, REST.JsonReflect, System.JSON,
  REST.Json.Types, StabilityAI.API, StabilityAI.Common, StabilityAI.Async.Support;

type
  /// <summary>
  /// The <c>TVideo</c> class provides functionality to create short, high-quality video clips from images or text-based prompts.
  /// It leverages advanced video diffusion models, allowing users to easily generate content for applications in game development, animation, virtual reality, and creative content production.
  /// </summary>
  /// <remarks>
  /// This class <c>TVideo</c> is responsible for managing parameters related to the API calls, encapsulating them in an intuitive manner.
  /// The parameters are prepared and provided through anonymous methods, ensuring seamless integration with other methods that call these APIs.
  /// The TVideo class abstracts the complexity of parameter management, making it easier for developers to generate creative video outputs without dealing with low-level implementation details.
  /// </remarks>
  TVideo = class(TMultipartFormData)
    /// <summary>
    /// The source image used in the video generation process.
    /// </summary>
    /// <param name="FilePath">
    /// Filename with supported format (jpeg, png, webp)
    /// </param>
    /// <returns>
    /// The updated <c>TStableImageUltra</c> instance.
    /// </returns>
    /// <remarks>
    /// Supported Dimensions:
    /// <para>
    /// - 1024x576
    /// </para>
    /// <para>
    /// - 576x1024
    /// </para>
    /// <para>
    /// - 768x768
    /// </para>
    /// </remarks>
    function Image(const FilePath: string): TVideo; overload;
    /// <summary>
    /// The source image used in the video generation process.
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
    /// Supported Dimensions:
    /// <para>
    /// - 1024x576
    /// </para>
    /// <para>
    /// - 576x1024
    /// </para>
    /// <para>
    /// - 768x768
    /// </para>
    /// </remarks>
    function Image(const Stream: TStream; StreamFreed: Boolean = False): TVideo; overload;
    /// <summary>
    /// A specific value that is used to guide the 'randomness' of the generation
    /// </summary>
    /// <param name="Value">
    /// number [0 .. 4294967294]  (Default: 0)
    /// </param>
    /// <remarks>
    /// Omit this parameter or pass 0 to use a random seed.
    /// </remarks>
    function Seed(const Value: Int64): TVideo;
    /// <summary>
    /// How strongly the video sticks to the original image.
    /// </summary>
    /// <param name="Value">
    /// Number: [0 .. 10] (Default: 1.8)
    /// </param>
    /// <remarks>
    /// Use lower values to allow the model more freedom to make changes and higher values to correct motion distortions.
    /// </remarks>
    function CfgScale(const Value: Double): TVideo;
    /// <summary>
    /// This parameter corresponds to the motion_bucket_id parameter from the paper.
    /// </summary>
    /// <param name="Value">
    /// Number: [ 1 .. 255 ] (Default: 127)
    /// </param>
    /// <remarks>
    /// Lower values generally result in less motion in the output video, while higher values generally result in more motion.
    /// </remarks>
    function MotionBucketId(const Value: Double): TVideo;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// The <c>TJobVideo</c> class represents a video generation job.
  /// It encapsulates the unique identifier (<c>Id</c>) for tracking the video generation process.
  /// </summary>
  /// <remarks>
  /// This class provides a simple interface for managing video generation jobs.
  /// The <c>Id</c> property can be used to retrieve results or monitor the progress of a job.
  /// Use this class in conjunction with the <c>TVideoRoute</c> to handle video generation tasks efficiently.
  /// </remarks>
  TJobVideo = class
  private
    FId: string;
  public
    /// <summary>
    /// A string representing the job's unique identifier.
    /// </summary>
    property Id: string read FId write FId;
  end;

  /// <summary>
  /// Manages asynchronous callBacks for a request using <c>TJobVideo</c> as the response type.
  /// </summary>
  /// <remarks>
  /// The <c>TAsynJobVideo</c> type extends the <c>TAsynParams&lt;TJobVideo&gt;</c> record to handle the lifecycle of an asynchronous chat operation.
  /// It provides event handlers that trigger at various stages, such as when the operation starts, completes successfully, or encounters an error.
  /// This structure facilitates non-blocking chat operations and is specifically tailored for scenarios where multiple choices from a chat model are required.
  /// </remarks>
  TAsynJobVideo = TAsynCallBack<TJobVideo>;

  /// <summary>
  /// The <c>TVideoRoute</c> class manages video generation processes using Stable Video Diffusion models.
  /// </summary>
  /// <remarks>
  /// This class serves as the primary interface for generating videos from images or text-based prompts.
  /// It provides both synchronous and asynchronous methods for video creation and result retrieval.
  /// Use this class to handle video generation efficiently, including parameter setup and API communication.
  /// </remarks>
  TVideoRoute = class(TStabilityAIAPIRoute)
    /// <summary>
    /// Generate a short video based on an initial image with Stable Video Diffusion, a latent video diffusion model.
    /// <para>
    /// After invoking this endpoint with the required parameters, use the id in the response to poll for results at the image-to-video/result/{id} endpoint. Rate-limiting or other errors may occur if you poll more than once every 10 seconds.
    /// </para>
    /// <para>
    /// NOTE: This method is <c>synchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the mask, the seed, the the format of the output image.
    /// </param>
    /// <returns>
    /// Returns a <c>TJobVideo</c> object that contains then ID of the task.
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
    ///   var Data := Stability.VideoAnd3D.ImageToVideo.Generation(
    ///     procedure (Params: TVideo)
    ///     begin
    ///       // Define parameters.
    ///     end);
    ///   try
    ///     ShowMessage(Data.Id);
    ///   finally
    ///     Data.Free;
    ///   end;
    /// </code>
    /// </remarks>
    function Generation(ParamProc: TProc<TVideo>): TJobVideo; overload;
    /// <summary>
    /// Generate a short video based on an initial image with Stable Video Diffusion, a latent video diffusion model.
    /// <para>
    /// After invoking this endpoint with the required parameters, use the id in the response to poll for results at the image-to-video/result/{id} endpoint. Rate-limiting or other errors may occur if you poll more than once every 10 seconds.
    /// </para>
    /// <para>
    /// NOTE: This method is <c>asynchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the the format of the output image etc.
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
    /// Stability.VideoAnd3D.ImageToVideo.Generation(
    ///   procedure (Params: TVideo)
    ///   begin
    ///     // Define parameters
    ///   end,
    ///
    ///   function : TAsynJobVideo
    ///   begin
    ///     Result.Sender := my_obj;  // Instance passed to callback parameter
    ///
    ///     Result.OnStart := nil;   // If nil then; Can be omitted
    ///
    ///     Result.OnSuccess := procedure (Sender: TObject; Data: TJobVideo)
    ///       begin
    ///         // Handle success operation
    ///         ShowMessage(Data.Id);
    ///       end;
    ///
    ///     Result.OnError := procedure (Sender: TObject; Error: string)
    ///       begin
    ///         // Handle error message
    ///       end;
    ///   end);
    /// </code>
    /// </remarks>
    procedure Generation(ParamProc: TProc<TVideo>; CallBacks: TFunc<TAsynJobVideo>); overload;
    /// <summary>
    /// Fetch the result of an image-to-video generation by ID.
    /// <para>
    /// Make sure to use the same API key to fetch the generation result that you used to create the generation, otherwise you will receive a 404 response.
    /// </para>
    /// <para>
    /// NOTE: This method is <c>synchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ResultId">
    /// The id of a generation, typically used for async generations, that can be used to check the status of the generation or retrieve the result.
    /// <para>
    /// string = 64 characters
    /// </para>
    /// <para>
    /// - Example: d4fb4aa8301aee0b368a41b3c0a78018dfc28f1f959a3666be2e6951408fb8e3
    /// </para>
    /// <para>
    /// - Results are stored for 24 hours after generation. After that, the results are deleted and you will need to re-generate your video.
    /// </para>
    /// </param>
    /// <returns>
    /// Returns a <c>TResults</c> object that contains <c>Id</c>, <c>Status</c> and and possibly a <c>video</c>.
    /// </returns>
    /// <remarks>
    /// <code>
    ///   var Stability := TStabilityAIFactory.CreateInstance(BaererKey);
    ///   var Fetch := Stability.VideoAnd3D.ImageToVideo.Fetch(ID);
    ///   try
    ///     if not (Fetch.Status = 'in-progress') then
    ///       //The video is loaded
    ///       Fetch.SaveToFile('file as .mp4')
    ///   finally
    ///     Fetch.Free;
    ///   end;
    /// </code>
    /// </remarks>
    function Fetch(const ResultId: string): TResults; overload;
    /// <summary>
    /// Fetch the result of an image-to-video generation by ID.
    /// <para>
    /// Make sure to use the same API key to fetch the generation result that you used to create the generation, otherwise you will receive a 404 response.
    /// </para>
    /// <para>
    /// NOTE: This method is <c>synchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ResultId">
    /// The id of a generation, typically used for async generations, that can be used to check the status of the generation or retrieve the result.
    /// <para>
    /// string = 64 characters
    /// </para>
    /// <para>
    /// Example: d4fb4aa8301aee0b368a41b3c0a78018dfc28f1f959a3666be2e6951408fb8e3
    /// </para>
    /// <para>
    /// Results are stored for 24 hours after generation. After that, the results are deleted.
    /// </para>
    /// </param>
    /// <param name="CallBacks">
    /// A function that returns a record containing event handlers for asynchronous image creation, such as <c>onSuccess</c> and <c>onError</c>.
    /// </param>
    /// <remarks>
    /// <code>
    /// // WARNING - Move the following line to the main OnCreate method for maximum scope.
    /// // var Stability := TStabilityAIFactory.CreateInstance(BaererKey);
    /// Stability.VideoAnd3D.ImageToVideo.Fetch(Id,
    ///   function : TAsynResults
    ///   begin
    ///     Result.Sender := my_object;  // Instance passed to callback parameter
    ///
    ///     Result.OnStart := nil;   // If nil then; Can be omitted
    ///
    ///     Result.OnSuccess := procedure (Sender: TObject; Data: TResults)
    ///       begin
    ///         // Handle success operation
    ///         Data.SaveToFile('file as .mp4')
    ///       end;
    ///
    ///     Result.OnError := procedure (Sender: TObject; Error: string)
    ///       begin
    ///         // Handle error message
    ///       end;
    ///   end);
    /// </code>
    /// </remarks>
    procedure Fetch(const ResultId: string; CallBacks: TFunc<TAsynResults>); overload;
  end;

implementation

uses
  StabilityAI.NetEncoding.Base64, StabilityAI.Consts;

{ TVideo }

function TVideo.CfgScale(const Value: Double): TVideo;
begin
  AddField(CheckFloat('cfg_scale', Value, 0, 10), Value.ToString);
  Result := Self;
end;

constructor TVideo.Create;
begin
  inherited Create(True);
end;

function TVideo.Image(const FilePath: string): TVideo;
begin
  AddBytes('image', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TVideo.Image(const Stream: TStream; StreamFreed: Boolean): TVideo;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('image', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('image', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

function TVideo.MotionBucketId(const Value: Double): TVideo;
begin
  AddField(CheckFloat('motion_bucket_id', Value, 1, 255), Value.ToString);
  Result := Self;
end;

function TVideo.Seed(const Value: Int64): TVideo;
begin
  AddField(CheckInteger('seed', Value, 0, SeedMax), Value.ToString);
  Result := Self;
end;

{ TVideoRoute }

function TVideoRoute.Fetch(const ResultId: string): TResults;
begin
  Result := API.Get<TResults>('v2beta/image-to-video/result/' + ResultId);
end;

procedure TVideoRoute.Fetch(const ResultId: string; CallBacks: TFunc<TAsynResults>);
begin
  with TAsynCallBackExec<TAsynResults, TResults>.Create(CallBacks) do
  try
    Sender := Use.Param.Sender;
    OnStart := Use.Param.OnStart;
    OnSuccess := Use.Param.OnSuccess;
    OnError := Use.Param.OnError;
    Run(
      function: TResults
      begin
        Result := Self.Fetch(ResultId);
      end);
  finally
    Free;
  end;
end;

function TVideoRoute.Generation(ParamProc: TProc<TVideo>): TJobVideo;
begin
  Result := API.PostForm<TJobVideo, TVideo>('v2beta/image-to-video', ParamProc);
end;

procedure TVideoRoute.Generation(ParamProc: TProc<TVideo>;
  CallBacks: TFunc<TAsynJobVideo>);
begin
  with TAsynCallBackExec<TAsynJobVideo, TJobVideo>.Create(CallBacks) do
  try
    Sender := Use.Param.Sender;
    OnStart := Use.Param.OnStart;
    OnSuccess := Use.Param.OnSuccess;
    OnError := Use.Param.OnError;
    Run(
      function: TJobVideo
      begin
        Result := Self.Generation(ParamProc);
      end);
  finally
    Free;
  end;
end;

end.
