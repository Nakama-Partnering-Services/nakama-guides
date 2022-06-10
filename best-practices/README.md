# best-practices

Generally, most of our coding guidelines are based on Clean Code, by Bob Martin. Use [this link](https://moderatemisbehaviour.github.io/clean-code-smells-and-heuristics/) for reference. You can also refer [here](https://github.com/ryanmcdermott/clean-code-javascript) particularly for Javascript. It is not expected you to know all the rules, just to get familiar with the concept. We improve everyday the code we write, so do not worry if you receive many comments in your first pull requests, you will receive less each time, and you will be able to help others doing reviews yourself once you get familiar with the guidelines.

## Particularities:

- Formatting rules are enforced by [prettier](./PRETTIER.md).
- Readability is more important than Consistency but Consistency is less subjective and easier to enforce. If you propose an improvement to readability think about objective proof and easy ways to enforce it.
- In the same way that we try to use `const` whenever possible in Javascript, ideally we will write `final` in Apex (Welcome to the team final!). This way, although it clutters the code a bit and decreases readability, it helps the reader to understand that the variable value or reference is not going to be changed later, improving the understanding of the code.
- If you really need to write a comment, write it with good spelling, without typos and always start them like: `// Note: `.
- Remember to always add proper descriptions for things such as Labels, Custom Objects, Custom Fields, and Flows (including their elements and variables). 

## Naming is important. And hard.

- Naming is hard. And even more important. So spend time and effort into finding better names.
- Saying "I am bad with naming" is not an excuse. Then try harder to get better with it.
- Good Names reveal intentions and hide implementation details (Name should be stable, implementations change).
- The more important a name is the simpler it must be. CamelCaseHumps are a sign of overcomplicated naming
- Prefixing non-void methods with get... was needed in Java but is bad style in Apex. Having all methods start with g wont help readability. int age() and void age(int value) is much clearer.
- For Custom Labels, Custom Objects and Custom Fields, API Names should always follow PascalCase convention. This indicates that you really took care when providing the API name rather than leaving the default Salesforce name with underscores replacing whitespaces. In the same way, variables in apex should follow camelCase conventions except for contants, which should follow SNAKE_CASE convention. Similarly, when creating Flows, every element should also follow PascalCase naming convention except for variables, which should follow camelCase instead, just like in real code.
- Avoid [Hungarian notation](https://en.wikipedia.org/wiki/Hungarian_notation) where variable type is encoded in the variable name.
- Follow [Microsoft Guidelines for abbreviations and acronyms](https://docs.microsoft.com/en-us/previous-versions/dotnet/netframework-1.1/141e06ef(v=vs.71)?redirectedfrom=MSDN). Avoid abbreviations, use only well known acronyms and always use PascalCase or camelCase for them.
- Naming conventions for differents Apex classes are explained in the correspondant README.md files in the [project-scaffolding](https://github.com/Nakama-Partnering-Services/nakama-project-scaffolding) repository.

- Examples:
  - `RegistrationQueue` is better than `PlatformEventHandler`
  - `age` is better than `intAge`
  - `students` is better than `studentList`
  - `Registration` is better than `IRegistrationDAOWrapper`
  - age() is better than getAge()
  - `explode()` is better than `triggerExplosionInitiation()`
  - `Result` is better than `ResultWrapper`
  - `encodedUrl` is better than `encodedURL`
- Encourage reviewers to propose better names

### Naming Examples
- **Test:** Suffix with `Test` to make selecting tests easy and put tests next to their parent class.
- **Trigger:** Just the Object name as Plural. Don't add the word "Trigger" as it is in the filename `.trigger` or the UI anyway.
- **Invocable:** Name it verb/command style and call the method `execute`: e.g. `RunApexTests.execute()`
- **VF/LWC Controller:** Indicate its a Controller and who uses it `newContact.action` --> `NewContactActionCtrl` 
- **Custom Objects:** `CreditCard__c`
- **Custom Fields:** `CreditCardNumber__c`

## Apex specific

- Test Classes are private, regular class public and you need a very good reason foir making it global. Put a // Note: on top to explain why.
- Aside form test classes, all classes should have a sharing declaration. Most of classes should usually have `with sharing` declaration except for classes such as Selectors or other classes that are always delegated, who should have `inherithed sharing` to operate under calling class sharing specification. If omitted or `without sharing`, you should write a // Note: on top to explain why.
- As Apex IDEs don't do that for you (other than Java IDEs) structure your classes using // Constructor // Public // Private // Inner section comments.
- Test classes just have an optional // Helper section comment for private methods used by multiple tests methods.
- A class should read like a good newpaper article, where the most important stuff comes at the beginning. Move implementation details to the end. And show the broad algorithm and actors on top. It's definitly not like a book where you need to read to the end to understand it.
- A method should do ONE thing and reveal that in its name. Complicated names with many CamelCaseHumps show that a method either does too much or you are describing the implementation instead.
- Methods that return something should alway in Line 1 declare it as `result` and return result in the last line. Always call it `result` it will dramatically increase readability. What it is, is decribed in the method name. 
- When you call your classes `Helper` or `Manager` you are doing something wrong. Read [here](https://www.yegor256.com/2015/03/09/objects-end-with-er.html) why.
- Again, as Clean Code explains, the first rule for writting classes is that they should be small, and the second, they should be smaller than that. Do not hesitate creating _command classes_, and call them with a _execute_ or _apply_ method, for example: `UserLicencesesValidations.apply`. This way, instead of writing an additional method in a bigger class, the logic is decoupled and you will face less issues when merging your code in upper branches due to someone else's changes in the same class.
- Always respect Apex best practices when applicable, such as checking user permissions, sharing accessibility, and so on.
- Do not clutter your code with methods such as `Database.insert` when just `insert` is enough.
- Name your test methods like `successOnInsertAccounts` and `failsOnInsertAccountsWithoutPermissions`, rather than `GivenTheUserHasEnoughPermissionsWhenInsertingAccountsThenAccountsAreInserterSuccessfully` or `test_insertAccounts`.
- No matter which trigger-framework (I recommend [this](https://github.com/mitchspano/apex-trigger-actions-framework)) you use if there is a central Handler class just call it like the trigger `Students.cls`.
- A Trigger never contain more than a single line of Code. It's the line delegating the work to a class. Triggers use the plural-form of the object they represent and never repeat the word `Trigger`.  So the file is `Students.trigger` and not `StudentTrigger.trigger` or such.
```````java
trigger OpportunityTrigger on Opportunity (
  before insert,
  after insert,
  before update,
  after update,
  before delete,
  after delete,
  after undelete
) {
  new MetadataTriggerHandler().run();
}
```````

## Apex Tests
- Keep tests short AND isolated. 
- Use the apex-domainbuilder library instead rather than Factories.
- Don't put the word "test" in the test method name
- No _ underscores to structure tests. Use separate test classes instead.
- Use Upper case @IsTest (rather than @istest) and not the outdated TestMethod modifier.
- Test class name plus method name should sound a bit like a sentence: Calculator multiplies two integers.
- Don't add words like works, correct, prove that. Everybody knows that this is what tests do.
- Don't use global variables for tests if you don't need them. It makes tests harder to understand and less independent.
- Don't assert too much in a test. Better make two test methods.
- Every test needs 3 comments to mark its // Setup, // Exercise and // Verify section.
- Move stuff that is needed but somewhat irrelevant to tests to the bottom HELPER section.
- A test class is a better documentation. Start with the general stuff and get more specific at the bottom. Don't add new test at the top but at the bottom.

## LWC specific

- Always try to avoid innecessary levels of indentation, for example, by leveraging early return statements for validations or using `if:true={}` directive directly in your tag rather than in `<template>`.
- When variables are only going to be used in the `.js` controller file, start them with underscore `_`, for example: `_accountId`.
- You will not need `@track` annotation almost ever.
- Try to move your functional methods to a `utils.js` file and you imports for SObjects, fields, and labels to a `schema.js` file in you lightning web components.
- When communicating with other components, leverage public (`@api`) methods/properties from parents, `dispatchEvent` from children, and lightning message channels from siblings, when they do not have a common ancestor. Use `pubsub` only when lightning message channels do not cover your use case. Use [this link](https://developer.salesforce.com/blogs/2021/05/inter-component-communication-patterns-for-lightning-web-components) for reference.

- Preference order for styling:

    1. Component attributes, such as `padding` in `lightning-layout-item`.
    2. Standard slds classes.
    3. Custom classes created in the `.css` file, ideally using [design tokens](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.create_components_css_design_tokens).
    4. Inline css with the `<style>` attribute. If you need standard components to infer styling, leverage [styling hooks](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.create_components_css_custom_properties) before using an static resource or dynamically inserting an `style` tag scoping Salesforce inner CSS classes. Use [this link](https://salesforce.stackexchange.com/questions/246887/target-inner-elements-of-standard-lightning-web-components-with-css) for reference.

- When sharing [CSS](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.create_components_css_share) or [Javascript](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.js_share_code) code, service components are prefered over static resource.

- When naming CSS classes, use hyphen delimited strings, for example: `.red-box`.

## Salesforce Best Practices
Know and apply all the [recommendations Salesforce has published](https://developer.salesforce.com/blogs/2022/01/drive-consistency-and-grow-developer-skills-with-a-developer-best-practices-checklist) for building secure apps that respect the limitations of the Platform.
