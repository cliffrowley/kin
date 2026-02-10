import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    dismissDelay: { type: Number, default: 3000 },
    fadeOutDuration: { type: Number, default: 300 }
  }

  connect() {
    // Auto-dismiss toast after specified delay
    this.timeoutId = setTimeout(() => {
      this.dismiss()
    }, this.dismissDelayValue)
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
    }, this.fadeOutDurationValue)
  }
}
