# "ask if you want account to be created or amend existing."

	$Create_account = Read-Host -Prompt 'Is Account Created: Y/N'

	if ($Create_account -match "N") {




		# "Account needs to be created then run the below You will still need to add a license to it."

		# "Connect to office365 online - Enter office365 Admin details"
		connect-MSOLService

		$firstname = Read-Host -Prompt 'Input users firstname'
		$lastname = Read-Host -Prompt 'Input users last name'
		$DisplayName = "$firstname $lastname"
		$Email= Read-Host -Prompt 'Input users email'

		$usernameDifferent = Read-Host -Prompt 'Is username different from email? Y/N'

				if ($usernameDifferent -match "Y") {
				
				$Username = Read-Host -Prompt 'Input username'
						Write "Firstname is $firstname"
						Write "Lastname is $lastname"
						write "Display name is $DisplayName"
						Write "Email is $Email"
						Write "Username is $Username"
						Write ""
						Write "Here is the information you have collected"
						
						$continue = Read-Host -Prompt 'Are these details Correct? Y/N'
				
						if ($contine -match "N") {
							
							$firstname = Read-Host -Prompt 'Input users firstname'
							$lastname = Read-Host -Prompt 'Input users last name'
							$DisplayName = "$firstname $lastname"
							$Email= Read-Host -Prompt 'Input users email'
							$Username = Read-Host -Prompt 'Input username'
															
							}
								else {
							
							New-MsolUser -DisplayName $DisplayName -FirstName $firstname -LastName $lastname -UserPrincipalName $Username -AlternateEmailAddresses $Email -UsageLocation GB -forcechangepassword 0
							start-sleep -s 5
							
							$passwordExpiry? = Read-Host -Prompt 'Would you like the password to Expire? Y/N'
							
							if ($passwordExpiry -match "N") {Set-MsolUser –UserPrincipalName $Email -PasswordNeverExpires $True}
								Else {write "Password will not expire"}}
						
						Write ""
						Write ""
						Write "Now please assigned your license to your account"
						Write "Please take a note of your password as it will disappear"
						start-sleep -s 3600

					
				}
					Else {
					
						Write "Firstname is $firstname"
						Write "Lastname is $lastname"
						write "Display name is $DisplayName"
						Write "Email is $Email"
						Write ""
						Write "Here is the information you have collected"
						
						$continue = Read-Host -Prompt 'Are these details Correct? Y/N'
						
							if ($contine -match "N") {
							
							$firstname = Read-Host -Prompt 'Input users firstname'
							$lastname = Read-Host -Prompt 'Input users last name'
							$DisplayName = "$firstname $lastname"
							$Email= Read-Host -Prompt 'Input users email'								
															
							}
							else {
						
							New-MsolUser -DisplayName $DisplayName -FirstName $firstname -LastName $lastname -UserPrincipalName $Email -UsageLocation GB -forcechangepassword 0
							start-sleep -s 5
							
							
							$passwordExpiry? = Read-Host -Prompt 'Would you like the password to Expire? Y/N'
							
							if ($passwordExpiry -match "Y") {Set-MsolUser –UserPrincipalName $Email -PasswordNeverExpires $True}
								Else {write "Password will not expire"}}
						
						Write ""
						Write ""
						Write "Now please assigned your license to your account"
						Write "Please take a note of your password as it will disappear"
						start-sleep -s 3600
						}

}


Else {


		# "Account already created then run below"

		# "Connect to office365 online - Enter office365 Admin details"
			$s = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $cred -Authentication Basic –AllowRedirection
				Import-PSSession $s

		# "Create varible for email address - Enter users email address"
			$Email = Read-Host -Prompt 'Input users email'


		# "Disables OWA"

			$Disable_OWA = Read-Host -Prompt 'Do you want to Enable / Disable / Unchange OWA: E / D / U'
				if 
					($Disable_OWA -match "D") {
						Set-CasMailbox -Identity $Email -OWAEnabled $false }
						
				Elseif 
					($Disable_OWA -match "E")
						{Set-CasMailbox -Identity $Email -OWAEnabled $true}
						
				Elseif ($Disable_OWA -match "U")
					{write "Nothing changed"}

				Get-CASMailbox -Identity $Email | Format-List DisplayName, OWAEnabled
				
			# "Disables PowerShell"

			$Disable_Powershell = Read-Host -Prompt 'Do you want to Enable / Disable / Unchange Powershell: E / D / U'
				if 
					($Disable_Powershell -match "D") {
						Set-User $Email -RemotePowerShellEnabled $false }
						
				Elseif 	
					($Disable_Powershell -match "E")
						{Set-User $Email -RemotePowerShellEnabled $true}
						
				Elseif ($Disable_Powershell -match "U") {write "Nothing Changed"}
				
				Get-User -Identity $Email | Format-List RemotePowerShellEnabled

		# "Enables litigation hold if valid license"
			$Enable_Litigation = Read-Host -Prompt 'Do you want to Enable / Disable / Unchange Litigation: E / D / U'
				if 
										
					($Disable_Enable_Litigation -match "E")
					
					{
					
					##	Enable for organisation
					##	Get-Mailbox -RecipientTypeDetails UserMailbox -Filter {PersistedCapabilities -eq "BPOS_S_Enterprise" -and LitigationHoldEnabled -ne $false} | Set-Mailbox -LitigationHoldEnabled $true -LitigationHoldDuration 5475}
					
					##	Enable for User
						 Get-Mailbox -Identity $Email | Set-Mailbox -LitigationHoldEnabled $true -LitigationHoldDuration 5475
						 
					}
					
					
				Elseif
					($Disable_Enable_Litigation -match "D")
					
					{
						
						##	disable for organisation
						##	Get-Mailbox -RecipientTypeDetails UserMailbox -Filter {PersistedCapabilities -eq "BPOS_S_Enterprise" -and LitigationHoldEnabled -ne $true} | Set-Mailbox -LitigationHoldEnabled $false
						
						##disable for username
						 Get-Mailbox -Identity $Email | Set-Mailbox -LitigationHoldEnabled $false
						
					}
				
				Elseif ($Disable_Enable_Litigation -match "U") {write "Nothing Changed"}
				
				Get-Mailbox -Identity $Email | Format-List DisplayName, Lit*
				write "If LitigationHoldEnabled is False after selecting enable, please make sure valid license is assigned."
				
			Get-PSSession | Remove-PSSession			
			Write "All Done"
		cmd /c pause | out-null
}