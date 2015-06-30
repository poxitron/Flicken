{
        Flicken
        Copyright © 2014, poxitron
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

unit frmFlicken;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Winapi.ShellAPI, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  System.Zip, INIFiles, System.IOUtils, RegularExpressions;

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
    Memo1: TMemo;
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
          if FileExists(PChar(@pDroppedFilename)) and SameText(ExtractFileExt(PChar(@pDroppedFilename)), '.zip') then
          begin
            ArchivoZip_Edit.Text := PChar(@pDroppedFilename);
          end;
        end
        else
        if Msg.hwnd = RutaOrigen_Edit.Handle then
        begin
          // comprueba si es una carpeta y lo añade
          if DirectoryExists(PChar(@pDroppedFilename)) then
          begin
            RutaOrigen_Edit.Text := PChar(@pDroppedFilename);
          end;
        end
        else
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

// extraer el archivo .zip a la carpeta temporal de Windows
procedure ExtraerArchivos;
var
  AZipper: TZipFile;
begin
  AZipper := TZipFile.Create;
  try
    AZipper.Open(Form2.ArchivoZip_Edit.Text,zmRead);
    AZipper.ExtractAll(TempDirectory);
    AZipper.Close;
  finally
    AZipper.Free;
  end;
end;

procedure ParchearArchivos;
type
 TMyHeader = packed record
 header: array[0..500] of byte;
end;

var
  FileToProbe: TFileStream;
  header: TMyHeader;
  RegExOrigen, RegExDestino: TRegEx;
  MOrigen, MDestino: TMatch;
  AListBox: TStringList;
  parametros, Archivoxdelta, ArchivoOrigen, ArchivoDestino: String;
  h, i: integer;

begin
  // abrir el archivo y leer el encabezado
  AListBox := TStringList.Create;
  AListBox.Sorted := True;
  try
    FileSearch(TempDirectory, '.xdelta;.vcdiff', AListBox);
    for i := 0 to AListBox.Count -1 do
    begin
      Form2.Memo1.Clear;
      Archivoxdelta := AListBox.Strings[i];
      FileToProbe := TFileStream.Create(Archivoxdelta, fmOpenRead);
      FileToProbe.seek(0, soFromBeginning);
      FileToProbe.ReadBuffer(header, SizeOf(header));
      for h := 0 to 500 do
      begin
        Form2.Memo1.Text := Form2.Memo1.Text + HexToString(IntToHex(header.Header[h], 2));
      end;
      // obtiene el nombre de archivo de destino
      RegExDestino.Create('\\(.*?)//',[roSingleLine]);
      MDestino := RegExDestino.Match(Form2.Memo1.Text);
      if MDestino.Success then
      begin
        ArchivoDestino := IncludeTrailingPathDelimiter(Form2.RutaDestino_Edit.Text) +  ExtractFileName(MDestino.Value);
        Delete(ArchivoDestino, Length(ArchivoDestino)-1, 2);
      end;
      // obtiene el nombre de archivo que se va a parchear
      RegExOrigen.Create('//(.*?)/',[roSingleLine]);
      MOrigen := RegExOrigen.Match(Form2.Memo1.Text);
      if MOrigen.Success then
      begin
        ArchivoOrigen := IncludeTrailingPathDelimiter(Form2.RutaOrigen_Edit.Text) + ExtractFileName(MOrigen.Value);
        Delete(ArchivoOrigen, Length(ArchivoOrigen), 1);
      end;
      parametros := '"' + ArchivoOrigen + '" "' + Archivoxdelta + '" "' + ArchivoDestino + '"';
      FileToProbe.Free;
      ExecNewProcess(RutaEjecutable + '\xdelta.exe -f -d -s ' + parametros, SW_HIDE, True);
    end;
  finally
    AListBox.Free;
  end;
end;
//------------------------- Fin de los procedimientos -------------------------
//-----------------------------------------------------------------------------

procedure TForm2.FormCreate(Sender: TObject);
begin
  Application.OnMessage := AppMessage;
  DragAcceptFiles(ArchivoZip_Edit.Handle, True);
  DragAcceptFiles(RutaOrigen_Edit.Handle, True);
  DragAcceptFiles(RutaDestino_Edit.Handle, True);
  RutaEjecutable := ExtractFileDir(Application.ExeName);
  TempDirectory := GetEnvironmentVariable('TEMP')+'\PatchMe';
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DragAcceptFiles(ArchivoZip_Edit.Handle, False);
  DragAcceptFiles(RutaOrigen_Edit.Handle, False);
  DragAcceptFiles(RutaDestino_Edit.Handle, False);
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
begin
  Estado_Label.Caption := 'Estado: Extrayendo archivos...';
  Estado_Label.Update;
  ExtraerArchivos;
  Estado_Label.Caption := 'Estado: Parcheando archivos...';
  Estado_Label.Update;
  ParchearArchivos;
  TDirectory.Delete(TempDirectory, True);
  Estado_Label.Caption := 'Estado: Proceso finalizado.';
end;

{ TODO 1: Añadir un hilo (thread) para que la aplicación no se quede congelada. }
end.
