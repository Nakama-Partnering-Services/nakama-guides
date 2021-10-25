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
