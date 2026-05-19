const searchForm = document.querySelector("#searchForm");
const searchInput = document.querySelector("#searchInput");
const timeLabel = document.querySelector("#timeLabel");
const dateLabel = document.querySelector("#dateLabel");

const bangs = new Map([
  ["g", "https://github.com/search?q=%s&type=repositories"],
  ["gh", "https://github.com/search?q=%s&type=code"],
  ["yt", "https://www.youtube.com/results?search_query=%s"],
  ["w", "https://en.wikipedia.org/wiki/Special:Search?search=%s"],
  ["aw", "https://wiki.archlinux.org/index.php?search=%s"],
]);

function updateClock() {
  const now = new Date();
  timeLabel.textContent = new Intl.DateTimeFormat("en-GB", {
    hour: "2-digit",
    minute: "2-digit",
  }).format(now);
  dateLabel.textContent = new Intl.DateTimeFormat("en-GB", {
    weekday: "long",
    day: "numeric",
    month: "long",
  }).format(now);
}

function looksLikeUrl(value) {
  return /^(https?:\/\/|file:\/\/|localhost(:\d+)?\/?)/i.test(value)
    || /^[a-z0-9-]+(\.[a-z0-9-]+)+(:\d+)?(\/.*)?$/i.test(value);
}

function resolveSearch(value) {
  const trimmed = value.trim();
  const bangMatch = trimmed.match(/^!(\S+)\s+(.+)$/);

  if (bangMatch) {
    const [, bang, query] = bangMatch;
    const template = bangs.get(bang.toLowerCase());
    if (template) return template.replace("%s", encodeURIComponent(query));
  }

  if (looksLikeUrl(trimmed)) {
    return /^(https?:\/\/|file:\/\/)/i.test(trimmed) ? trimmed : `https://${trimmed}`;
  }

  return `https://duckduckgo.com/?q=${encodeURIComponent(trimmed)}`;
}

searchForm.addEventListener("submit", (event) => {
  event.preventDefault();
  const value = searchInput.value.trim();
  if (!value) return;
  window.location.href = resolveSearch(value);
});

window.addEventListener("keydown", (event) => {
  if (event.key === "/" && document.activeElement !== searchInput) {
    event.preventDefault();
    searchInput.focus();
  }
});

updateClock();
setInterval(updateClock, 1000);
