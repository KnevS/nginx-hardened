# nginx auf Alpine 3.24 mit allen Alpine-Sicherheitsupdates.
#
# Warum nicht mehr `FROM nginx:alpine`: Das Upstream-Image liegt auf Alpine 3.23.
# Dort fehlen die libxml2-Fixes (CVE-2026-86138 ff., 2.13.9-r3 bzw. r4/r5), die
# es nur im 3.24-Repo gibt. Ein `apk upgrade` auf 3.23 holt sie nicht.
#
# Drop-in-Ersatz für nginx:alpine: gleiche Pfade, gleicher Entrypoint, gleiche
# Default-Config und Standardseite. Entrypoint, Default-Config und Seite stammen
# aus dem offiziellen Image (COPY --from), nginx selbst aus dem Alpine-3.24-Repo.
# Der Workflow baut täglich neu und veröffentlicht nur, wenn der Paketstand sich
# ändert und keine neuen behebbaren HIGH/CRITICAL dazukommen.
FROM nginx:alpine AS upstream

FROM alpine:3.24

LABEL org.opencontainers.image.title="nginx-hardened" \
      org.opencontainers.image.description="nginx auf Alpine 3.24 mit tagesaktuellen Sicherheitsupdates" \
      org.opencontainers.image.source="https://github.com/KnevS/nginx-hardened" \
      org.opencontainers.image.licenses="BSD-2-Clause"

RUN apk upgrade --no-cache \
 && apk add --no-cache nginx gettext-envsubst \
 && mkdir -p /docker-entrypoint.d /var/cache/nginx /var/log/nginx /etc/nginx/conf.d \
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

COPY --from=upstream /docker-entrypoint.sh /docker-entrypoint.sh
COPY --from=upstream /docker-entrypoint.d/ /docker-entrypoint.d/
COPY --from=upstream /etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=upstream /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY --from=upstream /usr/share/nginx/html/ /usr/share/nginx/html/

RUN chmod +x /docker-entrypoint.sh /docker-entrypoint.d/*.sh

EXPOSE 80
STOPSIGNAL SIGQUIT
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
