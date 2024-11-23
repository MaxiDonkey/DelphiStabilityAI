unit StabilityAI.Errors;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

uses
  REST.Json.Types;

type
  TErrorCore = class abstract
  end;

  TError = class(TErrorCore)
  private
    FId: string;
    FName: string;
    FErrors: TArray<string>;
  public
    property Id: string read FId write FId;
    property Name: string read FName write FName;
    property Errors: TArray<string> read FErrors write FErrors;
  end;

implementation


end.
