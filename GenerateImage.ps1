Param
(
	[Parameter(Mandatory = $true, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $True, HelpMessage = 'Image Generation Prompt', Position = 0)]
	[string]$Prompt,
	[Parameter(Mandatory = $false, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $True, HelpMessage = 'Number of Images', Position = 1)]
	[ValidateRange(1,10)]
	[int]$NumberOfImages = 4,
	[Parameter(Mandatory = $false, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $True, HelpMessage = 'Size', Position = 2)]
	[ValidateSet("256x256", "512x512", "1024x1024")]
	[string]$Size = "1024x1024",	
	[Parameter(Mandatory = $false, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $True, HelpMessage = 'API Key file', Position = 3)]
	[string]$APIKeyPath = "./Apikey",
	[Parameter(Mandatory = $false, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $True, HelpMessage = 'Output Folder', Position = 4)]
	[string]$OutputFolder = "./Output/",
	[Parameter(Mandatory = $false, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $True, HelpMessage = 'Json Folder', Position = 5)]
	[string]$JsonFolder = "./Json/",
	[Parameter(Mandatory = $false, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $True, HelpMessage = 'Dont download images', Position = 6)]
	[switch]$NoDownload = $False,
	[Parameter(Mandatory = $false, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $True, HelpMessage = 'Dont download images', Position = 7)]
	[switch]$NoJson = $False
)
Begin {
    $url = "https://api.openai.com/v1/images/generations"
}
Process {
	$ApiKeySecure = Get-Content $APIKeyPath
	$ApiKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((ConvertTo-SecureString $ApiKeySecure)))
	
	$recordData = [ordered]@{
		prompt = $Prompt
		n = $NumberOfImages
		size = $Size
	}

	$costTable = @(
		@{"256x256" = 0.016},
		@{"512x512" = 0.018},
		@{"1024x1024" = 0.02}
	)

	$cost = $costTable.$size * $NumberOfImages

	$record = New-Object psobject -Property $recordData

	$body = $record | ConvertTo-Json -Depth 5

	$headers =@{
		"Authorization" = "Bearer $ApiKey"
	}

	try
	{
		Write-Verbose "POST $url"
		$response = Invoke-RestMethod $url -Method POST -Body $body -Headers $headers -ContentType "application/json;charset=UTF-8"
		$headers = $null
		$success = $true
		$timestamp = (Get-Date -f "yyyy-MM-dd HH:mm:ss:ffff")
	}
	catch {
		$success = $false
		$errorMessage = $_.Exception.Message
		if (Get-Member -InputObject $_.Exception -Name 'Response') {
			try {
				$result = $_.Exception.Response.GetResponseStream()
				$reader = New-Object System.IO.StreamReader($result)
				$reader.BaseStream.Position = 0
				$reader.DiscardBufferedData()
				$responseBody = $reader.ReadToEnd();
			} catch {
				Write-Error "An error occurred while calling REST method at: $url. Error: $errorMessage. Cannot get more information."
			}
		}
		if ($null -ne $responseBody)
		{
			Write-Error "An error occurred while calling REST method at: $url. Error: $errorMessage. Response body: $responseBody"                
		}
	}    

	$outputData = [ordered]@{
		Url = $url
		Success = $success
		ErrorMessage = $errorMessage
		Request = $record
		Response = $response
		Cost = $cost
		Timestamp = $timestamp
	}

	if (!$NoDownload)
	{
		if (!(Test-Path $OutputFolder))
		{
			New-Item $OutputFolder -ItemType Directory
		}

		$imageCounter = 1

		if ($Prompt.Length -gt 50)
		{
			$Prompt = "$($Prompt.Substring(0,50))..."
		}

		foreach ($imageUrl in $outputData.Response.Data.Url)
		{
			Invoke-WebRequest $imageUrl -OutFile "$outputFolder\$(Get-Date -f 'yyyy-MM-dd')_DALL-E_$($outputData.Response.created)_$($imageCounter)-$($NumberOfImages)_$prompt.png"
			$imageCounter++
		}
	}

	if (!$NoJson)
	{
		if (!(Test-Path $JsonFolder))
		{
			New-Item $JsonFolder -ItemType Directory
		}

		$jsonObject = New-Object PSObject -Property $outputData

		$jsonObject | ConvertTo-Json -Depth 50 | Out-File "$jsonFolder\$(Get-Date -f 'yyyy-MM-dd')_DALL-E_$($outputData.Response.created)_$($NumberOfImages).json"
	}

	return New-Object PSObject -Property $outputData
}