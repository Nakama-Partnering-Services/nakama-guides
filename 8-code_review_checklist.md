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
<?xml version="1.0"?>
<ruleset name="Nakama ruleset for Salesforce.com Apex"
	xmlns="http://pmd.sourceforge.net/ruleset/2.0.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://pmd.sourceforge.net/ruleset/2.0.0 https://pmd.sourceforge.io/ruleset_2_0_0.xsd">

	<description>Nakama Partnering Services Opinionated PMD Ruleset</description>

	<!-- IGNORE EXTERNAL LIBS -->
	<include-pattern>.*/core/.*</include-pattern>

	<!-- STANDARD RULES -->

	<rule ref="category/apex/bestpractices.xml">
		<priority>2</priority>

		<!-- Better have a focused well named method -->
		<exclude name="ApexAssertionsShouldIncludeMessage" />
		<!-- Overwritten below -->
		<exclude name="ApexUnitTestClassShouldHaveAsserts" />
	</rule>

	<rule ref="category/apex/codestyle.xml">
		<priority>2</priority>

		<!-- Overwritten below -->
		<exclude name="ClassNamingConventions" />
	</rule>

	<rule ref="category/apex/design.xml">
		<priority>2</priority>

		<!-- Note: Cognitive Complexity covers all of that better -->
		<exclude name="AvoidDeeplyNestedIfStmts" />
		<exclude name="StdCyclomaticComplexity" />
		<exclude name="CyclomaticComplexity" />
		<exclude name="ExcessiveClassLength" />
		<exclude name="ExcessiveParameterList" />
		<exclude name="ExcessivePublicCount" />
		<exclude name="TooManyFields" />
		<exclude name="NcssConstructorCount" />
		<exclude name="NcssMethodCount" />
		<exclude name="NcssTypeCount" />
	</rule>

	<rule ref="category/apex/errorprone.xml">
		<priority>2</priority>
	</rule>

	<rule ref="category/apex/performance.xml">
		<priority>2</priority>

		<!-- Overwritten below -->
		<exclude name="AvoidDebugStatements" />
	</rule>

	<rule ref="category/apex/security.xml">
		<priority>1</priority>
	</rule>

	<!-- OVERWRITTEN STANDARD RULES -->

	<rule ref="category/apex/bestpractices.xml/ApexUnitTestClassShouldHaveAsserts"
		message="Apex unit test classes should have at least one System.assert() or assertEquals() or AssertNotEquals() call">
		<priority>2</priority>

		<properties>
			<property name="additionalAssertMethodPattern"
				value="((System\.Assert|Assert|Asserts)\.\w+|verify\w+)" />
		</properties>
	</rule>

	<rule ref="category/apex/codestyle.xml/ClassNamingConventions">
		<priority>2</priority>
		<properties>
			<property name="testClassPattern" value="[A-Z][a-zA-Z0-9_]*" />
			<property name="abstractClassPattern" value="[A-Z][a-zA-Z0-9]*" />
			<property name="classPattern" value="[A-Z][a-zA-Z0-9]*" />
			<property name="interfacePattern" value="[A-Z][a-zA-Z0-9]*" />
			<property name="enumPattern" value="[A-Z][a-zA-Z0-9]*" />
		</properties>
	</rule>

	<rule ref="category/apex/performance.xml/AvoidDebugStatements"
		message="Avoid leaving System.debug() statments in code as they negatively influence performance.">
		<priority>2</priority>

		<properties>
			<property name="xpath">
				<value>
					<![CDATA[//MethodCallExpression[lower-case(@FullMethodName)='system.debug'][count(*)=2]]]>
				</value>
			</property>
		</properties>
	</rule>

	<!-- Apex rules -->

	<rule name="UseTypeForNameOrDeferredFor" language="apex"
		message=""
		class="net.sourceforge.pmd.lang.rule.xpath.XPathRule">
		<priority>2</priority>
		<properties>
			<property name="xpath">
				<value>
					<![CDATA[
						//MethodCallExpression[lower-case(@MethodName)='get']/ReferenceExpression
						/MethodCallExpression[lower-case(@MethodName)='getglobaldescribe']/ReferenceExpression[lower-case(@Image)='schema']
					]]>
				</value>
			</property>
		</properties>
	</rule>

	<rule name="UnneededUseOfThisReducesReadability" language="apex"
		message="Unneeded use of this reduces readability"
		class="net.sourceforge.pmd.lang.rule.xpath.XPathRule">
		<priority>3</priority>
		<properties>
			<property name="xpath">
				<value>
					<![CDATA[
						//ThisVariableExpression[not(
							ancestor::ReturnStatement
							or
							ancestor::MethodCallExpression[ReferenceExpression/@Image = VariableExpression/@Image]
							or
							ancestor::AssignmentExpression[VariableExpression[1]/@Image = VariableExpression[2]/@Image]
						)]
					]]>
				</value>
			</property>
		</properties>
	</rule>

	<rule name="OnlyOneReturnPerMethod" language="apex"
		message="Method with multiple returns are confusing"
		class="net.sourceforge.pmd.lang.rule.xpath.XPathRule">
		<priority>3</priority>
		<properties>
			<property name="xpath">
				<value>
					<![CDATA[//Method[count(.//ReturnStatement) > 1]]]>
				</value>
			</property>
		</properties>
	</rule>

	<rule name="TestsShouldNotStartWithTest" language="apex"
		message="Test results are harder to grasp when tests start with the word test"
		class="net.sourceforge.pmd.lang.rule.xpath.XPathRule">
		<priority>3</priority>
		<properties>
			<property name="xpath">
				<value>
					<![CDATA[
						//Method[
							starts-with(lower-case(@Image), "test")
							and
							descendant::ModifierNode/Annotation[@Image="IsTest"]
						]
					]]>
				</value>
			</property>
		</properties>
	</rule>

	<rule name="DeclareWhatYouReturnFirstAndCallItResult" language="apex"
		message="What you return call it result and declare it in the first line"
		class="net.sourceforge.pmd.lang.rule.xpath.XPathRule">
		<priority>3</priority>
		<properties>
			<property name="xpath">
				<value>
					<![CDATA[
						//ReturnStatement[
							lower-case(@Image) != 'result'
							and
							ancestor::Method[
								@Synthetic = false()
								and
								lower-case(@ReturnType)!='void'
							]
							and
							preceding-sibling::VariableDeclarationStatements/VariableDeclaration[1][@Image != 'result'
						]]
					]]>
				</value>
			</property>
	</properties>
	</rule>

	<!-- Metadata XML Rules -->

	<rule name="BumpApiVersion" language="xml" message="Metadata should use the latest API version."
		class="net.sourceforge.pmd.lang.rule.xpath.XPathRule">
		<priority>3</priority>
		<properties>
			<property name="xpath">
				<value>
					<![CDATA[//apiVersion/text[number(@Image) < 60]]]>
				</value>
			</property>
		</properties>
	</rule>

	<!-- Flow Rules -->

	<rule name="DMLStatementInFlowLoop" language="xml"
		message="DML Operations shouldn't be done inside of Flow loops"
		class="net.sourceforge.pmd.lang.rule.xpath.XPathRule">
		<priority>2</priority>
		<properties>
			<property name="xpath">
				<value>
					<![CDATA[
						//Flow/loops//targetReference[not(ancestor::noMoreValuesConnector)]/text[@Image=//Flow/(recordCreates|recordDeletes|recordUpdates)/name/text/@Image]
					]]>
				</value>
			</property>
		</properties>
	</rule>

	<!-- Custom Objects / Fields Rules -->

	<rule name="NoUnderscoresInFieldNames" language="xml"
		message="Custom fields should not contain underscores."
		class="net.sourceforge.pmd.lang.rule.xpath.XPathRule">
		<priority>3</priority>
		<properties>
			<property name="xpath">
				<value>
					<![CDATA[
						//CustomField/fullName/text[matches(@Image, ".*_.*__c")]
					]]>
				</value>
			</property>
		</properties>
	</rule>

	<!-- Profile and Permission Set Rules -->

	<rule name="ModifyOrViewAllOnPermSet" language="xml"
		message="Allowing this user permission can give access and ability to modify sensitive data."
		class="net.sourceforge.pmd.lang.rule.xpath.XPathRule">
		<priority>1</priority>
		<properties>
			<property name="xpath">
				<value>
					<![CDATA[
						//PermissionSet/userPermissions[name/text[@Image='ModifyAllData' or @Image='ViewAllData'] and enabled/text[@Image='true']]
					]]>
				</value>
			</property>
		</properties>
	</rule>

	<rule name="ModifyOrViewAllOnSysAdminProfile" language="xml"
		message="Only Admins can view and modify all data, if any other profile get these permissions, they could manipulate records that shouldn't"
		class="net.sourceforge.pmd.lang.rule.xpath.XPathRule">
		<priority>1</priority>
		<properties>
			<property name="xpath">
				<value>
					<![CDATA[
						//Profile/userPermissions[name/text[@Image='ModifyAllData' or @Image='ViewAllData'] and enabled/text[@Image='true'] and pmd:fileName() != 'System Administrator']
					]]>
				</value>
			</property>
		</properties>
	</rule>

	<rule name="ManageUsersByNonSysAdmins" language="xml"
		message="Managing users need to be limited to System Administrator Profile only."
		class="net.sourceforge.pmd.lang.rule.xpath.XPathRule">
		<priority>1</priority>
		<properties>
			<property name="xpath">
				<value>
					<![CDATA[
						//Profile/userPermissions[ pmd:fileName() != 'System Administrator' and name/text[@Image='ManageUsers']]
					]]>
				</value>
			</property>
		</properties>
	</rule>

	<rule name="ViewSetupByNonSysAdmins" language="xml"
		message="Exposing the setup menu to non-authorized users."
		class="net.sourceforge.pmd.lang.rule.xpath.XPathRule">
		<priority>1</priority>
		<properties>
			<property name="xpath">
				<value>
					<![CDATA[
						//Profile/userPermissions[ pmd:fileName() != 'System Administrator' and enabled/text[@Image='true'] and name/text[@Image='ViewSetup']]
					]]>
				</value>
			</property>
		</properties>
	</rule>
</ruleset>
```
