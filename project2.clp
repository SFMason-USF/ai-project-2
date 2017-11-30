;Overwatch Hero Recommendation System
;Author:        Spenser Mason
;Description:   This expert system will recommend a hero to start out with for newcomers to the video game Overwatch.
;Usage:         Load this file into CLIPS, then call (reset) and then (run).

;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Classes ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

;Defines a hero; one instance will be selected as the output value
(defclass HERO
    (is-a USER)
    (role concrete)
    (slot strategy)
    (slot mechanics)
    (slot attack_type)
    (slot attack_speed)
    (slot mobility)
    (slot teamwork))

(defmessage-handler HERO difficulty-rating
    ;Get the difficulty of this hero based on its strategy and mechanics
    primary ;message type
    () ;parameters

    ;convert ?self:strategy to a numerical rating
    (switch ?self:strategy
        (case low then (bind ?strategy 1))
        (case medium then (bind ?strategy 2))
        (case high then (bind ?strategy 3))
    )
    ;convert ?self:mechanics to a numerical rating
    (switch ?self:mechanics
        (case low then (bind ?mechanics 1))
        (case medium then (bind ?mechanics 2))
        (case high then (bind ?mechanics 3))
    )
    ;Reutrn the sum of the numerical difficulty ratings
    (+ ?strategy ?mechanics)
)

(defmessage-handler HERO difficulty-easy
    ;Return true if this hero has low for both strategy and mechanics, or low for one and medium for the other
    primary
    ()
    (<= (send ?self difficulty-rating) 3)
)

(defmessage-handler HERO difficulty-medium
    ;Return true if this hero is medium in strategy or mechanics
    primary
    ()
    (and
        (<= (send ?self difficulty-rating) 5)
        (>= (send ?self difficulty-rating) 3)
    )
)

(defmessage-handler HERO difficulty-hard
    ;Return true if this hero is hard in strategy or mechanics, and at least medium in the other
    primary
    ()
    (>= (send ?self difficulty-rating) 5)
)

;Filter out this hero
(defmessage-handler HERO filter-out
    primary
    ()
    =>
    (assert (exclude (instance-name ?self)))
)

;Defines a player; fields in this will be used to determine which hero is best for this player
(defclass PLAYER
    (is-a USER)
    (role concrete)
    (slot skill)
    (slot aim)
    (slot aiming_preference)
    (slot reaction_time)
    (slot wits)
    (slot weapon_preference)
    (slot teamwork))

;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Instances ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

(defglobal ?*User* = (make-instance User of PLAYER)) ;The user
(defglobal ?*Questions-Asked* = 0)

(definstances HERO-INSTANCES
    (Doomfist of HERO
        (strategy medium)
        (mechanics high)
        (attack_type projectile)
        (attack_speed semi_auto)
        (mobility high)
        (teamwork low)
    )
    (Genji of HERO
        (strategy high)
        (mechanics high)
        (attack_type projectile)
        (attack_speed semi_auto)
        (mobility high)
        (teamwork low)
    )
    (McCree of HERO
        (strategy low)
        (mechanics high)
        (attack_type hitscan)
        (attack_speed semi_auto)
        (mobility low)
        (teamwork medium)
    )
    (Pharah of HERO
        (strategy low)
        (mechanics medium)
        (attack_type projectile)
        (attack_speed semi_auto)
        (mobility high)
        (teamwork medium)
    )
    (Reaper of HERO
        (strategy medium)
        (mechanics low)
        (attack_type hitscan)
        (attack_speed semi_auto)
        (mobility medium)
        (teamwork low)
    )
    (Soldier76 of HERO
        (strategy low)
        (mechanics medium)
        (attack_type hitscan)
        (attack_speed auto)
        (mobility medium)
        (teamwork medium)
    )
    (Sombra of HERO
        (strategy high)
        (mechanics medium)
        (attack_type hitscan)
        (attack_speed auto)
        (mobility medium)
        (teamwork medium)
    )
    (Tracer of HERO
        (strategy low)
        (mechanics high)
        (attack_type hitscan)
        (attack_speed auto)
        (mobility high)
        (teamwork low)
    )
    (Bastion of HERO
        (strategy medium)
        (mechanics low)
        (attack_type hitscan)
        (attack_speed auto)
        (mobility low)
        (teamwork high)
    )
    (Hanzo of HERO
        (strategy low)
        (mechanics high)
        (attack_type projectile)
        (attack_speed semi_auto)
        (mobility medium)
        (teamwork low)
    )
    (Junkrat of HERO
        (strategy medium)
        (mechanics medium)
        (attack_type projectile)
        (attack_speed semi_auto)
        (mobility high)
        (teamwork low)
    )
    (Mei of HERO
        (strategy high)
        (mechanics medium)
        (attack_type projectile)
        (attack_speed semi_auto)
        (mobility low)
        (teamwork medium)
    )
    (Torbjorn of HERO
        (strategy medium)
        (mechanics low)
        (attack_type projectile)
        (attack_speed semi_auto)
        (mobility low)
        (teamwork medium)
    )
    (Widowmaker of HERO
        (strategy low)
        (mechanics high)
        (attack_type hitscan)
        (attack_speed semi_auto)
        (mobility medium)
        (teamwork low)
    )
    (D.Va of HERO
        (strategy medium)
        (mechanics low)
        (attack_type hitscan)
        (attack_speed auto)
        (mobility high)
        (teamwork high)
    )
    (Orisa of HERO
        (strategy medium)
        (mechanics medium)
        (attack_type projectile)
        (attack_speed auto)
        (mobility low)
        (teamwork high)
    )
    (Reinhardt of HERO
        (strategy medium)
        (mechanics low)
        (attack_type hitscan)
        (attack_speed semi_auto)
        (mobility medium)
        (teamwork high)
    )
    (Roadhog of HERO
        (strategy low)
        (mechanics low)
        (attack_type projectile)
        (attack_speed semi_auto)
        (mobility low)
        (teamwork medium)
    )
    (Winston of HERO
        (strategy medium)
        (mechanics low)
        (attack_type hitscan)
        (attack_speed auto)
        (mobility high)
        (teamwork medium)
    )
    (Zarya of HERO
        (strategy high)
        (mechanics medium)
        (attack_type hitscan)
        (attack_speed auto)
        (mobility low)
        (teamwork high)
    )
    (Ana of HERO
        (strategy low)
        (mechanics high)
        (attack_type hitscan)
        (attack_speed semi_auto)
        (mobility low)
        (teamwork high)
    )
    (Lucio of HERO
        (strategy low)
        (mechanics low)
        (attack_type projectile)
        (attack_speed auto)
        (mobility medium)
        (teamwork high)
    )
    (Mercy of HERO
        (strategy medium)
        (mechanics low)
        (attack_type projectile)
        (attack_speed auto)
        (mobility medium)
        (teamwork high)
    )
    (Symmetra of HERO
        (strategy medium)
        (mechanics low)
        (attack_type hitscan)
        (attack_speed auto)
        (mobility low)
        (teamwork medium)
    )
    (Zenyatta of HERO
        (strategy low)
        (mechanics high)
        (attack_type projectile)
        (attack_speed semi_auto)
        (mobility low)
        (teamwork high)
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Rules ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

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
        (printout t "Invalid input. " ?prompt)
        (bind ?answer (read))
        (if (lexemep ?answer) then
            (bind ?answer (lowcase ?answer))
        )
    )
    ?answer
)

;Final function. Print the recommended hero and info for that hero to user, then exit
(deffunction recommend-hero (?hero)
    (printout t crlf "The best hero for you would be:" crlf)
    (send ?hero print)
    ;(exit)
)

;Prompt user for skill
(defrule get-skill
    ?run-flag <- (get skill)
    =>
    (bind ?*Questions-Asked (+ ?*Questions-Asked* 1))
    (send ?*User* put-skill (read-input "How much experience do you have in first person shooters? Enter low, medium, or high. " low medium high)) ;Store input into ?*User* after it's read and validated by read-input
    (retract ?run-flag)
)

;Prompt user for aim
(defrule get-aim
    ?run-flag <- (get aim)
    =>
    (bind ?*Questions-Asked (+ ?*Questions-Asked* 1))
    (send ?*User* put-aim (read-input "How good are you at aiming? If you are not experienced in aiming, you can determine how good you'll be by how comfortable and fast you are with a mouse. Enter low, medium, or high. " low medium high))
    (retract ?run-flag)
)

;Prompt user for aiming_preference
(defrule get-aiming_preference
    ?run-flag <- (get aiming_preference)
    =>
    (bind ?*Questions-Asked (+ ?*Questions-Asked* 1))
    (send ?*User* put-aiming_preference (read-input "What kind of aiming are you better at? Enter flicking (aim single shots quickly) or tracking (continuously keep your crosshair on a moving target). " flicking tracking)) ;Store input into ?*User*
    (retract ?run-flag)
)

;Prompt user for reaction_time
(defrule get-reaction_time
    ?run-flag <- (get reaction_time)
    =>
    (bind ?*Questions-Asked (+ ?*Questions-Asked* 1))
    (send ?*User* put-reaction_time (read-input "How fast is your reaction time? Enter low (slow), medium, or high (fast). " low medium high)) ;Store input into ?*User*
    (retract ?run-flag)
)

;Prompt user for wits
(defrule get-wits
    ?run-flag <- (get wits)
    =>
    (bind ?*Questions-Asked (+ ?*Questions-Asked* 1))
    (send ?*User* put-wits (read-input "How are you at thinking on your feet and making good decisions in the moment? Enter low, medium, or high. " low medium high)) ;Store input into ?*User*
    (retract ?run-flag)
)

;Prompt user for weapon_preference
(defrule get-weapon_preference
    ?run-flag <- (get weapon_preference)
    =>
    (bind ?*Questions-Asked (+ ?*Questions-Asked* 1))
    (send ?*User* put-weapon_preference (read-input "Do you prefer guns that hit whatever you're pointing at when you pull the trigger, or projectile weapons like rockets or a bow and arrows? Enter hitscan for guns and projectile for projectiles. " hitscan projectile)) ;Store input into ?*User*
    (retract ?run-flag)
)

;Prompt user for teamwork
(defrule get-teamwork
    ?run-flag <- (get teamwork)
    =>
    (bind ?*Questions-Asked (+ ?*Questions-Asked* 1))
    (send ?*User* put-teamwork (read-input "How much do you like working with and relying on a team? Enter low (independent), medium, or high (cooperative). " low medium high)) ;Store input into ?*User*
    (retract ?run-flag)
)

;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Filters ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

;Filter out heroes that are too hard for the user
(defrule filter-heroes-skill-low
    (object (is-a PLAYER) (skill low))
    ?hero <- (object (is-a HERO))
    =>
    (if (not (send ?hero difficulty-easy)) then
        (send ?hero filter-out)
    )
)

;Filter out heroes that are too hard for the user
(defrule filter-heroes-medium
    (object (is-a PLAYER) (skill medium))
    ?hero <- (object (is-a HERO))
    =>
    (if (send ?hero difficulty-hard) then
        (send ?hero filter-out)
    )
)

;Filter based on weapon preference
(defrule filter-heroes-weapon
    (object (is-a PLAYER) (weapon_preference ~nil))
    ?hero <- (object (is-a HERO))
    =>
    (if (neq (send ?hero get-attack_type) (send ?*User* get-weapon_preference)) then
        (send ?hero filter-out)
    )
)

;Filter out heroes that don't fit the user's aiming preference
(defrule filter-heroes-aiming_preference
    (object (is-a PLAYER) (aiming_preference ~nil))
    ?hero <- (object (is-a HERO))
    =>
    (switch (send ?hero get-attack_speed)
        (case auto then
            ;if the user likes flicking and this is a tracking hero, remove it
            (if (eq (send ?*User* get-aiming_preference) flicking) then
                (send ?hero filter-out)
            )
        )
        (case semi_auto then
            ;if the user likes tracking and this is a flicking hero, remove it
            (if (eq (send ?*User* get-aiming_preference) tracking) then
                (send ?hero filter-out)
            )
        )
    )
)

;Filter out heroes that are too reliant on their teams or not reliant enough
(defrule filter-heroes-teamwork
    ?player <- (object (is-a PLAYER) (teamwork low))
    ?hero <- (object (is-a HERO))
    =>
    (switch (send ?player get-teamwork)
        (case low then
            (if (eq (send ?hero get-teamwork) high) then
                (send ?hero filter-out)
            )
        )
        (case high then
            (if (eq (send ?hero get-teamwork) low) then
                (send ?hero filter-out)
            )
        )
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;
;;Recommendation rules;;
;;;;;;;;;;;;;;;;;;;;;;;;

;If we're down to one hero, recommend him
(defrule make-recommendation
    (test (= (length$ (find-all-instances ((?hero HERO)) (class HERO))) 1)) ;There is only 1 hero left
    =>
    ;Recommend the hero
    (foreach ?hero (find-all-instances ((?hero HERO)) (class HERO))
        (recommend-hero ?hero)
    )
)

;If we've asked all our questions and still can't decide on a hero, tell the user to pick one of the remaining choices
(defrule stumped
    (test (> (length$ (find-all-instances ((?hero HERO)) (class HERO))) 1)) ;There are multiple heroes left
    (test (>= ?*Questions-Asked* 7)) ;All questions asked
    =>
    (printout t "I don't know what to recommend to you. Try one of the following heroes:" crlf)
    (instances)
    ;(exit)
)

;If we have no options for the user's particular attributes, tell them so and exit
(defrule out-of-options
    (test (< (length$ (find-all-instances ((?hero HERO)) (class HERO))) 1)) ;No more options left
    =>
    ;(printout t "I have no idea who you should play. Try again and provide different answers." crlf)
    ;(exit)
)

    ;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;Section- Low Skill;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;

;1. If the player has low skill, ask them how cooperative they are
(defrule new-player
    (object (is-a PLAYER) (skill low))
    =>
    (assert (get teamwork))
)

;2. If the player has low skill and dislikes teamwork, recommend [Reaper]
(defrule bad-independent
    (object (is-a PLAYER) (skill low) (teamwork low))
    =>
    (recommend-hero [Reaper])
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
    (recommend-hero [Torbjorn])
)

;6. If the player is bad, prefers medium teamwork, likes flicking, and is good at aiming, recommend [Pharah]
(defrule bad-medteam-flick-goodaim
    (object (is-a PLAYER) (skill low) (teamwork medium) (aiming_preference flicking) (aim high))
    =>
    (recommend-hero [Pharah])
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
    (recommend-hero [Symmetra])
)

;10. If the player is bad, prefers medium teamwork, likes tracking, has bad aim, and can think on their feet, recommend [Winston]
(defrule bad-medteam-track-badaim-goodwits
    (object (is-a PLAYER) (skill low) (teamwork medium) (aiming_preference tracking) (aim low) (wits medium|high))
    =>
    (recommend-hero [Winston])
)

;11. If the player is bad, prefers medium teamwork, likes tracking, and has good aim, recommend [Bastion]
(defrule bad-medteam-track-goodaim
    (object (is-a PLAYER) (skill low) (teamwork medium) (aiming_preference tracking) (aim high))
    =>
    (recommend-hero [Bastion])
)

    ;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;Section- Med Skill;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;

;12. If the player is ok, ask them for their preferred weapon type
(defrule ok-player
    (object (is-a PLAYER) (skill medium))
    =>
    (assert (get weapon_preference))
)

;13. If the player is ok and likes hitscan, ask them how cooperative they are
(defrule ok-hitscan
    (object (is-a PLAYER) (skill medium) (weapon_preference hitscan))
    =>
    (assert (get teamwork))
)

;14. If the player is ok, likes hitscan, and is cooperative, then recommend [Zarya]
(defrule ok-hitscan-cooperative
    (object (is-a PLAYER) (skill medium) (weapon_preference hitscan) (teamwork high))
    =>
    (recommend-hero [Zarya])
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

;17. If the player is ok, likes hitscan, is somewhat cooperative, likes tracking, and is bad at aiming, recommend [Winston]
(defrule ok-hitscan-medteam-track-badaim
    (object (is-a PLAYER) (skill medium) (weapon_preference hitscan) (teamwork medium) (aiming_preference tracking) (aim low))
    =>
    (recommend-hero [Winston])
)

;18. If the player is ok, likes hitscan, is somewhat cooperative, likes tracking, and is decent at aiming, recommend Soldier
(defrule ok-hitscan-medteam-track-goodaim
    (object (is-a PLAYER) (skill medium) (weapon_preference hitscan) (teamwork medium) (aiming_preference tracking) (aim medium|high))
    =>
    (recommend-hero [Soldier76])
)

;19. If the player is ok, likes hitscan, is somewhat cooperative, and likes flicking, recommend [McCree]
(defrule ok-hitscan-medteam-flick
    (object (is-a PLAYER) (skill medium) (weapon_preference hitscan) (teamwork medium) (aiming_preference flicking))
    =>
    (recommend-hero [McCree])
)

;20. If the player is ok, likes hitscan, and is very cooperative, recommend [Bastion] -dupe rule
;(defrule ok-hitscan-cooperative
;    (object (is-a PLAYER) (skill medium) (weapon_preference hitscan) (teamwork high))
;    =>
;    (recommend-hero [Bastion])
;)

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

;23. If the player is ok, likes projectiles, likes tracking, and is independent or a little cooperative, recommend [Mei]
(defrule ok-projectile-track-independent
    (object (is-a PLAYER) (skill medium) (weapon_preference projectile) (aiming_preference tracking) (teamwork low|medium))
    =>
    (recommend-hero [Mei])
)

;24. If the player is ok, likes projectiles, likes tracking, and is very cooperative, recommend [Orisa]
(defrule ok-projectile-track-cooperative
    (object (is-a PLAYER) (skill medium) (weapon_preference projectile) (aiming_preference tracking) (teamwork high))
    =>
    (recommend-hero [Orisa])
)

;25. If the player is ok, likes projectiles, and likes flicking, ask for aim
(defrule ok-projectile-flick
    (object (is-a PLAYER) (skill medium) (weapon_preference projectile) (aiming_preference flicking))
    =>
    (assert (get aim))
)

;26. If the player is ok, likes projectiles, likes flicking, and has bad aim, recommend [Junkrat]
(defrule ok-projectile-flick-badaim
    (object (is-a PLAYER) (skill medium) (weapon_preference projectile) (aiming_preference flicking) (aim low))
    =>
    (recommend-hero [Junkrat])
)

;27. If the player is ok, likes projectiles, likes flicking, and has decent aim, recommend [Pharah]
(defrule ok-projectile-flick-medaim
    (object (is-a PLAYER) (skill medium) (weapon_preference projectile) (aiming_preference flicking) (aim medium))
    =>
    (recommend-hero [Pharah])
)

;28. If the player is ok, likes projectiles, likes flicking, and has good aim, recommend [Hanzo]
(defrule ok-projectile-flick-goodaim
    (object (is-a PLAYER) (skill medium) (weapon_preference projectile) (aiming_preference flicking) (aim high))
    =>
    (recommend-hero [Hanzo])
)

    ;;;;;;;;;;;;;;;;;;;;;;;;
    ;;Section - High Skill;;
    ;;;;;;;;;;;;;;;;;;;;;;;;

;29. If the player is good, ask them how cooperative they are
(defrule good-player
    (object (is-a PLAYER) (skill high))
    =>
    (assert (get teamwork))
)

;30. If the player is good and cooperative, ask them their preferred weapon type
(defrule good-cooperative
    (object (is-a PLAYER) (skill high) (teamwork high))
    =>
    (assert (get weapon_preference))
)

;31. If the player is good, cooperative, and likes hitscan, recommend [Ana]
(defrule good-cooperative-hitscan
    (object (is-a PLAYER) (skill high) (teamwork high) (weapon_preference hitscan))
    =>
    (recommend-hero [Ana])
)

;32. If the player is good, cooperative, and likes projectiles, recommend [Zenyatta]
(defrule good-cooperative-projectile
    (object (is-a PLAYER) (skill high) (teamwork high) (weapon_preference projectile))
    =>
    (recommend-hero [Zenyatta])
)

;33. If the player is good and somewhat cooperative, ask their aiming preference
(defrule good-medteam
    (object (is-a PLAYER) (skill high) (teamwork medium))
    =>
    (assert (get aiming_preference))
)

;34. If the player is good, somewhat cooperative, and likes flicking, recommend [McCree]
(defrule good-medteam-flick
    (object (is-a PLAYER) (skill high) (teamwork medium) (aiming_preference flicking))
    =>
    (recommend-hero [McCree])
)

;35. If the player is good, somewhat cooperative, and likes tracking, ask them their weapon preference
(defrule good-medteam-track
    (object (is-a PLAYER) (skill high) (teamwork medium) (aiming_preference tracking))
    =>
    (assert (get weapon_preference))
)

;36. If the player is good, somewhat cooperative, likes tracking, and likes hitscan, recommend Soldier
(defrule good-medteam-track-hitscan
    (object (is-a PLAYER) (skill high) (teamwork medium) (aiming_preference tracking) (weapon_preference hitscan))
    =>
    (recommend-hero [Soldier76])
)

;37. If the player is good, somewhat cooperative, likes tracking, and likes projectiles, recommend [Mei]
(defrule good-medteam-track-projectile
    (object (is-a PLAYER) (skill high) (teamwork medium) (aiming_preference tracking) (weapon_preference projectile))
    =>
    (recommend-hero [Mei])
)

;38. If the player is good and independent, ask their weapon preference
(defrule good-independent
    (object (is-a PLAYER) (skill high) (teamwork low))
    =>
    (assert (get weapon_preference))
)

;39. If the player is good, independent, and likes hitscan, ask their reaction time
(defrule good-independent-hitscan
    (object (is-a PLAYER) (skill high) (teamwork low) (weapon_preference hitscan))
    =>
    (assert (get reaction_time))
)

;40. If the player is good, independent, likes hitscan, and has decent/good reaction time, recommend [Tracer]
(defrule good-independent-hitscan-quick
    (object (is-a PLAYER) (skill high) (teamwork low) (weapon_preference hitscan) (reaction_time medium|high))
    =>
    (recommend-hero [Tracer])
)

;41. If the player is good, independent, likes hitscan, and has bad reaction time, recommend [Widowmaker]
(defrule good-independent-hitscan-slow
    (object (is-a PLAYER) (skill high) (teamwork low) (weapon_preference hitscan) (reaction_time low))
    =>
    (recommend-hero [Widowmaker])
)

;42. If the player is good, independent, and likes projectiles, ask their reaction time
(defrule good-independent-projectile
    (object (is-a PLAYER) (skill high) (teamwork low) (weapon_preference projectile))
    =>
    (assert (get reaction_time))
)

;43. If the player is good, independent, likes projectiles, and has bad reaction time, recommend [Hanzo]
(defrule good-independent-projectile-slow
    (object (is-a PLAYER) (skill high) (teamwork low) (weapon_preference projectile) (reaction_time low))
    =>
    (recommend-hero [Hanzo])
)

;44. If the player is good, independent, likes projectiles, and had decent reaction time, recommend [Doomfist]
(defrule good-independent-projectile-avgspeed
    (object (is-a PLAYER) (skill high) (teamwork low) (weapon_preference projectile) (reaction_time medium))
    =>
    (recommend-hero [Doomfist])
)

;45. If the player is good, independent, likes projectiles, and has good reaction time, recommend [Genji]
(defrule good-independent-projectile-quick
    (object (is-a PLAYER) (skill high) (teamwork low) (weapon_preference projectile) (reaction_time high))
    =>
    (recommend-hero [Genji])
)

;(reset) ;Prepare ourselves...

;(printout t crlf crlf crlf crlf crlf)

;(run) ;And so it begins.
