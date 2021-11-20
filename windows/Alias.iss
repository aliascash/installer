;  SPDX-FileCopyrightText: © 2021 Alias developers
;  SPDX-License-Identifier: MIT
;
;  Alias installation script
;
;  @author HLXEasy <hlxeasy@gmail.com>>
;

; Include download plugin and translations
; (https://mitrichsoftware.wordpress.com/inno-setup-tools/inno-download-plugin/)
//#pragma include __INCLUDE__ + ";" + ReadReg(HKLM, "Software\Mitrich Software\Inno Download Plugin", "InstallDir")
#pragma include __INCLUDE__ + ";" + SourcePath + "\plugins\InnoDownloadPlugin"
#include <idp.iss>
#include <idplang\German.iss>
#include <idplang\Spanish.iss>
#include <idplang\Russian.iss>
#include <idplang\French.iss>
#include <idplang\Italian.iss>

; Define constants
#define MyAppName "Alias"
#define MyAppVersion "4.4.0"
#define MyAppPublisher "Alias Team"
#define MyAppURL "https://alias.cash/"
#define MyAppExeName "Alias.exe"
#define BootstrapArchiveName "BootstrapChain.zip"
//#define BootstrapMainURL "https://download.alias.cash/files/bootstrap/{#BootstrapArchiveName}"
#define BootstrapMainURL "https://github.com/aliascash/docker-aliwa-server/archive/refs/tags/1.0.zip"
#define BootstrapMirrorURL1 "https://download.alias.cash/files/bootstrap/{#BootstrapArchiveName}"
#define BootstrapMirrorURL2 "https://download.alias.cash/files/bootstrap/{#BootstrapArchiveName}"
#define SHCONTCH_NOPROGRESSBOX 4
#define SHCONTCH_RESPONDYESTOALL 16

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in
; installers for other applications. (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppCopyright=(c) 2021 {#MyAppPublisher}
AppId=FBB6A488-F94A-45D8-8D13-86EDD1ADC90A
AppName={#MyAppName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
AppVersion={#MyAppVersion}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=..\LICENSES\MIT.txt
; Non administrative install mode (install for current user only.)
PrivilegesRequired=lowest
OutputBaseFilename={#MyAppName}-Installer
Compression=lzma
SolidCompression=yes
SetupIconFile=images/alias-app.ico
WizardImageFile=images/branding.bmp
WizardSmallImageFile=images/branding.bmp
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "de"; MessagesFile: "compiler:Languages\German.isl"
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "tr"; MessagesFile: "compiler:Languages\Turkish.isl"

[Dirs]
Name: "{userappdata}\Aliaswallet"; Flags: uninsneveruninstall

[Types]
Name: installWallet; Description: "Install Alias"; Flags: iscustom

[Components]
Name: wallet;        Description: "Install Alias Wallet"; Types: installWallet
Name: bootstrap;     Description: "Bootstrap Blockchain Data"; Types: installWallet

[Tasks]
Name: desktopicon;   Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Components: wallet

[Files]
Source: "content\Alias\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "content\Alias\*";               DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
//procedure InitializeWizard();
function NextButtonClick(CurPageID: Integer): Boolean;
begin
    Result := True;
    if CurPageID = wpReady then begin
        if WizardIsComponentSelected('bootstrap') then begin
            // Data dir needs to be created manually as [Dirs] is not ready at this point
            CreateDir(ExpandConstant('{userappdata}\Aliaswallet'));
            idpAddFile('{#BootstrapMainURL}', ExpandConstant('{userappdata}\Aliaswallet\{#BootstrapArchiveName}'));
//            idpAddFile('{#BootstrapMainURL}', ExpandConstant('{tmp}\{#BootstrapArchiveName}'));
                // Mirrors
                //idpAddMirror('{#BootstrapMainURL}', '{#BootstrapMirrorURL1}');
                //idpAddMirror('{#BootstrapMainURL}', '{#BootstrapMirrorURL2}');

            idpDownloadAfter(wpReady);
        end;
    end;
end;
procedure CurStepChanged(CurStep: TSetupStep);
var
    shellobj: variant;
    ZipFileV, TargetFldrV: variant;
    SrcFldr, DestFldr: variant;
    shellfldritems: variant;
begin
    if CurStep = ssPostInstall then begin
        if WizardIsComponentSelected('bootstrap') then begin
            if FileExists(ExpandConstant('{userappdata}\Aliaswallet\{#BootstrapArchiveName}')) then begin
//            if FileExists(ExpandConstant('{tmp}\{#BootstrapArchiveName}')) then begin
                ForceDirectories('{userappdata}\Aliaswallet\');
                shellobj := CreateOleObject('Shell.Application');
                ZipFileV := ExpandConstant('{userappdata}\Aliaswallet\{#BootstrapArchiveName}');
//                ZipFileV := ExpandConstant('{tmp}\{#BootstrapArchiveName}');
                TargetFldrV := ExpandConstant('{userappdata}\Aliaswallet\');
                SrcFldr := shellobj.NameSpace(ZipFileV);
                DestFldr := shellobj.NameSpace(TargetFldrV);
                shellfldritems := SrcFldr.Items;
                DestFldr.CopyHere(shellfldritems, {#SHCONTCH_NOPROGRESSBOX} or {#SHCONTCH_RESPONDYESTOALL});  
            end;
        end;
    end;
end;
