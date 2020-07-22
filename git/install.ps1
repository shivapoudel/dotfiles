$gitconfig        = [Environment]::GetFolderPath('UserProfile') + "\.gitconfig"
$gitignore_global = [Environment]::GetFolderPath('UserProfile') + "\.gitignore_global"

# Download Git Configuration File.
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/shivapoudel/dotfiles/master/git/config/.gitconfig" -OutFile $gitconfig
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/shivapoudel/dotfiles/master/git/config/.gitignore_global" -OutFile $gitignore_global
