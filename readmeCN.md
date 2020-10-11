# PBox ��һ������ DLL ��̬�ⴰ���ģ�黯����ƽ̨

- [English](readme.md)

## һ��������ּ
    ���ž������޸Ļ��޸�ԭ�й���(EXE)Դ�����ԭ��;
    ֧�� Delphi DLL ���塢VC DLL ����(Dialog/MFC)��QT DLL ����; 

## ��������ƽ̨
    Delphi10.3��WIN10X64 �¿�����
    ���谲װ�κε������ؼ���
    WIN10X64�²���ͨ����֧��X86��X64��
    ���䣺dbyoung@sina.com��
    QQȺ��101611228��

## ����ʹ�÷���
### Delphi��
* Delphi ԭ EXE �����ļ����޸�Ϊ DLL ���̡�������������Ϳ����ˣ�ԭ�д��벻�����κ��޸ģ�
* �ѱ����� DLL �ļ����õ� plugins Ŀ¼�¾Ϳ����ˣ�
* ʾ����module\sPath��
* ʾ����module\pm��
* ʾ����module\PDFView��
* Delphi ����������
```
 procedure db_ShowDllForm_Plugins(var frm: TFormClass; var strParentModuleName, strSubModuleName: PAnsiChar); stdcall;
```
### VC2017 / VC2019
* �� VC ���� EXE ת���� DLL�����������Ե���: [https://blog.csdn.net/dbyoung/article/details/103987103]
* VC ԭ EXE�����ڶԻ��򣬲����κ��޸ġ��½� Dll.cpp �ļ���������������Ϳ����ˣ�
* VC ԭ EXE������   MFC����Ҫ�����޸ģ�
* �ѱ����� DLL �ļ����õ� plugins Ŀ¼�¾Ϳ����ˣ�
* ʾ��(���ڶԻ���)��module\7-zip��
* ʾ��(���ڶԻ���)��module\Notepad2��
* ʾ��(����   MFC)��module\mpc-be��
* VC2017 / VC2019 ����������
```
enum TLangStyle {lsDelphiDll, lsVCDLGDll, lsVCMFCDll, lsQTDll, lsEXE};
extern "C" __declspec(dllexport) void db_ShowDllForm_Plugins(TLangStyle* lsFileType, char** strParentName, char** strSubModuleName, char** strClassName, char** strWindowName, const bool show = false)
```

### QT
* QT ԭ EXE�������κ��޸ġ����룬�õ� LIB��RES��OBJ �ļ���
* �½� Dll.cpp �ļ���������������Ϳ����ˣ����롢���ӵõ� DLL �ļ���
* �ѱ����� DLL �ļ����õ� plugins Ŀ¼�¾Ϳ����ˣ�
* ��ʵ�� VC Dialog DLL ��ʽһģһ������װ�͵��ã�
* ʾ����module\cmake-gui��
* ����������
```
enum TLangStyle {lsDelphiDll, lsVCDLGDll, lsVCMFCDll, lsQTDll, lsEXE};
extern "C" __declspec(dllexport) void db_ShowDllForm_Plugins(TLangStyle* lsFileType, char** strParentName, char** strSubModuleName, char** strClassName, char** strWindowName, const bool show = false)
```

## �ģ�Dll �����������˵��
* Delphi ��
```
 procedure db_ShowDllForm_Plugins(var frm: TFormClass; var strParentModuleName, strSubModuleName: PAnsiChar); stdcall;

 frm                 ��Delphi �� DLL ������������
 strParentModuleName ����ģ�����ƣ�
 strSubModuleName    ����ģ�����ƣ�
```
* VC2017/QT ��
```
extern "C" __declspec(dllexport) void db_ShowDllForm_Plugins(TLangStyle* lsFileType, char** strParentName, char** strSubModuleName, char** strClassName, char** strWindowName, const bool show = false)

 lsFileType        ���ǻ��� Dialog(�Ի���) �� DLL ���壬���ǻ��� MFC �� DLL ���壬���ǻ��� QT �� DLL ���壻
 strParentName     ����ģ�����ƣ�
 strSubModuleName  ����ģ�����ƣ�
 strClassName      ��DLL �������������
 strWindowName     ��DLL ������ı�������
 show              ����ʾ/���ش��壻
```

## �壺��ɫ����
    ����֧�֣��˵���ʽ��ʾ����ť���Ի��򣩷�ʽ��ʾ���б��ӷ�ʽ��ʾ��
    ֧�ֽ�һ�� EXE ���������ʾ�����ǵĴ����У�
    ֧�ִ���������̬�仯�� EXE��DLL ���� ����֧�ֶ��ĵ����壻
    ֧���ļ��Ϸ��� EXE��DLL ���壻
    ֧�� x86 EXE ���� x64 EXE��x64 EXE ���� x86 EXE��
    
## ����������������
    �������ݿ�֧�֣����ڱ��˶����ݿⲻ��Ϥ�����Կ�������������ҵ��ʱ�俪����;