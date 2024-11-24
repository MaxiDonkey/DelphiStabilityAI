# Delphi StabilityAI API

___
![GitHub](https://img.shields.io/badge/IDE%20Version-Delphi%2010.3/11/12-yellow)
![GitHub](https://img.shields.io/badge/platform-all%20platforms-green)
![GitHub](https://img.shields.io/badge/Updated%20the%2011/23/2024-blue)

<br/>
<br/>

- [Introduction](#Introduction)
    - [Who is Stability AI](#Who-is-Stability-AI)
    - [About this tutorial](#About-this-tutorial)
    - [Remarks](#remarks)
- [Stability AI console](#Stability-AI-console)
- [Usage](#Usage)
    - [Asynchronous callback mode management](#Asynchronous-callback-mode-management)
    - [Stable Image Ultra](#Stable-Image-Ultra)
        - [Text to image](#Text-to-image)
        - [Tools for simplifying this tutorial](#Tools-for-simplifying-this-tutorial)
        - [Image and text to image](#Image-and-text-to-image)
    - [Stable Image Core](#Stable-Image-Core)
        - [Image Core Create](#Image-Core-Create)
        - [Using a preset style](#Using-a-preset-style )
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

## About this tutorial

This project provides a Delphi wrapper for integrating `Stability.ai’s` APIs into `Delphi` applications. It simplifies access to the capabilities of their **text-to-image** and **image-to-image** models.

The documentation begins with the most recent models and their features, gradually covering earlier versions to show the progression of the technology. While features from the initial API versions remain available, they may be deprecated over time, and the latest versions are recommended for future-proof integration.

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

# Usage

## Asynchronous callback mode management

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
      Result.Sender := Image1;

      Result.OnStart :=
        procedure (Sender: TObject)
        begin
          Cursor := crHourGlass;
        end;

      Result.OnSuccess :=
        procedure (Sender: TObject; Image: TStableImage)
        begin
          var Stream := Image.GetStream;
          try
            Image.SaveToFile('lighthouse.png');
            (Sender as TImage).Picture.LoadFromStream(Stream);
          finally
            Stream.Free;
            Cursor := crDefault;
          end;
        end;

      //Add a TMemo on the form
      Result.OnError :=
        procedure (Sender: TObject; Error: String)
        begin
          Memo1.Lines.Text := Memo1.Text + Error + sLineBreak;
          Cursor := crDefault;
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

# Contributing

Pull requests are welcome. If you're planning to make a major change, please open an issue first to discuss your proposed changes.

<br/>

# License

This project is licensed under the [MIT](https://choosealicense.com/licenses/mit/) License.