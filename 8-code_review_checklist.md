# Code review checklist.

- [Why code review](#why-code-review)
- [Review checklist](#review-checklist)
- [PMD ruleset](#pmd-ruleset)

## Why code review

The following checklist should be followed to ensure all development meets our code quality standards. The purpose of the checklist is ensuring Clean Coding and Best practices by checking:

- Reduce cost of maintenance - 40% - 80% of the lifetime of a piece of Software goes into maintenance.
- Maintainability.
- Code readability.
- Consistency.
- Code-re-usability.
- Avoid technical debts.

## Review checklist

1. Is code is following Standard Guidelines.
   - Naming conventions.
   - Formatting Salesforce.
   - Keep your methods short.
   - Don’t repeat yourself.
   - Methods should do just one thing.
2. Is code following Defined Architecture?
   - Order of Execution : be aware of order of executions.
   - Exception Handling & Logging Framework (Nebula Logger).
   - Trigger Framework is implemented properly.
3. Is the code meeting the Non Functional Requirements?
   - Is the code scalable to support huge number of users?
   - Is the performance acceptance with huge data?
   - Is security taken care?
   - Is the code maintainable easily?
4. Apex best practices : Prefer clicks over code where ever possible.
   - Avoid hardcoding IDs.
   - Bulkify your code.
   - No DML/SOQL inside for Loop.
   - Secure DML, queries.
   - No global classes.
   - Use with sharing.
   - No SOQL injection.
   - Create one trigger per object.
   - Apex test classes best practices.
   - Write meaningful tests with asserts.
   - At least one assert per method.
   - Focus on 100% code coverage.
   - Writing test methods to verify large datasets.
   - Use apex-domainbuilder for data creation.
   - Remember that you can utilize map for queries when needed.
   - Use of the limits Apex methods to avoid hitting governor limits.
5. OOAD ( Object Oriented Analysis & Design)
   - Separation of Concerns.
   - DRY principle.
   - SOLID principle.
   - Single-responsibility principle: a piece of logic should only have a single responsibility, and that responsibility should be entirely encapsulated by the class, module or function.
   - Open-closed principle : software entities should be open for extension but closed for modification.
   - Dependency inversion principle : depend on abstractions and not concretions.
   - Dependency injection.
6. Static Code Analysis: Programming Mistake Detector - PMD tool can be used for static code analysis. A free Apex PMD extension is available with VSCode.

#### PMD ruleset

```XML
<?xml version="1.0" encoding="UTF-8"?>
<ruleset
    name="Nakama ruleset for Salesforce.com Apex"
    xmlns="http://pmd.sourceforge.net/ruleset/2.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://pmd.sourceforge.net/ruleset/2.0.0 https://pmd.sourceforge.io/ruleset_2_0_0.xsd">

    <description>
        Nakama PMD ruleset
    </description>

    <!-- STANDARD RULES -->

    <rule ref="category/apex/security.xml">
        <priority>1</priority> <!-- Only Security should show red, everything else default 2 -->
    </rule>
    <rule ref="category/apex/design.xml" />
    <rule ref="category/apex/performance.xml">
        <exclude name="AvoidDebugStatements" /> <!-- We have smarter rule below -->
    </rule>
    <rule ref="category/apex/codestyle.xml" />
    <rule ref="category/apex/bestpractices.xml">
        <exclude name="ApexAssertionsShouldIncludeMessage" /> <!-- Not enforce, sometimes it is controversial and redundant -->
    </rule>
    <rule ref="category/apex/documentation.xml">
        <exclude name="ApexDoc"/> <!-- Nonsense rule even against Clean Code -->
    </rule>
    <rule ref="category/apex/errorprone.xml" />
    <rule ref="category/apex/multithreading.xml" />

    <!-- CUSTOM SF METADATA RULES -->

    <rule name="NoUnderscoresInFieldNames" language="xml" message="Custom fields should not contain underscores." class="net.sourceforge.pmd.lang.rule.XPathRule">
        <priority>3</priority>
        <properties>
            <property name="version" value="2.0"></property>
            <property name="xpath">
                <value>
                    <![CDATA[
                        //CustomField/fullName/text[matches(@Image, ".*_.*__c")]
                    ]]>
                </value>
            </property>
        </properties>
    </rule>

    <rule name="ModifyAllOnPermSet" language="xml" message="Allowing this user permission can give access and ability to modify sensitive data." class="net.sourceforge.pmd.lang.rule.XPathRule">
        <priority>3</priority>
        <properties>
            <property name="version" value="2.0"></property>
            <property name="xpath">
                <value>
                    <![CDATA[
                        //PermissionSet/userPermissions[ name/text[@Image='ModifyAllData'] and enabled/text[@Image='true'] ]
                    ]]>
                </value>
            </property>
        </properties>
    </rule>
</ruleset>
```
