import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "menu", "editModal", "deleteModal" ]

  open() {
    this.menuTarget.classList.toggle("hidden")
  }

  close() {
    this.menuTarget.classList.add("hidden")
  }

  openEdit() {
    this.close()
    this.editModalTarget.classList.remove("hidden")
    this.editModalTarget.classList.add("flex")
  }

  closeEdit() {
    this.editModalTarget.classList.add("hidden")
    this.editModalTarget.classList.remove("flex")
  }

  openDelete() {
    this.close()
    this.deleteModalTarget.classList.remove("hidden")
    this.deleteModalTarget.classList.add("flex")
  }

  closeDelete() {
    this.deleteModalTarget.classList.add("hidden")
    this.deleteModalTarget.classList.remove("flex")
  }

  closeEditOnBackdrop(event) {
    if (this.editModalTarget === event.target) {
      this.closeEdit()
    }
  }

  closeDeleteOnBackdrop(event) {
    if (this.deleteModalTarget === event.target) {
      this.closeDelete()
    }
  }

  closeOutside(event) {
    if (this.menuTarget === event.target) {
      this.close()
    }
  }
}
