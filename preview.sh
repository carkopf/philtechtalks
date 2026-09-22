#!/bin/sh
# Local preview server using the Hugo version pinned in netlify.toml.
exec "$(dirname "$0")/.hugo-bin/hugo" server -D --disableFastRender
