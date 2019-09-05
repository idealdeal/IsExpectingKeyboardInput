{ ; AUTOEXECUTE SECTION

    ; This is an example script.
    ; Goal of this script is to create "client commands" simular to AHKs hotstrings that the user can use in any
    ; active window where he is expected to type / write something.

    ; This can can be quite handy in browser games (roleplaying for example)

    #SingleInstance Force
    TARGET_WINDOW_NAME := "Untitled - Notepad"
    MY_NAME := "Aiden"
}
return

F12::
    ExitApp
return

Pause::
    Suspend Permit
    Suspend Toggle
return

{ ; FUNCTIONS

    { ; Input checking

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
    }

    { ; Clipboard management
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
    }

    { ; Text management

        ; Fetches the written text in an input box
        ; This can be any input box. A Notepad window, some browser input field etc..
        GetText() {
            oldClip := SaveAndClearClipboard()

            SendInput ^a^c{right}
            Clipwait, 0.05
            myText := Clipboard

            RestoreClipboard(oldClip)
            return myText
        }

        ; Clears the current line of text
        ClearText() {
            SendInput +{Home}{BackSpace}
        }
    }

    { ; SendChat(text)

        ; Sends keystroke to the active window
        SendChat(sText, sendEnter=true) {
            SendInput {raw}%sText%
            if(sendEnter) {
                SendInput {enter}
            }
        }
    }

    { ; HandleClientCommand(text)

        ; This is basically a function that immitates AHKs hotstring function while granting the user the ability to pass arguments
        ; and create "custom commands"
        HandleClientCommand(ClientCommand) {
            if(Trim(ClientCommand) = "") {
                SendInput {enter}
                return
            }

            ClientCommand := StrSplit(ClientCommand, "`r`n")
            ClientCommand := ClientCommand[ClientCommand.MaxIndex()]

            if(RegExMatch(ClientCommand,"i)/greet Aiden (.*)", args) == 1) {
                ClearText()
                SendChat("Aiden greets " args1)
                return
            }

            if(RegExMatch(ClientCommand,"i)/rand ([0-9]{1,}) ([0-9]{1,})", args) == 1) {
                ClearText()
                Random, rand, %args1%, %args2%
                SendChat(rand, false)
                return
            }

            if(RegExMatch(ClientCommand,"i)(.*)%MY_NAME%(.*)", args) == 1) {
                global MY_NAME
                ClearText()
                SendChat(args1 "" MY_NAME "" args2)
                return
            }

            SendInput {enter}
        }
    }
}

{ ; HOTKEYS
    Enter::
        if(!WinActive(TARGET_WINDOW_NAME) || !IsExpectingKeyboardInput()) {
            SendInput {Enter}
            return
        }

        HandleClientCommand(GetText())
    return
}
