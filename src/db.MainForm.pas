unit db.MainForm;

interface

uses
  Winapi.Windows, Winapi.IpTypes, System.SysUtils, System.Classes, System.IniFiles, System.Types, System.StrUtils, System.Math, System.UITypes, System.ImageList, System.IOUtils,
  Vcl.Graphics, Vcl.Buttons, Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus, Vcl.StdCtrls, Vcl.ToolWin, Vcl.ImgList, Data.Win.ADODB,
  db.uBaseForm, db.uCommon;

type
  TfrmPBox = class(TdbBaseForm)
    clbrPModule: TCoolBar;
    tlbPModule: TToolBar;
    pmFuncMenu: TPopupMenu;
    mniFuncMenuConfig: TMenuItem;
    mniFuncMenuMoney: TMenuItem;
    mniFuncMenuLine01: TMenuItem;
    mniFuncMenuAbout: TMenuItem;
    ilMainMenu: TImageList;
    mmMainMenu: TMainMenu;
    pnlBottom: TPanel;
    bvlModule02: TBevel;
    pnlTime: TPanel;
    lblTime: TLabel;
    pnlIP: TPanel;
    lblIP: TLabel;
    bvlIP: TBevel;
    pnlWeb: TPanel;
    lblWeb: TLabel;
    bvlWeb: TBevel;
    pnlLogin: TPanel;
    lblLogin: TLabel;
    tmrDateTime: TTimer;
    pmAdapterList: TPopupMenu;
    ilPModule: TImageList;
    pgcAll: TPageControl;
    tsButton: TTabSheet;
    tsList: TTabSheet;
    tsDll: TTabSheet;
    pnlModuleDialog: TPanel;
    pnlModuleDialogTitle: TPanel;
    imgSubModuleClose: TImage;
    pmTray: TPopupMenu;
    mniTrayShowForm: TMenuItem;
    mniTrayLine01: TMenuItem;
    mniTrayExit: TMenuItem;
    imgDllFormBack: TImage;
    imgListBack: TImage;
    imgButtonBack: TImage;
    procedure FormCreate(Sender: TObject);
    procedure mniFuncMenuConfigClick(Sender: TObject);
    procedure mniFuncMenuMoneyClick(Sender: TObject);
    procedure mniFuncMenuAboutClick(Sender: TObject);
    procedure tmrDateTimeTimer(Sender: TObject);
    procedure lblTimeClick(Sender: TObject);
    procedure lblIPClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure imgSubModuleCloseClick(Sender: TObject);
    procedure imgSubModuleCloseMouseEnter(Sender: TObject);
    procedure imgSubModuleCloseMouseLeave(Sender: TObject);
    procedure mniTrayShowFormClick(Sender: TObject);
    procedure mniTrayExitClick(Sender: TObject);
  private
    FListDll  : THashedStringList;
    FintBakRow: Integer;
    { ����Ĭ�Ͻ��� }
    procedure ReadConfigUI;
    { �������е� DLL �� EXE ���б� }
    procedure LoadAllPlugins(var lstDll: THashedStringList);
    { ����ģ�鹦�ܲ˵� }
    procedure CreateMenu(listDll: THashedStringList);
    { ������ʾ���� }
    procedure CreateDisplayUI;
    procedure CreateDisplayUI_Menu;   // �˵�ģʽ
    procedure CreateDisplayUI_Button; // ��ťģʽ
    procedure CreateDisplayUI_List;   // �б�ģʽ
    { �������� }
    procedure ReCreate;
    { ϵͳ�������� }
    procedure OnSysConfig(Sender: TObject);
    { ���� DLL / EXE ���� }
    procedure FreeAllDllForm(const bExit: Boolean = False);
    procedure OnMenuItemClick(Sender: TObject);
    procedure OnAdapterDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure OnAdapterIPClick(Sender: TObject);
    procedure FreeModuleMenu;
    procedure OnParentModuleButtonClick(Sender: TObject);
    { �����ָ�Ĭ��ֵ }
    procedure FillDefaultValue;
    { ������ʾ������ģ��Ի����� }
    procedure CreateSubModulesFormDialog(const strPModuleName: string); overload;
    procedure CreateSubModulesFormDialog(const mmItem: TMenuItem); overload;
    { �б���ʾ��񣬴�����ģ�� DLL ���� }
    procedure OnSubModuleButtonClick(Sender: TObject);
    { ���ٷ���ʽ���� }
    procedure FreeListViewSubModule;
    { ��ȡ��ֱλ������� }
    function GetMaxInstance: Integer;
    { ����ʽ��ʾʱ���������� label ʱ }
    procedure OnSubModuleMouseEnter(Sender: TObject);
    { ����ʽ��ʾʱ��������뿪 label ʱ }
    procedure OnSubModuleMouseLeave(Sender: TObject);
    { ������ģ�� DLL ģ�� }
    procedure OnSubModuleListClick(Sender: TObject);
    procedure CreateDllForm(const intMenuItemIndex: Integer);
    procedure CreateDllForm_Delphi(const strDllFileName: String);
    procedure CreateDllForm_VCDLL(const strDllFileName: String);
    procedure CreateDllForm_imgEXE(const strDllFileName: String);
    { Delphi DLL �������� }
    procedure OnDelphiDllFormClose(Sender: TObject; var Action: TCloseAction);
    { Image EXE �������� }
    procedure OnEXEFormClose(Sender: TObject);
    { DLL/EXE ��������֮�󣬻ָ����� }
    procedure DllFormCloseRestoreUI;
    { VC DLG DLL Form �������� }
    procedure OnVCDLGDllFormClose(Sender: TObject);
  end;

var
  frmPBox: TfrmPBox;

implementation

{$R *.dfm}

uses db.uCreateDelphiDllForm, db.uCreateEXEForm, db.uCreateVCDllForm, db.ConfigForm, db.DonateForm, db.AboutForm;

{ ������ʾ���� --- �˵�ģʽ }
procedure TfrmPBox.CreateDisplayUI_Menu;
begin
  tlbPModule.Menu      := mmMainMenu;
  mmMainMenu.AutoMerge := True;
  tlbPModule.Height    := 24;
  clbrPModule.Visible  := True;
end;

{ ������ʾ���� --- ��ťģʽ }
procedure TfrmPBox.CreateDisplayUI_Button;
var
  tmpTB          : TToolButton;
  I              : Integer;
  strIconFilePath: String;
  strIconFileName: String;
  icoPModule     : TIcon;
begin
  tlbPModule.Images := ilPModule;
  tlbPModule.Height := 58;

  { ��ȡ���и�ģ��ͼ�� }
  for I := 0 to mmMainMenu.Items.Count - 1 do
  begin
    with TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')) do
    begin
      strIconFilePath := mmMainMenu.Items.Items[I].Caption + '_ICON';
      strIconFileName := ExtractFilePath(ParamStr(0)) + 'plugins\icon\' + ReadString(c_strIniModuleSection, strIconFilePath, '');
      Free;
    end;

    if FileExists(strIconFileName) then
    begin
      icoPModule := TIcon.Create;
      try
        icoPModule.LoadFromFile(strIconFileName);
        ilPModule.AddIcon(icoPModule);
      finally
        icoPModule.Free;
      end;
    end;
  end;

  for I := mmMainMenu.Items.Count - 1 downto 0 do
  begin
    tmpTB            := TToolButton.Create(tlbPModule);
    tmpTB.Parent     := tlbPModule;
    tmpTB.Caption    := mmMainMenu.Items.Items[I].Caption;
    tmpTB.ImageIndex := I;
    tmpTB.OnClick    := OnParentModuleButtonClick;
  end;
  clbrPModule.Visible    := True;
  pgcAll.ActivePageIndex := 0;
  pnlModuleDialog.Left   := (pnlModuleDialog.Parent.Width - pnlModuleDialog.Width) div 2;
  pnlModuleDialog.Top    := (pnlModuleDialog.Parent.Height - pnlModuleDialog.Height) div 2
end;

{ ���ٷ���ʽ���� }
procedure TfrmPBox.FreeListViewSubModule;
var
  I: Integer;
begin
  if not Assigned(tsList) then
    Exit;

  for I := tsList.ComponentCount - 1 downto 0 do
  begin
    if tsList.Components[I] is TLabel then
    begin
      TLabel(tsList.Components[I]).Free;
    end
    else if tsList.Components[I] is TImage then
    begin
      if TImage(tsList.Components[I]).Name = '' then
      begin
        TImage(tsList.Components[I]).Free;
      end;
    end;
  end;
end;

{ ��ȡ��ֱλ������� }
function TfrmPBox.GetMaxInstance: Integer;
var
  intMax               : Integer;
  arrInt               : array of Integer;
  I                    : Integer;
  intLabelPModuleHeight: Integer;
  intLabelSModuleHeight: Integer;
begin
  { ȡ����е�ģ����� }
  SetLength(arrInt, mmMainMenu.Items.Count);
  for I := 0 to mmMainMenu.Items.Count - 1 do
  begin
    arrInt[I] := mmMainMenu.Items.Items[I].Count;
  end;
  intMax := MaxIntValue(arrInt);

  intLabelPModuleHeight := GetLabelHeight('����', 17);
  intLabelSModuleHeight := GetLabelHeight('����', 12);

  Result := (intLabelSModuleHeight + c_intBetweenVerticalDistance * 2) * (Ifthen(intMax mod 3 = 0, 0, 1) + intMax div 3) + intLabelPModuleHeight;
end;

{ ������ʾ���� --- �б�ģʽ }
procedure TfrmPBox.CreateDisplayUI_List;
var
  I                     : Integer;
  arrParentModuleLabel  : array of TLabel;
  arrParentModuleImage  : array of TImage;
  arrSubModuleLabel     : array of array of TLabel;
  intRow                : Integer;
  strPModuleIconFileName: string;
  strPModuleIconFilePath: string;
  J                     : Integer;
begin
  intRow := Ifthen(WindowState = wsMaximized, 5, 3);
  if FintBakRow = intRow then
    Exit;

  { ���ٷ���ʽ���� }
  FreeListViewSubModule;
  FintBakRow := intRow;

  clbrPModule.Visible := False;
  pgcAll.ActivePage   := tsList;
  SetLength(arrParentModuleLabel, mmMainMenu.Items.Count);
  SetLength(arrParentModuleImage, mmMainMenu.Items.Count);
  SetLength(arrSubModuleLabel, mmMainMenu.Items.Count);
  for I := 0 to mmMainMenu.Items.Count - 1 do
  begin
    SetLength(arrSubModuleLabel[I], mmMainMenu.Items[I].Count);
  end;

  for I := 0 to mmMainMenu.Items.Count - 1 do
  begin
    { ������ģ���ı� }
    arrParentModuleLabel[I]            := TLabel.Create(tsList);
    arrParentModuleLabel[I].Parent     := tsList;
    arrParentModuleLabel[I].Caption    := mmMainMenu.Items[I].Caption;
    arrParentModuleLabel[I].Font.Name  := '����';
    arrParentModuleLabel[I].Font.Size  := 17;
    arrParentModuleLabel[I].Font.Style := [fsBold];
    arrParentModuleLabel[I].Font.Color := RGB(0, 174, 29);
    arrParentModuleLabel[I].Left       := 40 + 400 * (I mod intRow);
    arrParentModuleLabel[I].Top        := GetMaxInstance * (I div intRow);

    { ������ģ��ͼ�� }
    arrParentModuleImage[I]         := TImage.Create(tsList);
    arrParentModuleImage[I].Parent  := tsList;
    arrParentModuleImage[I].Height  := 32;
    arrParentModuleImage[I].Width   := 32;
    arrParentModuleImage[I].Stretch := True;
    arrParentModuleImage[I].Left    := arrParentModuleLabel[I].Left - 40;
    arrParentModuleImage[I].Top     := arrParentModuleLabel[I].Top - 2;
    with TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')) do
    begin
      strPModuleIconFilePath := ReadString(c_strIniModuleSection, arrParentModuleLabel[I].Caption + '_ICON', '');
      strPModuleIconFileName := ExtractFilePath(ParamStr(0)) + 'plugins\icon\' + strPModuleIconFilePath;
      if FileExists(strPModuleIconFileName) then
        arrParentModuleImage[I].Picture.LoadFromFile(strPModuleIconFileName);
      Free;
    end;

    { ������ģ���ı� }
    for J := 0 to Length(arrSubModuleLabel[I]) - 1 do
    begin
      arrSubModuleLabel[I, J]            := TLabel.Create(tsList);
      arrSubModuleLabel[I, J].Parent     := tsList;
      arrSubModuleLabel[I, J].Caption    := mmMainMenu.Items[I].Items[J].Caption;
      arrSubModuleLabel[I, J].Font.Name  := '����';
      arrSubModuleLabel[I, J].Font.Size  := 12;
      arrSubModuleLabel[I, J].Font.Style := [fsBold];
      arrSubModuleLabel[I, J].Font.Color := RGB(51, 153, 255);
      arrSubModuleLabel[I, J].Cursor     := crHandPoint;
      if J mod 3 = 0 then
        arrSubModuleLabel[I, J].Left := arrParentModuleLabel[I].Left + 2
      else
        arrSubModuleLabel[I, J].Left       := arrSubModuleLabel[I, J - 1].Left + arrSubModuleLabel[I, J - 1].Width + 10;
      arrSubModuleLabel[I, J].Top          := arrParentModuleLabel[I].Top + GetLabelHeight('����', 17) + c_intBetweenVerticalDistance + (GetLabelHeight('����', 12) + c_intBetweenVerticalDistance) * (J div 3);
      arrSubModuleLabel[I, J].Tag          := mmMainMenu.Items[I].Items[J].Tag;
      arrSubModuleLabel[I, J].OnMouseEnter := OnSubModuleMouseEnter;
      arrSubModuleLabel[I, J].OnMouseLeave := OnSubModuleMouseLeave;
      arrSubModuleLabel[I, J].OnClick      := OnSubModuleListClick;
    end;
  end;
end;

{ ������ʾ���� }
procedure TfrmPBox.CreateDisplayUI;
var
  intShowStyle: Integer;
begin
  intShowStyle := GetShowStyle;
  case intShowStyle of
    0:
      CreateDisplayUI_Menu;
    1:
      CreateDisplayUI_Button;
    2:
      CreateDisplayUI_List;
  end;
end;

{ ����ģ�鹦�ܲ˵� }
procedure TfrmPBox.CreateMenu(listDll: THashedStringList);
var
  I             : Integer;
  strInfo       : String;
  strPModuleName: String;
  strSModuleName: String;
  mmPM          : TMenuItem;
  mmSM          : TMenuItem;
  intIconIndex  : Integer;
begin
  for I := 0 to listDll.Count - 1 do
  begin
    strInfo        := listDll.ValueFromIndex[I];
    strPModuleName := strInfo.Split([';'])[0];
    strSModuleName := strInfo.Split([';'])[1];
    intIconIndex   := StrToInt(strInfo.Split([';'])[4]);

    { ������˵������ڣ��������˵� }
    mmPM := mmMainMenu.Items.Find(string(strPModuleName));
    if mmPM = nil then
    begin
      mmPM         := TMenuItem.Create(mmMainMenu);
      mmPM.Caption := string((strPModuleName));
      mmMainMenu.Items.Add(mmPM);
    end;

    { �����Ӳ˵� }
    mmSM            := TMenuItem.Create(mmPM);
    mmSM.Caption    := string((strSModuleName));
    mmSM.Tag        := I;
    mmSM.ImageIndex := intIconIndex;
    mmSM.OnClick    := OnMenuItemClick;
    mmPM.Add(mmSM);
  end;
end;

{ �������е� DLL �� EXE ���б� }
procedure TfrmPBox.LoadAllPlugins(var lstDll: THashedStringList);
begin
  { ɨ�� DLL �ļ�����ȡ Plugins Ŀ¼ }
  LoadAllPlugins_Dll(lstDll, ilMainMenu);

  { ɨ�� EXE �ļ�����ȡ ���� �ļ� }
  LoadAllPlugins_EXE(lstDll, ilMainMenu);

  { ����ģ�� }
  SortModuleList(lstDll);
end;

procedure TfrmPBox.mniFuncMenuAboutClick(Sender: TObject);
begin
  ShowAboutForm;
end;

procedure TfrmPBox.mniFuncMenuConfigClick(Sender: TObject);
begin
  if ShowConfigForm(FListDll) then
  begin
    FreeAllDllForm;
    ReCreate;
  end;
end;

procedure TfrmPBox.mniFuncMenuMoneyClick(Sender: TObject);
begin
  ShowDonateForm;
end;

procedure TfrmPBox.mniTrayExitClick(Sender: TObject);
begin
  CloseToTray := False;
  Close;
end;

procedure TfrmPBox.mniTrayShowFormClick(Sender: TObject);
begin
  MainTrayIcon.OnDblClick(nil);
end;

{ ϵͳ�������� }
procedure TfrmPBox.OnSysConfig(Sender: TObject);
var
  img: TImage;
  pt : TPoint;
begin
  img  := TImage(Sender);
  pt.X := Left + img.Left + 8;
  pt.Y := Top + img.Top + img.Height;
  pmFuncMenu.Popup(pt.X, pt.Y);
end;

{ �����ָ�Ĭ��ֵ }
procedure TfrmPBox.FillDefaultValue;
var
  I: Integer;
begin
  FListDll.Clear;
  ilMainMenu.Clear;
  ilPModule.Clear;
  FintBakRow              := 0;
  clbrPModule.Visible     := False;
  pnlModuleDialog.Visible := False;
  FreeModuleMenu;
  FreeListViewSubModule;

  for I := tlbPModule.ButtonCount - 1 downto 0 do
  begin
    tlbPModule.Buttons[I].Free;
  end;
  tlbPModule.Images := nil;
  tlbPModule.Height := 30;
  tlbPModule.Menu   := nil;
end;

{ ����Ĭ�Ͻ��� }
procedure TfrmPBox.ReadConfigUI;
var
  bShowImage  : Boolean;
  strImageBack: String;
begin
  TitleString := GetTitleText;
  with TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')) do
  begin
    TitleString    := ReadString(c_strIniUISection, 'Title', c_strTitle);
    MulScreenPos   := ReadBool(c_strIniUISection, 'MulScreen', False);
    FormStyle      := TFormStyle(Integer(ReadBool(c_strIniUISection, 'OnTop', False)) * 3);
    CloseToTray    := ReadBool(c_strIniUISection, 'CloseMini', False);
    pnlWeb.Visible := ReadBool(c_strIniUISection, 'ShowWebSpeed', False);
    bShowImage     := ReadBool(c_strIniUISection, 'showbackimage', False);
    strImageBack   := ReadString(c_strIniUISection, 'filebackimage', '');
    if (bShowImage) and (Trim(strImageBack) <> '') and (FileExists(strImageBack)) then
    begin
      imgDllFormBack.Picture.LoadFromFile(strImageBack);
      imgButtonBack.Picture.LoadFromFile(strImageBack);
      imgListBack.Picture.LoadFromFile(strImageBack);
    end
    else
    begin
      imgDllFormBack.Picture.Assign(nil);
      imgButtonBack.Picture.Assign(nil);
      imgListBack.Picture.Assign(nil);
    end;
    Free;
  end;
end;

{ �������� }
procedure TfrmPBox.ReCreate;
begin
  { �����ָ�Ĭ��ֵ }
  FillDefaultValue;

  { ����Ĭ�Ͻ��� }
  ReadConfigUI;

  { �������е� DLL �� EXE ���б� }
  LoadAllPlugins(FListDll);

  { ����ģ�鹦�ܲ˵� }
  CreateMenu(FListDll);

  { ������ʾ���� }
  CreateDisplayUI;
end;

procedure TfrmPBox.tmrDateTimeTimer(Sender: TObject);
const
  WeekDay: array [1 .. 7] of String = ('������', '����һ', '���ڶ�', '������', '������', '������', '������');
var
  strWebDownSpeed, strWebUpSpeed: String;
begin
  lblTime.Caption := DateTimeToStr(Now) + ' ' + WeekDay[DayOfWeek(Now)];
  GetWebSpeed(strWebDownSpeed, strWebUpSpeed);
  lblWeb.Caption := Format('���ء���%s  �ϴ�����%s', [strWebDownSpeed, strWebUpSpeed]);
end;

procedure TfrmPBox.imgSubModuleCloseClick(Sender: TObject);
var
  I: Integer;
begin
  pnlModuleDialog.Visible := False;
  for I                   := 0 to tlbPModule.ButtonCount - 1 do
  begin
    tlbPModule.Buttons[I].Down := False;
  end;
end;

procedure TfrmPBox.imgSubModuleCloseMouseEnter(Sender: TObject);
begin
  { �б���ʾ��񣬹رհ�ť״̬ }
  LoadButtonBmp(imgSubModuleClose, 'Close', 1);
end;

procedure TfrmPBox.imgSubModuleCloseMouseLeave(Sender: TObject);
begin
  { �б���ʾ��񣬹رհ�ť״̬ }
  LoadButtonBmp(imgSubModuleClose, 'Close', 0);
end;

procedure TfrmPBox.FreeModuleMenu;
var
  I, J: Integer;
begin
  mmMainMenu.AutoMerge := False;
  for I                := mmMainMenu.Items.Count - 1 downto 0 do
  begin
    for J := mmMainMenu.Items.Items[I].Count - 1 downto 0 do
    begin
      mmMainMenu.Items.Items[I].Items[J].Free;
    end;
    mmMainMenu.Items.Items[I].Free;
  end;
  mmMainMenu.Items.Clear;
  mmMainMenu.AutoMerge := False;
end;

procedure TfrmPBox.FormDestroy(Sender: TObject);
begin
  FreeModuleMenu;
  FListDll.Free;
end;

procedure TfrmPBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAllDllForm(True);
end;

procedure TfrmPBox.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  FListDll      := THashedStringList.Create;
  OnConfig      := OnSysConfig;
  TrayIconPMenu := pmTray;

  for I := 0 to pgcAll.PageCount - 1 do
  begin
    pgcAll.Pages[I].TabVisible := False;
  end;
  LoadButtonBmp(imgSubModuleClose, 'Close', 0);

  { ��ʾ ʱ�� }
  tmrDateTime.OnTimer(nil);

  { ��ʾ IP }
  lblIP.Caption := GetCurrentAdapterIP;

  { �������� }
  ReCreate;
end;

function EnumChildFunc(hDllForm: THandle; hParentHandle: THandle): Boolean; stdcall;
var
  rctClient: TRect;
begin
  Result := True;

  { �ж��Ƿ��� DLL �Ĵ����� }
  if GetParent(hDllForm) = 0 then
  begin
    { ���� DLL �����С }
    GetWindowRect(hParentHandle, rctClient);
    SetWindowPos(hDllForm, hParentHandle, 0, 0, rctClient.Width, rctClient.Height, SWP_NOZORDER + SWP_NOACTIVATE);
  end;
end;

procedure TfrmPBox.FormResize(Sender: TObject);
begin
  if GetShowStyle = 1 then
  begin
    if Assigned(pnlModuleDialog) then
    begin
      pnlModuleDialog.Left := (pnlModuleDialog.Parent.Width - pnlModuleDialog.Width) div 2;
      if Assigned(Sender) then
        pnlModuleDialog.Top := (pnlModuleDialog.Parent.Height - pnlModuleDialog.Height) div 2
      else
        pnlModuleDialog.Top := (pnlModuleDialog.Parent.Height - 19 - pnlModuleDialog.Height) div 2;
    end;
  end;

  if (Assigned(pgcAll)) and (Assigned(tsDll)) and (pgcAll.ActivePage = tsDll) then
  begin
    { ���� DLL �����С }
    EnumChildWindows(Handle, @EnumChildFunc, tsDll.Handle);
  end;
end;

procedure TfrmPBox.lblIPClick(Sender: TObject);
var
  lstAdapter : TList;
  I          : Integer;
  AdapterInfo: PIP_ADAPTER_INFO;
  strIP      : String;
  strGate    : String;
  strName    : String;
  mmItem     : TMenuItem;
  pt         : TPoint;
begin
  lstAdapter := TList.Create;
  try
    GetAdapterInfo(lstAdapter);
    if lstAdapter.Count > 0 then
    begin
      pmAdapterList.Items.Clear;
      for I := 0 to lstAdapter.Count - 1 do
      begin
        AdapterInfo       := PIP_ADAPTER_INFO(lstAdapter.Items[I]);
        strIP             := string(AdapterInfo^.IpAddressList.IpAddress.S);
        strGate           := string(AdapterInfo^.GatewayList.IpAddress.S);
        strName           := string(AdapterInfo^.Description);
        mmItem            := TMenuItem.Create(pmAdapterList);
        mmItem.Caption    := Format('IP: ' + '%-16s Gate: %-16s Name: %-80s', [strIP, strGate, strName]);
        mmItem.OnDrawItem := OnAdapterDrawItem;
        mmItem.OnClick    := OnAdapterIPClick;
        pmAdapterList.Items.Add(mmItem);
      end;
      if pmAdapterList.Items.Count > 1 then
      begin
        pt.X := pnlIP.Left + Left;
        pt.Y := Top + Height + 2;
        pmAdapterList.Popup(pt.X, pt.Y);
      end;
    end;
  finally
    lstAdapter.Free;
  end;
end;

procedure TfrmPBox.OnAdapterDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
  ACanvas.Font.Name := '����';
  ACanvas.Font.Size := 11;
  ACanvas.TextOut(ARect.Left, ARect.Top, (Sender as TMenuItem).Caption);
end;

procedure TfrmPBox.lblTimeClick(Sender: TObject);
begin
  WinExec(PAnsiChar('rundll32.exe Shell32.dll,Control_RunDLL intl.cpl,,/p:"date"'), SW_SHOW);
end;

procedure TfrmPBox.OnAdapterIPClick(Sender: TObject);
var
  strText       : string;
  strIP         : String;
  strName       : String;
  strIniFileName: String;
begin
  strText       := (Sender as TMenuItem).Caption;
  strIP         := Trim(LeftStr(strText, 19));
  strIP         := RightStr(strIP, Length(strIP) - 3);
  lblIP.Caption := strIP;

  strName        := Trim(RightStr(strText, Length(strText) - 42));
  strName        := RightStr(strName, Length(strName) - 6);
  strIniFileName := ChangeFileExt(ParamStr(0), '.ini');
  with TIniFile.Create(strIniFileName) do
  begin
    WriteString('Network', 'AdapterName', strName);
    Free;
  end;
end;

{ ������ʾ������ģ��Ի����� }
procedure TfrmPBox.CreateSubModulesFormDialog(const strPModuleName: string);
var
  I: Integer;
begin
  for I := 0 to mmMainMenu.Items.Count - 1 do
  begin
    if CompareText(mmMainMenu.Items.Items[I].Caption, strPModuleName) = 0 then
    begin
      CreateSubModulesFormDialog(mmMainMenu.Items.Items[I]);
      Break;
    end;
  end;
end;

{ ������ʾ������ģ��Ի����� }
procedure TfrmPBox.CreateSubModulesFormDialog(const mmItem: TMenuItem);
const
  c_intCols         = 5;
  c_intButtonWidth  = 128;
  c_intButtonHeight = 64;
  c_intMiniTop      = 2;
  c_intMiniLeft     = 2;
  c_intHorSpace     = 2;
  c_intVerSpace     = 2;
var
  arrSB   : array of TSpeedButton;
  I, Count: Integer;
begin
  { �ͷ���ǰ�����İ�ť }
  Count := pnlModuleDialog.ComponentCount;
  if Count > 0 then
  begin
    for I := Count - 1 downto 0 do
    begin
      if pnlModuleDialog.Components[I] is TSpeedButton then
      begin
        TSpeedButton(pnlModuleDialog.Components[I]).Free;
      end;
    end;
  end;

  { �����µ���ģ�鰴ť }
  SetLength(arrSB, mmItem.Count);
  for I := 0 to mmItem.Count - 1 do
  begin
    arrSB[I]            := TSpeedButton.Create(pnlModuleDialog);
    arrSB[I].Parent     := pnlModuleDialog;
    arrSB[I].Caption    := mmItem.Items[I].Caption;
    arrSB[I].Width      := c_intButtonWidth;
    arrSB[I].Height     := c_intButtonHeight;
    arrSB[I].GroupIndex := 1;
    arrSB[I].Flat       := True;
    arrSB[I].Top        := pnlModuleDialogTitle.Height + c_intMiniTop + (c_intCols + c_intButtonHeight + c_intVerSpace) * (I div c_intCols);
    arrSB[I].Left       := c_intMiniLeft + (c_intButtonWidth + c_intHorSpace) * (I mod c_intCols);
    arrSB[I].Tag        := mmItem.Items[I].Tag;
    arrSB[I].OnClick    := OnSubModuleButtonClick;
    ilMainMenu.GetBitmap(mmItem.Items[I].ImageIndex, arrSB[I].Glyph);
  end;
  pnlModuleDialog.Visible := True;
end;

procedure TfrmPBox.OnParentModuleButtonClick(Sender: TObject);
var
  I             : Integer;
  strPMdouleName: string;
begin
  pgcAll.ActivePageIndex := 0;
  for I                  := 0 to tlbPModule.ButtonCount - 1 do
  begin
    tlbPModule.Buttons[I].Down := False;
  end;
  TToolButton(Sender).Down     := True;
  strPMdouleName               := TToolButton(Sender).Caption;
  pnlModuleDialogTitle.Caption := strPMdouleName;

  { ���� DLL / EXE ���� }
  FreeAllDllForm;

  { ������ʾ������ģ��Ի����� }
  CreateSubModulesFormDialog(strPMdouleName);
end;

{ ���� DLL / EXE ���� }
procedure TfrmPBox.FreeAllDllForm(const bExit: Boolean = False);
begin
  { EXE ������� }
  FreeExeForm;

  { Delphi DLL ������� }
  FreeDelphiDllForm;

  { VC DLG DLL ������� }
  FreeVCDllForm(bExit);
end;

procedure TfrmPBox.OnSubModuleButtonClick(Sender: TObject);
var
  I, J         : Integer;
  mmItem       : TMenuItem;
  strPMouleName: string;
  strSMouleName: string;
begin
  mmItem := nil;

  strSMouleName := TSpeedButton(Sender).Caption;
  for I         := 0 to tlbPModule.ButtonCount - 1 do
  begin
    if tlbPModule.Components[I] is TToolButton then
    begin
      if TToolButton(tlbPModule.Components[I]).Down then
      begin
        strPMouleName := TToolButton(tlbPModule.Components[I]).Caption;
        Break;
      end;
    end;
  end;

  for I := 0 to mmMainMenu.Items.Count - 1 do
  begin
    if SameText(mmMainMenu.Items.Items[I].Caption, strPMouleName) then
    begin
      for J := 0 to mmMainMenu.Items.Items[I].Count - 1 do
      begin
        if SameText(mmMainMenu.Items.Items[I].Items[J].Caption, strSMouleName) then
        begin
          mmItem := mmMainMenu.Items.Items[I].Items[J];
          Break;
        end;
      end;
    end;
  end;

  pnlModuleDialog.Visible := True;
  if mmItem <> nil then
    OnMenuItemClick(mmItem);
end;

{ ����ʽ��ʾʱ��������ģ�� DLL ģ�� }
procedure TfrmPBox.OnSubModuleListClick(Sender: TObject);
var
  intTag: Integer;
  I, J  : Integer;
  mmItem: TMenuItem;
begin
  mmItem := nil;
  intTag := TLabel(Sender).Tag;
  for I  := 0 to mmMainMenu.Items.Count - 1 do
  begin
    for J := 0 to mmMainMenu.Items.Items[I].Count - 1 do
    begin
      if mmMainMenu.Items.Items[I].Items[J].Tag = intTag then
      begin
        mmItem := mmMainMenu.Items.Items[I].Items[J];
        Break;
      end;
    end;
  end;

  if mmItem <> nil then
    OnMenuItemClick(mmItem);
end;

{ ����ʽ��ʾʱ���������� label ʱ }
procedure TfrmPBox.OnSubModuleMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Color := RGB(0, 0, 255);
  TLabel(Sender).Font.Style := TLabel(Sender).Font.Style + [fsUnderline];
end;

{ ����ʽ��ʾʱ��������뿪 label ʱ }
procedure TfrmPBox.OnSubModuleMouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Color := RGB(51, 153, 255);
  TLabel(Sender).Font.Style := TLabel(Sender).Font.Style - [fsUnderline];
end;

procedure TfrmPBox.OnMenuItemClick(Sender: TObject);
begin
  FreeAllDllForm;
  CreateDllForm(TMenuItem(Sender).Tag);
end;

{ DLL/EXE ��������֮�󣬻ָ����� }
procedure TfrmPBox.DllFormCloseRestoreUI;
begin
  if GetShowStyle = 1 then
    pgcAll.ActivePage := tsButton
  else if GetShowStyle = 2 then
    pgcAll.ActivePage := tsList;
end;

{ Delphi DLL �������� }
procedure TfrmPBox.OnDelphiDllFormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;

  { Delphi DLL ��������֮�󣬻ָ����� }
  DllFormCloseRestoreUI;
end;

{ PE EXE �������� }
procedure TfrmPBox.OnEXEFormClose(Sender: TObject);
begin
  { PE EXE ��������֮�󣬻ָ����� }
  DllFormCloseRestoreUI;
end;

{ VC DLG DLL Form �������� }
procedure TfrmPBox.OnVCDLGDllFormClose(Sender: TObject);
begin
  { VC DLG DLL ��������֮�󣬻ָ����� }
  DllFormCloseRestoreUI;
end;

procedure TfrmPBox.CreateDllForm_Delphi(const strDllFileName: String);
begin
  PBoxRun_DelphiDll(strDllFileName, FListDll.Values[strDllFileName], tsDll, OnDelphiDllFormClose);
end;

procedure TfrmPBox.CreateDllForm_imgEXE(const strDllFileName: String);
begin
  PBoxRun_IMAGE_EXE(strDllFileName, FListDll.Values[strDllFileName], tsDll, OnEXEFormClose);
end;

procedure TfrmPBox.CreateDllForm_VCDLL(const strDllFileName: String);
begin
  PBoxRun_VCDll(strDllFileName, FListDll.Values[strDllFileName], tsDll, OnVCDLGDllFormClose);
end;

procedure TfrmPBox.CreateDllForm(const intMenuItemIndex: Integer);
var
  LangType: TLangStyle;
begin
  SetDllDirectory(PChar(ExtractFilePath(ParamStr(0)) + 'plugins'));
  LangType := TLangStyle(StrToInt(FListDll.ValueFromIndex[intMenuItemIndex].Split([';'])[5]));
  case LangType of
    lsDelphiDll:
      CreateDllForm_Delphi(FListDll.Names[intMenuItemIndex]);
    lsVCDLGDll:
      CreateDllForm_VCDLL(FListDll.Names[intMenuItemIndex]);
    lsVCMFCDll:
      CreateDllForm_VCDLL(FListDll.Names[intMenuItemIndex]);
    lsQTDll:
      CreateDllForm_VCDLL(FListDll.Names[intMenuItemIndex]);
    lsEXE:
      CreateDllForm_imgEXE(FListDll.Names[intMenuItemIndex]);
  end;
end;

end.