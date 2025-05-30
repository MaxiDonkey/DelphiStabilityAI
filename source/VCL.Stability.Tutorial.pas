unit VCL.Stability.Tutorial;

{ Tutorial Support Unit

   WARNING:
     This module is intended solely to illustrate the examples provided in the
     README.md file of the repository :
         https://github.com/MaxiDonkey/DelphiStabilityAI.
     Under no circumstances should the methods described below be used outside
     of the examples presented on the repository's page.
}

interface

uses
  System.SysUtils, System.Classes, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Controls, Vcl.Forms,
  StabilityAI.Common, StabilityAI.Version1.SDXL1AndSD1_6, StabilityAI.VideoAnd3D.Stable3D,
  StabilityAI.VideoAnd3D.Video, StabilityAI.Version1.Engines, StabilityAI.Version1.User;

type
  TVCLStabilitySender = class
  private
    FId: string;
    FMemo: TMemo;
    FImage: TImage;
    FFileName: string;
  public
    property Id: string read FId write FId;
    property Memo: TMemo read FMemo write FMemo;
    property Image: TImage read FImage write FImage;
    property FileName: string read FFileName write FFileName;
    constructor Create(const AMemo: TMemo; const AImage: TImage);
  end;

  procedure Start(Sender: TObject);
  procedure Display(Sender: TObject; Value: string); overload;
  procedure Display(Sender: TObject; Result: TStableImage); overload;
  procedure Display(Sender: TObject; Result: TArtifacts); overload;
  procedure Display(Sender: TObject; Value: TResults); overload;
  procedure Display(Sender: TObject; Value: TModel3D); overload;
  procedure Display(Sender: TObject; Value: TJobVideo); overload;
  procedure Display(Sender: TObject; Value: TEngines); overload;
  procedure Display(Sender: TObject; Value: TAccountDetails); overload;

var
  StabilityResult: TVCLStabilitySender = nil;

implementation

procedure Start(Sender: TObject);
begin
  Display(Sender, 'Request sended. Please wait...');
end;

procedure Display(Sender: TObject; Value: string);
begin
  var T := Sender as TVCLStabilitySender;
  T.Memo.Lines.Text := T.Memo.Text + Value + sLineBreak;
end;

procedure Display(Sender: TObject; Result: TStableImage);
begin
  var T := Sender as TVclStabilitySender;
  var Stream := Result.GetStream;
  try
    if not T.FileName.IsEmpty then
      Result.SaveToFile(T.FileName);
    Display(Sender, 'Save to file : ' + T.FileName);
    {--- Display only images }
    if not Result.Image.IsEmpty then
      T.Image.Picture.LoadFromStream(Stream);
    Display(Sender, 'Operation ended successfully');
  finally
    Stream.Free;
  end;
end;

procedure Display(Sender: TObject; Result: TArtifacts);
begin
  var T := Sender as TVCLStabilitySender;
  var Stream := Result.Artifacts[0].GetStream;
  try
    if not T.FileName.IsEmpty then
      Result.SaveToFile(T.FileName);
    T.Image.Picture.LoadFromStream(Stream);
    Display(Sender, 'Operation ended successfully');
  finally
    Stream.Free;
  end;
end;

procedure Display(Sender: TObject; Value: TResults); overload;
begin
  if not Value.Id.IsEmpty then
    begin
      Display(Sender, Value.Id);
      StabilityResult.Id := Value.Id;
      { Keep only the last ID of the job in progress !!!
        Please refer to the warning in the unit header. }
    end;
  if Value.Status = 'in-progress' then
    begin
      Display(Sender, 'in-progress');
      Exit;
    end;
  try
    Display(Sender, Value as TStableImage);
  except
  end;
end;

procedure Display(Sender: TObject; Value: TModel3D);
begin
  var T := Sender as TVCLStabilitySender;
  Value.SaveToFile(T.FileName);
  Display(Sender, 'Model 3d : ' + T.FileName);
end;

procedure Display(Sender: TObject; Value: TJobVideo);
begin
  Display(Sender, Value.Id);
end;

procedure Display(Sender: TObject; Value: TEngines);
begin
  for var Item in Value.Result do
    Display(Sender, Item.Name);
end;

procedure Display(Sender: TObject; Value: TAccountDetails);
begin
  Display(Sender, Value.Id);
  Display(Sender, Value.Email);
  Display(Sender, Value.ProfilePicture);
  for var Item in Value.Organizations do
    begin
      Display(Sender, Item.Id);
      Display(Sender, Item.Name);
      Display(Sender, Item.Role);
      Display(Sender, BoolToStr(Item.IsDefault, True));
    end;
end;

{ TVCLStabilitySender }

constructor TVCLStabilitySender.Create(const AMemo: TMemo;
  const AImage: TImage);
begin
  inherited Create;
  FMemo := AMemo;
  FImage := AImage;
end;

initialization
finalization
  if Assigned(StabilityResult) then
    StabilityResult.Free;
end.
