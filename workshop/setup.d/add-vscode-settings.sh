# Modify code-server settings to open projects in the current workspace by default
jq -M '. + {"spring.initializr.defaultOpenProjectMethod":"Add to Workspace", "java.semanticHighlighting.enabled":false, "java.help.firstView":"overview", "java.configuration.checkProjectSettingsExclusions":false, "files.exclude":{"**/.classpath": true, "**/.project": true, "**/.settings": true, "**/.factorypath": true}}' \
    $HOME/.local/share/code-server/User/settings.json > $HOME/temp_settings.json \
    && mv $HOME/temp_settings.json $HOME/.local/share/code-server/User/settings.json