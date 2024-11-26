# Delphi StabilityAI API

___
![GitHub](https://img.shields.io/badge/IDE%20Version-Delphi%2010.3/11/12-yellow)
![GitHub](https://img.shields.io/badge/platform-all%20platforms-green)
![GitHub](https://img.shields.io/badge/Updated%20the%2011/23/2024-blue)

<br/>
<br/>

- [Introduction](#Introduction)
    - [Who is Stability AI](#Who-is-Stability-AI)
    - [Remarks](#remarks)
- [Stability AI console](#Stability-AI-console)
- [Asynchronous callback mode management](#Asynchronous-callback-mode-management)
- [Generate](#Generate)
    - [Stable Image Ultra](#Stable-Image-Ultra)
        - [Text to image](#Text-to-image)
        - [Tools for simplifying this tutorial](#Tools-for-simplifying-this-tutorial)
        - [Image and text to image](#Image-and-text-to-image)
    - [Stable Image Core](#Stable-Image-Core)
        - [Image Core Create](#Image-Core-Create)
        - [Using a preset style](#Using-a-preset-style )
    - [Stable Diffusion](#Stable-Diffusion)
        - [Generating with a prompt](#Generating-with-a-prompt)
        - [Generating with a prompt and an image](#Generating-with-a-prompt-and-an-image)
        - [Optional Parameters](#Optional-Parameters)
    - [SDXL and SD version 1](#SDXL-and-SD-version-1)
        - [Text to image prompting](#Text-to-image-prompting)
        - [Image to image with prompt](#Image-to-image-with-prompt)
        - [Image to image with mask](#Image-to-image-with-mask)
- [Upscale](#Upscale)
    - [Conservative](#Conservative)
    - [Creative Upscale](#Creative-Upscale)
        - [Fetch async generation result](#Fetch-async-generation-result)
    - [Fast](#Fast)
- [Edit](#Edit)
    - [Erase](#Erase)
    - [Inpaint](#Inpaint)
    - [Outpaint](#Outpaint)
    - [Search and Replace](#Search-and-Replace)
    - [Search and Recolor](#Search-Recolor)
    - [Remove Background](#Remove-Background)
    - [Replace Background and Relight](#Replace-Background-and-Relight)
- [Control](#Control)
    - [Sketch](#Sketch)
    - [Structure](#Structure)
    - [Style](#Style)
- [Results](#Results)
- [3D](#3D)
- [Contributing](#contributing)
- [License](#license)
 
<br/>
<br/>

# Introduction

## Who is Stability AI

`Stability.ai` is a well-established organization in artificial intelligence, known for its models that generate images and text from descriptions. Below is a summary of the key models they have developed, presented in chronological order of release:

Image Generation Models:

- `Stable Diffusion` (August 2022)
The first latent diffusion model, capable of generating images based on textual descriptions.

- `Stable Diffusion 2.0` (November 2022)
An updated version with improved image quality, support for higher resolutions, and additional features.

- `Stable Diffusion XL (SDXL)` (April 2023)
Focused on photorealism, this version introduced improvements in image composition and face generation.

- `Stable Diffusion 3.0` (February 2024)
Featuring a new architecture that combines diffusion transformers and flow matching, this version enhances performance for multi-subject queries and overall image quality.

- `Stable Cascade` (February 2024)
Built on the Würstchen architecture, this model improves accuracy and efficiency in text-to-image generation.

- `Stable Diffusion 3.5` (October 2024)
Includes variants such as Stable Diffusion 3.5 Large and 3.5 Medium, offering more options for diverse generation tasks with optimized efficiency.

<br/>

## Remarks

> [!IMPORTANT]
>
> This is an unofficial library. **Stability.ai** does not provide any official library for `Delphi`.
> This repository contains `Delphi` implementation over [Stability.ai](https://platform.stability.ai/docs/api-reference/) public API.

<br/>

# Stability AI console

You can access the [Stability.ai console](https://platform.stability.ai/) to explore the available possibilities.

To obtain an API key, you need to create an account. A credit of 25 will be granted to you, and an initial key will be automatically generated. You can find this key [here](https://platform.stability.ai/account/keys).

Once you have a token, you can initialize `IStabilityAI` interface, which is an entry point to the API.

> [!NOTE]
>```Pascal
>uses StabilityAI;
>
>var Stability := TStabilityAIFactory.CreateInstance(API_KEY);
>```

>[!Warning]
> To use the examples provided in this tutorial, especially to work with asynchronous methods, I recommend defining the stability interface with the widest possible scope.
><br/>
> So, set `Stability := TStabilityAIFactory.CreateInstance(API_KEY);` in the `OnCreate` event of your application.
><br/> 
>Where `Stability: IStabilityAI;`

<br/>

# Asynchronous callback mode management

In the context of asynchronous methods, for a method that does not involve streaming, callbacks use the following generic record: `TAsynCallBack<T> = record` defined in the `StabilityAI.Async.Support.pas` unit. This record exposes the following properties:

```Pascal
   TAsynCallBack<T> = record
   ... 
       Sender: TObject;
       OnStart: TProc<TObject>;
       OnSuccess: TProc<TObject, T>;
       OnError: TProc<TObject, string>; 
```
<br/>

The name of each property is self-explanatory; if needed, refer to the internal documentation for more details.

> [!NOTE]
>In the rest of the tutorial, we will primarily use anonymous methods unless otherwise specified, as working with APIs requires it due to processing times that can sometimes be quite long.
>

<br/>

# Generate

## Stable Image Ultra

**Stable Image Ultra** use the Diffusion 3.5 model. This method is distinguished by:

- **Advanced Prompt Understanding:** Fine and precise analysis of descriptions, even complex ones.
- **Typography Mastery:** Ability to integrate readable and aesthetically pleasing text elements.
- **Complex Compositions:** Harmonious management of detailed, multi-element scenes.
- **Dynamic Lighting:** Rendering of natural, dramatic, or artistic lighting effects.
- **Vibrant Colors:** Rich palettes, dynamic nuances, and visual depth.
- **Cohesion and Structure:** Creation of balanced, well-structured images with no inconsistencies.

### Text to image

**Asynchronous Code Example**

```Pascal
//uses StabilityAI, StabilityAI.Types, StabilityAI.Common, StabilityAI.StableImage.Generate;

  Stability.StableImage.Generate.ImageUltra(
    procedure (Params: TStableImageUltra)
    begin
      Params.AspectRatio(ratio16x9);
      Params.Prompt('Lighthouse on a cliff overlooking the ocean');
      //A blurb of text describing what you do not wish to see in the output image.
      //Params.NegativePrompt('...')
      Params.OutputFormat(png);
    end,
    function : TAsynStableImage
    begin
      //Add a TImage on the form
      //Add a TMemo on the form
      Result.Sender := Image1;

      Result.OnStart :=
        procedure (Sender: TObject)
        begin
          Memo1.Lines.Text := Memo1.Text + 'The generation has started. Please wait...' + sLineBreak;
        end;

      Result.OnSuccess :=
        procedure (Sender: TObject; Image: TStableImage)
        begin
          var Stream := Image.GetStream;
          try
            Image.SaveToFile('lighthouse.png');
            //for VCL 
            Image1.Picture.LoadFromStream(Stream);
            //for FMX
            //Image1.Bitmap.LoadFromStream(Stream);
            Memo1.Lines.Text := Memo1.Text + 'Generation ended successfully' + sLineBreak;
          finally
            Stream.Free;
          end;
        end;

      Result.OnError :=
        procedure (Sender: TObject; Error: String)
        begin
          Memo1.Lines.Text := Memo1.Text + Error + sLineBreak;
        end;
    end);
```
Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Generate/paths/~1v2beta~1stable-image~1generate~1ultra/post)

<br/>

### Tools for simplifying this tutorial

To simplify the example codes provided in this tutorial, I have included two units in the source code: `VCL.Stability.Tutorial` and `FMX.Stability.Tutorial`. Depending on the option you choose to test the provided source code, you will need to instantiate either the `TVCLStabilitySender` or `TFMXStabilitySender` class in the application's `OnCreate` event, as follows:

>[!TIP]
>```Pascal
>//uses VCL.Stability.Tutorial;
>
>  StabilityResult := TVCLStabilitySender.Create(Memo1, Image1);
>```
>
>or
>
>```Pascal
>//uses FMX.Stability.Tutorial;
>
>  StabilityResult := TFMXStabilitySender.Create(Memo1, Image1);
>```
>

Make sure to add a `TMemo` and a `TImage` component to your form beforehand.

<br/>

### Image and text to image

It is also possible to provide a reference image to use as a starting point for generation. In this case, the `strength` parameter must be specified, as it determines the influence of the input image on the final output. A `strength` value of 0 will produce an image identical to the input, while a value of 1 indicates no influence from the initial image.

```Pascal
//uses StabilityAI, StabilityAI.Types, StabilityAI.Common, StabilityAI.StableImage.Generate, FMX.Stability.Tutorial;

  StabilityResult.FileName := 'lighthouse1.png';

  Stability.StableImage.Generate.ImageUltra(
    procedure (Params: TStableImageUltra)
    begin
      Params.AspectRatio(ratio16x9);
      Params.Prompt('There are many birds in the sky');
      Params.Image('lighthouse.png');
      Params.Strength(0.3);
      Params.OutputFormat(png);
    end,
    function : TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

<br/>

## Stable Image Core
**Specificity:**
- `Stable Image Core` is a text-to-image generation service designed to deliver premium quality with speed. Unlike other similar tools, it requires no expertise in "prompt engineering." Users simply describe a style, scene, or character, and the tool generates an image that aligns with their description.

<br/>

**Key Points:**
- **Premium Quality:** Produces high-quality images, perfect for creative and professional uses.
- **Ease of Use:** No need for complex prompt-writing techniques.
- **Speed:** Near-instant image generation, even for detailed descriptions.
- **Flexibility:** Handles a wide range of requests, from artistic styles to specific scenes or characters.
- **Reliability:** Delivers consistent results that align with provided descriptions without requiring adjustments.

<br/>

**Applications Inventory:**
- **Design and Creative Work:** Ideal for creating visuals for graphic design projects or illustrations.
- **Communication and Marketing:** Quickly generates eye-catching visuals for campaigns.
- **Creative Exploration:** Visualizes abstract ideas or concepts.
- **Education and Training:** Produces illustrations for courses or educational materials.
- **Rapid Prototyping:** Helps quickly design images for pitches or ongoing projects.

<br/>

### Image Core Create

**Asynchronous Code Example**

```Pascal
//uses StabilityAI, StabilityAI.Types, StabilityAI.Common, StabilityAI.StableImage.Generate, FMX.Stability.Tutorial;

  StabilityResult.FileName := 'lighthouse2.png';

  Stability.StableImage.Generate.ImageCore(
    procedure (Params: TStableImageCore)
    begin
      Params.AspectRatio(ratio16x9);
      Params.Prompt('Lighthouse on a cliff overlooking the ocean');
      Params.OutputFormat(png);
    end,
    function : TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Generate/paths/~1v2beta~1stable-image~1generate~1core/post)

<br>

### Using a preset style

You can guide the image model toward a specific style by selecting from 17 available styles.

```Pascal
//uses StabilityAI, StabilityAI.Types, StabilityAI.Common, StabilityAI.StableImage.Generate, FMX.Stability.Tutorial;

  StabilityResult.FileName := 'lighthouse3.png';

  Stability.StableImage.Generate.ImageCore(
    procedure (Params: TStableImageCore)
    begin
      Params.AspectRatio(ratio16x9);
      Params.Prompt('Lighthouse on a cliff overlooking the ocean');
      Params.StylePreset(TStylePreset.digitalArt);
      Params.OutputFormat(png);
    end,
    function : TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

<br/>

## Stable Diffusion

Inventory of available models

**Stable Diffusion 3.5**
- **SD3.5 Large:** Flagship model with 8 billion parameters, delivering exceptional image quality and precise prompt adherence. Ideal for professional use at 1-megapixel resolution.
- **SD3.5 Large Turbo:** A distilled version of **SD3.5 Large**, designed for fast image generation in just 4 steps, while maintaining high quality and excellent prompt fidelity. Perfect for projects requiring quick execution.
- **SD3.5 Medium:** Mid-tier model with 2.5 billion parameters, offering an optimal balance between prompt accuracy and image quality. Best suited for fast and efficient performance.

<br/>

**Stable Diffusion 3.0** (Fireworks AI)
- **SD3 Large:** Model with 8 billion parameters, providing professional-grade performance similar to **SD3.5 Large**.
- **SD3 Large Turbo:** Optimized version for faster execution while maintaining high-quality output.
- **SD3 Medium:** Model with 2 billion parameters, balancing quality and speed for less intensive use cases.

<br/>

**Key Points:**
- **Parameter Count:** Indicates the model’s power (8B for Large, 2–2.5B for Medium).
- **Speed:** `Turbo` versions generate images faster without sacrificing quality.
- **Applications:** Large models are perfect for detailed and professional projects, while Medium models are ideal for quick, balanced tasks.

<br/>

### Generating with a prompt

This mode creates an image based solely on a textual description. The `prompt` is the only mandatory input, but an optional `aspect_ratio` parameter is available to adjust the dimensions of the resulting image.

**Asynchronous Code Example**

```Pascal
//uses StabilityAI, StabilityAI.Types, StabilityAI.Common, StabilityAI.StableImage.Generate, FMX.Stability.Tutorial;

  StabilityResult.FileName := 'lighthouse4.png';

  Stability.StableImage.Generate.Diffusion(
    procedure (Params: TStableImageDiffusion)
    begin
      Params.AspectRatio(ratio16x9);
      Params.Prompt('Lighthouse on a cliff overlooking the ocean');
      Params.OutputFormat(png);
    end,
    function : TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Generate/paths/~1v2beta~1stable-image~1generate~1sd3/post)

<br/>

### Generating with a prompt and an image

This method generates an image based on text input while using an existing image as the initial reference. The necessary parameters include:
- `prompt`: the descriptive text that guides the image generation.
- `image`: the starting image that serves as the foundation for the output.
- `strength`: determines the degree to which the starting image influences the final result.
- `mode`: should be set to "image-to-image".

**Asynchronous Code Example**

```Pascal
//uses StabilityAI, StabilityAI.Types, StabilityAI.Common, StabilityAI.StableImage.Generate, FMX.Stability.Tutorial;

  StabilityResult.FileName := 'lighthouse5.png';

  Stability.StableImage.Generate.Diffusion(
    procedure (Params: TStableImageDiffusion)
    begin
      Params.Prompt('There are many birds in the sky');
      Params.Mode(imageToImage);
      Params.Image('lighthouse4.png');
      Params.Strength(0.6);
      Params.OutputFormat(png);
    end,
    function : TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

>[!NOTE]
> Note: maximum request size is 10MiB.
>

<br/>

### Optional Parameters

Both modes allow the use of these optional parameters:
- `model`: Specifies the model to utilize, such as **SD3 Large**, **SD3 Large Turbo**, or **SD3 Medium**.
- `output_format`: Determines the desired format of the resulting image.
- `seed`: Sets the randomness seed for the generation process.
- `negative_prompt`: Defines keywords to exclude from the generated image.
- `cfg_scale`: Adjusts the level of adherence to the prompt text during the diffusion process.

<br/>

## SDXL and SD version 1

### Text to image prompting

**Using SDXL 1.0:** Use `stable-diffusion-xl-1024-v1-0` as the `engine_id` for your request, and specify the dimensions (`height` and `width`) with one of the following combinations:
- **1024x1024** (default)
- **1152x896**
- **896x1152**
- **1216x832**
- **1344x768**
- **768x1344**
- **1536x640**
- **640x1536**

<br/>

**Using SD 1.6**: SD 1.6 is a flexible-resolution base model designed for generating images with non-standard aspect ratios. The model is optimized for a resolution of 512 x 512 pixels. To create outputs with a resolution of 1 megapixel, we recommend using SDXL 1.0, which is available at the same price.

To use this model, set `stable-diffusion-v1-6` as the `engine_id` in your request and ensure the `height` and `width` meet the following requirements:
- Each dimension must be at least 320 pixels.
- No dimension can exceed 1536 pixels.
- Dimensions must be in increments of 64.
- The default resolution is 512 x 512 pixels.

<br/>

**Asynchronous Code Example**

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, StabilityAI.StableImage.Generate, 
//  StabilityAI.Version1.SDXL1AndSD1_6, FMX.Stability.Tutorial; 

  StabilityResult.FileName := 'lighthouse6.png';

  Stability.Version1.SDXLAndSDL.TextToImage('stable-diffusion-xl-1024-v1-0',
    procedure (Params: TPayload)
    begin
      Params.TextPrompts([TPrompt.New(1, 'A lighthouse on a cliff') ]);
      Params.CfgScale(7);
      Params.Height(1216);
      Params.Width(832);
      Params.Sampler(TSamplerType.K_DPMPP_2S_ANCESTRAL);
      Params.Samples(1);
      Params.Steps(30);
    end,
    function : TAsynArtifacts
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```
Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/SDXL-1.0-and-SD1.6/operation/textToImage)

<br/>

### Image to image with prompt

**Adjusting the Degree of Transformation**
- To retain approximately 35% of the original image in the final output, you can use either of these approaches: set `init_image_mode=IMAGE_STRENGTH` with `image_strength=0.35`, or use `init_image_mode=STEP_SCHEDULE` with `step_schedule_start=0.65`. Both methods yield similar results, but the `step_schedule` mode offers additional flexibility by allowing you to specify a `step_schedule_end` value, giving more nuanced control if needed. For further details, refer to the specific parameter descriptions below.

**Asynchronous Code Example**

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, StabilityAI.StableImage.Generate, 
//  StabilityAI.Version1.SDXL1AndSD1_6, FMX.Stability.Tutorial; 

  StabilityResult.FileName := 'lighthouse7.png';

  Stability.Version1.SDXLAndSDL.ImageToImageWithPrompt('stable-diffusion-v1-6',
    procedure (Params: TPayloadPrompt)
    begin
      Params.TextPrompts([TPromptMultipart.New(1, 'A dog space commander') ]);
      Params.InitImage('lighthouse6.png');
      Params.ImageStrength(0.45);
      Params.CfgScale(7);
      Params.Sampler(TSamplerType.K_DPMPP_2S_ANCESTRAL);
      Params.Samples(3);
      Params.Steps(30);
    end,
    function : TAsynArtifacts
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

>[!TIP]
> In our code example, the value of the Samples parameter is 3, which means that three images were generated. Only the first one is displayed. The other two were saved with indexed file names as follows: lighthouse701.png and lighthouse702.png.
>

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/SDXL-1.0-and-SD1.6/operation/imageToImage)

<br/>

### Image to image with mask

Modify specific parts of an image using a mask. The mask must match the dimensions and shape of the original image. This functionality also supports images with alpha channels. 

use the métode:
```Pascal
  ImageToImageWithMask(const Model: string; ParamProc: TProc<TPayloadMask>; 
     CallBacks: TFunc<TAsynArtifacts>);
```

<br/>

# Upscale

Tools to Enhance the Size and Resolution of Your Images

**Conservative Upscaler**
- Upscale images by 20 to 40 times while preserving their original appearance, delivering outputs up to 4 megapixels. This tool works effectively even with images as small as 64x64 pixels, directly scaling them up to 4 megapixels. Choose this option when you need a straightforward 4-megapixel result.

**Creative Upscaler**
- Designed for heavily degraded images (less than 1 megapixel), this service applies a creative approach to generate high-resolution outputs with a unique touch.

**Fast Upscaler**
- This quick and efficient tool is perfect for improving the quality of compressed images, making it a great choice for social media posts and other similar uses.

 <br/>

## Conservative

Accepts images ranging in size from 64x64 pixels up to 1 megapixel and enhances their resolution to 4K. More broadly, it can upscale images by approximately 20 to 40 times while maintaining their original details. The Conservative Upscale option focuses on preserving the image's integrity with minimal modifications and is not intended for reinterpreting the image's content.

**Asynchronous Code Example**

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, FMX.Stability.Tutorial,
//  StabilityAI.StableImage.Upscale;

  StabilityResult.FileName := 'Upscalelighthouse1.png';

  Stability.StableImage.Upscale.Conservative(
    procedure (Params: TUpscaleConservative)
    begin
      Params.Image('lighthouse.png');
      Params.Prompt('The light house');
      Params.OutputFormat(png);
    end,
    function : TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Upscale/paths/~1v2beta~1stable-image~1upscale~1conservative/post)

<br/>

## Creative Upscale

Accepts images ranging from 64x64 pixels to a maximum of 1 megapixel, enhancing their resolution up to 4K. More broadly, it can upscale images by approximately 20 to 40 times while maintaining—and often improving—their quality. The Creative Upscale feature is particularly effective for heavily degraded images, but it is not suited for photos larger than 1 megapixel, as it applies significant reinterpretation (adjustable via the creativity scale).

>[!WARNING]
> This function is labeled as asynchronous by the editor, but in reality, it doesn't behave as such for a third-party application utilizing it. It operates more like a caching mechanism for a slightly delayed processing.
>

**Asynchronous Code Example**

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, FMX.Stability.Tutorial,
//  StabilityAI.StableImage.Upscale;

  Stability.StableImage.Upscale.Creative(
    procedure (Params: TUpscaleCreative)
    begin
      Params.Image('lighthouse.png');
      Params.Prompt('The gray light house');
      Params.OutputFormat(png);
    end,
    function : TAsynResults
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Upscale/paths/~1v2beta~1stable-image~1upscale~1creative/post)

We retrieve the job ID, and in the next step, we need to load the image unless the status retrieved is "in-progress." In that case, the operation should be retried.

### Fetch async generation result

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, FMX.Stability.Tutorial,
//  StabilityAI.StableImage.Results,

  // e.g. Id ---> ea771536f066b7fd03d62384581982ecd8b54a932a6378d5809d43f6e5aa789a
  StabilityResult.FileName := 'Upscalelighthouse2.png';
  
  Stability.StableImage.Results.Fetch(StabilityResult.Id,
    function : TAsynResults
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Results/paths/~1v2beta~1results~1%7Bid%7D/get)

<br/>

## Fast

The Fast Upscaler serviceincrease image resolution by 400%. Designed for speed and efficiency, it processes images in approximately one second, making it an excellent tool for improving the clarity of compressed visuals, perfect for social media posts and various other uses.

**Asynchronous Code Example**

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, FMX.Stability.Tutorial,
//  StabilityAI.StableImage.Upscale;

  StabilityResult.FileName := 'Upscalelighthouse3.png';

  Stability.StableImage.Upscale.Fast(
    procedure (Params: TUpscaleFast)
    begin
      Params.Image('lighthouse.png');
      Params.OutputFormat(png);
    end,
    function : TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Upscale/paths/~1v2beta~1stable-image~1upscale~1fast/post) 

<br/>

# Edit

**Feature Inventory**
- **Erase:** Removes unwanted elements.
- **Outpaint:** Extends the image beyond its boundaries.
- **Inpaint:** Edits or replaces specific defined areas.
- **Search and Replace:** Changes objects based on textual instructions.
- **Search and Recolor:** Adjusts the colors of specific objects.
- **Remove Background:** Segments the foreground to eliminate the background.

<br/>

## Erase

The Erase service is designed to eliminate unwanted elements from images, such as imperfections on faces or objects on surfaces, using masking techniques.

`Masks` can be supplied in one of two methods:
1. Directly, by providing a separate image through the `mask` parameter.
2. Indirectly, by extracting it from the alpha channel of the image parameter.

**Asynchronous Code Example**

>[!NOTE]
>- If no specific `mask` is supplied, a mask will automatically be generated based on the image's alpha channel. Transparent areas will be subject to inpainting, while opaque regions will remain unchanged.
>- If an image with an alpha channel is provided together with a `mask`, the `mask` will override the alpha channel.
>

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, FMX.Stability.Tutorial,
//  StabilityAI.StableImage.Edit;

  StabilityResult.FileName := 'EraseLighthouse.png';

  Stability.StableImage.Edit.Erase(
    procedure (Params: TErase)
    begin
      Params.Image('Lighthouse.png');
      Params.OutputFormat(png);
    end,
    function: TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

When a mask is provided :

>[!NOTE]
> - The input for this parameter should be a black-and-white image where the intensity of each pixel determines the strength of the inpainting effect. Darker pixels indicate minimal or no inpainting, while lighter pixels represent maximum inpainting intensity, with completely black pixels having no effect and completely white pixels applying the strongest effect.
> - If the `mask`'s dimensions differ from those of the image parameter, it will be automatically adjusted to match the image size.
>

```Pascal
  Stability.StableImage.Edit.Erase(
    procedure (Params: TErase)
    begin
      Params.Image('Lighthouse.png');
      Params.Mask('MyMask01.png');
      Params.GrowMask(6);
      Params.OutputFormat(png);
    end,
   ...
```

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Edit/paths/~1v2beta~1stable-image~1edit~1erase/post)

<br/>

## Inpaint

Modify images intelligently by adding or replacing specific sections with new content, guided by a `mask` image.

This `mask` can be supplied in two ways:
- By directly providing a separate image through the mask parameter.
- By extracting it from the alpha channel of the image parameter.

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, FMX.Stability.Tutorial,
//  StabilityAI.StableImage.Edit;

  StabilityResult.FileName := 'InpaintLighthouse.png';

  Stability.StableImage.Edit.Inpaint(
    procedure (Params: TInpaint)
    begin
      Params.Image('Lighthouse.png');
      Params.Mask('Mask01.png');
      Params.Prompt('The lighthouse is bigger');
      Params.OutputFormat(png);
    end,
    function: TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

The use of the `mask` is identical to that described with the [erase](#Erase) API.

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Edit/paths/~1v2beta~1stable-image~1edit~1inpaint/post)

<br/>

## Outpaint

The Outpaint service allows for the seamless extension of an image by adding content in any direction to fill the surrounding space. Unlike other methods, whether automated or manual, this service is designed to reduce visible artifacts and avoid noticeable indications of image editing.

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, FMX.Stability.Tutorial,
//  StabilityAI.StableImage.Edit;

  StabilityResult.FileName := 'OutpaintLighthouse.png';

  Stability.StableImage.Edit.Outpaint(
    procedure (Params: TOutpaint)
    begin
      Params.Image('Lighthouse.png');
      Params.Right(200);
      Params.Down(400);
      Params.OutputFormat(png);
    end,
    function: TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Edit/paths/~1v2beta~1stable-image~1edit~1outpaint/post)

<br/>

## Search and Replace

The Search and Replace service offers a specialized form of inpainting that eliminates the need for a mask. Instead, users can specify an object to replace by describing it in plain language using a search_prompt. The service will then automatically detect and segment the specified object, seamlessly substituting it with the one described in the prompt.

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, FMX.Stability.Tutorial,
//  StabilityAI.StableImage.Edit;

  StabilityResult.FileName := 'SearchReplaceLighthouse.png';

  Stability.StableImage.Edit.SearchAndReplace(
    procedure (Params: TSearchAndReplace)
    begin
      Params.Image('Lighthouse.png');
      Params.Prompt('Replace the lighthouse');
      Params.SearchPrompt('Lighthouse');
      Params.OutputFormat(png);
    end,
    function: TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Edit/paths/~1v2beta~1stable-image~1edit~1search-and-replace/post)

<br/>

## Search and Recolor

By utilizing the Search and Recolor service, you can change the color of a specific object in an image through a simple prompt. This specialized form of inpainting doesn't require a mask. Instead, the service automatically segments the object and applies the new colors as specified in your prompt.

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, FMX.Stability.Tutorial,
//  StabilityAI.StableImage.Edit;

  StabilityResult.FileName := 'SearchRecolorLighthouse.png';

  Stability.StableImage.Edit.SearchAndRecolor(
    procedure (Params: TSearchAndRecolor)
    begin
      Params.Image('Lighthouse.png');
      Params.Prompt('The lighthouse is pink');
      Params.SelectPrompt('Lighthouse');
      Params.OutputFormat(png);
    end,
    function: TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Edit/paths/~1v2beta~1stable-image~1edit~1search-and-recolor/post)

<br/>

## Remove Background

The Remove Background service precisely identifies and isolates the foreground in an image, allowing for the background to be either removed or replaced as needed.

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, FMX.Stability.Tutorial,
//  StabilityAI.StableImage.Edit;

  StabilityResult.FileName := 'RemoveBackgroundLighthouse.png';

  Stability.StableImage.Edit.RemoveBackground(
    procedure (Params: TRemoveBackground)
    begin
      Params.Image('Lighthouse.png');
      Params.OutputFormat(png);
    end,
    function: TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Edit/paths/~1v2beta~1stable-image~1edit~1remove-background/post)

<br/>

## Replace Background and Relight

The Replace Background and Relight editing service enables to effortlessly change backgrounds using AI-generated images or their own uploads, while seamlessly adjusting lighting to complement the subject. This API offers an efficient image editing solution tailored for various industries, including e-commerce, real estate, photography, and creative endeavors.

Key features include:
- **Background Replacement:** Effortlessly remove the current background and replace it with a new one.
- **AI-Generated Backgrounds:** Generate unique backgrounds with AI based on your chosen prompts.
- **Relighting:** Fine-tune the lighting of images to correct underexposure or overexposure.
- **Customizable Inputs:** Opt for your own uploaded background or create one using AI.
- **Lighting Controls:** Adjust the reference, direction, and intensity of lighting for a polished look.

>[!WARNING]
> This function is labeled as asynchronous by the editor, but in reality, it doesn't behave as such for a third-party application utilizing it. It operates more like a caching mechanism for a slightly delayed processing.
>

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, FMX.Stability.Tutorial,
//  StabilityAI.StableImage.Edit;

  Stability.StableImage.Edit.ReplaceBackgroundAndRelight(
    procedure (Params: TReplaceBackgroundAndRelight)
    begin
      Params.SubjectImage('Lighthouse.png');
      Params.BackgroundPrompt('cinematic lighting');
      Params.OutputFormat(png);
    end,
    function: TAsynResults
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

The API returns the ID of the ongoing task, just like the [Upscale Creative](#Creative-Upscale) API. You then need to use the [Fetch](#Fetch-async-generation-result) API, as previously mentioned.

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Edit/paths/~1v2beta~1stable-image~1edit~1replace-background-and-relight/post)

<br/>

# Control

Tools for Creating Controlled Variations of Images and Sketches
- **Sketch:** This feature transforms rough sketches into polished, refined outputs with a high level of precision. For non-sketch images, it offers advanced control over the final look by utilizing the image's contour lines and edges to guide adjustments.
- **Structure:** Designed to maintain the structural integrity of an input image, this tool is ideal for sophisticated content creation tasks, such as reconstructing scenes or rendering characters based on existing models.
- **Style:** By analyzing the stylistic elements of a reference image (control image), this service generates a new image aligned with the style of the reference, guided by the user's prompt. The result is an output that mirrors the artistic essence of the original.

## Sketch

This tool is designed for development workflows involving iterative design and brainstorming. It transforms hand-drawn sketches into polished visuals with precise adjustments. Additionally, it enables fine-tuned control over the final appearance of non-sketch images by utilizing the image's contours and edges.

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, FMX.Stability.Tutorial,
//  StabilityAI.StableImage.Control;

  StabilityResult.FileName := 'Control01.png';

  Stability.StableImage.Control.Sketch(
    procedure (Params: TSketch)
    begin
      Params.Image('lighthouse.png');
      Params.ControlStrength(0.7);
      Params.Prompt('a medieval castle on a hill');
      Params.OutputFormat(png);
    end,
    function : TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Control/paths/~1v2beta~1stable-image~1control~1sketch/post)

<br/>

## Structure

This service is designed to generate images while preserving the structure of an input image, making it particularly useful for tasks like replicating scenes or rendering characters based on predefined models.

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, FMX.Stability.Tutorial,
//  StabilityAI.StableImage.Control;

  StabilityResult.FileName := 'Control02.png';

  Stability.StableImage.Control.Structure(
    procedure (Params: TStructure)
    begin
      Params.Image('lighthouse.png');
      Params.ControlStrength(0.7);
      Params.Prompt('a well manicured shrub in an english garden');
      Params.OutputFormat(png);
    end,
    function : TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Control/paths/~1v2beta~1stable-image~1control~1structure/post)

<br/>

## Style

This tool analyzes the stylistic features of a given input image (control image) and applies them to generate a new image guided by a specified prompt. The output image retains the visual style of the control image while incorporating the requested content.

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, FMX.Stability.Tutorial,
//  StabilityAI.StableImage.Control;

  StabilityResult.FileName := 'Control03.png';

  Stability.StableImage.Control.Style(
    procedure (Params: TStyle)
    begin
      Params.Image('lighthouse.png');
      Params.Prompt('a majestic portrait of a chicken');
      Params.Fidelity(0.7);
      Params.OutputFormat(png);
    end,
    function : TAsynStableImage
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/Control/paths/~1v2beta~1stable-image~1control~1style/post)

<br/>

# Results

Tools for fetching the results of your async generations.

For using, see [Fetch async generation result](#Fetch-async-generation-result) 

<br/>

# 3D

Stable Fast 3D generates high-quality 3D assets from a single 2D input image.

```Pascal
//uses 
//  StabilityAI, StabilityAI.Types, StabilityAI.Common, FMX.Stability.Tutorial,
// StabilityAI.VideoAnd3D.Stable3D;

  StabilityResult.FileName := 'My_Result.gltf';

  Stability.VideoAnd3D.Model3D.Fast3D(
    procedure (Params: TStable3D)
    begin
      Params.Image('My_ImageTo3D.png');
      Params.ForegroundRatio(0.85);
    end,
    function : TAsynModel3D
    begin
      Result.Sender := StabilityResult;
      Result.OnStart := Start;
      Result.OnSuccess := Display;
      Result.OnError := Display;
    end);
```

Detailed settings on the [official documentation](https://platform.stability.ai/docs/api-reference#tag/3D/paths/~1v2beta~13d~1stable-fast-3d/post)

<br/>

# Contributing

Pull requests are welcome. If you're planning to make a major change, please open an issue first to discuss your proposed changes.

<br/>

# License

This project is licensed under the [MIT](https://choosealicense.com/licenses/mit/) License.