unit uRidThread;

interface

uses
  Classes;

type
  TRidThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation

uses
  uMain, BCPort, SysUtils;

const
  MaxIt = 100000; // ????????? ??? ????????

procedure TRidThread.Execute;
var
  CRC16: Word;
  ByteCount: Integer;
  RxCnt: integer;
  Count: integer;
  ta: integer; // ?????????? ??? ????????

// ============ ?????????? CRC16 ============
  procedure CalcCRC16(PBuf: PByteArray; PCRC: Pointer; BufLen: Word);
  var
    Per: Word;
    I: Byte;
    WCRC: ^Word;
    LBCRC: ^Byte;
    BufPos: Word;
  begin
    WCRC := PCRC;
    LBCRC := PCRC;
    WCRC^ := $FFFF;
    for BufPos := 0 to BufLen - 1 do
    begin
      LBCRC^ := PBuf^[BufPos] xor LBCRC^;
      for i := 0 to 7 do
      begin
        Per := WCRC^ and $0001;
        WCRC^ := WCRC^ shr 1;
        if Per = $0001 then
          WCRC^ := WCRC^ xor $A001;
      end;
    end;
  end;
// ============ / ?????????? CRC16 ============

begin
  CalcCRC16(@OutBuf, @CRC16, OutBuf[1]);
  FMain.BCP.Parity := paMark;
  FMain.BCP.Write(OutBuf[0], 1);
  if FMain.RzIni.ReadBool('Hard', 'HardPort', true) then begin
	 FMain.BCP.Close;
	 FMain.BCP.Open;
  end;
  FMain.BCP.Parity := paSpace;
  FMain.BCP.Write(OutBuf[1], OutBuf[1] - 1);
//Outbuf[10]:=StrToHex('8071'); //Outbuf[11]:=$71;
  FMain.BCP.Write(CRC16, 2);

  ByteCount := 100;   // ???? ???????????????? ??????? ???? (? ???? max 0x2? + CRC16)
  ta := MaxIt;
  RxCnt := 0;
  repeat    // ???????? ????
	 Count := FMain.BCP.InBufCount;
	 if Count > 0 then
	 begin   // ???-?? ???? ??? ?????? ?? ?????
      ta := MaxIt;
      FMain.BCP.Read(InBuf[RxCnt], Count);
      RxCnt := RxCnt + Count;
      if RxCnt > 1 then ByteCount := InBuf[1];  // ??? ???????? ??????? ???? ?????
      if RxCnt = ByteCount + 2 then   // ??? ??????? (+ 2 ??? CRC16)
      begin
        ErrCode := 0;
        Synchronize(FMain.ResParse);
        break;
      end;
    end;
	 ta := ta - 1;
	 if ta = 0 then
	 begin    // ?? ????????? (?????? ????????)
		ErrCode := 1;
      Synchronize(FMain.ResParse);
      break;
    end;
  until false;

end;

end.
