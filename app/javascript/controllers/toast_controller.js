import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Auto-dismiss toast after 3 seconds
    this.timeoutId = setTimeout(() => {
      this.dismiss()
    }, 3000)
  }

  disconnect() {
    // Clear timeout if element is removed before timeout fires
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }

  dismiss() {
    // Add fade-out class for smooth transition
    this.element.classList.add("toast-fade-out")
    
    // Remove element after transition completes
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
