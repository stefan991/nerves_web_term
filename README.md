# NervesWebTerm

This is a simple web based terminal connected to the Raspberry Pi UART.
It uses https://xtermjs.org as terminal.

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

## Getting Started

To start this Nerves app:
  * `export MIX_TARGET=my_target` or prefix every command with
    `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi0`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`
  * Connect the Raspberry Pi to some serial port
  * Open http://nerves.local


## Other usefull Stuff
  * Upgrade SDCard without losing data with `mix firmware.burn --task upgrade`
  * Update over SSH with `./upload $IP_OR_HOSTNAME`
  * Connect to an IEx console with `ssh $IP_OR_HOSTNAME`
  * Set the serialnumber (hostname = nerves-$SERIAL_NUMBER) with
    `cmd("fw_setenv serial_number abc123")` on the remote IEx console.
  * Configure WiFi using VintageNet:

```
VintageNet.configure("wlan0", %{
  type: VintageNetWiFi,
  vintage_net_wifi: %{
    networks: [
      %{
        key_mgmt: :wpa_psk,
        ssid: "my_network_ssid",
        psk: "a_passphrase_or_psk"
      }
    ]
  },
  ipv4: %{method: :dhcp},
})

```
