#define DAMAGE_RECIEVED
#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <hamsandwich>
#include <fun>

new maxplayers
new mpd, mkb, mhb
new health_add
new health_hs_add
new health_max
new nKiller
new nKiller_hp
new nHp_add
new nHp_max
new g_menu_active
new bool:HasC4[33]
#define Keysrod (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<9) // Keys: 1234567890

public plugin_init()
{
	register_plugin("VIP Eng Version", "3.1", "Dunno")
	mpd = register_cvar("money_per_damage","3")
	mkb = register_cvar("money_kill_bonus","200")
	mhb = register_cvar("money_hs_bonus","500")
	health_add = register_cvar("amx_vip_hp", "15")
	health_hs_add = register_cvar("amx_vip_hp_hs", "30")
	health_max = register_cvar("amx_vip_max_hp", "100")
	g_menu_active = register_cvar("menu_active", "1")
	RegisterHam(Ham_Spawn, "player", "player_spawn", 1)
	register_event("Damage","Damage","b")
	register_event("DeathMsg","death_msg","a")
	register_menucmd(register_menuid("rod"), Keysrod, "Pressedrod")
	maxplayers = get_maxplayers()
	register_event("DeathMsg", "hook_death", "a", "1>0")
	register_event("Damage", "on_damage", "b", "2!0", "3=0", "4!0")
}

public player_spawn(id)
{
	if(get_pcvar_num(g_menu_active) == 1)
	{
		Showrod(id)
	}
}
public Damage(id)
{
	new weapon, hitpoint, attacker = get_user_attacker(id,weapon,hitpoint)
	if(attacker<=maxplayers && is_user_alive(attacker) && attacker!=id)
	if (get_user_flags(attacker) & ADMIN_LEVEL_H) 
	{
		new money = read_data(2) * get_pcvar_num(mpd)
		if(hitpoint==1) money += get_pcvar_num(mhb)
		cs_set_user_money(attacker,cs_get_user_money(attacker) + money)
	}
}

public death_msg()
{
	if(read_data(1)<=maxplayers && read_data(1) && read_data(1)!=read_data(2)) cs_set_user_money(read_data(1),cs_get_user_money(read_data(1)) + get_pcvar_num(mkb) - 300)
}

public hook_death()
{
	// Killer id
	nKiller = read_data(1)
	
	if ( (read_data(3) == 1) && (read_data(5) == 0) )
	{
	nHp_add = get_pcvar_num (health_hs_add)
	}
	else
	nHp_add = get_pcvar_num (health_add)
	nHp_max = get_pcvar_num (health_max)
	// Updating Killer HP
	if(!(get_user_flags(nKiller) & ADMIN_LEVEL_H))
	return;
	
	nKiller_hp = get_user_health(nKiller)
	nKiller_hp += nHp_add
	// Maximum HP check
	if (nKiller_hp > nHp_max) nKiller_hp = nHp_max
	set_user_health(nKiller, nKiller_hp)
	// Hud message "Healed +15/+30 hp"
	set_hudmessage(0, 255, 0, -1.0, 0.15, 0, 1.0, 1.0, 0.1, 0.1, -1)
	show_hudmessage(nKiller, "Healed +%d hp", nHp_add)
	// Screen fading
	message_begin(MSG_ONE, get_user_msgid("ScreenFade"), {0,0,0}, nKiller)
	write_short(1<<10)
	write_short(1<<10)
	write_short(0x0000)
	write_byte(0)
	write_byte(0)
	write_byte(200)
	write_byte(75)
	message_end()
 
}

public Showrod(id) {
	show_menu(id, Keysrod, "\wE\rX\wTREME GAME\rR\wZ \r | \wGUNS MENU \r|^n\yChoose Your Weapon^n\r1. \w I Want \r| \w M4A1 + DEAGLE \r|^n\r2. \w I Want \r| \w AK47 + DEAGLE \r|^n\r1. \w I Want \r| \w FAMAS + DEAGLE \r|^n\r0. \yI Prefer To Buy", -1, "rod") // Display menu
}
public Pressedrod(id, key) {
	/* Menu:
	* VIP Menu
	* 1. Get M4A1+Deagle
	* 2. Get AK47+Deagle
	* 3. Get FAMAS+Deagle
	* 0. I Prefer to buy
	*/
	switch (key) 
	{
		case 0: { 
			if (user_has_weapon(id, CSW_C4) && get_user_team(id) == 1)
				HasC4[id] = true;
			else
				HasC4[id] = false;
            
			strip_user_weapons (id)
			give_item(id,"weapon_m4a1")
			give_item(id,"ammo_556nato")
			give_item(id,"ammo_556nato")
			give_item(id,"ammo_556nato")
			give_item(id,"weapon_deagle")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"weapon_knife")
			give_item(id,"weapon_hegrenade")
			give_item(id, "weapon_flashbang");
			give_item(id, "weapon_flashbang");
			give_item(id, "item_assaultsuit");
			give_item(id, "item_thighpack");
			client_print(id, print_center, "You Took Free M4A1 and Deagle")
			
			if (HasC4[id])
			{
				give_item(id, "weapon_c4");
				cs_set_user_plant( id );
			}
			}
		case 1: { 
			if (user_has_weapon(id, CSW_C4) && get_user_team(id) == 1)
				HasC4[id] = true;
			else
				HasC4[id] = false;
            
			strip_user_weapons (id)
			give_item(id,"weapon_ak47")
			give_item(id,"ammo_762nato")
			give_item(id,"ammo_762nato")
			give_item(id,"ammo_762nato")
			give_item(id,"weapon_deagle")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"weapon_knife")
			give_item(id,"weapon_hegrenade")
			give_item(id, "weapon_flashbang");
			give_item(id, "weapon_flashbang");
			give_item(id, "item_assaultsuit");
			give_item(id, "item_thighpack");
			client_print(id, print_center, "You Took Free AK47 and Deagle")
			
			if (HasC4[id])
			{
				give_item(id, "weapon_c4");
				cs_set_user_plant( id );
			}
			}
		case 2: { 
			if (user_has_weapon(id, CSW_C4) && get_user_team(id) == 1)
				HasC4[id] = true;
			else
				HasC4[id] = false;
            
			strip_user_weapons (id)
			give_item(id,"weapon_famas")
			give_item(id,"ammo_556nato")
			give_item(id,"ammo_556nato")
			give_item(id,"ammo_556nato")
			give_item(id,"weapon_deagle")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"weapon_knife")
			give_item(id,"weapon_hegrenade")
			give_item(id, "weapon_flashbang");
			give_item(id, "weapon_flashbang");
			give_item(id, "item_assaultsuit");
			give_item(id, "item_thighpack");
			client_print(id, print_center, "You Took Free Famas and Deagle")
			
			if (HasC4[id])
			{
				give_item(id, "weapon_c4");
				cs_set_user_plant( id );
			}
			}
		case 9: { 			
		}
	}
	return PLUGIN_CONTINUE
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/
