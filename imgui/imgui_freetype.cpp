// Fix for stb_rect_pack
#undef STB_RECT_PACK_IMPLEMENTATION
#include "imconfig.h"
#include "misc/freetype/imgui_freetype.cpp"
#define STB_RECT_PACK_IMPLEMENTATION 1
