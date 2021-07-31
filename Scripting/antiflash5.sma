#include <amxmodx>
#include <fakemeta> 
#include <hamsandwich>

// https://forums.alliedmods.net/showthread.php?p=2565017

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const PEV_NADE_TYPE = pev_flTimeStepSound
const NADE_TYPE_FLASH = 3333

new g_msgid_ScreenFade
new g_PlayerFlasher

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

public plugin_init()
{
	register_plugin("AntiFlash FINAL", "5.0", "Leo_[BH]")
	
	g_msgid_ScreenFade = get_user_msgid("ScreenFade")

	register_message(g_msgid_ScreenFade, "message_screenfade");

	register_forward(FM_SetModel, "fw_SetModel")
	RegisterHam(Ham_Think, "grenade", "fw_ThinkGrenade")
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

public message_screenfade(msg_id, msg_dest, msg_entity)
{
	if (get_msg_arg_int(4) != 255 || get_msg_arg_int(5) != 255 || get_msg_arg_int(6) != 255 || get_msg_arg_int(7) < 200)
		return PLUGIN_CONTINUE;
	
	new id = msg_entity
	
	if (id != g_PlayerFlasher && get_user_team(id) == get_user_team(g_PlayerFlasher))
	{
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

public fw_SetModel(entity, szModel[]) 
{
	if(!equal(szModel, "models/w_flashbang.mdl")) 
		return FMRES_IGNORED;
	
	set_pev(entity, PEV_NADE_TYPE, NADE_TYPE_FLASH)

	return FMRES_IGNORED;
} 

public fw_ThinkGrenade(entity)
{
	if (!pev_valid(entity)) return HAM_IGNORED;
	
	static Float:dmgtime
	pev(entity, pev_dmgtime, dmgtime)
	
	if (dmgtime > get_gametime())
		return HAM_IGNORED;
	
	switch (pev(entity, PEV_NADE_TYPE))
	{
		case NADE_TYPE_FLASH: // Flash Grenade
		{
			g_PlayerFlasher = pev(entity, pev_owner)
			return HAM_IGNORED;
		}
	}
	
	return HAM_IGNORED;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/
