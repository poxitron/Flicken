{
        Flicken
        Copyright © 2015, poxitron
        This file is part of Flicken.

    Flicken is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Flicken is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Flicken.  If not, see <http://www.gnu.org/licenses/>.
}

unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Winapi.ShellAPI, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  System.IOUtils, System.UITypes, INIFiles, RegularExpressions;

type
  TForm2 = class(TForm)
    ArchivoZip_Edit: TEdit;
    Zip_Button: TButton;
    Label1: TLabel;
    Zip_OpenDialog: TOpenDialog;
    Label2: TLabel;
    RutaOrigen_Edit: TEdit;
    Origen_Button: TButton;
    Label3: TLabel;
    RutaDestino_Edit: TEdit;
    RutaDestino_Button: TButton;
    Parchear_Button: TButton;
    Estado_Label: TLabel;
    procedure Origen_ButtonClick(Sender: TObject);
    procedure Zip_ButtonClick(Sender: TObject);
    procedure RutaDestino_ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Parchear_ButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
  public
    { Public declarations }
  end;

  { TMyThread }
  TMyThread = class(TThread)
  protected
    procedure Execute; override;
  end;

var
  Form2: TForm2;
  INI: TINIFile;
  TempDirectory, RutaEjecutable: String;

implementation

uses MyFunctions;

{$R *.dfm}
//-----------------------------------------------------------------------------
//------------------------------- Procedimientos ------------------------------
function HexToString(H: String): String;
var I : Integer;
begin
  Result := '';
  for I := 1 to length (H) div 2 do
    Result := Result+Char(StrToInt('$'+Copy(H,(I-1)*2+1,2)));
end;

procedure DeshabilitarComponentes;
var
  i: Integer;
begin
  for i := 0 to Form2.ComponentCount - 1 do
  begin
    if Form2.Components[i] is TButton then
    begin
      TButton(Form2.Components[i]).Enabled := False;
    end;
    if Form2.Components[i] is TEdit then
    begin
      TEdit(Form2.Components[i]).Enabled := False;
    end;
  end;
end;

procedure HabilitarComponentes;
var
  i: Integer;
begin
  for i := 0 to Form2.ComponentCount - 1 do
  begin
    if Form2.Components[i] is TButton then
    begin
      TButton(Form2.Components[i]).Enabled := True;
    end;
    if Form2.Components[i] is TEdit then
    begin
      TEdit(Form2.Components[i]).Enabled := True;
    end;
  end;
end;

// arrastrar y soltar archivos desde Windows
procedure TForm2.AppMessage(var Msg: TMsg; var Handled: Boolean);
var
  QtyDroppedFiles, FileIndex: Integer;
  pDroppedFilename: array[0..255] of Char;
begin
  if Msg.message=WM_DROPFILES then
  begin
    QtyDroppedFiles:=DragQueryFile(Msg.wParam, Cardinal(-1), nil, 0);
    try
      for FileIndex:=0 to QtyDroppedFiles -1 do
      begin
        DragQueryFile(Msg.wParam, FileIndex, @pDroppedFilename, sizeof(pDroppedFilename));
        if Msg.hwnd= ArchivoZip_Edit.Handle then
        begin
          // comprueba si es un archivo .zip y lo añade
          if FileExists(PChar(@pDroppedFilename)) then
          begin
            ArchivoZip_Edit.Text := PChar(@pDroppedFilename);
          end;
        end;
        if Msg.hwnd = RutaOrigen_Edit.Handle then
        begin
          // comprueba si es una carpeta y lo añade
          if DirectoryExists(PChar(@pDroppedFilename)) then
          begin
            RutaOrigen_Edit.Text := PChar(@pDroppedFilename);
          end;
        end;
        if Msg.hwnd = RutaDestino_Edit.Handle then
        begin
          // comprueba si es una carpeta y lo añade
          if DirectoryExists(Pchar(@pDroppedFilename)) then
          begin
            RutaDestino_Edit.Text := PChar(@pDroppedFilename);
          end;
        end;
      end;
    finally
      DragFinish(Msg.wParam);
      Handled:=True;
    end;
  end;
end;

procedure ExtraerArchivos;
begin
  try
    ExecNewProcess(RutaEjecutable + '\7z.exe e ' + '"' +Form2.ArchivoZip_Edit.Text + '" -o"' + TempDirectory + '"'+ ' *.xdelta -y', SW_HIDE, True);
  finally

  end;
end;

procedure ParchearArchivos;
type
 TMyHeader = packed record
 Header1: byte;
 Header2: byte;
 Header3: byte;
 Header4: byte;
 Hdr_Indicator: byte;
 Win_Indicator: byte;
 Header: array [0..500] of byte;
end;

var
  FileStream1: TFileStream;
  Streamlist: TStringStream;
  MyHeader: TMyHeader;
  RegExOrigen, RegExDestino: TRegEx;
  MOrigen, MDestino: TMatch;
  AListBox: TStringList;
  parametros, Archivoxdelta, ArchivoOrigen, ArchivoDestino: String;
  h, i: integer;
begin
  // abrir el archivo y leer el encabezado
  AListBox := TStringList.Create;
  AListBox.Sorted := True;
  Streamlist := TStringStream.Create('', TEncoding.Unicode);
  FileSearch(TempDirectory, '.xdelta;.vcdiff', AListBox);
  try
    for i := 0 to AListBox.Count -1 do
    begin
      Archivoxdelta := AListBox.Strings[i];
      FileStream1 := TFileStream.Create(Archivoxdelta, fmOpenRead or fmShareDenyNone);
      FileStream1.seek(0, soFromBeginning);
      FileStream1.ReadBuffer(MyHeader, SizeOf(MyHeader));
      for h := 0 to 500 do
      begin
        Streamlist.WriteString(HexToString(IntToHex(MyHeader.Header[h], 2)));
      end;
      // obtiene el nombre de archivo de destino
      RegExDestino.Create('\\(.*?)//',[roSingleLine]);
      MDestino := RegExDestino.Match(Streamlist.DataString);
      if MDestino.Success then
      begin
        ArchivoDestino := IncludeTrailingPathDelimiter(Form2.RutaDestino_Edit.Text) +  ExtractFileName(MDestino.Value);
        Delete(ArchivoDestino, Length(ArchivoDestino)-1, 2);
      end
      else
      begin
        MessageDlg('No se ha podido encontrar el archivo de destino en el .xdelta.' + #13 + 'Avisa al desarrollador de la aplicación.', mtError, [mbOK], 0);
      end;
      // obtiene el nombre de archivo que se va a parchear
      RegExOrigen.Create('//(.*?)/',[roSingleLine]);
      MOrigen := RegExOrigen.Match(Streamlist.DataString);
      if MOrigen.Success then
      begin
        ArchivoOrigen := IncludeTrailingPathDelimiter(Form2.RutaOrigen_Edit.Text) + ExtractFileName(MOrigen.Value);
        Delete(ArchivoOrigen, Length(ArchivoOrigen), 1);
      end
      else
      begin
        MessageDlg('No se ha podido encontrar el archivo de origen en el .xdelta.' + #13 + 'Avisa al desarrollador de la aplicación.', mtError, [mbOK], 0);
      end;
      Streamlist.Size := 0;
      FileStream1.Free;
      parametros := '"' + ArchivoOrigen + '" "' + Archivoxdelta + '" "' + ArchivoDestino + '"';
      ExecNewProcess(RutaEjecutable + '\xdelta.exe -f -d -s ' + parametros, SW_HIDE, True);
    end;
  finally
    Streamlist.Free;
    AListBox.Free;
  end;
end;
//------------------------- Fin de los procedimientos -------------------------
//-----------------------------------------------------------------------------

procedure TForm2.FormCreate(Sender: TObject);
begin
  Form2.Caption := Application.Title + GetAppVersion;
  Application.OnMessage := AppMessage;
  DragAcceptFiles(ArchivoZip_Edit.Handle, True);
  DragAcceptFiles(RutaOrigen_Edit.Handle, True);
  DragAcceptFiles(RutaDestino_Edit.Handle, True);
  RutaEjecutable := ExtractFileDir(Application.ExeName);
  TempDirectory := GetEnvironmentVariable('TEMP') + '\PatchMe';
  try
    INI := TINIFile.Create(RutaEjecutable + '\config.ini');
    Self.Top := INI.ReadInteger('form', 'MainFormTop', Screen.DesktopHeight div 2 - 120);
    Self.Left := INI.ReadInteger('form', 'MainFormLeft', Screen.DesktopWidth div 2 - 225);
    Self.Width := INI.ReadInteger('form', 'MainFormWidth', 500);
    Self.Height := INI.ReadInteger('form', 'MainFormHeight', 520);
  finally
    INI.Free;
  end;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DragAcceptFiles(ArchivoZip_Edit.Handle, False);
  DragAcceptFiles(RutaOrigen_Edit.Handle, False);
  DragAcceptFiles(RutaDestino_Edit.Handle, False);
  try
    INI := TINIFile.Create(RutaEjecutable + '\config.ini');
    INI.WriteInteger('form', 'MainFormTop', Self.Top);
    INI.WriteInteger('form', 'MainFormLeft', Self.Left);
    INI.WriteInteger('form', 'MainFormWidth', Self.Width);
    INI.WriteInteger('form', 'MainFormHeight', Self.Height);
  finally
    Ini.Free;
  end;
end;

// seleccionar el archivo zip
procedure TForm2.Zip_ButtonClick(Sender: TObject);
begin
  if Zip_OpenDialog.Execute then
    ArchivoZip_Edit.Text := Zip_OpenDialog.FileName;
end;

// seleccionar la carpeta donde están los archivos que se van a parchear
procedure TForm2.Origen_ButtonClick(Sender: TObject);
begin
with TFileOpenDialog.Create(nil) do
  try
    Options := [fdoPickFolders];
    if Execute then
      RutaOrigen_Edit.Text := FileName;
  finally
    Free;
  end;
end;

// seleccionar la carpeta donde se crearán los archivos parcheados
procedure TForm2.RutaDestino_ButtonClick(Sender: TObject);
begin
with TFileOpenDialog.Create(nil) do
  try
    Options := [fdoPickFolders];
    if Execute then
      RutaDestino_Edit.Text := FileName;
  finally
    Free;
  end;
end;

procedure TForm2.Parchear_ButtonClick(Sender: TObject);
var
  AThread: TMyThread;
begin
  if not FileExists(ArchivoZip_Edit.Text)  then
    MessageDlg('El archivo .zip no existe.', mtError, [mbOK], 0)
  else
  if not DirectoryExists(RutaOrigen_Edit.Text) then
    MessageDlg('El directorio de origen no existe.', mtError, [mbOK], 0)
  else
  if not DirectoryExists(RutaDestino_Edit.Text) then
    MessageDlg('El directorio de destino no existe.', mtError, [mbOK], 0)
  else
  begin
    AThread := TMyThread.Create(True);
    AThread.FreeOnTerminate := True;
    AThread.Start;
  end;
end;

procedure TMyThread.Execute;
begin
  DeshabilitarComponentes;
  Form2.Estado_Label.Caption := 'Estado: Extrayendo archivos...';
  ExtraerArchivos;
  Form2.Estado_Label.Caption := 'Estado: Parcheando archivos...';
  ParchearArchivos;
  TDirectory.Delete(TempDirectory, True);
  HabilitarComponentes;
  Form2.Estado_Label.Caption := 'Estado: Proceso finalizado.';
end;

end.
