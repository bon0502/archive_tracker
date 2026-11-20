import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    videoId: String,
    startSeconds: Number,
    saveUrl: String
  }
  static targets = ["player","currentTime", "remainingTime", "progressBar"]

  connect() {
    this.loadYouTubeAPI()
  }

  // YouTube IFrame Player API を読み込む
  loadYouTubeAPI() {
    if (window.YT && window.YT.Player) {
      this.initPlayer()
      return
    }

    const tag = document.createElement("script")
    tag.src = "https://www.youtube.com/iframe_api"
    document.head.appendChild(tag)

    window.onYouTubeIframeAPIReady = () => {
      this.initPlayer()
    }
  }

  // プレイヤーを初期化する
  initPlayer() {
    this.player = new YT.Player(this.playerTarget, {
      videoId: this.videoIdValue,
      playerVars: {
        start: this.startSecondsValue
      },
      events: {
        onReady: () => this.startTracking()
      }
    })

    // ページを離れる時に再生位置を保存する
    window.addEventListener("beforeunload", () => {
      this.saveBeacon()
    })
  }

  startTracking() {
    this.displayTimer = setInterval(() => {
      this.updateTimeDisplay()
    }, 1000)

    this.timer = setInterval(() => {
      this.savePosition()
    }, 5000)
  }

  disconnect() {
    clearInterval(this.displayTimer)
    clearInterval(this.timer)
  }

  // 再生位置をサーバーに保存する(定期保存用)
  savePosition() {
    if (!this.player) return

    const currentPosition = Math.floor(this.player.getCurrentTime())
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content

    fetch(this.saveUrlValue, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": csrfToken,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({
        viewing_position: { current_position_seconds: currentPosition }
      })
    })
  }

  // 再生位置をサーバーに保存する(ページ離脱時専用)
  saveBeacon() {
    if (!this.player) return

    const currentPosition = Math.floor(this.player.getCurrentTime())
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content

    const formData = new FormData()
    formData.append("authenticity_token", csrfToken)
    formData.append("viewing_position[current_position_seconds]", currentPosition)

    navigator.sendBeacon(this.saveUrlValue, formData)
  }

  updateTimeDisplay() {
  if (!this.player) return

  const current = this.player.getCurrentTime()
  const duration = this.player.getDuration()
  const remaining = duration - current

  if (this.hasCurrentTimeTarget) {
    this.currentTimeTarget.textContent = this.formatTime(current)
  }
  if (this.hasRemainingTimeTarget) {
    this.remainingTimeTarget.textContent = this.formatTime(remaining)
  }
  if (this.hasProgressBarTarget && duration > 0) {
    const percentage = Math.floor((current / duration) * 100)
    this.progressBarTarget.style.width = `${percentage}%`
    this.progressBarTarget.textContent = `${percentage}%`
  }
}

formatTime(seconds) {
  if (isNaN(seconds) || seconds < 0) return "00:00"

  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  const s = Math.floor(seconds % 60)
  const pad = (num) => String(num).padStart(2, "0")

  return h > 0 ? `${h}:${pad(m)}:${pad(s)}` : `${pad(m)}:${pad(s)}`
}
}
