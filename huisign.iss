; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{BF80A0A7-3390-4569-8D41-00C28C5B7416}
AppName=�ܴ�
AppVersion=1.01
;AppVerName=�ܴ� 1.1
AppPublisher=BirdZhang
AppPublisherURL=http://www.birdzhang.xyz
AppSupportURL=http://www.birdzhang.xyz
AppUpdatesURL=http://www.birdzhang.xyz
DefaultDirName={pf}\huisignin
DisableProgramGroupPage=yes
OutputDir=C:\Users\BirdZhang\Desktop\
OutputBaseFilename=�ܴ�
Compression=lzma
SolidCompression=yes
SetupIconFile=C:\Users\BirdZhang\Desktop\testttt\huisignin.ico

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon" ; Description: "{cm:CreateDesktopIcon}" ; GroupDescription: "{cm:AdditionalIcons}" ; Flags: unchecked

[Files]
Source: "C:\Users\BirdZhang\Desktop\testttt\huisignin.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\BirdZhang\Desktop\testttt\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{commonprograms}\�ܴ�"; Filename: "{app}\huisignin.exe"
Name: "{commondesktop}\�ܴ�"; Filename: "{app}\huisignin.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\huisignin.exe"; Description: "{cm:LaunchProgram,�ܴ�}"; Flags: nowait postinstall skipifsilent

