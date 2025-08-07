#define Version '1.0'
#define VersionExtra ''

#define AppName 'VapourSynth for VEGAS'
#define AppId 'SVPVapourSynth'
#define RegistryPath 'SOFTWARE\SVP VapourSynth'
#define SourceBinaryPath '..\msvc\x64\Release'


[Setup]
OutputDir=Compiled
OutputBaseFilename=VapourSynth for VEGAS {#= Version}{#= VersionExtra}
Compression=lzma2/max
SolidCompression=yes
VersionInfoDescription={#= AppName} {#= Version}{#= VersionExtra} Installer
AppId={#= AppId}
AppName={#= AppName} {#= Version}{#= VersionExtra}
AppVersion={#= Version}{#= VersionExtra}
AppVerName={#= AppName} {#= Version}{#= VersionExtra}
AppPublisher=TSFBCE24RhythmHeaveners
AppPublisherURL=https://github.com/TSFBCE24RhythmHeaveners/VapourSynth-for-VEGAS
AppSupportURL=https://github.com/TSFBCE24RhythmHeaveners/VapourSynth-for-VEGAS
AppUpdatesURL=https://github.com/TSFBCE24RhythmHeaveners/VapourSynth-for-VEGAS
VersionInfoVersion={#= Version}.0.0
UsePreviousAppDir=yes
DefaultDirName={autopf}\{#= AppId}
DefaultGroupName={#= AppName}
AllowCancelDuringInstall=no
AllowNoIcons=yes
AllowUNCPath=no
MinVersion=6.1
PrivilegesRequired=admin
WizardStyle=modern
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"

[Types]
Name: Full; Description: Full installation

[Files]
Source: {#= SourceBinaryPath}\VapourSynthVegasPlugin.dll; DestDir: {commoncf}\OFX\Plugins\VapourSynthVegasPlugin.ofx.bundle\Contents\Win64; DestName: VapourSynthVegasPlugin.ofx; Flags: ignoreversion uninsrestartdelete restartreplace

[Icons]
Name: {group}\VapourSynth for Resolve Website; Filename: https://github.com/TSFBCE24RhythmHeaveners/VapourSynth-for-VEGAS

[Registry]
Root: HKA; Subkey: {#= RegistryPath}; ValueType: string; ValueName: "Version"; ValueData: {#= Version}; Flags: uninsdeletevalue uninsdeletekeyifempty

[Code]

/////////////////////////////////////////////////////////////////////
function GetUninstallString: String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
  sUnInstallString := '';
  RegQueryStringValue(HKA, sUnInstPath, 'UninstallString', sUnInstallString)
  Result := sUnInstallString;
end;

/////////////////////////////////////////////////////////////////////
function IsUpgrade: Boolean;
begin
  Result := (GetUninstallString() <> '');
end;

/////////////////////////////////////////////////////////////////////
function UnInstallOldVersion: Integer;
var
  sUnInstallString: String;
  iResultCode: Integer;
begin
// Return Values:
// 1 - uninstall string is empty
// 2 - error executing the UnInstallString
// 3 - successfully executed the UnInstallString

  // default return value
  Result := 0;

  // get the uninstall string of the old app
  sUnInstallString := GetUninstallString();
  if sUnInstallString <> '' then begin
    sUnInstallString := RemoveQuotes(sUnInstallString);
    if Exec(sUnInstallString, '/SILENT /NORESTART /SUPPRESSMSGBOXES','', SW_HIDE, ewWaitUntilTerminated, iResultCode) then
      Result := 3
    else
      Result := 2;
  end
  else
    Result := 1;
end;

/////////////////////////////////////////////////////////////////////
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep=ssInstall then
  begin
    if IsUpgrade() then
      UnInstallOldVersion();
  end;
end;

