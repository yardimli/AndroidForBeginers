unit cordova1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AeroButtons, AdvmCSS,
  AdvmWS, AdvMemo, FolderDialog, AdvPageControl, Vcl.ComCtrls,
  Vcl.Imaging.GIFImg, Vcl.ExtCtrls, Registry, ShellAPI, Vcl.ImgList;

type
  TForm1 = class(TForm)
    AdvMemoSource1: TAdvMemoSource;
    AdvHTMLMemoStyler1: TAdvHTMLMemoStyler;
    AdvJSMemoStyler1: TAdvJSMemoStyler;
    AdvCSSMemoStyler1: TAdvCSSMemoStyler;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    AdvPageControl1: TAdvPageControl;
    HTMLFile: TAdvTabSheet;
    CSSFile: TAdvTabSheet;
    JavascriptFile: TAdvTabSheet;
    HtmlMemo: TAdvMemo;
    CSSMemo: TAdvMemo;
    JSMemo: TAdvMemo;
    FolderDialog1: TFolderDialog;
    ConsoleLog: TAdvTabSheet;
    ConsoleMemo: TAdvMemo;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    ShortNameEdit: TEdit;
    LongNameEdit: TEdit;
    AeroButton1: TAeroButton;
    GroupBox2: TGroupBox;
    AeroButton2: TAeroButton;
    AeroButton3: TAeroButton;
    AeroButton4: TAeroButton;
    GroupBox3: TGroupBox;
    AeroButton5: TAeroButton;
    Panel2: TPanel;
    Image1: TImage;
    AeroButton6: TAeroButton;
    AeroButton7: TAeroButton;
    AeroButton8: TAeroButton;
    AeroButton9: TAeroButton;
    AeroButton10: TAeroButton;
    AeroButton11: TAeroButton;
    AeroButton12: TAeroButton;
    RootFolder: TEdit;
    GroupBox4: TGroupBox;
    AeroButton13: TAeroButton;
    AeroButton14: TAeroButton;
    AeroButton15: TAeroButton;
    ImageList1: TImageList;
    procedure AeroButton1Click(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure AeroButton3Click(Sender: TObject);
    procedure AeroButton5Click(Sender: TObject);
    procedure AeroButton4Click(Sender: TObject);
    procedure AeroButton14Click(Sender: TObject);
    procedure AeroButton15Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
     Procedure CMDialogKey(Var Msg: TWMKey); message CM_DIALOGKEY;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  projectFolder : String;

implementation

{$R *.dfm}

procedure TForm1.CMDialogKey(var Msg: TWMKey);
begin
 if (AdvPageControl1.Focused) then
    Msg.Result := 0
 else
 inherited;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (ssShift in Shift) and (Ord(Key) = VK_TAB) then
 begin
  if AdvPageControl1.ActivePageIndex>0 then
   if Ord(Key) = VK_TAB then AdvPageControl1.ActivePageIndex:=AdvPageControl1.ActivePageIndex-1 else
   AdvPageControl1.ActivePageIndex:= AdvPageControl1.PageCount-1;

   if AdvPageControl1.ActivePage = HTMLFile then HtmlMemo.SetFocus;
   if AdvPageControl1.ActivePage = CSSFile then CSSMemo.SetFocus;
   if AdvPageControl1.ActivePage = JavascriptFile then JSMemo.SetFocus;
   if AdvPageControl1.ActivePage = ConsoleLog then ConsoleMemo.SetFocus;

   exit;
 end;

 if Ord(Key) = VK_TAB then
 begin
  if AdvPageControl1.ActivePageIndex<AdvPageControl1.PageCount-1 then
   AdvPageControl1.ActivePageIndex:=AdvPageControl1.ActivePageIndex+1 else
   AdvPageControl1.ActivePageIndex:=0;

   if AdvPageControl1.ActivePage = HTMLFile then HtmlMemo.SetFocus;
   if AdvPageControl1.ActivePage = CSSFile then CSSMemo.SetFocus;
   if AdvPageControl1.ActivePage = JavascriptFile then JSMemo.SetFocus;
   if AdvPageControl1.ActivePage = ConsoleLog then ConsoleMemo.SetFocus;

 end;
end;

function GetDosOutput(CommandLine: string; Work: string = 'C:\'): string;
var
  SA: TSecurityAttributes;
  SI: TStartupInfo;
  PI: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  Buffer: array[0..255] of AnsiChar;
  BytesRead: Cardinal;
  WorkDir: string;
  Handle: Boolean;
begin
  Result := '';
  with SA do begin
    nLength := SizeOf(SA);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SA, 0);
  try
    with SI do
    begin
      FillChar(SI, SizeOf(SI), 0);
      cb := SizeOf(SI);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;
    WorkDir := Work;
    Handle := CreateProcess(nil, PChar('cmd.exe /C ' + CommandLine),
                            nil, nil, True, 0, nil,
                            PChar(WorkDir), SI, PI);
    CloseHandle(StdOutPipeWrite);
    if Handle then
      try
        repeat
          WasOK := ReadFile(StdOutPipeRead, Buffer, 255, BytesRead, nil);
          if BytesRead > 0 then
          begin
            Buffer[BytesRead] := #0;
            Result := Result + Buffer;
          end;
        until not WasOK or (BytesRead = 0);
        WaitForSingleObject(PI.hProcess, INFINITE);
        Application.ProcessMessages;
      finally
        CloseHandle(PI.hThread);
        CloseHandle(PI.hProcess);
      end;
  finally
    CloseHandle(StdOutPipeRead);
  end;
end;

procedure TForm1.AeroButton14Click(Sender: TObject);
begin
  HtmlMemo.lines.SaveToFile( projectFolder+'\www\index.html' );
  CSSMemo.lines.SaveToFile( projectFolder+'\www\css\index.css' );
  JSMemo.lines.SaveToFile( projectFolder+'\www\js\index.js' );
end;


function BrowseURL(const URL: string) : boolean;
var
   Browser: string;
begin
   Result := True;
   Browser := '';
   with TRegistry.Create do
   try
     RootKey := HKEY_CLASSES_ROOT;
Access := KEY_QUERY_VALUE;
     if OpenKey('\htmlfile\shell\open\command', False) then
       Browser := ReadString('') ;
     CloseKey;
   finally
     Free;
   end;
   if Browser = '' then
   begin
     Result := False;
     Exit;
   end;
   Browser := Copy(Browser, Pos('"', Browser) + 1, Length(Browser)) ;
   Browser := Copy(Browser, 1, Pos('"', Browser) - 1) ;
   ShellExecute(0, 'open', PChar(Browser), PChar(URL), nil, SW_SHOW) ;
end;

procedure TForm1.AeroButton15Click(Sender: TObject);
begin
  HtmlMemo.lines.SaveToFile( projectFolder+'\www\index.html' );
  CSSMemo.lines.SaveToFile( projectFolder+'\www\css\index.css' );
  JSMemo.lines.SaveToFile( projectFolder+'\www\js\index.js' );

  ShellExecute(self.WindowHandle,'open',pchar('file:///'+projectFolder+'\www\index.html'),nil,nil, SW_SHOWNORMAL);

//  BrowseURL('file:///'+projectFolder+'\www\index.html') ;
end;

procedure TForm1.AeroButton1Click(Sender: TObject);
begin
 Image1.Visible := true;
 (Image1.Picture.Graphic as TGIFImage).Animate := True;

 AdvPageControl1.ActivePage := ConsoleLog;
        Application.ProcessMessages;
 ConsoleMemo.InsertText( GetDosOutput('cordova create '+RootFolder.Text+'\'+ShortNameEdit.Text+' io.cordova.'+ShortNameEdit.Text+' '+LongNameEdit.Text+'' , 'c:\adt' ));

 ConsoleMemo.SelStart := ConsoleMemo.GetTextLen;
 ConsoleMemo.SelLength := 0;
 ConsoleMemo.ScrollBy(0, ConsoleMemo.Lines.Count);
 ConsoleMemo.Refresh;

        Application.ProcessMessages;
 ConsoleMemo.InsertText( GetDosOutput('cordova -d platform add android',RootFolder.Text+'\'+ShortNameEdit.Text));

 ConsoleMemo.SelStart := ConsoleMemo.GetTextLen;
 ConsoleMemo.SelLength := 0;
 ConsoleMemo.ScrollBy(0, ConsoleMemo.Lines.Count);
 ConsoleMemo.Refresh;

        Application.ProcessMessages;
 ConsoleMemo.InsertText( GetDosOutput('cordova plugin add org.apache.cordova.camera',RootFolder.Text+'\'+ShortNameEdit.Text));

 ConsoleMemo.SelStart := ConsoleMemo.GetTextLen;
 ConsoleMemo.SelLength := 0;
 ConsoleMemo.ScrollBy(0, ConsoleMemo.Lines.Count);
 ConsoleMemo.Refresh;

        Application.ProcessMessages;
 ConsoleMemo.InsertText( GetDosOutput('cordova build',RootFolder.Text+'\'+ShortNameEdit.Text));

 ConsoleMemo.SelStart := ConsoleMemo.GetTextLen;
 ConsoleMemo.SelLength := 0;
 ConsoleMemo.ScrollBy(0, ConsoleMemo.Lines.Count);
 ConsoleMemo.Refresh;

 projectFolder := RootFolder.Text+'\'+ShortNameEdit.Text;
 form1.Caption := 'Taipei Hackerspace Cordova Editor - ['+projectFolder+']';

 HtmlMemo.lines.LoadFromFile( projectFolder+'\www\index.html' );
 CSSMemo.lines.LoadFromFile( projectFolder+'\www\css\index.css' );
 JSMemo.lines.LoadFromFile( projectFolder+'\www\js\index.js' );

 Image1.Visible := false;
 (Image1.Picture.Graphic as TGIFImage).Animate := false;
end;

procedure TForm1.AeroButton2Click(Sender: TObject);
begin
 FolderDialog1.Directory := RootFolder.Text;
 if FolderDialog1.Execute then
 begin
  projectFolder := FolderDialog1.Directory;
  form1.Caption := 'Taipei Hackerspace Cordova Editor - ['+projectFolder+']';

  HtmlMemo.lines.LoadFromFile( projectFolder+'\www\index.html' );
  CSSMemo.lines.LoadFromFile( projectFolder+'\www\css\index.css' );
  JSMemo.lines.LoadFromFile( projectFolder+'\www\js\index.js' );

  AdvPageControl1.ActivePage := HTMLFile;
 end;
end;

procedure TForm1.AeroButton3Click(Sender: TObject);
begin
  HtmlMemo.lines.SaveToFile( projectFolder+'\www\index.html' );
  CSSMemo.lines.SaveToFile( projectFolder+'\www\css\index.css' );
  JSMemo.lines.SaveToFile( projectFolder+'\www\js\index.js' );

 Image1.Visible := true;
 (Image1.Picture.Graphic as TGIFImage).Animate := True;

 AdvPageControl1.ActivePage := ConsoleLog;
 Application.ProcessMessages;

 Application.ProcessMessages;
 ConsoleMemo.InsertText( GetDosOutput('cordova build',projectFolder));

 ConsoleMemo.SelStart := ConsoleMemo.GetTextLen;
 ConsoleMemo.SelLength := 0;
 ConsoleMemo.ScrollBy(0, ConsoleMemo.Lines.Count);
 ConsoleMemo.Refresh;

 Image1.Visible := false;

end;

procedure TForm1.AeroButton4Click(Sender: TObject);
begin
 HtmlMemo.lines.SaveToFile( projectFolder+'\www\index.html' );
 CSSMemo.lines.SaveToFile( projectFolder+'\www\css\index.css' );
 JSMemo.lines.SaveToFile( projectFolder+'\www\js\index.js' );

 Image1.Visible := true;
 (Image1.Picture.Graphic as TGIFImage).Animate := True;

 AdvPageControl1.ActivePage := ConsoleLog;
 Application.ProcessMessages;

 Application.ProcessMessages;
 ConsoleMemo.InsertText( GetDosOutput('cordova run android',projectFolder));

 ConsoleMemo.SelStart := ConsoleMemo.GetTextLen;
 ConsoleMemo.SelLength := 0;
 ConsoleMemo.ScrollBy(0, ConsoleMemo.Lines.Count);
 ConsoleMemo.Refresh;

 Image1.Visible := false;
end;

procedure TForm1.AeroButton5Click(Sender: TObject);
begin
 Image1.Visible := true;
 (Image1.Picture.Graphic as TGIFImage).Animate := True;

 AdvPageControl1.ActivePage := ConsoleLog;
 Application.ProcessMessages;

 Application.ProcessMessages;
 ConsoleMemo.InsertText( GetDosOutput('cordova plugin add org.apache.cordova.camera',projectFolder));

 ConsoleMemo.SelStart := ConsoleMemo.GetTextLen;
 ConsoleMemo.SelLength := 0;
 ConsoleMemo.ScrollBy(0, ConsoleMemo.Lines.Count);
 ConsoleMemo.Refresh;

 Image1.Visible := false;

end;

end.















                    