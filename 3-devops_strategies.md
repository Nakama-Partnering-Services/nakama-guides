# DevOps strategies.

# Content

-   [Instructions](#instructions)
    -   [DevOps Settings](#devops-settings)
    -   [Development Workflow](#development-workflow)
        -   [Repository](#repository)
            -   [Branch Naming Conventions](#branch-naming-conventions)
            -   [Commit Message Conventions](#commit-message-conventions)
            -   [Workflow](#workflow)
            -   [Tagging](#tagging)
    -   [Technical instructions for rebases and Production deployments](#technical-instructions-for-rebases-and-production-deployments)
        -   [Production deployment](#production-deployment)
        -   [Main update with rebase](#main-update-with-rebase)

# Instructions

In here you can find instructions and notes for DevOps configuration and settings.
You can also find here naming conventions and suggested workflows around release development and repository management.

## DevOps Settings

We are currently using build pipelines with trigger set to `main`, `rc/*` and `patch/*` branches.

-   Pull request against `main` branch validate against CI and commits deploy to QA and lower environments.
-   Pull request against `rc/*` branches validate against UAT and commits deploy to UAT. Then, they should be rebased onto the main branch. (\*1)
-   Pull request against `patch/*` branches validate against PRODUCTION and commits are not deployed. They should be deployed manually and rebased into the main branch, as well as in the open `rc/*` branches.
-   Deployment to PRODUCTION environment are done manually from the plaform. (\*2)
-   All deployments calculate deltas automatically and do not require manual maintenance of package.xml files. (\*3)

(\*1) Rebase onto the main branch requires special repository permission to `$ git push --force` of the `main` branch and bypass branch policies. These permissions should be granted in a very mindful way since this part is critical and can break the entire process if not done properly, since rebase operation rewrites entire branch commit history. Due to these, only few designated people is able to do this.

(\*2) Manual deployment option requires special permissions since it implies the ability of deploy to PRODUCTION and hence only few designated people is able to do this.

(\*3) Sometimes, the deployment job may fail, although the deployment to the target Salesforce environment have succeed. This is usually due to a timeout in the job with an error similar to Metadata API request failed. In this case, someone should go to the corresponding environment delta variable in the environment DeploymentInformation.Last custom metadata type, and manually update it to the last commit of the branch that was last deployed there.

## Development Workflow

Make sure you configure your local git repository with your remote repository username and email:

```
git config user.name <username>
git config user.email <email>
```

For every new development follow [repository workflow and conventions](#repository).

Note: the source branch for your feature/bugfix/hotfix branch should always be the same as the target branch of your PR. In order to know the target branch for your PR changes, follow this criteria:

-   For normal development (for the new minor release), create your PR against `main` branch.
-   For changes that should go to PRODUCTION before anything else, that can exist together with changes already in UAT and will be tested there before PRODUCTION deployment, create your PR against the latest `rc/*` branch. If latest `rc/*` has not been created yet, or you need your changes to be deployed on a different date, request a new `rc/*`branch to the responsible repository mantainer.
-   For hotfixes against PRODUCTION that can not exist together with UAT latest changes, request the responsible repository mantainer to create a new `patch/*` branch out of the latest tag, so you can create your PR against it.

### Repository

#### Branch Naming Conventions

For release developments use following naming convention for branches: `feature/NameOfIssue` or `bugfix/NameOfIssue`.

For hotfixes use following naming convention for branches: `hotfix/NameOfIssue`

Good branch names are like the following:

-   feature/PROJECTNAME-1234 - containing all branches regarding new features for CRM
-   bugfix/PROJECTNAME-1234 - containing all branches regarding bugfixes, either for minor release or current release candidate (rc/*)
-   hotfix/PROJECTNAME-1234 - containing all branches regarding hotfixes
-   rc/1.2.3 - containing all branches regarding release candidates (\*4)

(\*4) `rc/*` branches can also be used as long-lived branches for other project streams, that are regularly rebased and aligned with the latest changes of the released to PRODUCTION, in order to merge and contain the code corresponding to the features and bugs of the long-living release, that need to be developed in parallel to other activities with a different release date. For activities such as End to End, Smoke and QA testing with integrated systems, when we do not want to compromise UAT environment and main branch with these changes, it can be manually deployed to QA, or the relevant environment accordingly.

#### Commit Message Conventions

[Conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) + [smart commits](https://support.atlassian.com/jira-software-cloud/docs/process-issues-with-smart-commits/).

Conventional commits are enforced for local commits with a git commit-msg hook.
Smart commits are optional and should be developer responsibility.

On PR title upon completion, the same convention should be applied to take advantage of automatic `CHANGELOG.md` generation and Jira Integration. It is developer responsibility to ensure that the PR title upon completion is following convention commits (+ smart commits conventions).

Examples:

`feat: add account dashboard PROJECT-1234 #close #comment Fixed this today #time 2d 5h`

`fix: solve styling issue PROJECT-5678 #close #comment Changed color #time 1d 2h 5m`

> Smart commit commands that you execute will appear duplicated under certain circumstances. Altering commit history creates "new" commits, which replace the "old" ones. If those "new" commits contain the same smart commit commands as before the history rewrite, then the same smart commits will be executed again and hence appear to have been duplicated. The commit history altering git commands include git push --force and git merge --squash.

#### Workflow

-   Whenever you are starting to work on new item, pull from remote branch `main` or latest `rc/*` or `patch/*` branch.
-   Create branch accordingly to naming convention.
-   After your work is done, stage and commit your changes.
-   Then pull from the remote branch you have started to work from (`main` or latest `rc/*` or `patch/*`). Default strategy is rebase.
-   If there are any conflicts, resolve them and then run `git rebase --continue` (repeat as many times as needed for each commit having conflicts) and `git push -f` to your remote branch.
-   If your changes contain any new metadata or modification that may break apex tests, such as validation rules, ensure all local tests pass successfully in your development environment.
-   Create pull request, ensure that PR title follows our [Commit Message Conventions](#commit-message-conventions), validations and quality checks have succeeded, and ask for a [review](./8-code_review_checklist.md).
-   If you PR contains changes in Apex classes that are not Test classes, and you are not adding/modifying the correspondent @IsTest classes for those as part of your PR, make sure that the PR description specifies the desired test level for the validation deployment like for example `Tests: RunLocalTests`. You can also specifically list the @IsTest classes that should be executed to comply with the required coverage checks. Syntax for that should be like: `Tests: RunSpecifiedTests TestClass1,TestClass2`.
-   After your PR validates successfully and its completed, subsequent deployment execution will happen as it is explained in the [DevOps Settings section](#devops-settings).

#### Tagging

After deploying to PRODUCTION, tag the patch/release branch and rebase the branch onto `main`. Kindly refer to the [Technical instructions for rebases and Production deployments](#technical-instructions-for-rebases-and-production-deployments).

## Technical instructions for rebases and Production deployments

### Production deployment

1. Go to PRODUCTION and HOTFIX and check that the DeploymentInformation.Last custom metadata type Commit was properly updated., If it has not, but the deployment has succeed, make sure that you properly update this value manually (this can happen due to job timeouts).
2. In VSCode, making sure that you are in the branch that was just deployed to PRODUCTION, make sure you run `git pull` to be up-to-date.
3. Run `npm run release:minor` or `npm run release:patch` depending on if the deployment was just a minor release (+0.1.0) or a patch one (+0.0.1), based on [Semantic Versioning](https://semver.org/). This will update current release references in the repository and update the [CHANGELOG.md](./CHANGELOG.md) with the latest content of the [conventional commits](#commit-message-conventions).
4. Run `git add CHANGELOG.md` to make sure changes were staged.
5. Run `git push --follow-tags` to push to remote the branch we deployed with the last commit that was just created as well as the new tag.

### Main update with rebase

MANDATORY AFTER PRODUCTION DEPLOYMENT.

This approach is also the one that needs to be followed every time a `rc/*`or `patch/*` branch gets new changes that we want to get deployed into MOLUAT and lower environments.

1. In VSCode, making sure that you are in the `main` branch, make sure you run `git pull` to be up-to-date.
2. (Recommeneded, but optional) Create a `backup/main` branch with `git checkout -b backup/main` to save current history and commit ids references in the `main` branch at this point. If `backup/main` branch already exists and can not be deleted since there are still some delta variables pointing to a commit id in there, create a new branch like `backup/main-CurrentDate`. `git checkout -b backup/main`.
3. In VSCode go to the branch you want to rebase into main and make sure that it's up to date, so pull the latest changes (if there is any). Also, make sure it is in sync with the latest release deployed to PRODUCTION, and, if not, rebase last deployed release into this new rc/* branch.
4. Move back to the main branch.
5. Rebase latest `rc/*`or `patch/*` deployed branch into main: `git rebase rc/X.X.X`. In case of conflicts, solve them (ask for help to corresponding developers if needed if you do not know how to solve them), stage the files and run `git rebase --continue`.
6. Check with `Git Graph` that new branch history for the `main` branch looks correct, linear, and clear, on top of latest `rc/*`or `patch/*` deployed branch. If so push the new rewritten `main` branch to remote: `git push --force`.
7. The previous step triggers a deployment against QA and lower environments, so you should review that these deployment have succeed in the corresponding pipeline job, and also check that the DeploymentInformation.Last custom metadata type Commit  for each environment have been updated. If not, proceed accordingly. For this step, refer to [DevOps Settings](#devops-settings) and step 2 in [Production deployment](#production-deployment) sections.
8. If deployment to QA and all lower environments has finishes successfully, delete from remote the `backup/main` branch that you just created in the step 2.
