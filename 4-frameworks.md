# Frameworks.

Most projects have a set of common needs and demands. Usually, the best option to fill these gaps is using an already existing solution, commonly adopted, supported and maintained, such as an AppExchange managed package. When managed packages do not really cover the needs, or do not even exist, often the customer has also the possibility to build something by itself. Alternatively, there is also an option to use free AppExchange package or open-source frameworks, although these are not officially supported and maintained by Salesforce or any vendor. Despite the lack of official support of maintenance, some of this frameworks are really trustable since they are currently being actively maintained and has reach a very robust status of quality, after being used by several years in hundreds of projects by thousands of developer who actively contribute to improve them day to day. Our recommendation is to use the following frameworks for the following gaps, rather than building something custom for the project ourselves, since these open-source solutions are much better than what we could build and the do not require effort or time to be created, but just to learn how to use them. Besides since they are open-source, we will always have full access to the source code to read and understand it so we can also modify, change, or extend accordingly.

Our main frameworks in the project, all of them implemented under the MIT license, would be delivered as an unlocked packaged and only contain the relevant subset of features that is actually used in this project. The customer could choose build something custom for the project, but they do not have a managed paid alternative.

- NebulaLogger: as our logging framework. No considerable alternatives.
- apex-dml-manager: as our framework to ensure secure DML operations. Why this one?
  - ESAPI usage is discarded because of limitations when using StripInnaccessible:
    - Not resolving relationships when using `fflib_SObjectUnitOfWork`.
    - Limitation when the record contains a field which is not updateable, such as formulas. Even if the field has not been modified nor changed, but is contained in the record because it was first retrieved with such field, when trying to insert the record because another field was updated, the insert fails when it should not.
    - Limitation when the record contains a field which the user has read but not edit access on a it. Even if the field has not been modified nor changed, but is contained in the record because it was first retrieved with such field, when trying to insert the record because another field was updated, the insert fails when it should not.
  - `fflib_SecurityUtils` is not enough.
  - https://github.com/trailheadapps/apex-recipes/tree/main/force-app/main/default/classes/Security%20Recipes is not enough.
  - Standard Salesforce methods such as `StripInnaccessible`, and `SObjectDescribe` methods, are not enough.
  - Standard User Mode Database Operations has been in Pilot/Beta so far. We can migrate to this option once it proved enough to be trusted.
- apex-domainbuilder: as our test data framework. An alternative to the old-fashioned TestDataFactory patterns. We could complementarily use a mocking framework, preferably [amoss](https://github.com/bobalicious/amoss).
- apex-trigger-actions-framework: as our trigger framework. No considerable alternatives. Other trigger frameworks are simply not as good as this ones.
- fflib-apex-common: as our framework to follow apex enterprise patterns. No considerable alternatives.
  extensions: custom additional functionality that extends certain areas of the previous frameworks to be used. Contains: `DebugDML.cls`, `SObjectSecureUnitOfWork.cls` and `SObjectsSecureSelector.cls`.
