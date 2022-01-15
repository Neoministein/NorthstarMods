global function AddNorthstarCustomMatchSettingsBanMenu


void function AddNorthstarCustomMatchSettingsBanMenu()
{
   AddMenu("CustomMatchBanSettingsMenu", $"resource/ui/menus/custom_match_settings_ban.menu", InitNorthstarCustomMatchSettingsBanMenu, "#MENU_MATCH_SETTINGS")
}  

void function InitNorthstarCustomMatchSettingsBanMenu()
{
  AddMenuFooterOption( GetMenu( "CustomMatchBanSettingsMenu" ), BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}