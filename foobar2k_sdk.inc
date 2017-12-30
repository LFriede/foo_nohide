FOOBAR2000_CLIENT_VERSION = FOOBAR2000_TARGET_VERSION
FOOBAR2000_TARGET_VERSION = 78

struct foobar2000_api_vftable
  service_enum_find_class  dd ?
  service_enum_create      dd ?
  service_enum_get_count   dd ?
  get_main_window          dd ?
  assert_main_thread       dd ?
  is_main_thread           dd ?
  is_shutting_down         dd ?
  get_profile_path         dd ?
  is_initializing          dd ?
  is_portable_mode_enabled dd ?
  is_quiet_mode_enabled    dd ?
ends

struct string8_t_vftable
  add_string    dd ?
  get_ptr       dd ?
  set_string    dd ?
  truncate      dd ?
  get_length    dd ?
  lock_buffer   dd ?
  unlock_buffer dd ?
ends

struc foobar2000_client get_version, get_service_list, get_config, set_config, set_library_path, services_init, is_debug {
  .get_version        dd get_version
  .get_service_list   dd get_service_list
  .get_config         dd get_config
  .set_config         dd set_config
  .set_library_path   dd set_library_path
  .services_init      dd services_init
  .is_debug           dd is_debug
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
