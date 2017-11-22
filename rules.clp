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
