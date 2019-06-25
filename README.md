# Marker - A new Role for TTT2

The marker plays in his own team and has the goal of marking other players with his fancy paintgun. Once he marked enough of them (by default all players except himself) he wins. Marked players get notified when they are marked, so they do know there's a marker active in this round (you can disable that). The marker can't win by killing people in fact by default he can't deal any damage at all, he always looses when only he and maximal one other role is alive. Therefore he plays nicely alongside the jester, since then there are two roles that do not deal any damage, one of which should be killed and one shouldn't. If he's too slow with marking other players, he might be unable to mark enough of them. Once all markers are dead, all players are unmarked! Players that were marked but killed afterwards do not count to marked players.

Additionally the marker sees in a special UI element how many players he has to mark. And since this number is scaled by the number of players that are alive, he can get a sense of how many players are still alive. This gives him some interesting powers, but he should keep quiet about them because calling out that someone has died might reveal him. Marked players do not deal any damage at all to him and he wears a body armor to protect himself.

## Convars

Besides the normal role convars found in ULX, there are these special convars:

```
# should marked players get a symbol in their status display
  ttt_mark_show_sidebar [0/1] (default: 1)
# should the marker be informed via a message when a player was marked / a marked player dies
  ttt_mark_show_messages [0/1] (default: 1)
# what is the lower limit when the marker is unable to win, set to 0 to disable
  ttt_mark_min_alive [0..n] (default: 4)
# the upper limit of how many players have to be marked, set to high number to disable
  ttt_mark_max_to_mark [0..n] (default: 9)
# which percentage of alive non marker players have to be marked in order to win?
  ttt_mark_pct_marked [0.0..1.0] (def: 1.0)
# set to a specific max value if you do not want to used a scaled max value at all, set to -1 to used scaled max
  ttt_mark_fixed_mark_amount [-1..n] (def: -1)
# sets if the marker should be able to deal any damage
  ttt_mark_deal_no_damage [0/1] (def: 1)
# sets if marked players should be able to deal any damage to the marker
  ttt_mark_take_no_damage [0/1] (def: 1)
# defines the factor to calculate the amount of defis; set to 0 to disable
  ttt_mark_defi_factor [0.0..1.0] (def: 0.34)
```
