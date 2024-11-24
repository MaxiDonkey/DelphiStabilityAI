unit FMX.Stability.Tutorial;

{ Tutorial Support Unit }

interface

uses
  System.SysUtils, System.Classes, System.Types, FMX.Memo, FMX.Objects, FMX.Forms,
  StabilityAI.Common, StabilityAI.Version1.SDXL1AndSD1_6;

type
  TFMXStabilitySender = class
  private
    FMemo: TMemo;
    FImage: TImage;
    FFileName: string;
  public
    property Memo: TMemo read FMemo write FMemo;
    property Image: TImage read FImage write FImage;
    property FileName: string read FFileName write FFileName;
    constructor Create(const AMemo: TMemo; const AImage: TImage);
  end;

  procedure Start(Sender: TObject);
  procedure Display(Sender: TObject; Value: string); overload;
  procedure Display(Sender: TObject; Result: TStableImage); overload;
  procedure Display(Sender: TObject; Result: TArtifacts); overload;

var
  StabilityResult: TFMXStabilitySender;

implementation

procedure Start(Sender: TObject);
begin
  Display(Sender, 'The generation has started. Please wait...');
end;

procedure Display(Sender: TObject; Value: string);
begin
  var T := Sender as TFMXStabilitySender;
  T.Memo.Lines.Text := T.Memo.Text + Value + sLineBreak;
end;

procedure Display(Sender: TObject; Result: TStableImage);
begin
  var T := Sender as TFMXStabilitySender;
  var Stream := Result.GetStream;
  try
    if not T.FileName.IsEmpty then
      Result.SaveToFile(T.FileName);
    T.Image.Bitmap.LoadFromStream(Stream);
    Display(Sender, 'Generation ended successfully');
  finally
    Stream.Free;
  end;
end;

procedure Display(Sender: TObject; Result: TArtifacts);
begin
  var T := Sender as TVclStabilitySender;
  var Stream := Result.Artifacts[0].GetStream;
  try
    if not T.FileName.IsEmpty then
      Result.SaveToFile(T.FileName);
    T.Image. Picture.LoadFromStream(Stream);
    Display(Sender, 'Generation ended successfully');
  finally
    Stream.Free;
  end;
end;

{ TFMXStabilitySender }

constructor TFMXStabilitySender.Create(const AMemo: TMemo;
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
