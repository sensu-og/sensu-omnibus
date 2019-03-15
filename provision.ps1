# Use newest TLS1.2 protocol version for HTTPS connections
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

##
# Windows 8.1 SDK
##
$winSdkDir = "C:\Program Files (x86)\Windows Kits\8.1"
$winSdkExePath = "c:\tmp\sdksetup.exe"
$winSdkUrl = "http://download.microsoft.com/download/B/0/C/B0C80BA3-8AD6-4958-810B-6882485230B5/standalonesdk/sdksetup.exe"

if (-not (Test-Path $winSdkDir))
{
    # Download Windows 8.1 SDK
    $wc = New-Object net.webclient
    $wc.Downloadfile($winSdkUrl, $winSdkExePath)

    # Install Windows 8.1 SDK
    Start-Process $winSdkExePath -Wait -ArgumentList "/norestart /quiet /features OptionId.WindowsDesktopSoftwareDevelopmentKit"
    Write-Host "Windows 8.1 SDK is now installed"
}
else
{
    Write-Host "Windows 8.1 SDK is already installed"
}

$env:Path = "$($winSdkDir)\bin\x64;$env:Path"

##
# omnibus-toolchain
##
$toolchainDir = "C:\opscode\omnibus-toolchain"
$toolchainMsiPath = "c:\tmp\omnibustoolchain.msi"
$toolchainVersion = "1.1.94"
$toolchainUrl = "https://packages.chef.io/files/stable/omnibus-toolchain/$($toolchainVersion)/windows/2016/omnibus-toolchain-$($toolchainVersion)-1-x64.msi"

$env:OMNIBUS_TOOLCHAIN_INSTALL_DIR = $toolchainDir
$env:MSYSTEM = "mingw64"

if (-not (Test-Path $toolchainDir))
{
    # Download omnibus-toolchain
    $wc = New-Object net.webclient
    $wc.Downloadfile($toolchainUrl, $toolchainMsiPath)

    # Install omnibus-toolchain
    Start-Process msiexec -Wait -ArgumentList "/i $($toolchainMsiPath) /quiet"
    Write-Host "omnibus-toolchain is now installed"
}
else
{
    Write-Host "omnibus-toolchain is already installed"
}

##
# 7-zip
##
$7zipDir = "C:\Program Files\7-Zip"
$7zipMsiPath = "c:\tmp\7zip.msi"
$7zipVersion = "1900"
$7zipUrl = "https://www.7-zip.org/a/7z$($7zipVersion)-x64.msi"

if (-not (Test-Path $7zipDir))
{
    # Download 7-zip
    $wc = New-Object net.webclient
    $wc.Downloadfile($7zipUrl, $7zipMsiPath)

    # Install 7-zip
    Start-Process msiexec -Wait -ArgumentList "/i $($7zipMsiPath) /quiet"
    Write-Host "7-zip is now installed"
}
else
{
    Write-Host "7-zip is already installed"
}

$env:Path = "$7zipDir;$env:Path"

##
# WiX
##
$wixDir = "C:\wix"
$wixZipPath = "c:\tmp\wix.zip"
$wixUrl = "https://github.com/wixtoolset/wix3/releases/download/wix3111rtm/wix311-binaries.zip"

if (-not (Test-Path $wixDir))
{
    # Download wix
    $wc = New-Object net.webclient
    $wc.Downloadfile($wixUrl, $wixZipPath)

    # Install wix
    Expand-Archive $wixZipPath -DestinationPath $wixDir
    Write-Host "WiX is now installed"
}
else
{
    Write-Host "WiX is already installed"
}

$env:Path = "$wixDir;$env:Path"

##
# setup environment
##

###############################################################
# Load the base Omnibus environment
###############################################################

# mingw32 or mingw64
$mingwToolchain = "mingw64"

$embeddedDir = "$($toolchainDir)\embedded"
$embeddedBinDir = "$($embeddedDir)\bin"
$mingwBinDir = "$($embeddedBinDir)\$($mingwToolchain)\bin"
$usrBinDir = "$($embeddedBinDir)\usr\bin"
$gitCmdDir = "$($embeddedDir)\git\cmd"
$gitCoreDir = "$($embeddedDir)\git\$($mingwToolchain)\libexec\git-core"
$env:Path = "$embeddedBinDir;$mingwBinDir;$usrBinDir;$gitCmdDir;$gitCoreDir;$env:Path"

New-Item -ItemType directory -Path "$($embeddedBinDir)\tmp"

Write-Host " ========================================"
Write-Host " = Environment"
Write-Host " ========================================"

Write-Host " Path: $env:Path"

#Get-ChildItem env: | grep -v GPG_PASSPHRASE

###############################################################
# Query tool versions
###############################################################

$GIT_VERSION=git --version
$RUBY_VERSION=ruby --version
$GEM_VERSION=gem --version
$BUNDLER_VERSION=bundle --version
$GCC_VERSION=(gcc --version)[0]
$MAKE_VERSION=(make --version)[0]
$SEVENZIP_VERSION=(7z -h)[1]
$WIX_HEAT_VERSION=(heat -help)[0]
$WIX_CANDLE_VERSION=(candle -help)[0]
$WIX_LIGHT_VERSION=(light -help)[0]

Write-Host " ========================================"
Write-Host " = Tool Versions"
Write-Host " ========================================"

Write-Host " 7-Zip..........$SEVENZIP_VERSION"
Write-Host " Bundler........$BUNDLER_VERSION"
Write-Host " GCC............$GCC_VERSION"
Write-Host " Git............$GIT_VERSION"
Write-Host " Make...........$MAKE_VERSION"
Write-Host " Ruby...........$RUBY_VERSION"
Write-Host " RubyGems.......$GEM_VERSION"
Write-Host " WiX:Heat.......$WIX_HEAT_VERSION"
Write-Host " WiX:Candle.....$WIX_CANDLE_VERSION"
Write-Host " WiX:Light......$WIX_LIGHT_VERSION"

Write-Host " ========================================"

##
# Configure git
##
git config --global user.email "justin@sensu.io"
git config --global user.name "Justin Kolberg"

##
# omnibus build
##
$omnibusDir = "C:\vagrant"

$env:OMNIBUS_WINDOWS_ARCH = "x64"

$env:SENSU_VERSION = "1.7.0"
$env:BUILD_NUMBER = "2"

cd $omnibusDir
bundle install --without development vagrant ec2
bundle exec omnibus build sensu -l debug
