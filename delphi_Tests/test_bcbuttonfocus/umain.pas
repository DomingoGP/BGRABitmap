unit umain;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  BCButtonFocus, BCBaseCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    BCButtonFocus1: TBCButtonFocus;
    BCButtonFocus2: TBCButtonFocus;
    procedure BCButtonFocus1PaintButton(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.BCButtonFocus1PaintButton(Sender: TObject);
var
  button: TBCButtonFocus;
begin
  button := TBCButtonFocus(Sender);
  button.Canvas.Brush.Style := bsClear;
  button.Canvas.Pen.Color := clRed;
  if button.Focused then
    button.Canvas.Rectangle(3, 3, button.Width-3, button.Height-3);
end;

end.

