$gitconfig        = [Environment]::GetFolderPath('UserProfile') + "\.gitconfig"
$gitignore_global = [Environment]::GetFolderPath('UserProfile') + "\.gitignore_global"
$bash_profile     = [Environment]::GetFolderPath('UserProfile') + "\.bash_profile"

# Download Git Configuration File.
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/shivapoudel/dotfiles/main/git/config/.gitconfig" -OutFile $gitconfig
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/shivapoudel/dotfiles/main/git/config/.gitignore_global" -OutFile $gitignore_global
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/shivapoudel/dotfiles/main/git/config/.bash_profile" -OutFile $bash_profile
