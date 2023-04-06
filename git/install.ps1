$UserName         = [Environment]::UserName
$gitconfig        = [Environment]::GetFolderPath('UserProfile') + "\.gitconfig"
$gitignore_global = [Environment]::GetFolderPath('UserProfile') + "\.gitignore_global"

# Download Git Configuration File.
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/shivapoudel/dotfiles/main/git/config/.gitconfig" -OutFile $gitconfig
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/shivapoudel/dotfiles/main/git/config/.gitignore_global" -OutFile $gitignore_global

# Read the content of the config file.
$configContent = Get-Content -Path $gitconfig

# Replace the username using regular expressions.
$updatedConfig = $configContent -replace "\\shiva", "\$UserName"

# Write the updated config back to the file.
$updatedConfig | Set-Content -Path $gitconfig
