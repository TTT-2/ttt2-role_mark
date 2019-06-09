# Marke - A new Role for TTT2

The marker plays in his own team and has the goal of marking other players with his fancy paintgun. Once he marked enough of them (by default all players except himself) he wins. Marked players get notified when they are marked, so they do know there's a marker active in this round (you can disable that). The marker can't win by killing people, he always looses when only he and maximal one other role is alive). If he's to slow with marking other players, he might be unable to mark enough of them. Once all markers are dead, all players are unmarked! Players that were marked but killed afterwards do not count to marked players.

## Conars

Besides the normal role convars found in ULX, there are these special convars:

```
# should marked players get a symbol in their status display
  ttt_mark_show_sidebar [0/1] (default: 1)
# should the marker be informed via a message when a player was marked / a marked player dies
  ttt_mark_show_messages [0/1] (default: 1)
# how many players have to be marked at least for the marker to win
  ttt_mark_min_alive [0..n] (default: 5)
# which percentage of alive non marker players have to be marked in order to win?
  ttt_mark_pct_marked [0.0..1.0] (def: 1.0)
```
