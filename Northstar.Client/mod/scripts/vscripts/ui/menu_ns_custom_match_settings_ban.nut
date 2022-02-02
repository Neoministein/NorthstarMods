global function AddNorthstarCustomMatchSettingsBanMenu

struct BoolAttributte {
  bool disabeled = false
  asset image
}

struct ArrayAttribute {
    array<asset> images
    array<string> values
}

struct PilotDisplay {
  var loadoutDisplay

  table<string ,BoolAttributte> attributes 
} 

struct Weapon {
    string name
    asset image
    bool disabled = false

    int selectedMod0 
    int selectedMod1
    int selectedVisor

    ArrayAttribute &mod0
    ArrayAttribute &mod1 
    ArrayAttribute &visor
}

struct WeaponCategory {
    string displayName

    array<Weapon> weapons
}

struct WeaponDisplay {
  int categorySelected = 1
  int modTypeSelected = 1
  int weaponSelected = 1

  array<var> buttons = []
  array<WeaponCategory> categories
  array<var> weaponDisplays 
  var loadoutDisplay
} 

struct Titan {
    string name
    asset image
    bool disabled = false

    int selectedKit0 
    int selectedKit1
    int selectedKit2

    ArrayAttribute &kit0
    ArrayAttribute &kit1 
    ArrayAttribute &kit2
}

struct TitanDisplay {
  var loadoutDisplay

  int selectedTitanAttribute
  int selectedTitan

  array<Titan> titans
  array<var> titanDisplays 
} 

struct BoostDisplay {
  var loadoutDisplay

  table<string ,BoolAttributte> boosts 
} 


struct {
  var menu
  var subMenu

  int selected = 0

  array<var> buttons = []
  array<var> loadoutDisplays = []
  PilotDisplay pilot
  WeaponDisplay weapon
  TitanDisplay titan
  BoostDisplay boost
} file

void function AddNorthstarCustomMatchSettingsBanMenu()
{
   AddMenu("CustomMatchBanSettingsMenu", $"resource/ui/menus/custom_match_settings_ban.menu", InitNorthstarCustomMatchSettingsBanMenu, "#MENU_MATCH_SETTINGS")
   AddSubmenu( "customSelectMenu", $"resource/ui/menus/modselect.menu", InitCustomSelectMenu )
}  

void function InitNorthstarCustomMatchSettingsBanMenu()
{
  file.menu = GetMenu( "CustomMatchBanSettingsMenu" )
  AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )


  file.loadoutDisplays = GetElementsByClassname( file.menu, "loadoutDisplay" )
  
  initPilot()
  initWeapon()
  initTitan()
  initBoost()

  file.buttons = GetElementsByClassname( file.menu, "BanSettingCategoryButton" )
  RHud_SetText( file.buttons[0], "#MODE_SETTING_BAN_PILOT" )
  RHud_SetText( file.buttons[1], "#MODE_SETTING_BAN_WEAPON" )
  RHud_SetText( file.buttons[2], "#MODE_SETTING_BAN_TITAN" )
  RHud_SetText( file.buttons[3], "#MODE_SETTING_BAN_BOOST" )

  selectButton(file.buttons, 2, 0)
  selectDisplay(file.loadoutDisplays, 2, 0)
  
  foreach (var button in file.buttons ) 
  {
    AddButtonEventHandler( button, UIE_CLICK, callChangeMainDisplay )
    Hud_SetVisible( button, true)
	}
}

void function InitCustomSelectMenu()
{
	var menu = GetMenu( "customSelectMenu" )
  file.subMenu = menu

  array<var> modButton = GetElementsByClassname( menu, "ModSelectClass" )
  for(int i = 0; i < modButton.len(); i++) 
  {
    AddButtonEventHandler( modButton[i], UIE_CLICK, clickSelectInSubmenu )
  } 

	var screen = Hud_GetChild( menu, "Screen" )
	var rui = Hud_GetRui( screen )
	RuiSetFloat( rui, "basicImageAlpha", 0.0 )
	Hud_AddEventHandler( screen, UIE_CLICK, OnModSelectBGScreen_Activate )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnModSelectBGScreen_Activate( var button )
{
	CloseActiveMenu(true)
  RestoreHiddenSubmenuBackgroundElems()
}

void function clickOpenSubMenu(var pressedButton) {
  OpenSubmenu( file.subMenu )
  var menu = file.subMenu

	var vguiButtonFrame = Hud_GetChild( menu, "ButtonFrame" )
	var ruiButtonFrame = Hud_GetRui( vguiButtonFrame )
	RuiSetImage( ruiButtonFrame, "basicImage", $"rui/borders/menu_border_button" )
	RuiSetFloat3( ruiButtonFrame, "basicImageColor", <0,0,0> )
	RuiSetFloat( ruiButtonFrame, "basicImageAlpha", 0.25 )
  
	array<var> buttons = GetElementsByClassname( menu, "ModSelectClass" )

  int uiElementId = int(Hud_GetScriptID( Hud_GetParent( pressedButton ) ) )  
  int buttonSelected = int(Hud_GetScriptID( pressedButton ))

  array<asset> items

  //This defines the screen which calls this button so that weapons and titans can use the same logic
  if (file.selected == 1) {
    file.weapon.modTypeSelected = buttonSelected
    file.weapon.weaponSelected = uiElementId

    if (0 == buttonSelected) {
      items = file.weapon.categories[file.weapon.categorySelected].weapons[uiElementId].mod0.images
    } else if (1 == buttonSelected) {
      items = file.weapon.categories[file.weapon.categorySelected].weapons[uiElementId].mod1.images
    } else {
      items = file.weapon.categories[file.weapon.categorySelected].weapons[uiElementId].visor.images
    }
  } else if (file.selected == 2) {
    file.titan.selectedTitanAttribute = buttonSelected
    file.titan.selectedTitan = uiElementId

    if (0 == buttonSelected) {
      items = file.titan.titans[uiElementId].kit0.images
    } else if (1 == buttonSelected) {
      items = file.titan.titans[uiElementId].kit1.images
    } else {
      items = file.titan.titans[uiElementId].kit2.images
    }
  }

	
	int maxRowCount = 4
	int numItems = items.len()
	int displayRowCount = int( ceil( numItems / 2.0 ) )

	int buttonWidth = 72
	int spacerWidth = 6
	int vguiButtonFrameWidth = int( ContentScaledX( (buttonWidth * displayRowCount) + (spacerWidth * (displayRowCount-1)) ) )
	Hud_SetWidth( vguiButtonFrame, vguiButtonFrameWidth )

  for(int i = 0; i < buttons.len();i++) {
    var button = buttons[rearangeButtonTwoInt(i)]
    var rui = Hud_GetRui( button )

    if (i < items.len()) {
		  Hud_SetEnabled( button, true )
		  Hud_SetSelected( button, false )
      RuiSetBool( rui, "isVisible", true )
      RuiSetImage( rui, "buttonImage", items[i] )
    } else {
		  Hud_SetEnabled( button, false )
		  Hud_SetSelected( button, false )
      RuiSetBool( rui, "isVisible", false )
    }
  }

  HideSubmenuBackgroundElems()
  thread RestoreHiddenElemsOnMenuChange()
}

void function clickSelectInSubmenu(var pressedButton) 
{
  int modSelected = rearangeIntToButton(int(Hud_GetScriptID( pressedButton )))

  //This defines the screen which calls this button so that weapons and titans can use the same logic
  if (file.selected == 1) {
    if (0 == file.weapon.modTypeSelected) {
      file.weapon.categories[file.weapon.categorySelected].weapons[file.weapon.weaponSelected].selectedMod0 = modSelected
    } else if (1 == file.weapon.modTypeSelected) {
      file.weapon.categories[file.weapon.categorySelected].weapons[file.weapon.weaponSelected].selectedMod1 = modSelected
    } else {
      file.weapon.categories[file.weapon.categorySelected].weapons[file.weapon.weaponSelected].selectedVisor = modSelected
    }
    loadWeaponCategory(file.weapon.categories[file.weapon.categorySelected])
  } else {
    if (0 == file.titan.selectedTitanAttribute) {
      file.titan.titans[file.titan.selectedTitan].selectedKit0 = modSelected
    } else if (1 == file.titan.selectedTitanAttribute) {
      file.titan.titans[file.titan.selectedTitan].selectedKit1 = modSelected
    } else {
      file.titan.titans[file.titan.selectedTitan].selectedKit2 = modSelected
    }
    reloadTitanScreen()
  }
  
  OnModSelectBGScreen_Activate(null)
}

void function RestoreHiddenElemsOnMenuChange()
{
	while ( uiGlobal.activeMenu == file.subMenu )
		WaitFrame()

	RestoreHiddenSubmenuBackgroundElems()
}

//I could code this dynamicly but I just don't want to spend the time
int function rearangeButtonTwoInt(int value) {
  switch(value) {
    case 0:
      return 0
    case 1:
      return 4
    case 2:
      return 1
    case 3:
      return 5
    case 4:
      return 2
    case 5:
      return 6
    case 6:
      return 3
    case 7:
      return 7
  }
  return 0 
}

int function rearangeIntToButton(int value) {
  switch(value) {
    case 0:
      return 0
    case 1:
      return 2
    case 2:
      return 4
    case 3:
      return 6
    case 4:
      return 1
    case 5:
      return 3
    case 6:
      return 5
    case 7:
      return 7
  }
  return 0 
}

void function HideSubmenuBackgroundElems()
{
  int subLoadout
  array<var> elems
  if(file.selected == 1) 
  {
    elems = GetElementsByClassname( file.menu, "HideWhenEditing_" + file.weapon.modTypeSelected )
    subLoadout = file.weapon.weaponSelected
  } else {
    elems = GetElementsByClassname( file.menu, "HideWhenEditing_" + file.titan.selectedTitanAttribute )
    subLoadout = file.titan.selectedTitan
  }
	foreach ( elem in elems ) {
    if(int(Hud_GetScriptID( Hud_GetParent( elem ) ) ) == subLoadout) {
      Hud_Hide( elem )
    }
  }
}

void function RestoreHiddenSubmenuBackgroundElems()
{
	array<string> classnames
	classnames.append( "HideWhenEditing_0" )
	classnames.append( "HideWhenEditing_1" )
  classnames.append( "HideWhenEditing_2" )
	

	foreach ( classname in classnames )
	{
		array<var> elems = GetElementsByClassname( file.menu , classname )

		foreach ( elem in elems )
			Hud_Show( elem )
	}
  //This is here to not show the sights on weapon categories without sights
  if(file.weapon.categorySelected > 4 && file.selected == 1) 
  {
    array<var> elems = GetElementsByClassname( file.menu , "HideWhenNoVisor" )
	  foreach ( elem in elems )
		  Hud_Hide( elem )
  }

  
}

void function selectButton(array<var> buttons, int current, int selected) {
    Hud_SetSelected( buttons[current] , false )
    Hud_SetSelected( buttons[selected] , true )
}

void function selectDisplay(array<var>  loadoutDisplays, int selected, int newSelected) {
      Hud_SetVisible( loadoutDisplays[selected] , false )
      Hud_SetVisible( loadoutDisplays[newSelected] , true )
}

void function callChangeMainDisplay( var pressedButton )
{
  int selected = int( Hud_GetScriptID( pressedButton ))
  if(selected != file.selected) {
    selectButton(file.buttons, file.selected, selected)
    selectDisplay(file.loadoutDisplays, file.selected, selected)
    file.selected = selected

    if(file.selected == 1) {
      loadWeaponCategory(file.weapon.categories[file.weapon.categorySelected])
    } else if (file.selected == 2) {
      reloadTitanScreen()
    }
    
  }
}

void function callPilotButtonClick(var pressedButton) 
{
  BoolAttributte attribute = file.pilot.attributes[Hud_GetScriptID( pressedButton )];
  switchBoolAttribute(pressedButton ,attribute)
}

void function callBoostClick(var pressedButton) 
{
  BoolAttributte attribute = file.boost.boosts[Hud_GetScriptID( pressedButton )];
  switchBoolAttribute(pressedButton, attribute)
}

void function callWeaponButtonClick(var pressedButton) 
{
  int weaponId = int(Hud_GetScriptID( Hud_GetParent( pressedButton ) ) ) 
  bool state = !file.weapon.categories[file.weapon.categorySelected].weapons[weaponId].disabled

  Hud_SetSelected( pressedButton , state )

  file.weapon.categories[file.weapon.categorySelected].weapons[weaponId].disabled = state
}

void function switchBoolAttribute(var button, BoolAttributte attribute)
{
  attribute.disabeled = !attribute.disabeled
  Hud_SetSelected( button , attribute.disabeled )
}

void function changeWeaponDisplay( var pressedButton )
{
  int selected = int( Hud_GetScriptID( pressedButton ))
  if(selected != file.weapon.categorySelected) {
    selectButton(file.weapon.buttons, file.weapon.categorySelected, selected)
    loadWeaponCategory(file.weapon.categories[selected])
    
    file.weapon.categorySelected = selected
  }
}

void function loadWeaponCategory(WeaponCategory category) 
{
  for(int i = 0; i < file.weapon.weaponDisplays.len();i++) {
      if(i < category.weapons.len()) {
        RuiSetImage( 
          Hud_GetRui( Hud_GetChild( file.weapon.weaponDisplays[i], "ButtonWeapon" )), 
          "buttonImage", 
          category.weapons[i].image )

        RuiSetImage( 
          Hud_GetRui( Hud_GetChild( file.weapon.weaponDisplays[i], "ButtonWeaponMod0" )), 
          "buttonImage", 
          category.weapons[i].mod0.images[category.weapons[i].selectedMod0] )

        RuiSetImage( 
          Hud_GetRui( Hud_GetChild( file.weapon.weaponDisplays[i], "ButtonWeaponMod1" )), 
          "buttonImage", 
          category.weapons[i].mod1.images[category.weapons[i].selectedMod1] )     

        if (category.weapons[i].visor.images.len() > 0) {
          RuiSetImage( 
            Hud_GetRui( Hud_GetChild( file.weapon.weaponDisplays[i], "ButtonWeaponSight" )), 
            "buttonImage", 
            category.weapons[i].visor.images[category.weapons[i].selectedVisor] )  

            Hud_SetVisible( Hud_GetChild( file.weapon.weaponDisplays[i], "ButtonWeaponSight" ) , true )    
        } 
        else 
        {
          Hud_SetVisible( Hud_GetChild( file.weapon.weaponDisplays[i], "ButtonWeaponSight" ) , false )
        }


        Hud_SetVisible( file.weapon.weaponDisplays[i] , true )
      } else {
        Hud_SetVisible( file.weapon.weaponDisplays[i] , false )
      }
  }
}

void function reloadTitanScreen() {
  for(int i = 0; i < file.titan.titanDisplays.len();i++) {
    RuiSetImage( 
      Hud_GetRui( Hud_GetChild( file.titan.titanDisplays[i], "ButtonWeapon" )), 
      "buttonImage", 
      file.titan.titans[i].image )

    RuiSetImage( 
      Hud_GetRui( Hud_GetChild( file.titan.titanDisplays[i] ,"ButtonFrame")),
     "basicImage", 
     file.titan.titans[i].image )  

    RuiSetImage( 
      Hud_GetRui( Hud_GetChild( file.titan.titanDisplays[i], "ButtonWeaponMod0" )), 
      "buttonImage", 
      file.titan.titans[i].kit0.images[file.titan.titans[i].selectedKit0] )

    RuiSetImage( 
      Hud_GetRui( Hud_GetChild( file.titan.titanDisplays[i], "ButtonWeaponMod1" )), 
      "buttonImage", 
      file.titan.titans[i].kit1.images[file.titan.titans[i].selectedKit1] )     


    RuiSetImage( 
      Hud_GetRui( Hud_GetChild( file.titan.titanDisplays[i], "ButtonWeaponSight" )), 
      "buttonImage", 
      file.titan.titans[i].kit2.images[file.titan.titans[i].selectedKit2] )  
  }
}

void function reloadBoostScreen() {
  for(int i = 0; i < file.titan.titanDisplays.len();i++) {
    RuiSetImage( 
      Hud_GetRui( Hud_GetChild( file.titan.titanDisplays[i], "ButtonWeapon" )), 
      "buttonImage", 
      file.titan.titans[i].image )

    RuiSetImage( 
      Hud_GetRui( Hud_GetChild( file.titan.titanDisplays[i] ,"ButtonFrame")),
     "basicImage", 
     file.titan.titans[i].image )  

    RuiSetImage( 
      Hud_GetRui( Hud_GetChild( file.titan.titanDisplays[i], "ButtonWeaponMod0" )), 
      "buttonImage", 
      file.titan.titans[i].kit0.images[file.titan.titans[i].selectedKit0] )

    RuiSetImage( 
      Hud_GetRui( Hud_GetChild( file.titan.titanDisplays[i], "ButtonWeaponMod1" )), 
      "buttonImage", 
      file.titan.titans[i].kit1.images[file.titan.titans[i].selectedKit1] )     


    RuiSetImage( 
      Hud_GetRui( Hud_GetChild( file.titan.titanDisplays[i], "ButtonWeaponSight" )), 
      "buttonImage", 
      file.titan.titans[i].kit2.images[file.titan.titans[i].selectedKit2] )  
  }
}

void function initPilot() 
{
  PilotDisplay pilot = file.pilot
  pilot.loadoutDisplay = file.loadoutDisplays[0]

  var lableOne = Hud_GetChild( file.pilot.loadoutDisplay, "TacticalName" )
  SetLabelRuiText( lableOne, Localize("#MODE_SETTING_BAN_PILOT_TACTIAL") )

  var lableTwo = Hud_GetChild( file.pilot.loadoutDisplay, "OrdnanceName" )
  SetLabelRuiText( lableTwo, Localize("#MODE_SETTING_BAN_PILOT_ORDINANCE") )

  pilot.attributes["cloak"]   <- createBoolAttributte($"rui/pilot_loadout/suit/geist")
  pilot.attributes["pulse"]   <- createBoolAttributte($"rui/pilot_loadout/suit/medium")
  pilot.attributes["grapple"] <- createBoolAttributte($"rui/pilot_loadout/suit/grapple")
  pilot.attributes["stim"]    <- createBoolAttributte($"rui/pilot_loadout/suit/nomad")
  pilot.attributes["a-wall"]  <- createBoolAttributte($"rui/pilot_loadout/suit/heavy")
  pilot.attributes["holo"]    <- createBoolAttributte($"rui/pilot_loadout/suit/light")
  pilot.attributes["phase"]   <- createBoolAttributte($"rui/pilot_loadout/suit/stalker")

  pilot.attributes["grenade"]       <- createBoolAttributte( $"rui/pilot_loadout/ordnance/frag_menu")
  pilot.attributes["arcGerande"]    <- createBoolAttributte($"rui/pilot_loadout/ordnance/arc_grenade_menu")
  pilot.attributes["firestar"]      <- createBoolAttributte($"rui/pilot_loadout/ordnance/firestar_menu")
  pilot.attributes["gravstar"]      <- createBoolAttributte( $"rui/pilot_loadout/ordnance/gravity_grenade_menu")
  pilot.attributes["electricSmoke"] <- createBoolAttributte($"rui/pilot_loadout/ordnance/electric_smoke_menu")
  pilot.attributes["satchel"]       <- createBoolAttributte($"rui/pilot_loadout/ordnance/satchel_menu")

  foreach(var button in GetElementsByClassname( file.menu, "PilotLoadoutPanelButtonClass" ))
  {
    string buttonId = Hud_GetScriptID( button )

    RuiSetImage( Hud_GetRui( button  ), "buttonImage",  pilot.attributes[buttonId].image)
    AddButtonEventHandler( button, UIE_CLICK, callPilotButtonClick )
  }

}

BoolAttributte function createBoolAttributte( asset image) 
{
    BoolAttributte attribute
    attribute.image = image
    return attribute
}

void function initWeapon() 
{
  WeaponDisplay weapon = file.weapon
  weapon.loadoutDisplay = file.loadoutDisplays[1]
  weapon.weaponDisplays = GetElementsByClassname( file.menu, "weaponDisplay")

  weapon.buttons = GetElementsByClassname( file.menu, "BanWeaponCategoryButton" )

  ArrayAttribute defaultMod
  defaultMod.images = [
    $"rui/menu/common/unlock_random",
    $"rui/pilot_loadout/mods/extended_ammo",
    $"rui/pilot_loadout/mods/gunrunner",
    $"rui/pilot_loadout/kit/speed_loader",
    $"rui/pilot_loadout/mods/gun_ready",
    $"rui/pilot_loadout/mods/speed_transition",
    $"rui/pilot_loadout/mods/tactikill",
    $"ui/menu/items/mod_icons/none"]
  defaultMod.values = [
    "undefined",
    "extended_ammo",
    "gunrunner",
    "speed_loader",
    "gun_ready",
    "speed_transition",
    "tactikill",
    "none"]

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  WeaponCategory ar
  ar.displayName = "#MENU_TITLE_AR"

  ArrayAttribute arVisor
  arVisor.images = [
    $"rui/menu/common/unlock_random",
    $"r2_ui/menus/loadout_icons/attachments/iron_sights",
    $"r2_ui/menus/loadout_icons/attachments/hcog_ranger",
    $"r2_ui/menus/loadout_icons/attachments/hcog" ,
    $"r2_ui/menus/loadout_icons/attachments/threat_scope"]
  arVisor.values = [
    "undefined",
    "iron_sights",
    "hcog_ranger",
    "hcog",
    "threat_scope"]

  ar.weapons.append(createWeapon(
    "r201",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_r102",
    defaultMod,
    defaultMod,
    arVisor))

  ArrayAttribute r101Visor = {
      images = [
        $"rui/menu/common/unlock_random",
        $"r2_ui/menus/loadout_icons/attachments/aog",
        $"r2_ui/menus/loadout_icons/attachments/hcog_ranger",
        $"r2_ui/menus/loadout_icons/attachments/hcog" ,
        $"r2_ui/menus/loadout_icons/attachments/threat_scope"],
      values = [
        "undefined",
        "aog",
        "hcog_ranger",
        "hcog",
        "threat_scope"]   
    }  
  ar.weapons.append(createWeapon(
    "r101",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_r101_aog",
    defaultMod,
    defaultMod,
    r101Visor
    ))
  ar.weapons.append(createWeapon(
    "hemlok",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_hemlok",
    defaultMod,
    defaultMod,
    arVisor))
  ar.weapons.append(createWeapon(
    "g2",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_g2a5",
    defaultMod,
    defaultMod,
    arVisor))
  ar.weapons.append(createWeapon(
    "flatline",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_vinson",
    defaultMod,
    defaultMod,
    arVisor))

  weapon.categories.append(ar)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  WeaponCategory smg
  smg.displayName = "#MENU_TITLE_SMG"

  ArrayAttribute smgVisor
  smgVisor.images = [
    $"rui/menu/common/unlock_random",
    $"r2_ui/menus/loadout_icons/attachments/iron_sights",
    $"r2_ui/menus/loadout_icons/attachments/hcog_ranger",
    $"r2_ui/menus/loadout_icons/attachments/holosight" ,
    $"r2_ui/menus/loadout_icons/attachments/threat_scope"]
  smgVisor.values = [
    "undefined",
    "iron_sights",
    "hcog_ranger",
    "holosight",
    "threat_scope"]

  smg.weapons.append(createWeapon(
    "car",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_car",
    defaultMod,
    defaultMod,
    smgVisor))  

  smg.weapons.append(createWeapon(
    "alternator",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_alternator",
    defaultMod,
    defaultMod,
    arVisor))

  smg.weapons.append(createWeapon(
    "volt",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_volt",
    defaultMod,
    defaultMod,
    smgVisor))     

  smg.weapons.append(createWeapon(
    "r97",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_r97n",
    defaultMod,
    defaultMod,
    smgVisor))       

  weapon.categories.append(smg)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  WeaponCategory lmg
  lmg.displayName = "#MENU_TITLE_LMG"

  ArrayAttribute lmgVisor
  lmgVisor.images = [
    $"rui/menu/common/unlock_random",
    $"r2_ui/menus/loadout_icons/attachments/iron_sights",
    $"r2_ui/menus/loadout_icons/attachments/hcog_ranger",
    $"r2_ui/menus/loadout_icons/attachments/aog",
    $"r2_ui/menus/loadout_icons/attachments/threat_scope"]
  lmgVisor.values = [
    "undefined",
    "iron_sights",
    "hcog_ranger",
    "aog",
    "threat_scope"]

  lmg.weapons.append(createWeapon(
    "spitfire",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_spitfire",
    defaultMod,
    defaultMod,
    lmgVisor))   

  lmg.weapons.append(createWeapon(
    "lstar",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_lstar",
    defaultMod,
    defaultMod,
    lmgVisor))  

  lmg.weapons.append(createWeapon(
    "devotion",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_esaw",
    defaultMod,
    defaultMod,
    lmgVisor))      

  weapon.categories.append(lmg)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  WeaponCategory sniper
  sniper.displayName = "#MENU_TITLE_SNIPER"

  ArrayAttribute sniperViser
  sniperViser.images = [
    $"rui/menu/common/unlock_random",
    $"r2_ui/menus/loadout_icons/attachments/iron_sights",
    $"r2_ui/menus/loadout_icons/attachments/variable_zoom",
    $"r2_ui/menus/loadout_icons/attachments/threat_scope",]
  sniperViser.values = [
    "undefined",
    "iron_sights",
    "variable_zoom",
    "threat_scope",]

  ArrayAttribute sniperModOne
  sniperModOne.images = [
    $"rui/menu/common/unlock_random",
    $"rui/pilot_loadout/mods/extended_ammo",
    $"rui/pilot_loadout/kit/speed_loader",
    $"rui/pilot_loadout/mods/gun_ready",
    $"rui/pilot_loadout/mods/speed_transition",
    $"rui/pilot_loadout/mods/tactikill",
    $"rui/pilot_loadout/mods/ricochet",
    $"ui/menu/items/mod_icons/none"]
  sniperModOne.values = [
    "undefined",
    "extended_ammo",
    "speed_loader",
    "gun_ready",
    "speed_transition",
    "tactikill",
    "ricochet",
    "none"]

  ArrayAttribute sniperModTwo
  sniperModTwo.images = [
    $"rui/menu/common/unlock_random",
    $"rui/pilot_loadout/mods/extended_ammo",
    $"rui/pilot_loadout/kit/speed_loader",
    $"rui/pilot_loadout/mods/gun_ready",
    $"rui/pilot_loadout/mods/speed_transition",
    $"rui/pilot_loadout/mods/tactikill",
    $"ui/menu/items/mod_icons/none"]
  sniperModTwo.values = [
    "undefined",
    "extended_ammo",
    "speed_loader",
    "gun_ready",
    "speed_transition",
    "tactikill",
    "none"]    

  sniper.weapons.append(createWeapon(
    "kraber",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_kraber",
    sniperModOne,
    sniperModOne,
    sniperViser))   

  sniper.weapons.append(createWeapon(
    "doubletake",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_doubletake",
    sniperModOne,
    sniperModOne,
    sniperViser))

  sniper.weapons.append(createWeapon(
    "dmr",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_longbow",
    sniperModTwo,
    sniperModTwo,
    sniperViser)) 
  //Sniper don't have run and gun
  weapon.categories.append(sniper)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  WeaponCategory shotgun
  shotgun.displayName = "#MENU_TITLE_SHOTGUN"

  shotgun.weapons.append(createWeapon(
    "eva",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_eva8",
    defaultMod,
    defaultMod,
    smgVisor)) 

  shotgun.weapons.append(createWeapon(
    "mastiff",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_mastiff",
    defaultMod,
    defaultMod,
    smgVisor)) 
  
  weapon.categories.append(shotgun)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  WeaponCategory grenadier
  grenadier.displayName = "#MENU_TITLE_GRENADIER"

  grenadier.weapons.append(createWeaponNoVisor(
    "smr",
    $"r2_ui/menus/loadout_icons/anti_titan/at_sidewinder",
    defaultMod,
    defaultMod)) 

  grenadier.weapons.append(createWeaponNoVisor(
    "epg",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_epg1",
    defaultMod,
    defaultMod)) 

  grenadier.weapons.append(createWeaponNoVisor(
    "softball",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_softball",
    defaultMod,
    defaultMod)) 

  grenadier.weapons.append(createWeaponNoVisor(
    "coldwar",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_coldwar",
    defaultMod,
    defaultMod)) 

  weapon.categories.append(grenadier)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  WeaponCategory handgun
  handgun.displayName = "#MENU_TITLE_HANDGUN"

  ArrayAttribute handgunMod
  handgunMod.images = [
    $"rui/menu/common/unlock_random",
    $"rui/pilot_loadout/mods/extended_ammo",
    $"r2_ui/menus/loadout_icons/attachments/suppressor",
    $"rui/pilot_loadout/mods/gunrunner",
    $"rui/pilot_loadout/kit/speed_loader",
    $"rui/pilot_loadout/mods/gun_ready",
    $"rui/pilot_loadout/mods/tactikill",
    $"ui/menu/items/mod_icons/none"]
  handgunMod.values = [
    "undefined",
    "extended_ammo",
    "suppressor",
    "gunrunner",
    "speed_loader",
    "gun_ready",
    "tactikill",
    "none"]

  ArrayAttribute wingmanMod
  wingmanMod.images = [
    $"rui/menu/common/unlock_random",
    $"rui/pilot_loadout/mods/extended_ammo",
    $"rui/pilot_loadout/mods/ricochet",
    $"rui/pilot_loadout/mods/gunrunner",
    $"rui/pilot_loadout/kit/speed_loader",
    $"rui/pilot_loadout/mods/gun_ready",
    $"rui/pilot_loadout/mods/tactikill",
    $"ui/menu/items/mod_icons/none"]
  wingmanMod.values = [
    "undefined",
    "extended_ammo",
    "ricochet",
    "gunrunner",
    "speed_loader",
    "gun_ready",
    "tactikill",
    "none"]

  handgun.weapons.append(createWeaponNoVisor(
    "wingman_elite",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_wingman_elite",
    wingmanMod,
    wingmanMod)) 

  handgun.weapons.append(createWeaponNoVisor(
    "mozambique",
    $"r2_ui/menus/loadout_icons/secondary_weapon/secondary_mozambique",
    handgunMod,
    handgunMod)) 

  handgun.weapons.append(createWeaponNoVisor(
    "re45",
    $"r2_ui/menus/loadout_icons/secondary_weapon/secondary_autopistol",
    handgunMod,
    handgunMod)) 

  handgun.weapons.append(createWeaponNoVisor(
    "p2016",
    $"r2_ui/menus/loadout_icons/secondary_weapon/secondary_hammondp2011",
    handgunMod,
    handgunMod)) 

  handgun.weapons.append(createWeaponNoVisor(
    "b3",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_wingman_m",
    handgunMod,
    handgunMod))  

  weapon.categories.append(handgun)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  WeaponCategory antiTitan
  antiTitan.displayName = "#MENU_TITLE_ANTI_TITAN"

  ArrayAttribute antiTitanMod
  antiTitanMod.images = [
    $"rui/menu/common/unlock_random",
    $"rui/pilot_loadout/mods/extended_ammo",
    $"rui/pilot_loadout/mods/gunrunner",
    $"rui/pilot_loadout/kit/speed_loader",
    $"rui/pilot_loadout/mods/speed_transition",
    $"ui/menu/items/mod_icons/none"]
  antiTitanMod.values = [
    "undefined",
    "extended_ammo",
    "speed_loader",
    "gun_ready",
    "speed_transition",
    "none"]

  ArrayAttribute chargerifleMod
  chargerifleMod.images = [
    $"rui/menu/common/unlock_random",
    $"rui/pilot_loadout/mods/extended_ammo",
    $"rui/pilot_loadout/mods/charge_hack",
    $"rui/pilot_loadout/mods/gun_ready",
    $"rui/pilot_loadout/mods/speed_transition",
    $"ui/menu/items/mod_icons/none"]
  chargerifleMod.values = [
    "undefined",
    "extended_ammo",
    "charge_hack",
    "speed_loader",
    "gun_ready",
    "none"]

  antiTitan.weapons.append(createWeaponNoVisor(
    "chargerifle",
    $"r2_ui/menus/loadout_icons/anti_titan/at_defenderc",
    chargerifleMod,
    chargerifleMod)) 

  antiTitan.weapons.append(createWeaponNoVisor(
    "mgl",
    $"r2_ui/menus/loadout_icons/anti_titan/at_mgl",
    antiTitanMod,
    antiTitanMod))  

  antiTitan.weapons.append(createWeaponNoVisor(
    "thunderbolt",
    $"r2_ui/menus/loadout_icons/anti_titan/at_arcball",
    antiTitanMod,
    antiTitanMod)) 

  antiTitan.weapons.append(createWeaponNoVisor(
    "archer",
    $"r2_ui/menus/loadout_icons/anti_titan/at_archer",
    antiTitanMod,
    antiTitanMod))   

  weapon.categories.append(antiTitan)      
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  for(int i = 0; i < weapon.buttons.len() ; i++) 
  {
    RHud_SetText( weapon.buttons[i], Localize(weapon.categories[i].displayName) )
    AddButtonEventHandler( weapon.buttons[i], UIE_CLICK, changeWeaponDisplay )
	}

  array<var> weaponButton = GetElementsByClassname( file.menu, "WeaponLoadoutPanelButtonClass" )

  for(int i = 0; i < weaponButton.len(); i++) {
    AddButtonEventHandler( weaponButton[i], UIE_CLICK, callWeaponButtonClick )
  }  
  
  array<var> modTypeButtons = GetElementsByClassname( file.menu, "HideWhenEditing_0" )

  for(int i = 0; i < modTypeButtons.len(); i++) {
    AddButtonEventHandler( modTypeButtons[i], UIE_CLICK, clickOpenSubMenu )
  }    



  selectButton(weapon.buttons, 1, 0)
  changeWeaponDisplay(weapon.buttons[0])
}

Weapon function createWeapon(string name, asset image, ArrayAttribute mod0, ArrayAttribute mod1, ArrayAttribute visor) 
{
  Weapon weapon
  weapon.image = image
  weapon.disabled = false
  weapon.selectedMod0 = 0
  weapon.selectedMod1 = 0
  weapon.selectedVisor = 0
  weapon.name = name
  weapon.mod0 = mod0
  weapon.mod1 = mod1
  weapon.visor = visor

  return weapon
}

Weapon function createWeaponNoVisor(string name, asset image, ArrayAttribute mod0, ArrayAttribute mod1) 
{
  ArrayAttribute visor 

  Weapon weapon
  weapon.image = image
  weapon.disabled = false
  weapon.selectedMod0 = 0
  weapon.selectedMod1 = 0
  weapon.selectedVisor = 0
  weapon.name = name
  weapon.mod0 = mod0
  weapon.mod1 = mod1
  weapon.visor = visor

  return weapon
}

void function initTitan() 
{
  TitanDisplay titan = file.titan

  titan.loadoutDisplay = file.loadoutDisplays[2]

  var lableOne = Hud_GetChild( file.titan.loadoutDisplay, "TitanName" )
  SetLabelRuiText( lableOne, Localize("#MODE_SETTING_BAN_TITAN") )

  titan.titanDisplays = GetElementsByClassname( file.menu, "titanDisplay")

  ArrayAttribute fallKit
  fallKit.images = [
    $"rui/menu/common/unlock_random",
    $"rui/titan_loadout/passive/titanfall_kit_bubbleshield",
    $"rui/titan_loadout/passive/titanfall_kit_warpfall"]
  fallKit.values = [
    "undefined"
    "bubbleshield",
    "warpfall"
  ]

  ArrayAttribute titanKit
  titanKit.images = [
    $"rui/menu/common/unlock_random",
    $"rui/titan_loadout/passive/assault_chip",
    $"rui/titan_loadout/passive/auto_eject",
    $"rui/titan_loadout/passive/dash_plus",
    $"rui/titan_loadout/passive/overcore",
    $"rui/titan_loadout/passive/nuke_eject",
    $"rui/titan_loadout/passive/improved_anti_rodeo"]
  titanKit.values = [
    "undefined",
    "assault_chip",
    "auto_eject",
    "dash_plus",
    "overcore",
    "nuke_eject",
    "improved_anti_rodeo"
  ]

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  Titan ion
  ion.name = "ion"
  ion.image = $"rui/callsigns/callsign_fd_ion_hard"
  ion.disabled = false
  ion.selectedKit0 = 0
  ion.selectedKit1 = 0
  ion.selectedKit2 = 0
  ArrayAttribute ionKit
  ionKit.images = [
    $"rui/menu/common/unlock_random",
    $"rui/titan_loadout/passive/ion_entangled_energy",
    $"rui/titan_loadout/passive/ion_zero_point_tripwire",
    $"rui/titan_loadout/passive/ion_vortex_amp",
    $"rui/titan_loadout/passive/ion_grand_canon",
    $"rui/titan_loadout/passive/ion_diffraction_lens"
  ]
  ionKit.values = [
    "undefined",
    "ion_entangled_energy",
    "ion_zero_point_tripwire",
    "ion_vortex_amp",
    "ion_grand_canon",
    "ion_diffraction_lens"
  ]
  ion.kit0 = ionKit
  ion.kit1 = titanKit
  ion.kit2 = fallKit

  titan.titans.append(ion)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  

  Titan scorch
  scorch.name = "scorch"
  scorch.image = $"rui/callsigns/callsign_fd_scorch_hard"
  scorch.disabled = false
  scorch.selectedKit0 = 0
  scorch.selectedKit1 = 0
  scorch.selectedKit2 = 0
  ArrayAttribute scorchKit
  scorchKit.images = [
    $"rui/menu/common/unlock_random",
    $"rui/titan_loadout/passive/scorch_wildfire_launcher",
    $"rui/titan_loadout/passive/scorch_fuel",
    $"rui/titan_loadout/passive/scorch_scorched_earth",
    $"rui/titan_loadout/passive/scorch_inferno_shield",
    $"rui/titan_loadout/passive/scorch_tempered_plating"
  ]
  scorchKit.values = [
    "undefined",
    "scorch_wildfire_launcher",
    "scorch_fuel",
    "scorch_scorched_earth",
    "scorch_inferno_shield",
    "scorch_tempered_plating"
  ]
  scorch.kit0 = scorchKit
  scorch.kit1 = titanKit
  scorch.kit2 = fallKit

  titan.titans.append(scorch)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  
  Titan northstar
  northstar.name = "northstar"
  northstar.image = $"rui/callsigns/callsign_fd_northstar_hard"
  northstar.disabled = false
  northstar.selectedKit0 = 0
  northstar.selectedKit1 = 0
  northstar.selectedKit2 = 0
  ArrayAttribute northstarKit
  northstarKit.images = [
    $"rui/menu/common/unlock_random",
    $"rui/titan_loadout/passive/northstar_piercing_shot",
    $"rui/titan_loadout/passive/northstar_enhanced_payload",
    $"rui/titan_loadout/passive/northstar_twin_trap",
    $"rui/titan_loadout/passive/northstar_viper_thrusters",
    $"rui/titan_loadout/passive/northstar_threat_optics"
  ]
  northstarKit.values = [
    "undefined",
    "northstar_piercing_shot",
    "northstar_enhanced_payload",
    "northstar_twin_trap",
    "northstar_viper_thrusters",
    "northstar_threat_optics"
  ]
  northstar.kit0 = northstarKit
  northstar.kit1 = titanKit
  northstar.kit2 = fallKit

  titan.titans.append(northstar)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  

  Titan ronin
  ronin.name = "ronin"
  ronin.image = $"rui/callsigns/callsign_fd_ronin_hard"
  ronin.disabled = false
  ronin.selectedKit0 = 0
  ronin.selectedKit1 = 0
  ronin.selectedKit2 = 0
  ArrayAttribute roninKit
  roninKit.images = [
    $"rui/menu/common/unlock_random",
    $"rui/titan_loadout/passive/ronin_ricochet_round",
    $"rui/titan_loadout/passive/ronin_thunderstorm",
    $"rui/titan_loadout/passive/ronin_temporal_anomaly",
    $"rui/titan_loadout/passive/ronin_highlander",
    $"rui/titan_loadout/passive/ronin_auto_shift"
  ]
  roninKit.values = [
    "undefined",
    "ronin_ricochet_round",
    "ronin_thunderstorm",
    "ronin_temporal_anomaly",
    "ronin_highlander",
    "ronin_auto_shift"
  ]
  ronin.kit0 = roninKit
  ronin.kit1 = titanKit
  ronin.kit2 = fallKit

  titan.titans.append(ronin)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  Titan tone
  tone.name = "tone"
  tone.image = $"rui/callsigns/callsign_fd_tone_hard"
  tone.disabled = false
  tone.selectedKit0 = 0
  tone.selectedKit1 = 0
  tone.selectedKit2 = 0
  ArrayAttribute toneKit
  toneKit.images = [
    $"rui/menu/common/unlock_random",
    $"rui/titan_loadout/passive/tone_enhanced_tracker",
    $"rui/titan_loadout/passive/tone_reinforced_partical_wall",
    $"rui/titan_loadout/passive/tone_pulse_echo",
    $"rui/titan_loadout/passive/tone_rocket_barrage",
    $"rui/titan_loadout/passive/tone_40mm_burst"
  ]
  toneKit.values = [
    "undefined",
    "tone_enhanced_tracker",
    "tone_reinforced_partical_wall",
    "tone_pulse_echo",
    "tone_rocket_barrage",
    "tone_40mm_burst"
  ]
  tone.kit0 = toneKit
  tone.kit1 = titanKit
  tone.kit2 = fallKit

  titan.titans.append(tone)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  Titan legion
  legion.name = "legion"
  legion.image = $"rui/callsigns/callsign_fd_legion_hard"
  legion.disabled = false
  legion.selectedKit0 = 0
  legion.selectedKit1 = 0
  legion.selectedKit2 = 0
  ArrayAttribute legionKit
  legionKit.images = [
    $"rui/menu/common/unlock_random",
    $"rui/titan_loadout/passive/legion_enhanced_ammo",
    $"rui/titan_loadout/passive/legion_sensor_array",
    $"rui/titan_loadout/passive/legion_bulwark",
    $"rui/titan_loadout/passive/legion_lightweight_alloys",
    $"rui/titan_loadout/passive/legion_siege_mode"
  ]
  legionKit.values = [
    "undefined",
    "legion_enhanced_ammo",
    "legion_sensor_array",
    "legion_bulwark",
    "legion_lightweight_alloys",
    "legion_siege_mode"
  ]
  legion.kit0 = legionKit
  legion.kit1 = titanKit
  legion.kit2 = fallKit

  titan.titans.append(legion)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  Titan monarch
  monarch.name = "monarch"
  monarch.image = $"rui/callsigns/callsign_fd_monarch_hard"
  monarch.disabled = false
  monarch.selectedKit0 = 0
  monarch.selectedKit1 = 0
  monarch.selectedKit2 = 0
  ArrayAttribute monarchKit
  monarchKit.images = [
    $"rui/menu/common/unlock_random",
    $"rui/titan_loadout/passive/vanguard_fittest",
    $"rui/titan_loadout/passive/vanguard_siphon",
    $"rui/titan_loadout/passive/vanguard_survivor",
    $"rui/titan_loadout/passive/vanguard_rearm"
  ]
  monarchKit.values = [
    "undefined",
    "vanguard_fittest",
    "vanguard_siphon",
    "vanguard_survivor",
    "vanguard_rearm"
  ]
  monarch.kit0 = monarchKit
  monarch.kit1 = titanKit
  monarch.kit2 = fallKit

  titan.titans.append(monarch)

  Titan monarchCores
  monarchCores.name = "monarchCores"
  monarchCores.image = $"rui/callsigns/callsign_fd_monarch_hard"
  monarchCores.disabled = false
  monarchCores.selectedKit0 = 0
  monarchCores.selectedKit1 = 0
  monarchCores.selectedKit2 = 0
  ArrayAttribute monarchCore0
  monarchCore0.images = [
    $"rui/menu/common/unlock_random",
    $"rui/titan_loadout/passive/monarch_core_arc_rounds",
    $"rui/titan_loadout/passive/monarch_core_energy_field",
    $"rui/titan_loadout/passive/monarch_core_missile_racks"
  ]
  monarchCore0.values = [
    "undefined",
    "monarch_core_arc_rounds",
    "monarch_core_energy_field",
    "monarch_core_missile_racks"
  ]
  ArrayAttribute monarchCore1
  monarchCore1.images = [
    $"rui/menu/common/unlock_random",
    $"rui/titan_loadout/passive/monarch_core_swift_rearm",
    $"rui/titan_loadout/passive/monarch_core_maelstrom",
    $"rui/titan_loadout/passive/monarch_core_energy_transfer"
  ]
  monarchCore1.values = [
    "undefined",
    "monarch_core_swift_rearm",
    "monarch_core_maelstrom",
    "monarch_core_energy_transfer"
  ]
  ArrayAttribute monarchCore2
  monarchCore2.images = [
    $"rui/menu/common/unlock_random",
    $"rui/titan_loadout/passive/monarch_core_multi_target",
    $"rui/titan_loadout/passive/monarch_core_superior_chassis",
    $"rui/titan_loadout/passive/monarch_core_xo16"
  ]
  monarchCore2.values = [
    "undefined",
    "monarch_core_multi_target",
    "monarch_core_superior_chassis",
    "monarch_core_xo16"
  ]
  monarchCores.kit0 = monarchCore0
  monarchCores.kit1 = monarchCore1
  monarchCores.kit2 = monarchCore2

  titan.titans.append(monarchCores)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  

  reloadTitanScreen()
}

void function initBoost() 
{
  BoostDisplay boost = file.boost

  boost.loadoutDisplay = file.loadoutDisplays[3]

  var lableOne = Hud_GetChild( file.boost.loadoutDisplay, "BoostName" )
  SetLabelRuiText( lableOne, Localize("#MODE_SETTING_BAN_BOOST") )

  boost.boosts["amped_weapons"]         <- createBoolAttributte($"rui/menu/boosts/boost_amped_weapons")
  boost.boosts["ticks"]                 <- createBoolAttributte($"rui/menu/boosts/boost_ticks")
  boost.boosts["antipersonnel_sentry"]  <- createBoolAttributte($"rui/menu/boosts/boost_antipersonnel_sentry")
  boost.boosts["map_hack"]              <- createBoolAttributte($"rui/menu/boosts/boost_map_hack")
  boost.boosts["battery"]               <- createBoolAttributte($"rui/menu/boosts/boost_battery")
  boost.boosts["radar_jammer"]          <- createBoolAttributte($"rui/menu/boosts/boost_radar_jammer")
  boost.boosts["antititan_sentry"]      <- createBoolAttributte($"rui/menu/boosts/boost_antititan_sentry")
  boost.boosts["smart_pistol"]          <- createBoolAttributte($"rui/menu/boosts/boost_smart_pistol")
  boost.boosts["phase_rewind"]          <- createBoolAttributte($"rui/menu/boosts/boost_phase_rewind")
  boost.boosts["shield"]                <- createBoolAttributte($"rui/menu/boosts/boost_shield")
  boost.boosts["holo_pilots"]           <- createBoolAttributte($"rui/menu/boosts/boost_holo_pilots")
  boost.boosts["random"]                <- createBoolAttributte($"rui/menu/boosts/boost_random")

  foreach(var button in GetElementsByClassname( file.menu, "BoostLoadoutPanelButtonClass" ))
  {
    string buttonId = Hud_GetScriptID( button )

    RuiSetImage( Hud_GetRui( button  ), "buttonImage",  boost.boosts[buttonId].image)
    AddButtonEventHandler( button, UIE_CLICK, callBoostClick )
  }
}
