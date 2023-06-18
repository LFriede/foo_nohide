FOOBAR2000_CLIENT_VERSION = FOOBAR2000_TARGET_VERSION
FOOBAR2000_TARGET_VERSION = 81 ; 2.0

struct foobar2000_api_vftable
  service_enum_find_class  dq ?
  service_enum_create      dq ?
  service_enum_get_count   dq ?
  get_main_window          dq ?
  assert_main_thread       dq ?
  is_main_thread           dq ?
  is_shutting_down         dq ?
  get_profile_path         dq ?
  is_initializing          dq ?
  is_portable_mode_enabled dq ?
  is_quiet_mode_enabled    dq ?
ends

struct string8_t_vftable
  add_string    dq ?
  get_ptr       dq ?
  set_string    dq ?
  truncate      dq ?
  get_length    dq ?
  lock_buffer   dq ?
  unlock_buffer dq ?
ends

struc foobar2000_client get_version, get_service_list, get_config, set_config, set_library_path, services_init, is_debug {
  .get_version        dq get_version
  .get_service_list   dq get_service_list
  .get_config         dq get_config
  .set_config         dq set_config
  .set_library_path   dq set_library_path
  .services_init      dq services_init
  .is_debug           dq is_debug
}

; This one is the GUID macro from the "USECOM" example in your FASM folder.
struc GUID def
 {
   match d1-d2-d3-d4-d5, def
    \{
      .Data1 dd 0x\#d1
      .Data2 dw 0x\#d2
      .Data3 dw 0x\#d3
      .Data4 db 0x\#d4 shr 8,0x\#d4 and 0FFh
      .Data5 db 0x\#d5 shr 40,0x\#d5 shr 32 and 0FFh,0x\#d5 shr 24 and 0FFh,0x\#d5 shr 16 and 0FFh,0x\#d5 shr 8 and 0FFh,0x\#d5 and 0FFh
    \}
 }