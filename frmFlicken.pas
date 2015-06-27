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
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Zip, INIFiles, System.IOUtils,
  RegularExpressions;

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
  private
    { Private declarations }
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
  Result:= '';
  for I := 1 to length (H) div 2 do
    Result:= Result+Char(StrToInt('$'+Copy(H,(I-1)*2+1,2)));
end;

// extraer el archivo zip a la carpeta temporal de Windows
procedure ExtraerArchivos;
var
  AZipper: TZipFile;
begin
  AZipper:=TZipFile.Create;
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
  FileToProbe: TStream;
  header: TMyHeader;
  RegExOrigen, RegExDestino: TRegEx;
  MOrigen, MDestino: TMatch;
  AListBox: TStringList;
  parametros, Archivoxdelta, ArchivoOrigen, ArchivoDestino: String;
  h, i: integer;
begin
  // Open the file and read the header
  AListBox:=TStringList.Create;
  AListBox.Sorted:=True;
  try
    FileSearch(TempDirectory, '.xdelta;.vcdiff', AListBox);
    for i:=0 to AListBox.Count -1 do
    begin
      Form2.Memo1.Clear;
      Archivoxdelta:=AListBox.Strings[i];
      FileToProbe := TFileStream.Create(Archivoxdelta, fmOpenRead);
      FileToProbe.seek(0, soFromBeginning);
      FileToProbe.ReadBuffer(header, SizeOf(header));
      for h:= 0 to 500 do
      begin
        Form2.Memo1.Text := Form2.Memo1.Text + HexToString(IntToHex(header.Header[h], 2));
      end;
      // obtiene el nombre de archivo de destino
      RegExDestino.Create('\\(.*?)//',[roSingleLine]);
      MDestino := RegExDestino.Match(Form2.Memo1.Text);
      if MDestino.Success then
      begin
        ArchivoDestino := Form2.RutaDestino_Edit.Text +  ExtractFileName(MDestino.Value);
        Delete(ArchivoDestino, Length(ArchivoDestino)-1, 2);
      end;
      // obtiene el nombre de archivo de origen
      RegExOrigen.Create('//(.*?)/',[roSingleLine]);
      MOrigen := RegExOrigen.Match(Form2.Memo1.Text);
      if MOrigen.Success then
      begin
        ArchivoOrigen := Form2.RutaOrigen_Edit.Text + ExtractFileName(MOrigen.Value);
        Delete(ArchivoOrigen, Length(ArchivoOrigen), 1);
      end;
      parametros := '"' + ArchivoOrigen + '" "' + Archivoxdelta + '" "' + ArchivoDestino + '"';
      //MessageDlg(RutaEjecutable+'\xdelta.exe -f -d -s ' + parametros, mtError, [mbOK], 0);
      FileToProbe.Free;
      ExecNewProcess(RutaEjecutable+'\xdelta.exe -f -d -s '+parametros, SW_HIDE, True);
    end;
  finally
    AListBox.Free;
  end;
end;
//------------------------- Fin de los procedimientos -------------------------
//-----------------------------------------------------------------------------

procedure TForm2.FormCreate(Sender: TObject);
begin
  RutaEjecutable:=ExtractFileDir(Application.ExeName);
  TempDirectory:=GetEnvironmentVariable('TEMP')+'\PatchMe';
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
      RutaOrigen_Edit.Text:= IncludeTrailingBackslash(FileName);
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
      RutaDestino_Edit.Text:= IncludeTrailingBackslash(FileName);
  finally
    Free;
  end;
end;

// inicia el thread
procedure TForm2.Parchear_ButtonClick(Sender: TObject);
var
  AThread:TMyThread;
begin
  try
    AThread:=TMyThread.Create(True);
    AThread.FreeOnTerminate:=true;
    AThread.Start;
  finally
  end;
end;

procedure TMyThread.Execute;
begin
  try
    Form2.Estado_Label.Caption:='Estado: Extrayendo archivos...';
    ExtraerArchivos;
    Form2.Estado_Label.Caption:='Estado: Parcheando archivos...';
    ParchearArchivos;
    Form2.Estado_Label.Caption:='Estado: Borrando archivos temporales...';
    TDirectory.Delete(TempDirectory, True);
    Form2.Estado_Label.Caption:='Estado: Proceso finalizado.';
  finally
  end;
end;

{ TODO 1 : Añadir las comprobaciones pertientes }
{ TODO 2 : Añadir la función para arrastras y solartar archivos .zip y carpetas }
end.
