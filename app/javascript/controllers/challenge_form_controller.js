import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['row', 'errors'];

  add(e) {
    e.preventDefault();

    const formElement = this.rowTarget.firstElementChild.cloneNode(true);
    formElement.id = '';
    const inputFields = formElement.querySelectorAll('input');
    inputFields.forEach(input => input.value = '');

    const counter = this.data.get('counter') || 0;
    this.data.set('counter', parseInt(counter) + 1);

    const index = parseInt(counter) + 1;

    formElement.dataset.index = index;

    const deleteSection = formElement.querySelector('#delete-section');
    const deleteIcon = document.createElement('i');
    deleteIcon.setAttribute('data-action', 'click->challenge-form#remove');
    deleteIcon.classList.add('fa-solid','fa-trash');
    deleteSection.appendChild(deleteIcon);

    const formContainer = document.querySelector('#form-section');
  
    formContainer.appendChild(formElement);
  }

  remove(e) {
    e.preventDefault();
    const formElement = e.currentTarget.closest('[data-index]');
    formElement.remove();
  }

  clearErrors() {
    this.errorsTarget.remove();
  }
}
