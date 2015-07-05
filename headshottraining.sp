#include <sourcemod>
#include <sdktools>
#include <console>

#define VERSION "0.0.0"

public Plugin:myinfo =
{
  name = "Headshot Training",
  author = "Eshin Kunishima",
  description = "Shoot heads, or you will suicide.",
  version = VERSION,
  url = "https://github.com/mikoim/headshottraining"
};

new g_iHealth, g_Armor;

public OnPluginStart()
{
  HookEvent("player_hurt", EventPlayerHurt, EventHookMode_Pre);

  g_iHealth = FindSendPropOffs("CCSPlayer", "m_iHealth");
  if (g_iHealth == -1)
  {
    SetFailState("[Headshot Training] Error - Unable to get offset for CSSPlayer::m_iHealth");
  }

  g_Armor = FindSendPropOffs("CCSPlayer", "m_ArmorValue");
  if (g_Armor == -1)
  {
    SetFailState("[Headshot Training] Error - Unable to get offset for CSSPlayer::m_ArmorValue");
  }
}

public Action:EventPlayerHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
  new hitgroup = GetEventInt(event, "hitgroup");
  new victim = GetClientOfUserId(GetEventInt(event, "userid"));
  new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
  new dhealth = GetEventInt(event, "dmg_health");
  new darmor = GetEventInt(event, "dmg_armor");
  new health = GetEventInt(event, "health");
  new armor = GetEventInt(event, "armor");

  if (hitgroup != 1 && attacker != victim && victim != 0 && attacker != 0)
  {
    if (dhealth > 0)
    {
      SetEntData(victim, g_iHealth, (health + dhealth), 4, true);
    }

    if (darmor > 0)
    {
      SetEntData(victim, g_Armor, (armor + darmor), 4, true);
    }

    ForcePlayerSuicide(attacker);
  }

  return Plugin_Continue;
}
