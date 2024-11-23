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
- [Contributing](#contributing)
- [License](#license)
    - [Asynchronous callback mode management](#Asynchronous-callback-mode-management)
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

<br/>

# Contributing

Pull requests are welcome. If you're planning to make a major change, please open an issue first to discuss your proposed changes.

<br/>

# License

This project is licensed under the [MIT](https://choosealicense.com/licenses/mit/) License.