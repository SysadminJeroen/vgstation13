/obj/item/weapon/storage/bag/gadgets/part_replacer //Bag because disposals bin snowflake code is shit
	name = "rapid part exchange device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	icon_state = "RPED"
	item_state = "RPED"
	w_class = W_CLASS_LARGE
	use_to_pickup = 1
	fits_max_w_class = W_CLASS_MEDIUM
	max_combined_w_class = 100
	storage_slots = 50
	inhand_states = list("left_hand" = 'icons/mob/in-hand/left/misc_tools.dmi', "right_hand" = 'icons/mob/in-hand/right/misc_tools.dmi')
	display_contents_with_number = TRUE
	var/bluespace = FALSE

/obj/item/weapon/storage/bag/gadgets/part_replacer/discount_bluespace
	name = "Prototype bluespace rapid part exchange device" //Alternative name: Discount BRPED, therefore denoted as DBRPED
	desc = "Not as good as the real deal, but still good. This device is a better variant of the RPED that can hold twice as many parts and can function on machines that do not have their panels open."
	icon_state = "DBRPED"
	item_state = "DBRPED"
	max_combined_w_class = 200
	storage_slots = 100
	bluespace = TRUE

/obj/item/weapon/storage/bag/gadgets/part_replacer/proc/play_rped_sound()
	//Plays the sound for RPED exhanging or installing parts.
	playsound(src, 'sound/items/rped.ogg', 40, 1)

//Sorts items by their rating. Currently used by the RPED (did that need mentioning since this proc is in RPED.dm?)
//Only use /obj/item with this sort proc!
/proc/cmp_rped_sort(var/obj/item/A, var/obj/item/B)
	return B.rped_rating() - A.rped_rating()

/obj/item/weapon/storage/bag/gadgets/part_replacer/attackby(var/obj/item/weapon/W, var/mob/user)
	if(istype(W, /obj/item/weapon/storage/bag/gadgets)) //I guess this allows for moving stuff between RPEDs, honk.
		var/obj/item/weapon/storage/bag/gadgets/A = W
		if(A.contents.len <= 0)
			to_chat(user, "<span class='notify'>\the [A] is empty!</span>")
			return 1
		if(src.contents.len >= storage_slots)
			to_chat(user, "<span class='notify'>\the [src] is full!</span>")
			return 1
		A.mass_remove(src)
		to_chat(user, "<span class='notify'>You fill up \the [src] with \the [A]")
		return 1

	return ..()

/obj/item/weapon/storage/bag/gadgets/part_replacer/pre_loaded/New() //Comes preloaded with loads of parts for testing
	..()
	for(var/i in 1 to 3)
		new /obj/item/weapon/stock_parts/matter_bin/adv/super/bluespace(src)
	for(var/i in 1 to 8)
		new /obj/item/weapon/stock_parts/manipulator/nano/pico(src)
	for(var/i in 1 to 8)
		new /obj/item/weapon/stock_parts/matter_bin/adv/super(src)
	for(var/i in 1 to 5)
		new /obj/item/weapon/stock_parts/micro_laser/high/ultra(src)
	for(var/i in 1 to 5)
		new /obj/item/weapon/stock_parts/scanning_module/adv/phasic(src)
	for(var/i in 1 to 5)
		new /obj/item/weapon/stock_parts/capacitor/adv/super(src)
	for(var/i in 1 to 3)
		new /obj/item/weapon/stock_parts/manipulator/nano(src)
	for(var/i in 1 to 3)
		new /obj/item/weapon/stock_parts/matter_bin/adv(src)
	for(var/i in 1 to 3)
		new /obj/item/weapon/stock_parts/micro_laser/high(src)
	for(var/i in 1 to 3)
		new /obj/item/weapon/stock_parts/scanning_module/adv(src)
	for(var/i in 1 to 3)
		new /obj/item/weapon/stock_parts/capacitor/adv(src)
	for(var/i in 1 to 8)
		new /obj/item/weapon/stock_parts/console_screen(src)

//Takes a tier 1 stock part path and a target rating
//Returns a part object
/proc/part_subtype(var/basepath, var/target)
	for(var/path in subtypesof(basepath))
		var/obj/item/weapon/stock_parts/SP = path
		if(initial(SP.rating) == target)
			return new SP

/obj/item/weapon/storage/bag/gadgets/part_replacer/injector
	name = "upgrade injector"
	desc = "A single use upgrade injector. Just stab it into the side of a machine and it will dissolve away."
	icon = 'icons/obj/syringe.dmi'
	icon_state = "combat_hypo"
	item_state = "hypo"
	mech_flags = MECH_SCAN_FAIL
	bluespace = TRUE
	w_class = W_CLASS_SMALL
	use_to_pickup = FALSE
	var/base_rating = 2
	var/parts_each = 3
	var/list/part_types = list(/obj/item/weapon/stock_parts/manipulator,
								/obj/item/weapon/stock_parts/matter_bin,
								/obj/item/weapon/stock_parts/scanning_module,
								/obj/item/weapon/stock_parts/capacitor,
								/obj/item/weapon/stock_parts/micro_laser)

/obj/item/weapon/storage/bag/gadgets/part_replacer/injector/super
	name = "super upgrade injector"
	icon_state = "combat_hypo_s"
	base_rating = 3

/obj/item/weapon/storage/bag/gadgets/part_replacer/injector/New()
	..()
	var/obj/item/weapon/stock_parts/SP
	for(var/i in 1 to parts_each)
		for(var/path in part_types)
			var/target_rating = base_rating
			if(prob(10))
				target_rating++
			SP = part_subtype(path,target_rating)
			SP.forceMove(src)
			SP.mech_flags |= MECH_SCAN_FAIL
		new /obj/item/weapon/stock_parts/console_screen(src)

/obj/item/weapon/storage/bag/gadgets/part_replacer/injector/attackby(obj/O,mob/user)
	return

/obj/item/weapon/storage/bag/gadgets/part_replacer/injector/can_be_inserted(obj/item/W, stop_messages = 0)
	return FALSE

/obj/item/weapon/storage/bag/gadgets/part_replacer/injector/remove_from_storage(obj/item/W, atom/new_location, var/force = 0, var/refresh = 1)
	if(force)
		return ..()
	else
		return FALSE

/obj/item/weapon/storage/bag/gadgets/part_replacer/injector/play_rped_sound()
	..()
	qdel(src) //We've had a successful upgrade, time to die.