FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    jq \
    && rm -rf /var/lib/apt/lists/*

RUN PROTO="https://" \
    && HOST="api.github.com" \
    && PATH_REPO="repos/jwilger/auto_review/releases/latest" \
    && RELEASE_URL=$(curl -fsSL "${PROTO}${HOST}/${PATH_REPO}" \

        | jq -r '.assets[] | select(.name | endswith("-linux-x86_64.tar.gz")) | .browser_download_url') \
    && test -n "$RELEASE_URL" \
    && echo "Downloaden van: $RELEASE_URL" \
    && curl -fL "$RELEASE_URL" -o /tmp/auto-review.tar.gz \
    && tar -xzf /tmp/auto-review.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/auto-review \
    && rm /tmp/auto-review.tar.gz

WORKDIR /data
CMD ["auto-review", "gateway", "--bare"]
