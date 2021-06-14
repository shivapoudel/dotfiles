$path          = [Environment]::GetEnvironmentVariable('Path', 'User')
$vendor        = [Environment]::GetFolderPath('ApplicationData') + "\Composer\vendor\bin;"
$php_path      = [Environment]::GetFolderPath('ApplicationData') + "\Local\lightning-services\php-8.0.0+2\bin\win64;"
$wp_cli_path   = [Environment]::GetFolderPath('LocalApplicationData') + "\Programs\Local\resources\extraResources\bin\wp-cli\posix;"
$composer_path = [Environment]::GetFolderPath('LocalApplicationData') + "\Programs\Local\resources\extraResources\bin\composer\posix;"

# Set environment variables.
[System.Environment]::SetEnvironmentVariable('Path', $path + $vendor + $php_path + $wp_cli_path + $composer_path, 'User')

# Download PHP Configuration File.
$php_config = join-path -path $php_path.trim(';') -childpath 'php.ini'
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/shivapoudel/dotfiles/master/local/conf/php.ini" -OutFile $php_config
