unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FileCtrl, Vcl.StdCtrls, StrUtils;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    procedure Edit1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
type TChannel = Record
  Group    : string[100];
  Title    : string[100];
  TVGShift : integer;
  Address  : string[255];
  Favorite : integer;
end;
var Channels : array of TChannel;
var Buf: TChannel;

var List1, List2: TStringList;
var I, J, nTmp1, nTmp2, nShift: Integer;
var sTmp: String;
begin
  if Length(Edit1.Text)=0 then Exit;
  begin
    try
      List1 := TStringList.Create;
      List2 := TStringList.Create;
      List1.LoadFromFile(Edit1.Text);
      List2.Clear;
      //List2.Add('');

      I := 0;
      while I < List1.Count do
      begin
        //if pos('#EXTINF:',List1[I])=0 then List2.Add(List1[I]);

        //Найден очередной канал
        if pos('#EXTINF:',List1[I])>0 then
        begin
          SetLength(Channels, Length(Channels)+1);

          sTmp := '';
          nTmp1 := pos('group-title="',List1[I]);
          if nTmp1>0 then
          begin
            nTmp2 := PosEX('"',List1[I], nTmp1+13);
            if nTmp2=0 then
              Raise Exception.Create('ОШИБКА в строке '+IntToStr(I)+', не удалось выделить значение group-title')
            else
              sTmp := Copy(List1[I], nTmp1+13, nTmp2-nTmp1-13);
          end
          else Raise Exception.Create('ОШИБКА в строке '+IntToStr(I)+', нет тега group-title');
          Channels[Length(Channels)-1].Group := sTmp;

          sTmp := '';
          nTmp1 := pos(',',List1[I]);
          sTmp := Copy(List1[I], nTmp1+1, Length(List1[I])-nTmp1);
          Channels[Length(Channels)-1].Title := sTmp;

          //Возможно признак сдвига программы
          nShift := 0;
          sTmp := '';
          nTmp1 := pos('+',Channels[Length(Channels)-1].Title);
          if nTmp1>0 then
          begin
            sTmp := Copy(Channels[Length(Channels)-1].Title, nTmp1+1, Length(Channels[Length(Channels)-1].Title)-nTmp1);
            if Length(sTmp)>0 then
            begin
              try
                nShift := StrToInt(sTmp);
              except
                nShift := 0;
              end;
            end;
          end;
          Channels[Length(Channels)-1].TVGShift := nShift;

          Inc(I);
          Channels[Length(Channels)-1].Address := List1[I];

          if Channels[Length(Channels)-1].Group='XXX' then SetLength(Channels, Length(Channels)-1);

          Channels[Length(Channels)-1].Favorite := 0;
          sTmp := AnsiLowerCase(Channels[Length(Channels)-1].Title);
          if pos('первый',sTmp)>0 then Channels[Length(Channels)-1].Favorite := 100;
          if pos('россия',sTmp)>0 then Channels[Length(Channels)-1].Favorite := 99;
          if pos('стс',sTmp)>0 then Channels[Length(Channels)-1].Favorite := 98;
          if pos('домашний',sTmp)>0 then Channels[Length(Channels)-1].Favorite := 97;
          if pos('рен тв',sTmp)>0 then Channels[Length(Channels)-1].Favorite := 96;
          if pos('перец',sTmp)>0 then Channels[Length(Channels)-1].Favorite := 95;
          if pos('кино',sTmp)>0 then Channels[Length(Channels)-1].Favorite := 94;
          if pos('cbs',sTmp)>0 then Channels[Length(Channels)-1].Favorite := 93;
          if pos('нтв',sTmp)>0 then Channels[Length(Channels)-1].Favorite := 92;
          if pos('комед',sTmp)>0 then Channels[Length(Channels)-1].Favorite := 91;
          if pos('сери',sTmp)>0 then Channels[Length(Channels)-1].Favorite := 90;
          if pos('иллюзион',sTmp)>0 then Channels[Length(Channels)-1].Favorite := 89;

        end;
        Inc(I);
      end;


      // Сортируем по алфавиту
      For I := Low(Channels) To High(Channels)-1 Do
        For J := I + 1 To High(Channels) Do
        Begin
          If Channels[i].Group = Channels[J].Group Then
          Begin
            If Channels[i].Title > Channels[J].Title Then
            Begin
              Buf := Channels[i];
              Channels[i] := Channels[J];
              Channels[J] := Buf;
            End;
          End
          Else
            If Channels[i].Group > Channels[J].Group Then
            Begin
              Buf := Channels[i];
              Channels[i] := Channels[J];
              Channels[J] := Buf;
            End;
        End;

      // Убираем дубли
      I := Low(Channels);
      nTmp1 := High(Channels);
      while I < nTmp1 Do
      begin
        while (Channels[I].Title = Channels[I+1].Title) and (I < nTmp1) do
        Begin
            if Channels[I+1].Address > Channels[I].Address then Channels[I].Address := Channels[I+1].Address;
            For J := I+1 To High(Channels)-1 Do Channels[J] := Channels[J+1];
            SetLength(Channels, Length(Channels)-1);
            Dec(nTmp1);
        End;
        Inc(I);
      end;

      // Сортируем по предпочтениям
      For I := Low(Channels) To High(Channels)-1 Do
        For J := I + 1 To High(Channels) Do
        Begin
          If Channels[i].Group = Channels[J].Group Then
          Begin
            If Channels[i].Favorite < Channels[J].Favorite Then
            Begin
              Buf := Channels[i];
              Channels[i] := Channels[J];
              Channels[J] := Buf;
            End;
          End
          Else
            If Channels[i].Group > Channels[J].Group Then
            Begin
              Buf := Channels[i];
              Channels[i] := Channels[J];
              Channels[J] := Buf;
            End;
        End;

      List2.Clear;
      List2.Add('#EXTM3U');
      for I := Low(Channels) to High(Channels) do
      begin
        sTmp := '#EXTINF:-1 group-title="' + Channels[I].Group + '"';
        if Channels[I].TVGShift>0 then sTmp := sTmp + ' tvg-shift=-'+IntToStr(Channels[I].TVGShift);
        sTmp := sTmp + ',' + Channels[I].Title;
        List2.Add(UTF8EncodeToShortString(sTmp));
        List2.Add(Channels[I].Address);
      end;
      List2.SaveToFile(ExtractFileDir(Edit1.Text)+'converted.m3u');

    finally
      FreeAndNil(List1);
      FreeAndNil(List2);
    end;
  end;
  ShowMessage('Готово');
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then Edit1.Text := OpenDialog1.FileName;
end;

end.
