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
