#================================
# Base - Minimal shared foundation
#================================
FROM docker.io/databricksruntime/minimal:17.3-LTS AS base
WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        python3 \
        python3-pip \
        openssh-client \
        pipx \
        make \
    && rm -rf /var/lib/apt/lists/* \
    && pipx ensurepath

# Create python symlink
RUN ln -s /usr/bin/python3 /usr/bin/python


#================================
# Tools - Reusable common tools
#================================
FROM base AS tools

USER ubuntu
RUN mkdir -p /home/ubuntu/.local/bin
RUN pipx install pre-commit \
    && pipx install python-semantic-release \
    && pipx install ruff==0.15.0
ENV PATH="/home/ubuntu/.local/bin:${PATH}"


#================================
# Dev stage
#================================
FROM tools AS dev

RUN pipx install pytest==9.0.2 \
    && pipx install commitizen


#================================
# CI stage
#================================
FROM tools AS ci

# Sphinx install
COPY docs/requirements.txt /tmp/docs-requirements.txt
RUN pipx install sphinx \
    && pipx runpip sphinx install --no-cache-dir -r /tmp/docs-requirements.txt
