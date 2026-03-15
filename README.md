# derper

Container image scaffold for `ghcr.io/codeadminde/derper`.

This repository builds a pinned `derper` binary from upstream `tailscale.com/cmd/derper`
and ships it in a minimal non-root runtime image. It is intended for standalone DERP
relay deployments, for example together with Headscale, without compiling anything in
the cluster at rollout time.

## Image contract

- Upstream binary source: `tailscale.com/cmd/derper`
- Runtime image: distroless, non-root
- Entrypoint: `/usr/local/bin/derper`
- Exposed ports: `8080/tcp`, `8443/tcp`, `3478/udp`
- Recommended image tags follow the upstream Tailscale release without the leading `v`,
  for example `1.94.2`

## Build

```sh
docker build \
  --build-arg DERPER_VERSION=v1.94.2 \
  -t ghcr.io/codeadminde/derper:1.94.2 \
  .
```

## Runtime notes

- The image only provides the `derper` binary. Runtime flags such as `-c`, `-hostname`,
  `-certmode`, `-certdir`, `-stun`, and `-verify-client-url` are supplied by the
  deployment.
- `DERPER_VERSION` is tracked by Renovate from upstream `tailscale/tailscale` tags.
- A persistent writable path for the DERP node key and certificate cache is expected to
  be mounted by the workload using this image.
