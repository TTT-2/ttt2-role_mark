# Marker - A new Role for TTT2

The marker plays in his own team and has the goal of marking other players with his fancy paintgun. Once he marked enough of them (by default all players except himself) he wins. Marked players get notified when they are marked, so they do know there's a marker active in this round (you can disable that). The marker can't win by killing people, he always looses when only he and maximal one other role is alive). If he's to slow with marking other players, he might be unable to mark enough of them. Once all markers are dead, all players are unmarked! Players that were marked but killed afterwards do not count to marked players.

Additionally the marker sees in a special UI element how many players that aren't in his team are still alive. This gives him some interesting powers, but he should keep quiet about them because calling out that someone has died might reveal him.

## Convars

Besides the normal role convars found in ULX, there are these special convars:

```
# should marked players get a symbol in their status display
  ttt_mark_show_sidebar [0/1] (default: 1)
# should the marker be informed via a message when a player was marked / a marked player dies
  ttt_mark_show_messages [0/1] (default: 1)
# how many players have to be marked at least for the marker to win
  ttt_mark_min_alive [0..n] (default: 4)
# which percentage of alive non marker players have to be marked in order to win?
  ttt_mark_pct_marked [0.0..1.0] (def: 1.0)
# sets how much damage the marker should receive. 0 is no damage, 1 is full damage
  ttt_mark_scale_dmg [0.0..1.0] (def: 0.1)
# sets if the marker should be able to deal any damage
  ttt_mark_deal_no_damage [0/1] (def: 1)
```
