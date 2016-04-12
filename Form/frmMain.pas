// 全屏鼠标画框
// 原理是全屏最顶一个半透明的窗体，然后鼠标在上面画框
// 上下箭头键：更改透明度
// 左右箭头键：更改笔的粗细

unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts, StdCtrls;

type
  TMainForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    m_MousePt, m_OldPt: TPoint;
    m_IsDrawing: Boolean;
    m_X1, m_X2, m_Y1, m_Y2: Integer;
    m_PenWidth: Integer;
    m_IsDebug: Boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := True;

  m_IsDebug := False;
  self.AlphaBlendValue := 60;
  m_IsDrawing := False;
  m_PenWidth := 20;

  if not m_IsDebug then begin
    Self.Width := GetSystemMetrics(SM_CXSCREEN);
    self.Height := GetSystemMetrics(SM_CYSCREEN);
  end;
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  // ESC: Quit
  // c  : Clear

  if Key = #27 then Application.Terminate
  else if key = 'c' then begin
    m_X2 := m_X1;
    m_Y2 := m_Y1;
    Invalidate;
  end;
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
const
  ALPHA_DELTA = 5;
  WIDTH_DELTA = 2;
begin
  // Up   : Alpha ++
  // Down : Alpha --
  // Left : Pen Width --
  // Right: Pen Width ++

  if Key = VK_UP then begin
    Self.AlphaBlendValue := Self.AlphaBlendValue + ALPHA_DELTA;
    if Self.AlphaBlendValue >= 255 then Self.AlphaBlendValue := 255;
  end else if Key = VK_DOWN then begin
    Self.AlphaBlendValue := Self.AlphaBlendValue - ALPHA_DELTA;
    if Self.AlphaBlendValue <= 0 then Self.AlphaBlendValue := 0;
  end else if Key = VK_LEFT then begin
    m_PenWidth := m_PenWidth - WIDTH_DELTA;
    if m_PenWidth <= WIDTH_DELTA then m_PenWidth := WIDTH_DELTA;
  end else if Key = VK_RIGHT then begin
    m_PenWidth := m_PenWidth + WIDTH_DELTA;
    if m_PenWidth >= (Self.Width div 10) then m_PenWidth := (Self.Width div 10);
  end;

  // Update screen
  Invalidate;
end;

procedure TMainForm.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  m_IsDrawing := True;

  m_X1 := X;
  m_Y1 := Y;
end;

procedure TMainForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if m_IsDrawing then begin
    m_X2 := X;
    m_Y2 := Y;
  end;

  // Update screen
  Invalidate;
end;

procedure TMainForm.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  m_IsDrawing := False;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  with Self.Canvas do begin
    Pen.Color := clRed;
    Pen.Width := m_PenWidth;
    Rectangle(m_X1, m_Y1, m_X2, m_Y2);
  end;
end;

end.

