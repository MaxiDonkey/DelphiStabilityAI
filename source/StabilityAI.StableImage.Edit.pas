unit StabilityAI.StableImage.Edit;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

uses
  System.SysUtils, System.Classes, System.Net.Mime, REST.JsonReflect, System.JSON,
  REST.Json.Types, StabilityAI.API, StabilityAI.Types, StabilityAI.Common;

type
  /// <summary>
  /// <c>TErase</c> is a class designed to manage parameters for the Erase image manipulation service.
  /// This service is used to remove unwanted objects from images by utilizing image masks.
  /// </summary>
  /// <remarks>
  /// <c>TErase</c> centralizes parameter handling for the Erase API, allowing for efficient reuse through anonymous methods that can be directly passed to API-consuming functions.
  /// The masks used to remove unwanted elements can be provided either explicitly via a separate image or derived from the alpha channel of the main image parameter.
  /// This class simplifies the process of configuring and managing mask-related parameters for consistent image editing operations.
  /// </remarks>
  TErase = class(TEditSeedAndGrowMaskCommon)
    /// <summary>
    /// Controls the strength of the inpainting process on a per-pixel basis, either via a second image (passed into this parameter) or via the alpha channel of the image parameter.
    /// </summary>
    /// <param name="FilePath">
    /// Filename provided
    /// </param>
    /// <remarks>
    /// <para>
    /// - <c>Mask Input Overview</c>
    /// The mask should be a black-and-white image where pixel brightness determines inpainting strength: black means no effect, white means full strength. If the mask size differs from the image, it will be resized automatically.
    /// </para>
    /// <para>
    /// - <c>Alpha Channel Support</c>
    /// If no mask is provided, the alpha channel of the image will be used to create one. Transparent areas will be inpainted, and opaque areas will remain unchanged. If both an alpha channel and a mask are given, the mask takes priority.
    /// </para>
    /// </remarks>
    function Mask(const FilePath: string): TErase; overload;
    /// <summary>
    /// An image stream containing the mask used to control the strength of the inpainting process.
    /// </summary>
    /// <param name="Stream">
    /// A <c>TStream</c> containing the mask image. Supported formats include JPEG, PNG, and WEBP.
    /// </param>
    /// <param name="StreamFreed">
    /// Indicates whether the stream should be automatically freed after processing.
    /// Set to <c>True</c> if the method should take ownership and free the stream,
    /// or <c>False</c> if the caller will manage the stream's lifecycle.
    /// Default is <c>False</c>.
    /// </param>
    /// <returns>
    /// The updated <c>TErase</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// <c>Mask Input Overview:</c>
    /// The mask should be a black-and-white image where pixel brightness determines inpainting strength:
    /// black means no effect, white means full strength. If the mask size differs from the image, it will be resized automatically.
    /// </para>
    /// <para>
    /// <c>Alpha Channel Support:</c>
    /// If no mask is provided, the alpha channel of the image will be used to create one.
    /// Transparent areas will be inpainted, and opaque areas will remain unchanged.
    /// If both an alpha channel and a mask are given, the mask takes priority.
    /// </para>
    /// <para>
    /// If <c>StreamFreed</c> is set to <c>True</c>, the method will automatically free the stream after processing.
    /// If set to <c>False</c>, the caller is responsible for freeing the stream to prevent memory leaks.
    /// </para>
    /// </remarks>
    function Mask(const Stream: TStream; StreamFreed: Boolean = False): TErase; overload;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// <c>TInpaint</c> is a class that facilitates intelligent modification of images by filling in or replacing specified areas with contextually relevant content.
  /// It uses a mask image to determine which areas of the original image should be altered.
  /// </summary>
  /// <remarks>
  /// <c>TInpaint</c> manages the parameters required for image inpainting operations, providing a structured way to supply these parameters via anonymous methods to functions utilizing the inpainting API.
  /// The mask used for inpainting can be provided explicitly through a separate image or derived from the alpha channel of the original image. This approach supports seamless integration with inpainting services, ensuring precise and effective modifications to selected image areas.
  /// </remarks>
  TInpaint = class(TEditSeedAndGrowMaskAndPromtCommon)
    /// <summary>
    /// A blurb of text describing what you do not wish to see in the output image.
    /// </summary>
    /// <param name="Value">
    /// string [1 .. 10000] characters
    /// </param>
    /// <remarks>
    /// This is an advanced feature.
    /// </remarks>
    function NegativePrompt(const Value: string): TInpaint;
    /// <summary>
    /// Controls the strength of the inpainting process on a per-pixel basis, either via a second image (passed into this parameter) or via the alpha channel of the image parameter.
    /// </summary>
    /// <param name="FilePath">
    /// Filename provided
    /// </param>
    /// <remarks>
    /// <para>
    /// - <c>Mask Input Overview</c>
    /// The mask should be a black-and-white image where pixel brightness determines inpainting strength: black means no effect, white means full strength. If the mask size differs from the image, it will be resized automatically.
    /// </para>
    /// <para>
    /// - <c>Alpha Channel Support</c>
    /// If no mask is provided, the alpha channel of the image will be used to create one. Transparent areas will be inpainted, and opaque areas will remain unchanged. If both an alpha channel and a mask are given, the mask takes priority.
    /// </para>
    /// </remarks>
    function Mask(const FilePath: string): TInpaint; overload;
    /// <summary>
    /// Controls the strength of the inpainting process using an image stream.
    /// </summary>
    /// <param name="Stream">
    /// A <c>TStream</c> containing the mask image. Supported formats include JPEG, PNG, and WEBP.
    /// </param>
    /// <param name="StreamFreed">
    /// Indicates whether the stream should be automatically freed after processing.
    /// Set to <c>True</c> if the method should take ownership and free the stream,
    /// or <c>False</c> if the caller will manage the stream's lifecycle.
    /// Default is <c>False</c>.
    /// </param>
    /// <returns>
    /// The updated <c>TInpaint</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// <c>Mask Input Overview:</c>
    /// </para>
    /// <para>
    /// The mask should be a black-and-white image where pixel brightness determines inpainting strength:
    /// black means no effect, white means full strength. If the mask size differs from the image, it will be resized automatically.
    /// </para>
    /// <para>
    /// <c>Alpha Channel Support:</c>
    /// If no mask is provided, the alpha channel of the image will be used to create one.
    /// Transparent areas will be inpainted, and opaque areas will remain unchanged.
    /// If both an alpha channel and a mask are given, the mask takes priority.
    /// </para>
    /// <para>
    /// If <c>StreamFreed</c> is set to <c>True</c>, the method will automatically free the stream after processing.
    /// If set to <c>False</c>, the caller is responsible for freeing the stream to prevent memory leaks.
    /// </para>
    /// </remarks>
    function Mask(const Stream: TStream; StreamFreed: Boolean = False): TInpaint; overload;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// <c>TOutpaint</c> is a class designed to manage and configure parameters for the Outpaint service, which extends existing images by filling additional space seamlessly in any direction.
  /// This class aims to facilitate efficient expansion of images while minimizing visible artifacts or signs of modification.
  /// </summary>
  /// <remarks>
  /// <c>TOutpaint</c> centralizes the handling of parameters for the Outpaint API, enabling the use of anonymous methods to pass these parameters to API-consuming functions.
  /// The approach ensures that extending an image's boundaries can be performed with minimal manual configuration, preserving consistency and visual integrity in the output.
  /// </remarks>
  TOutpaint = class(TEditSeedCommon)
    /// <summary>
    /// The number of pixels to outpaint on the left side of the image.
    /// </summary>
    /// <param name="Value">
    /// integer [ 0 .. 2000 ] (Default: 0)
    /// </param>
    /// <remarks>
    /// At least one outpainting direction must be supplied with a non-zero value.
    /// </remarks>
    function Left(const Value: Integer): TOutpaint;
    /// <summary>
    /// The number of pixels to outpaint on the right side of the image.
    /// </summary>
    /// <param name="Value">
    /// integer [ 0 .. 2000 ] (Default: 0)
    /// </param>
    /// <remarks>
    /// At least one outpainting direction must be supplied with a non-zero value.
    /// </remarks>
    function Right(const Value: Integer): TOutpaint;
    /// <summary>
    /// The number of pixels to outpaint on the top of the image.
    /// </summary>
    /// <param name="Value">
    /// integer [ 0 .. 2000 ] (Default: 0)
    /// </param>
    /// <remarks>
    /// At least one outpainting direction must be supplied with a non-zero value.
    /// </remarks>
    function Up(const Value: Integer): TOutpaint;
    /// <summary>
    /// The number of pixels to outpaint on the bottom of the image.
    /// </summary>
    /// <param name="Value">
    /// integer [ 0 .. 2000 ] (Default: 0)
    /// </param>
    /// <remarks>
    /// At least one outpainting direction must be supplied with a non-zero value.
    /// </remarks>
    function Down(const Value: Integer): TOutpaint;
    /// <summary>
    /// Controls the likelihood of creating additional details not heavily conditioned by the init image.
    /// </summary>
    /// <param name="Value">
    /// Number: [0 .. 1]  (Default: 0.5)
    /// </param>
    function Creativity(const Value: Double): TOutpaint;
    /// <summary>
    /// What you wish to see in the output image. A strong, descriptive prompt that clearly defines elements, colors, and subjects will lead to better results.
    /// </summary>
    /// <param name="Value">
    /// string [1 .. 10000] characters
    /// </param>
    /// <remarks>
    /// To control the weight of a given word use the format (word:weight), where word is the word you'd like to control the weight of and weight is a value between 0 and 1.
    /// <para>
    /// - For example: The sky was a crisp (blue:0.3) and (green:0.8) would convey a sky that was blue and green, but more green than blue.
    /// </para>
    /// </remarks>
    function Prompt(const Value: string): TOutpaint;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// <c>TSearchAndReplace</c> is a class designed to manage the parameters for the Search and Replace image inpainting service.
  /// This service allows users to locate and replace objects in an image using simple language, without requiring manual masking.
  /// </summary>
  /// <remarks>
  /// <c>TSearchAndReplace</c> centralizes the parameter management for the Search and Replace API suite. By encapsulating these parameters into a structured class, the parameters can be efficiently reused and supplied as anonymous methods to API-consuming functions.
  /// This design approach simplifies the process of object replacement in images, enabling users to use a search prompt to specify objects for automatic segmentation and replacement.
  /// </remarks>
  TSearchAndReplace = class(TEditSeedAndGrowMaskAndPromtCommon)
    /// <summary>
    /// Short description of what to inpaint in the image.
    /// </summary>
    /// <param name="Value">
    /// string [1 .. 10000] characters
    /// </param>
    function SelectPrompt(const Value: string): TSearchAndReplace;
    /// <summary>
    /// A blurb of text describing what you do not wish to see in the output image.
    /// </summary>
    /// <param name="Value">
    /// string [1 .. 10000] characters
    /// </param>
    /// <remarks>
    /// This is an advanced feature.
    /// </remarks>
    function NegativePrompt(const Value: string): TSearchAndReplace;
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// <c>TSearchAndRecolor</c> is a class designed to manage and provide parameters for the Search and Recolor service, enabling automated object segmentation and color modification within an image.
  /// This service offers an inpainting-like functionality without requiring manual masks, allowing recoloring of specific image elements based solely on a textual prompt.
  /// </summary>
  /// <remarks>
  /// <c>TSearchAndRecolor</c> encapsulates the parameters required by the Search and Recolor API suite. The class enables straightforward reuse of parameters by wrapping them into anonymous methods, which can be directly passed to functions that interact with the API.
  /// By automating object segmentation and recoloring, this service allows users to specify desired colors for particular image elements efficiently, enhancing usability without manual mask creation.
  /// </remarks>
  TSearchAndRecolor = TSearchAndReplace;

  /// <summary>
  /// <c>TRemoveBackground</c> is a class designed to manage parameters for the Remove Background service, which accurately segments the foreground from an image and removes or modifies the background as required.
  /// </summary>
  /// <remarks>
  /// <c>TRemoveBackground</c> provides a structured approach to managing the parameters required by the Remove Background API. By encapsulating these parameters into a cohesive class, it facilitates seamless reuse and efficient integration with functions that utilize these APIs through anonymous methods.
  /// This design aims to simplify the handling of image segmentation tasks while ensuring accurate control over background removal and modification processes.
  /// </remarks>
  TRemoveBackground = class(TEditCommon)
    constructor Create; reintroduce;
  end;

  /// <summary>
  /// <c>TRemoveBackground</c> is a class that manages the parameters for the Replace Background and Relight image editing service.
  /// It enables background replacement, AI background generation, and lighting adjustments to create cohesive and visually enhanced images.
  /// </summary>
  /// <remarks>
  /// TRemoveBackground centralizes parameter handling for the Replace Background and Relight API suite, allowing efficient use of these services through anonymous methods.
  /// This class provides a flexible framework for background removal, replacement, and relighting operations, supporting various input options such as uploaded images or AI-generated backgrounds.
  /// Additionally, it includes features for refining light direction, strength, and reference to achieve realistic and visually consistent results.
  /// </remarks>
  TReplaceBackgroundAndRelight = class(TMultipartFormData)
    /// <summary>
    /// An image containing the subject that you wish to change background and relight.
    /// </summary>
    /// <param name="FilePath">
    /// Filename with supported format (jpeg, png, webp)
    /// </param>
    /// <returns>
    /// The updated <c>TStableImageUltra</c> instance.
    /// </returns>
    /// <remarks>
    /// Validation Rules:
    /// <para>
    /// - Every side must be at least 64 pixels
    /// </para>
    /// <para>
    /// - Total pixel count must be between 4,096 and 9,437,184 pixels
    /// </para>
    /// <para>
    /// - The aspect ratio must be between 1:2.5 and 2.5:1
    /// </para>
    /// </remarks>
    function SubjectImage(const FilePath: string): TReplaceBackgroundAndRelight; overload;
    /// <summary>
    /// An image stream containing the subject that you wish to change the background and relight.
    /// </summary>
    /// <param name="Stream">
    /// A <c>TStream</c> containing the subject image. Supported formats include JPEG, PNG, and WEBP.
    /// </param>
    /// <param name="StreamFreed">
    /// Indicates whether the stream should be automatically freed after processing.
    /// Set to <c>True</c> if the method should take ownership and free the stream,
    /// or <c>False</c> if the caller will manage the stream's lifecycle.
    /// Default is <c>False</c>.
    /// </param>
    /// <returns>
    /// The updated <c>TReplaceBackgroundAndRelight</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// <c>Validation Rules:</c>
    /// </para>
    /// <para>
    /// - Every side of the image must be at least 64 pixels.
    /// </para>
    /// <para>
    /// - Total pixel count must be between 4,096 and 9,437,184 pixels.
    /// </para>
    /// <para>
    /// - The aspect ratio must be between 1:2.5 and 2.5:1.
    /// </para>
    /// <para>
    /// If <c>StreamFreed</c> is set to <c>True</c>, the method will automatically free the stream after processing.
    /// If set to <c>False</c>, the caller is responsible for freeing the stream to prevent memory leaks.
    /// </para>
    /// </remarks>
    function SubjectImage(const Stream: TStream; StreamFreed: Boolean = False): TReplaceBackgroundAndRelight; overload;
    /// <summary>
    /// An image whose style you wish to use in the background. Similar to the Control: Style API, stylistic elements from this image are added to the background.
    /// </summary>
    /// <param name="FilePath">
    /// Filename with supported format (jpeg, png, webp)
    /// </param>
    /// <returns>
    /// The updated <c>TStableImageUltra</c> instance.
    /// </returns>
    /// <remarks>
    /// Validation Rules:
    /// <para>
    /// - Every side must be at least 64 pixels
    /// </para>
    /// <para>
    /// - Total pixel count must be between 4,096 and 9,437,184 pixels
    /// </para>
    /// </remarks>
    function BackgroundReference(const FilePath: string): TReplaceBackgroundAndRelight; overload;
    /// <summary>
    /// An image stream whose style you wish to use in the background. Similar to the Control: Style API, stylistic elements from this image are added to the background.
    /// </summary>
    /// <param name="Stream">
    /// A <c>TStream</c> containing the background reference image. Supported formats include JPEG, PNG, and WEBP.
    /// </param>
    /// <param name="StreamFreed">
    /// Indicates whether the stream should be automatically freed after processing.
    /// Set to <c>True</c> if the method should take ownership and free the stream,
    /// or <c>False</c> if the caller will manage the stream's lifecycle.
    /// Default is <c>False</c>.
    /// </param>
    /// <returns>
    /// The updated <c>TReplaceBackgroundAndRelight</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// <c>Validation Rules:</c>
    /// </para>
    /// <para>
    /// - Every side of the image must be at least 64 pixels.
    /// </para>
    /// <para>
    /// - Total pixel count must be between 4,096 and 9,437,184 pixels.
    /// </para>
    /// </remarks>
    function BackgroundReference(const Stream: TStream; StreamFreed: Boolean = False): TReplaceBackgroundAndRelight; overload;
    /// <summary>
    /// What you wish to see in the background of the output image.
    /// </summary>
    /// <param name="Value">
    /// [1 .. 10000] characters
    /// </param>
    /// <remarks>
    /// This could be a description of the desired background scene, or just a description of the lighting if modifying the light source through light_source_direction or light_reference.
    /// <para>
    /// - IMPORTANT : either <c>background_reference</c> or <c>background_prompt</c> must be provided.
    /// </para>
    /// </remarks>
    function BackgroundPrompt(const Value: string): TReplaceBackgroundAndRelight;
    /// <summary>
    /// Description of the subject. Use this to prevent elements of the background from bleeding into the subject.
    /// </summary>
    /// <param name="Value">
    /// [1 .. 10000] characters
    /// </param>
    /// <remarks>
    ///  For example, if you find your subject is turning green with a forest in the background, try putting a short description of the subject in this field.
    /// </remarks>
    function ForegroundPrompt(const Value: string): TReplaceBackgroundAndRelight;
    /// <summary>
    /// A blurb of text describing what you do not wish to see in the output image.
    /// </summary>
    /// <param name="Value">
    /// [1 .. 10000] characters
    /// </param>
    /// <remarks>
    /// This is an advanced feature.
    /// </remarks>
    function NegativePrompt(const Value: string): TReplaceBackgroundAndRelight;
    /// <summary>
    /// How much to overlay the original subject to exactly match the original image.
    /// </summary>
    /// <param name="Value">
    /// Number: [0 .. 1] (Default 0.6)
    /// </param>
    /// <remarks>
    /// A 1.0 is an exact pixel match for the subject, and 0.0 is a close match but will have new lighting qualities. This is an advanced feature.
    /// </remarks>
    function PreserveOriginalSubject(const Value: Double): TReplaceBackgroundAndRelight;
    /// <summary>
    /// Controls the generated background to have the same depth as the original subject image.
    /// </summary>
    /// <param name="Value">
    /// Number: [0 .. 1] (Default 0.5)
    /// </param>
    /// <remarks>
    /// This is an advanced feature.
    /// </remarks>
    function OriginalBackgroundDepth(const Value: Double): TReplaceBackgroundAndRelight;
    /// <summary>
    /// Whether to keep the background of the original image.
    /// </summary>
    /// <param name="Value">
    /// Enum: false, true (Default false)
    /// </param>
    /// <remarks>
    /// When this is on, the background will have different lighting than the original image that changes based on the other parameters in this API.
    /// </remarks>
    function KeepOriginalBackground(const Value: Boolean): TReplaceBackgroundAndRelight;
    /// <summary>
    /// Direction of the light source.
    /// </summary>
    /// <param name="Value">
    /// Enum: <c>above</c>, <c>below</c>, <c>left</c>, <c>right</c>,
    /// </param>
    function LightSourceDirection(const Value: TLightSourceDirection): TReplaceBackgroundAndRelight;
    /// <summary>
    /// An image with the desired lighting. Lighter sections of the light_reference image will correspond to sections with brighter lighting in the output image.
    /// </summary>
    /// <param name="FilePath">
    /// Filename with supported format (jpeg, png, webp)
    /// </param>
    /// <returns>
    /// The updated <c>TStableImageUltra</c> instance.
    /// </returns>
    /// <remarks>
    /// Validation Rules:
    /// <para>
    /// - Every side must be at least 64 pixels
    /// </para>
    /// <para>
    /// - Total pixel count must be between 4,096 and 9,437,184 pixels
    /// </para>
    /// </remarks>
    function LightReference(const FilePath: string): TReplaceBackgroundAndRelight; overload;
    /// <summary>
    /// An image stream providing the desired lighting reference for the output image.
    /// </summary>
    /// <param name="Stream">
    /// A <c>TStream</c> containing the lighting reference image. Supported formats include JPEG, PNG, and WEBP.
    /// </param>
    /// <param name="StreamFreed">
    /// Indicates whether the stream should be automatically freed after processing.
    /// Set to <c>True</c> if the method should take ownership and free the stream,
    /// or <c>False</c> if the caller will manage the stream's lifecycle.
    /// Default is <c>False</c>.
    /// </param>
    /// <returns>
    /// The updated <c>TReplaceBackgroundAndRelight</c> instance.
    /// </returns>
    /// <remarks>
    /// <para>
    /// <c>Validation Rules:</c>
    /// </para>
    /// <para>
    /// - Every side of the image must be at least 64 pixels.
    /// </para>
    /// <para>
    /// - Total pixel count must be between 4,096 and 9,437,184 pixels.
    /// </para>
    /// <para>
    /// - The aspect ratio must be between 1:2.5 and 2.5:1.
    /// </para>
    /// <para>
    /// If <c>StreamFreed</c> is set to <c>True</c>, the method will automatically free the stream after processing.
    /// If set to <c>False</c>, the caller is responsible for freeing the stream to prevent memory leaks.
    /// </para>
    /// </remarks>
    function LightReference(const Stream: TStream; StreamFreed: Boolean = False): TReplaceBackgroundAndRelight; overload;
    /// <summary>
    /// If using <c>light_reference_image</c> or <c>light_source_direction</c>, controls the strength of the light source. 1.0 is brighter and 0.0 is dimmer. This is an advanced feature.
    /// </summary>
    /// <param name="Value">
    /// Number: [0 .. 1] (Default 0.3)
    /// </param>
    /// <remarks>
    /// IMPORTANT : Use of this parameter requires <c>light_reference</c> or <c>light_source_direction</c> to be provided.
    /// </remarks>
    function LightSourceStrength(const Value: Double): TReplaceBackgroundAndRelight;
    /// <summary>
    /// A specific value that is used to guide the 'randomness' of the generation
    /// </summary>
    /// <param name="Value">
    /// number [0 .. 4294967294]  (Default: 0)
    /// </param>
    /// <remarks>
    /// Omit this parameter or pass 0 to use a random seed.
    /// </remarks>
    function Seed(const Value: Int64): TReplaceBackgroundAndRelight;
    /// <summary>
    /// Dictates the content-type of the generated image.
    /// </summary>
    /// <param name="Value">
    /// Enum: <c>jpeg</c>, <c>png</c>, <c>webp</c>
    /// </param>
    function OutputFormat(const Value: TOutPutFormat): TReplaceBackgroundAndRelight;
    constructor Create; reintroduce;
  end;

  TEditRoute = class(TStabilityAIAPIRoute)
    /// <summary>
    /// The Erase service allows you to eliminate undesired elements, like imperfections on portraits or objects on desks, by utilizing image masking techniques.
    /// <para>
    /// The mask can be supplied in one of two forms:
    /// </para>
    /// <para>
    /// - By explicitly providing a separate image through the <c>mask</c> parameter.
    /// </para>
    /// <para>
    /// - By extracting it from the alpha channel of the <c>image</c> parameter.
    /// </para>
    /// <para>
    /// The resolution of the generated image will be 4 megapixels.
    /// </para>
    /// <para>
    /// NOTE: This method is <c>synchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the mask, the seed, the the format of the output image.
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
    /// The <c>Erase</c> method sends an image editing request to remove unwanted objects from an image, such as blemishes on portraits or items on desks, using image masks.  The returned <c>TStableImage</c> object contains the model's edited response, including multiple choices if available.
    /// <code>
    ///   var Stability := TStabilityAIFactory.CreateInstance(BaererKey);
    ///   var Data := Stability.StableImage.Edit.Erase(
    ///     procedure (Params: TErase)
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
    function Erase(ParamProc: TProc<TErase>): TStableImage; overload;
    /// <summary>
    /// The Erase service allows you to eliminate undesired elements, like imperfections on portraits or objects on desks, by utilizing image masking techniques.
    /// <para>
    /// The mask can be supplied in one of two forms:
    /// </para>
    /// <para>
    /// - By explicitly providing a separate image through the <c>mask</c> parameter.
    /// </para>
    /// <para>
    /// - By extracting it from the alpha channel of the <c>image</c> parameter.
    /// </para>
    /// <para>
    /// The resolution of the generated image will be 4 megapixels.
    /// </para>
    /// <para>
    /// NOTE: This method is <c>asynchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the mask, the seed, the the format of the output image.
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
    /// The <c>Erase</c> method sends an image editing request to remove unwanted objects from an image, such as blemishes on portraits or items on desks, using image masks.
    /// <code>
    /// // WARNING - Move the following line to the main OnCreate method for maximum scope.
    /// // var Stability := TStabilityAIFactory.CreateInstance(BaererKey);
    /// Stability.StableImage.Edit.Erase(
    ///   procedure (Params: TErase)
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
    procedure Erase(ParamProc: TProc<TErase>; CallBacks: TFunc<TAsynStableImage>); overload;
    /// <summary>
    /// Intelligently modify images by filling in or replacing specified areas with new content based on the content of a "mask" image.
    /// <para>
    /// The mask is provided in one of two ways:
    /// </para>
    /// <para>
    /// - Explicitly passing in a separate image via the mask parameter
    /// </para>
    /// <para>
    /// - Derived from the alpha channel of the image parameter.
    /// </para>
    /// <para>
    /// The resolution of the generated image will be 4 megapixels.
    /// </para>
    /// <para>
    /// NOTE: This method is <c>synchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the mask, the seed, the the format of the output image.
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
    ///   var Data := Stability.StableImage.Edit.Inpaint(
    ///     procedure (Params: TInpaint)
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
    function Inpaint(ParamProc: TProc<TInpaint>): TStableImage; overload;
    /// <summary>
    /// Intelligently modify images by filling in or replacing specified areas with new content based on the content of a "mask" image.
    /// <para>
    /// The mask is provided in one of two ways:
    /// </para>
    /// <para>
    /// - Explicitly passing in a separate image via the mask parameter
    /// </para>
    /// <para>
    /// - Derived from the alpha channel of the image parameter.
    /// </para>
    /// <para>
    /// The resolution of the generated image will be 4 megapixels.
    /// </para>
    /// <para>
    /// NOTE: This method is <c>synchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the mask, the seed, the the format of the output image.
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
    /// The <c>Erase</c> method sends an image editing request to remove unwanted objects from an image, such as blemishes on portraits or items on desks, using image masks.
    /// <code>
    /// // WARNING - Move the following line to the main OnCreate method for maximum scope.
    /// // var Stability := TStabilityAIFactory.CreateInstance(BaererKey);
    /// Stability.StableImage.Edit.Inpaint(
    ///   procedure (Params: TInpaint)
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
    procedure Inpaint(ParamProc: TProc<TInpaint>; CallBacks: TFunc<TAsynStableImage>); overload;
    /// <summary>
    /// The Outpaint service inserts additional content in an image to fill in the space in any direction.
    /// Compared to other automated or manual attempts to expand the content in an image, the Outpaint service
    /// should minimize artifacts and signs that the original image has been edited.
    /// <para>
    /// NOTE: This method is <c>synchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the the format of the output image etc.
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
    ///   var Data := Stability.StableImage.Edit.Outpaint(
    ///     procedure (Params: TOutpaint)
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
    function Outpaint(ParamProc: TProc<TOutpaint>): TStableImage; overload;
    /// <summary>
    /// The Outpaint service inserts additional content in an image to fill in the space in any direction.
    /// Compared to other automated or manual attempts to expand the content in an image, the Outpaint service
    /// should minimize artifacts and signs that the original image has been edited.
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
    /// Stability.StableImage.Edit.Outpaint(
    ///   procedure (Params: TOutpaint)
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
    procedure Outpaint(ParamProc: TProc<TOutpaint>; CallBacks: TFunc<TAsynStableImage>); overload;
    /// <summary>
    /// The Search and Replace service is a specific version of inpainting that does not require a mask.
    /// Instead, users can leverage a <c>search_prompt</c> to identify an object in simple language to be replaced.
    /// The service will automatically segment the object and replace it with the object requested in the prompt.
    /// <para>
    /// NOTE: This method is <c>synchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the the format of the output image etc.
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
    ///   var Data := Stability.StableImage.Edit.SearchAndReplace(
    ///     procedure (Params: TSearchAndReplace)
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
    function SearchAndReplace(ParamProc: TProc<TSearchAndReplace>): TStableImage; overload;
    /// <summary>
    /// The Search and Replace service is a specific version of inpainting that does not require a mask.
    /// Instead, users can leverage a <c>search_prompt</c> to identify an object in simple language to be replaced.
    /// The service will automatically segment the object and replace it with the object requested in the prompt.
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
    /// Stability.StableImage.Edit.SearchAndReplace(
    ///   procedure (Params: TSearchAndReplace)
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
    procedure SearchAndReplace(ParamProc: TProc<TSearchAndReplace>; CallBacks: TFunc<TAsynStableImage>); overload;
    /// <summary>
    /// The Search and Recolor service provides the ability to change the color of a specific object in
    /// an image using a prompt. This service is a specific version of inpainting that does not require
    /// a mask. The Search and Recolor service will automatically segment the object and recolor it
    /// using the colors requested in the prompt.
    /// <para>
    /// NOTE: This method is <c>synchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the the format of the output image etc.
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
    ///   var Data := Stability.StableImage.Edit.SearchAndRecolor(
    ///     procedure (Params: TSearchAndRecolor)
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
    function SearchAndRecolor(ParamProc: TProc<TSearchAndRecolor>): TStableImage; overload;
    /// <summary>
    /// The Search and Recolor service provides the ability to change the color of a specific object in
    /// an image using a prompt. This service is a specific version of inpainting that does not require
    /// a mask. The Search and Recolor service will automatically segment the object and recolor it
    /// using the colors requested in the prompt.
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
    /// Stability.StableImage.Edit.SearchAndRecolor(
    ///   procedure (Params: TSearchAndRecolor)
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
    procedure SearchAndRecolor(ParamProc: TProc<TSearchAndRecolor>; CallBacks: TFunc<TAsynStableImage>); overload;
    /// <summary>
    /// The Remove Background service accurately segments the foreground from an image and implements and removes the background.
    /// <para>
    /// NOTE: This method is <c>synchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, etc
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
    ///   var Data := Stability.StableImage.Edit.RemoveBackground(
    ///     procedure (Params: TRemoveBackground)
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
    function RemoveBackground(ParamProc: TProc<TRemoveBackground>): TStableImage; overload;
    /// <summary>
    /// The Remove Background service accurately segments the foreground from an image and implements and removes the background.
    /// <para>
    /// NOTE: This method is <c>asynchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, the format of the output image etc.
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
    /// Stability.StableImage.Edit.RemoveBackground(
    ///   procedure (Params: TRemoveBackground)
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
    procedure RemoveBackground(ParamProc: TProc<TRemoveBackground>; CallBacks: TFunc<TAsynStableImage>); overload;
    /// <summary>
    /// The Replace Background and Relight edit service lets users swap backgrounds with AI-generated or uploaded images while adjusting lighting to match the subject. This new API provides a streamlined image editing solution and can serve e-commerce, real estate, photography, and creative projects.
    /// <para>
    /// Some of the things you can do include:
    /// </para>
    /// <para>
    /// - Background Replacement: Remove existing background and add new ones.
    /// </para>
    /// <para>
    /// - AI Background Generation: Create new backgrounds using AI generated images based on prompts.
    /// </para>
    /// <para>
    /// - Relighting: Adjust lighting in images that are under or overexposed.
    /// </para>
    /// <para>
    /// - Flexible Inputs: Use your own background image or generate one.
    /// </para>
    /// <para>
    /// - Lighting Adjustments: Modify light reference, direction, and strength.
    /// </para>
    /// <para>
    /// NOTE: This method is <c>synchronous</c>
    /// </para>
    /// </summary>
    /// <param name="ParamProc">
    /// A procedure used to configure the parameters for the image creation, such as image, etc
    /// </param>
    /// <returns>
    /// Returns a <c>TResults</c> object that contains ID of the task.
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
    ///   var Data := Stability.StableImage.Edit.ReplaceBackgroundAndRelight(
    ///     procedure (Params: TReplaceBackgroundAndRelight)
    ///     begin
    ///       Params.OutputFormat(png);
    ///       // Move on to the other parameters.
    ///     end);
    ///   try
    ///     ShowMessage(Data.Id);
    ///     // Display the Id
    ///     // e.g. ea771536f066b7fd03d62384581982ecd8b54a932a6378d5809d43f6e5aa789a
    ///   finally
    ///     Data.Free;
    ///   end;
    /// </code>
    /// </remarks>
    function ReplaceBackgroundAndRelight(ParamProc: TProc<TReplaceBackgroundAndRelight>): TResults; overload;
    /// <summary>
    /// The Replace Background and Relight edit service lets users swap backgrounds with AI-generated or uploaded images while adjusting lighting to match the subject. This new API provides a streamlined image editing solution and can serve e-commerce, real estate, photography, and creative projects.
    /// <para>
    /// Some of the things you can do include:
    /// </para>
    /// <para>
    /// - Background Replacement: Remove existing background and add new ones.
    /// </para>
    /// <para>
    /// - AI Background Generation: Create new backgrounds using AI generated images based on prompts.
    /// </para>
    /// <para>
    /// - Relighting: Adjust lighting in images that are under or overexposed.
    /// </para>
    /// <para>
    /// - Flexible Inputs: Use your own background image or generate one.
    /// </para>
    /// <para>
    /// - Lighting Adjustments: Modify light reference, direction, and strength.
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
    /// Stability.StableImage.Edit.ReplaceBackgroundAndRelight(
    ///   procedure (Params: TReplaceBackgroundAndRelight)
    ///   begin
    ///     // Define parameters
    ///   end,
    ///
    ///   function : TAsynResults
    ///   begin
    ///     Result.Sender := My_Object;  // Instance passed to callback parameter
    ///
    ///     Result.OnStart := nil;   // If nil then; Can be omitted
    ///
    ///     Result.OnSuccess := procedure (Sender: TObject; Job: TResults)
    ///       begin
    ///         // Handle success operation
    ///         ShowMessage(Job.Id);
    ///         // Display the Id
    ///         // e.g. ea771536f066b7fd03d62384581982ecd8b54a932a6378d5809d43f6e5aa789a
    ///       end;
    ///
    ///     Result.OnError := procedure (Sender: TObject; Error: string)
    ///       begin
    ///         // Handle error message
    ///       end;
    ///   end);
    /// </code>
    /// </remarks>
    procedure ReplaceBackgroundAndRelight(ParamProc: TProc<TReplaceBackgroundAndRelight>; CallBacks: TFunc<TAsynResults>); overload;
  end;

implementation

uses
  StabilityAI.NetEncoding.Base64, StabilityAI.Consts, StabilityAI.Async.Support;

{ TEditRoute }

function TEditRoute.Erase(ParamProc: TProc<TErase>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TErase>('v2beta/stable-image/edit/erase', ParamProc);
end;

procedure TEditRoute.Erase(ParamProc: TProc<TErase>; CallBacks: TFunc<TAsynStableImage>);
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
        Result := Self.Erase(ParamProc);
      end);
  finally
    Free;
  end;
end;

function TEditRoute.Inpaint(ParamProc: TProc<TInpaint>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TInpaint>('v2beta/stable-image/edit/inpaint', ParamProc);
end;

procedure TEditRoute.Inpaint(ParamProc: TProc<TInpaint>; CallBacks: TFunc<TAsynStableImage>);
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
        Result := Self.Inpaint(ParamProc);
      end);
  finally
    Free;
  end;
end;

function TEditRoute.Outpaint(ParamProc: TProc<TOutpaint>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TOutpaint>('v2beta/stable-image/edit/outpaint', ParamProc);
end;

procedure TEditRoute.Outpaint(ParamProc: TProc<TOutpaint>; CallBacks: TFunc<TAsynStableImage>);
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
        Result := Self.Outpaint(ParamProc);
      end);
  finally
    Free;
  end;
end;

function TEditRoute.RemoveBackground(ParamProc: TProc<TRemoveBackground>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TRemoveBackground>('v2beta/stable-image/edit/remove-background', ParamProc);
end;

procedure TEditRoute.RemoveBackground(ParamProc: TProc<TRemoveBackground>; CallBacks: TFunc<TAsynStableImage>);
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
        Result := Self.RemoveBackground(ParamProc);
      end);
  finally
    Free;
  end;
end;

function TEditRoute.ReplaceBackgroundAndRelight(
  ParamProc: TProc<TReplaceBackgroundAndRelight>): TResults;
begin
  Result := API.PostForm<TResults, TReplaceBackgroundAndRelight>('v2beta/stable-image/edit/replace-background-and-relight', ParamProc);
end;

procedure TEditRoute.ReplaceBackgroundAndRelight(
  ParamProc: TProc<TReplaceBackgroundAndRelight>;
  CallBacks: TFunc<TAsynResults>);
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
        Result := Self.ReplaceBackgroundAndRelight(ParamProc);
      end);
  finally
    Free;
  end;
end;

function TEditRoute.SearchAndRecolor(ParamProc: TProc<TSearchAndRecolor>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TSearchAndRecolor>('v2beta/stable-image/edit/search-and-recolor', ParamProc);
end;

procedure TEditRoute.SearchAndRecolor(ParamProc: TProc<TSearchAndRecolor>;
  CallBacks: TFunc<TAsynStableImage>);
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
        Result := Self.SearchAndRecolor(ParamProc);
      end);
  finally
    Free;
  end;
end;

function TEditRoute.SearchAndReplace(ParamProc: TProc<TSearchAndReplace>): TStableImage;
begin
  Result := API.PostForm<TStableImage, TSearchAndReplace>('v2beta/stable-image/edit/search-and-replace', ParamProc);
end;

procedure TEditRoute.SearchAndReplace(ParamProc: TProc<TSearchAndReplace>;
  CallBacks: TFunc<TAsynStableImage>);
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
        Result := Self.SearchAndReplace(ParamProc);
      end);
  finally
    Free;
  end;
end;

{ TRemoveBackground }

constructor TRemoveBackground.Create;
begin
  inherited Create(True);
end;

{ TErase }

constructor TErase.Create;
begin
  inherited Create;
end;

function TErase.Mask(const FilePath: string): TErase;
begin
  AddBytes('mask', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TErase.Mask(const Stream: TStream; StreamFreed: Boolean): TErase;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('mask', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('mask', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

{ TInpaint }

constructor TInpaint.Create;
begin
  inherited Create(True);
end;

function TInpaint.Mask(const FilePath: string): TInpaint;
begin
  AddBytes('mask', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TInpaint.Mask(const Stream: TStream; StreamFreed: Boolean): TInpaint;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('mask', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('mask', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

function TInpaint.NegativePrompt(const Value: string): TInpaint;
begin
  AddField(Check('negative_prompt', Value), Value);
  Result := Self;
end;

{ TOutpaint }

constructor TOutpaint.Create;
begin
  inherited Create(True);
end;

function TOutpaint.Creativity(const Value: Double): TOutpaint;
begin
  AddField(CheckFloat('creativity', Value, 0, 1), Value.ToString);
  Result := Self;
end;

function TOutpaint.Down(const Value: Integer): TOutpaint;
begin
  AddField(CheckInteger('down', Value, 0 ,2000), Value.ToString);
  Result := Self;
end;

function TOutpaint.Left(const Value: Integer): TOutpaint;
begin
  AddField(CheckInteger('left', Value, 0 ,2000), Value.ToString);
  Result := Self;
end;

function TOutpaint.Prompt(const Value: string): TOutpaint;
begin
  AddField(Check('prompt', Value), Value);
  Result := Self;
end;

function TOutpaint.Right(const Value: Integer): TOutpaint;
begin
  AddField(CheckInteger('right', Value, 0 ,2000), Value.ToString);
  Result := Self;
end;

function TOutpaint.Up(const Value: Integer): TOutpaint;
begin
  AddField(CheckInteger('up', Value, 0 ,2000), Value.ToString);
  Result := Self;
end;

{ TSearchAndReplace }

constructor TSearchAndReplace.Create;
begin
  inherited Create(True);
end;

function TSearchAndReplace.NegativePrompt(
  const Value: string): TSearchAndReplace;
begin
  AddField(Check('negative_prompt', Value), Value);
  Result := Self;
end;

function TSearchAndReplace.SelectPrompt(const Value: string): TSearchAndReplace;
begin
  AddField(Check('select_prompt', Value), Value);
  Result := Self;
end;

{ TReplaceBackgroundAndRelight }

function TReplaceBackgroundAndRelight.BackgroundPrompt(
  const Value: string): TReplaceBackgroundAndRelight;
begin
  AddField(Check('background_prompt', Value), Value);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.BackgroundReference(
  const FilePath: string): TReplaceBackgroundAndRelight;
begin
  AddBytes('background_reference', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.BackgroundReference(const Stream: TStream;
  StreamFreed: Boolean): TReplaceBackgroundAndRelight;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('background_reference', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('background_reference', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

constructor TReplaceBackgroundAndRelight.Create;
begin
  inherited Create(True);
end;

function TReplaceBackgroundAndRelight.ForegroundPrompt(
  const Value: string): TReplaceBackgroundAndRelight;
begin
  AddField(Check('foreground_prompt', Value), Value);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.KeepOriginalBackground(
  const Value: Boolean): TReplaceBackgroundAndRelight;
begin
  AddField('keep_original_background', BoolToStr(Value, True).ToLower);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.LightReference(
  const FilePath: string): TReplaceBackgroundAndRelight;
begin
  AddBytes('light_reference', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.LightReference(const Stream: TStream;
  StreamFreed: Boolean): TReplaceBackgroundAndRelight;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('light_reference', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('light_reference', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

function TReplaceBackgroundAndRelight.LightSourceDirection(
  const Value: TLightSourceDirection): TReplaceBackgroundAndRelight;
begin
  AddField('light_source_direction', Value.ToString);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.LightSourceStrength(
  const Value: Double): TReplaceBackgroundAndRelight;
begin
  AddField(CheckFloat('light_source_strength', Value, 0 ,1), Value.ToString);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.NegativePrompt(
  const Value: string): TReplaceBackgroundAndRelight;
begin
  AddField(Check('negative_prompt', Value), Value);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.OriginalBackgroundDepth(
  const Value: Double): TReplaceBackgroundAndRelight;
begin
  AddField(CheckFloat('original_background_depth', Value, 0 ,1), Value.ToString);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.OutputFormat(
  const Value: TOutPutFormat): TReplaceBackgroundAndRelight;
begin
  AddField('output_format', Value.ToString);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.PreserveOriginalSubject(
  const Value: Double): TReplaceBackgroundAndRelight;
begin
  AddField(CheckFloat('preserve_original_subject', Value, 0 ,1), Value.ToString);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.Seed(
  const Value: Int64): TReplaceBackgroundAndRelight;
begin
  AddField(CheckInteger('seed', Value, 0, SeedMax), Value.ToString);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.SubjectImage(
  const FilePath: string): TReplaceBackgroundAndRelight;
begin
  AddBytes('subject_image', FileToBytes(FilePath), FilePath);
  Result := Self;
end;

function TReplaceBackgroundAndRelight.SubjectImage(const Stream: TStream;
  StreamFreed: Boolean): TReplaceBackgroundAndRelight;
begin
  if StreamFreed then
    {--- The stream's content is automatically freed. }
    AddStream('subject_image', Stream, True, 'FileNameForHeader.png')
  else
    {--- You should release the stream's content. }
    AddBytes('subject_image', StreamToBytes(Stream), 'FileNameForHeader.png');
  Result := Self;
end;

end.
