# nginx-hardened

`nginx:alpine` mit tagesaktuellen Alpine-Sicherheitsupdates.

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

Drop-in-Ersatz für `nginx:alpine` (gleiche Pfade, gleicher Entrypoint), linux/amd64.
