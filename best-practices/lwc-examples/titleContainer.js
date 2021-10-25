import { LightningElement, api } from 'lwc';

const DEFAULT_TITLE = 'Hello World!';
const BODY_CONTENT =
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';

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
		console.log('Title clicked');
	}

	// PRIVATE

	_multiplyBodyContent() {
		let i = 5;
		while (i--) {
			this.bodyContent += ' ' + BODY_CONTENT;
		}
	}
}
