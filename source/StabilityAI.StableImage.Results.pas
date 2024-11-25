unit StabilityAI.StableImage.Results;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

uses
  System.SysUtils, System.Classes, System.Net.Mime, REST.JsonReflect, System.JSON,
  REST.Json.Types, StabilityAI.API, StabilityAI.Common;

type
  TResultsRoute = class(TStabilityAIAPIRoute)
    /// <summary>
    /// Tools to retrieve the results of your asynchronous (or cached) builds.
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
    /// Example: a6dc6c6e20acda010fe14d71f180658f2896ed9b4ec25aa99a6ff06c796987c4
    /// </para>
    /// <para>
    /// Results are stored for 24 hours after generation. After that, the results are deleted.
    /// </para>
    /// </param>
    /// <returns>
    /// Returns a <c>TResults</c> object that contains <c>Id</c>, <c>Status</c> and and possibly an <c>image</c>.
    /// </returns>
    /// <remarks>
    /// The <c>Fetch</c> method sends a request to check the status of an image creation task. The returned <c>TResults</c> object contains the creation task ID and the status <c>in progress</c> if the process is not yet complete. Otherwise, the image is retrieved in base-64 format.
    /// <code>
    ///   var Stability := TStabilityAIFactory.CreateInstance(BaererKey);
    ///   var Fetch := Stability.StableImage.Results.Fetch(ID);
    ///   try
    ///     if not (Fetch.Status = 'in-progress') then
    ///       //The image is loaded
    ///       var Stream := Fetch.GetStream;
    ///       //Do something
    ///   finally
    ///     Stream.Free;
    ///     Fetch.Free;
    ///   end;
    /// </code>
    /// </remarks>
    function Fetch(const ResultId: string): TResults; overload;
    /// <summary>
    /// Tools to retrieve the results of your asynchronous (or cached) builds.
    /// <para>
    /// NOTE: This method is <c>asynchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ResultId">
    /// The id of a generation, typically used for async generations, that can be used to check the status of the generation or retrieve the result.
    /// <para>
    /// string = 64 characters
    /// </para>
    /// <para>
    /// Example: a6dc6c6e20acda010fe14d71f180658f2896ed9b4ec25aa99a6ff06c796987c4
    /// </para>
    /// <para>
    /// Results are stored for 24 hours after generation. After that, the results are deleted.
    /// </para>
    /// </param>
    /// <param name="CallBacks">
    /// A function that returns a record containing event handlers for asynchronous image creation, such as <c>onSuccess</c> and <c>onError</c>.
    /// </param>
    /// <remarks>
    /// The <c>Fetch</c> method sends a request to check the status of an image creation task. If the status is different from <c>in-progress</c>, then the corresponding image is loaded.
    /// <code>
    /// // WARNING - Move the following line to the main OnCreate method for maximum scope.
    /// // var Stability := TStabilityAIFactory.CreateInstance(BaererKey);
    /// Stability.StableImage.Results.Fetch(Id,
    ///   function : TAsynResults
    ///   begin
    ///     Result.Sender := Image1;  // Instance passed to callback parameter
    ///
    ///     Result.OnStart := nil;   // If nil then; Can be omitted
    ///
    ///     Result.OnSuccess := procedure (Sender: TObject; FetchResult: TResults)
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
    procedure Fetch(const ResultId: string; CallBacks: TFunc<TAsynResults>); overload;
  end;

implementation

uses
  StabilityAI.Consts, StabilityAI.Async.Support;

{ TResultsRoute }

function TResultsRoute.Fetch(const ResultId: string): TResults;
begin
  Result := API.Get<TResults>('v2beta/results/' + ResultId);
  if Assigned(Result) then
    begin
      if not (Result.status = 'in-progress') and not Result.Result.IsEmpty then
        begin
          {--- Documentation not compliant because it does not state that Fetch reloads a Result field
               and not the image field of the TStableImage class }
          Result.Image := Result.Result;
        end;
    end;
end;


procedure TResultsRoute.Fetch(const ResultId: string; CallBacks: TFunc<TAsynResults>);
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

end.
