$Smtp2goAPIKey  = "api-key-here"
$EmailList = "list.txt"
$EmailSender = "Jonathan <jonathan@company.com>"
$EmailSubject = "AC"
$EmailBody = @"
Hello,

When is the air conditioning being fixed?

Thanks
Jonathan
"@


## DON'T EDIT BELOW HERE

$recipients = (get-content $EmailList) | ForEach-Object { $_.Trim() }

foreach ($recipient in $recipients){
	$Email = [PSCustomObject]@{
	   to = @($recipient)
	   sender = $EmailSender
	   subject = $EmailSubject
	   text_body = $EmailBody
	} | ConvertTo-JSON -Compress

	$headers=@{}
	$headers.Add("accept", "application/json")
	$headers.Add("Content-Type", "application/json")
	$headers.Add("X-Smtp2go-Api-Key", $Smtp2goAPIKey)

	$response = Invoke-WebRequest -Uri 'https://api.smtp2go.com/v3/email/send' -Method POST -Headers $headers -Body $Email
	
    if (($response.content | convertfrom-json).data.succeeded -eq "1") {
        Write-Host "Email sent successfully to $recipient!"
    } else {
        Write-Host "Failed to send email to $recipient. Error: $($response.data.error)"
    
	
}
}
