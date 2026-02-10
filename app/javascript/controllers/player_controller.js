import { Controller } from "@hotwired/stimulus"

// Global audio player controller
// Lives on a data-turbo-permanent element so it persists across navigations.
// Listens for "player:play" events on window to start playback of a new track.
export default class extends Controller {
  static targets = [
    "audio",
    "playPauseButton",
    "playIcon",
    "pauseIcon",
    "trackTitle",
    "currentTime",
    "duration",
    "progressBar"
  ]

  connect() {
    this.playing = false
    this.currentUrl = null

    // Listen for play requests from play buttons anywhere on the page
    this.handlePlayRequest = this._handlePlayRequest.bind(this)
    window.addEventListener("player:play", this.handlePlayRequest)

    // Audio event listeners
    this.audioTarget.addEventListener("timeupdate", () => this._updateProgress())
    this.audioTarget.addEventListener("loadedmetadata", () => this._updateDuration())
    this.audioTarget.addEventListener("ended", () => this._onEnded())
    this.audioTarget.addEventListener("play", () => this._onPlay())
    this.audioTarget.addEventListener("pause", () => this._onPause())
  }

  disconnect() {
    window.removeEventListener("player:play", this.handlePlayRequest)
  }

  _handlePlayRequest(event) {
    const { url, title } = event.detail

    if (this.currentUrl === url) {
      // Same track — toggle play/pause
      this.togglePlayPause()
      return
    }

    // New track
    this.currentUrl = url
    this.trackTitleTarget.textContent = title
    this.audioTarget.src = url
    this.audioTarget.play()

    // Show the player bar
    this.element.classList.remove("hidden")
  }

  togglePlayPause() {
    if (this.audioTarget.paused) {
      this.audioTarget.play()
    } else {
      this.audioTarget.pause()
    }
  }

  seek() {
    if (!this.audioTarget.duration) return
    const time = (this.progressBarTarget.value / 100) * this.audioTarget.duration
    this.audioTarget.currentTime = time
  }

  _onPlay() {
    this.playing = true
    this.playIconTarget.classList.add("hidden")
    this.pauseIconTarget.classList.remove("hidden")
    this._broadcastState()
  }

  _onPause() {
    this.playing = false
    this.playIconTarget.classList.remove("hidden")
    this.pauseIconTarget.classList.add("hidden")
    this._broadcastState()
  }

  _onEnded() {
    this.playing = false
    this.playIconTarget.classList.remove("hidden")
    this.pauseIconTarget.classList.add("hidden")
    this.progressBarTarget.value = 0
    this._broadcastState()
  }

  _updateProgress() {
    if (!this.audioTarget.duration) return
    const pct = (this.audioTarget.currentTime / this.audioTarget.duration) * 100
    this.progressBarTarget.value = pct
    this.currentTimeTarget.textContent = this._formatTime(this.audioTarget.currentTime)
  }

  _updateDuration() {
    this.durationTarget.textContent = this._formatTime(this.audioTarget.duration)
  }

  _formatTime(seconds) {
    if (!seconds || !isFinite(seconds)) return "0:00"
    const mins = Math.floor(seconds / 60)
    const secs = Math.floor(seconds % 60)
    return `${mins}:${secs.toString().padStart(2, "0")}`
  }

  // Broadcast current state so play buttons can update their appearance
  _broadcastState() {
    window.dispatchEvent(
      new CustomEvent("player:state", {
        detail: {
          url: this.currentUrl,
          playing: this.playing
        }
      })
    )
  }
}
