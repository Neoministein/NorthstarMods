global function AddNorthstarCustomMatchSettingsBanMenu

struct BoolAttributte {
  bool disabled = false
  asset image
}

struct ArrayAttribute {
    array<asset> images
    array<string> values
}

struct Loadout {
    string name
    asset image
    bool disabled = false

    int selectedAtr0 = 0
    int selectedAtr1 = 0
    int selectedAtr2 = 0

    ArrayAttribute &atr0
    ArrayAttribute &atr1 
    ArrayAttribute &atr2
}

struct Category {
    string displayName

    array<Loadout> loadouts
}

struct PilotDisplay {
  var loadoutDisplay

  table<string ,BoolAttributte> attributes 
} 

struct LoadoutDisplay {
  var loadoutDisplay

  int categorySelected = 1
  int selectedAttribute
  int selectedLoadout

  array<var> buttons = []
  array<Category> categories
  array<var> displays 
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
  LoadoutDisplay weapon
  LoadoutDisplay titan
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
  AddMenuFooterOption(file.menu, BUTTON_A, "#A_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", callRestoreDefaults )
  AddMenuFooterOption(file.menu, BUTTON_Y, "#Y_BAN_ALL", "#BAN_ALL", callBanAll )

  AddButtonEventHandler( Hud_GetChild(file.menu, "Export"), UIE_CLICK, exportConfigToString )
  AddButtonEventHandler( Hud_GetChild(file.menu, "Import"), UIE_CLICK, importConfigToString )
  
  file.loadoutDisplays = GetElementsByClassname( file.menu, "loadoutDisplay" )
  
  initPilot()
  initWeapon()
  initTitan()
  initBoost()

  file.buttons = GetElementsByClassname( file.menu, "BanSettingCategoryButton" )
  RHud_SetText( file.buttons[0], Localize("#MODE_SETTING_BAN_PILOT") )
  RHud_SetText( file.buttons[1], Localize("#MODE_SETTING_BAN_WEAPON") )
  RHud_SetText( file.buttons[2], Localize("#MODE_SETTING_BAN_TITAN") )
  RHud_SetText( file.buttons[3], Localize("#MODE_SETTING_BAN_BOOST") )

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
  int currentlySelected = 0

  //This defines the screen which calls this button so that weapons and titans can use the same logic
  LoadoutDisplay loadout
  if (file.selected == 1) { 
    loadout = file.weapon
  } else if (file.selected == 2) { 
    loadout = file.titan
  }

  loadout.selectedAttribute = buttonSelected
  loadout.selectedLoadout = uiElementId

  if (0 == buttonSelected) {
    items = loadout.categories[loadout.categorySelected].loadouts[uiElementId].atr0.images
    currentlySelected = loadout.categories[loadout.categorySelected].loadouts[uiElementId].selectedAtr0
  } else if (1 == buttonSelected) {
    items = loadout.categories[loadout.categorySelected].loadouts[uiElementId].atr1.images
    currentlySelected = loadout.categories[loadout.categorySelected].loadouts[uiElementId].selectedAtr1
  } else {
    items = loadout.categories[loadout.categorySelected].loadouts[uiElementId].atr2.images
    currentlySelected = loadout.categories[loadout.categorySelected].loadouts[uiElementId].selectedAtr2
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
    Hud_SetSelected( button, false )

    if (i < items.len()) {
		  Hud_SetEnabled( button, true )
      RuiSetBool( rui, "isVisible", true )
      RuiSetImage( rui, "buttonImage", items[i] )
    } else {
		  Hud_SetEnabled( button, false )
      RuiSetBool( rui, "isVisible", false )
    }
  }

  Hud_SetSelected( buttons[rearangeButtonTwoInt(currentlySelected)], true )

  HideSubmenuBackgroundElems()
  thread RestoreHiddenElemsOnMenuChange()
}

void function clickSelectInSubmenu(var pressedButton) 
{
  int modSelected = rearangeIntToButton(int(Hud_GetScriptID( pressedButton )))

  LoadoutDisplay loadout
  //This defines the screen which calls this button so that weapons and titans can use the same logic
  if (file.selected == 1) {
    loadout = file.weapon
  } else {
    loadout = file.titan
  }

  if (0 == loadout.selectedAttribute) {
    loadout.categories[file.weapon.categorySelected].loadouts[loadout.selectedLoadout].selectedAtr0 = modSelected
  } else if (1 == file.weapon.selectedAttribute) {
    loadout.categories[file.weapon.categorySelected].loadouts[loadout.selectedLoadout].selectedAtr1 = modSelected
  } else {
    loadout.categories[file.weapon.categorySelected].loadouts[loadout.selectedLoadout].selectedAtr2 = modSelected
  }
  reloadCurrentScreen()
  
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
    elems = GetElementsByClassname( file.menu, "HideWhenEditing_" + file.weapon.selectedAttribute )
    subLoadout = file.weapon.selectedLoadout
  } else {
    elems = GetElementsByClassname( file.menu, "HideWhenEditing_" + file.titan.selectedAttribute )
    subLoadout = file.titan.selectedLoadout
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


    reloadCurrentScreen()
  }
}

void function reloadCurrentScreen() 
{
    if (file.selected == 0) {
      reloadPilotScreen()
    } else if(file.selected == 1) {
      loadWeaponCategory(file.weapon.categories[file.weapon.categorySelected])
    } else if (file.selected == 2) {
      loadTitanCategory(file.titan.categories[file.titan.categorySelected])
    } else if (file.selected == 3) {
      reloadBoostScreen()
    }
    RestoreHiddenSubmenuBackgroundElems()
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
  int id = int(Hud_GetScriptID( Hud_GetParent( pressedButton ) ) )
  bool state
  if(file.selected == 1) 
  {
    state = !file.weapon.categories[file.weapon.categorySelected].loadouts[id].disabled
    file.weapon.categories[file.weapon.categorySelected].loadouts[id].disabled = state
  } 
  else 
  {
    state = !file.titan.categories[file.titan.categorySelected].loadouts[id].disabled
    file.titan.categories[file.titan.categorySelected].loadouts[id].disabled = state
  } 
  Hud_SetSelected( pressedButton , state )
}

void function callRestoreDefaults(var pressedButton) 
{
  setAllAttributes(true)
}

void function callBanAll(var pressedButton) 
{
  setAllAttributes(false)
}

void function switchBoolAttribute(var button, BoolAttributte attribute)
{
  attribute.disabled = !attribute.disabled
  Hud_SetSelected( button , attribute.disabled )
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

void function loadWeaponCategory(Category category) 
{
  for(int i = 0; i < file.weapon.displays.len();i++) {
      if(i < category.loadouts.len()) {

        Hud_SetSelected( Hud_GetChild( file.weapon.displays[i], "ButtonWeapon" ) , category.loadouts[i].disabled )

        RuiSetImage( 
          Hud_GetRui( Hud_GetChild( file.weapon.displays[i], "ButtonWeapon" )), 
          "buttonImage", 
          category.loadouts[i].image )

        RuiSetImage( 
          Hud_GetRui( Hud_GetChild( file.weapon.displays[i], "ButtonWeaponMod0" )), 
          "buttonImage", 
          category.loadouts[i].atr0.images[category.loadouts[i].selectedAtr0] )

        RuiSetImage( 
          Hud_GetRui( Hud_GetChild( file.weapon.displays[i], "ButtonWeaponMod1" )), 
          "buttonImage", 
          category.loadouts[i].atr1.images[category.loadouts[i].selectedAtr1] )     

        if (category.loadouts[i].atr2.images.len() > 0) {
          RuiSetImage( 
            Hud_GetRui( Hud_GetChild( file.weapon.displays[i], "ButtonWeaponSight" )), 
            "buttonImage", 
            category.loadouts[i].atr2.images[category.loadouts[i].selectedAtr2] )  

            Hud_SetVisible( Hud_GetChild( file.weapon.displays[i], "ButtonWeaponSight" ) , true )    
        } 
        else 
        {
          Hud_SetVisible( Hud_GetChild( file.weapon.displays[i], "ButtonWeaponSight" ) , false )
        }


        Hud_SetVisible( file.weapon.displays[i] , true )
      } else {
        Hud_SetVisible( file.weapon.displays[i] , false )
      }
  }
}

void function changeTitanDisplay( var pressedButton )
{
  int selected = int( Hud_GetScriptID( pressedButton ))
  if(selected != file.titan.categorySelected) {
    selectButton(file.titan.buttons, file.titan.categorySelected, selected)
    loadTitanCategory(file.titan.categories[selected])
    
    file.titan.categorySelected = selected
  }
}

void function loadTitanCategory(Category category) {
  for(int i = 0; i < file.titan.displays.len();i++) {
    if(i < category.loadouts.len()) {

      Hud_SetSelected( Hud_GetChild( file.titan.displays[i], "ButtonWeapon" ) , category.loadouts[i].disabled )

      RuiSetImage( 
        Hud_GetRui( Hud_GetChild( file.titan.displays[i], "ButtonWeapon" )), 
        "buttonImage", 
        category.loadouts[i].image )

      RuiSetImage( 
        Hud_GetRui( Hud_GetChild( file.titan.displays[i] ,"ButtonFrame")),
        "basicImage", 
        category.loadouts[i].image )  

      RuiSetImage( 
        Hud_GetRui( Hud_GetChild( file.titan.displays[i], "ButtonWeaponMod0" )), 
        "buttonImage", 
        category.loadouts[i].atr0.images[category.loadouts[i].selectedAtr0] )


      RuiSetImage( 
        Hud_GetRui( Hud_GetChild( file.titan.displays[i], "ButtonWeaponMod1" )), 
        "buttonImage", 
        category.loadouts[i].atr1.images[category.loadouts[i].selectedAtr1] )     

      RuiSetImage( 
        Hud_GetRui( Hud_GetChild( file.titan.displays[i], "ButtonWeaponSight" )), 
        "buttonImage", 
        category.loadouts[i].atr2.images[category.loadouts[i].selectedAtr2] )

      //Check if is Monarch Core Abilities
      if(category.loadouts[i].name == "monarchCores") 
      {
        Hud_SetVisible( Hud_GetChild( file.titan.displays[i], "ButtonWeapon" ) , false )
        Hud_SetVisible( Hud_GetChild( file.titan.displays[i] ,"ButtonFrame" ) , false ) 
        
      } 
      else 
      {
        Hud_SetVisible( Hud_GetChild( file.titan.displays[i], "ButtonWeapon" ) , true )
        Hud_SetVisible( Hud_GetChild( file.titan.displays[i] ,"ButtonFrame" ) , true )   
      }  

      Hud_SetVisible( file.titan.displays[i] , true )
      
    } else {
      Hud_SetVisible( file.titan.displays[i] , false )
    }
  }
}

void function reloadBoostScreen() 
{
  foreach(var button in GetElementsByClassname( file.menu, "BoostLoadoutPanelButtonClass" ))
  {
    print(file.boost.boosts[Hud_GetScriptID(button)].disabled)
     Hud_SetSelected( button , file.boost.boosts[Hud_GetScriptID(button)].disabled )
  }
}

void function reloadPilotScreen() 
{
  foreach(var button in GetElementsByClassname( file.menu, "PilotLoadoutPanelButtonClass" ))
  {
    Hud_SetSelected( button , file.pilot.attributes[Hud_GetScriptID(button)].disabled )
  }
}

void function setAllAttributes(bool enabled) 
{
  //Pilot
  foreach(BoolAttributte attribute in file.pilot.attributes)
  {
    attribute.disabled = !enabled
  }
  //Weapon
  for(int i = 0; i < file.weapon.categories.len();i++) 
  {
    for(int j = 0; j < file.weapon.categories[i].loadouts.len(); j++) 
    {
      Loadout weapon = file.weapon.categories[i].loadouts[j]
      weapon.disabled = !enabled
      if(enabled) {
        weapon.selectedAtr0 = 0
        weapon.selectedAtr1 = 0
        weapon.selectedAtr2 = 0
      }
    }
  }
  //Titan
  for(int i = 0; i < file.titan.categories.len(); i++) 
  {
    for(int j = 0; j < file.titan.categories[i].loadouts.len(); j++) 
    {
      Loadout titan = file.titan.categories[i].loadouts[j]
      titan.disabled = !enabled
      if(enabled) {
        titan.selectedAtr0 = 0
        titan.selectedAtr1 = 0
        titan.selectedAtr2 = 0
      }
    }
  }
  //Boost
  foreach(BoolAttributte attribute in file.boost.boosts)
  {
    attribute.disabled = !enabled
  }
  reloadCurrentScreen()
}

void function exportConfigToString(var pressedButton) 
{
  string exportString = ""
  //Pilot
  foreach(BoolAttributte attribute in file.pilot.attributes)
  {
    if(attribute.disabled) {
      exportString += string(1)
    } else {
      exportString += string(0)
    }
  }
  //Weapon
  for(int i = 0; i < file.weapon.categories.len();i++) 
  {
    for(int j = 0; j < file.weapon.categories[i].loadouts.len(); j++) 
    {
      Loadout weapon = file.weapon.categories[i].loadouts[j]
      if(weapon.disabled) {
        exportString += string(1)
      } else {
        exportString += string(0)
      }
      exportString += string(weapon.selectedAtr0)
      exportString += string(weapon.selectedAtr1)
      exportString += string(weapon.selectedAtr2)
    }
  }
  //Titan
  for(int i = 0; i < file.titan.categories.len(); i++) 
  {
    for(int j = 0; j < file.titan.categories[i].loadouts.len(); j++) 
    {
      Loadout titan = file.titan.categories[i].loadouts[j]
      if(titan.disabled) {
        exportString += string(1)
      } else {
        exportString += string(0)
      }
      exportString += string(titan.selectedAtr0)
      exportString += string(titan.selectedAtr1)
      exportString += string(titan.selectedAtr2)
    }
  }
  //Boost
  foreach(BoolAttributte attribute in file.boost.boosts)
  {
    if(attribute.disabled) {
      exportString += string(1)
    } else {
      exportString += string(0)
    }
  }

  Hud_SetText( Hud_GetChild( file.menu, "ImportExportArea" ), exportString )
}

void function importConfigToString(var pressedButton) 
{
  string importString = Hud_GetUTF8Text( Hud_GetChild( file.menu, "ImportExportArea" ) ) 
  array<int> importArray

  if(importString.len() != 177) {
    return
  }
  for(int i = 0; i < importString.len(); i++) {
    if(importString[i] == 55) {
      importArray.append(7)
    } else if(importString[i] == 54) {
      importArray.append(6)
    } else if(importString[i] == 53) {
      importArray.append(5)
    } else if(importString[i] == 52) {
      importArray.append(4)
    } else if(importString[i] == 51) {
      importArray.append(3)
    } else if(importString[i] == 50) {
      importArray.append(2)
    } else if(importString[i] == 49) {
      importArray.append(1)
    } else {
      importArray.append(0)
    }
  }
  int count = 0
  //Pilot
  foreach(BoolAttributte attribute in file.pilot.attributes)
  {
    if(importArray[count++] == 1) {
      attribute.disabled = true
    } else {
      attribute.disabled = false
    }
  }
  
  
  //Weapon
  for(int i = 0; i < file.weapon.categories.len();i++) 
  {
    for(int j = 0; j < file.weapon.categories[i].loadouts.len(); j++) 
    {
      Loadout weapon = file.weapon.categories[i].loadouts[j]

      if(importArray[count++] == 1) {
        weapon.disabled = true
      } else {
        weapon.disabled = false
      }

      weapon.selectedAtr0 = importArray[count++]
      weapon.selectedAtr1 = importArray[count++]
      weapon.selectedAtr2 = importArray[count++]
    }
  }
  
  //Titan
  for(int i = 0; i < file.titan.categories.len(); i++) 
  {
    for(int j = 0; j < file.titan.categories[i].loadouts.len(); j++) 
    {
      Loadout titan = file.titan.categories[i].loadouts[j]
      if(importArray[count++] == 1) {
        titan.disabled = true
      } else {
        titan.disabled = false
      }

      titan.selectedAtr0 = importArray[count++]
      titan.selectedAtr1 = importArray[count++]
      titan.selectedAtr2 = importArray[count++]
    }
  }
  //Boost
  foreach(BoolAttributte attribute in file.boost.boosts)
  {
    print(importArray[count])
    if(importArray[count++] == 1) {
      attribute.disabled = true
    } else {
      attribute.disabled = false
    }
  } 
  reloadCurrentScreen() 
}

void function initPilot() 
{
  PilotDisplay pilot = file.pilot
  pilot.loadoutDisplay = file.loadoutDisplays[0]

  var lableOne = Hud_GetChild( file.pilot.loadoutDisplay, "TacticalName" )
  SetLabelRuiText( lableOne, Localize("#MODE_SETTING_BAN_PILOT_TACTICAL") )

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


  var rui = Hud_GetRui( Hud_GetChild( pilot.loadoutDisplay, "PilotDetails" ) )

	RuiSetString( rui, "nameText", Localize("#MODE_SETTING_BAN_PILOT_LBL_TITLE") )
	RuiSetString( rui, "descText", Localize("#MODE_SETTING_BAN_PILOT_LBL_TEXT") )
}

BoolAttributte function createBoolAttributte( asset image) 
{
    BoolAttributte attribute
    attribute.image = image
    return attribute
}

void function initWeapon() 
{
  LoadoutDisplay weapon = file.weapon
  weapon.loadoutDisplay = file.loadoutDisplays[1]
  weapon.displays = GetElementsByClassname( file.menu, "weaponDisplay")

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
  Category ar
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

  ar.loadouts.append(createWeapon(
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
  ar.loadouts.append(createWeapon(
    "r101",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_r101_aog",
    defaultMod,
    defaultMod,
    r101Visor
    ))
  ar.loadouts.append(createWeapon(
    "hemlok",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_hemlok",
    defaultMod,
    defaultMod,
    arVisor))
  ar.loadouts.append(createWeapon(
    "g2",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_g2a5",
    defaultMod,
    defaultMod,
    arVisor))
  ar.loadouts.append(createWeapon(
    "flatline",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_vinson",
    defaultMod,
    defaultMod,
    arVisor))

  weapon.categories.append(ar)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Category smg
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

  smg.loadouts.append(createWeapon(
    "car",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_car",
    defaultMod,
    defaultMod,
    smgVisor))  

  smg.loadouts.append(createWeapon(
    "alternator",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_alternator",
    defaultMod,
    defaultMod,
    arVisor))

  smg.loadouts.append(createWeapon(
    "volt",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_volt",
    defaultMod,
    defaultMod,
    smgVisor))     

  smg.loadouts.append(createWeapon(
    "r97",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_r97n",
    defaultMod,
    defaultMod,
    smgVisor))       

  weapon.categories.append(smg)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Category lmg
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

  lmg.loadouts.append(createWeapon(
    "spitfire",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_spitfire",
    defaultMod,
    defaultMod,
    lmgVisor))   

  lmg.loadouts.append(createWeapon(
    "lstar",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_lstar",
    defaultMod,
    defaultMod,
    lmgVisor))  

  lmg.loadouts.append(createWeapon(
    "devotion",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_esaw",
    defaultMod,
    defaultMod,
    lmgVisor))      

  weapon.categories.append(lmg)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Category sniper
  sniper.displayName = "#MENU_TITLE_SNIPER"

  ArrayAttribute sniperViser
  sniperViser.images = [
    $"rui/menu/common/unlock_random",
    $"r2_ui/menus/loadout_icons/attachments/stock_scope",
    $"r2_ui/menus/loadout_icons/attachments/variable_zoom",
    $"r2_ui/menus/loadout_icons/attachments/threat_scope",]
  sniperViser.values = [
    "stock_scope",
    "iron_sights",
    "variable_zoom",
    "threat_scope",]

  ArrayAttribute takeViser
  takeViser.images = [
    $"rui/menu/common/unlock_random",
    $"r2_ui/menus/loadout_icons/attachments/stock_doubletake_sight",
    $"r2_ui/menus/loadout_icons/attachments/variable_zoom",
    $"r2_ui/menus/loadout_icons/attachments/threat_scope",]
  takeViser.values = [
    "stock_doubletake_sight",
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

  sniper.loadouts.append(createWeapon(
    "kraber",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_kraber",
    sniperModOne,
    sniperModOne,
    sniperViser))   

  sniper.loadouts.append(createWeapon(
    "doubletake",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_doubletake",
    sniperModOne,
    sniperModOne,
    takeViser))

  sniper.loadouts.append(createWeapon(
    "dmr",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_longbow",
    sniperModTwo,
    sniperModTwo,
    sniperViser)) 
  
  weapon.categories.append(sniper)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Category shotgun
  shotgun.displayName = "#MENU_TITLE_SHOTGUN"

  shotgun.loadouts.append(createWeapon(
    "eva",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_eva8",
    defaultMod,
    defaultMod,
    smgVisor)) 

  shotgun.loadouts.append(createWeapon(
    "mastiff",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_mastiff",
    defaultMod,
    defaultMod,
    smgVisor)) 
  
  weapon.categories.append(shotgun)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Category grenadier
  grenadier.displayName = "#MENU_TITLE_GRENADIER"

  grenadier.loadouts.append(createWeaponNoVisor(
    "smr",
    $"r2_ui/menus/loadout_icons/anti_titan/at_sidewinder",
    defaultMod,
    defaultMod)) 

  grenadier.loadouts.append(createWeaponNoVisor(
    "epg",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_epg1",
    defaultMod,
    defaultMod)) 

  grenadier.loadouts.append(createWeaponNoVisor(
    "softball",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_softball",
    defaultMod,
    defaultMod)) 

  grenadier.loadouts.append(createWeaponNoVisor(
    "coldwar",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_coldwar",
    defaultMod,
    defaultMod)) 

  weapon.categories.append(grenadier)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Category handgun
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

  handgun.loadouts.append(createWeaponNoVisor(
    "wingman_elite",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_wingman_elite",
    wingmanMod,
    wingmanMod)) 

  handgun.loadouts.append(createWeaponNoVisor(
    "mozambique",
    $"r2_ui/menus/loadout_icons/secondary_weapon/secondary_mozambique",
    handgunMod,
    handgunMod)) 

  handgun.loadouts.append(createWeaponNoVisor(
    "re45",
    $"r2_ui/menus/loadout_icons/secondary_weapon/secondary_autopistol",
    handgunMod,
    handgunMod)) 

  handgun.loadouts.append(createWeaponNoVisor(
    "p2016",
    $"r2_ui/menus/loadout_icons/secondary_weapon/secondary_hammondp2011",
    handgunMod,
    handgunMod)) 

  handgun.loadouts.append(createWeaponNoVisor(
    "b3",
    $"r2_ui/menus/loadout_icons/primary_weapon/primary_wingman_m",
    handgunMod,
    handgunMod))  

  weapon.categories.append(handgun)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Category antiTitan
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

  antiTitan.loadouts.append(createWeaponNoVisor(
    "chargerifle",
    $"r2_ui/menus/loadout_icons/anti_titan/at_defenderc",
    chargerifleMod,
    chargerifleMod)) 

  antiTitan.loadouts.append(createWeaponNoVisor(
    "mgl",
    $"r2_ui/menus/loadout_icons/anti_titan/at_mgl",
    antiTitanMod,
    antiTitanMod))  

  antiTitan.loadouts.append(createWeaponNoVisor(
    "thunderbolt",
    $"r2_ui/menus/loadout_icons/anti_titan/at_arcball",
    antiTitanMod,
    antiTitanMod)) 

  antiTitan.loadouts.append(createWeaponNoVisor(
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

  var rui = Hud_GetRui( Hud_GetChild( weapon.loadoutDisplay, "WeaponDetails" ) )

	RuiSetString( rui, "nameText", Localize("#MODE_SETTING_BAN_WEAPON_LBL_TITLE") )
	RuiSetString( rui, "descText", Localize("#MODE_SETTING_BAN_WEAPON_LBL_TEXT") )
}

Loadout function createWeapon(string name, asset image, ArrayAttribute atr0, ArrayAttribute atr1, ArrayAttribute atr2) 
{
  Loadout weapon
  weapon.image = image
  weapon.disabled = false
  weapon.selectedAtr0 = 0
  weapon.selectedAtr1 = 0
  weapon.selectedAtr2 = 0
  weapon.name = name
  weapon.atr0 = atr0
  weapon.atr1 = atr1
  weapon.atr2 = atr2

  return weapon
}

Loadout function createWeaponNoVisor(string name, asset image, ArrayAttribute atr0, ArrayAttribute atr1) 
{
  ArrayAttribute visor 

  Loadout weapon
  weapon.image = image
  weapon.disabled = false
  weapon.selectedAtr0 = 0
  weapon.selectedAtr1 = 0
  weapon.selectedAtr2 = 0
  weapon.name = name
  weapon.atr0 = atr0
  weapon.atr1 = atr1
  weapon.atr2 = visor

  return weapon
}

void function initTitan() 
{
  LoadoutDisplay titan = file.titan

  titan.loadoutDisplay = file.loadoutDisplays[2]

  var lableOne = Hud_GetChild( file.titan.loadoutDisplay, "TitanName" )
  SetLabelRuiText( lableOne, Localize("#MODE_SETTING_BAN_TITAN") )

  titan.buttons = GetElementsByClassname( file.menu, "BanTitanCategoryButton" )  

  titan.displays = GetElementsByClassname( file.menu, "titanDisplay")

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
  Category stryder
  stryder.displayName = "Stryder"

  Loadout northstar
  northstar.name = "northstar"
  northstar.image = $"rui/callsigns/callsign_fd_northstar_hard"
  northstar.disabled = false
  northstar.selectedAtr0 = 0
  northstar.selectedAtr1 = 0
  northstar.selectedAtr2 = 0
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
  northstar.atr0 = northstarKit
  northstar.atr1 = titanKit
  northstar.atr2 = fallKit
  stryder.loadouts.append(northstar)

  Loadout ronin
  ronin.name = "ronin"
  ronin.image = $"rui/callsigns/callsign_fd_ronin_hard"
  ronin.disabled = false
  ronin.selectedAtr0 = 0
  ronin.selectedAtr1 = 0
  ronin.selectedAtr2 = 0
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
  ronin.atr0 = roninKit
  ronin.atr1 = titanKit
  ronin.atr2 = fallKit

  stryder.loadouts.append(ronin)
  titan.categories.append(stryder)
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  

  Category atlas
  atlas.displayName = "Atlas"

  Loadout ion
  ion.name = "ion"
  ion.image = $"rui/callsigns/callsign_fd_ion_hard"
  ion.disabled = false
  ion.selectedAtr0 = 0
  ion.selectedAtr1 = 0
  ion.selectedAtr2 = 0
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
  ion.atr0 = ionKit
  ion.atr1 = titanKit
  ion.atr2 = fallKit

  atlas.loadouts.append(ion)

  Loadout tone
  tone.name = "tone"
  tone.image = $"rui/callsigns/callsign_fd_tone_hard"
  tone.disabled = false
  tone.selectedAtr0 = 0
  tone.selectedAtr1 = 0
  tone.selectedAtr2 = 0
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
  tone.atr0 = toneKit
  tone.atr1 = titanKit
  tone.atr2 = fallKit

  atlas.loadouts.append(tone)

  Loadout monarch
  monarch.name = "monarch"
  monarch.image = $"rui/callsigns/callsign_fd_monarch_hard"
  monarch.disabled = false
  monarch.selectedAtr0 = 0
  monarch.selectedAtr1 = 0
  monarch.selectedAtr2 = 0
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
  monarch.atr0 = monarchKit
  monarch.atr1 = titanKit
  monarch.atr2 = fallKit

  atlas.loadouts.append(monarch)

  Loadout monarchCores
  monarchCores.name = "monarchCores"
  monarchCores.image = $"rui/callsigns/callsign_fd_monarch_hard"
  monarchCores.disabled = false
  monarchCores.selectedAtr0 = 0
  monarchCores.selectedAtr1 = 0
  monarchCores.selectedAtr2 = 0
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
  monarchCores.atr0 = monarchCore0
  monarchCores.atr1 = monarchCore1
  monarchCores.atr2 = monarchCore2

  atlas.loadouts.append(monarchCores)

  titan.categories.append(atlas)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  Category ogre
  ogre.displayName = "Ogre"

  Loadout scorch
  scorch.name = "scorch"
  scorch.image = $"rui/callsigns/callsign_fd_scorch_hard"
  scorch.disabled = false
  scorch.selectedAtr0 = 0
  scorch.selectedAtr1 = 0
  scorch.selectedAtr2 = 0
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
  scorch.atr0 = scorchKit
  scorch.atr1 = titanKit
  scorch.atr2 = fallKit

  ogre.loadouts.append(scorch)
  

  Loadout legion
  legion.name = "legion"
  legion.image = $"rui/callsigns/callsign_fd_legion_hard"
  legion.disabled = false
  legion.selectedAtr0 = 0
  legion.selectedAtr1 = 0
  legion.selectedAtr2 = 0
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
  legion.atr0 = legionKit
  legion.atr1 = titanKit
  legion.atr2 = fallKit

  ogre.loadouts.append(legion)

  titan.categories.append(ogre)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  

  for(int i = 0; i < titan.buttons.len() ; i++) 
  {
    RHud_SetText( titan.buttons[i], Localize(titan.categories[i].displayName) )
    AddButtonEventHandler( titan.buttons[i], UIE_CLICK, changeTitanDisplay )
	}

  var rui = Hud_GetRui( Hud_GetChild( titan.loadoutDisplay, "TitanDetails" ) )

  selectButton(titan.buttons, 1, 0)
  changeTitanDisplay(titan.buttons[0])

	RuiSetString( rui, "nameText", Localize("#MODE_SETTING_BAN_TITAN_LBL_TITLE") )
	RuiSetString( rui, "descText", Localize("#MODE_SETTING_BAN_TITAN_LBL_TEXT") )
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

  var rui = Hud_GetRui( Hud_GetChild( boost.loadoutDisplay, "BoostDetails" ) )

	RuiSetString( rui, "nameText", Localize("MODE_SETTING_BAN_BOOST_LBL_TITLE") )
	RuiSetString( rui, "descText", Localize("MODE_SETTING_BAN_BOOST_LBL_TEXT") )
}
