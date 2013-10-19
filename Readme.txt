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