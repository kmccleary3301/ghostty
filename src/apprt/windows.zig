const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;
const windows = std.os.windows;

const internal_os = @import("../os/main.zig");
const apprt = @import("../apprt.zig");
const configpkg = @import("../config.zig");
const input = @import("../input.zig");
const CoreApp = @import("../App.zig");
const CoreSurface = @import("../Surface.zig");
const Config = configpkg.Config;

const HWND = windows.HWND;
const HINSTANCE = windows.HINSTANCE;
const UINT = windows.UINT;
const WPARAM = windows.WPARAM;
const LPARAM = windows.LPARAM;
const LRESULT = windows.LRESULT;
const HCURSOR = windows.HCURSOR;
const HICON = windows.HICON;
const HBRUSH = windows.HBRUSH;
const HDC = windows.HDC;
const HGLRC = windows.HGLRC;
const HMODULE = windows.HMODULE;
const FARPROC = windows.FARPROC;
const HANDLE = windows.HANDLE;
const HIMC = HANDLE;

const CS_VREDRAW: u32 = 0x0001;
const CS_HREDRAW: u32 = 0x0002;
const WS_OVERLAPPEDWINDOW: u32 = 0x00CF0000;
const WS_VISIBLE: u32 = 0x10000000;
const CW_USEDEFAULT: i32 = -2147483648;
const SW_SHOW: i32 = 5;
const WM_CLOSE: UINT = 0x0010;
const WM_SIZE: UINT = 0x0005;
const WM_DESTROY: UINT = 0x0002;
const WM_NCCREATE: UINT = 0x0081;
const WM_SETFOCUS: UINT = 0x0007;
const WM_KILLFOCUS: UINT = 0x0008;
const WM_KEYDOWN: UINT = 0x0100;
const WM_KEYUP: UINT = 0x0101;
const WM_SYSKEYDOWN: UINT = 0x0104;
const WM_SYSKEYUP: UINT = 0x0105;
const WM_CHAR: UINT = 0x0102;
const WM_DEADCHAR: UINT = 0x0103;
const WM_SYSCHAR: UINT = 0x0106;
const WM_SYSDEADCHAR: UINT = 0x0107;
const WM_UNICHAR: UINT = 0x0109;
const WM_IME_STARTCOMPOSITION: UINT = 0x010D;
const WM_IME_ENDCOMPOSITION: UINT = 0x010E;
const WM_IME_COMPOSITION: UINT = 0x010F;
const WM_GHOSTTY_TICK: UINT = 0x8000 + 1;
const WM_MOUSEMOVE: UINT = 0x0200;
const WM_LBUTTONDOWN: UINT = 0x0201;
const WM_LBUTTONUP: UINT = 0x0202;
const WM_RBUTTONDOWN: UINT = 0x0204;
const WM_RBUTTONUP: UINT = 0x0205;
const WM_MBUTTONDOWN: UINT = 0x0207;
const WM_MBUTTONUP: UINT = 0x0208;
const WM_MOUSEWHEEL: UINT = 0x020a;
const WM_MOUSEHWHEEL: UINT = 0x020e;
const GWLP_USERDATA: i32 = -21;
const CF_UNICODETEXT: u32 = 13;
const GMEM_MOVEABLE: u32 = 0x0002;
const GCS_COMPSTR: u32 = 0x0008;
const GCS_RESULTSTR: u32 = 0x0800;
const PFD_DOUBLEBUFFER: u32 = 0x00000001;
const PFD_DRAW_TO_WINDOW: u32 = 0x00000004;
const PFD_SUPPORT_OPENGL: u32 = 0x00000020;
const PFD_TYPE_RGBA: u8 = 0;
const PFD_MAIN_PLANE: u8 = 0;
const WGL_CONTEXT_MAJOR_VERSION_ARB: i32 = 0x2091;
const WGL_CONTEXT_MINOR_VERSION_ARB: i32 = 0x2092;
const WGL_CONTEXT_FLAGS_ARB: i32 = 0x2094;
const WGL_CONTEXT_PROFILE_MASK_ARB: i32 = 0x9126;
const WGL_CONTEXT_CORE_PROFILE_BIT_ARB: i32 = 0x00000001;
const IDC_ARROW: ?[*:0]const u16 = @ptrFromInt(@as(usize, 32512));
const VK_SHIFT: u32 = 0x10;
const VK_CONTROL: u32 = 0x11;
const VK_MENU: u32 = 0x12;
const VK_CAPITAL: u32 = 0x14;
const VK_ESCAPE: u32 = 0x1b;
const VK_SPACE: u32 = 0x20;
const VK_PRIOR: u32 = 0x21;
const VK_NEXT: u32 = 0x22;
const VK_END: u32 = 0x23;
const VK_HOME: u32 = 0x24;
const VK_LEFT: u32 = 0x25;
const VK_UP: u32 = 0x26;
const VK_RIGHT: u32 = 0x27;
const VK_DOWN: u32 = 0x28;
const VK_INSERT: u32 = 0x2d;
const VK_DELETE: u32 = 0x2e;
const VK_LWIN: u32 = 0x5b;
const VK_RWIN: u32 = 0x5c;
const VK_APPS: u32 = 0x5d;
const VK_NUMPAD0: u32 = 0x60;
const VK_NUMPAD1: u32 = 0x61;
const VK_NUMPAD2: u32 = 0x62;
const VK_NUMPAD3: u32 = 0x63;
const VK_NUMPAD4: u32 = 0x64;
const VK_NUMPAD5: u32 = 0x65;
const VK_NUMPAD6: u32 = 0x66;
const VK_NUMPAD7: u32 = 0x67;
const VK_NUMPAD8: u32 = 0x68;
const VK_NUMPAD9: u32 = 0x69;
const VK_MULTIPLY: u32 = 0x6a;
const VK_ADD: u32 = 0x6b;
const VK_SEPARATOR: u32 = 0x6c;
const VK_SUBTRACT: u32 = 0x6d;
const VK_DECIMAL: u32 = 0x6e;
const VK_DIVIDE: u32 = 0x6f;
const VK_F1: u32 = 0x70;
const VK_F24: u32 = 0x87;
const VK_NUMLOCK: u32 = 0x90;
const VK_SCROLL: u32 = 0x91;
const VK_LSHIFT: u32 = 0xa0;
const VK_RSHIFT: u32 = 0xa1;
const VK_LCONTROL: u32 = 0xa2;
const VK_RCONTROL: u32 = 0xa3;
const VK_LMENU: u32 = 0xa4;
const VK_RMENU: u32 = 0xa5;
const VK_BROWSER_BACK: u32 = 0xa6;
const VK_BROWSER_FORWARD: u32 = 0xa7;
const VK_BROWSER_REFRESH: u32 = 0xa8;
const VK_BROWSER_STOP: u32 = 0xa9;
const VK_BROWSER_SEARCH: u32 = 0xaa;
const VK_BROWSER_FAVORITES: u32 = 0xab;
const VK_BROWSER_HOME: u32 = 0xac;
const VK_VOLUME_MUTE: u32 = 0xad;
const VK_VOLUME_DOWN: u32 = 0xae;
const VK_VOLUME_UP: u32 = 0xaf;
const VK_MEDIA_NEXT_TRACK: u32 = 0xb0;
const VK_MEDIA_PREV_TRACK: u32 = 0xb1;
const VK_MEDIA_STOP: u32 = 0xb2;
const VK_MEDIA_PLAY_PAUSE: u32 = 0xb3;
const VK_LAUNCH_MAIL: u32 = 0xb4;
const VK_LAUNCH_MEDIA_SELECT: u32 = 0xb5;
const VK_LAUNCH_APP1: u32 = 0xb6;
const VK_LAUNCH_APP2: u32 = 0xb7;
const VK_OEM_1: u32 = 0xba;
const VK_OEM_PLUS: u32 = 0xbb;
const VK_OEM_COMMA: u32 = 0xbc;
const VK_OEM_MINUS: u32 = 0xbd;
const VK_OEM_PERIOD: u32 = 0xbe;
const VK_OEM_2: u32 = 0xbf;
const VK_OEM_3: u32 = 0xc0;
const VK_OEM_4: u32 = 0xdb;
const VK_OEM_5: u32 = 0xdc;
const VK_OEM_6: u32 = 0xdd;
const VK_OEM_7: u32 = 0xde;
const VK_OEM_8: u32 = 0xdf;
const VK_OEM_102: u32 = 0xe2;
const VK_PROCESSKEY: u32 = 0xe5;
const VK_PACKET: u32 = 0xe7;
const UNICODE_NOCHAR: u32 = 0xFFFF;

const WNDPROC = *const fn (HWND, UINT, WPARAM, LPARAM) callconv(.winapi) LRESULT;

const WNDCLASSEXW = extern struct {
    cbSize: u32,
    style: u32,
    lpfnWndProc: ?WNDPROC,
    cbClsExtra: i32,
    cbWndExtra: i32,
    hInstance: HINSTANCE,
    hIcon: ?HICON,
    hCursor: ?HCURSOR,
    hbrBackground: ?HBRUSH,
    lpszMenuName: ?[*:0]const u16,
    lpszClassName: ?[*:0]const u16,
    hIconSm: ?HICON,
};

const CREATESTRUCTW = extern struct {
    lpCreateParams: ?*anyopaque,
    hInstance: HINSTANCE,
    hMenu: ?windows.HMENU,
    hwndParent: HWND,
    cy: i32,
    cx: i32,
    y: i32,
    x: i32,
    style: i32,
    lpszName: ?[*:0]const u16,
    lpszClass: ?[*:0]const u16,
    dwExStyle: u32,
};

const PIXELFORMATDESCRIPTOR = extern struct {
    nSize: u16,
    nVersion: u16,
    dwFlags: u32,
    iPixelType: u8,
    cColorBits: u8,
    cRedBits: u8,
    cRedShift: u8,
    cGreenBits: u8,
    cGreenShift: u8,
    cBlueBits: u8,
    cBlueShift: u8,
    cAlphaBits: u8,
    cAlphaShift: u8,
    cAccumBits: u8,
    cAccumRedBits: u8,
    cAccumGreenBits: u8,
    cAccumBlueBits: u8,
    cAccumAlphaBits: u8,
    cDepthBits: u8,
    cStencilBits: u8,
    cAuxBuffers: u8,
    iLayerType: u8,
    bReserved: u8,
    dwLayerMask: u32,
    dwVisibleMask: u32,
    dwDamageMask: u32,
};

const WglCreateContextAttribsARB = *const fn (HDC, ?HGLRC, [*]const i32) callconv(.winapi) ?HGLRC;

const user32 = struct {
    pub extern "user32" fn RegisterClassExW(lpWndClass: *const WNDCLASSEXW) callconv(.winapi) u16;
    pub extern "user32" fn CreateWindowExW(
        dwExStyle: u32,
        lpClassName: ?[*:0]const u16,
        lpWindowName: ?[*:0]const u16,
        dwStyle: u32,
        X: i32,
        Y: i32,
        nWidth: i32,
        nHeight: i32,
        hWndParent: ?HWND,
        hMenu: ?windows.HMENU,
        hInstance: HINSTANCE,
        lpParam: ?*anyopaque,
    ) callconv(.winapi) ?HWND;
    pub extern "user32" fn ShowWindow(hWnd: HWND, nCmdShow: i32) callconv(.winapi) windows.BOOL;
    pub extern "user32" fn UpdateWindow(hWnd: HWND) callconv(.winapi) windows.BOOL;
    pub extern "user32" fn GetMessageW(
        lpMsg: *MSG,
        hWnd: ?HWND,
        wMsgFilterMin: UINT,
        wMsgFilterMax: UINT,
    ) callconv(.winapi) windows.BOOL;
    pub extern "user32" fn TranslateMessage(lpMsg: *const MSG) callconv(.winapi) windows.BOOL;
    pub extern "user32" fn DispatchMessageW(lpMsg: *const MSG) callconv(.winapi) LRESULT;
    pub extern "user32" fn PostMessageW(hWnd: HWND, Msg: UINT, wParam: WPARAM, lParam: LPARAM) callconv(.winapi) windows.BOOL;
    pub extern "user32" fn DefWindowProcW(hWnd: HWND, Msg: UINT, wParam: WPARAM, lParam: LPARAM) callconv(.winapi) LRESULT;
    pub extern "user32" fn DestroyWindow(hWnd: HWND) callconv(.winapi) windows.BOOL;
    pub extern "user32" fn PostQuitMessage(nExitCode: i32) callconv(.winapi) void;
    pub extern "user32" fn LoadCursorW(hInstance: ?HINSTANCE, lpCursorName: ?[*:0]const u16) callconv(.winapi) ?HCURSOR;
    pub extern "user32" fn SetWindowLongPtrW(hWnd: HWND, nIndex: i32, dwNewLong: isize) callconv(.winapi) isize;
    pub extern "user32" fn GetWindowLongPtrW(hWnd: HWND, nIndex: i32) callconv(.winapi) isize;
    pub extern "user32" fn GetClientRect(hWnd: HWND, lpRect: *RECT) callconv(.winapi) windows.BOOL;
    pub extern "user32" fn SetCapture(hWnd: HWND) callconv(.winapi) HWND;
    pub extern "user32" fn ReleaseCapture() callconv(.winapi) windows.BOOL;
    pub extern "user32" fn GetKeyboardState(lpKeyState: [*]u8) callconv(.winapi) windows.BOOL;
    pub extern "user32" fn GetKeyState(nVirtKey: i32) callconv(.winapi) i16;
    pub extern "user32" fn OpenClipboard(hWndNewOwner: ?HWND) callconv(.winapi) windows.BOOL;
    pub extern "user32" fn CloseClipboard() callconv(.winapi) windows.BOOL;
    pub extern "user32" fn EmptyClipboard() callconv(.winapi) windows.BOOL;
    pub extern "user32" fn IsClipboardFormatAvailable(format: u32) callconv(.winapi) windows.BOOL;
    pub extern "user32" fn GetClipboardData(uFormat: u32) callconv(.winapi) ?HANDLE;
    pub extern "user32" fn SetClipboardData(uFormat: u32, hMem: ?HANDLE) callconv(.winapi) ?HANDLE;
    pub extern "user32" fn ToUnicode(
        wVirtKey: u32,
        wScanCode: u32,
        lpKeyState: [*]const u8,
        pwszBuff: [*]u16,
        cchBuff: i32,
        wFlags: u32,
    ) callconv(.winapi) i32;
    pub extern "user32" fn SetWindowTextW(hWnd: HWND, lpString: ?[*:0]const u16) callconv(.winapi) windows.BOOL;
};

const gdi32 = struct {
    pub extern "gdi32" fn GetDC(hWnd: HWND) callconv(.winapi) ?HDC;
    pub extern "gdi32" fn ReleaseDC(hWnd: HWND, hDC: ?HDC) callconv(.winapi) i32;
    pub extern "gdi32" fn ChoosePixelFormat(hdc: HDC, ppfd: *const PIXELFORMATDESCRIPTOR) callconv(.winapi) i32;
    pub extern "gdi32" fn SetPixelFormat(hdc: HDC, format: i32, ppfd: *const PIXELFORMATDESCRIPTOR) callconv(.winapi) windows.BOOL;
    pub extern "gdi32" fn SwapBuffers(hdc: HDC) callconv(.winapi) windows.BOOL;
};

const opengl32 = struct {
    pub extern "opengl32" fn wglCreateContext(hdc: HDC) callconv(.winapi) ?HGLRC;
    pub extern "opengl32" fn wglDeleteContext(hglrc: HGLRC) callconv(.winapi) windows.BOOL;
    pub extern "opengl32" fn wglMakeCurrent(hdc: ?HDC, hglrc: ?HGLRC) callconv(.winapi) windows.BOOL;
    pub extern "opengl32" fn wglGetProcAddress(lpszProc: [*:0]const u8) callconv(.winapi) ?*const anyopaque;
};

const kernel32_ext = struct {
    pub extern "kernel32" fn GlobalAlloc(uFlags: u32, dwBytes: usize) callconv(.winapi) ?HANDLE;
    pub extern "kernel32" fn GlobalFree(hMem: ?HANDLE) callconv(.winapi) ?HANDLE;
    pub extern "kernel32" fn GlobalLock(hMem: ?HANDLE) callconv(.winapi) ?*anyopaque;
    pub extern "kernel32" fn GlobalUnlock(hMem: ?HANDLE) callconv(.winapi) windows.BOOL;
};

const imm32 = struct {
    pub extern "imm32" fn ImmGetContext(hWnd: HWND) callconv(.winapi) ?HIMC;
    pub extern "imm32" fn ImmReleaseContext(hWnd: HWND, hIMC: ?HIMC) callconv(.winapi) windows.BOOL;
    pub extern "imm32" fn ImmGetCompositionStringW(
        hIMC: ?HIMC,
        dwIndex: u32,
        lpBuf: ?*anyopaque,
        dwBufLen: u32,
    ) callconv(.winapi) i32;
};

const opengl32_dll = std.unicode.utf8ToUtf16LeStringLiteral("opengl32.dll");
var opengl32_module: ?HMODULE = null;

fn ensureOpenGL32Module() !HMODULE {
    if (opengl32_module) |module| return module;
    const module = windows.kernel32.GetModuleHandleW(opengl32_dll) orelse
        try windows.LoadLibraryW(opengl32_dll);
    opengl32_module = module;
    return module;
}

pub fn glGetProcAddress(name: [*:0]const u8) ?*const anyopaque {
    if (opengl32.wglGetProcAddress(name)) |ptr| return ptr;
    const module = ensureOpenGL32Module() catch return null;
    return @ptrCast(windows.kernel32.GetProcAddress(module, name) orelse return null);
}

pub fn clearCurrentContext() void {
    _ = opengl32.wglMakeCurrent(null, null);
}

const MSG = extern struct {
    hwnd: HWND,
    message: UINT,
    wParam: WPARAM,
    lParam: LPARAM,
    time: u32,
    pt: windows.POINT,
    lPrivate: u32,
};

const RECT = extern struct {
    left: i32,
    top: i32,
    right: i32,
    bottom: i32,
};

pub const resourcesDir = internal_os.resourcesDir;
pub const must_draw_from_app_thread = false;

pub const App = struct {
    core_app: ?*CoreApp = null,
    config: Config = undefined,
    window: ?HWND = null,
    surface: ?*Surface = null,

    pub fn init(
        self: *App,
        core_app: *CoreApp,
        opts: struct {},
    ) !void {
        _ = opts;
        self.* = .{
            .core_app = core_app,
            .config = try Config.load(core_app.alloc),
        };
    }

    pub fn run(self: *App) !void {
        if (builtin.os.tag != .windows) return;

        const hwnd = try createWindow(self);
        self.window = hwnd;
        defer {
            if (self.window) |window| _ = user32.DestroyWindow(window);
            self.window = null;
        }

        var surface = try self.core_app.?.alloc.create(Surface);
        var surface_registered = false;
        surface.init(self, hwnd) catch |err| {
            self.core_app.?.alloc.destroy(surface);
            return err;
        };
        self.surface = surface;
        defer {
            self.surface = null;
            if (surface_registered) self.core_app.?.deleteSurface(surface);
            surface.deinit();
            self.core_app.?.alloc.destroy(surface);
        }

        surface.syncWindowMetrics();
        try surface.bootstrapCoreSurface();
        try self.core_app.?.addSurface(surface);
        surface_registered = true;
        try self.core_app.?.tick(self);

        var msg: MSG = std.mem.zeroes(MSG);
        while (true) {
            const status = user32.GetMessageW(&msg, null, 0, 0);
            if (status == -1) return error.WindowMessageLoopFailed;
            if (status == 0) break;

            _ = user32.TranslateMessage(&msg);
            _ = user32.DispatchMessageW(&msg);
            try self.core_app.?.tick(self);
        }
    }

    pub fn terminate(self: *App) void {
        if (builtin.os.tag == .windows) {
            if (self.window != null) user32.PostQuitMessage(0);
        }
        self.config.deinit();
    }

    pub fn wakeup(self: *App) void {
        if (self.window) |hwnd| {
            _ = user32.PostMessageW(hwnd, WM_GHOSTTY_TICK, 0, 0);
        }
    }

    pub fn performAction(
        self: *App,
        target: apprt.Target,
        comptime action: apprt.Action.Key,
        value: apprt.Action.Value(action),
    ) !bool {
        switch (action) {
            .quit => {
                if (builtin.os.tag == .windows) user32.PostQuitMessage(0);
                return true;
            },
            .close_all_windows => {
                if (builtin.os.tag == .windows) user32.PostQuitMessage(0);
                return true;
            },
            .close_window => {
                if (builtin.os.tag == .windows) {
                    user32.PostQuitMessage(0);
                }
                return true;
            },
            .set_title => {
                if (builtin.os.tag == .windows) {
                    if (self.surface) |surface| surface.setTitle(value.title);
                }
                return true;
            },
            .render => {
                if (builtin.os.tag != .windows) return false;
                const surface = switch (target) {
                    .surface => |v| v,
                    .app => return false,
                };
                surface.rt_surface.makeCurrent() catch |err| {
                    std.log.warn("error making GL context current err={}", .{err});
                    return false;
                };
                surface.draw() catch |err| {
                    std.log.warn("error drawing windows surface err={}", .{err});
                    return false;
                };
                return true;
            },
            else => return false,
        }
    }

    /// Windows runtime bootstrap starts as a no-op shell so the runtime tag
    /// and build graph can land before the host loop does.
    pub fn performIpc(
        _: Allocator,
        _: apprt.ipc.Target,
        comptime action: apprt.ipc.Action.Key,
        _: apprt.ipc.Action.Value(action),
    ) !bool {
        return false;
    }
};

pub const Surface = struct {
    app: *App,
    hwnd: HWND,
    dc: ?HDC = null,
    gl_context: ?HGLRC = null,
    core_surface: ?*CoreSurface = null,
    size: apprt.SurfaceSize = .{ .width = 0, .height = 0 },
    content_scale: apprt.ContentScale = .{ .x = 1, .y = 1 },
    cursor_pos: apprt.CursorPos = .{ .x = -1, .y = -1 },
    title: ?[:0]const u8 = null,
    pending_text_input: bool = false,
    pending_high_surrogate: ?u16 = null,

    pub const Options = struct {};

    pub fn deinit(self: *Surface) void {
        self.shutdownCoreSurface();
        if (self.title) |title| {
            self.app.core_app.?.alloc.free(title);
            self.title = null;
        }
    }

    pub fn init(self: *Surface, app: *App, hwnd: HWND) !void {
        self.* = .{
            .app = app,
            .hwnd = hwnd,
            .size = .{ .width = 1280, .height = 800 },
        };
    }

    pub fn rtApp(self: *const Surface) *App {
        return self.app;
    }

    pub fn getSize(self: *const Surface) !apprt.SurfaceSize {
        return self.size;
    }

    pub fn getContentScale(self: *const Surface) !apprt.ContentScale {
        return self.content_scale;
    }

    pub fn getCursorPos(self: *const Surface) !apprt.CursorPos {
        return self.cursor_pos;
    }

    pub fn getTitle(self: *Surface) ?[:0]const u8 {
        return self.title;
    }

    pub fn setTitle(self: *Surface, title: ?[:0]const u8) void {
        const alloc = self.app.core_app.?.alloc;
        if (self.title) |old| alloc.free(old);
        self.title = if (title) |v| alloc.dupeZ(u8, v) catch null else null;

        const next = self.title orelse "Ghostty";
        const next_w = std.unicode.utf8ToUtf16LeAllocZ(alloc, next) catch |err| {
            std.log.warn("error updating window title err={}", .{err});
            return;
        };
        defer alloc.free(next_w);
        _ = user32.SetWindowTextW(self.hwnd, next_w.ptr);
    }

    pub fn updateSize(self: *Surface, size: apprt.SurfaceSize) void {
        if (self.size.width == size.width and self.size.height == size.height) return;
        self.size = size;
        if (self.core_surface) |core_surface| core_surface.sizeCallback(size) catch |err| {
            std.log.warn("error in size callback err={}", .{err});
        };
    }

    pub fn updateContentScale(self: *Surface, x: f64, y: f64) void {
        self.content_scale = .{
            .x = @floatCast(@max(1, if (std.math.isNan(x)) 1 else x)),
            .y = @floatCast(@max(1, if (std.math.isNan(y)) 1 else y)),
        };
        if (self.core_surface) |core_surface| core_surface.contentScaleCallback(self.content_scale) catch |err| {
            std.log.warn("error in content scale callback err={}", .{err});
        };
    }

    pub fn attachCoreSurface(self: *Surface, core_surface: *CoreSurface) void {
        self.core_surface = core_surface;
        core_surface.sizeCallback(self.size) catch |err| {
            std.log.warn("error attaching size to core surface err={}", .{err});
        };
        core_surface.contentScaleCallback(self.content_scale) catch |err| {
            std.log.warn("error attaching content scale to core surface err={}", .{err});
        };
    }

    pub fn core(self: *Surface) *CoreSurface {
        return self.core_surface orelse @panic("windows core surface not initialized");
    }

    pub fn bootstrapCoreSurface(self: *Surface) !void {
        if (self.core_surface != null) return;

        const alloc = self.app.core_app.?.alloc;
        var core_surface = try alloc.create(CoreSurface);
        errdefer alloc.destroy(core_surface);
        try core_surface.init(alloc, &self.app.config, self.app.core_app.?, self.app, self);
        self.attachCoreSurface(core_surface);
    }

    pub fn glSurfaceInit(self: *Surface) !void {
        if (self.gl_context != null) return;

        const dc = gdi32.GetDC(self.hwnd) orelse return error.GetDeviceContextFailed;
        errdefer _ = gdi32.ReleaseDC(self.hwnd, dc);

        const pfd = PIXELFORMATDESCRIPTOR{
            .nSize = @sizeOf(PIXELFORMATDESCRIPTOR),
            .nVersion = 1,
            .dwFlags = PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER,
            .iPixelType = PFD_TYPE_RGBA,
            .cColorBits = 32,
            .cRedBits = 0,
            .cRedShift = 0,
            .cGreenBits = 0,
            .cGreenShift = 0,
            .cBlueBits = 0,
            .cBlueShift = 0,
            .cAlphaBits = 8,
            .cAlphaShift = 0,
            .cAccumBits = 0,
            .cAccumRedBits = 0,
            .cAccumGreenBits = 0,
            .cAccumBlueBits = 0,
            .cAccumAlphaBits = 0,
            .cDepthBits = 24,
            .cStencilBits = 8,
            .cAuxBuffers = 0,
            .iLayerType = PFD_MAIN_PLANE,
            .bReserved = 0,
            .dwLayerMask = 0,
            .dwVisibleMask = 0,
            .dwDamageMask = 0,
        };

        const pixel_format = gdi32.ChoosePixelFormat(dc, &pfd);
        if (pixel_format == 0) return error.ChoosePixelFormatFailed;
        if (gdi32.SetPixelFormat(dc, pixel_format, &pfd) == 0) return error.SetPixelFormatFailed;

        const legacy_context = opengl32.wglCreateContext(dc) orelse return error.CreateGLContextFailed;
        errdefer _ = opengl32.wglDeleteContext(legacy_context);

        if (opengl32.wglMakeCurrent(dc, legacy_context) == 0) return error.MakeGLContextCurrentFailed;

        var current_context = legacy_context;
        if (glGetProcAddress("wglCreateContextAttribsARB")) |proc| {
            const create_context_attribs: WglCreateContextAttribsARB = @ptrCast(proc);
            const attribs = [_]i32{
                WGL_CONTEXT_MAJOR_VERSION_ARB, 4,
                WGL_CONTEXT_MINOR_VERSION_ARB, 3,
                WGL_CONTEXT_FLAGS_ARB, 0,
                WGL_CONTEXT_PROFILE_MASK_ARB, WGL_CONTEXT_CORE_PROFILE_BIT_ARB,
                0,
            };
            const maybe_modern_context = create_context_attribs(dc, null, &attribs);
            if (maybe_modern_context) |modern_context| {
                errdefer _ = opengl32.wglDeleteContext(modern_context);
                if (opengl32.wglMakeCurrent(null, null) == 0) return error.ClearGLContextFailed;
                _ = opengl32.wglDeleteContext(legacy_context);
                if (opengl32.wglMakeCurrent(dc, modern_context) == 0) return error.MakeGLContextCurrentFailed;
                current_context = modern_context;
            }
        }

        self.dc = dc;
        self.gl_context = current_context;
    }

    pub fn makeCurrent(self: *Surface) !void {
        const dc = self.dc orelse return error.GLContextNotInitialized;
        const gl_context = self.gl_context orelse return error.GLContextNotInitialized;
        if (opengl32.wglMakeCurrent(dc, gl_context) == 0) return error.MakeGLContextCurrentFailed;
    }

    pub fn swapBuffers(self: *Surface) !void {
        const dc = self.dc orelse return error.GLContextNotInitialized;
        if (gdi32.SwapBuffers(dc) == 0) return error.SwapBuffersFailed;
    }

    fn shutdownGLContext(self: *Surface) void {
        _ = self;
    }

    pub fn shutdownCoreSurface(self: *Surface) void {
        const core_surface = self.core_surface orelse return;
        self.core_surface = null;
        core_surface.deinit();
        self.app.core_app.?.alloc.destroy(core_surface);
    }

    pub fn supportsClipboard(
        self: *const Surface,
        clipboard_type: apprt.Clipboard,
    ) bool {
        _ = self;
        return switch (clipboard_type) {
            .standard => true,
            .selection, .primary => false,
        };
    }

    pub fn clipboardRequest(
        self: *Surface,
        clipboard_type: apprt.Clipboard,
        req: apprt.ClipboardRequest,
    ) !bool {
        if (clipboard_type != .standard) return false;

        if (user32.OpenClipboard(self.hwnd) == 0) return false;
        defer _ = user32.CloseClipboard();

        if (user32.IsClipboardFormatAvailable(CF_UNICODETEXT) == 0) return false;

        const handle = user32.GetClipboardData(CF_UNICODETEXT) orelse return false;
        const locked = kernel32_ext.GlobalLock(handle) orelse return false;
        defer _ = kernel32_ext.GlobalUnlock(handle);

        const utf16_ptr: [*:0]const u16 = @ptrCast(@alignCast(locked));
        const utf16 = std.mem.sliceTo(utf16_ptr, 0);
        const alloc = self.app.core_app.?.alloc;
        const utf8 = try std.unicode.utf16LeToUtf8AllocZ(alloc, utf16);
        defer alloc.free(utf8);

        const core_surface = self.core_surface orelse return false;
        core_surface.completeClipboardRequest(req, utf8, true) catch |err| {
            std.log.warn("failed to complete Windows clipboard request err={}", .{err});
            return false;
        };

        return true;
    }

    pub fn setClipboard(
        self: *const Surface,
        clipboard_type: apprt.Clipboard,
        contents: []const apprt.ClipboardContent,
        _: bool,
    ) !void {
        if (clipboard_type != .standard) return;

        const content = findClipboardText(contents) orelse return;
        const alloc = self.app.core_app.?.alloc;
        const utf16 = try std.unicode.utf8ToUtf16LeAllocZ(alloc, content.data);
        defer alloc.free(utf16);

        const total_code_units = utf16.len + 1;
        const byte_len = total_code_units * @sizeOf(u16);
        const handle = kernel32_ext.GlobalAlloc(GMEM_MOVEABLE, byte_len) orelse return error.OutOfMemory;
        errdefer _ = kernel32_ext.GlobalFree(handle);

        const locked = kernel32_ext.GlobalLock(handle) orelse return error.GlobalLockFailed;
        {
            const dest: [*]u16 = @ptrCast(@alignCast(locked));
            @memcpy(dest[0..utf16.len], utf16);
            dest[utf16.len] = 0;
        }
        _ = kernel32_ext.GlobalUnlock(handle);

        if (user32.OpenClipboard(self.hwnd) == 0) return error.OpenClipboardFailed;
        defer _ = user32.CloseClipboard();

        if (user32.EmptyClipboard() == 0) return error.EmptyClipboardFailed;
        if (user32.SetClipboardData(CF_UNICODETEXT, handle) == null) return error.SetClipboardDataFailed;
    }

    pub fn defaultTermioEnv(self: *const Surface) !std.process.EnvMap {
        const alloc = self.app.core_app.?.alloc;
        return internal_os.getEnvMap(alloc);
    }

    pub fn close(self: *const Surface, _: bool) void {
        _ = self;
        user32.PostQuitMessage(0);
    }

    pub fn syncWindowMetrics(self: *Surface) void {
        var rect: RECT = std.mem.zeroes(RECT);
        if (user32.GetClientRect(self.hwnd, &rect) == 0) return;
        const width: u32 = @intCast(@max(0, rect.right - rect.left));
        const height: u32 = @intCast(@max(0, rect.bottom - rect.top));
        self.updateSize(.{ .width = width, .height = height });
    }
};

fn createWindow(self: *App) !HWND {
    if (builtin.os.tag != .windows) return null;

    const class_name = std.unicode.utf8ToUtf16LeStringLiteral("GhosttyWindowClass");
    const window_title = std.unicode.utf8ToUtf16LeStringLiteral("Ghostty");
    const instance: HINSTANCE = @ptrCast(windows.kernel32.GetModuleHandleW(null) orelse return error.GetModuleHandleFailed);

    const wc = WNDCLASSEXW{
        .cbSize = @sizeOf(WNDCLASSEXW),
        .style = CS_HREDRAW | CS_VREDRAW,
        .lpfnWndProc = windowProc,
        .cbClsExtra = 0,
        .cbWndExtra = 0,
        .hInstance = instance,
        .hIcon = null,
        .hCursor = user32.LoadCursorW(null, IDC_ARROW),
        .hbrBackground = null,
        .lpszMenuName = null,
        .lpszClassName = class_name,
        .hIconSm = null,
    };

    if (user32.RegisterClassExW(&wc) == 0) return error.RegisterClassFailed;

    const hwnd = user32.CreateWindowExW(
        0,
        class_name,
        window_title,
        WS_OVERLAPPEDWINDOW | WS_VISIBLE,
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        1280,
        800,
        null,
        null,
        instance,
        self,
    ) orelse return error.CreateWindowFailed;

    _ = user32.ShowWindow(hwnd, SW_SHOW);
    _ = user32.UpdateWindow(hwnd);
    return hwnd;
}

fn windowProc(hwnd: HWND, msg: UINT, wparam: WPARAM, lparam: LPARAM) callconv(.winapi) LRESULT {
    if (builtin.os.tag != .windows) return 0;

    switch (msg) {
        WM_NCCREATE => {
            const create: *const CREATESTRUCTW = @ptrFromInt(@as(usize, @bitCast(lparam)));
            if (create.lpCreateParams) |param| {
                _ = user32.SetWindowLongPtrW(hwnd, GWLP_USERDATA, @as(isize, @bitCast(@intFromPtr(param))));
                return 1;
            }
            return 0;
        },
        WM_SIZE => {
            if (windowApp(hwnd)) |app| {
                const size_bits: usize = @bitCast(lparam);
                const size: apprt.SurfaceSize = .{
                    .width = @intCast(size_bits & 0xffff),
                    .height = @intCast((size_bits >> 16) & 0xffff),
                };
                if (app.surface) |surface| surface.updateSize(size);
                return 0;
            }
            return user32.DefWindowProcW(hwnd, msg, wparam, lparam);
        },
        WM_SETFOCUS => {
            if (windowApp(hwnd)) |app| {
                if (app.surface) |surface| {
                    if (surface.core_surface) |core_surface| core_surface.focusCallback(true) catch |err| {
                        std.log.warn("error in focus callback err={}", .{err});
                    };
                }
                if (app.core_app) |core_app| core_app.focusEvent(true);
                return 0;
            }
            return user32.DefWindowProcW(hwnd, msg, wparam, lparam);
        },
        WM_KILLFOCUS => {
            if (windowApp(hwnd)) |app| {
                if (app.surface) |surface| {
                    surface.pending_text_input = false;
                    surface.pending_high_surrogate = null;
                    if (surface.core_surface) |core_surface| core_surface.focusCallback(false) catch |err| {
                        std.log.warn("error in focus callback err={}", .{err});
                    };
                }
                if (app.core_app) |core_app| core_app.focusEvent(false);
                return 0;
            }
            return user32.DefWindowProcW(hwnd, msg, wparam, lparam);
        },
        WM_KEYDOWN, WM_SYSKEYDOWN, WM_KEYUP, WM_SYSKEYUP => {
            if (windowApp(hwnd)) |app| {
                if (app.surface) |surface| {
                    if (dispatchKeyMessage(surface, msg, wparam, lparam)) return 0;
                    return 0;
                }
            }
            return user32.DefWindowProcW(hwnd, msg, wparam, lparam);
        },
        WM_MOUSEMOVE => {
            if (windowApp(hwnd)) |app| {
                if (app.surface) |surface| {
                    dispatchMouseMove(surface, lparam);
                    return 0;
                }
            }
            return user32.DefWindowProcW(hwnd, msg, wparam, lparam);
        },
        WM_LBUTTONDOWN, WM_LBUTTONUP, WM_RBUTTONDOWN, WM_RBUTTONUP, WM_MBUTTONDOWN, WM_MBUTTONUP => {
            if (windowApp(hwnd)) |app| {
                if (app.surface) |surface| {
                    dispatchMouseButton(surface, msg, wparam);
                    return 0;
                }
            }
            return user32.DefWindowProcW(hwnd, msg, wparam, lparam);
        },
        WM_MOUSEWHEEL, WM_MOUSEHWHEEL => {
            if (windowApp(hwnd)) |app| {
                if (app.surface) |surface| {
                    dispatchMouseWheel(surface, msg, wparam);
                    return 0;
                }
            }
            return user32.DefWindowProcW(hwnd, msg, wparam, lparam);
        },
        WM_CHAR, WM_SYSCHAR, WM_UNICHAR => {
            if (msg == WM_UNICHAR and @as(u32, @intCast(wparam)) == UNICODE_NOCHAR) return 1;
            if (windowApp(hwnd)) |app| {
                if (app.surface) |surface| {
                    if (dispatchCharMessage(surface, msg, wparam)) return 0;
                    return 0;
                }
            }
            return user32.DefWindowProcW(hwnd, msg, wparam, lparam);
        },
        WM_DEADCHAR, WM_SYSDEADCHAR => {
            if (windowApp(hwnd)) |app| {
                if (app.surface) |surface| {
                    surface.pending_text_input = false;
                    surface.pending_high_surrogate = null;
                    return 0;
                }
            }
            return user32.DefWindowProcW(hwnd, msg, wparam, lparam);
        },
        WM_IME_STARTCOMPOSITION, WM_IME_COMPOSITION, WM_IME_ENDCOMPOSITION => {
            if (windowApp(hwnd)) |app| {
                if (app.surface) |surface| {
                    if (dispatchImeMessage(surface, hwnd, msg, lparam)) return 0;
                    return 0;
                }
            }
            return user32.DefWindowProcW(hwnd, msg, wparam, lparam);
        },
        WM_CLOSE => {
            user32.PostQuitMessage(0);
            return 0;
        },
        WM_DESTROY => {
            user32.PostQuitMessage(0);
            return 0;
        },
        else => return user32.DefWindowProcW(hwnd, msg, wparam, lparam),
    }
}

fn windowApp(hwnd: HWND) ?*App {
    const ptr = user32.GetWindowLongPtrW(hwnd, GWLP_USERDATA);
    if (ptr == 0) return null;
    return @ptrFromInt(@as(usize, @bitCast(ptr)));
}

fn dispatchKeyMessage(surface: *Surface, msg: UINT, wparam: WPARAM, lparam: LPARAM) bool {
    const action: input.Action = switch (msg) {
        WM_KEYDOWN, WM_SYSKEYDOWN => if ((@as(usize, @bitCast(lparam)) & (1 << 30)) != 0) .repeat else .press,
        WM_KEYUP, WM_SYSKEYUP => .release,
        else => return false,
    };

    const vk: u32 = @intCast(wparam);
    const key = virtualKeyToKey(vk);
    const mods = currentMods(vk);
    var text_buf: [8]u8 = undefined;
    var utf8: []const u8 = "";
    var unshifted_codepoint: u21 = 0;

    if (action != .release and key != .unidentified and isTextualKey(vk)) {
        if (keyToUtf8(vk, lparam, &text_buf, &unshifted_codepoint)) |slice| {
            utf8 = slice;
        } else |_| {}
    }

    const expects_char_message = action != .release and
        utf8.len == 0 and
        !mods.ctrl and
        !mods.alt and
        !mods.super and
        (isTextualKey(vk) or vk == VK_PROCESSKEY or vk == VK_PACKET or key == .unidentified);
    surface.pending_text_input = expects_char_message;
    if (!expects_char_message) surface.pending_high_surrogate = null;

    const event: input.KeyEvent = .{
        .action = action,
        .key = key,
        .mods = mods,
        .consumed_mods = if (utf8.len > 0 and !mods.ctrl and !mods.alt and !mods.super)
            .{ .shift = mods.shift, .caps_lock = mods.caps_lock }
        else .{},
        .utf8 = utf8,
        .unshifted_codepoint = unshifted_codepoint,
    };

    if (surface.core_surface) |core_surface| {
        const effect = core_surface.keyCallback(event) catch |err| {
            std.log.warn("error dispatching key event err={}", .{err});
            return false;
        };
        return effect != .ignored;
    }

    return surface.app.core_app.?.keyEvent(surface.app, event);
}

fn dispatchCharMessage(surface: *Surface, msg: UINT, wparam: WPARAM) bool {
    _ = msg;

    if (!surface.pending_text_input) return false;

    const code_unit: u32 = @intCast(wparam);
    if (code_unit == 0) return false;

    var utf16_buf: [2]u16 = undefined;
    var utf16_len: usize = 0;

    if (code_unit > std.math.maxInt(u16)) return false;
    const unit: u16 = @intCast(code_unit);

    if (std.unicode.utf16IsHighSurrogate(unit)) {
        surface.pending_high_surrogate = unit;
        return true;
    }

    if (std.unicode.utf16IsLowSurrogate(unit)) {
        const high = surface.pending_high_surrogate orelse return false;
        utf16_buf[0] = high;
        utf16_buf[1] = unit;
        utf16_len = 2;
        surface.pending_high_surrogate = null;
    } else {
        utf16_buf[0] = unit;
        utf16_len = 1;
        surface.pending_high_surrogate = null;
    }

    var utf8_buf: [8]u8 = undefined;
    const utf8_len = std.unicode.utf16LeToUtf8(utf8_buf[0..], utf16_buf[0..utf16_len]) catch return false;
    const text = utf8_buf[0..utf8_len];

    if (surface.core_surface) |core_surface| {
        core_surface.textCallback(text) catch |err| {
            std.log.warn("error dispatching char message err={}", .{err});
            return false;
        };
        surface.pending_text_input = false;
        return true;
    }

    return false;
}

fn dispatchImeMessage(surface: *Surface, hwnd: HWND, msg: UINT, lparam: LPARAM) bool {
    surface.pending_text_input = false;
    surface.pending_high_surrogate = null;

    switch (msg) {
        WM_IME_STARTCOMPOSITION => return true,
        WM_IME_ENDCOMPOSITION => {
            if (surface.core_surface) |core_surface| {
                core_surface.preeditCallback(null) catch |err| {
                    std.log.warn("error clearing ime preedit err={}", .{err});
                    return false;
                };
                return true;
            }
            return false;
        },
        WM_IME_COMPOSITION => {},
        else => return false,
    }

    const himc = imm32.ImmGetContext(hwnd) orelse return false;
    defer _ = imm32.ImmReleaseContext(hwnd, himc);

    const flags: u32 = @truncate(@as(usize, @bitCast(lparam)));

    if ((flags & GCS_RESULTSTR) != 0) {
        if (readImeUtf8(surface, himc, GCS_RESULTSTR)) |text| {
            defer surface.app.core_app.?.alloc.free(text);
            if (surface.core_surface) |core_surface| {
                core_surface.textCallback(text) catch |err| {
                    std.log.warn("error dispatching ime result err={}", .{err});
                    return false;
                };
                core_surface.preeditCallback(null) catch |err| {
                    std.log.warn("error clearing ime preedit after result err={}", .{err});
                    return false;
                };
                return true;
            }
        } else |_| {}
    }

    if ((flags & GCS_COMPSTR) != 0) {
        if (readImeUtf8(surface, himc, GCS_COMPSTR)) |text| {
            defer surface.app.core_app.?.alloc.free(text);
            if (surface.core_surface) |core_surface| {
                core_surface.preeditCallback(text) catch |err| {
                    std.log.warn("error dispatching ime preedit err={}", .{err});
                    return false;
                };
                return true;
            }
        } else |_| {}
    } else if (surface.core_surface) |core_surface| {
        core_surface.preeditCallback(null) catch |err| {
            std.log.warn("error clearing ime preedit err={}", .{err});
            return false;
        };
        return true;
    }

    return false;
}

fn readImeUtf8(surface: *Surface, himc: ?HIMC, index: u32) ![:0]u8 {
    const byte_len = imm32.ImmGetCompositionStringW(himc, index, null, 0);
    if (byte_len <= 0) return error.NoCompositionString;

    const alloc = surface.app.core_app.?.alloc;
    const copied_bytes: u32 = @intCast(byte_len);
    const code_units: usize = @intCast(@divExact(copied_bytes, @sizeOf(u16)));
    const utf16 = try alloc.alloc(u16, code_units);
    defer alloc.free(utf16);

    const copied = imm32.ImmGetCompositionStringW(
        himc,
        index,
        utf16.ptr,
        copied_bytes,
    );
    if (copied <= 0) return error.NoCompositionString;

    return try std.unicode.utf16LeToUtf8AllocZ(alloc, utf16[0..code_units]);
}

fn findClipboardText(contents: []const apprt.ClipboardContent) ?apprt.ClipboardContent {
    for (contents) |content| {
        if (std.mem.eql(u8, content.mime, "text/plain")) return content;
    }

    return if (contents.len > 0) contents[0] else null;
}

fn keyToUtf8(
    vk: u32,
    lparam: LPARAM,
    out: []u8,
    unshifted_codepoint: *u21,
) ![]const u8 {
    var key_state: [256]u8 = undefined;
    if (user32.GetKeyboardState(&key_state) == 0) return error.KeyboardStateFailed;

    var utf16: [8]u16 = undefined;
    const scan_code: u32 = @intCast((@as(usize, @bitCast(lparam)) >> 16) & 0xff);
    const count = user32.ToUnicode(vk, scan_code, &key_state, &utf16, @intCast(utf16.len), 0);
    if (count <= 0) return error.NoText;

    const utf8_len = std.unicode.utf16LeToUtf8(out, utf16[0..@intCast(count)]) catch return error.NoText;
    if (count == 1) unshifted_codepoint.* = utf16[0];
    return out[0..utf8_len];
}

fn currentMods(vk: u32) input.Mods {
    const shift = isKeyDown(VK_SHIFT);
    const ctrl = isKeyDown(VK_CONTROL);
    const alt = isKeyDown(VK_MENU);
    const super = isKeyDown(VK_LWIN) or isKeyDown(VK_RWIN);

    var mods: input.Mods = .{
        .shift = shift,
        .ctrl = ctrl,
        .alt = alt,
        .super = super,
        .caps_lock = (user32.GetKeyState(@as(i32, @intCast(VK_CAPITAL))) & 1) != 0,
        .num_lock = (user32.GetKeyState(@as(i32, @intCast(VK_NUMLOCK))) & 1) != 0,
    };

    if (vk == VK_LSHIFT or vk == VK_RSHIFT) {
        mods.sides.shift = if (vk == VK_RSHIFT) .right else .left;
    } else if (vk == VK_LCONTROL or vk == VK_RCONTROL) {
        mods.sides.ctrl = if (vk == VK_RCONTROL) .right else .left;
    } else if (vk == VK_LMENU or vk == VK_RMENU) {
        mods.sides.alt = if (vk == VK_RMENU) .right else .left;
    } else if (vk == VK_LWIN or vk == VK_RWIN) {
        mods.sides.super = if (vk == VK_RWIN) .right else .left;
    }

    return mods;
}

fn isKeyDown(vk: u32) bool {
    return user32.GetKeyState(@as(i32, @intCast(vk))) < 0;
}

fn isTextualKey(vk: u32) bool {
    return switch (vk) {
        '0'...'9',
        'A'...'Z',
        VK_OEM_1,
        VK_OEM_PLUS,
        VK_OEM_COMMA,
        VK_OEM_MINUS,
        VK_OEM_PERIOD,
        VK_OEM_2,
        VK_OEM_3,
        VK_OEM_4,
        VK_OEM_5,
        VK_OEM_6,
        VK_OEM_7,
        VK_OEM_8,
        VK_OEM_102,
        => true,
        else => false,
    };
}

fn virtualKeyToKey(vk: u32) input.Key {
    for (input.keycodes.entries) |entry| {
        if (entry.native == vk) return entry.key;
    }
    return .unidentified;
}

fn dispatchMouseMove(surface: *Surface, lparam: LPARAM) void {
    const pos = mousePosFromLParam(lparam);
    if (surface.core_surface) |core_surface| {
        core_surface.cursorPosCallback(pos, currentMods(0)) catch |err| {
            std.log.warn("error dispatching mouse move err={}", .{err});
        };
    }
}

fn dispatchMouseButton(surface: *Surface, msg: UINT, wparam: WPARAM) void {
    const button: input.MouseButton = switch (msg) {
        WM_LBUTTONDOWN, WM_LBUTTONUP => .left,
        WM_RBUTTONDOWN, WM_RBUTTONUP => .right,
        WM_MBUTTONDOWN, WM_MBUTTONUP => .middle,
        else => .unknown,
    };
    const action: input.MouseButtonState = switch (msg) {
        WM_LBUTTONDOWN, WM_RBUTTONDOWN, WM_MBUTTONDOWN => .press,
        else => .release,
    };

    if (button == .unknown) return;

    if (surface.core_surface) |core_surface| {
        if (action == .press) _ = user32.SetCapture(surface.hwnd) else _ = user32.ReleaseCapture();
        _ = wparam;
        _ = core_surface.mouseButtonCallback(action, button, currentMods(0)) catch |err| {
            std.log.warn("error dispatching mouse button err={}", .{err});
            return;
        };
    }
}

fn dispatchMouseWheel(surface: *Surface, msg: UINT, wparam: WPARAM) void {
    const raw: usize = @bitCast(wparam);
    const delta_bits: u16 = @truncate((raw >> 16) & 0xffff);
    const signed: i16 = @bitCast(delta_bits);
    const delta: f64 = @as(f64, @floatFromInt(signed)) / 120.0;

    if (surface.core_surface) |core_surface| {
        const mods = @as(input.ScrollMods, .{});
        const result = switch (msg) {
            WM_MOUSEWHEEL => core_surface.scrollCallback(0, delta, mods),
            WM_MOUSEHWHEEL => core_surface.scrollCallback(delta, 0, mods),
            else => unreachable,
        };
        result catch |err| std.log.warn("error dispatching mouse wheel err={}", .{err});
    }
}

fn mousePosFromLParam(lparam: LPARAM) apprt.CursorPos {
    const raw: usize = @bitCast(lparam);
    const x_bits: u16 = @truncate(raw & 0xffff);
    const y_bits: u16 = @truncate((raw >> 16) & 0xffff);
    const x: i16 = @bitCast(x_bits);
    const y: i16 = @bitCast(y_bits);
    return .{
        .x = @floatFromInt(x),
        .y = @floatFromInt(y),
    };
}
