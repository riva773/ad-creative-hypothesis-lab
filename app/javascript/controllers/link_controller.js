import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  visit() {
    window.location.href = this.element.dataset.href
  }
}
