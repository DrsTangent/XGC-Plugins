#include <amxmodx>
#include <amxmisc>

#define PLUGIN	"Bhop Abilities"
#define VERSION "1.0"
#define AUTHOR	"ROCKY ROCK"

new Tag[33][64];
new bool: haveTag[33];
new SzGTeam[3][] = {
	"Spectator",
	"Terrorist",
	"Counter-Terrorist"
}
new SzMaxPlayers, SzSayText;

new base[] = "addons\amxmodx\configs\tags.ini"

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	
	register_clcmd("say", "hook_say");
	register_clcmd("say_team", "hook_say_team");
	register_concmd("amx_setTag", "setTag",ADMIN_RCON, "<Name/Steam> <Type: name/steam> <Tag>");
	SzSayText = get_user_msgid ("SayText");
	SzMaxPlayers = get_maxplayers();
	
	register_message(SzSayText, "MsgDuplicate");
}
public client_putinserver(id)
{
	Tag[id] = "";
	haveTag[id] = false;
	new text[128];
	new num;
	new name[64], steam[64], parseddata[64], parsedtag[64];
	get_user_name(id, name, charsmax(name));
	get_user_authid(id, steam, charsmax(steam));
	if(file_exists(base))
	{
		for(new i=0; read_file(base, i, text, charsmax(text), num); i++) {
			if (num > 0 && text[0] != ';' && text[0] != '-' && text[0] != '=') {
				parse(text, parseddata, charsmax(parseddata), parsedtag, charsmax(parsedtag));
				
				if(equali(parseddata, name) || equali(parseddata, steam))
				{
					Tag[id] = parsedtag;
					haveTag[id] = true;
					break;
				}
			}
		}
	}
}

public client_disconnect(id)
{
	Tag[id] = "";
	haveTag[id] = false;
}
/* MESSAGE HANDLING */
public MsgDuplicate(id){ return PLUGIN_HANDLED; }

public hook_say(id)
{
	new SzMessages[192], SzName[32];
	new SzAlive = is_user_alive(id);
	
	read_args(SzMessages, 191);
	remove_quotes(SzMessages);
	get_user_name(id, SzName, charsmax(SzName));
	
	if(!is_valid_msg(SzMessages))
		return PLUGIN_CONTINUE;
	if(haveTag[id])
		(SzAlive )? format(SzMessages, 191, "^4%s ^3%s : ^1%s", Tag[id], SzName, SzMessages) : format(SzMessages, 191, "^1*DEAD* ^4 %s ^3%s : ^1%s", Tag[id], SzName, SzMessages);
	else
		(SzAlive )? format(SzMessages, 191, "^3%s : ^1%s", SzName, SzMessages) : format(SzMessages, 191, "^1*DEAD* ^3%s : ^1%s", SzName, SzMessages);
	log_amx(SzMessages);
	
	for(new i = 1; i <= SzMaxPlayers; i++)
	{
		if(!is_user_connected(i))
			continue;
		
		message_begin(MSG_ONE, get_user_msgid("SayText"), {0, 0, 0}, i);
		write_byte(id);
		write_string(SzMessages);
		message_end();
	}
	
	return PLUGIN_CONTINUE;
}

public hook_say_team(id)
{
	new SzMessages[192], SzName[32];
	new SzAlive = is_user_alive(id);
	new SzGetTeam = get_user_team(id);
	
	read_args(SzMessages, 191);
	remove_quotes(SzMessages);
	get_user_name(id, SzName, charsmax(SzName));
	
	if(!is_valid_msg(SzMessages))
		return PLUGIN_CONTINUE;
	if(haveTag[id])
		(SzAlive)? format(SzMessages, 191, "^1(%s) ^4%s ^3%s : ^1%s", SzGTeam[SzGetTeam], Tag[id], SzName, SzMessages) : format(SzMessages, 191, "^1*DEAD* ^1(%s) ^4%s ^3%s : ^1%s", SzGTeam[SzGetTeam], Tag[id], SzName, SzMessages);
	else
		(SzAlive)? format(SzMessages, 191, "^1(%s) ^3%s : ^1%s", SzGTeam[SzGetTeam], SzName, SzMessages) : format(SzMessages, 191, "^1*DEAD* ^1(%s) ^3%s : ^1%s", SzGTeam[SzGetTeam], SzName, SzMessages);
	log_amx(SzMessages);
	for(new i = 1; i <= SzMaxPlayers; i++)
	{
		if(!is_user_connected(i))
			continue;
		
		if(get_user_team(i) != SzGetTeam)
			continue;
		
		message_begin(MSG_ONE, get_user_msgid("SayText"), {0, 0, 0}, i);
		write_byte(id);
		write_string(SzMessages);
		message_end();
	}
	
	return PLUGIN_CONTINUE;
}

bool:is_valid_msg(const SzMessages[])
{
	if( SzMessages[0] == '@'
	|| !strlen(SzMessages)){ return false; }
	return true;
}  

/*EXTRA COMMANDS- will be edited in future*/

public setTag(id, level, cid)
{
	if (!cmd_access(id, level, cid, 4))
		return PLUGIN_HANDLED
		
	return PLUGIN_HANDLED;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/
