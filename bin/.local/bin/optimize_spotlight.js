// This script opts out Spotlight from indexing node_modules in process.env.ROOT_DIR.
// Initially retrieved from the https://github.com/Strajk/setup/blob/master/programs/prevent-spotlight-from-indexing-node-modules.js
// Contains a fix from https://github.com/yarnpkg/yarn/issues/6453#issuecomment-764526584

const { execSync } = require("child_process");

// Customize
// ===
const DIR = process.env.ROOT_DIR || `/Users/${process.env.USER}/projects`

// Keep
// ===
const PLIST = "/System/Volumes/Data/.Spotlight-V100/VolumeConfiguration.plist"
const BUDDY = "/usr/libexec/PlistBuddy"

// Helpers
// ---
const execSyncSudo = (input, options = {}) => execSync(`sudo ${input}`, options)
const cleanArray = input => input.toString().split("\n").map(x => x.trim()).filter(x => x.length)

// Collect info
// ===
const candidates = cleanArray(execSync(`find ${DIR} -type d -name 'node_modules' -prune`))
const existing = cleanArray(execSyncSudo(`${BUDDY} -c "Print :Exclusions" ${PLIST} | sed -e 1d -e '$d'`)) // TODO: Nicer way of getting pure array of results
const toAdd = candidates.filter(x => !existing.includes(x))

console.log(`Candidates: ${candidates.length}, Existing: ${existing.length}, To add: ${toAdd.length}`)

// Uncomment to clear and add everything
// execSyncSudo(`${BUDDY} -c "Delete :Exclusions" ${PLIST}`)
// execSyncSudo(`${BUDDY} -c "Add :Exclusions array" ${PLIST}`)
// replace toAdd with candidates on the next line

// Execute
// ===
toAdd.forEach(item => {
  execSyncSudo(`${BUDDY} -c "Add :Exclusions: string ${item}" ${PLIST}`)
})
execSyncSudo(`launchctl stop com.apple.metadata.mds && sudo launchctl start com.apple.metadata.mds`)

// Report
// ===
console.log("Current content of Exclusions:")
console.log("===")
execSyncSudo(`${BUDDY} -c "Print :Exclusions" ${PLIST}`, { stdio: 'inherit' })

console.log("")
console.log("👀 Check and verify at System Preferences > Spotlight > Privacy")

// Notes
// ===
/*
Inspired by https://mattprice.me/2020/programmatically-modify-spotlight-ignore/
Inspired by https://github.com/yarnpkg/yarn/issues/6453#issuecomment-476048618
`defaults` does not work, throws: `The domain/default pair of (..., Exclusions) does not exist`, otherwise the code would be sth like this
defaults read $PLIST Exclusions
defaults write $PLIST Exclusions -array-add $PATH
*/
