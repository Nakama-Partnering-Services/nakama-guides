# DevOps strategies.

- [DevOps settings](#devops-settings)
- [Development process](#development-process)
  - [Brach naming conventions](#branch-naming-conventions)
  - [Commit message conventions](#commit-message-conventions)
  - [Workflow](#workflow)
  - [Tagging](#tagging)

## DevOps settings

We use pipelines with trigger set to `main`, `rc/*` and `patch/*` branches.

- Pull request against `main` branch validate against DEVINT and commits deploy to TEST and lower environments.
- Pull request against `rc/*` branches validate against STAGING and commits deploy to STAGING. Then, they should be rebased onto the main branch.
- Pull request against `patch/*` branches validate against PRODUCTION and commits are not deployed. They are deployed manually and rebased into the main branch, as well as in the open `rc/*` branches.

All deployments calculate deltas automatically and do not require manual maintenance of package.xml files.

## Development process

Make sure you configure your local git repository with your remote repository username and email:

```
git config user.name <username>
git config user.email <email>
```

Note: the source branch for your feature/bugfix/hotfix branch should always be the same as the target branch of your PR. In order to know the target branch for your PR changes, follow this criteria:

- For normal development (for the new minor release), create your PR against `main` branch.
- For changes that should go to PRODUCTION before anything else, that can exist together with changes already in STAGING and will be tested there before PRODUCTION deployment, create your PR against the latest `rc/*` branch. If latest `rc/*` has not been created yet, request it to the responsible repository maintainer.
- For hotfixes against PRODUCTION that can not exist together with STAGING latest changes, request the responsible repository maintainer to create a new `patch/*` branch out of the latest tag, so you can create your PR against it.

### Branch naming conventions

For release developments use following naming convention for branches: `feature/NameOfIssue` or `bugfix/NameOfIssue`.

For hotfixes use following naming convention for branches: `hotfix/NameOfIssue`

Good branch names are like the following:

- `feature/PROJECTNAME-1234` - containing all branches regarding new features for CRM.
- `bugfix/PROJECTNAME-1234` - containing all branches regarding bugfixes, either for minor release or current release candidate (rc/\*).
- `hotfix/PROJECTNAME-1234` - containing all branches regarding hotfixes.

### Commit message conventions

[Conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) + [smart commits](https://support.atlassian.com/jira-software-cloud/docs/process-issues-with-smart-commits/).

Conventional commits are enforced for local commits with a git commit-msg hook. Smart commits should be developer responsibility.

On PR title upon completion, the same convention should be applied to take advantage of automatic `CHANGELOG.md` generation and Jira Integration. It is developer responsibility to ensure that the PR title upon completion if following convention commits + smart commits conventions.

Examples:

`feat: add account dashboard PROJECT-1234 #close #comment Fixed this today #time 2d 5h`

`fix: solve styling issue PROJECT-5678 #close #comment Changed color #time 1d 2h 5m`

> Smart commit commands that you execute will appear duplicated under certain circumstances. Altering commit history creates "new" commits, which replace the "old" ones. If those "new" commits contain the same smart commit commands as before the history rewrite, then the same smart commits will be executed again and hence appear to have been duplicated. The commit history altering git commands include git push --force and git merge --squash.

### Workflow

- Whenever you are starting to work on new item, pull from remote branch `main` or latest `rc/*` or `patch/*` branch.
- Create branch accordingly to naming convention.
- After your work is done, stage and commit your changes.
- Then pull from the remote branch you have started to work from (`main` or latest `rc/*` or `patch/*`). Default strategy is rebase.
- If there are any conflicts, resolve them and then run `git rebase --continue` (repeat as many times as needed for each commit having conflicts) and `git push -f` to your remote branch.
- If your changes contain any new metadata or modification that may break apex tests, such as validation rules, ensure all local tests pass successfully in your development environment.
- Create pull request, ensure that PR title follows our [Commit message conventions](#commit-message-conventions) and ask for review.
- If you PR contains changes in Apex classes that are not Test classes, and you are not adding/modifying the correspondent `@IsTest` classes for those as part of your PR, make sure that the PR description specifies the desired test level for the validation deployment like for example `Tests: RunLocalTests`. You can also specifically list the `@IsTest` classes that should be executed to comply with the required coverage checks. Syntax for that should be like: `Tests: RunSpecifiedTests TestClass1,TestClass2`.

#### Tagging

After deploying to PRODUCTION, tag the patch/release branch and rebase the branch onto `main`. Kindly refer to the [Technical instructions for rebases and Production deployments](#technical-instructions-for-rebases-and-production-deployments).

## Technical instructions for rebases and Production deployments

### Production deployment

1. After deployment succeeds, in VSCode, making sure that you are in the branch that was just deployed to Production, make sure you run `git pull` to be up-to-date.
2. Run `npm run release:minor` or `npm run release:patch` depending on if the deployment was just a minor release (+0.1.0) or a patch one (+0.0.1), based on [Semantic Versioning](https://semver.org/). This will update current release references in the repository and update the [CHANGELOG.md](./CHANGELOG.md) with the latest content of the [conventional commits](#commit-message-conventions).
3. Run `git push --follow-tags` to push to remote the branch we deployed with the last commit that was just created as well as the new tag.

### Main update with rebase

MANDATORY AFTER PRODUCTION DEPLOYMENT.

This approach is also the one that needs to be followed every time a `rc/*`or `patch/*` branch gets new changes that we want to get deployed into MOLUAT and lower environments.

1. In VSCode, making sure that you are in the `main` branch, make sure you run `git pull` to be up-to-date.
2. Create a `backup/main` branch with `git checkout -b backup/main` to save current history and commit ids references in the `main` branch at this point. If `backup/main` branch already exists and can not be deleted since there are still some delta variables pointing to a commit id in there, create a new branch like `backup/main-CurrentDate`. `git checkout -b backup/main`.
3. Push the new `backup/main` branch to remote: `git push --set-upstream origin backup/main --no-verify`.
4. Rebase latest `rc/*`or `patch/*` deployed branch into main: `git rebase rc/X.X.X`.
   6.1. In case of conflicts, solve them (ask for help to corresponding developers if needed if you do not know how to solve them), stage the files and run `git rebase --continue`.
5. Check with `Git Graph` that new branch history for the `main` branch looks correct, linear, and clear, on top of latest `rc/*`or `patch/*` deployed branch. If so push the new rewritten `main` branch to remote: `git push --force`.
6. If deployment to TEST and all lower environments has finishes successfully, delete from remote the `backup/main` branch that you just created in the step 2.

