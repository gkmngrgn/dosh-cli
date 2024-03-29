; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "dosh-cli"
#define MyAppVersion "0.1.3"
#define MyAppPublisher "GoeDev"
#define MyAppURL "https://github.com/gkmngrgn/dosh-cli"
#define MyAppExeName "dosh.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{AE3BC64C-7499-499C-96C4-CA4ED9C83CEA}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=LICENSE.md
; Remove the following line to run in administrative install mode (install for all users.)
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputBaseFilename={#MyAppName}-windows-amd64-{#MyAppVersion}-installer
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "{#MyAppName}-windows-amd64-{#MyAppVersion}\{#MyAppExeName}"; DestDir: "{app}"
Source: "{#MyAppName}-windows-amd64-{#MyAppVersion}\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

[Registry]
Root: "HKA"; Subkey: "{code:GetEnvironmentKey}"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}"; Check: NeedsAddPathHKA(ExpandConstant('{app}'))

[Code]
function GetEnvironmentKey(Param: string): string;
begin
  if IsAdminInstallMode then
    Result := 'System\CurrentControlSet\Control\Session Manager\Environment'
  else
    Result := 'Environment';
end;
function NeedsAddPathHKA(Param: string): boolean;
var
    OrigPath: string;
begin
    if not RegQueryStringValue(HKA, GetEnvironmentKey(''), 'Path', OrigPath)
    then begin
        Result := True;
        exit;
    end;
    // look for the path with leading and trailing semicolon
    // Pos() returns 0 if not found
    Result := Pos(';' + Param + ';', ';' + OrigPath + ';') = 0;
end;
