%include 'common.inc'

global report_interrupt


;;; Registers to save pieced together from:
;;;
;;; http://stackoverflow.com/questions/6837392/how-to-save-the-registers-on-x86-64-for-an-interrupt-service-routine
;;; https://github.com/torvalds/linux/blob/master/arch/x86/entry/entry_64.S
;;; http://x86-64.org/documentation/abi.pdf
;;; http://developer.amd.com/wordpress/media/2012/10/24593_APM_v21.pdf
;;; https://github.com/redox-os/redox/blob/master/kernel/asm/interrupts-x86_64.asm
;;;
;;; We skip any "callee saved" registers, on the theory that the Rust
;;; compiler will save them if it actually uses them.
;;;
;;; We don't save any floating point, MMX, SSE, etc. registers, because
;;; they're large, complicated, and slow to save, and we want our interrupt
;;; handlers to be fast.  So we just don't use any of those processor
;;; features in kernel mode.
%macro push_caller_saved 0
        ;; Save ordinary registers.
        push rax
        push rcx
        push rdx
        push r8
        push r9
        push r10
        push r11
        ;; These two are caller-saved on x86_64!
        push rdi
        push rsi
%endmacro

%macro pop_caller_saved 0
        ;; Restore ordinary registers.
        pop rsi
        pop rdi
        pop r11
        pop r10
        pop r9
        pop r8
        pop rdx
        pop rcx
        pop rax
%endmacro

;;; A dummy interrupt handler.
report_interrupt:
        push_caller_saved

        ;; Print "INT!"
        mov rax, 0x2f212f542f4e2f49
        mov qword [SCREEN_BASE], rax

        pop_caller_saved
        iretq
