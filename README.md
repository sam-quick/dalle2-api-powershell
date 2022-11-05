# dalle2-api-powershell
Powershell script to generate images using DALLE-2 by OpenAI

---
## Installation

Before running you need to first create the ApiKey file by running the below in the same directory as *GenerateImage.ps1*

`"<YOUR API KEY>" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File ApiKey`

---
## Parameters

| Name | Description | Type | Default |  Mandatory | Example |
| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |
Prompt | The text to image prompt | string | N/A | Yes | *3D render of a cute cat, dark blue background* 
NumberOfImages | Number of images to generate. Min is 1, Max is 10 | int | 4 | No | *2*
Size | Size of images to generate, 256x256, 512x512 or 1024x1024 | string | 1024x1024 | No | *512x512*
APIKeyPath | Path to the API key file | string | .\ApiKey | No | *.\ApiKey*
OutputFolder | Folder to save generated images | string | .\Output\ | No | *.\Output*
JsonFolder | Folder to save metadata of request/response including prompt, generated image urls, cost etc. | string | .\Json\ | No | *.\Json\*
NoDownload | Don't download generated images | switch | True | No | N/A
NoJson | Don't save request/response metadata as Json file | switch | True | No | N/A
