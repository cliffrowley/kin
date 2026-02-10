import { Controller } from "@hotwired/stimulus"

// Play button controller — dispatches a "player:play" event to the global player.
// Placed on individual play buttons on artefact/song views.
export default class extends Controller {
  static values = {
    url: String,
    title: String
  }

  connect() {
    this.handleStateChange = this._handleStateChange.bind(this)
    window.addEventListener("player:state", this.handleStateChange)
  }

  disconnect() {
    window.removeEventListener("player:state", this.handleStateChange)
  }

  play() {
    window.dispatchEvent(
      new CustomEvent("player:play", {
        detail: {
          url: this.urlValue,
          title: this.titleValue
        }
      })
    )
  }

  _handleStateChange(event) {
    const { url, playing } = event.detail
    const isThisTrack = url === this.urlValue

    // Update button appearance based on whether this track is playing
    if (isThisTrack && playing) {
      this.element.classList.add("btn-active")
    } else {
      this.element.classList.remove("btn-active")
    }
  }
}
