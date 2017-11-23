(defrule main (declare(salience 10))
    =>
    (assert (get skill)) ;Start by checking skill
)

;;;;;;;;;;;;;;;;;;;;;;;;
;;;;User input rules;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

;Each defrule here handles filling one of the slots of instances of the PLAYER class.
;Rule names are in the format get-{name}, where {name} is the name of the PLAYER slot that rule is responsible for.

;Repeatedly prompt user for input until it matches any of $?allowed-values, then return the validated input. Case insensitive.
(deffunction read-input (?prompt $?allowed-values)
    (printout t ?prompt)
    (bind ?answer (read))
    (if (lexemep ?answer)
       then (bind ?answer (lowcase ?answer))
    )
    (while (not (member ?answer ?allowed-values)) do
        (printout t ?prompt)
        (bind ?answer (read))
        (if (lexemep ?answer)
            then (bind ?answer (lowcase ?answer))
        )
    )
    ?answer
)

(deffunction recommend-hero (?hero-name)
    (printout t crlf "The best hero for you would be:" crlf ?hero-name crlf)
    (exit)
)

(defrule get-skill
    ?run-flag <- (get skill)
    =>
    (send ?*User* put-skill (read-input "How much experience do you have in first person shooters? Enter low, medium, or high. " low medium high)) ;Store input into ?*User* after it's read and validated by read-input
    (retract ?run-flag)
)

(defrule get-aim
    ?run-flag <- (get aim)
    =>
    (send ?*User* put-aim (read-input "How good are you at aiming? If you are not experienced in aiming, you can determine how good you'll be by how comfortable and fast you are with a mouse. Enter low, medium, or high. " low medium high))
    (retract ?run-flag)
)

(defrule get-aiming_preference
    ?run-flag <- (get aiming_preference)
    =>
    (send ?*User* put-aiming_preference (read-input "What kind of aiming are you better at? Enter flicking (aim single shots quickly) or tracking (continuously keep your crosshair on a moving target). " flicking tracking)) ;Store input into ?*User*
    (retract ?run-flag)
)

(defrule get-reaction_time
    ?run-flag <- (get reaction_time)
    =>
    (send ?*User* put-reaction_time (read-input "How fast is your reaction time? Enter low (slow), medium, or high (fast). " low medium high)) ;Store input into ?*User*
    (retract ?run-flag)
)

(defrule get-wits
    ?run-flag <- (get wits)
    =>
    (send ?*User* put-wits (read-input "How are you at thinking on your feet and making good decisions in the moment? Enter low, medium, or high. " low medium high)) ;Store input into ?*User*
    (retract ?run-flag)
)

(defrule get-weapon_preference
    ?run-flag <- (get weapon_preference)
    =>
    (send ?*User* put-weapon_preference (read-input "Do you prefer guns that hit whatever you're pointing at when you pull the trigger, or projectile weapons like rockets or a bow and arrows? Enter hitscan for guns and projectile for projectiles. " hitscan projectile)) ;Store input into ?*User*
    (retract ?run-flag)
)

(defrule get-teamwork
    ?run-flag <- (get teamwork)
    =>
    (send ?*User* put-teamwork (read-input "How much do you like working with and relying on a team? Enter low (independent), medium, or high (cooperative). " low medium high)) ;Store input into ?*User*
    (retract ?run-flag)
)

;;;;;;;;;;;;;;;;;;;;;;;;
;;Recommendation rules;;
;;;;;;;;;;;;;;;;;;;;;;;;

    ;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;Section- Low Skill;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;

;1. If the player has low skill, ask them how cooperative they are
(defrule new-player
    (object (is-a PLAYER) (skill low))
    =>
    (assert (get teamwork))
)

;2. If the player has low skill and dislikes teamwork, recommend Reaper
(defrule bad-independent
    (object (is-a PLAYER) (skill low) (teamwork low))
    =>
    (recommend-hero Reaper)
)

;3. If the player is bad and likes a medium amount of cooperation, ask for aiming preference
(defrule bad-medteam
    (object (is-a PLAYER) (skill low) (teamwork medium))
    =>
    (assert (get aiming_preference))
)

;4. If the player is bad, prefers medium teamwork, and likes flicking, ask how their aim is
(defrule bad-medteam-flick
    (object (is-a PLAYER) (skill low) (teamwork medium) (aiming_preference flicking))
    =>
    (assert (get aim))
)

;5. If the player is bad, prefers medium teamwork, likes flicking, and isn't good at aiming
(defrule bad-medteam-flick-badaim
    (object (is-a PLAYER) (skill low) (teamwork medium) (aiming_preference flicking) (aim low|medium))
    =>
    (recommend-hero Torbjorn)
)

;6. If the player is bad, prefers medium teamwork, likes flicking, and is good at aiming, recommend Pharah
(defrule bad-medteam-flick-goodaim
    (object (is-a PLAYER) (skill low) (teamwork medium) (aiming_preference flicking) (aim high))
    =>
    (recommend-hero Pharah)
)

;7. If the player is bad, prefers medium teamwork, and likes tracking, ask them how their aim is
(defrule bad-medteam-track
    (object (is-a PLAYER) (skill low) (teamwork medium) (aiming_preference tracking))
    =>
    (assert (get aim))
)

;8. If the player is bad, prefers medium teamwork, likes tracking, and has bad aim, ask them how their wits are
(defrule bad-medteam-track-badaim
    (object (is-a PLAYER) (skill low) (teamwork medium) (aiming_preference tracking) (aim low))
    =>
    (assert (get wits))
)

;9. If the player is bad, prefers medium teamwork, likes tracking, has bad aim, and is bad under pressure, recommend sym
(defrule bad-medteam-track-badaim-badwits
    (object (is-a PLAYER) (skill low) (teamwork medium) (aiming_preference tracking) (aim low) (wits low))
    =>
    (recommend-hero Symmetra)
)

;10. If the player is bad, prefers medium teamwork, likes tracking, has bad aim, and can think on their feet, recommend Winston
(defrule bad-medteam-track-badaim-goodwits
    (object (is-a PLAYER) (skill low) (teamwork medium) (aiming_preference tracking) (aim low) (wits medium|high))
    =>
    (recommend-hero Winston)
)

;11. If the player is bad, prefers medium teamwork, likes tracking, and has good aim, recommend Bastion
(defrule bad-medteam-track-goodaim
    (object (is-a PLAYER) (skill low) (teamwork medium) (aiming_preference tracking) (aim high))
    =>
    (recommend-hero Bastion)
)

    ;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;Section- Med Skill;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;

;12. If the player is ok, ask them for their preferred weapon type
(defrule ok-player
    (object (is-a player) (skill medium))
    =>
    (assert (get weapon_preference))
)

;13. If the player is ok and likes hitscan, ask them how cooperative they are
(defrule ok-hitscan
    (object (is-a PLAYER) (skill medium) (weapon_preference hitscan))
    =>
    (assert (get teamwork))
)

;14. If the player is ok, likes hitscan, and is cooperative, then recommend Zarya
(defrule ok-hitscan-cooperative
    (object (is-a PLAYER) (skill medium) (weapon_preference hitscan) (teamwork high))
    =>
    (recommend-hero Zarya)
)

;15. If the player is ok, likes hitscan, and is somewhat cooperative, ask them for aiming preference
(defrule ok-hitscan-medteam
    (object (is-a PLAYER) (skill medium) (weapon_preference hitscan) (teamwork medium))
    =>
    (assert (get aiming_preference))
)

;16. If the player is ok, likes hitscan, is somewhat cooperative, and likes tracking, ask for aiming ability
(defrule ok-hitscan-medteam-track
    (object (is-a PLAYER) (skill medium) (weapon_preference hitscan) (teamwork medium) (aiming_preference tracking))
    =>
    (assert (get aim))
)

;17. If the player is ok, likes hitscan, is somewhat cooperative, likes tracking, and is bad at aiming, recommend Winston
(defrule ok-hitscan-medteam-track-badaim
    (object (is-a PLAYER) (skill medium) (weapon_preference hitscan) (teamwork medium) (aiming_preference tracking) (aim low))
    =>
    (recommend-hero Winston)
)

;18. If the player is ok, likes hitscan, is somewhat cooperative, likes tracking, and is decent at aiming, recommend Soldier
(defrule ok-hitscan-medteam-track-goodaim
    (object (is-a PLAYER) (skill medium) (weapon_preference hitscan) (teamwork medium) (aiming_preference tracking) (aim medium|high))
    =>
    (recommend-hero Soldier76)
)

;19. If the player is ok, likes hitscan, is somewhat cooperative, and likes flicking, recommend McCree
(defrule ok-hitscan-medteam-flick
    (object (is-a PLAYER) (skill medium) (weapon_preference hitscan) (teamwork medium) (aiming_preference flicking))
    =>
    (recommend-hero McCree)
)

;20. If the player is ok, likes hitscan, and is very cooperative, recommend Bastion
(defrule ok-hitscan-cooperative
    (object (is-a PLAYER) (skill medium) (weapon_preference hitscan) (teamwork high))
    =>
    (recommend-hero Bastion)
)

;21. If the player is ok and likes projectiles, ask for aim preference
(defrule ok-projectile
    (object (is-a PLAYER) (skill medium) (weapon_preference projectile))
    =>
    (assert (get aiming_preference))
)

;22. If the player is ok, likes projectiles, and likes tracking, ask for teamwork
(defrule ok-projectile-track
    (object (is-a PLAYER) (skill medium) (weapon_preference projectile) (aiming_preference tracking))
    =>
    (assert (get teamwork))
)

;23. If the player is ok, likes projectiles, likes tracking, and is independent or a little cooperative, recommend Mei
(defrule ok-projectile-track-independent
    (object (is-a PLAYER) (skill medium) (weapon_preference projectile) (aiming_preference tracking) (teamwork low|medium))
    =>
    (recommend-hero Mei)
)

;24. If the player is ok, likes projectiles, likes tracking, and is very cooperative, recommend Orisa
(defrule ok-projectile-track-cooperative
    (object (is-a PLAYER) (skill medium) (weapon_preference projectile) (aiming_preference tracking) (teamwork high))
    =>
    (recommend-hero Orisa)
)

;25. If the player is ok, likes projectiles, and likes flicking, ask for aim
(defrule ok-projectile-flick
    (object (is-a PLAYER) (skill medium) (weapon_preference projectile) (aiming_preference flicking))
    =>
    (assert (get aim))
)

;26. If the player is ok, likes projectiles, likes flicking, and has bad aim, recommend Junkrat
(defrule ok-projectile-flick-badaim
    (object (is-a PLAYER) (skill medium) (weapon_preference projectile) (aiming_preference flicking) (aim low))
    =>
    (recommend-hero Junkrat)
)

;27. If the player is ok, likes projectiles, likes flicking, and has decent aim, recommend Pharah
(defrule ok-projectile-flick-medaim
    (object (is-a PLAYER) (skill medium) (weapon_preference projectile) (aiming_preference flicking) (aim medium))
    =>
    (recommend-hero Pharah)
)

;28. If the player is ok, likes projectiles, likes flicking, and has good aim, recommend Hanzo
(defrule ok-projectile-flick-goodaim
    (object (is-a PLAYER) (skill medium) (weapon_preference projectile) (aiming_preference flicking) (aim high))
    =>
    (recommend-hero Hanzo)
)

    ;;;;;;;;;;;;;;;;;;;;;;;;
    ;;Section - High Skill;;
    ;;;;;;;;;;;;;;;;;;;;;;;;

;29. If the player is good, ask them how cooperative they are
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;30. If the player is good and cooperative, ask them their preferred weapon type
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;31. If the player is good, cooperative, and likes hitscan, recommend Ana
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;32. If the player is good, cooperative, and likes projectiles, recommend Zenyatta
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;33. If the player is good and somewhat cooperative, ask their aiming preference
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;34. If the player is good, somewhat cooperative, and likes flicking, recommend McCree
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;35. If the player is good, somewhat cooperative, and likes tracking, ask them their weapon preference
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;36. If the player is good, somewhat cooperative, likes tracking, and likes hitscan, recommend Soldier
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;37. If the player is good, somewhat cooperative, likes tracking, and likes projectiles, recommend Mei
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;38. If the player is good and independent, ask their weapon preference
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;39. If the player is good, independent, and likes hitscan, ask their reaction time
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;40. If the player is good, independent, likes hitscan, and has decent/good reaction time, recommend Tracer
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;41. If the player is good, independent, likes hitscan, and has bad reaction time, recommend Widow
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;42. If the player is good, independent, and likes projectiles, ask their reaction time
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;43. If the player is good, independent, likes projectiles, and has bad reaction time, recommend Hanzo
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;44. If the player is good, independent, likes projectiles, and had decent reactin time, recommend Doomfist
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)

;45. If the player is good, independent, likes projectiles, and has good reaction time, recommend Genji
(defrule good-
    (object (is-a PLAYER) (skill high) ())
    =>
    ()
)
