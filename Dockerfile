# nginx:alpine mit allen Alpine-Sicherheitsupdates.
#
# Das offizielle Image wird nur neu gebaut, wenn nginx oder das Alpine-Basis-
# image eine neue Version bekommt. Paket-Fixes (libexpat, libx11, openssl …)
# liegen im Alpine-Repo oft Tage bis Wochen früher bereit. Dieses Image holt
# sie per `apk upgrade`; der Workflow baut täglich neu und veröffentlicht nur,
# wenn sich der Paketstand geändert hat.
#
# Basis bewusst ohne Digest: Ziel ist immer der aktuelle Upstream-Stand.
# Was genau drin ist, protokolliert jeder Lauf (Paketstand + Trivy-Vergleich).
FROM nginx:alpine

LABEL org.opencontainers.image.title="nginx-hardened" \
      org.opencontainers.image.description="nginx:alpine mit tagesaktuellen Alpine-Sicherheitsupdates" \
      org.opencontainers.image.source="https://github.com/KnevS/nginx-hardened" \
      org.opencontainers.image.licenses="BSD-2-Clause"

RUN apk upgrade --no-cache
