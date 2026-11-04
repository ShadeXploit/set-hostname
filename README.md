# set-hostname

Prompts for a new hostname and applies it persistently on any Linux distro.

## One-liner

Nothing is written to disk: the script is streamed straight into bash, so no repo or file is left behind.

```bash
curl -fsSL https://raw.githubusercontent.com/ShadeXploit/set-hostname/main/set-hostname.sh | sudo bash
```

Or with `wget`:

```bash
wget -qO- https://raw.githubusercontent.com/ShadeXploit/set-hostname/main/set-hostname.sh | sudo bash
```

## What it does

- Requires root
- Asks for the hostname (read from `/dev/tty`, so it works when piped)
- Validates it, then sets it with `hostnamectl` (falls back to `hostname` + `/etc/hostname`)
- Updates the `127.0.1.1` entry in `/etc/hosts` to avoid sudo warnings

## Leaving no trace

The script itself le
leaves no files. The hostname change and the `/etc/hosts` edit are the only system modifications.
Shell history may still record the command; to avoid that, prefix the command with a space
(when `HISTCONTROL=ignorespace`) or run `history -d $(history 1 | awk '{print $1}')` afterwards.
