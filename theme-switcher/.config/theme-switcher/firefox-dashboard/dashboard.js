const searchForm = document.querySelector("#searchForm");
const searchInput = document.querySelector("#searchInput");
const timeLabel = document.querySelector("#timeLabel");
const dateLabel = document.querySelector("#dateLabel");
const githubGrid = document.querySelector("#githubGrid");
const githubMonths = document.querySelector("#githubMonths");
const githubTotal = document.querySelector("#githubTotal");
const githubUpdated = document.querySelector("#githubUpdated");

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

function parseDate(date) {
  const [year, month, day] = date.split("-").map(Number);
  return new Date(Date.UTC(year, month - 1, day));
}

function daysBetween(start, end) {
  return Math.round((end - start) / 86400000);
}

function monthName(date) {
  return new Intl.DateTimeFormat("en-GB", { month: "short", timeZone: "UTC" }).format(date);
}

function formatUpdated(timestamp) {
  if (!timestamp) return "contributions";
  return `updated ${new Intl.DateTimeFormat("en-GB", {
    day: "numeric",
    month: "short",
    hour: "2-digit",
    minute: "2-digit",
  }).format(new Date(timestamp * 1000))}`;
}

function renderContributionMonths(start, weeks) {
  githubMonths.innerHTML = "";
  githubMonths.style.gridTemplateColumns = `repeat(${weeks}, 14px)`;

  let previousMonth = "";
  for (let column = 0; column < weeks; column += 1) {
    const date = new Date(start);
    date.setUTCDate(start.getUTCDate() + (column * 7));
    const label = monthName(date);
    if (label === previousMonth) continue;
    previousMonth = label;

    const month = document.createElement("span");
    month.textContent = label;
    month.style.gridColumn = `${column + 1} / span 4`;
    githubMonths.append(month);
  }
}

function renderContributions(data) {
  if (!githubGrid || !githubMonths || !githubTotal || !data?.days?.length) return;

  const dates = data.days.map((day) => parseDate(day.date));
  const start = new Date(Math.min(...dates));
  start.setUTCDate(start.getUTCDate() - start.getUTCDay());
  const end = new Date(Math.max(...dates));
  const weeks = Math.max(1, Math.floor(daysBetween(start, end) / 7) + 1);
  const dayMap = new Map(data.days.map((day) => [day.date, day]));

  githubTotal.textContent = String(data.total ?? "--");
  githubUpdated.textContent = formatUpdated(data.updated_at);
  githubGrid.innerHTML = "";
  githubGrid.style.gridTemplateColumns = `repeat(${weeks}, 11px)`;
  renderContributionMonths(start, weeks);

  for (let column = 0; column < weeks; column += 1) {
    for (let row = 0; row < 7; row += 1) {
      const date = new Date(start);
      date.setUTCDate(start.getUTCDate() + (column * 7) + row);
      const key = date.toISOString().slice(0, 10);
      const day = dayMap.get(key);
      const cell = document.createElement("span");
      cell.className = "contribution-day";
      cell.dataset.level = day?.level ?? 0;
      cell.style.gridColumn = String(column + 1);
      cell.style.gridRow = String(row + 1);
      cell.title = day?.label ?? `No contributions on ${key}.`;
      githubGrid.append(cell);
    }
  }
}

async function loadContributions() {
  if (!githubGrid) return;

  try {
    const response = await fetch("../github-contributions.json", { cache: "no-store" });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    renderContributions(await response.json());
  } catch (error) {
    githubUpdated.textContent = "offline";
    githubGrid.innerHTML = '<span class="contributions-empty">Run theme-github-contributions</span>';
  }
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
loadContributions();
