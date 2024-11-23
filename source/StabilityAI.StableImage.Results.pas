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
    procedure Fetch(const ResultId: string; CallBacks: TFunc<TAsynResults>); overload;
    function Fetch(const ResultId: string): TResults; overload;
  end;

implementation

uses
  StabilityAI.Consts, StabilityAI.Async.Support;

{ TResultsRoute }

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

end.
