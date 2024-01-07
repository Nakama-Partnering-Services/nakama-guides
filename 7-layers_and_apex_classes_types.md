# Layers and Apex classes types.

- [Clients](#clients)
- [Domains](#domains)
- [Selectors](#selectors)
- [Services](#services)
- [Trigger actions](#trigger-actions)
- [Tests](#tests)

## Clients

To organize apex classes that are the entry point of executions, other than the ones related to database operations (triggers).

These classes should always be with sharing unless strictly justified and explained in a // Note: comment at the top of the class.

- **Controllers (for LWCs):** The name of these classes should end with Ctrl. E.g.: `OpportunitiesDiscountConfiguratorCtrl.cls`.
- **Global APIs:** The name of these classes should end with Global. E.g.: `OpportunitiesDiscountsGlobal.cls`.
- **Soap APIs:** The name of these classes should end with Soap. E.g.: `OpportunitiesDiscountsSoap.cls`.
- **Rest APIs:** The name of these classes should end with Rest. E.g.: `OpportunitiesDiscountsRest.cls`.
- **Invocables:** The name of these classes should exceptionally be in a verb/command style, and have a single public method execute.This classes are known as command classes. E.g.: `RunApexTests.execute()`.
- **Batch jobs:** The name of these classes should end with Batch. E.g.: `OpportunitiesSynchronizerBatch.cls`.
- **Queueable jobs:** The name of these classes should end with Queue. E.g.: `OpportunitiesCurrencyRateConverterQueue.cls`.
- **Scheduled jobs:** The name of these classes should be the name of the class they are scheduling, ending with Sch. E.g.: `OpportunitiesSynchronizerBatchSch.cls`.

## Domains

To organize apex classes in the domain (SObject) layer.

Considerations:

- The name of these classes should correspond to the plural name of the SObject they act upon. E.g.: `Accounts.cls`.
- These classes should usually be inherited sharing, and services or trigger handlers/actions should specify with sharing or inherited (without) sharing respectively.
- These classes should extend from `fflib_SObjects`.
- These classes will just be used by trigger handlers/actions and service classes, so, by clients, they are always invoked indirectly.
- Operations in these classes include:
    - Complex validations.
    - Field values defaulting.
    - Other logic relating to complex calculation and manipulation.
- For more information about the domain layer, refer to Learn Domain Layer Principles in trailhead.

## Selectors

To organize apex classes in the selector (queries) layer.

Considerations:

- The name of these classes should correspond to the plural name of the SObject they act upon, ending with Selector. E.g.: `AccountsSelector.cls`.
- Selector methods should not start by select to avoid redundancy with Selector in the class name. E.g.: `Map<Id, Account> byId(Set<> accountIds)`.
- These classes should usually be inherited sharing, and services or trigger handlers/actions should specify with sharing or inherited (without) sharing respectively. However, a service class can leverage an inner class without sharing to perform a query with elevated permissions.
- These classes should extend from `SObjectsSecureSelector` which extends `fflib_SObjectSelector` in order to enforce OLS and FLS by default (FLS is not enforced by default).
- Consider using singleton pattern to avoid doing repeated queries in the same transaction. Important across trigger actions.
- The selectors should use the compile time references to field names when possible, even if dynamic queries are being constructed. Doing so ensures that when fields are deleted, the platform prevents the deletion if references exist in the code.
- Consider using Custom Metadata to define the fields that the query should contain, providing dependency injection when using the selector with an extension package.
- Trade-off: apex heap size versus how frequently fields are needed by the various callers of the selector methods.
- Testing of selectors is covered in the domain and service layer, so it is not required to create `AccountsSelectorTest.cls`.
- For more information about the selector layer, refer to Learn Selector Layer Principles in trailhead.

## Services

To organize apex classes in the service layer.

Considerations:

- These classes should always be with sharing, especially when having the global modifier, unless strictly justified and explained in a // Note: comment at the top of the class.
- If Apex logic must access records outside of the user’s visibility, the code must explicitly elevate the execution context as briefly as possible. E.g.: with a private inner without sharing class.
- These classes should throw exceptions, or provide partial database handling. E.g.: with `Database.SaveResult`.
- The methods of these classes should be bulkified.
- These classes will just be used by clients.
- Having compound services is better than having clients calling one service after another. Especially good for optimizing SOQL and DML usage.
- Database operations and service state should be encapsulated within the method call to the service layer.
- These classes are the ones that should call `uow.commitWork()`.
- The services should be stateless to give calling contexts the flexibility to employ their own state management solutions.
- Consider leveraging Custom Metadata and the Callable interface in the service classes so that they can be called dynamically from clients in the core package even if they are in a different extension package.
- For more information about the service layer, refer to Learn Service Layer Principles in trailhead.

## Trigger actions
To organize apex classes for trigger actions.

Considerations:

- The name of these classes should correspond to the object they act upon plus the action they execute. E.g.: `AccountCapitalizeNames.cls`.
- These classes should usually be inherited (without) sharing, since trigger context should act regardless of record level access of the current user. The inherited sharing will apply without sharing since it is executed in trigger context.

## Tests

- The name of Unit Test Apex classes should correspond to the class name they are testing and end with `Test`. E.g.: `CloseOpportunitiesInvTest.cls`.
- Domain builder classes for test should have the name of the SObject they are aimed to create records for and end with `_t`. E.g.: `Lead_t.cls`.
