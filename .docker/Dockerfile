#================================
# Base
#================================
FROM docker.io/databricksruntime/minimal:17.3-LTS AS base

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        git \
        python3 \
        python3-pip \
        openssh-client && \
    rm -rf /var/lib/apt/lists/*


#================================
# Dev stage
#================================
FROM base AS dev

RUN apt-get update && \
    apt-get install -y --no-install-recommends pipx && \
    rm -rf /var/lib/apt/lists/*


# Install pre-commit & comitizen as non-root
# using pre-defined `unbuntu` user
USER ubuntu
RUN mkdir -p /home/ubuntu/.local/bin
RUN pipx install pre-commit && \
    pipx install python-semantic-release && \
    pipx install commitizen
ENV PATH="/home/ubuntu/.local/bin:${PATH}"

# Install project requiremnets
WORKDIR /workspaces/${PROJECT_NAME}

RUN python3 -m venv /home/ubuntu/venv
ENV PATH="/home/ubuntu/venv/bin:${PATH}"

COPY --chown=ubuntu:ubuntu requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
#================================
# CI stage
#================================
