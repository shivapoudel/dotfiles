$UserName        = [Environment]::UserName
$faviconsPaths   = [Environment]::GetFolderPath('UserProfile') + "\OneDrive\Workspace\icons\favicons\"
$persistedPaths  = [Environment]::GetEnvironmentVariable('Path', 'User') -split ';'
$additionalPaths = @(
	[Environment]::GetFolderPath('ApplicationData') + "\Composer\vendor\bin"
	[Environment]::GetFolderPath('ApplicationData') + "\Local\lightning-services\php-8.2.23+1\bin\win64"
	[Environment]::GetFolderPath('LocalApplicationData') + "\Programs\Local\resources\extraResources\bin\rsync\win32"
	[Environment]::GetFolderPath('LocalApplicationData') + "\Programs\Local\resources\extraResources\bin\wp-cli\win32"
	[Environment]::GetFolderPath('LocalApplicationData') + "\Programs\Local\resources\extraResources\bin\composer\win32"
	[Environment]::GetFolderPath('LocalApplicationData') + "\Programs\Local\resources\extraResources\lightning-services\mysql-8.0.35+2\bin\win64\bin"
)

# Setup sites favicon.
Get-ChildItem -Path $faviconsPaths -Recurse -Include *.ico | %{
	$site = [System.IO.Path]::GetFileNameWithoutExtension($_.fullname)
	$dest = [Environment]::GetFolderPath('MyComputer') + "D:\htdocs\$site\app\public\"
	$icon = Join-Path -Path $dest -ChildPath "favicon.ico"

	if (Test-Path -Path $dest) {
		Write-Host "Added Favicon: '$site'"
		Copy-Item -Path $_.fullname -Destination $icon -Force -Container
	} else {
		Write-Host "Doesn't exist site: '$site'"
	}
}

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

# Set MySQL default port.
if (-Not [Environment]::GetEnvironmentVariable('MYSQL_DEFAULT_PORT')) {
	[Environment]::SetEnvironmentVariable('MYSQL_DEFAULT_PORT', '10004', 'User')
}

# Set NPM script-shell to bash.
npm config set script-shell "C:\\Program Files\\Git\\bin\\bash.exe"

# Define PHP config path.
$phpConfig = Join-Path -Path $additionalPaths[1] -ChildPath 'php.ini'

# Ensure php.ini file exists
if (!(Test-Path -Path $phpConfig)) {
    New-Item -ItemType File -Path $phpConfig -Force | Out-Null
    Write-Host "Created a new php.ini file at: $phpConfig"
}

# Download the php.ini file (if needed)
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/shivapoudel/dotfiles/main/local/conf/php.ini" -OutFile $phpConfig

# Read the content of the config file.
$configContent = Get-Content -Path $phpConfig -Raw

# Replace the username using regular expressions.
$updatedConfig = $configContent -replace "/shiva", "/$($UserName)"

# Write the updated content back to the file.
$updatedConfig | Set-Content -Path $phpConfig -Encoding UTF8

Write-Host "PHP Config updated: '$phpConfig'"
