#!/bin/sh
# Called on every new Teams window. Teams sets the title after the window is
# detected, so poll briefly and move only "Meeting join" windows to M.
aero=/opt/homebrew/bin/aerospace
seen=/tmp/aerospace-teams-meetings-moved
log=/tmp/aerospace-teams-meeting.log
for _ in 1 2 3 4 5 6 7 8 9 10; do
  sleep 0.3
  ids=$($aero list-windows --all --format '%{window-id}|%{app-bundle-id}|%{window-title}' \
    | awk -F'|' '$2 == "com.microsoft.teams2" && $3 ~ /^Meeting join/ { print $1 }')
  for id in $ids; do
    # Only move a meeting window once, so moving it away later sticks
    grep -qx "$id" "$seen" 2>/dev/null && continue
    echo "$id" >> "$seen"
    $aero move-node-to-workspace --window-id "$id" M
    # Focus the window itself (not just the workspace) so macOS focus moves
    # too; Teams may steal focus back right after, so re-check a few times
    for _ in 1 2 3 4 5; do
      $aero focus --window-id "$id"
      sleep 0.4
      [ "$($aero list-workspaces --focused)" = M ] && break
    done
    echo "$(date '+%T') moved $id, focused=$($aero list-workspaces --focused)" >> "$log"
    exit 0
  done
done
