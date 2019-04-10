{ ***************************************************************************
 *                                                                          *
 *  This file is part of BGRABitmap library which is distributed under the  *
 *  modified LGPL.                                                          *
 *                                                                          *
 *  See the file COPYING.modifiedLGPL.txt, included in this distribution,   *
 *  for details about the copyright.                                        *
 *                                                                          *
 *  This program is distributed in the hope that it will be useful,         *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                    *
 *                                                                          *
 ************************* BGRABitmap library  ******************************

 - Drawing routines with transparency and antialiasing with Lazarus.
   Offers also various transforms.
 - These routines allow to manipulate 32bit images in BGRA format or RGBA
   format (depending on the platform).
 - This code is under modified LGPL (see COPYING.modifiedLGPL.txt).
   This means that you can link this library inside your programs for any purpose.
   Only the included part of the code must remain LGPL.

 - If you make some improvements to this library, please notify here:
   http://www.lazarus.freepascal.org/index.php/topic,12037.0.html

   ********************* Contact : Circular at operamail.com *******************


   ******************************* CONTRIBUTOR(S) ******************************
   - Edivando S. Santos Brasil | mailedivando@gmail.com
     (Compatibility with FPC ($Mode objfpc/delphi) and delphi VCL 11/2018)

   ***************************** END CONTRIBUTOR(S) *****************************}


unit BGRABlend;

{ This unit contains pixel blending functions. They take a destination adress as parameter,
  and draw pixels at this address with different blending modes. These functions are used
  by many functions in BGRABitmap library to do the low level drawing. }

{$i bgrabitmap.inc}{$H+}

interface

uses
  {$IFNDEF FPC}Types, GraphType, {$ENDIF} BGRATypes, BGRAGraphics, BGRABitmapTypes;

{ Draw one pixel with alpha blending }
procedure DrawPixelInlineWithAlphaCheck(dest: PBGRAPixel; const c: TBGRAPixel); {$ifdef inline}inline;{$endif} overload;
procedure DrawPixelInlineWithAlphaCheck(dest: PBGRAPixel; c: TBGRAPixel; appliedOpacity: byte); {$ifdef inline}inline;{$endif} overload;
procedure DrawExpandedPixelInlineWithAlphaCheck(dest: PBGRAPixel; const ec: TExpandedPixel); {$ifdef inline}inline;{$endif} overload;
procedure DrawPixelInlineExpandedOrNotWithAlphaCheck(dest: PBGRAPixel; const ec: TExpandedPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif} overload;  //alpha in 'c' parameter
procedure DrawPixelInlineNoAlphaCheck(dest: PBGRAPixel; const c: TBGRAPixel); {$ifdef inline}inline;{$endif} overload;
procedure DrawExpandedPixelInlineNoAlphaCheck(dest: PBGRAPixel; const ec: TExpandedPixel; calpha: byte); {$ifdef inline}inline;{$endif} overload;
procedure ClearTypeDrawPixel(pdest: PBGRAPixel; Cr, Cg, Cb: byte; Color: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure InterpolateBilinear(pUpLeft,pUpRight,pDownLeft,pDownRight: PBGRAPixel;
                iFactX,iFactY: Integer; ADest: PBGRAPixel);

procedure CopyPixelsWithOpacity(dest,src: PBGRAPixel; opacity: byte; Count: integer); {$ifdef inline}inline;{$endif}
function ApplyOpacity(opacity1,opacity2: byte): byte; {$ifdef inline}inline;{$endif}
function FastRoundDiv255(value: BGRACardinal): BGRACardinal; {$ifdef inline}inline;{$endif}

{ Draw a series of pixels with alpha blending }
procedure PutPixels(pdest: PBGRAPixel; psource: PBGRAPixel; copycount: integer; mode: TDrawMode; AOpacity:byte);
procedure DrawPixelsInline(dest: PBGRAPixel; c: TBGRAPixel; Count: integer); {$ifdef inline}inline;{$endif} overload;
procedure DrawExpandedPixelsInline(dest: PBGRAPixel; ec: TExpandedPixel; Count: integer); {$ifdef inline}inline;{$endif} overload;
procedure DrawPixelsInlineExpandedOrNot(dest: PBGRAPixel; ec: TExpandedPixel; c: TBGRAPixel; Count: integer); {$ifdef inline}inline;{$endif} overload;  //alpha in 'c' parameter

{ Draw one pixel with linear alpha blending }
procedure FastBlendPixelInline(dest: PBGRAPixel; const c: TBGRAPixel); {$ifdef inline}inline;{$endif} overload;
procedure FastBlendPixelInline(dest: PBGRAPixel; c: TBGRAPixel; appliedOpacity: byte); {$ifdef inline}inline;{$endif} overload;

{ Draw a series of pixels with linear alpha blending }
procedure FastBlendPixelsInline(dest: PBGRAPixel; c: TBGRAPixel; Count: integer); {$ifdef inline}inline;{$endif}

{ Replace a series of pixels }
procedure FillInline(dest: PBGRAPixel; c: TBGRAPixel; Count: integer); {$ifdef inline}inline;{$endif}

{ Xor a series of pixels }
procedure XorInline(dest: PBGRAPixel; c: TBGRAPixel; Count: integer); {$ifdef inline}inline;{$endif}
procedure XorPixels(pdest, psrc: PBGRAPixel; count: integer);

{ Set alpha value for a series of pixels }
procedure AlphaFillInline(dest: PBGRAPixel; alpha: byte; Count: integer); {$ifdef inline}inline;{$endif}

{ Erase a series of pixels, i.e. decrease alpha value }
procedure ErasePixelInline(dest: PBGRAPixel; alpha: byte); {$ifdef inline}inline;{$endif}

{ Draw a pixel to the extent the current pixel is close enough to compare value.
  It should not be called on pixels that have not been checked to be close enough }
procedure DrawPixelInlineDiff(dest: PBGRAPixel; c, compare: TBGRAPixel;
  maxDiff: byte); {$ifdef inline}inline;{$endif}
{ Draw a series of pixel to the extent the current pixel is close enough to compare value }
procedure DrawPixelsInlineDiff(dest: PBGRAPixel; c: TBGRAPixel;
  Count: integer; compare: TBGRAPixel; maxDiff: byte); {$ifdef inline}inline;{$endif}

{ Blend pixels with scanner content }
procedure ScannerPutPixels(scan: IBGRAScanner; pdest: PBGRAPixel; count: integer; mode: TDrawMode);

{ Perform advanced blending operation }
procedure BlendPixels(pdest: PBGRAPixel; psrc: PBGRAPixel;
  blendOp: TBlendOperation; Count: integer);

{ Perform blending operation and merge over destination }
procedure BlendPixelsOver(pdest: PBGRAPixel; psrc: PBGRAPixel;
  blendOp: TBlendOperation; Count: integer; opacity: byte; linearBlend: boolean = false);

//layer blend modes
//- http://www.pegtop.net/delphi/articles/blendmodes/
//- http://www.w3.org/TR/2009/WD-SVGCompositing-20090430/#comp-op
//- http://docs.gimp.org/en/gimp-concepts-layer-modes.html
procedure LinearMultiplyPixelInline(dest: PBGRAPixel; c: TBGRAPixel); //@{$ifdef inline}inline;{$endif}
procedure AddPixelInline(dest: PBGRAPixel; c: TBGRAPixel); //@{$ifdef inline}inline;{$endif}
procedure LinearAddPixelInline(dest: PBGRAPixel; c: TBGRAPixel); //@{$ifdef inline}inline;{$endif}
procedure ColorBurnPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure ColorDodgePixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure DividePixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure ReflectPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure NonLinearReflectPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure GlowPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure NiceGlowPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure OverlayPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure LinearOverlayPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure DifferencePixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure LinearDifferencePixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure ExclusionPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure LinearExclusionPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure LinearSubtractPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure LinearSubtractInversePixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure SubtractPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure SubtractInversePixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure NegationPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure LinearNegationPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure LightenPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure DarkenPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure ScreenPixelInline(dest: PBGRAPixel; c: TBGRAPixel); //@{$ifdef inline}inline;{$endif}
procedure SoftLightPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure SvgSoftLightPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure HardLightPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure BlendXorPixelInline(dest: PBGRAPixel; c: TBGRAPixel); {$ifdef inline}inline;{$endif}
procedure BGRAFillClearTypeMask(dest: TBGRACustomBitmap; x,y: integer; xThird: integer; mask: TBGRACustomBitmap; color: TBGRAPixel; texture: IBGRAScanner; RGBOrder: boolean);
procedure BGRAFillClearTypeRGBMask(dest: TBGRACustomBitmap; x, y: integer;
  mask: TBGRACustomBitmap; color: TBGRAPixel; texture: IBGRAScanner;
  KeepRGBOrder: boolean);
procedure BGRAFillClearTypeMaskPtr(dest: TBGRACustomBitmap; x,y: integer; xThird: integer; maskData: PByte; maskPixelSize: BGRANativeInt; maskRowSize: BGRANativeInt; maskWidth,maskHeight: integer; color: TBGRAPixel; texture: IBGRAScanner; RGBOrder: boolean);

type
  TscanNextFunc = function(): TBGRAPixel of object;

implementation

procedure BGRAFillClearTypeMaskPtr(dest: TBGRACustomBitmap; x,y: integer; xThird: integer; maskData: PByte; maskPixelSize: BGRANativeInt; maskRowSize: BGRANativeInt; maskWidth,maskHeight: integer; color: TBGRAPixel; texture: IBGRAScanner; RGBOrder: boolean);
var
  pdest: PBGRAPixel;
  ClearTypePixel: array[0..2] of byte;
  curThird: integer;

  procedure OutputPixel; //@{$ifdef inline}inline;{$endif}
  begin
    if texture <> nil then
      color := texture.ScanNextPixel;
    if RGBOrder then
      ClearTypeDrawPixel(pdest, ClearTypePixel[0],ClearTypePixel[1],ClearTypePixel[2], color)
    else
      ClearTypeDrawPixel(pdest, ClearTypePixel[2],ClearTypePixel[1],ClearTypePixel[0], color);
  end;

  procedure NextAlpha(alphaValue: byte); //@{$ifdef inline}inline;{$endif}
  begin
    ClearTypePixel[curThird] := alphaValue;
    inc(curThird);
    if curThird = 3 then
    begin
      OutputPixel;
      curThird := 0;
      Fillchar(ClearTypePixel, sizeof(ClearTypePixel),0);
      inc(pdest);
    end;
  end;

  procedure EndRow; //@{$ifdef inline}inline;{$endif}
  begin
    if curThird > 0 then OutputPixel;
  end;

var
  yMask,n: integer;
  a: byte;
  pmask: PByte;
  dx:integer;
  miny,maxy,minx,minxThird,maxx,alphaMinX,alphaMaxX,alphaLineLen: integer;
  leftOnSide, rightOnSide: boolean;
  countBetween: integer;
  v1,v2,v3: byte;

  procedure StartRow; //@{$ifdef inline}inline;{$endif}
  begin
    pdest := dest.Scanline[yMask+y]+minx;
    if texture <> nil then
      texture.ScanMoveTo(minx,yMask+y);

    curThird := minxThird;
    ClearTypePixel[0] := 0;
    ClearTypePixel[1] := 0;
    ClearTypePixel[2] := 0;
  end;

begin
  alphaLineLen := maskWidth+2;

  xThird := xThird -1; //for first subpixel

  if xThird >= 0 then dx := xThird div 3
   else dx := -((-xThird+2) div 3);
  x := x +dx;
  xThird := xThird -(dx*3);

  if y >= dest.ClipRect.Top then miny := 0
    else miny := dest.ClipRect.Top-y;
  if y+maskHeight-1 < dest.ClipRect.Bottom then
    maxy := maskHeight-1 else
      maxy := dest.ClipRect.Bottom-1-y;

  if x >= dest.ClipRect.Left then
  begin
    minx := x;
    minxThird := xThird;
    alphaMinX := 0;
    leftOnSide := false;
  end else
  begin
    minx := dest.ClipRect.Left;
    minxThird := 0;
    alphaMinX := (dest.ClipRect.Left-x)*3 - xThird;
    leftOnSide := true;
  end;

  if x*3+xThird+maskWidth-1 < dest.ClipRect.Right*3 then
  begin
    maxx := (x*3+xThird+maskWidth-1) div 3;
    alphaMaxX := alphaLineLen-1;
    rightOnSide := false;
  end else
  begin
    maxx := dest.ClipRect.Right-1;
    alphaMaxX := maxx*3+2 - (x*3+xThird);
    rightOnSide := true;
  end;

  countBetween := alphaMaxX-alphaMinX-1;

  if (alphaMinX <= alphaMaxX) then
  begin
    for yMask := miny to maxy do
    begin
      StartRow;

      if leftOnSide then
      begin
        pmask := maskData + (yMask*maskRowSize)+ (alphaMinX-1)*maskPixelSize;
        a := pmask^ div 3;
        v1 := a+a;
        v2 := a;
        v3 := 0;
        inc(pmask, maskPixelSize);
      end else
      begin
        pmask := maskData + (yMask*maskRowSize);
        v1 := 0;
        v2 := 0;
        v3 := 0;
      end;

      for n := countBetween-1 downto 0 do
      begin
        a := pmask^ div 3;
        v1 := v1 +a;
        v2 := v2 +a;
        v3 := v3 +a;
        inc(pmask, maskPixelSize);

        NextAlpha(v1);
        v1 := v2;
        v2 := v3;
        v3 := 0;
      end;

      if rightOnSide then
      begin
        a := pmask^ div 3;
        v1 := v1 +a;
        v2 := v2 +a+a;
      end;

      NextAlpha(v1);
      NextAlpha(v2);

      EndRow;
    end;
  end;
end;

procedure BGRAFillClearTypeMask(dest: TBGRACustomBitmap; x,y: integer; xThird: integer; mask: TBGRACustomBitmap; color: TBGRAPixel; texture: IBGRAScanner; RGBOrder: boolean);
var delta: BGRANativeInt;
begin
  delta := mask.Width*sizeof(TBGRAPixel);
  if mask.LineOrder = riloBottomToTop then
    delta := -delta;
  BGRAFillClearTypeMaskPtr(dest,x,y,xThird,pbyte(mask.Scanline[0])+1,sizeof(TBGRAPixel),delta,mask.Width,mask.Height,color,texture,RGBOrder);
end;

procedure BGRAFillClearTypeRGBMask(dest: TBGRACustomBitmap; x, y: integer;
  mask: TBGRACustomBitmap; color: TBGRAPixel; texture: IBGRAScanner;
  KeepRGBOrder: boolean);
var
  minx,miny,maxx,maxy,countx,n,yb: integer;
  pdest,psrc: PBGRAPixel;
begin
  if y >= dest.ClipRect.Top then miny := 0
    else miny := dest.ClipRect.Top-y;
  if y+mask.Height-1 < dest.ClipRect.Bottom then
    maxy := mask.Height-1 else
      maxy := dest.ClipRect.Bottom-1-y;

  if x >= dest.ClipRect.Left then minx := 0
    else minx := dest.ClipRect.Left-x;
  if x+mask.Width-1 < dest.ClipRect.Right then
    maxx := mask.Width-1 else
      maxx := dest.ClipRect.Right-1-x;

  countx := maxx-minx+1;
  if countx <= 0 then exit;

  for yb := miny to maxy do
  begin
    pdest := dest.Scanline[y+yb]+(x+minx);
    psrc := mask.Scanline[yb]+minx;
    if texture <> nil then
      texture.ScanMoveTo(x+minx, y+yb);
    if KeepRGBOrder then
    begin
      for n := countx-1 downto 0 do
      begin
        if texture <> nil then color := texture.ScanNextPixel;
        ClearTypeDrawPixel(pdest, psrc^.red, psrc^.green, psrc^.blue, color);
        inc(pdest);
        inc(psrc);
      end;
    end else
    begin
      for n := countx-1 downto 0 do
      begin
        if texture <> nil then color := texture.ScanNextPixel;
        ClearTypeDrawPixel(pdest, psrc^.blue, psrc^.green, psrc^.red, color);
        inc(pdest);
        inc(psrc);
      end;
    end;
  end;
end;

procedure ClearTypeDrawPixel(pdest: PBGRAPixel; Cr, Cg, Cb: byte; Color: TBGRAPixel);
var merge,mergeClearType: TBGRAPixel;
    acc: BGRAWord;
    keep,dont_keep: byte;
begin
  Cr := ApplyOpacity(Cr,color.alpha);
  Cg := ApplyOpacity(Cg,color.alpha);
  Cb := ApplyOpacity(Cb,color.alpha);
  acc := Cr+Cg+Cb;
  if acc = 0 then exit;

  merge := pdest^;
  mergeClearType.red := GammaCompressionTab[(GammaExpansionTab[merge.red] * (not byte(Cr)) +
                GammaExpansionTab[color.red] * Cr + 128) div 255];
  mergeClearType.green := GammaCompressionTab[(GammaExpansionTab[merge.green] * (not byte(Cg)) +
                GammaExpansionTab[color.green] * Cg + 128) div 255];
  mergeClearType.blue := GammaCompressionTab[(GammaExpansionTab[merge.blue] * (not byte(Cb)) +
                GammaExpansionTab[color.blue] * Cb + 128) div 255];
  mergeClearType.alpha := merge.alpha;

  if (mergeClearType.alpha = 255) then
    pdest^:= mergeClearType
  else
  begin
    if Cg <> 0 then
      DrawPixelInlineWithAlphaCheck(@merge, color, Cg);
    dont_keep := mergeClearType.alpha;
    if dont_keep > 0 then
    begin
      keep := not dont_keep;
      merge.red := GammaCompressionTab[(GammaExpansionTab[merge.red] * keep + GammaExpansionTab[mergeClearType.red] * dont_keep) div 255];
      merge.green := GammaCompressionTab[(GammaExpansionTab[merge.green] * keep + GammaExpansionTab[mergeClearType.green] * dont_keep) div 255];
      merge.blue := GammaCompressionTab[(GammaExpansionTab[merge.blue] * keep + GammaExpansionTab[mergeClearType.blue] * dont_keep) div 255];
      merge.alpha := mergeClearType.alpha + ApplyOpacity(merge.alpha, not mergeClearType.alpha);
    end;
    pdest^ := merge;
  end;
end;

procedure InterpolateBilinear(pUpLeft, pUpRight, pDownLeft,
  pDownRight: PBGRAPixel; iFactX,iFactY: Integer; ADest: PBGRAPixel);
var
  w1,w2,w3,w4,alphaW: BGRACardinal;
  rSum, gSum, bSum: BGRACardinal; //rgbDiv = aSum
  aSum, aDiv: BGRACardinal;
begin
  rSum   := 0;
  gSum   := 0;
  bSum   := 0;
  aSum   := 0;
  aDiv   := 0;

  w4 := (iFactX*iFactY+127) shr 8;
  w3 := iFactY-w4;
  {$IFDEF FPC}{$PUSH}{$ENDIF}{$HINTS OFF}
  w1 := (256-iFactX)-w3;
  {$IFDEF FPC}{$POP}{$ENDIF}
  w2 := iFactX-w4;

  { For each pixel around the coordinate, compute
    the weight for it and multiply values by it before
    adding to the sum }
  if pUpLeft <> nil then
  with pUpLeft^ do
  begin
    alphaW := alpha * w1;
    aDiv   := aDiv   +w1;
    aSum   := aSum   +alphaW;
    rSum   := rSum   +(red   * alphaW);
    gSum   := gSum   +(green * alphaW);
    bSum   := bSum   +(blue  * alphaW);
  end;
  if pUpRight <> nil then
  with pUpRight^ do
  begin
    alphaW := alpha * w2;
    aDiv   := aDiv   +w2;
    aSum   := aSum   +alphaW;
    rSum   := rSum   +(red   * alphaW);
    gSum   := gSum   +(green * alphaW);
    bSum   := bSum   +(blue  * alphaW);
  end;
  if pDownLeft <> nil then
  with pDownLeft^ do
  begin
    alphaW := alpha * w3;
    aDiv   := aDiv   +w3;
    aSum   := aSum   +alphaW;
    rSum   := rSum   +(red   * alphaW);
    gSum   := gSum   +(green * alphaW);
    bSum   := bSum   +(blue  * alphaW);
  end;
  if pDownRight <> nil then
  with pDownRight^ do
  begin
    alphaW := alpha * w4;
    aDiv   := aDiv   +w4;
    aSum   := aSum   +alphaW;
    rSum   := rSum   +(red   * alphaW);
    gSum   := gSum   +(green * alphaW);
    bSum   := bSum   +(blue  * alphaW);
  end;

  if aSum < 128 then //if there is no alpha
    ADest^ := BGRAPixelTransparent
  else
  with ADest^ do
  begin
    red   := (rSum + aSum shr 1) div aSum;
    green := (gSum + aSum shr 1) div aSum;
    blue  := (bSum + aSum shr 1) div aSum;
    if aDiv = 256 then
      alpha := (aSum + 128) shr 8
    else
      alpha := (aSum + aDiv shr 1) div aDiv;
  end;
end;

procedure ScannerPutPixels(scan: IBGRAScanner; pdest: PBGRAPixel; count: integer; mode: TDrawMode);
var c : TBGRAPixel;
  i: Integer;
  scanNextFunc : TscanNextFunc;
begin
  if scan.IsScanPutPixelsDefined then
    scan.ScanPutPixels(pdest,count,mode) else
  begin
    {$IFDEF OBJ}
    scanNextFunc := @scan.ScanNextPixel;
    {$ELSE}
    scanNextFunc := TBGRACustomBitmap(scan.GetInstance).ScanNextPixel;
    {$ENDIF}
    case mode of
      dmLinearBlend:
        for i := 0 to count-1 do
        begin
          FastBlendPixelInline(pdest, scanNextFunc());
          inc(pdest);
        end;
      dmDrawWithTransparency:
        for i := 0 to count-1 do
        begin
          DrawPixelInlineWithAlphaCheck(pdest, scanNextFunc());
          inc(pdest);
        end;
      dmSet:
        for i := 0 to count-1 do
        begin
          pdest^ := scanNextFunc();
          inc(pdest);
        end;
      dmXor:
        for i := 0 to count-1 do
        begin
          PByte(pdest)^ := PBGRADWord(pdest)^ xor BGRADWord(scanNextFunc());
          inc(pdest);
        end;
      dmSetExceptTransparent:
        for i := 0 to count-1 do
        begin
          c := scanNextFunc();
          if c.alpha = 255 then pdest^ := c;
          inc(pdest);
        end;
    end;
  end;
end;

procedure XorInline(dest: PBGRAPixel; c: TBGRAPixel; Count: integer);
begin
  while Count > 0 do
  begin
    PDWord(dest)^ := PDWord(dest)^ xor DWord(c);
    Inc(dest);
    Dec(Count);
  end;
end;


procedure XorPixels(pdest, psrc: PBGRAPixel; count: integer);
begin
  while Count > 0 do
  begin
    PDWord(pdest)^ := PDWord(psrc)^ xor PDWord(pdest)^;
    Inc(pdest);
    Inc(psrc);
    Dec(Count);
  end;
end;

{$i blendpixels.inc}

procedure AlphaFillInline(dest: PBGRAPixel; alpha: byte; Count: integer); {$ifdef inline}inline;{$endif}
begin
  while Count > 0 do
  begin
    dest^.alpha := alpha;
    Inc(dest);
    Dec(Count);
  end;
end;

procedure FillInline(dest: PBGRAPixel; c: TBGRAPixel; Count: integer);{$ifdef inline}inline;{$endif}
begin
  FillDWord(dest^, Count, longWord(c));
end;

procedure FastBlendPixelsInline(dest: PBGRAPixel; c: TBGRAPixel; Count: integer);
var
  n: integer;
begin
  if c.alpha = 0 then exit;
  for n := Count - 1 downto 0 do
  begin
    FastBlendPixelInline(dest, c);
    Inc(dest);
  end;
end;

procedure PutPixels(pdest: PBGRAPixel; psource: PBGRAPixel; copycount: integer;
  mode: TDrawMode; AOpacity: byte);
var i: integer; tempPixel: TBGRAPixel;
begin
  case mode of
    dmSet:
    begin
      if AOpacity <> 255 then
          CopyPixelsWithOpacity(pdest, psource, AOpacity, copycount)
      else
      begin
        copycount := copycount * sizeof(TBGRAPixel);
        move(psource^, pdest^, copycount);
      end;
    end;
    dmSetExceptTransparent:
    begin
        if AOpacity <> 255 then
        begin
          for i := copycount - 1 downto 0 do
          begin
            if psource^.alpha = 255 then
            begin
              tempPixel := psource^;
              tempPixel.alpha := ApplyOpacity(tempPixel.alpha,AOpacity);
              FastBlendPixelInline(pdest,tempPixel);
            end;
            Inc(pdest);
            Inc(psource);
          end;
        end else
          for i := copycount - 1 downto 0 do
          begin
            if psource^.alpha = 255 then
              pdest^ := psource^;
            Inc(pdest);
            Inc(psource);
          end;
    end;
    dmDrawWithTransparency:
    begin
        if AOpacity <> 255 then
        begin
          for i := copycount - 1 downto 0 do
          begin
            DrawPixelInlineWithAlphaCheck(pdest, psource^, AOpacity);
            Inc(pdest);
            Inc(psource);
          end;
        end
        else
          for i := copycount - 1 downto 0 do
          begin
            DrawPixelInlineWithAlphaCheck(pdest, psource^);
            Inc(pdest);
            Inc(psource);
          end;
    end;
    dmFastBlend:
    begin
        if AOpacity <> 255 then
        begin
          for i := copycount - 1 downto 0 do
          begin
            FastBlendPixelInline(pdest, psource^, AOpacity);
            Inc(pdest);
            Inc(psource);
          end;
        end else
          for i := copycount - 1 downto 0 do
          begin
            FastBlendPixelInline(pdest, psource^);
            Inc(pdest);
            Inc(psource);
          end;
    end;
    dmXor:
    begin
      if AOpacity <> 255 then
      begin
          for i := copycount - 1 downto 0 do
          begin
            FastBlendPixelInline(pdest, TBGRAPixel(PDWord(pdest)^ xor PDword(psource)^), AOpacity);
            Inc(pdest);
            Inc(psource);
          end;
      end else
          XorPixels(pdest, psource, copycount);
    end;
  end;
end;


procedure DrawPixelsInline(dest: PBGRAPixel; c: TBGRAPixel; Count: integer);
var
  n: integer;
  ec: TExpandedPixel;
begin
  if c.alpha = 0 then exit;
  if c.alpha = 255 then
  begin
    filldword(dest^,count,longword(c));
    exit;
  end;
  ec := GammaExpansion(c);
  for n := Count - 1 downto 0 do
  begin
    DrawExpandedPixelInlineNoAlphaCheck(dest, ec,c.alpha);
    Inc(dest);
  end;
end;

procedure DrawExpandedPixelsInline(dest: PBGRAPixel; ec: TExpandedPixel;
  Count: integer);
var
  n: integer;
  c: TBGRAPixel;
begin
  if ec.alpha < $0100 then exit;
  if ec.alpha >= $FF00 then
  begin
    c := GammaCompression(ec);
    filldword(dest^,count,longword(c));
    exit;
  end;
  for n := Count - 1 downto 0 do
  begin
    DrawExpandedPixelInlineNoAlphaCheck(dest, ec, ec.alpha shr 8);
    Inc(dest);
  end;
end;

procedure DrawPixelsInlineExpandedOrNot(dest: PBGRAPixel; ec: TExpandedPixel; c: TBGRAPixel; Count: integer);
var
  n: integer;
begin
  if c.alpha = 0 then exit;
  if c.alpha = 255 then
  begin
    filldword(dest^,count,longword(c));
    exit;
  end;
  for n := Count - 1 downto 0 do
  begin
    DrawExpandedPixelInlineNoAlphaCheck(dest, ec, c.alpha);
    Inc(dest);
  end;
end;

procedure DrawPixelsInlineDiff(dest: PBGRAPixel; c: TBGRAPixel;
  Count: integer; compare: TBGRAPixel; maxDiff: byte); {$ifdef inline}inline;{$endif}
var
  n: integer;
begin
  for n := Count - 1 downto 0 do
  begin
    DrawPixelInlineDiff(dest, c, compare, maxDiff);
    Inc(dest);
  end;
end;

procedure DrawPixelInlineWithAlphaCheck(dest: PBGRAPixel; const c: TBGRAPixel);
begin
  case c.alpha of
  0: ;
  255: dest^ := c;
  else
    DrawPixelInlineNoAlphaCheck(dest,c);
  end;
end;

procedure DrawPixelInlineWithAlphaCheck(dest: PBGRAPixel; c: TBGRAPixel; appliedOpacity: byte);
begin
  c.alpha := ApplyOpacity(c.alpha,appliedOpacity);
  DrawPixelInlineWithAlphaCheck(dest, c);
end;

procedure CopyPixelsWithOpacity(dest, src: PBGRAPixel; opacity: byte;
  Count: integer);
begin
  while count > 0 do
  begin
    dest^ := MergeBGRAWithGammaCorrection(src^,opacity,dest^,not opacity);
    inc(src);
    inc(dest);
    dec(count);
  end;
end;

function ApplyOpacity(opacity1, opacity2: byte): byte;
begin
  result := opacity1*(opacity2+1) shr 8;
end;

function FastRoundDiv255(value: BGRACardinal): BGRACardinal; {$ifdef inline}inline;{$endif}
begin
  result := (value + (value shr 7)) shr 8;
end;

procedure DrawExpandedPixelInlineWithAlphaCheck(dest: PBGRAPixel; const ec: TExpandedPixel);
var
  calpha: byte;
begin
  calpha := ec.alpha shr 8;
  case calpha of
  0: ;
  255: dest^ := GammaCompression(ec);
  else
    DrawExpandedPixelInlineNoAlphaCheck(dest,ec,calpha);
  end;
end;

procedure DrawPixelInlineExpandedOrNotWithAlphaCheck(dest: PBGRAPixel; const ec: TExpandedPixel; c: TBGRAPixel);
begin
  case c.alpha of
  0: ;
  255: dest^ := c;
  else
    DrawExpandedPixelInlineNoAlphaCheck(dest,ec,c.alpha);
  end;
end;

procedure DrawPixelInlineNoAlphaCheck(dest: PBGRAPixel; const c: TBGRAPixel);
var
  a1f, a2f, a12, a12m, alphaCorr: NativeUInt;
begin
  case dest^.alpha of
    0: dest^ := c;
    255:
      begin
        alphaCorr := c.alpha;
        if alphaCorr >= 128 then alphaCorr := alphaCorr + 1;
        dest^.red := GammaCompressionTab[(GammaExpansionTab[dest^.red] * NativeUInt(256-alphaCorr) + GammaExpansionTab[c.red]*alphaCorr) shr 8];
        dest^.green := GammaCompressionTab[(GammaExpansionTab[dest^.green] * NativeUInt(256-alphaCorr) + GammaExpansionTab[c.green]*alphaCorr) shr 8];
        dest^.blue := GammaCompressionTab[(GammaExpansionTab[dest^.blue] * NativeUInt(256-alphaCorr) + GammaExpansionTab[c.blue]*alphaCorr) shr 8];
      end;
    else
    begin
      {$HINTS OFF}
      a12  := 65025 - (not dest^.alpha) * (not c.alpha);
      {$HINTS ON}
      a12m := a12 shr 1;

      a1f := dest^.alpha * (not c.alpha);
      a2f := (c.alpha shl 8) - c.alpha;

      PDWord(dest)^ := ((GammaCompressionTab[(GammaExpansionTab[dest^.red] * a1f +
                         GammaExpansionTab[c.red] * a2f + a12m) div a12]) shl TBGRAPixel_RedShift) or
                       ((GammaCompressionTab[(GammaExpansionTab[dest^.green] * a1f +
                         GammaExpansionTab[c.green] * a2f + a12m) div a12]) shl TBGRAPixel_GreenShift) or
                       ((GammaCompressionTab[(GammaExpansionTab[dest^.blue] * a1f +
                         GammaExpansionTab[c.blue] * a2f + a12m) div a12]) shl TBGRAPixel_BlueShift) or
                       (((a12 + a12 shr 7) shr 8) shl TBGRAPixel_AlphaShift);
    end;
  end;
end;

procedure DrawExpandedPixelInlineNoAlphaCheck(dest: PBGRAPixel;
  const ec: TExpandedPixel; calpha: byte);
var
  a1f, a2f, a12, a12m, alphaCorr: NativeUInt;
begin
  case dest^.alpha of
    0: begin
         dest^.red := GammaCompressionTab[ec.red];
         dest^.green := GammaCompressionTab[ec.green];
         dest^.blue := GammaCompressionTab[ec.blue];
         dest^.alpha := calpha;
      end;
    255:
      begin
        alphaCorr := calpha;
        if alphaCorr >= 128 then alphaCorr := alphaCorr + 1;
        dest^.red := GammaCompressionTab[(GammaExpansionTab[dest^.red] * NativeUInt(256-alphaCorr) + ec.red*alphaCorr) shr 8];
        dest^.green := GammaCompressionTab[(GammaExpansionTab[dest^.green] * NativeUInt(256-alphaCorr) + ec.green*alphaCorr) shr 8];
        dest^.blue := GammaCompressionTab[(GammaExpansionTab[dest^.blue] * NativeUInt(256-alphaCorr) + ec.blue*alphaCorr) shr 8];
      end;
    else
    begin
      {$HINTS OFF}
      a12  := 65025 - (not dest^.alpha) * (not calpha);
      {$HINTS ON}
      a12m := a12 shr 1;

      a1f := dest^.alpha * (not calpha);
      a2f := (calpha shl 8) - calpha;

      PDWord(dest)^ := ((GammaCompressionTab[(GammaExpansionTab[dest^.red] * a1f +
                         ec.red * a2f + a12m) div a12]) shl TBGRAPixel_RedShift) or
                       ((GammaCompressionTab[(GammaExpansionTab[dest^.green] * a1f +
                         ec.green * a2f + a12m) div a12]) shl TBGRAPixel_GreenShift) or
                       ((GammaCompressionTab[(GammaExpansionTab[dest^.blue] * a1f +
                         ec.blue * a2f + a12m) div a12]) shl TBGRAPixel_BlueShift) or
                       (((a12 + a12 shr 7) shr 8) shl TBGRAPixel_AlphaShift);
    end;
  end;
end;

procedure FastBlendPixelInline(dest: PBGRAPixel; const c: TBGRAPixel);
var
  a1f, a2f, a12, a12m, alphaCorr: NativeUInt;
begin
  case c.alpha of
    0: ;
    255: dest^ := c;
    else
    begin
      case dest^.alpha of
        0: dest^ := c;
        255:
        begin
          alphaCorr := c.alpha;
          if alphaCorr >= 128 then alphaCorr := alphaCorr + 1;
          dest^.red := (dest^.red * NativeUInt(256-alphaCorr) + c.red*(alphaCorr+1)) shr 8;
          dest^.green := (dest^.green * NativeUInt(256-alphaCorr) + c.green*(alphaCorr+1)) shr 8;
          dest^.blue := (dest^.blue * NativeUInt(256-alphaCorr) + c.blue*(alphaCorr+1)) shr 8;
        end;
        else
        begin
          {$HINTS OFF}
          a12  := 65025 - (not dest^.alpha) * (not c.alpha);
          {$HINTS ON}
          a12m := a12 shr 1;

          a1f := dest^.alpha * (not c.alpha);
          a2f := (c.alpha shl 8) - c.alpha;

          PDWord(dest)^ := (((dest^.red * a1f + c.red * a2f + a12m) div a12) shl TBGRAPixel_RedShift) or
                           (((dest^.green * a1f + c.green * a2f + a12m) div a12) shl TBGRAPixel_GreenShift) or
                           (((dest^.blue * a1f + c.blue * a2f + a12m) div a12) shl TBGRAPixel_BlueShift) or
                           (((a12 + a12 shr 7) shr 8) shl TBGRAPixel_AlphaShift);
        end;
      end;
    end;
  end;
end;

procedure FastBlendPixelInline(dest: PBGRAPixel; c: TBGRAPixel;
  appliedOpacity: byte);
begin
  c.alpha := ApplyOpacity(c.alpha,appliedOpacity);
  FastBlendPixelInline(dest,c);
end;

procedure DrawPixelInlineDiff(dest: PBGRAPixel; c, compare: TBGRAPixel;
  maxDiff: byte); {$ifdef inline}inline;{$endif}
var alpha: BGRANativeInt;
    c2: TBGRAPixel;
begin
  alpha := (c.alpha * (maxDiff + 1 - BGRADiff(dest^, compare)) + (maxDiff + 1) shr 1) div
    (maxDiff + 1);
  if alpha > 0 then
  begin
    c2 := BGRA(c.red, c.green, c.blue, alpha);
    DrawPixelInlineWithAlphaCheck(dest, c2);
  end;
end;

procedure ErasePixelInline(dest: PBGRAPixel; alpha: byte); {$ifdef inline}inline;{$endif}
var
  newAlpha: byte;
begin
  newAlpha := ApplyOpacity(dest^.alpha, not alpha);
  if newAlpha = 0 then
    dest^ := BGRAPixelTransparent
  else
    dest^.alpha := newAlpha;
end;

{$i blendpixelsover.inc}

{$i blendpixelinline.inc}

end.

