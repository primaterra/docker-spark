#================================
# Base - Minimal shared foundation
#================================
FROM docker.io/databricksruntime/minimal:17.3-LTS AS base
WORKDIR /app

ARG GIT_VERSION=1:2.43*
ARG OPENSSH_CLIENT_VERSION=1:9.6p1*
ARG PIPX_VERSION=1.4.3*
ARG MAKE_VERSION=4.3*

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git=${GIT_VERSION} \
        python3 \
        python3-pip \
        openssh-client=${OPENSSH_CLIENT_VERSION} \
        pipx=${PIPX_VERSION} \
        make=${MAKE_VERSION} \
    && rm -rf /var/lib/apt/lists/* \
    && pipx ensurepath

# Expose python binary
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10


#================================
# Tools - Reusable common tools
#================================
FROM base AS tools

USER ubuntu
RUN mkdir -p /home/ubuntu/.local/bin

ARG PRE_COMMIT_VERSION=4.5.1
ARG SEMANTIC_RELEASE_VERSION=10.5.3
ARG RUFF_VERSION=0.15.4
RUN pipx install pre-commit==${PRE_COMMIT_VERSION} \
    && pipx install python-semantic-release==${SEMANTIC_RELEASE_VERSION} \
    && pipx install ruff==${RUFF_VERSION}

ARG UPDATECLI_VERSION=v0.114.0
RUN curl -L -o /tmp/updatecli_Linux_x86_64.tar.gz \
      "https://github.com/updatecli/updatecli/releases/download/${UPDATECLI_VERSION}/updatecli_Linux_x86_64.tar.gz" && \
    curl -L -o /tmp/checksums.txt \
      "https://github.com/updatecli/updatecli/releases/download/${UPDATECLI_VERSION}/checksums.txt" && \
    cd /tmp && sha256sum --ignore-missing -c checksums.txt | grep -q 'updatecli_Linux_x86_64.tar.gz: OK' && \
    tar xzf updatecli_Linux_x86_64.tar.gz -C /home/ubuntu/.local/bin updatecli && \
    chmod +x /home/ubuntu/.local/bin/updatecli && \
    rm -f /tmp/updatecli_Linux_x86_64.tar.gz /tmp/checksums.txt

ENV PATH="/home/ubuntu/.local/bin:${PATH}"


#================================
# Dev stage
#================================
FROM tools AS dev

ARG PYTEST_VERSION=9.0.2
ARG COMMITIZEN_VERSION=4.13.9
RUN pipx install pytest==${PYTEST_VERSION} \
    && pipx install commitizen==${COMMITIZEN_VERSION}


#================================
# CI stage
#================================
FROM tools AS ci

# Sphinx install
COPY docs/requirements.txt /tmp/docs-requirements.txt

ARG SPHINX_VERSION=9.1.0
RUN pipx install sphinx==${SPHINX_VERSION} \
    && pipx runpip sphinx install --no-cache-dir -r /tmp/docs-requirements.txt
