FROM golang:1.26-alpine AS build

LABEL org.opencontainers.image.source="https://github.com/codeadminde/derper"
LABEL org.opencontainers.image.description="Pinned Tailscale DERP relay image"

# renovate: datasource=github-tags depName=tailscale/tailscale versioning=loose
ARG DERPER_VERSION=v1.97.0-pre
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN apk add --no-cache ca-certificates git

RUN CGO_ENABLED=0 GOOS="${TARGETOS}" GOARCH="${TARGETARCH}" \
    go install tailscale.com/cmd/derper@"${DERPER_VERSION}"

FROM gcr.io/distroless/static:nonroot

# renovate: datasource=github-tags depName=tailscale/tailscale versioning=loose
ARG DERPER_VERSION=v1.97.0-pre

LABEL org.opencontainers.image.source="https://github.com/codeadminde/derper"
LABEL org.opencontainers.image.description="Pinned Tailscale DERP relay image"
LABEL org.opencontainers.image.version="${DERPER_VERSION}"

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /out/derper /usr/local/bin/derper

EXPOSE 8080/tcp
EXPOSE 8443/tcp
EXPOSE 3478/udp

USER 65532:65532
ENTRYPOINT ["/usr/local/bin/derper"]
