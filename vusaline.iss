#define MyAppName "Vusaline"
#define MyAppVersion "1.0"
#define MyAppPublisher "Spookbuster"
#define MyAppURL "https://github.com/high-brow/Vusaline"

[Setup]
Compression=lzma
DefaultDirName={code:GetTF2Path}
Output=yes
OutputBaseFilename=vusaline_installer
OutputDir=.
SolidCompression=yes

AppId={{53454E44-2048-454C-5020504C45415345}}
AppName={#MyAppName}
AppPublisher={#MyAppPublisher}
AppUpdatesURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppVersion={#MyAppVersion}
CloseApplicationsFilter=*.dll,*.cfg,*.vpk
UninstallDisplayName=vusaline_uninstall
UninstallFilesDir={app}\Vusaline
SetupIconFile=dur.ico
WizardStyle=modern

[Files]
Source: "bats\*"; DestDir: "{app}\Vusaline"; Flags: ignoreversion;
Source: "cfgs\locked_overrides.cfg"; DestDir: "{app}\tf\custom\vusaline_configuration\cfg"; Flags: ignoreversion onlyifdoesntexist;
Source: "cfgs\options.cfg"; DestDir: "{app}\tf\custom\vusaline_configuration\cfg"; Flags: ignoreversion onlyifdoesntexist;
Source: "cfgs\vr_settings.cfg"; DestDir: "{app}\tf\custom\vusaline_configuration\cfg"; Flags: ignoreversion onlyifdoesntexist;
Source: "vpks\zzz_vusaline_base.vpk"; DestDir: "{app}\tf\custom"; Flags: ignoreversion;

[Run]
Filename: "{app}\Vusaline\file_operations.bat"; Flags: postinstall runhidden;

[UninstallRun]
Filename: "{app}\Vusaline\revert_file_operations.bat"; Flags: runhidden;

[Code]
var
	TF2Path: String;
	SteamPath: String;
	UsingSteamDir: Boolean;
function GetTF2Path(Default: String): String;
begin
	if not RegQueryStringValue(HKEY_CLASSES_ROOT,'Valve.Source\shell\open\command','',TF2Path) 
	then
		if RegQueryStringValue(HKEY_LOCAL_MACHINE,'SOFTWARE\WOW6432Node\Valve\Steam','InstallPath',SteamPath) or RegQueryStringValue(HKEY_LOCAL_MACHINE,'SOFTWARE\Valve\Steam','InstallPath',SteamPath) and DirExists(SteamPath)
		then begin
			TF2Path:= SteamPath;
			Insert('\steamapps\common\Team Fortress 2',TF2Path,Length(TF2Path)+1);
			UsingSteamDir:= True;
		end;
	Result:= TF2Path; 
end;

procedure CurPageChanged(CurPageID: Integer);
begin                                                                                                                                                                                                 
	if CurPageID = wpSelectDir
	then begin
		if not UsingSteamDir
		then begin
			Delete(TF2Path,1,1);
			Delete(TF2Path,Length(TF2Path)-13,14);
		end;
		WizardForm.DirEdit.Text:= TF2Path;
	end;
end;