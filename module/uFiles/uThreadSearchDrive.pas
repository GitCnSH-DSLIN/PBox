unit uThreadSearchDrive;
{
  NTFS �ļ������߳�
  dbyoung@sina.com
  2020-10-01
}

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, SynCommons, SynSQLite3, db.uCommon;

type
  TSearchThread = class(TThread)
  private
    FchrDrive      : AnsiChar;
    FMainFormHandle: THandle;
    FDataBase      : TSQLite3DB;
    FsrInsert      : TSQLRequest;
    { ��ȡ�ļ���Ϣ }
    procedure GetUSNFileInfo(UsnInfo: PUSN);
  protected
    procedure Execute; override;
  public
    constructor Create(const chrDrive: AnsiChar; const MainFormHandle: THandle; DataBase: TSQLite3DB); overload;
  end;

implementation

{ TSearchThread }

const
  c_strInsertSQL: RawUTF8 = 'INSERT INTO NTFS (ID, Drive, FileID, FilePID, IsDir, FileName) VALUES(NULL,?,?,?,?,?)';

constructor TSearchThread.Create(const chrDrive: AnsiChar; const MainFormHandle: THandle; DataBase: TSQLite3DB);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FchrDrive       := chrDrive;
  FMainFormHandle := MainFormHandle;
  FDataBase       := DataBase;

  FsrInsert.Prepare(FDataBase, RawUTF8(c_strInsertSQL));
end;

procedure TSearchThread.GetUSNFileInfo(UsnInfo: PUSN);
var
  intFileID  : UInt64;
  intFilePID : UInt64;
  strFileName: String;
  intDir     : Integer;
begin
  intFileID   := UsnInfo^.FileReferenceNumber;
  intFilePID  := UsnInfo^.ParentFileReferenceNumber;
  strFileName := PWideChar(Integer(UsnInfo) + UsnInfo^.FileNameOffset);
  strFileName := Copy(strFileName, 1, UsnInfo^.FileNameLength div 2);
  intDir      := Integer(UsnInfo^.FileAttributes and FILE_ATTRIBUTE_DIRECTORY = FILE_ATTRIBUTE_DIRECTORY);
  FsrInsert.Reset;
  FsrInsert.Bind(1, FchrDrive);
  FsrInsert.Bind(2, intFileID);
  FsrInsert.Bind(3, intFilePID);
  FsrInsert.Bind(4, intDir);
  FsrInsert.Bind(5, RawUTF8(strFileName));
  FsrInsert.Step;
end;

{ �򻯵� MOVE ������Ҳ������ MOVE ��������� }
procedure MyMove(const Source; var Dest; Count: NativeInt); assembler;
asm
  FILD    QWORD PTR [EAX]
  FISTP   QWORD PTR [EDX]
end;

procedure TSearchThread.Execute;
var
  cjd         : CREATE_USN_JOURNAL_DATA;
  ujd         : USN_JOURNAL_DATA;
  djd         : DELETE_USN_JOURNAL_DATA;
  dwRet       : DWORD;
  int64Size   : Integer;
  BufferOut   : array [0 .. BUF_LEN - 1] of Char;
  BufferIn    : MFT_ENUM_DATA;
  UsnInfo     : PUSN;
  hRootHandle : THandle;
  intST, intET: Cardinal;
  strTip      : String;
  intCount    : Integer;
begin
  hRootHandle := CreateFile(PChar('\\.\' + FchrDrive + ':'), GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  if hRootHandle = ERROR_INVALID_HANDLE then
    Exit;

  intST    := GetTickCount;
  intCount := 0;
  try
    { ��ʼ��USN��־�ļ� }
    if not DeviceIoControl(hRootHandle, FSCTL_CREATE_USN_JOURNAL, @cjd, Sizeof(cjd), nil, 0, dwRet, nil) then
      Exit;

    { ��ȡUSN��־������Ϣ }
    if not DeviceIoControl(hRootHandle, FSCTL_QUERY_USN_JOURNAL, nil, 0, @ujd, Sizeof(ujd), dwRet, nil) then
      Exit;

    { ö��USN��־�ļ��е����м�¼ }
    int64Size                         := Sizeof(Int64);
    BufferIn.StartFileReferenceNumber := 0;
    BufferIn.LowUsn                   := 0;
    BufferIn.HighUsn                  := ujd.NextUsn;
    while DeviceIoControl(hRootHandle, FSCTL_ENUM_USN_DATA, @BufferIn, Sizeof(BufferIn), @BufferOut, BUF_LEN, dwRet, nil) do
    begin
      { �ҵ���һ�� USN ��¼ }
      UsnInfo := PUSN(Integer(@(BufferOut)) + int64Size);
      while dwRet > 60 do
      begin
        { ��ȡ�ļ���Ϣ }
        GetUSNFileInfo(UsnInfo);
        Inc(intCount);

        { ��ȡ��һ�� USN ��¼ }
        if UsnInfo.RecordLength > 0 then
          Dec(dwRet, UsnInfo.RecordLength)
        else
          Break;

        UsnInfo := PUSN(Cardinal(UsnInfo) + UsnInfo.RecordLength);
      end;
      Move(BufferOut, BufferIn, int64Size);
    end;

    { ɾ��USN��־�ļ���Ϣ }
    djd.UsnJournalID := ujd.UsnJournalID;
    djd.DeleteFlags  := USN_DELETE_FLAG_DELETE;
    DeviceIoControl(hRootHandle, FSCTL_DELETE_USN_JOURNAL, @djd, Sizeof(djd), nil, 0, dwRet, nil);
  finally
    CloseHandle(hRootHandle);
    intET  := GetTickCount;
    strTip := FchrDrive + ':\���ļ�������' + IntToStr(intCount) + '��������ʱ��' + IntToStr((intET - intST) div 1000) + '��';
    SendMessage(FMainFormHandle, WM_SEARCHDRIVEFINISHED, intCount, Integer(PChar(strTip)));
  end;
end;

end.
