# onboarding-setup

## Mozilla firefox

Plugins:

-   Lastpass (passwords manager)
-   Multi-Account containers (open multiple orgs in the same browser)
-   Salesforce inspector

## Visual Studio Code

-   Install VSCode (No need to install Salesforce Extension Pack plugin)
-   Install Docker (note: add user to group for permissions): https://developer.salesforce.com/tools/vscode/en/user-guide/remote-development
-   Install VSCode extension Remote-Containers and inner dependencies

    -   VSCode extensions will be there in the Salesforce Image provided by us
    -   In case you are using Salesforce default docker image, our one is exactly that one but including:

        -   Salesforce Extension Pack, plus: 
            -   Apex Log Analyzer 
            -   ESLint 
            -   Apex PMD  
            -   Prettier 
            -   XML

            OR

        -   Salesforce Extension Pack (Expanded), plus:
            -   SOQL

        -   Git Graph
        -   GitHub Copilot
        -   GitLens-Git supercharged
        -   Salesforce Package.xml Generator
        -   Tabnine
        -   Trailing Spaces
        -   XML Tools

    Either docker image, already contains salesforce cli, java (with /usr/lib/jvm/java-11-openjdk-amd64 specified in remote settings), node and git.

    We also recommend these extensions, which can only be installed locally, but not in Dev Container: 
    -   Auto Close Tag 
    -   Auto Rename Tag 
    -   Bracket Pair Colorizer 2 
    -   Codey Midnight (or your favourite VSCode theme)
    -   Peacock (to easily identify different projects open in separate VSCode windows) 
    -   VSCode icons

## Git

-   Install git if not installed already
-   Clone remote GitHub repository to local:

    -   Authenticate with SSH key:

        -   Open terminal in your local machine:

            -   $ ssk-keygen > press “enter” 3 times to accept all the defaults
            -   $ code /home/{your user}/.ssh/id_rsa.pub > copy ALL file content

        -   In your GitHub profile, go to:
            -   Settings > SSH and GPG Keys > new SSH key
            -   Leave _Title_ empty, paste ALL content in _Key_ section
            -   Add SSH key

    -   Go to the repository > code > SSH > copy git@github.com:Nakama-Partnering-Services/project-scaffolding.git

    -   Go to the terminal again in your local machine:
        -   $ git clone git@github.com:Nakama-Partnering-Services/project-scaffolding.git

            If you find an issue `Host key verification failed. fatal: Could not read from remote repository` in the previous step, follow these steps: 
        
        - $ ssh -T git@github.com (yes) 
        - $ git clone git@github.com:Nakama-Partnering-Services/project-scaffolding.git

-   Setup your user local config:
    -   $ git config --global init.defaultBranch main
    -   $ git config --global user.email "Your email address”
    -   $ git config --global user.name "Your name”
    -   $ git config --global core.editor code
    -   $ git config --global core.autocrlf input (ONLY if you are in a Unix OS, to format files on committing with LF, as Linux and OSX does, instead of doing it with CRLF, as Windows does)
    -   $ git config --global core.autocrlf true (ONLY if you are in a Unix OS, to format files on committing with LF, as Linux and OSX does, instead of doing it with CRLF, as Windows does)
    -   $ git config --global pull.rebase true (to rebase your local branch when pulling changes from remote)
    -   $ git config --global core.longpaths true (ONLY needed if you are in Windows)

-   Note: when a pull request is approved, use squash and merge to combine all your pull request’s commits into one and retain a clean history.

-   Note: if you are using Windows, when working with a repository in a container, you will probably need to create again a ssh key there and add it in github in order to access the remote repository from within the container, for example, when using `git pull` or `git push`.

## NPM

-   $ npm set unsafe-perm true (this is needed in docker to install husky without issues)
-   $ npm ci

Happy coding!
