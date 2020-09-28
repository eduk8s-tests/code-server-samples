# Produce VSIX file for vscode-spring-initializr extension at /work/vscode-spring-initializr-0.4.8.vsix
FROM node:current as vscode-spring-initializr
RUN mkdir /work
WORKDIR /work
ADD https://github.com/microsoft/vscode-spring-initializr/archive/master.zip /work/initializr-extension.zip
RUN unzip initializr-extension.zip 
RUN rm initializr-extension.zip
RUN cd vscode-spring-initializr-* \
    && npm install \
    && npm install vsce --save-dev \
    && ./node_modules/.bin/vsce package \
    && mv *.vsix /work

FROM quay.io/eduk8s/eduk8s-vscode-helper:200807.182328.2129ce9 AS vscode-helper

# Produces installed copy of vscode-spring-initializr at /opt/code-server/initializr-extension
FROM quay.io/eduk8s/pkgs-code-server:200617.031609.8e8a4e1 AS code-server
COPY --from=vscode-spring-initializr --chown=1001:0 /work/vscode-spring-initializr-0.5.0.vsix /tmp/vscode-spring-initializr-0.5.0.vsix
RUN /opt/code-server/bin/code-server --extensions-dir /opt/code-server/initializr-extension --install-extension /tmp/vscode-spring-initializr-0.5.0.vsix && \
    rm /tmp/*.vsix

# Layers the installed java vscode extensions into eduk8s Java environment image
FROM quay.io/eduk8s/jdk11-environment:200731.081701.f6c3787

# Install eduk8s-vscode-helper extension into Code-Server
COPY --from=vscode-helper --chown=1001:0 /opt/eduk8s/workshop/code-server/extensions/. /opt/code-server/extensions/
COPY --from=vscode-helper --chown=1001:0 /opt/eduk8s/workshop/gateway/routes/. /opt/eduk8s/workshop/gateway/routes/

# Remove original vscode-initializr extension before the new forked installed
RUN rm -rf /opt/code-server/extensions/vscjava.vscode-spring-initializr* \
    && rm -rf /opt/vscode-spring-initializr

COPY --from=code-server --chown=1001:0 /opt/code-server/initializr-extension/. /opt/code-server/extensions/
