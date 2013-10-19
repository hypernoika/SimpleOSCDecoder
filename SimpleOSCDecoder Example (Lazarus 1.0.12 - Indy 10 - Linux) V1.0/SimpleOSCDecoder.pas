{###############################################################################
################################################################################


                  >>> SimpleOSCReader Delphi FPC Lazarus UNIT <<<
                                  Version 1.0
                              -------------------
                This unit requiere INDY9 or 10 components
    If you want to use INDY10 components, please checkout the Lazarus version
                              -------------------
           By Axel GUILLAUMET - Hypernoika - http://www.hypernoika.cc/
                            This code is GPL Licence
                              -------------------
                  Feel free to use this unit in your software
				  
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

NB : Don't forget to include the Indy library path into the project options.

################################################################################
###############################################################################}

unit SimpleOSCDecoder;

interface

uses Classes, SysUtils;

type
  TOSCMessage = class (TObject)
  public
    Address : string;
    Datatype : string;
    OutString: string;
    OutUntyped : string;
    OutInt: integer;
    OutSingle: single;
    procedure decodeOSCMessage(AData : TStream);
  end;

implementation

function ReadOSCString(AData:TStream):string;
var
  s: String;
  a: array[1..4] of byte;
  i,j : integer;
  endfound : boolean;
begin
  endfound := false;
  s := '';
  repeat
    j := AData.Read(a,4);
    for i := 1 to j do
      if a[i] > 0
        then s := s+chr(a[i])
        else endfound := true;
    until endfound or (j < 4);
  result := s;
end;

function ReadOSCLong(AData:TStream):int64;
var
  a,b: array[1..8] of byte;
  i,j : integer;
begin
  j := AData.Read(a,8);
  for i := 1 to j do b[9-i] := a[i];
  result := int64(b);
end;

function ReadOSCInt(AData:TStream):integer;
var
  a,b: array[1..4] of byte;
  i,j : integer;
begin
  for i := 1 to 4 do b[i] := 0;
  j := AData.Read(a,4);
  for i := 1 to j do b[5-i] := a[i];
  result := integer(b);
end;

function ReadOSCSingle(AData:TStream):single;
var
  a,b: array[1..4] of byte;
  i,j : integer;
begin
  j := AData.Read(a,4);
  for i := 1 to j do b[5-i] := a[i];
  result := single(b);
end;

procedure TOSCMessage.decodeOSCMessage(AData : TStream);
var
  adr,s,ss: String;
  fbundle : boolean;
  i,j,k : integer;
  a : byte;
begin
    s := ReadOSCString(AData);
    fbundle := s = '#bundle';
      if fBundle
        then begin
            k := ReadOscInt(AData);
            adr := ReadOSCString(AData);
        end else begin
          adr := s;
          k := 1;
        end;
      while k > 0
       do begin
        s := ReadOSCString(AData);
        if (s>'')
        then begin
          if (s[1] = ',')
          then begin
            for i := 2 to length(s) do
              case char(s[i]) of
                'f' : begin
                        outsingle := ReadOSCSingle(AData);
                        datatype := 'single';
                        address := adr;
                      end;
                'i' : begin
                        outint := ReadOSCInt(AData);
                        datatype := 'integer';
                        address := adr;
                      end;
                's' : begin
                        outstring := ReadOSCString(AData);
                        datatype := 'string';
                        address := adr;
                      end
              end;
          end else begin
            ss := '';
            for i := 1 to length(s) do
              ss := ss+inttohex(ord(s[i]),2)+' ';
            ss := ss+ '00 ';
            for i := Adata.Position to AData.Size-1 do
            begin
              j := AData.Read(a,1);
              if j > 0 then ss := ss+inttohex(a,2)+' ';
            end;
            OutUntyped := ss;
            datatype := 'Untyped';
          end
        end;
          if fBundle
        then begin
          k := ReadOscInt(AData);
        end else
          k := 0;
    end;
end;

end.
