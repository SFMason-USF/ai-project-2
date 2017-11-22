def defrule(slot, prompt, valid_values):
    '''Generate a CLIPS defrule for getting user input for a slot.
    {str} slot - The name of the slot of the PLAYER class to generate input for.
    {str} prompt - The message to prompt the user with.
    {str} valid_values - A space-separated list of correct user responses.'''
    return '''(defrule get-{0}
    ?run-flag <- (get {0})
    =>
    (send ?*User* put-{0} (read-input "{1}" {2})) ;Store input into ?*User*
    (retract ?run-flag)
)'''.format(slot, prompt, valid_values)


with open('genrules.txt', 'w+') as file:
    file.write(defrule('aiming_preference', 'What kind of aiming are you better at? Enter flicking (aim single shots quickly) or tracking (continuously keep your crosshair on a moving target). ', 'flicking tracking'))
    file.write(defrule('reaction_time',
                       'How fast is your reaction time? Enter low (slow), medium, or high (fast). ', 'low medium high'))
    file.write(defrule('wits', 'How are you at thinking on your feet and making good decisions in the moment? Enter low, medium, or high. ', 'low medium high'))
    file.write(defrule('weapon_preference', '''Do you prefer guns that hit whatever you're pointing at when you pull the trigger, or projectile weapons like rockets or a bow and arrows? Enter hitscan for guns and projectile for projectiles. ''', 'hitscan projectile'))
    file.write(defrule('teamwork', 'How much do you like working with and relying on a team? Enter low (independent), medium, or high (cooperative). ', 'low medium high'))
