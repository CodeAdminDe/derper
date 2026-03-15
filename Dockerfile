# renovate: datasource=github-tags depName=tailscale/tailscale versioning=loose
ARG DERPER_VERSION=v1.94.2

FROM golang:1.26-alpine@sha256:2389ebfa5b7f43eeafbd6be0c3700cc46690ef842ad962f6c5bd6be49ed82039 AS build

LABEL org.opencontainers.image.source="https://github.com/codeadminde/derper"
LABEL org.opencontainers.image.description="Pinned Tailscale DERP relay image"

ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN apk add --no-cache ca-certificates git

RUN CGO_ENABLED=0 GOOS="${TARGETOS}" GOARCH="${TARGETARCH}" GOBIN=/out \
    go install tailscale.com/cmd/derper@"${DERPER_VERSION}"

FROM gcr.io/distroless/static:nonroot@sha256:e3f945647ffb95b5839c07038d64f9811adf17308b9121d8a2b87b6a22a80a39


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
