local home = "/Users/mvshmakov"
local remote_host = "pi@mvshmakov-pi.local"

-- https://lsyncd.github.io/lsyncd/manual/config/file/
settings({
  logfile = home .. "/.local/share/lsyncd/lsyncd.log",
  statusFile = home .. "/.local/state/lsyncd/lsyncd.status",
  pidfile = home .. "/.local/state/lsyncd/lsyncd.pid",

  nodaemon = true,    -- do not detach from tty on startup
  insist = true,      -- keep running at startup although one or more targets failed due to not being reachable.
  statusInterval = 1, -- minimum write time of status file
  maxProcesses = 1,   -- maximum process
  maxDelays = 1,      -- maximum delay
})

-- Can add arbutrary number of sources
local sourceList = {}
sourceList[home .. "/projects/work/iterative/studio"] = "/home/pi/projects/work/iterative/studio"

for from_source, target_source in pairs(sourceList) do
  sync({
    -- Should be one of 'direct' | 'rsync' | 'rsyncssh'
    -- 'direct' uses /bin/cp or /bin/mv commands during operation to optimize performance,
    -- though startup is still done by rsync
    -- https://lsyncd.github.io/lsyncd/manual/config/layer4/#defaultdirect
    default.direct,
    delete = true,
    source = from_source,
    target = remote_host .. ":" .. target_source,
    exclude = { ".vscode/*", ".git/*", "node_modules/*", "__pycache__/*", ".history/*", ".DS_Store" },
    rsync = {
      -- https://stackoverflow.com/questions/13713101/rsync-exclude-according-to-gitignore-hgignore-svnignore-like-filter-c#comment43645099_15373763
      binary = "/usr/bin/env rsync --exclude='/.git' --filter='dir-merge,- .gitignore'",
      archive = true,
      compress = true,
      bwlimit = 2000,
    },
  })
end
