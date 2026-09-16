import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { autoOpen: Boolean }
  static targets = ["modal"]

  open() {
    this.modalTarget.classList.remove("hidden")
    this.modalTarget.classList.add("flex")
  }

  close() {
    this.modalTarget.classList.add("hidden")
    this.modalTarget.classList.remove("flex")
  }

  closeOutside(event) {
    if (this.modalTarget === event.target) {
      this.close()
    }
  }

  connect() {
    if (this.autoOpenValue === true) {
      this.open()
    }
  }
}
