# Specific best practices.

- [Apex-specific](#apex-specific)
  - [Apex class example](#apex-class-example)
  - [Apex trigger example](#apex-trigger-example)
- [Apex tests](#apex-tests)
- [LWC specific](#lwc-specific)
  - [LWC example](#lwc-example)

## Apex specific

- Test classes omit private and sharing declaration, regular class public and you need a very good reason for making it global. Put a // Note: on top to explain why.
- Aside from test classes, all classes should have a sharing declaration. Most of classes should usually have `with sharing` declaration except for classes such as selectors or other classes that are always delegated, who should have `inherited sharing` to operate under calling class sharing specification. If omitted or `without sharing`, you should write a // Note: on top to explain why.
- As Apex IDEs don't do that for you (other than Java IDEs) structure your classes using `// Constructor` `// Public` `// Private` `// Inner` section comments.
- Test classes just have an optional `// Helper` section comment for private methods used by multiple tests methods.
- A class should read like a good newspaper article, where the most important stuff comes at the beginning. Move implementation details to the end. And show the broad algorithm and actors on top. It's definitely not like a book where you need to read to the end to understand it.
- A method should do ONE thing and reveal that in its name. Complicated names with many CamelCaseHumps show that a method either does too much or you are describing the implementation instead.
- Methods that return something should always declare it as `result` and return result in the last line. Always call it `result` it will dramatically increase readability. What it is, is described in the method name.
- When you call your classes `Helper` or `Manager` you are doing something wrong. Read [here](https://www.yegor256.com/2015/03/09/objects-end-with-er.html) why.
- Again, as Clean Code explains, the first rule for writing classes is that they should be small, and the second, they should be smaller than that. Do not hesitate creating _command classes_, and call them with a _execute_ or _apply_ method, for example: `UserLicencesesValidations.apply`. This way, instead of writing an additional method in a bigger class, the logic is decoupled and you will face less issues when merging your code in upper branches due to someone else's changes in the same class.
- Always respect Apex best practices when applicable, such as checking user permissions, sharing accessibility, and so on.
- Do not clutter your code with methods such as `Database.insert` when just `insert` is enough.
- Name your test methods like `successOnInsertAccounts` and `failsOnInsertAccountsWithoutPermissions`, rather than `GivenTheUserHasEnoughPermissionsWhenInsertingAccountsThenAccountsAreInserterSuccessfully` or `test_insertAccounts`.
- No matter which trigger-framework is used, if there is a central handler class just call it like the trigger `Students.cls`.
- A Trigger never contains more than a single line of Code. It's the line delegating the work to a class. Triggers use the plural-form of the object they represent and never repeat the word `Trigger`. So the file is `Students.trigger` and not `StudentTrigger.trigger` or such.
- Follow Test Driven Development.

### Apex class example

```java
public with sharing class Person {
    private static final String DEFAULT_AGE = 33;

    private final String name;
    private Integer age;
    private String hairColor;

    // CONSTRUCTORS

    public Person(final String name) {
        this.name = name;
        age = DEFAULT_AGE;
    }

    public Person(final String name, final Integer age) {
        this.name = name;
        this.age = age;
    }

    // PUBLIC

    public Person age(final Integer age) {
        this.age = age;
        return this;
    }

    public Integer age() {
        return age;
    }

    public Person hairColor(final String hairColor) {
        this.hairColor = hairColor;
        return this;
    }

    public String hairColor() {
        return hairColor;
    }

    public Boolean isBlond() {
        return hairColor == 'blond';
    }

    public Contact save() {
        return createContact();
    }

    // PRIVATE

    // Note: this is a simple example of usage of SObjectSecureUnitOfWork
    private Contact createContact() {
        final Contact result = new Contact(FirstName = name);
        final SObjectSecureUnitOfWork uow = new SObjectSecureUnitOfWork(new List<SObjectType>{ Contact.SObjectType });
        uow.registerNew(result);
        uow.commitWork();
        return result;
    }
}
```

### Apex trigger example

```java
trigger Opportunities on Opportunity (
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
```

## Apex tests

- Tests should be run against assertions, not simply for code coverage. There must be at least one assertion statement in every test method, but there should be enough assertions to cover all the functionality in the tested code, including invalid scenarios.
- `@SeeAllData` should be avoided. Test classes should create their own data and not reference data in the org, unless the class involves records that cannot be created in a test method.
- Keep tests short AND isolated.
- Use the apex-domainbuilder library instead rather than Factories.
- Don't put the word "test" in the test method name
- No `_` underscores to structure tests. Use separate test classes instead.
- Use Upper case @IsTest (rather than @istest) and not the outdated TestMethod modifier.
- Test class name plus method name should sound a bit like a sentence: Calculator multiplies two integers.
- Don't add words like works, correct, prove that. Everybody knows that this is what tests do.
- Don't use global variables for tests if you don't need them. It makes tests harder to understand and less independent.
- Don't assert too much in a test. Better make two test methods.
- Every test needs 3 comments to mark its // Setup, // Exercise and // Verify section.
- Move stuff that is needed but somewhat irrelevant to tests to the bottom HELPER section.
- A test class is a better documentation. Start with the general stuff and get more specific at the bottom. Don't add new test at the top but at the bottom.

## LWC specific

- Always try to avoid innecessary levels of indentation, for example, by leveraging early return statements for validations or using `lwc:if={}` directive directly in your tag rather than in `<template>`.
- Bind your template directives such as `lwc:if={}` to getters instead of simple variables, so that the values are automatically and dynamically calculated when they change.
- When variables are only going to be used in the `.js` controller file, start them with underscore `_`, for example: `_accountId`.
- You will not need `@track` annotation almost ever.
- Try to move your functional methods to a `utils.js` file and you imports for SObjects, fields, and labels to a `schema.js` file in you lightning web components.
- When communicating with other components, leverage public (`@api`) methods/properties from parents, `dispatchEvent` from children, and lightning message channels from siblings, when they do not have a common ancestor. Use `pubsub` only when lightning message channels do not cover your use case. Use [this link](https://developer.salesforce.com/blogs/2021/05/inter-component-communication-patterns-for-lightning-web-components) for reference.
- Order preference for styling:
  1. Component attributes, such as `padding` in `lightning-layout-item`.
  2. Standard slds classes.
  3. Custom classes created in the `.css` file, ideally using [design tokens](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.create_components_css_design_tokens).
  4. Inline css with the `<style>` attribute. If you need standard components to infer styling, leverage [styling hooks](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.create_components_css_custom_properties) before using an static resource or dynamically inserting an `style` tag scoping Salesforce inner CSS classes. Use [this link](https://salesforce.stackexchange.com/questions/246887/target-inner-elements-of-standard-lightning-web-components-with-css) for reference.
- When sharing [CSS](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.create_components_css_share) or [Javascript](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.js_share_code) code, service components are preferred over static resource.
- When naming CSS classes, use hyphen delimited strings, for example: `.red-box`.

### LWC example

```javascript
import { LightningElement, api } from "lwc";

const DEFAULT_TITLE = "Hello World!";
const BODY_CONTENT =
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";

export default class TitleContainer extends LightningElement {
  @api showTitle;
  @api showBody;

  bodyContent = BODY_CONTENT;

  _isCustomTitle = false;

  _title;
  @api get title() {
    return this._title || DEFAULT_TITLE;
  }

  set title(value) {
    this._isCustomTitle = true;
    this._title = value;
  }

  connectedCallback() {
    this._multiplyBodyContent();
  }

  // PUBLIC

  @api isDefaultTitle() {
    return !this._isCustomTitle;
  }

  // TEMPLATE

  handleTitleClick() {
    this._multiplyBodyContent();
  }

  // PRIVATE

  _multiplyBodyContent() {
    let i = 5;
    while (i--) {
      this.bodyContent += " " + BODY_CONTENT;
    }
  }
}
```
