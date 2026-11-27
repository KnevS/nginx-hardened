# nginx-hardened

nginx auf Alpine 3.24 mit tagesaktuellen Sicherheitsupdates.

Das offizielle Image wird nur neu gebaut, wenn nginx oder Alpine eine neue
Version bekommt. Paketfixes liegen im Alpine-Repo oft deutlich früher bereit.
Dieses Image holt sie per `apk upgrade`.

- Täglicher Neubau (23:05 UTC), ohne Build-Cache, mit Funktionstest
- Trivy-Vergleich gegen `:stable`: veröffentlicht wird nur, wenn sich der
  Paketstand geändert hat und keine neuen behebbaren HIGH/CRITICAL dazukommen
- Ohne Änderung bleibt `:stable` gleich, Watchtower startet nichts unnötig neu

```yaml
image: ghcr.io/knevs/nginx-hardened:stable
```

Drop-in-Ersatz für `nginx:alpine` (gleiche Pfade, gleicher Entrypoint), linux/amd64. Basis ist Alpine 3.24 statt 3.23, weil die libxml2-Fixes nur dort existieren. nginx kommt aus dem 3.24-Repo (1.30.x), ohne die optionalen Module des Upstream-Images.
