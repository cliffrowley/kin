import { Controller } from "@hotwired/stimulus"

// Manages theme switching with DaisyUI theme-controller radios.
// Supports system (prefers-color-scheme), light, and dark.
// Persists the user's choice in localStorage.
export default class extends Controller {
  static targets = ["radio", "iconLight", "iconDark"]

  static STORAGE_KEY = "kin-theme"

  connect() {
    const saved = localStorage.getItem(this.constructor.STORAGE_KEY) || "system"
    this.mediaQuery = window.matchMedia("(prefers-color-scheme: dark)")
    this.handleSystemChange = () => this.updateIcon()
    this.mediaQuery.addEventListener("change", this.handleSystemChange)
    this.restoreTheme(saved)
  }

  disconnect() {
    this.mediaQuery?.removeEventListener("change", this.handleSystemChange)
  }

  change(event) {
    const value = event.target.value
    const theme = value || "system"
    this.applyTheme(theme)
    localStorage.setItem(this.constructor.STORAGE_KEY, theme)
    document.activeElement?.blur()
  }

  restoreTheme(theme) {
    const value = theme === "system" ? "" : theme
    this.radioTargets.forEach(radio => {
      radio.checked = radio.value === value
    })
    this.applyTheme(theme)
  }

  applyTheme(theme) {
    this.currentSetting = theme
    if (theme === "system") {
      document.documentElement.removeAttribute("data-theme")
    } else {
      document.documentElement.setAttribute("data-theme", theme)
    }
    this.updateIcon()
  }

  updateIcon() {
    const isDark = this.effectiveThemeIsDark()
    this.iconLightTarget.classList.toggle("hidden", isDark)
    this.iconDarkTarget.classList.toggle("hidden", !isDark)
  }

  effectiveThemeIsDark() {
    if (this.currentSetting === "dark") return true
    if (this.currentSetting === "light") return false
    // system: check OS preference
    return this.mediaQuery?.matches ?? true
  }
}
