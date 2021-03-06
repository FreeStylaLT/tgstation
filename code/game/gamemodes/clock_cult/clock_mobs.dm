/mob/living/simple_animal/hostile/anima_fragment //Anima fragment: Low health but high melee power. Created by inserting a soul vessel into an empty fragment.
	name = "anima fragment"
	desc = "An ominous humanoid shell with a spinning cogwheel as its head, lifted by a jet of blazing red flame."
	faction = list("ratvar")
	icon = 'icons/mob/clockwork_mobs.dmi'
	icon_state = "anime_fragment"
	health = 75 //Glass cannon
	maxHealth = 75
	wander = FALSE
	minbodytemp = 0
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0) //Robotic
	healable = FALSE
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "crushes"
	attack_sound = 'sound/magic/clockwork/anima_fragment_attack.ogg'
	var/playstyle_string = "<span class='heavy_brass'>You are an anima fragment</span><b>, a clockwork creation of Ratvar. As a fragment, you are weak but possess powerful melee capabilities \
	in addition to being immune to extreme temperatures and pressures. Your goal is to serve the Justiciar and his servants in any way you can. You yourself are one of these servants, and will \
	be able to utilize anything they can, assuming it doesn't require opposable thumbs.</b>"

/mob/living/simple_animal/hostile/anima_fragment/New()
	..()
	if(prob(1))
		name = "anime fragment"
		real_name = name
		desc = "I-it's not like I want to show you the light of the Justiciar or anything, B-BAKA!"

/mob/living/simple_animal/hostile/anima_fragment/death(gibbed)
	..(TRUE)
	visible_message("<span class='warning'>[src]'s flame jets cut out as it falls to the floor with a tremendous crash. A cube of metal tumbles out, whirring and sputtering.</span>", \
	"<span class='userdanger'>Your gears seize up. Your flame jets flicker. Your soul vessel belches smoke as you helplessly crash down.</span>")
	playsound(src, 'sound/magic/clockwork/anima_fragment_death.ogg', 100, 1)
	new/obj/item/clockwork/component/replicant_alloy/smashed_anima_fragment(get_turf(src))
	new/obj/item/device/mmi/posibrain/soul_vessel(get_turf(src)) //Notice the lack of transfer - it's a standard soul vessel with no mind in it!
	qdel(src)
	return 1



/mob/living/simple_animal/hostile/clockwork_marauder //Clockwork marauder: Slow but with high damage, resides inside of a servant. Created via the Memory Allocation scripture.
	name = "clockwork marauder"
	desc = "A stalwart apparition of a soldier, blazing with crimson flames. It's armed with a gladius and shield."
	icon = 'icons/mob/clockwork_mobs.dmi'
	icon_state = "clockwork_marauder"
	health = 25 //Health is governed by fatigue, but can be directly reduced by the presence of certain objects
	maxHealth = 25
	wander = FALSE
	speed = 1
	minbodytemp = 0
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	healable = FALSE
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "slashes"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	var/true_name = "Meme Master 69" //Required to call forth the marauder
	var/list/possible_true_names = list("Xaven", "Melange", "Ravan", "Kel", "Rama", "Geke", "Peris", "Vestra", "Skiwa") //All fairly short and easy to pronounce
	var/fatigue = 0 //Essentially what determines the marauder's power
	var/fatigue_recall_threshold = 100 //In variable form due to changed effects once Ratvar awakens
	var/mob/living/host //The mob that the marauder is living inside of
	var/recovering = FALSE //If the marauder is recovering from a large amount of fatigue
	var/playstyle_string = "<span class='heavy_brass'>You are a clockwork marauder</span><b>, a living extension of Ratvar's will. As a marauder, you are slow but sturdy and decently powerful \
	in addition to being immune to extreme temperatures and pressures. Your primary goal is to serve the creature that you are now a part of. You can use the Linked Minds ability in your \
	Marauder tab to communicate silently with your master, but can only exit if your master calls your true name.\n\n\
	\
	Taking damage and remaining outside of your master will cause <i>fatigue</i>, which hinders your movement speed and attacks, in addition to forcing you back into your master if it grows \
	too high. As a final note, you should probably avoid harming any fellow servants of Ratvar.</span>"

/mob/living/simple_animal/hostile/clockwork_marauder/New()
	..()
	true_name = pick(possible_true_names)

/mob/living/simple_animal/hostile/clockwork_marauder/Life()
	..()
	if(is_in_host())
		fatigue = max(0, fatigue - 2) //Doesn't use adjust_fatigue in order to bypass the Ratvar edgecase
		if(!fatigue && recovering)
			src << "<span class='userdanger'>Your strength has returned. You can once again come forward!</span>"
			host << "<span class='userdanger'>Your marauder is now strong enough to come forward again!</span>"
			recovering = FALSE
	else
		if(ratvar_awakens) //If Ratvar is alive, marauders both don't take fatigue loss and move at sanic speeds
			speed = -1
			melee_damage_lower = 30
			melee_damage_upper = 30
			attacktext = "devastates"
		else
			if(host)
				switch(get_dist(src, host))
					if(1 to 5)
						adjust_fatigue(1)
					if(5 to INFINITY)
						adjust_fatigue(rand(10, 20))
						src << "<span class='userdanger'>You're too far from your host and rapidly taking fatigue damage!</span>"
			switch(fatigue)
				if(0 to 1) //Bonuses to speed and damage at normal fatigue levels
					speed = 0
					melee_damage_lower = 15
					melee_damage_upper = 15
					attacktext = "viciously slashes"
				if(1 to 25)
					speed = initial(speed)
					melee_damage_lower = initial(melee_damage_lower)
					melee_damage_upper = initial(melee_damage_upper)
					attacktext = initial(attacktext)
				if(25 to 50) //Damage decrease, but not speed
					melee_damage_lower = 7
					melee_damage_upper = 7
					attacktext = "lightly slashes"
				if(50 to 75) //Speed decrease
					speed = 2
				if(75 to 99) //Massive speed decrease and weak melee attacks
					speed = 3
					melee_damage_lower = 5
					melee_damage_upper = 5
					attacktext = "weakly slashes"
				if(99 to 100)
					src << "<span class='userdanger'>The fatigue becomes too much!</span>"
					if(host)
						src << "<span class='userdanger'>You retreat to [host] - you will have to wait before being deployed again.</span>"
						host << "<span class='userdanger'>[true_name] is too fatigued to fight - you will need to wait until they are strong enough.</span>"
						recovering = TRUE
						return_to_host()
					else
						qdel(src) //Shouldn't ever happen, but...

/mob/living/simple_animal/hostile/clockwork_marauder/death(gibbed)
	..(TRUE)
	emerge_from_host()
	visible_message("<span class='warning'>[src]'s equipment clatters lifelessly to the ground as the red flames within dissipate.</span>", \
	"<span class='userdanger'>Your equipment falls away. You feel a moment of confusion before your fragile form is annihilated.</span>")
	playsound(src, 'sound/magic/clockwork/anima_fragment_death.ogg', 100, 1)
	new/obj/item/clockwork/component/replicant_alloy/fallen_armor(get_turf(src))
	qdel(src)
	return 1

/mob/living/simple_animal/hostile/clockwork_marauder/Stat()
	..()
	if(statpanel("Status"))
		stat(null, "Fatigue: [fatigue]/[fatigue_recall_threshold]")
		stat(null, "Current True Name: [true_name]")
		stat(null, "Host: [host ? host : "NONE"]")
		stat(null, "You are [recovering ? "too weak" : "able"] to deploy!")

/mob/living/simple_animal/hostile/clockwork_marauder/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans)
	..()
	if(findtext(message, true_name) && is_in_host()) //Called or revealed by hearing their true name
		if(speaker == host)
			emerge_from_host()
		else
			src << "<span class='warning'><b>You hear your true name and partially emerge before you can stop yourself!</b></span>"
			host.visible_message("<span class='warning'>[host]'s skin flashes crimson!</span>", "<span class='warning'><b>Your marauder instinctively reacts to its true name!</b></span>")

/mob/living/simple_animal/hostile/clockwork_marauder/say(message)
	if(is_in_host())
		message = "<span class='heavy_brass'>Marauder [true_name]:</span> <span class='brass'>\"[message]\"</span>" //Automatic linked minds
		src << message
		host << message
		return 1
	..()

/mob/living/simple_animal/hostile/clockwork_marauder/adjustHealth(amount) //Fatigue damage
	for(var/mob/living/L in range(1, src))
		if(L.null_rod_check()) //Null rods allow direct damage
			src << "<span class='userdanger'>The power of a holy artifact bypasses your armor and wounds you directly!</span>"
			return ..()
	return adjust_fatigue(amount)

/mob/living/simple_animal/hostile/clockwork_marauder/AttackingTarget()
	if(is_in_host())
		return 0
	..()

/mob/living/simple_animal/hostile/clockwork_marauder/proc/adjust_fatigue(amount) //Adds or removes the given amount of fatigue
	if(!ratvar_awakens)
		fatigue = max(0, min(fatigue + amount, fatigue_recall_threshold))
		Life() //Immediately runs a life tick to check for recalling
	else
		amount = 0
	return amount

/mob/living/simple_animal/hostile/clockwork_marauder/verb/linked_minds() //Discreet communications between a marauder and its host
	set name = "Linked Minds"
	set desc = "Silently communicates with your master."
	set category = "Marauder"

	if(!host) //Verb isn't removed because they might gain one... somehow
		usr << "<span class='warning'>You don't have a host!</span>"
		return 0
	var/message = stripped_input(usr, "Enter a message to tell your host.", "Telepathy")// as null|anything
	if(!usr || !message)
		return 0
	if(!host)
		usr << "<span class='warning'>Your host seems to have vanished!</span>"
		return 0
	message = "<span class='heavy_brass'>Marauder [true_name]:</span> <span class='brass'>\"[message]\"</span>" //Processed output
	usr << message
	host << message
	return 1

/mob/living/proc/talk_with_marauder() //See above - this is the host version
	set name = "Linked Minds"
	set desc = "Silently communicates with your marauder."
	set category = "Clockwork"
	var/mob/living/simple_animal/hostile/clockwork_marauder/marauder

	if(!marauder)
		for(var/mob/living/simple_animal/hostile/clockwork_marauder/C in living_mob_list)
			if(C.host == src)
				marauder = C
		if(!marauder) //Double-check afterwards
			src << "<span class='warning'>You aren't hosting any marauders!</span>"
			verbs -= src
			return 0
	var/message = stripped_input(src, "Enter a message to tell your marauder.", "Telepathy")// as null|anything
	if(!src || !message)
		return 0
	if(!marauder)
		usr << "<span class='warning'>Your marauder seems to have vanished!</span>"
		return 0
	message = "<span class='heavy_brass'>Servant [name == real_name ? name : "[real_name] (as [name])"]:</span> <span class='brass'>\"[message]\"</span>" //Processed output
	src << message
	marauder << message
	return 1

/mob/living/simple_animal/hostile/clockwork_marauder/verb/change_true_name()
	set name = "Change True Name (One-Use)"
	set desc = "Changes your true name, used to be called forth."
	set category = "Marauder"

	verbs -= /mob/living/simple_animal/hostile/clockwork_marauder/verb/change_true_name
	var/new_name = stripped_input(usr, "Enter a new true name (20-character limit).", "Change True Name")// as null|anything
	if(!usr)
		return 0
	if(!new_name)
		usr << "<span class='notice'>You decide against changing your true name for now.</span>"
		verbs += /mob/living/simple_animal/hostile/clockwork_marauder/verb/change_true_name //If they decide against it, let them have another opportunity
		return 0
	new_name = dd_limittext(new_name, 20)
	true_name = new_name
	usr << "<span class='userdanger'>You have changed your true name to \"[new_name]\"!</span>"
	if(host)
		host << "<span class='userdanger'>Your clockwork marauder has changed their true name to \"[new_name]\"!</span>"
	return 1

/mob/living/simple_animal/hostile/clockwork_marauder/verb/return_to_host()
	set name = "Return to Host"
	set desc = "Recalls yourself to your host, assuming you aren't already there."
	set category = "Marauder"

	if(is_in_host())
		return 0
	if(!host)
		src << "<span class='warning'>You don't have a host!</span>"
		verbs -= /mob/living/simple_animal/hostile/clockwork_marauder/verb/return_to_host
		return 0
	host << "<span class='heavy_brass'>You feel [true_name]'s consciousness settle in your mind.</span>"
	visible_message("<span class='warning'>[src] is yanked into [host]'s body!</span>", "<span class='brass'>You return to [host].</span>")
	forceMove(host)
	return 1

/mob/living/simple_animal/hostile/clockwork_marauder/proc/emerge_from_host() //Notice that this is a proc rather than a verb - marauders can NOT exit at will, but they CAN return
	if(!is_in_host())
		return 0
	if(recovering)
		host << "<span class='heavy_brass'>[true_name] is too weak to come forth!</span>"
		src << "<span class='userdanger'>You try to come forth, but you're too weak!</span>"
		return 0
	host << "<span class='heavy_brass'>You words echo with power as [true_name] emerges from your body!</span>"
	forceMove(get_turf(host))
	visible_message("<span class='warning'>[host]'s skin glows red as a [name] emerges from their body!</span>", "<span class='brass'>You exit the safety of [host]'s body!</span>")
	return 1

/mob/living/simple_animal/hostile/clockwork_marauder/proc/is_in_host() //Checks if the marauder is inside of their host
	return host && loc == host



/mob/living/mind_control_holder
	name = "imprisoned mind"
	desc = "A helpless mind, imprisoned in its own body."
	stat = 0
	flags = GODMODE

/mob/living/mind_control_holder/say()
	return 0
