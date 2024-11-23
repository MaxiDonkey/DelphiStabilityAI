unit StabilityAI.Version1.User;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

uses
  System.SysUtils, System.Classes, System.Net.Mime, REST.JsonReflect, System.JSON,
  REST.Json.Types, StabilityAI.API, StabilityAI.API.Params, StabilityAI.Async.Support;

type
  /// <summary>
  /// Represents an organization associated with a user in the StabilityAI API.
  /// </summary>
  /// <remarks>
  /// This class encapsulates information about an organization, including its ID, name, role,
  /// and whether it is the default organization for the user.
  /// </remarks>
  TOrganization = class
  private
    FId: string;
    FName: string;
    FRole: string;
    [JsonNameAttribute('is_default')]
    FIsDefault: Boolean;
  public
    /// <summary>
    /// The organization's ID
    /// </summary>
    property Id: string read FId write FId;
    /// <summary>
    /// The organization's name
    /// </summary>
    property Name: string read FName write FName;
    /// <summary>
    /// The organization's role
    /// </summary>
    property Role: string read FRole write FRole;
    /// <summary>
    /// True: if is the default organization
    /// </summary>
    property IsDefault: Boolean read FIsDefault write FIsDefault;
  end;

  /// <summary>
  /// Represents the details of a user's account in the StabilityAI API.
  /// </summary>
  /// <remarks>
  /// This class provides access to user-related information such as the user's unique ID,
  /// email, associated organizations, and profile picture.
  /// </remarks>
  TAccountDetails = class
  private
    FId: string;
    FEmail: string;
    FOrganizations: TArray<TOrganization>;
    [JsonNameAttribute('profile_picture')]
    FProfilePicture: string;
  public
    /// <summary>
    /// The user's ID
    /// </summary>
    property Id: string read FId write FId;
    /// <summary>
    /// The user's email
    /// </summary>
    property Email: string read FEmail write FEmail;
    /// <summary>
    /// The user's organizations
    /// </summary>
    property Organizations: TArray<TOrganization> read FOrganizations write FOrganizations;
    /// <summary>
    /// The user's profile picture
    /// </summary>
    property ProfilePicture: string read FProfilePicture write FProfilePicture;
    destructor Destroy; override;
  end;

  /// <summary>
  /// Represents the account balance associated with the API key in the StabilityAI system.
  /// </summary>
  /// <remarks>
  /// This class provides information about the available credits in the user's account or organization.
  /// </remarks>
  TAccountBalance = class
  private
    FCredits: Double;
  public
    /// <summary>
    /// The balance of the account/organization associated with the API key
    /// </summary>
    property Credits: Double read FCredits write FCredits;
  end;

  /// <summary>
  /// Manages asynchronous chat callBacks for a chat request using <c>TAccountDetails</c> as the response type.
  /// </summary>
  /// <remarks>
  /// The <c>TAsynAccountDetails</c> type extends the <c>TAsynParams&lt;TAccountDetails&gt;</c> record to handle the lifecycle of an asynchronous chat operation.
  /// It provides event handlers that trigger at various stages, such as when the operation starts, completes successfully, or encounters an error.
  /// This structure facilitates non-blocking chat operations and is specifically tailored for scenarios where multiple choices from a chat model are required.
  /// </remarks>
  TAsynAccountDetails = TAsynCallBack<TAccountDetails>;

  /// <summary>
  /// Manages asynchronous chat callBacks for a chat request using <c>TAccountBalance</c> as the response type.
  /// </summary>
  /// <remarks>
  /// The <c>TAsynAccountBalance</c> type extends the <c>TAccountBalance&gt;</c> record to handle the lifecycle of an asynchronous chat operation.
  /// It provides event handlers that trigger at various stages, such as when the operation starts, completes successfully, or encounters an error.
  /// This structure facilitates non-blocking chat operations and is specifically tailored for scenarios where multiple choices from a chat model are required.
  /// </remarks>
  TAsynAccountBalance = TAsynCallBack<TAccountBalance>;

  TUserRoute = class(TStabilityAIAPIRoute)
    function AccountDetails: TAccountDetails; overload;
    procedure AccountDetails(CallBacks: TFunc<TAsynAccountDetails>); overload;

    function AccountBalance: TAccountBalance; overload;
    procedure AccountBalance(CallBacks: TFunc<TAsynAccountBalance>); overload;
  end;

implementation

uses
  Rest.Json;

{ TAccountDetails }

destructor TAccountDetails.Destroy;
begin
  for var Item in FOrganizations do
    Item.Free;
  inherited;
end;

{ TUserRoute }

procedure TUserRoute.AccountBalance(CallBacks: TFunc<TAsynAccountBalance>);
begin
  with TAsynCallBackExec<TAsynAccountBalance, TAccountBalance>.Create(CallBacks) do
  try
    Sender := Use.Param.Sender;
    OnStart := Use.Param.OnStart;
    OnSuccess := Use.Param.OnSuccess;
    OnError := Use.Param.OnError;
    Run(
      function: TAccountBalance
      begin
        Result := Self.AccountBalance;
      end);
  finally
    Free;
  end;
end;

function TUserRoute.AccountBalance: TAccountBalance;
begin
  Result := API.Get<TAccountBalance>('v1/user/balance');
end;

procedure TUserRoute.AccountDetails(CallBacks: TFunc<TAsynAccountDetails>);
begin
  with TAsynCallBackExec<TAsynAccountDetails, TAccountDetails>.Create(CallBacks) do
  try
    Sender := Use.Param.Sender;
    OnStart := Use.Param.OnStart;
    OnSuccess := Use.Param.OnSuccess;
    OnError := Use.Param.OnError;
    Run(
      function: TAccountDetails
      begin
        Result := Self.AccountDetails;
      end);
  finally
    Free;
  end;
end;

function TUserRoute.AccountDetails: TAccountDetails;
begin
  Result := API.Get<TAccountDetails>('v1/user/account');
end;

end.
