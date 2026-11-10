#!/bin/sh
# Called (via on-window-detected) for each new Teams window, which the rule has
# already floated so it doesn't retile anything while we wait. Teams titles every
# new window "Microsoft Teams" and renames it shortly after, so poll its title:
# "Meeting join" windows go to M and get focus; anything else tiles in place.
# Check quickly at first in case the rename is instant, then back off; ~5s max.
aero=/opt/homebrew/bin/aerospace
id=$AEROSPACE_WINDOW_ID
[ -n "$id" ] || exit 0

for delay in 0.1 0.2 0.4 0.8 0.8 0.8 0.8 0.8; do
  sleep "$delay"
  line=$($aero list-windows --all --format '%{window-id}|%{window-title}' | grep "^$id|") \
    || exit 0 # window closed
  title=${line#*|}
  case $title in
    'Meeting join'*)
      $aero move-node-to-workspace --window-id "$id" M
      $aero layout --window-id "$id" tiling
      # Focus the window itself (not just the workspace) so macOS focus moves
      # too; Teams may steal focus back right after, so re-check a few times
      for _ in 1 2 3 4 5; do
        $aero focus --window-id "$id"
        sleep 0.4
        [ "$($aero list-workspaces --focused)" = M ] && break
      done
      exit 0 ;;
    'Microsoft Teams') ;; # not renamed yet
    *) break ;;
  esac
done
$aero layout --window-id "$id" tiling
