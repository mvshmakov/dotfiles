home = "/Users/mvshmakov"
remote_host = "pi@mvshmakov-pi.local"

settings {
    logfile = home.."/.local/share/lsyncd/lsyncd.log",          --Log path
    statusFile = home.."/.local/state/lsyncd/lsyncd.status",    --Status file
    pidfile = home.."/.local/state/lsyncd/lsyncd.pid",          --pid File path
    nodaemon = true,                                            --daemon Function
    insist=true,
    statusInterval = 1,                                         --Minimum write time of status file
    maxProcesses = 1,                                           --Maximum process
    maxDelays = 1,                                              --Maximum delay
}

sourceList = {}
sourceList[home..'/projects/work/iterative/studio'] = '/home/pi/projects/work/iterative/studio'

for from_source, target_source in pairs(sourceList) do
    sync {
        default.rsync,
        source = from_source,
        delete = true,
        target = remote_host..":"..target_source,
        exclude = {".vscode/*", ".git/*", "node_modules/*", "__pycache__/*", ".DS_Store"},
        rsync     = {
            binary = "/usr/local/bin/rsync",
            -- binary ="/usr/bin/rsync",
            archive = true,
            compress = true,
            bwlimit   = 2000,
            -- TODO: use SSH_KEY_PATH
            rsh = "ssh -i"..home.."/.ssh/id_rsa"
            -- rsh = "/usr/bin/ssh -p 22 -o StrictHostKeyChecking=no"
            -- If you want to specify another port, use the rsh
        }
    }
end

