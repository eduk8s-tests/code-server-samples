# Produce VSIX file for eduk8s-vscode-helper extension at /work/eduk8s-vscode-helper-0.0.1.vsix
FROM node:current as eduk8s-vscode-helper
RUN mkdir /work
WORKDIR /work
ADD https://codeload.github.com/eduk8s/eduk8s-vscode-helper/zip/c7d582231aa2e8f62e9c3d140a80e0381a4aa59e /work/extension.zip
RUN unzip extension.zip 
RUN rm extension.zip
RUN cd eduk8s-vscode-helper-* && npm install && npm run vsce-package && mv *.vsix ..

# Produce VSIX file for vscode-spring-initializr extension at /work/vscode-spring-initializr-0.4.8.vsix
FROM node:current as vscode-spring-initializr
RUN mkdir /work
WORKDIR /work
ADD https://github.com/BoykoAlex/vscode-spring-initializr/archive/customize.zip /work/initializr-extension.zip
RUN unzip initializr-extension.zip 
RUN rm initializr-extension.zip
RUN cd vscode-spring-initializr-* \
    && npm install \
    && npm install vsce --save-dev \
    && ./node_modules/.bin/vsce package \
    && mv *.vsix /work

# Produces installed copies of eduk8s-vscode-helper and vscode-spring-initializr at /opt/code-server/java-extensions
FROM quay.io/eduk8s/pkgs-code-server:200617.031609.8e8a4e1 AS code-server

COPY --from=eduk8s-vscode-helper --chown=1001:0 /work/eduk8s-vscode-helper-0.0.1.vsix /tmp/eduk8s-vscode-helper-0.0.1.vsix
RUN mkdir /opt/code-server/java-extensions && \
    /opt/code-server/bin/code-server --extensions-dir /opt/code-server/java-extensions --install-extension /tmp/eduk8s-vscode-helper-0.0.1.vsix && \
    rm /tmp/*.vsix

COPY --from=vscode-spring-initializr --chown=1001:0 /work/vscode-spring-initializr-0.4.8.vsix /tmp/vscode-spring-initializr-0.4.8.vsix
RUN /opt/code-server/bin/code-server --extensions-dir /opt/code-server/java-extensions --install-extension /tmp/vscode-spring-initializr-0.4.8.vsix && \
    rm /tmp/*.vsix

# Layers the installed java vscode extensions into eduk8s Java environment image
FROM quay.io/eduk8s/jdk11-environment:200731.081701.f6c3787

# Remove original vscode-initializr extension before the new forked installed
RUN rm -rf /opt/code-server/extensions/vscjava.vscode-spring-initializr* \
    && rm -rf /opt/vscode-spring-initializr

COPY --from=code-server --chown=1001:0 /opt/code-server/java-extensions /opt/code-server/extensions

# Modify code-server settings to open projects in the current workspace by default
RUN jq '."spring.initializr.defaultOpenProjectMethod"="Add to Workspace"' ~/.local/share/code-server/User/settings.json > ~/temp_settings.json \
    && mv ~/temp_settings.json ~/.local/share/code-server/User/settings.json

# COPY --chown=1001:0 . /home/eduk8s/
# RUN mv /home/eduk8s/workshop /opt/workshop
# RUN fix-permissions /home/eduk8s

