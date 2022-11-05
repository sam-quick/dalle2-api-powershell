# dalle2-api-powershell
Powershell script to generate images using DALLE-2 by OpenAI

Tested with Windows Powershell 5 and Powershell 7

---
## Installation (Windows)

You need a [OpenAI account](https://beta.openai.com/) and an API key which you can generate from ["View API Keys"](https://beta.openai.com/account/api-keys)

Before running you need to first create the ApiKey file by running the below in the same directory as *GenerateImage.ps1*

`"<YOUR API KEY>" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File ApiKey` 

The API Key is encrypted using Windows Data Protection API. This means that only the same user account on the same computer will be able to use this API key and run the *GenerateImage.ps1* script

---
## Parameters

| Name | Description | Type | Default |  Mandatory | Example |
| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |
Prompt | The text to image prompt | string | N/A | Yes | *3D render of a cute cat, dark blue background* 
NumberOfImages | Number of images to generate. Min is 1, Max is 10 | int | 4 | No | *2*
Size | Size of images to generate, 256x256, 512x512 or 1024x1024 | string | 1024x1024 | No | *512x512*
APIKeyPath | Path to the API key file | string | .\ApiKey | No | *.\ApiKey*
OutputFolder | Folder to save generated images | string | .\Output\ | No | *.\Output*
JsonFolder | Folder to save metadata of request/response including prompt, generated image urls, cost etc. | string | .\Json\ | No | *.\Json\ *
NoDownload | Don't download generated images | switch | False | No | N/A
NoJson | Don't save request/response metadata as Json file | switch | False | No | N/A

---
## Example Usage

`.\GenerateImage.ps1 -Prompt "Painting of an orange in front of a blue wall" -NumberOfImages 2 `

This will generate 2 images using the prompt *Painting of an orange in front of a blue wall* and save them to .\Output\ metadata related to the request/response will be saved to .\Json\

**Returned Output**

{
  *TODO*
}
