# General best practices.

- [Introduction](#introduction)
- [Allowed customization approaches](#allowed-customization-approaches)
- [Design principles](#design-principles)
- [In depth](#in-depth)
  - [Prettier configuration](#prettier-configuration)
- [Naming is important and hard](#naming-is-important-and-hard)
- [Code naming examples](#code-naming-examples)
- [Metadata naming examples](#metadata-naming-examples)

## Introduction

Generally, most of our coding guidelines are based on Clean Code, by Bob Martin. You can also refer [here](https://github.com/ryanmcdermott/clean-code-javascript) particularly for Javascript. It is not expected you to know all the rules, just to get familiar with the concept. We improve everyday the code we write, so do not worry if you receive many comments in your first pull requests, you will receive less each time, and you will be able to help others doing reviews yourself once you get familiar with the guidelines.

Know and apply all the [recommendations Salesforce has published](https://developer.salesforce.com/blogs/2022/01/drive-consistency-and-grow-developer-skills-with-a-developer-best-practices-checklist) for building secure apps that respect the limitations of the Platform.

Some of the guidelines shared in this document where included from the repository [salesforce-recipes](https://github.com/rsoesemann/salesforce-recipes) by [rsoesemann](https://github.com/rsoesemann).

## Allowed customization approaches

The following list aims to outline the main criteria to be taken into account when deciding if the design of a solution to be implemented in Salesforce should be brought to a solution review, which should always be the case if any of the following conditions is true:

- Does new metadata for data modeling (custom objects, fields, etc) needs to be created?
- Does new metadata of code (apex classes, lwc, etc) needs to be created?
- Does it involve any new automation (validation rule, record triggered flow, matching rules)?
- Does it involve any external system (send/receive information to/from another system)?
- Does any involve or interfere with any other existing customization solution?
- Is it expected to be a new framework or reusable design or solution?
- Do you believe there may be another approach that could be better or that is not being taken into account?
- Are you unsure of any of the above?

## Design principles

The following list aims to outline some of the principles that must always be considered when designing a solution:

- Use standard platform capabilities, standard fields, and objects as much as possible.
- Coding should be avoided in the first instance.
- Use named credentials for endpoints.
- Follow Clean Coding principles.
- Use custom metadata instead of list custom settings (Deprecated).
- Use custom permissions instead of hierarchy custom settings for mechanisms such as bypass processes.
- Use External Services rather than Apex callouts to call 3rd party systems.
- Use Standard APIs (Where possible) instead of building custom web services.
- Minimum test coverage for all Apex classes is 90%.
- Creation of test flows are required with the minimum of test coverage of 99%.

## In depth

- Remember to always add proper descriptions for things such as Labels, Custom Objects, Custom Fields, and Flows (including their elements and variables).
- Readability is more important than Consistency but Consistency is less subjective and easier to enforce. If you propose an improvement to readability think about objective proof and easy ways to enforce it.
- In the same way that we try to use `const` whenever possible in Javascript, ideally we will write `final` in Apex (welcome to the team final!). This way, although it clutters the code a bit and decreases readability, it helps the reader to understand that the variable value or reference is not going to be changed later, improving the understanding of the code.
- If you really need to write a comment, write it with good spelling, without typos and always start them like: `// Note: `.
- Formatting rules are enforced by [prettier](#prettier-configuration).

### Prettier configuration

```javascript
{
    "trailingComma": "none", // Required for Aura
    "singleQuote": true, // Preferable when writing HTML is needed in a Javascript file
    "bracketSameLine": true, // Solves previous awful formatting of HTML files
    "endOfLine": "lf", // Default, as used by Unix based OS
    "printWidth": 120, // We know, it is not aligned with commonly used guidelines in companies like google, where this value is 80, but we think it makes reading the code easier
    "tabWidth": 4, // We know again, it is not aligned with commonly used guidelines in companies like google, where this value is 2, but we think it makes reading the code easier
    "useTabs": true, // Once again, we know it is not aligned with commonly used guidelines in companies like google, where they use spaces, but we think tabs make our lives easier, as explained here
    "apexInsertFinalNewline": true, // Default. It is also enforced by prettier for non Apex files, since it has no option to change it. Unfortunately, Salesforce removes them when retrieving files, being unaligned with prettier, so for the time being we do not care about what Salesforce does, giving preference to prettier, and we hope that Salesforce changes this in the future in order to be aligned with prettier configurations
    "overrides": [
        {
            "files": "**/lwc/**/*.html",
            "options": { "parser": "lwc" }
        },
        {
            "files": "*.{cmp,page,component}",
            "options": { "parser": "html" }
        }
    ]
}
```

## Naming is important and hard

- Naming is hard. And even more important. So spend time and effort into finding better names.
- Saying "I am bad with naming" is not an excuse. Then try harder to get better with it.
- Good Names reveal intentions and hide implementation details (Name should be stable, implementations change).
- The more important a name is the simpler it must be. CamelCaseHumps are a sign of overcomplicated naming.
- Encourage reviewers to propose better names.
- Prefixing non-void methods with `get...` was needed in Java but is bad style in Apex. Having all methods start with `g` wont help readability. `int age()` and `void age(int value)` is much clearer.
- For Custom Labels, Custom Objects and Custom Fields, API Names should always follow PascalCase convention. This indicates that you really took care when providing the API name rather than leaving the default Salesforce name with underscores replacing whitespaces. In the same way, variables in apex should follow camelCase conventions except for contants, which should follow SNAKE_CASE convention. Similarly, when creating Flows, every element should also follow PascalCase naming convention except for variables, which should follow camelCase instead, just like in real code.
- Avoid [Hungarian notation](https://en.wikipedia.org/wiki/Hungarian_notation) where variable type is encoded in the variable name.
- Follow [Microsoft Guidelines for abbreviations and acronyms](<https://docs.microsoft.com/en-us/previous-versions/dotnet/netframework-1.1/141e06ef(v=vs.71)?redirectedfrom=MSDN>). Avoid abbreviations, use only well known acronyms and always use PascalCase or camelCase for them.
- Naming conventions for differents Apex classes are explained in the correspondant README.md files in the [project-scaffolding](https://github.com/Nakama-Partnering-Services/nakama-project-scaffolding) repository.

## Code naming examples

- `RegistrationQueue` is better than `PlatformEventHandler`
- `Registration` is better than `IRegistrationDAOWrapper`
- `Result` is better than `ResultWrapper`
- `explode()` is better than `triggerExplosionInitiation()`
- `age()` is better than `getAge()`
- `encodedUrl` is better than `encodedURL`
- `students` is better than `studentList`
- `age` is better than `intAge`

## Metadata naming examples

- **Record Triggered Flow:** `SendEmailToRegisteredUser`
- **Validation Rule:** `NameAndPhoneAreEmpty`
- **Custom Objects:** `CreditCard__c`
- **Custom Fields:** `CreditCardNumber__c`
