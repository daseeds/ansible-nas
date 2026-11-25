FROM python:3.11-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1

RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates git nodejs npm openssh-client \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --no-cache-dir \
      ansible==8.7.0 \
      ansible-lint==6.14.6 \
      yamllint==1.30.0 \
      'molecule[docker]==4.0.1' \
      pytest \
      pytest-molecule \
    && npm install --global markdownlint-cli@0.32.2

WORKDIR /workspace
