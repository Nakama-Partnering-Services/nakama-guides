# GUIDELINES

Generally, most of our coding guidelines are based on Clean Code, by Bob Martin. Use [this link](https://moderatemisbehaviour.github.io/clean-code-smells-and-heuristics/) for reference. It is not expected you to know all the rules, just to get familiar with the concept. We improve everyday the code we write, so do not worry if you receive many comments in your first pull requests, you will receive less each time, and you will be able to help others doing reviews yourself once you get familiar with the guidelines.

Particularities:

-   Formatting rules are enforced by prettier.

-   In the same way that we try to use `const` whenever possible in Javascript, ideally we will write `final` in Apex (Welcome to the team final!). This way, although it clutters the code a bit and decreases readability, it helps the reader to understand that the variable value or reference is not going to be changed later, improving the understanding of the code.

-   If you really need to write a comment, write it with good spelling, without typos and always start them like: `// Note: `.

-   Again, as Clean Code explains, avoid [Hungarian notation](https://en.wikipedia.org/wiki/Hungarian_notation) and use names like `Map<Id, Account> accountsById` instead of `Map<Id, Account> accountsMap` or `Map<Id, Account> mapAccountsById`, since they are more descriptive and today's environments helps you not to have to mangle the names.

-   Only use `_` in names when they are constants (top level class final static variables). If so, write them with all uppercase letters.

-   Naming conventions for differents Apex classes are explained in the correspondant README.md files in the [sfdx-nakama-project-scaffolding](https://github.com/Nakama-Partnering-Services/sfdx-nakama-project-scaffolding) repository.

## Apex specific

-   Again, as Clean Code explains, the first rule for writting classes is that they should be small, and the second, they should be smaller than that. Do not hesitate creating _command classes_, and call them with a _execute_ or _apply_ method, for example: `UserLicencesesValidations.apply`. This way, instead of writing an additional method in a bigger class, the logic is decoupled and you will face less issues when merging your code in upper branches due to someone else's changes in the same class.

-   Always respect Apex best practices when applicable, such as checking user permissions, sharing accessibility, and so on.

-   Do not clutter your code with methods such as `Database.insert` when just `insert` is enough.

-   Name your test methods like `successOnInsertAccounts` and `failsOnInsertAccountsWithoutPermissions`, rather than `GivenTheUserHasEnoughPermissionsWhenInsertingAccountsThenAccountsAreInserterSuccessfully` or `test_insertAccounts`.

## LWC specific

-   Always try to avoid innecessary levels of indentation, for example, by leveraging early return statements for validations or using `if:true={}` directive directly in your tag rather than in `<template>`.

-   When variables are only going to be used in the `.js` controller file, start them with underscore `_`, for example: `_accountId`.

-   You will not need `@track` annotation almost ever.

-   Try to move your functional methods to a `utils.js` file and you imports for SObjects, fields, and labels to a `schema.js` file in you lightning web components.

-   When communicating with other components, leverage public (`@api`) methods/properties from parents, `dispatchEvent` from children, and lightning message channels from siblings, when they do not have a common ancestor. Use `pubsub` only when lightning message channels do not cover your use case. Use [this link](https://developer.salesforce.com/blogs/2021/05/inter-component-communication-patterns-for-lightning-web-components) for reference.

-   Preference order for styling:

    1. Component attributes, such as `padding` in `lightning-layout-item`.
    2. Standard slds classes.
    3. Custom classes created in the `.css` file, ideally using [design tokens](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.create_components_css_design_tokens).
    4. Inline css with the `<style>` attribute. If you need standard components to infer styling, leverage [styling hooks](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.create_components_css_custom_properties) before using an static resource or dynamically inserting an `style` tag scoping Salesforce inner CSS classes. Use [this link](https://salesforce.stackexchange.com/questions/246887/target-inner-elements-of-standard-lightning-web-components-with-css) for reference.

-   When sharing [CSS](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.create_components_css_share) or [Javascript](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.js_share_code) code, service components are prefered over static resource.

-   When naming CSS classes, use hyphen delimited strings, for example: `.red-box`.
