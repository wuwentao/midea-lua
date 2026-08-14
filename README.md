# Midea Lua

This repository collects Lua protocol files for Midea appliances. Retrieve files with the
[`midea-lan`](https://github.com/wuwentao/midea-lan) CLI, then add or organize the results
here as appropriate.

## Download files

Install `midea-lan`, or clone it and create its development environment:

```bash
git clone https://github.com/wuwentao/midea-lan.git
cd midea-lan
./scripts/setup.sh
```

Use the installed `midealan` command, or run the command through `uv` from the clone:

```bash
# Show all download options
uv run python -m midealan.cli download --help

# Device found at a LAN address
uv run python -m midealan.cli download \
  --cloud-name "美的美居" --username "user@example.com" --password "password" \
  --host 192.0.2.121

# One device in the cloud account
uv run python -m midealan.cli download \
  --cloud-name "SmartHome" --username "user@example.com" --password "password" \
  --device-sn "0000005112429652937220340014X2X3"

# Specify a hexadecimal device type when needed
uv run python -m midealan.cli download \
  --cloud-name "SmartHome" --username "user@example.com" --password "password" \
  --device-sn "0000005112429652937220340014X2X3" --device-type AC

# Every device in the cloud account
uv run python -m midealan.cli download \
  --cloud-name "SmartHome" --username "user@example.com" --password "password"
```

Supported cloud names are `美的美居`, `SmartHome`, `Midea Air`, `NetHome Plus`, and
`Ariston Clima`. Downloaded files are written to the current working directory; move them
under `lua/` or another suitable directory before contributing them here.

The target selection order is:

1. `--host`: discovers one device on the LAN. If both `--host` and `--device-sn` are given,
   `--host` takes precedence.
2. `--device-sn`: downloads one device by serial number.
3. Neither option: downloads every device in the cloud account.

For `--device-sn`, the device type comes from `--device-type` when supplied, then from a
matching cloud-account appliance, and finally from the legacy type byte in the serial
number. `--device-type` accepts a hexadecimal value such as `AC` or `ac`.

Each device is processed independently, so an individual Lua or plugin failure is logged
without stopping an account-wide download. `美的美居` and `SmartHome` support Lua and
plugin downloads. `Midea Air`, `NetHome Plus`, and `Ariston Clima` use a legacy backend
that supports Lua downloads but not plugin downloads.

## Contributing

1. Format Lua protocol files with VS Code or an equivalent formatter.
2. Submit a pull request containing only the intended protocol files and documentation.
