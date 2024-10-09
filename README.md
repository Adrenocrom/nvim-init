nvim-init
=========

This is my nvim configuration, which I mainly use for Java development.
Code completion and debugging is working well.
To add a remote debugger a launch.json config is sufficient,
this requires a MainClass and a ProjectName, this is not resolved automatically.

install
-------

    git clone https://github.com/Adrenocrom/nvim-init.git ~/.config/nvim/

### required

* __ripgrep__ is needed for live_grep of telescope

* __ctags__ is needed for ctags open with F8 key

java
----

The debugger can be opened with F7 key

### required

* __sdkman__ (https://sdkman.io/) used for java/maven/gradle version selection

* __jdtls__ install via mason

        :Mason

* __ollama__ needed for offline ai assist

* __curl__ needed for offline ai assits requests

### maven.config

This config is only needed if you need to setup special maven configs.
Like a diferent settings.xml

    // cd <workspace>
    // mkdir .mvn  && cd.mvn && touch maven.config
    // inside maven config put settings you would append to mvn
    // like: -s ~/.m2/settings.xml

### launch.json

This config file is only needed for remote debugging, attach to processes
should be working fine too.
If you want to just start your application,
additianal params could set inside nvim with

    :JavaProfile

Otherwise for remotedebugging

    // cd <project>
    // mkdir .vscode && cd .vscode && touch launch.json
    {
        "configurations": [{
            "type": "java",
            "name": "Attach",
            "request": "attach",
            "hostName": "<hostname>",
            "port": "<port>",
            "mainClass": "<mainclass>",
            "projectName": "<artefactId>"
        }]
    }
