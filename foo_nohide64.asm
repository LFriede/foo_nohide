format PE64 GUI DLL
entry DllEntryPoint

include 'win64a.inc'

include 'foobar2k_sdk64.inc'

section '.data' data readable writeable
  componentversion_guid GUID 10BB3EBD-DDF7-4975-A3CC-23084829453E
  componentversion_impl:
    dq .create ; constructor
    dq $+8 ; vftable
    dq .notsure
    dq .dontknow
    dq 0
    dq .f2k_get_file_name
    dq .f2k_get_component_name
    dq .f2k_get_component_version
    dq .f2k_get_about_message

  ; Service list: ptr, next item, guid
  service_list  dq\
    componentversion_impl, 0, componentversion_guid

  pf2k_get_version        dq f2k_get_version
  pf2k_get_service_list   dq f2k_get_service_list
  pf2k_get_config         dq f2k_get_config
  pf2k_set_config         dq f2k_set_config
  pf2k_set_library_path   dq f2k_set_library_path
  pf2k_services_init      dq f2k_services_init
  pf2k_is_debug           dq f2k_is_debug

  f2k_client foobar2000_client\
    pf2k_get_version,\
    pf2k_get_service_list,\
    pf2k_get_config,\
    pf2k_set_config,\
    pf2k_set_library_path,\
    pf2k_services_init,\
    pf2k_is_debug

  sFileName db "foo_nohide64.dll",0
  sFileName.length = $ - sFileName
  sComponentName db 'DON''T FUCKING HIDE THAT WINDOW ON STARTUP, WTF!!!1!eleven',0
  sComponentName.length = $ - sComponentName
  sComponentVersion db "0.2",0
  sComponentVersion.length = $ - sComponentVersion
  sAboutMessage db "Yeah, seriously...",13,10,13,10,"Written in 100% gluten free ASM by gORDon_vdLg -> https://github.com/LFriede/foo_nohide"
  sAboutMessage.length = $ - sAboutMessage

  g_foobar2000_api dq 0
  nIDEvent dq 0


section '.code' code readable executable

proc DllEntryPoint hinstDLL, fdwReason, lpvReserved
  mov eax, 1
  ret
endp

proc TimerProc hwnd, uMsg, idEvent, dwTime
  local loc_hwnd:QWORD

  mov rcx, [g_foobar2000_api] ;not passed in following fastcall macro, but must be in rcx (this)
  mov rax, [rcx]
  fastcall [rax + foobar2000_api_vftable.get_main_window]
  mov [loc_hwnd], rax

  test rax, rax
  jz @f
    invoke KillTimer, 0, [nIDEvent]

    invoke ShowWindow, [loc_hwnd], SW_RESTORE
  @@:

  ret
endp


; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
; SDK functions
proc foobar2000_get_interface p_api, hIns
  mov [g_foobar2000_api], rcx ; p_api

  mov rax, f2k_client
  ret
endp

proc f2k_get_version
  mov rax, FOOBAR2000_CLIENT_VERSION
  ret
endp

proc f2k_get_service_list
  mov rax, service_list
  ret
endp

proc f2k_get_config p_stream, p_abort
  mov rax, 0 ; sdk creates empty function if win32 is not definded
  ret
endp

proc f2k_set_config p_stream, p_abort
  mov rax, 0 ; sdk creates empty function if win32 is not definded
  ret
endp

proc f2k_set_library_path path, name
  mov rax, 0
  ret
endp

proc f2k_services_init val
  invoke SetTimer, 0, 0, 100, TimerProc
  mov [nIDEvent], rax

  mov rax, 0
  ret
endp

proc f2k_is_debug
  mov rax, 0
  ret
endp


; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
; SDK functions - componentversion; rcx = this, 1st param in rdx
proc componentversion_impl.create out ; constructor, returns static ptr to vftable address in my case
  lea r10, [componentversion_impl+8]
  mov [rdx], r10

  ret
endp

proc componentversion_impl.notsure
  mov rax, 1
  ret
endp

proc componentversion_impl.dontknow
  mov rax, 1
  ret
endp

proc componentversion_impl.f2k_get_file_name out
  mov r10, rdx
  mov rax, [rdx]

  fastcall [rax + string8_t_vftable.set_string], r10, sFileName, sFileName.length

  ret
endp

proc componentversion_impl.f2k_get_component_name out
  mov r10, rdx
  mov rax, [rdx]

  fastcall [rax + string8_t_vftable.set_string], r10, sComponentName, sComponentName.length

  ret
endp

proc componentversion_impl.f2k_get_component_version out
  mov r10, rdx
  mov rax, [rdx]

  fastcall [rax + string8_t_vftable.set_string], r10, sComponentVersion, sComponentVersion.length

  ret
endp

proc componentversion_impl.f2k_get_about_message out
  mov r10, rdx ; out this
  mov rax, [rdx]

  ; thiscall, with "this" saved in r10
  fastcall [rax + string8_t_vftable.set_string], r10, sAboutMessage, sAboutMessage.length

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