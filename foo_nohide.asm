format PE GUI 4.0 DLL
entry DllEntryPoint

include 'win32a.inc'

include 'foobar2k_sdk.inc'

section '.data' data readable writeable
  componentversion_guid GUID 10BB3EBD-DDF7-4975-A3CC-23084829453E
  componentversion_impl:
    dd .create ; constructor
    dd $+4 ; vftable
    dd .notsure ; +0h i have no clue what this does, but we need it ;)
    dd .dontknow ; +4h will be called if you right click the plugin in the list (preferences)
    dd 0 ; +8h
    dd .f2k_get_file_name ; +Ch
    dd .f2k_get_component_name ; +10h
    dd .f2k_get_component_version ; +14h
    dd .f2k_get_about_message ; +18h

  ; Service list: ptr, next item, guid
  service_list  dd\
    componentversion_impl, 0, componentversion_guid

  pf2k_get_version        dd f2k_get_version
  pf2k_get_service_list   dd f2k_get_service_list
  pf2k_get_config         dd f2k_get_config
  pf2k_set_config         dd f2k_set_config
  pf2k_set_library_path   dd f2k_set_library_path
  pf2k_services_init      dd f2k_services_init
  pf2k_is_debug           dd f2k_is_debug

  f2k_client foobar2000_client\
    pf2k_get_version,\
    pf2k_get_service_list,\
    pf2k_get_config,\
    pf2k_set_config,\
    pf2k_set_library_path,\
    pf2k_services_init,\
    pf2k_is_debug

  sFileName db "foo_nohide.dll",0
  sFileName.length = $ - sFileName
  sComponentName db 'DON''T FUCKING HIDE THAT WINDOW ON STARTUP, WTF!!!1!eleven',0
  sComponentName.length = $ - sComponentName
  sComponentVersion db "0.1",0
  sComponentVersion.length = $ - sComponentVersion
  sAboutMessage db "Yeah, seriously...",13,10,13,10,"Written in 100% gluten free ASM by gORDon_vdLg -> https://github.com/LFriede/foo_nohide"
  sAboutMessage.length = $ - sAboutMessage

  g_foobar2000_api dd 0
  hHeap dd 0
  nIDEvent dd 0


section '.code' code readable executable

proc DllEntryPoint hinstDLL, fdwReason, lpvReserved
  mov eax, 1
  ret
endp

proc TimerProc hwnd, uMsg, idEvent, dwTime
  local loc_hwnd:DWORD

  mov ecx, [g_foobar2000_api]
  mov eax, [ecx]
  stdcall [eax + foobar2000_api_vftable.get_main_window]
  mov [loc_hwnd], eax

  test eax, eax
  jz @f
    invoke KillTimer, 0, [nIDEvent]

    invoke ShowWindow, [loc_hwnd], SW_RESTORE
  @@:

  ret
endp

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
; SDK functions
proc foobar2000_get_interface c, p_api, hIns
  mov eax, [p_api]
  mov [g_foobar2000_api], eax

  mov eax, f2k_client
  ret
endp

proc f2k_get_version
  mov eax, FOOBAR2000_CLIENT_VERSION
  ret
endp

proc f2k_get_service_list
  mov eax, service_list
  ret
endp

proc f2k_get_config p_stream, p_abort
  mov eax, 0 ; not implemented yet
  ret
endp

proc f2k_set_config p_stream, p_abort
  mov eax, 0 ; not implemented yet
  ret
endp

proc f2k_set_library_path path, name
  mov eax, 0
  ret
endp

proc f2k_services_init val
  invoke SetTimer, 0, 0, 100, TimerProc
  mov [nIDEvent], eax

  mov eax, 0
  ret
endp

proc f2k_is_debug
  mov eax, 0
  ret
endp

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
; SDK functions - componentversion
proc componentversion_impl.create out ; constructor, returns static ptr to vftable address in my case
  lea ecx, [componentversion_impl+4]

  mov eax, [out]
  mov dword [eax], ecx

  ret
endp

proc componentversion_impl.notsure
  mov eax, 1
  ret
endp

proc componentversion_impl.dontknow
  mov eax, 1
  ret
endp

proc componentversion_impl.f2k_get_file_name out
  mov ecx, [out]
  mov eax, [ecx]

  stdcall [eax + string8_t_vftable.set_string], sFileName, sFileName.length

  ret
endp

proc componentversion_impl.f2k_get_component_name out
  mov ecx, [out]
  mov eax, [ecx]

  stdcall [eax + string8_t_vftable.set_string], sComponentName, sComponentName.length

  ret
endp

proc componentversion_impl.f2k_get_component_version out
  mov ecx, [out]
  mov eax, [ecx]

  stdcall [eax + string8_t_vftable.set_string], sComponentVersion, sComponentVersion.length

  ret
endp

proc componentversion_impl.f2k_get_about_message out
  mov ecx, [out]
  mov eax, [ecx]

  stdcall [eax + string8_t_vftable.set_string], sAboutMessage, sAboutMessage.length

  ret
endp


section '.idata' import data readable
  library user32, 'user32.dll'

  import user32,\
    KillTimer, 'KillTimer',\
    SetTimer, 'SetTimer',\
    ShowWindow, 'ShowWindow'


section '.edata' export data readable
  export 'foo_nohide.dll',\
    foobar2000_get_interface, 'foobar2000_get_interface'


section '.reloc' fixups data readable discardable
  if ~ $-$$
    dd 0,8 ; empty fixups section if no other fixups
  end if
