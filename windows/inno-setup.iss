;  SPDX-FileCopyrightText: © 2021 Alias developers
;  SPDX-License-Identifier: MIT
;
;  Alias installation script
;
;  @author HLXEasy <hlxeasy@gmail.com>>
;

; Include download plugin and translations
; (https://mitrichsoftware.wordpress.com/inno-setup-tools/inno-download-plugin/)
#pragma include __INCLUDE__ + ";" + ReadReg(HKLM, "Software\Mitrich Software\Inno Download Plugin", "InstallDir")
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
#define MyAppDataLocation "{userappdata}\Aliaswallet"
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
AppId=FBB6A488-F94A-45D8-8D13-86EDD1ADC90A
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=..\LICENSES\MIT.txt
; Non administrative install mode (install for current user only.)
PrivilegesRequired=lowest
OutputBaseFilename={#MyAppName}-Installer
Compression=lzma
SolidCompression=yes
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
Name: "{#MyAppDataLocation}"; Flags: uninsneveruninstall

[Types]
Name: installWallet; Description: "Install Alias Wallet Software"; Flags: iscustom

[Components]
Name: wallet;      Description: "Install Alias Wallet"; Types: installWallet
Name: bootstrap;   Description: "Bootstrap Blockchain Data"; Types: installWallet

[Tasks]
Name: desktopicon; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Components: wallet

[Files]
Source: "content\Alias_Only\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "content\Alias_Only\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
//if IsComponentSelected('bootstrap') then
//begin
    procedure InitializeWizard();
    var
        shellobj: variant;
        ZipFileV, TargetFldrV: variant;
        SrcFldr, DestFldr: variant;
        shellfldritems: variant;
    begin
        idpAddFile('{#BootstrapMainURL}', ExpandConstant('{#MyAppDataLocation}\{#BootstrapArchiveName}'));
            // Mirrors
            //idpAddMirror('{#BootstrapMainURL}', '{#BootstrapMirrorURL1}');
            //idpAddMirror('{#BootstrapMainURL}', '{#BootstrapMirrorURL2}');

        idpDownloadAfter(wpReady);
        if FileExists(ExpandConstant('{#MyAppDataLocation}\{#BootstrapArchiveName}')) then begin
            ForceDirectories('{#MyAppDataLocation}\');
            shellobj := CreateOleObject('Shell.Application');
            ZipFileV := ExpandConstant('{#MyAppDataLocation}\{#BootstrapArchiveName}');
            TargetFldrV := ExpandConstant('{#MyAppDataLocation}\');
            SrcFldr := shellobj.NameSpace(ZipFileV);
            DestFldr := shellobj.NameSpace(TargetFldrV);
            shellfldritems := SrcFldr.Items;
            DestFldr.CopyHere(shellfldritems, {#SHCONTCH_NOPROGRESSBOX} or {#SHCONTCH_RESPONDYESTOALL});  
        end;
    end;
//end;
