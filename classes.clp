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
