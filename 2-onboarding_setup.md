# Onboarding setup.

- [Visual Studio Code](#visual-studio-code)
- [Git](#git)
- [NPM](#npm)

## Visual Studio Code

- Follow [these instructions](https://developer.salesforce.com/tools/vscode/en/getting-started/install) to install VSCode, Salesforce CLI, and OpenJDK 17.
- Install sfdx lightning flow scanner plugin for flows validation on pre-commit git hook: `sf plugins install lightning-flow-scanner`.
- Install sfdx scanner plugin for pmd local validation on pre-commit git hook: `sf plugins install @salesforce/sfdx-scanner`.
- Make sure sfdx scanner javaHome property is pointing property to your JAVA directory: under your home directory `C:\Users\<your_username>`, there should be a `.sfdx-scanner\Config.json` file. Towards the end of the file, there should be the "javaHome" property and the value pointing property to your JAVA directory.
- Install node latest LTS version.
- Install these extensions (recomended):
  - Salesforce Extension Pack, plus:
    - Apex Log Analyzer
    - ESLint
    - Apex PMD
    - Prettier
    - XML
  - Git Graph
  - GitLens-Git supercharged
  - Salesforce Package.xml Generator
  - Tabnine
  - Trailing Spaces
  - XML Tools
  - Auto Close Tag
  - Auto Complete Tag
  - Auto Rename Tag
  - Codey Midnight (or your favourite VSCode theme)
  - Peacock (to easily identify different projects open in separate VSCode windows)
  - Material Icon Theme
  - Error Lens

## Git

- Install git if not installed already
- If you have multiple accounts in the same machine, check [this link](https://gist.github.com/rahularity/86da20fe3858e6b311de068201d279e3)
- Authenticate with SSH key:
  - Open terminal in your local machine:
    - $ ssh-keygen > press “enter” 3 times to accept all the defaults
    - $ code /home/{your user}/.ssh/id_rsa.pub > copy ALL file content
  - In your GitHub profile, go to:
    - Settings > SSH and GPG Keys > new SSH key
    - Leave _Title_ empty, paste ALL content in _Key_ section
    - Add SSH key
- Go to the repository > code > SSH > copy git@github.com:Nakama-Partnering-Services/project-scaffolding.git
- Go to the terminal again in your local machine:

  - $ git clone git@github.com:Nakama-Partnering-Services/project-scaffolding.git

    If you find an issue `Host key verification failed. fatal: Could not read from remote repository` in the previous step, follow these steps:

    - $ ssh -T git@github.com (yes)
    - $ git clone git@github.com:Nakama-Partnering-Services/project-scaffolding.git

- Setup your user local config:
  - $ git config init.defaultBranch main
  - $ git config user.email "Your email address”
  - $ git config user.name "Your name”
  - $ git config core.editor code
  - $ git config core.autocrlf true (or core.autocrlf input if using Linux/UNIX)
  - $ git config pull.rebase true (to rebase your local branch when pulling changes from remote)
  - $ git config core.longpaths true
  - $ git config fetch.prune true

Note: when a pull request is approved, use squash and merge to combine all your pull request’s commits into one and retain a clean history.

Note: if you need to perform any changes locally in files such as .vscode/settings.json, use this command to prevent git from tracking it: `git update-index --assume-unchanged .vscode/settings.json`. To revert this configuration, use `git update-index --no-assume-unchanged .vscode/settings.json`.

## NPM

- $ npm install -g yarn
- $ yarn

Note: on Linux/UNIX, if encountering issues where husky scripts are not executable, go to folder `.husky` and run:

- $ chmod +x commit-msg
- $ chmod +x pre-commit
- $ chmod +x pre-push
- $ chmod +x ../scripts/shell/append_ticket_number_to_commit_message.sh

Happy coding!
