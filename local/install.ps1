$persistedPaths  = [Environment]::GetEnvironmentVariable('Path', 'User') -split ';'
$additionalPaths = @(
	[Environment]::GetFolderPath('ApplicationData') + "\Composer\vendor\bin"
	[Environment]::GetFolderPath('ApplicationData') + "\Local\lightning-services\php-8.0.0+2\bin\win64"
	[Environment]::GetFolderPath('LocalApplicationData') + "\Programs\Local\resources\extraResources\bin\wp-cli\posix"
	[Environment]::GetFolderPath('LocalApplicationData') + "\Programs\Local\resources\extraResources\bin\composer\posix"
)

# Set environment variables.
Foreach ($Path in $additionalPaths) {
	if ($persistedPaths -notcontains $Path) {
		$persistedPaths = $persistedPaths + $Path | where { $_ }
		Write-Host "Added Path: '$Path'"
		[Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', 'User')
	} else {
		Write-Host "Exist Path: '$Path'"
	}
}

# Set NPM script-shell to bash.
npm config set script-shell "C:\\Program Files\\Git\\bin\\bash.exe"

# Setup PHP configuration file.
$phpConfig = join-path -path $additionalPaths[1] -childpath 'php.ini'
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/shivapoudel/dotfiles/main/local/conf/php.ini" -OutFile $phpConfig
Write-Host "PHP Config: '$phpConfig'"
