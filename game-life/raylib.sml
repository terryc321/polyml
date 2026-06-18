structure raylib =
struct
  local
    open Foreign
    val sym = Foreign.getSymbol (Foreign.loadLibrary "/usr/local/lib/libraylib.so")
  in
    val InitWindow = buildCall3 (sym "InitWindow", (cInt, cInt, cString), cVoid)
    val SetWindowState = buildCall1 (sym "SetWindowState", (cUint), cVoid)
    val WindowShouldClose = buildCall0 (sym "WindowShouldClose", (), cInt)
    val CloseWindow = buildCall0 (sym "CloseWindow", (), cVoid)
    val SetTargetFPS = buildCall1 (sym "SetTargetFPS", (cInt), cVoid)
    val CloseWindow = buildCall0 (sym "CloseWindow", (), cVoid)
    val BeginDrawing = buildCall0 (sym "BeginDrawing", (), cVoid)
    val EndDrawing = buildCall0 (sym "EndDrawing", (), cVoid)
    val Color = cStruct4 (cUint8, cUint8, cUint8, cUint8)
    val Texture = cStruct5 (cUint, cInt, cInt, cInt, cInt)
    val Font = cStruct6 (cInt, cInt, cInt, Texture, cPointer, cPointer)
    val ClearBackground = buildCall1 (sym "ClearBackground", (Color), cVoid)
    val GetRenderWidth = buildCall0 (sym "GetRenderWidth", (), cInt)
    val GetRenderHeight = buildCall0 (sym "GetRenderHeight", (), cInt)
    val DrawFPS = buildCall2 (sym "DrawFPS", (cInt, cInt), cVoid)
    val DrawRectangle = buildCall5 (sym "DrawRectangle", (cInt, cInt, cInt, cInt, Color), cVoid)
    val GetRandomValue = buildCall2 (sym "GetRandomValue", (cInt, cInt), cInt)
    val IsKeyPressed = buildCall1 (sym "IsKeyPressed", (cInt), cInt)
    val KEY_SPACE = 32
    val KEY_R = 82
  end
end
