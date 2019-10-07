hook.Add("TTT2AddChange", "TTT2_role_marker_changelog", function()
    AddChange("TTT2 Role Marker - v1.0", [[
        <ul>
            <li>Initial Release</li>
        </ul>
        <br>
        <h2>How to Play:</h2>
        <p>The marker plays in his own team and has the goal of marking other players with his fancy paintgun. Once he marked enough of them (by default all players except himself) he wins. Marked players get notified when they are marked, so they do know there's a marker active in this round (you can disable that). The marker can't win by killing people in fact by default he can't deal any damage at all, he always looses when only he and maximal one other role is alive. Therefore he plays nicely alongside the jester, since then there are two roles that do not deal any damage, one of which should be killed and one shouldn't. If he's too slow with marking other players, he might be unable to mark enough of them. Once all markers are dead, all players are unmarked! Players that were marked but killed afterwards do not count to marked players.</p>

        <p>Additionally the marker sees in a special UI element how many players he has to mark. And since this number is scaled by the number of players that are alive, he can get a sense of how many players are still alive. This gives him some interesting powers, but he should keep quiet about them because calling out that someone has died might reveal him. Marked players do not deal any damage at all to him and he wears a body armor to protect himself.</p>
        
        <p>The marker spawns with a marker defi that allows him to revive dead players. Revived players keep their role but spawn as marked. Since nobody knows if he is a traitor, a survivalist or a marker he can confuse others really fast.</p>
    ]], os.time({year = 2019, month = 06, day = 22}))

    AddChange("TTT2 Role Marker - v1.1", [[
        <ul>
            <li>Small fix to make sure marked players are always informed</li>
            <li>Fixed a problem with the damage hook</li>
            <li>Added a marker's defi</li>
            <li>Added text to show if a player is marked</li>
        </ul>
    ]], os.time({year = 2019, month = 06, day = 25}))
    
    AddChange("TTT2 Role Marker - v1.2", [[
        <ul>
            <li>Added scoreboard support</li>
            <li>Updated marker to use new fontrendering</li>
            <li>EquipMenuData fix</li>
            <li>Fixed some icon bugs</li>
        </ul>
    ]], os.time({year = 2019, month = 07, day = 07}))

    AddChange("TTT2 Role Marker - v1.3", [[
        <ul>
            <li>Fixed pirate-marker interaction</li>
            <li>Fixed scoreboard sometimes causing erros</li>
            <li>Improved marker radar to show different types based on their goal:</li>
            <ul>
                <li>Corpses are shown in a light gray</li>
                <li>Marked players are shown in violet</li>
                <li>Other players are shown in green</li>
                <li>Players in the TEAM_MARKER are hidden in this radar</li> 
            </ul>
            <li>Improved loadout by using other hooks, prevents wrong loadout when a player was a marker in the previous round</li>
        </ul>
    ]], os.time({year = 2019, month = 09, day = 11}))

    AddChange("TTT2 Role Marker - v1.4", [[
        <ul>
            <li>Using new loadout functions that allow item giving without raceconditions</li>
            <li>Giving the marker 60 armor points on spawn</li>
            <li>Fixed a convar error where setting it to 0 disabled all damage taken on the server</li>
            <li>Added "was marked" indicator to body search</li>
        </ul>
    ]], os.time({year = 2019, month = 10, day = 07}))
end)