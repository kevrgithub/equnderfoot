#SingleInstance, Ignore
#Persistent

#MaxHotkeysPerInterval, 9999

#Include, everquest.ahk

Global psapi_dll_handle := 0

Global PI := 3.14159265358979323846

Gui, Add, Checkbox, vCheckboxCameraHack gCheckboxCameraHack, Camera Hack Enabled
Gui, Add, Text,, 
Gui, Add, Text, vTextCameraY w360, Camera Y: 0.000000
Gui, Add, Text, vTextCameraX w360, Camera X: 0.000000
Gui, Add, Text, vTextCameraZ w360, Camera Z: 0.000000
Gui, Add, Text, vTextCameraHeading w360, Camera Heading: 0.000000
Gui, Add, Text, vTextCameraPitch w360, Camera Pitch: 0.000000

CameraHack_Enable()
{
    Memory_Write(everquest_process_handle, EVERQUEST_CAMERA_VIEW, EVERQUEST_CAMERA_VIEW_FIRST_PERSON)

    Memory_WriteNops(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_Y,   EVERQUEST_ASM_SET_CAMERA_Y_SIZE)
    Memory_WriteNops(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_X,   EVERQUEST_ASM_SET_CAMERA_X_SIZE)
    Memory_WriteNops(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_Z,   EVERQUEST_ASM_SET_CAMERA_Z_SIZE)
    
    Memory_WriteNops(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_HEADING, EVERQUEST_ASM_SET_CAMERA_HEADING_SIZE)
    Memory_WriteNops(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_PITCH,   EVERQUEST_ASM_SET_CAMERA_PITCH_SIZE)

    Memory_WriteNops(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_Y_2, EVERQUEST_ASM_SET_CAMERA_Y_2_SIZE)
    Memory_WriteNops(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_X_2, EVERQUEST_ASM_SET_CAMERA_X_2_SIZE)
    Memory_WriteNops(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_Z_2, EVERQUEST_ASM_SET_CAMERA_Z_2_SIZE)
    Memory_WriteNops(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_Z_3, EVERQUEST_ASM_SET_CAMERA_Z_3_SIZE)
    Memory_WriteNops(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_Z_4, EVERQUEST_ASM_SET_CAMERA_Z_4_SIZE)

    Memory_WriteNops(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_PITCH_2, EVERQUEST_ASM_SET_CAMERA_PITCH_2_SIZE)
}

CameraHack_Disable()
{
    Memory_WriteBytes(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_Y,   EVERQUEST_ASM_SET_CAMERA_Y_BYTES)
    Memory_WriteBytes(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_X,   EVERQUEST_ASM_SET_CAMERA_X_BYTES)
    Memory_WriteBytes(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_Z,   EVERQUEST_ASM_SET_CAMERA_Z_BYTES)

    Memory_WriteBytes(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_HEADING, EVERQUEST_ASM_SET_CAMERA_HEADING_BYTES)
    Memory_WriteBytes(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_PITCH,   EVERQUEST_ASM_SET_CAMERA_PITCH_BYTES)

    Memory_WriteBytes(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_Y_2, EVERQUEST_ASM_SET_CAMERA_Y_2_BYTES)
    Memory_WriteBytes(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_X_2, EVERQUEST_ASM_SET_CAMERA_X_2_BYTES)
    Memory_WriteBytes(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_Z_2, EVERQUEST_ASM_SET_CAMERA_Z_2_BYTES)
    Memory_WriteBytes(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_Z_3, EVERQUEST_ASM_SET_CAMERA_Z_3_BYTES)
    Memory_WriteBytes(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_Z_4, EVERQUEST_ASM_SET_CAMERA_Z_4_BYTES)

    Memory_WriteBytes(everquest_process_handle, EVERQUEST_ASM_SET_CAMERA_PITCH_2, EVERQUEST_ASM_SET_CAMERA_PITCH_2_BYTES)

    Memory_Write(everquest_process_handle, EVERQUEST_CAMERA_VIEW, EVERQUEST_CAMERA_VIEW_FIRST_PERSON)
}

EnableDebugPrivileges()

psapi_dll_handle := DllCall("LoadLibrary", "Str", "Psapi.dll")

everquest_process_id := Memory_GetProcessID(EVERQUEST_CLIENT)

;MsgBox, everquest_process_id = %everquest_process_id%

If (everquest_process_id = 0)
{
    MsgBox, Error: everquest_process_id = 0
    ExitApp
    Return
}

everquest_process_handle := Memory_GetProcessHandle(everquest_process_id)

;MsgBox, everquest_process_handle = %everquest_process_handle%

If (everquest_process_handle = 0)
{
    MsgBox, Error: OpenProcess failed! Result: %A_LastError%
    ExitApp
    Return
}

SetTimer, TimerCamera, 100

SetTimer, TimerJoystick, 10

SetTimer, TimerUpdateProcess, 100

CameraHack_Disable()

SetNumlockState, On

Gui, Show, Center, c

Return

CheckboxCameraHack:
GuiControlGet, is_checked,, CheckboxCameraHack

If (is_checked = 0)
{
    CameraHack_Disable()
}
Else
{
    CameraHack_Enable()
}
Return

NumLock::
SetNumlockState, On
Return

Joy9::
GuiControlGet, is_checked,, CheckboxCameraHack
If (is_checked = 0)
{
    GuiControl,, CheckboxCameraHack, 1
    Gosub, CheckboxCameraHack
}
Else
{
    GuiControl,, CheckboxCameraHack, 0
    Gosub, CheckboxCameraHack
}
Return

Joy11::
GuiControlGet, is_checked,, CheckboxCameraHack
If (is_checked = 0)
{
    Return
}

camera := everquest_GetCameraPointer()

camera_heading := Memory_ReadFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_HEADING)

camera_heading := camera_heading + (EVERQUEST_CAMERA_HEADING_MAX / 2)

If (camera_heading > EVERQUEST_CAMERA_HEADING_MAX)
{
   camera_heading := camera_heading - EVERQUEST_CAMERA_HEADING_MAX
}

Memory_WriteFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_HEADING, camera_heading)
Return

Joy12::
GuiControlGet, is_checked,, CheckboxCameraHack
If (is_checked = 0)
{
    Return
}

camera := everquest_GetCameraPointer()

Memory_WriteFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_PITCH, 0.0)
;Memory_WriteFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_PITCH, EVERQUEST_CAMERA_PITCH_DEFAULT)
Return

Joy1::
GuiControlGet, is_checked,, CheckboxCameraHack
If (is_checked = 0)
{
    Return
}

camera := everquest_GetCameraPointer()

Memory_WriteFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_HEADING, 0.0)
Return

Joy2::
GuiControlGet, is_checked,, CheckboxCameraHack
If (is_checked = 0)
{
    Return
}

camera := everquest_GetCameraPointer()

Memory_WriteFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_HEADING, 128.0)
Return

Joy3::
GuiControlGet, is_checked,, CheckboxCameraHack
If (is_checked = 0)
{
    Return
}

camera := everquest_GetCameraPointer()

Memory_WriteFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_HEADING, 256.0)
Return

Joy4::
GuiControlGet, is_checked,, CheckboxCameraHack
If (is_checked = 0)
{
    Return
}

camera := everquest_GetCameraPointer()

Memory_WriteFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_HEADING, 384.0)
Return

TimerCamera:
camera := everquest_GetCameraPointer()

camera_y := Memory_ReadFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_Y)
camera_x := Memory_ReadFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_X)
camera_z := Memory_ReadFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_Z)

camera_heading := Memory_ReadFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_HEADING)
camera_pitch   := Memory_ReadFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_PITCH)

GuiControl,, TextCameraY, Camera Y: %camera_y%
GuiControl,, TextCameraX, Camera X: %camera_x%
GuiControl,, TextCameraZ, Camera Z: %camera_z%

GuiControl,, TextCameraHeading, Camera Heading: %camera_heading%
GuiControl,, TextCameraPitch, Camera Pitch: %camera_pitch%

Return

TimerJoystick:
GuiControlGet, is_checked,, CheckboxCameraHack
If (is_checked = 0)
{
    Return
}

joy_x_default := 50
joy_y_default := 50
joy_z_default := 50
joy_r_default := 50

joy_threshold := 10

joy_sensitivity := 0.1

joy_x_threshold_upper := joy_x_default + joy_threshold
joy_x_threshold_lower := joy_x_default - joy_threshold

joy_y_threshold_upper := joy_y_default + joy_threshold
joy_y_threshold_lower := joy_y_default - joy_threshold

joy_z_threshold_upper := joy_z_default + joy_threshold
joy_z_threshold_lower := joy_z_default - joy_threshold

joy_r_threshold_upper := joy_r_default + joy_threshold
joy_r_threshold_lower := joy_r_default - joy_threshold

GetKeyState, joy_x, 1JoyX
GetKeyState, joy_y, 1JoyY
GetKeyState, joy_z, 1JoyZ
GetKeyState, joy_r, 1JoyR

joystick_analog_left_moved  := False
joystick_analog_right_moved := False


If (joy_x > joy_x_threshold_upper)
{
    joystick_analog_left_moved := true

    delta_x := ((joy_x - joy_x_default) * (50 / (100 - joy_x_default)))
}
Else If (joy_x < joy_x_threshold_lower)
{
    joystick_analog_left_moved := true

    delta_x := (joy_x * 50 / joy_x_default) - 50
}
Else
{
    delta_x := 0
}


If (joy_y > joy_y_threshold_upper)
{
    joystick_analog_left_moved := true

    delta_y := ((joy_y - joy_y_default) * (50 / (100 - joy_y_default)))
}
Else If (joy_y < joy_y_threshold_lower)
{
    joystick_analog_left_moved := true

    delta_y := (joy_y * 50 / joy_y_default) - 50
}
Else
{
    delta_y := 0
}


If (joy_z > joy_z_threshold_upper)
{
    joystick_analog_right_moved := true

    delta_z := ((joy_z - joy_z_default) * (50 / (100 - joy_z_default)))
}
Else If (joy_z < joy_z_threshold_lower)
{
    joystick_analog_right_moved := true

    delta_z := (joy_z * 50 / joy_z_default) - 50
}
Else
{
    delta_z := 0
}


If (joy_r > joy_r_threshold_upper)
{
    joystick_analog_right_moved := true

    delta_r := ((joy_r - joy_r_default) * (50 / (100 - joy_r_default)))
}
Else If (joy_r < joy_r_threshold_lower)
{
    joystick_analog_right_moved := true

    delta_r := (joy_r * 50 / joy_r_default) - 50
}
Else
{
    delta_r := 0
}


If joystick_analog_left_moved
{
    camera := everquest_GetCameraPointer()

    camera_y := Memory_ReadFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_Y)
    camera_x := Memory_ReadFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_X)
    camera_z := Memory_ReadFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_Z)

    camera_heading := Memory_ReadFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_HEADING)
    camera_pitch   := Memory_ReadFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_PITCH)

    camera_heading := (camera_heading * 360) / 512 ; convert from 512 degrees to 360 degrees

    camera_heading -= 90 ; rotate by -90 degrees

    is_strafing := False

    If (delta_x = 0)
    {
        is_strafing := False
    }
    Else
    {
        is_strafing := True
    }

    If (delta_y > 0)
    {
        If (delta_x < 0)
        {
            camera_heading -= Abs((90 * delta_x) / joy_x_default)
        }
        Else If (delta_x > 0)
        {
            camera_heading += (90 * delta_x) / joy_x_default
        }
    }
    Else
    {
        If (delta_x < 0)
        {
            camera_heading += Abs((90 * delta_x) / joy_x_default)
        }
        Else If (delta_x > 0)
        {
            camera_heading -= (90 * delta_x) / joy_x_default
        }
    }

    If (camera_heading < 0)
    {
        camera_heading += 360
    }

    camera_heading_radians := camera_heading * PI / 180 ; convert degrees to radians

    camera_pitch := camera_pitch + Abs(EVERQUEST_CAMERA_PITCH_DEFAULT) ; remove negative offset from camera pitch

    camera_pitch := (camera_pitch * 360) / 512 ; convert from 512 degrees to 360 degrees

    camera_pitch_radians := camera_pitch * PI / 180 ; convert degrees to radians

    add_y := Sin(camera_heading_radians)
    add_x := Cos(camera_heading_radians)
    add_z := Sin(camera_pitch_radians)

    multiplier := 1

    GetKeyState, state, Joy8
    If state = D
    {
        multiplier := 2
    }

    GetKeyState, state, Joy6
    If state = D
    {
        multiplier := 0.5
    }

    If (delta_y < 0)
    {
        delta_y := Abs(delta_y)
        
        camera_y -= add_y * (delta_y / 10) * multiplier
        camera_x += add_x * (delta_y / 10) * multiplier

        camera_z += add_z * (delta_y / 10) * multiplier
    }
    Else If (delta_y > 0)
    {
        camera_y += add_y * (delta_y / 10) * multiplier
        camera_x -= add_x * (delta_y / 10) * multiplier

        camera_z -= add_z * (delta_y / 10) * multiplier
    }
    Else
    {
        camera_y -= add_y * multiplier
        camera_x += add_x * multiplier

        camera_z += add_z * multiplier
    }

    Memory_WriteFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_Y, camera_y)
    Memory_WriteFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_X, camera_x)
    Memory_WriteFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_Z, camera_z)

    ;ToolTip, add_y = %add_y%`nadd_x = %add_x%`nadd_z = %add_z%`n`ndelta_x = %delta_x%`ndelta_y = %delta_y%`ndelta_z = %delta_z%`ndelta_r = %delta_r%
}

If joystick_analog_right_moved
{
    ;ToolTip, delta_x = %delta_x%`ndelta_y = %delta_y%`ndelta_z = %delta_z%`ndelta_r = %delta_r%

    camera := everquest_GetCameraPointer()

    camera_heading := Memory_ReadFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_HEADING)
    camera_pitch   := Memory_ReadFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_PITCH)

    multiplier := 1

    GetKeyState, state, Joy8
    If state = D
    {
        multiplier := 2
    }

    GetKeyState, state, Joy6
    If state = D
    {
        multiplier := 0.5
    }


    camera_heading_sub := delta_z * joy_sensitivity * multiplier

    If ((camera_heading - camera_heading_sub) >= EVERQUEST_CAMERA_HEADING_MAX)
    {
        camera_heading := EVERQUEST_CAMERA_HEADING_MIN
    }

    If ((camera_heading - camera_heading_sub) <= EVERQUEST_CAMERA_HEADING_MIN)
    {
        camera_heading := EVERQUEST_CAMERA_HEADING_MAX
    }

    camera_heading := camera_heading - camera_heading_sub


    camera_pitch_sub := delta_r * joy_sensitivity * multiplier

    If ((camera_pitch - camera_pitch_sub) > EVERQUEST_CAMERA_PITCH_MAX)
    {
        camera_pitch := EVERQUEST_CAMERA_PITCH_MAX
    }

    If ((camera_pitch - camera_pitch_sub) < EVERQUEST_CAMERA_PITCH_MIN)
    {
        camera_pitch := EVERQUEST_CAMERA_PITCH_MIN
    }

    camera_pitch := camera_pitch - camera_pitch_sub


    Memory_WriteFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_HEADING, camera_heading)
    Memory_WriteFloat(everquest_process_handle, camera + EVERQUEST_OFFSET_CAMERA_PITCH,   camera_pitch)
}
Return

TimerUpdateProcess:
If WinNotActive, EverQuest
{
    Return
}

WinGet, active_process_id, PID, A

script_process_id := DllCall("GetCurrentProcessId")

If (active_process_id = script_process_id)
{
    Return
}

If (active_process_id = everquest_process_id)
{
    Return
}

psapi_size := 4096

psapi_size := VarSetCapacity(psapi_processes, psapi_size)
DllCall("Psapi.dll\EnumProcesses", "Ptr", &psapi_processes, "UInt", psapi_size, "UIntP", psapi_process)

Loop, % psapi_process // 4
{
    psapi_process_id := NumGet(psapi_processes, A_Index * 4, "UInt")

    psapi_process_handle := DllCall("OpenProcess", "UInt", 0x0010 | 0x0400, "Int", false, "UInt", psapi_process_id, "Ptr")

    If (!psapi_process_handle)
    {
        Continue
    }

    VarSetCapacity(psapi_process_name, psapi_size, 0)
    psapi_result := DllCall("Psapi.dll\GetModuleBaseName", "Ptr", psapi_process_handle, "Ptr", 0, "Str", psapi_process_name, "UInt", A_IsUnicode ? psapi_size // 2 : psapi_size)

    If (!psapi_result)
    {
        If psapi_result := DllCall("Psapi.dll\GetProcessImageFileName", "Ptr", psapi_process_handle, "Str", psapi_process_name, "UInt", A_IsUnicode ? psapi_size // 2 : psapi_size)
        {
            SplitPath, psapi_process_name, psapi_process_name
        }
    }

    DllCall("CloseHandle", "Ptr", psapi_process_handle)

    If (psapi_result && psapi_process_name)
    {
        If psapi_process_name = %EVERQUEST_CLIENT%
        {
            If (psapi_process_id = active_process_id)
            {
                everquest_process_id := psapi_process_id

                everquest_process_handle := Memory_GetProcessHandle(everquest_process_id)

                Break
            }
        }
    }
}

Return

GuiClose:
GuiEscape:

SetTimer, TimerUpdateProcess, Off

SetTimer, TimerCamera, Off

SetTimer, TimerJoystick, Off

CameraHack_Disable()

DllCall("FreeLibrary", "Ptr", psapi_dll_handle)
Memory_CloseHandle(everquest_process_handle)

ExitApp

Return
