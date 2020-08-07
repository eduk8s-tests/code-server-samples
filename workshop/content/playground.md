{% include "code-server/package.liquid" %}

## How to use `eduk8s-vscode-helper` in workshop content

When you see a block of code like below, you can click on it to automatically paste it into an editor:

<pre class="pastable" data-file="/home/eduk8s/Dockerfile" data-prefix="COPY --from">
# Multiple lines
# of stuff
# to paste
</pre>

Or paste into a new file works too:

<pre class="pastable" data-file="/tmp/deploy.yml">
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nother
          piece: here
        - name: nginx
          image: nginx:1.14.2
          ports:
          - containerPort: 80
</pre>

Text can also be pasted into a specific 'yaml path' location inside an existing yaml file.
For example, the following pastes an extra container definition into the
file created in the previous step:

<pre class="pastable" data-file="/tmp/deploy.yml" data-yaml-path="spec.template.spec.containers">
- name: another-container
  image: blah
  ports:
  - containerPort: 6677
</pre>

<pre class="pastable" data-file="/tmp/deploy.yml" data-yaml-path="spec.template.spec.containers[0]">
blah: blah
froo: froooooo
</pre>

Links like below can be clicked to open a file in the editor:

- <span class="editor_link" data-file="/home/eduk8s/Dockerfile" data-line="8"/>
- <span class="editor_link" data-file="/home/eduk8s/exercises/.empty"/>
- <span class="editor_link" data-file="/home/eduk8s/Dockerfile" data-line="10">Click me</span>

There are also links to execute commands in the IDE, e.g: <span class="editor_command_link" data-command="workbench.action.terminal.toggleTerminal">Open Terminal</span>.

Command parameters can be passed as JSON to the commands via a link in the workshop content, see the example below:
- <span class="editor_command_link" data-command="spring.initializr.maven-project">Create Spring Boot Maven Project 
    <parameter>
    {
        "language": "Java",
        "dependencies": ["actuator", "web", "devtools"],
        "artifactId": "web-project",
        "groupId": "com.eduk8s.example"
    }
    </parameter>
</span>

List of all parameters for Initializr Create Project command can be found [here](https://github.com/BoykoAlex/vscode-spring-initializr/blob/customize/src/handler/GenerateProjectHandler.ts#L20).
