#================================
# Base
#================================
FROM docker.io/databricksruntime/minimal:17.3-LTS AS base

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        python3 \
        python3-pip \
        openssh-client \
        pipx \
    && rm -rf /var/lib/apt/lists/* \
    && pipx ensurepath

# Create python symlink
RUN ln -s /usr/bin/python3 /usr/bin/python


#================================
# Dev stage
#================================
FROM base AS dev

# Install pre-commit & comitizen as non-root
# using pre-defined user: `unbuntu`
USER ubuntu
RUN mkdir -p /home/ubuntu/.local/bin
RUN pipx install pre-commit \
    && pipx install python-semantic-release \
    && pipx install commitizen \
    && pipx install ruff==0.15.0 \
    && pipx install pytest==9.0.2

ENV PATH="/home/ubuntu/.local/bin:${PATH}"


#================================
# CI stage
#================================
# FROM base AS ci

# USER ubuntu
# RUN mkdir -p /home/ubuntu/.local/bin && \
#     pipx install pre-commit && \
#     pipx install python-semantic-release && \
#     pipx install commitizen && \
#     pipx install ruff==0.15.0

# ENV PATH="/home/ubuntu/.local/bin:${PATH}"
