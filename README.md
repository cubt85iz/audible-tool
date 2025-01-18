# audible-tool

Lightweight container that uses ffmpeg to convert AAX audiobooks to M4B audiobooks.

## Usage

### Environment Variables

- `ACTIVATION_BYTES`: Specify sequence of activation bytes for decoding DRM
- `REMOVE_PROCESSED_FILES`: Specify a non-zero value to remove AAX audiobooks after they have been converted.

### Volumes

- `consume`: Storage location for AAX files to be processed
- `staging`: Storage location for converted M4B files

### Quadlet

The configuration described below allows you to monitor a folder for new files and automatically created M4B files using the audible-tool container.

_~/.config/containers/systemd/audible-tool.container_

```
[Unit]
Description=Container for processing Audible AAX files

[Container]
ContainerName=%p
Image=ghcr.io/cubt85iz/audible-tool:latest
Volume=%h/Downloads:/consume:z,rw,rslave,rbind
Volume=%h/Audiobooks:/staging:z,rw,rslave,rbind
AutoUpdate=registry

[Service]
Restart=on-failure
```

~/.config/containers/systemd/audible-tool.container.d/00-audible-tool-variables.conf_

```
[Container]
Environment=ACTIVATION_BYTES=XYZ123AA
Environment=REMOVE_PROCESSED_FILES=1
```

_~/.config/systemd/user/audible-tool.path_

```
[Unit]
Description=Service for processing Audible AAX files
Requires=audible-tool.service

[Path]
PathChanged=%h/Downloads

[Install]
WantedBy=default.target
```
