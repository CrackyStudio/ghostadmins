#include <sourcemod> 
#include <sdktools> 
#include <sdkhooks> 

new g_iVisible[MAXPLAYERS + 1] = {1, ...};
new g_iIsConnectedOffset = -1;

public Plugin:myinfo = 
{
    name = "Ghost Admins",
    author = "Cracky",
    description = "Admins join the server as Ghost. No connection/disconnection message, invisible on scoreboard",
    version = "alpha",
    url = "https://github.com/CrackyStudio"
}

public OnPluginStart()
{
	HookEvent("player_team", OnPlayerTeam, EventHookMode_Pre);
	HookEvent("player_disconnect", OnPlayerDisconnect, EventHookMode_Pre);
	HookEvent("player_connect", OnPlayerConnect, EventHookMode_Pre);
	RegConsoleCmd("sm_hideme", Command_HideMe, "");
}

public Action:OnPlayerTeam(Handle:event, const String:name[], bool:dontBroadcast)
{
	return (Plugin_Handled);
}

public Action:OnPlayerConnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	return (Plugin_Handled);
}

public Action:OnPlayerDisconnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	return (Plugin_Handled);
}

public OnMapStart() 
{
    g_iIsConnectedOffset = FindSendPropOffs("CCSPlayerResource", "m_bConnected");
    if (g_iIsConnectedOffset == -1)
        SetFailState("CCSPlayerResource.m_bConnected offset is invalid");    
    new CSPlayerManagerIndex = FindEntityByClassname(0, "cs_player_manager"); 
    SDKHook(CSPlayerManagerIndex, SDKHook_ThinkPost, OnThinkPost);
} 

public OnThinkPost(entity) 
{
    decl isConnected[65];   
    GetEntDataArray(entity, g_iIsConnectedOffset, isConnected, 65);
    for (new i = 1; i <= MaxClients; ++i)
    {
        if (IsClientInGame(i) && (GetUserAdmin(i) != INVALID_ADMIN_ID))
            isConnected[i] = !g_iVisible[i];
    }
    SetEntDataArray(entity, g_iIsConnectedOffset, isConnected, 65);
}

public Action:Command_HideMe(client, args)
{
    if(!client)
        return Plugin_Handled;    
    if(IsClientInGame(client) && (GetUserAdmin(client) != INVALID_ADMIN_ID))
        g_iVisible[client] = !g_iVisible[client];   
    return Plugin_Handled;
}