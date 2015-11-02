/// Macros used by our kernel.

/// Print formatted text to our console.
///
/// From http://blog.phil-opp.com/rust-os/printing-to-screen.html, but tweaked
/// to work with our APIs.
macro_rules! print {
    ($($arg:tt)*) => ({
            use core::fmt::Write;
            $crate::arch::vga::SCREEN.lock().write_fmt(format_args!($($arg)*)).unwrap();
    });
}

/// Print formatted text to our console, followed by a newline.
///
/// From https://doc.rust-lang.org/nightly/std/macro.println!.html
macro_rules! println {
    ($fmt:expr) => (print!(concat!($fmt, "\n")));
    ($fmt:expr, $($arg:tt)*) => (print!(concat!($fmt, "\n"), $($arg)*));
}
