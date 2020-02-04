@echo off
setlocal EnableExtensions DisableDelayedExpansion
REM LLVM 4+ MSBuild 15 Integration
REM Creation Date: 07-11-2017
REM Update Date: 28-03-2018
REM If you haven't received a copy of the LICENSe, See: Uol-NCSA License

set "VS_REGVAL=15.0"
set "LLVM_VERSION=6.0.1"

if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set VS_REGKEY=HKLM\Software\WOW6432Node\Microsoft\VisualStudio\SxS\VS7)
if not "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set VS_REGKEY=HKLM\Software\Microsoft\VisualStudio\SxS\VS7)

%SystemRoot%\System32\reg.exe query %VS_REGKEY% /v %VS_REGVAL% >nul 2>nul || (echo No vs2017 registry key present! & exit /b 1)

for /f "skip=2 tokens=2*" %%a in ('%SystemRoot%\System32\reg.exe query %VS_REGKEY% /v %VS_REGVAL% 2^>nul') do (
    if "%%a" == "REG_SZ" set "VS_DIR=%%b"  & goto install_x86
)

echo Cannot find Visual Studio 2017 directory! & exit /b 1

:install_x86
if "%VS_DIR:~-1%" == "\" set "VS_DIR=%VS_DIR:~0,-1%"
pushd "%~dp0"
set "VS_PROOT_DIR=%VS_DIR%\Common7\IDE\VC\VCTargets\Platforms"

if not exist "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017" (mkdir "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017")
if not exist "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017_xp" (mkdir "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017_xp")

call jrepl.bat "@VERSION@" "%LLVM_VERSION%" /L /F Toolset-llvm-vs2017-x86.props /O "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017\Toolset.props"
call jrepl.bat "@VERSION@" "%LLVM_VERSION%" /L /F Toolset-llvm-vs2017-x86.targets /O "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017\Toolset.targets"
call jrepl.bat "@VERSION@" "%LLVM_VERSION%" /L /F Toolset-llvm-vs2017-xp-x86.props /O "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017_xp\Toolset.props"
call jrepl.bat "@VERSION@" "%LLVM_VERSION%" /L /F Toolset-llvm-vs2017-xp-x86.targets /O "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017_xp\Toolset.targets"

if not "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto done

:install_x64
if not exist "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017" (mkdir "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017")
if not exist "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017_xp" (mkdir "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017_xp")
call jrepl.bat "@VERSION@" "%LLVM_VERSION%" /L /F Toolset-llvm-vs2017-x64.props /O "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017\Toolset.props"
call jrepl.bat "@VERSION@" "%LLVM_VERSION%" /L /F Toolset-llvm-vs2017-x64.targets /O "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017\Toolset.targets"
call jrepl.bat "@VERSION@" "%LLVM_VERSION%" /L /F Toolset-llvm-vs2017-xp-x64.props /O "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017_xp\Toolset.props"
call jrepl.bat "@VERSION@" "%LLVM_VERSION%" /L /F Toolset-llvm-vs2017-xp-x64.targets /O "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017_xp\Toolset.targets"
goto done

:done
echo Setup OK!
popd
endlocal
pause
