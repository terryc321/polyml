infix 1 |>
fun x |> f = f x

local
  open raylib
in

datatype CellState = CellLive | CellDead
fun cellnumb CellLive = 1
  | cellnumb CellDead = 0
fun cellcolo CellLive = (000, 255, 255, 255)
  | cellcolo CellDead = (100, 000, 100, 255)
fun celldraw (x, y, w, h, s, c) =
let
  val x = real(x)
  val y = real(y)
  val w = real(w)
  val h = real(h)
  val s = real(s)
  (* ese fragmento que codigo que escribi hace años que siempre se me olvida
   * como funciona pero siempre funciona, adaptado para este caso espesifico *)
  val m = if w < h then w else h
  val ox = (w-m)/2.0
  val oy = (h-m)/2.0
  val px = x/s*m
  val py = y/s*m
  val sz = m/s
  val color = cellcolo c
in
  DrawRectangle (
    ceil(ox+px),
    ceil(oy+py),
    ceil(sz),
    ceil(sz),
    color
  )
end
fun cellrand () = if GetRandomValue (0, 1) = 0
                  then CellDead
                  else CellLive

type Board = CellState Array2.array

fun count (b, x, y) =
let
  val (rows, cols) = Array2.dimensions b
  val reg = {
    base=b,
    row=if x-1 < 0 then x else x-1,
    col=if y-1 < 0 then y else y-1,
    nrows=SOME(if x=rows-1 orelse x=0 then 2 else 3),
    ncols=SOME(if y=cols-1 orelse y=0 then 2 else 3)
  }
  val cel = Array2.sub (b, x, y)
in
  (
    cel,
    (Array2.foldi Array2.RowMajor
      (fn (x, y, cel, acc) => acc+(cellnumb cel)) 0 reg) - (cellnumb cel)
  )
end

fun rule (cell, count) =
       if count = 3 andalso cell = CellDead then CellLive (*Reanimación por alguna razón*)
  else if count < 2 andalso cell = CellLive then CellDead (*Muerte por sub-población*)
  else if count > 3 andalso cell = CellLive then CellDead (*Muerte por sobre-población*)
  else cell (* en otro caso queda igual *)

fun step old_board =
let
  val s = Array2.nCols old_board
  val new_board = Array2.tabulate Array2.RowMajor
    (s, s, fn (x, y) => (old_board, x, y) |> count |> rule)
in
  new_board
end

fun render (gs as { board, size=s, ... }) =
let
  val w = GetRenderWidth ()
  val h = GetRenderHeight ()
in (
  BeginDrawing ();
  ClearBackground (0, 0, 0, 255);

  Array2.appi Array2.RowMajor
    (fn (x, y, c) => celldraw (x, y, w, h, s, c))
    { base=(!board), row=0, col=0, nrows=NONE, ncols=NONE };

  EndDrawing ();

  gs
) end

fun update (gs as { board, pause, size, ... }) =
let
in
  if not (!pause) then board := step (!board) else ();
  if IsKeyPressed KEY_SPACE = 1 then pause := not (!pause) else ();
  if IsKeyPressed KEY_R = 1 then
    board := Array2.tabulate Array2.RowMajor (size, size, (fn (x, y) => cellrand ()))
  else ();
  gs
end

fun main () =
let
  val _ = ( InitWindow (300, 300, "El juego de la vida"); SetWindowState 4; SetTargetFPS 15 )
  val size = 256
  fun loop (gamestate) =
    if WindowShouldClose () = 1
    then CloseWindow ()
    else gamestate |> update |> render |> loop
  val board = Array2.tabulate Array2.RowMajor (size, size, (fn (x, y) => cellrand ()))
in
  loop { board=ref board, size=size, pause=ref false }
end

end
