unit StabilityAI.Types;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

{--- Types only for versions greater than 1 }

type
  /// <summary>
  /// Styles to guide the model
  /// </summary>
  /// <remarks>
  /// Enum: <c>model3d</c>, <c>analogFilm</c>, <c>anime</c>, <c>cinematic</c>, <c>comicBook</c>,
  /// <c>digitalArt</c>, <c>enhance</c>, <c>fantasyArt</c>, <c>isometric</c>, <c>lineArt</c>,
  /// <c>lowPoly</c>, <c>modelingCompound</c>, <c>neonPunk</c>, <c>origami</c>, <c>photographic</c>,
  /// <c>pixelArt</c>, <c>tileTexture</c>
  /// </remarks>
  TStylePreset = (
    model3d,
    analogFilm,
    anime,
    cinematic,
    comicBook,
    digitalArt,
    enhance,
    fantasyArt,
    isometric,
    lineArt,
    lowPoly,
    modelingCompound,
    neonPunk,
    origami,
    photographic,
    pixelArt,
    tileTexture
  );

  TStylePresetHelper = record helper for TStylePreset
    function ToString: string;
  end;

  /// <summary>
  /// Stable Diffusion 3.0 models
  /// </summary>
  /// <remarks>
  /// Enum: <c>sd3Large</c>, <c>sd3LargeTurbo</c>, <c>sd3Medium</c>, <c>sd35Large</c>, <c>sd35LargeTurbo</c>, <c>sd35Medium</c>
  /// </remarks>
  TDiffusionModelType = (
    sd3Large,
    sd3LargeTurbo,
    sd3Medium,
    sd35Large,
    sd35LargeTurbo,
    sd35Medium
  );

  TDiffusionModelTypeHelper = record helper for TDiffusionModelType
    function ToString: string;
  end;

  /// <summary>
  /// Support for image building
  /// </summary>
  /// <remarks>
  /// Enum: <c>imageToImage</c>, <c>textToImage</c>
  /// </remarks>
  TGenerationMode = (
    imageToImage,
    textToImage
  );

  TGenerationModeHelper = record helper for TGenerationMode
    function ToString: string;
  end;

  /// <summary>
  /// Output format for the resulting image
  /// </summary>
  /// <remarks>
  /// Enum: <c>jpeg</c>, <c>png</c>, <c>webp</c>
  /// </remarks>
  TOutPutFormat = (
    jpeg,
    png,
    webp
  );

  TOutPutFormatHelper = record helper for TOutPutFormat
    function ToString: string;
  end;

  /// <summary>
  /// Aspect ratio of the generated image
  /// </summary>
  /// <remarks>
  /// Enum: <c>ratio16x9</c>, <c>ratio1x1</c>, <c>ratio21x9</c>, <c>ratio2x3</c>, <c>ratio3x2</c>,
  /// <c>ratio4x5</c>, <c>ratio5x4</c>, <c>ratio9x16</c>, <c>ratio9x21</c>
  /// </remarks>
  TAspectRatioType = (
    ratio16x9,
    ratio1x1,
    ratio21x9,
    ratio2x3,
    ratio3x2,
    ratio4x5,
    ratio5x4,
    ratio9x16,
    ratio9x21
  );

  TAspectRatioTypeHelper = record helper for TAspectRatioType
    function ToString: string;
  end;

  /// <summary>
  /// Direction of the light source.
  /// </summary>
  /// <remarks>
  /// Enum: <c>above</c>, <c>below</c>, <c>left</c>, <c>right</c>
  /// </remarks>
  TLightSourceDirection = (
    above,
    below,
    left,
    right
  );

  TLightSourceDirectionHelper = record helper for TLightSourceDirection
    function ToString: string;
  end;

  /// <summary>
  /// Resolutions of the textures used for both the albedo (color) map and the normal map.
  /// </summary>
  /// <summary>
  /// Enum: <c>r1024</c>, <c>r2048</c>, <c>r512</c>
  /// </summary>
  TTextureResolutionType = (
    r1024,
    r2048,
    r512
  );

  TTextureResolutionTypeHelper = record helper for TTextureResolutionType
    function ToString: string;
  end;

  /// <summary>
  /// Remeshing algorithm types.
  /// </summary>
  /// <remarks>
  /// Enum: <c>none</c>, <c>quad</c>, <c>triangle</c>
  /// </remarks>
  TRemeshType = (
    none,
    quad,
    triangle
  );

  TRemeshTypeHelper = record helper for TRemeshType
    function ToString: string;
  end;

implementation

{ TStylePresetHelper }

function TStylePresetHelper.ToString: string;
begin
  case Self of
    model3d:
      Exit('3d-model');
    analogFilm:
      Exit('analog-film');
    anime:
      Exit('anime');
    cinematic:
      Exit('cinematic');
    comicBook:
      Exit('comic-book');
    digitalArt:
      Exit('digital-art');
    enhance:
      Exit('enhance');
    fantasyArt:
      Exit('fantasy-art');
    isometric:
      Exit('isometric');
    lineArt:
      Exit('line-art');
    lowPoly:
      Exit('low-poly');
    modelingCompound:
      Exit('modeling-compound');
    neonPunk:
      Exit('neon-punk');
    origami:
      Exit('origami');
    photographic:
      Exit('photographic');
    pixelArt:
      Exit('pixel-art');
    tileTexture:
      Exit('tile-texture');
  end;
end;

{ TDiffusionModelTypeHelper }

function TDiffusionModelTypeHelper.ToString: string;
begin
  case Self of
    sd3Large:
      Exit('sd3-large');
    sd3LargeTurbo:
      Exit('sd3-large-turbo');
    sd3Medium:
      Exit('sd3-medium');
    sd35Large:
      Exit('sd3.5-large');
    sd35LargeTurbo:
      Exit('sd3.5-large-turbo');
    sd35Medium:
      Exit('sd3.5-medium');
  end;
end;

{ TOutPutFormatHelper }

function TOutPutFormatHelper.ToString: string;
begin
  case Self of
    jpeg:
      Exit('jpeg');
    png:
      Exit('png');
    webp:
      Exit('webp');
  end;
end;

{ TAspectRatioTypeHelper }

function TAspectRatioTypeHelper.ToString: string;
begin
  case Self of
    ratio16x9:
      Exit('16:9');
    ratio1x1:
      Exit('1:1');
    ratio21x9:
      Exit('21:9');
    ratio2x3:
      Exit('2:3');
    ratio3x2:
      Exit('3:2');
    ratio4x5:
      Exit('4:5');
    ratio5x4:
      Exit('5:4');
    ratio9x16:
      Exit('9:16');
    ratio9x21:
      Exit('16:9');
  end;
end;

{ TLightSourceDirectionHelper }

function TLightSourceDirectionHelper.ToString: string;
begin
  case Self of
    above:
      Exit('above');
    below:
      Exit('below');
    left:
      Exit('left');
    right:
      Exit('right');
  end;
end;

{ TGenerationModeHelper }

function TGenerationModeHelper.ToString: string;
begin
  case self of
    imageToImage:
      Exit('image-to-image');
    textToImage:
      Exit('text-to-image');
  end;
end;

{ TTextureResolutionTypeHelper }

function TTextureResolutionTypeHelper.ToString: string;
begin
  case Self of
    r1024:
      Exit('1024');
    r2048:
      Exit('2048');
    r512:
      Exit('512');
  end;
end;

{ TRemeshTypeHelper }

function TRemeshTypeHelper.ToString: string;
begin
  case Self of
    none:
      Exit('none');
    quad:
      Exit('quad');
    triangle:
      Exit('triangle');
  end;
end;

end.
