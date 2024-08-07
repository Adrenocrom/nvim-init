nvim-init
=========

This is my nvim configuration, which I mainly use for Java development.
Code completion and debugging is working well.
To add a remote debugger a launch.json config is sufficient,
this requires a MainClass and a ProjectName, this is not resolved automatically.

install
-------

    git clone https://github.com/Adrenocrom/nvim-init.git ~/.config/nvim/

maven.config
------------

    // cd <workspace>
    // mkdir .mvn  && cd.mvn && touch maven.config
    // inside maven config put settings you would append to mvn
    // like: -s ~/.m2/settings.xml

launch.json
-----------

This config file is only needed for remote debugging, attach to processes
should be working fine too.
If you want to just start your application,
additianal params could set inside nvim.
with:

    :JavaProfile

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
