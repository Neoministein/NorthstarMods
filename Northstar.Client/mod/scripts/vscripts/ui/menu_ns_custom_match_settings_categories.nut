global function AddNorthstarCustomMatchSettingsCategoryMenu

void function AddNorthstarCustomMatchSettingsCategoryMenu()
{
	AddMenu( "CustomMatchSettingsCategoryMenu", $"resource/ui/menus/custom_match_settings_categories.menu", InitNorthstarCustomMatchSettingsCategoryMenu, "#MENU_MATCH_SETTINGS" )
}

void function InitNorthstarCustomMatchSettingsCategoryMenu()
{
	AddMenuEventHandler( GetMenu( "CustomMatchSettingsCategoryMenu" ), eUIEvent.MENU_OPEN, OnNorthstarCustomMatchSettingsCategoryMenuOpened )
	AddMenuFooterOption( GetMenu( "CustomMatchSettingsCategoryMenu" ), BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
	AddMenuFooterOption( GetMenu( "CustomMatchSettingsCategoryMenu" ), BUTTON_Y, "#Y_BUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", ResetMatchSettingsToDefault )


	array<var> buttons = GetElementsByClassname( GetMenu( "CustomMatchSettingsCategoryMenu" ), "MatchSettingCategoryButton" )

	for ( int i = 1; i < buttons.len(); i++ )
	{
		
		AddButtonEventHandler( buttons[i], UIE_CLICK, SelectPrivateMatchSettingsCategory )
	
		Hud_SetEnabled( buttons[i], false )
		Hud_SetVisible( buttons[i], false )
	}

	AddButtonEventHandler( buttons[0], UIE_CLICK, OpenBanMenu )
}

void function OnNorthstarCustomMatchSettingsCategoryMenuOpened()
{
	array<string> categories = GetPrivateMatchSettingCategories()
	array<var> buttons = GetElementsByClassname( GetMenu( "CustomMatchSettingsCategoryMenu" ), "MatchSettingCategoryButton" )
	
	foreach ( var button in buttons )
	{
		Hud_SetEnabled( button, false )
		Hud_SetVisible( button, false )
	}

	Hud_SetText( buttons[ 0 ], Localize("#BAN_PAGE" ) + " ->" )
	Hud_SetEnabled( buttons[ 0 ], true )
	Hud_SetVisible( buttons[ 0 ], true )
	
	for ( int i = 1, j = 0; j < categories.len() && i < buttons.len(); i++, j++ )
	{
		Hud_SetText( buttons[ i ], Localize( categories[ j ] ) + " ->" )
		Hud_SetEnabled( buttons[ i ], true )
		Hud_SetVisible( buttons[ i ], true )
	}
}

void function SelectPrivateMatchSettingsCategory( var button )
{
	SetNextMatchSettingsCategory( GetPrivateMatchSettingCategories()[ int( Hud_GetScriptID( button ) ) -1 ] )
	AdvanceMenu( GetMenu( "CustomMatchSettingsMenu" ) )
}

void function ResetMatchSettingsToDefault( var button )
{
	ClientCommand( "ResetMatchSettingsToDefault" )
}

void function OpenBanMenu(var button) 
{
	print("--------------------------------------------- Click --------------------------------------")
	AdvanceMenu( GetMenu( "ServerBrowserMenu" ) )
}