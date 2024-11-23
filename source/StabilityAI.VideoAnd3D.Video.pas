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
  /// Manages asynchronous chat callBacks for a chat request using <c>TJobVideo</c> as the response type.
  /// </summary>
  /// <remarks>
  /// The <c>TAsynJobVideo</c> type extends the <c>TJobVideo&gt;</c> record to handle the lifecycle of an asynchronous chat operation.
  /// It provides event handlers that trigger at various stages, such as when the operation starts, completes successfully, or encounters an error.
  /// This structure facilitates non-blocking chat operations and is specifically tailored for scenarios where multiple choices from a chat model are required.
  /// </remarks>
  TAsynJobVideo = TAsynCallBack<TJobVideo>;

  TVideoRoute = class(TStabilityAIAPIRoute)
    function Generation(ParamProc: TProc<TVideo>): TJobVideo; overload;
    procedure Generation(ParamProc: TProc<TVideo>; CallBacks: TFunc<TAsynJobVideo>); overload;

    function Fetch(const ResultId: string): TResults; overload;
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

function TVideoRoute.Fetch(const ResultId: string): TResults;
begin
  Result := API.Get<TResults>('v2beta/image-to-video/result/' + ResultId);
end;

function TVideoRoute.Generation(ParamProc: TProc<TVideo>): TJobVideo;
begin
  Result := API.PostForm<TJobVideo, TVideo>('v2beta/image-to-video', ParamProc);
end;

end.
