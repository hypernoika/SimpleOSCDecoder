{###############################################################################
################################################################################


               >>> SimpleOSCReader Delphi 7 Unit Demo Program <<<
                                 Version 1.0
                              -------------------
                  This example program requiere INDY9 components
    If you want to use INDY10 components, please checkout the Lazarus version
                              -------------------
           By Axel GUILLAUMET - Hypernoika - http://www.hypernoika.cc/
                            This code is GPL Licence
                              -------------------

     http://www.hypernoika.cc/en/simpleoscdecoder-for-delphi-and-lazarus/

                 http://github.com/hypernoika/SimpleOSCDecoder

################################################################################
################################################################################

								 
						                 			User guide:
							                		-----------

Web resources:
Install INDY on LAZARUS : http://wiki.freepascal.org/Indy_with_Lazarus
Last INDY version (Highly recommanded) : http://indy.fulgan.com/ 
INDY website : 	http://www.indyproject.org/								

1 - Copy SimpleOSCDecoder.pas into your project folder.
2 - In USES, declare SimpleOSCDecoder.
3 - Declare a public variable OSCMessage : TOSCMessage;
4 - On create OSCMessage := TOSCMessage.create; and on Destroy OSCMessage.free
5 - Check if your Delphi/Lazarus have the INDY Components installed
6.A) If you are using INDY9:
Put a TIdUDPSerer on a form, and put on OnUDPRead Event. 	
  OSCMessage.decodeOSCMessage(AData);	 
6.B) If you are using INDY10:
Put a TIdUDPSerer on a form, and create the OnUDPRead Event.  
Then declare a TMemoryStream as a local variable. And put this code to convert
the TIdBytes into a TMemoryStream:
  ADataStream := TMemoryStream.Create;
  ADataStream.Size := 0;
  WriteTIdBytesToStream (ADataStream, AData);
  ADataStream.Position := 0;
  OSCMessage.decodeOSCMessage(ADataStream);      
7 - Now, when you will receive an OSC message, you will get the results in the
following variables:
 > OSCMessage.Address : String -> Give the OSC complete adress
 > OSCMessage.Datatype : String -> Give you a string about the type of the last
received message: 
	'string' for string
	'integer' for integer
	'single' for single
	'untyped' for an unknown message
 > 	OSCMessage.OutString : String -> Give the last string message received
as string.
 >  OSCMessage.OutInt : Integer -> Give the last string message received
as integer.
 >  OSCMessage.OutSingle : Single -> Give the last string message received
as single.
 >  OSCMessage.OutUntyped : String -> Give the last string message received
as string.
8 - Enjoy :)

################################################################################
###############################################################################}

{SO+}

unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdUDPBase, IdUDPServer, IdSocketHandle,
  Grids, StdCtrls, ExtCtrls, clipbrd, Menus, SimpleOSCDecoder;

type
  TFormMain = class(TForm)
    IdUDPServer: TIdUDPServer;
    StringGrid: TStringGrid;
    Panel1: TPanel;
    BtnQuit: TButton;
    EditUDPPort: TEdit;
    Label1: TLabel;
    BtnStartOSCMonitoring: TButton;
    BtnAbout: TButton;
    BtnClear: TButton;
    BtnExporttotxt: TButton;
    SaveDialog1: TSaveDialog;
    PopupMenu: TPopupMenu;
    Copy1: TMenuItem;
    procedure IdUDPServerUDPRead(Sender: TObject; AData: TStream;
    ABinding: TIdSocketHandle);
    procedure FormDestroy(Sender: TObject);
    procedure BtnQuitClick(Sender: TObject);
    procedure BtnStartOSCMonitoringClick(Sender: TObject);
    procedure EditUDPPortKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure BtnExporttotxtClick(Sender: TObject);
    procedure BtnAboutClick(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure StringGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  end;

var
  FormMain: TFormMain;
  // Oscmessage Object variable declaration
  OSCMessage : TOSCMessage;

implementation

uses UFormAbout;

{$R *.dfm}

procedure SaveStringGrid(StringGrid: TStringGrid; const FileName: TFileName);
var
  f:  TextFile;
  i : Integer;
begin
  AssignFile(f, FileName);
  Rewrite(f);
  with StringGrid do
  begin
    // Loop through cells
    for i := 1 to RowCount - 2 do
        Writeln(F, Cells[0, i]+Chr(9)+Cells[1, i]+Chr(9)+Cells[2, i]);
    end;
  CloseFile(F);
end;


procedure TFormMain.IdUDPServerUDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
begin
 // Check if the UDP Received data is not null and if the IdUDPServer is activated.
  if IdUDPServer.Active and assigned(Adata) and (AData.Size > 0) and (ABinding.Handle >= 0)
    then begin
    // Receive the IdUDPServer Stream and we enter it on decodeOSCMessage.
    OSCMessage.decodeOSCMessage(AData);

    // Now we fill the StringGrid with the correponding data, with the transtypings.

    //Receive an Integer
    if OSCMessage.Datatype = 'integer'
    then begin
    // Adding row on StringGrid
    StringGrid.RowCount := StringGrid.RowCount+1;
    // Moving StringGrid on last received number if necessary
    if StringGrid.RowCount >15 then StringGrid.TopRow:= StringGrid.RowCount-14;
    stringgrid.Row := StringGrid.RowCount-2;
    BtnClear.Enabled := true;
    BtnExporttotxt.Enabled := true;
    // Filling StringGrid with the correponding variable
    StringGrid.Cells[0,StringGrid.RowCount-2] := OSCMessage.Address;
    StringGrid.Cells[1,StringGrid.RowCount-2] := OSCMessage.Datatype;
    StringGrid.Cells[2,StringGrid.RowCount-2] := inttostr(OSCMessage.OutInt);
    end;

    // Receive a String
    if OSCMessage.Datatype = 'string'
    then begin
    // Adding row on StringGrid
    StringGrid.RowCount := StringGrid.RowCount+1;
    // Moving StringGrid on last received number if necessary
    if StringGrid.RowCount >15 then StringGrid.TopRow:= StringGrid.RowCount-14;
    stringgrid.Row := StringGrid.RowCount-2;
    BtnClear.Enabled := true;
    BtnExporttotxt.Enabled := true;
    // Filling StringGrid with the correponding variable
    StringGrid.Cells[0,StringGrid.RowCount-2] := OSCMessage.Address;
    StringGrid.Cells[1,StringGrid.RowCount-2] := OSCMessage.Datatype;
    StringGrid.Cells[2,StringGrid.RowCount-2] := OSCMessage.OutString;
    end;

    // Receive a Single
    if OSCMessage.Datatype = 'single'
    then begin
    // Adding row on StringGrid
    StringGrid.RowCount := StringGrid.RowCount+1;
    // Moving StringGrid on last received number if necessary
    if StringGrid.RowCount >15 then StringGrid.TopRow:= StringGrid.RowCount-14;
    stringgrid.Row := StringGrid.RowCount-2;
    BtnClear.Enabled := true;
    BtnExporttotxt.Enabled := true;
    // Filling StringGrid with the correponding variable
    StringGrid.Cells[0,StringGrid.RowCount-2] := OSCMessage.Address;
    StringGrid.Cells[1,StringGrid.RowCount-2] := OSCMessage.Datatype;
    StringGrid.Cells[2,StringGrid.RowCount-2] := vartostr(OSCMessage.OutSingle);
    end;

    // Receive an Untyped
    if OSCMessage.Datatype = 'untyped'
    then begin
    // Adding row on StringGrid
    StringGrid.RowCount := StringGrid.RowCount+1;
    // Moving StringGrid on last received number if necessary
    if StringGrid.RowCount >15 then StringGrid.TopRow:= StringGrid.RowCount-14;
    stringgrid.Row := StringGrid.RowCount-2;
    BtnClear.Enabled := true;
    BtnExporttotxt.Enabled := true;
    // Filling StringGrid with the correponding variable    
    StringGrid.Cells[0,StringGrid.RowCount-2] := OSCMessage.Address;
    StringGrid.Cells[1,StringGrid.RowCount-2] := OSCMessage.Datatype;
    StringGrid.Cells[2,StringGrid.RowCount-2] := OSCMessage.OutUntyped;
    end;
    end;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
// Destruction of OSCMessage
OSCMessage.free;
end;

procedure TFormMain.BtnQuitClick(Sender: TObject);
begin
close;
end;

procedure TFormMain.BtnStartOSCMonitoringClick(Sender: TObject);
begin
IdUDPServer.DefaultPort := strtoint(EditUDPPort.text);
IdUDPServer.Active := true;
BtnStartOSCMonitoring.Enabled := false;
EditUDPPort.Enabled := false;
EditUDPPort.color := clBtnFace;
end;

procedure TFormMain.EditUDPPortKeyPress(Sender: TObject; var Key: Char);
begin
  // Allow only numeric enter on EditUDPPort
  if not (Key in [#8, '0'..'9']) then begin
    application.messagebox('Please enter only a number from 1 to 65535','Information',MB_ICONINFORMATION or MB_OK);
    // Discard the key
    Key := #0;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
// Creation of OSCMessage
OSCMessage := TOSCMessage.create;
// Naming the StringGrid first row (legend)
StringGrid.Cells[0,0] := 'OSC Message Address';
StringGrid.Cells[1,0] := 'Value type';
StringGrid.Cells[2,0] := 'Value';
end;

procedure TFormMain.BtnClearClick(Sender: TObject);
var i : integer;
begin
for i := 1 to StringGrid.RowCount - 1
do StringGrid.Rows[i].Clear;
StringGrid.RowCount := 2;
BtnExporttotxt.Enabled := false;
end;

procedure TFormMain.BtnExporttotxtClick(Sender: TObject);
begin
 if savedialog1.Execute then begin
    SaveStringGrid(StringGrid,savedialog1.FileName);
 end;
end;

procedure TFormMain.BtnAboutClick(Sender: TObject);
begin
FormAbout.showmodal;
end;

procedure TFormMain.Copy1Click(Sender: TObject);
begin
Clipboard.AsText  := StringGrid.Cells[0,StringGrid.Row]+' - '+StringGrid.Cells[1,StringGrid.Row]+' - '+StringGrid.Cells[2,StringGrid.Row];
end;

procedure TFormMain.StringGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var row, col: integer; 
begin 
  stringgrid.MouseToCell(X,Y,col,row);
  if (row = 0) then exit;
  stringgrid.Row := row;
  if button = mbRight then popupmenu.Popup(formmain.left+StringGrid.Left-15+x,formmain.top+StringGrid.top+15+y);
end;

end.
