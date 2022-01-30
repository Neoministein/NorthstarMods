"resource/ui/menus/panels/ban_weaponloadout.res"
{
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	WeaponName
	{
        ControlName				RuiPanel
        InheritProperties       RuiLoadoutLabel
        ypos                    78
	}

    ButtonWeapon
    {
		ControlName				RuiButton
		InheritProperties		SuitButton
        classname				WeaponLoadoutPanelButtonClass
        scriptID				1
        tabPosition				1

        navUp					RenameEditBox
        navDown					ButtonPrimary
        navLeft                 ButtonGender
        navRight                ButtonOrdnance

        pin_to_sibling			WeaponName
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ButtonWeaponMod0
    {
        ControlName				RuiButton
        InheritProperties		LoadoutButtonSmall
        classname				"HideWhenEditing_0"
        scriptID				0
        xpos					6

        navUp					ButtonSuit
        navDown                 ButtonSecondary
        navLeft 				ButtonPrimary
        navRight 				ButtonPrimaryMod2

        pin_to_sibling			ButtonWeapon
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonWeaponMod1
    {
        ControlName				RuiButton
        InheritProperties		LoadoutButtonSmall
        classname				"HideWhenEditing_0 HideWhenEditing_1"
        scriptID				1
        xpos					6

        navUp					ButtonSuit
        navDown                 ButtonSecondary
        navLeft 				ButtonPrimaryMod1
        navRight 				ButtonPrimarySight

        pin_to_sibling			ButtonWeaponMod0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonWeaponSight
    {
        ControlName				RuiButton
        InheritProperties		LoadoutButtonSmall
        classname				"HideWhenEditing_0 HideWhenEditing_1 HideWhenEditing_2 HideWhenNoVisor"
        scriptID				2
        xpos					6

        navUp                   ButtonSuit
        navDown					ButtonSecondary
        navLeft 				ButtonPrimaryMod2
        navRight 				ButtonPrimaryMod3

        pin_to_sibling			ButtonWeaponMod1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ModDisplay
	{
		 ControlName				CNestedPanel
		 classname 				loadoutDisplay
		 xpos					450
    	 ypos                    0
		 zpos					10
		 wide					1048
		 tall					1080

         scriptID				2
		 visible					1
		 enabled                 0
		 controlSettingsFile		"resource/ui/menus/panels/modselect.res"
	}  

}