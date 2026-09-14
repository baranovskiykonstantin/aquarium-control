# Windows installer

Build a Release `aquarium-control.exe` first (Qt Creator writes it under `build/<Kit>-Release/`).

Edit the Qt path variables at the top of `make_installer.ps1` when building on another machine, then run:

```
powershell -ExecutionPolicy Bypass -File installer\make_installer.ps1
```

The offline installer is written next to this file as `aquarium-control-<version>-windows_x86_64.exe`.
