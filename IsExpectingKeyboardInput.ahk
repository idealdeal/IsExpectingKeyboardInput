; Call this function.
IsExpectingKeyboardInput() {
    return CanType() = "." ? true : false
}

CanType() {
    oldClip := SaveAndClearClipboard()

    SendInput .+{left}^x
    Clipwait, 0.05
    char := Clipboard

    RestoreClipboard(oldClip)
    return char
}

SaveAndClearClipboard() {
    oldClip := Clipboard
    Clipboard := ""
    return oldClip
}

RestoreClipboard(clipboardText) {
    Clipboard := ""
    Clipboard := clipboardText
    Clipwait, 0.05, 1
}
