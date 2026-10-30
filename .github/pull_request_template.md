<!--
Thanks for contributing Midea Lua protocol files!
Please fill in the summary and tick the checklist below.
-->

## Summary

<!-- Which device(s) does this cover? Include device type, SN8/model, and the cloud account the files were downloaded from (美的美居, SmartHome, Midea Air, NetHome Plus, Ariston Clima). -->

- Device type:
- Model / SN8:
- Cloud:

## Checklist

- [ ] Each Lua file is placed under `lua/` in the subdirectory for its device
      type byte (e.g. `lua/0xAC/`, `lua/0xCD/`). New `lua/0x<TYPE>/` directories
      are created as needed.
- [ ] The original downloaded filename is preserved (SN8 and version intact);
      files are not renamed.
- [ ] Lua source was formatted before committing (VS Code Lua formatter, StyLua,
      or equivalent) so it is readable and reviewable from the web UI.
- [ ] Files are UTF-8 without BOM and use Unix (LF) line endings.
- [ ] The PR contains only the intended protocol files and documentation — no
      stray downloads, secrets, or unrelated changes.

## Notes

<!-- Anything reviewers should know: protocol quirks, variant patterns, related issues. -->
