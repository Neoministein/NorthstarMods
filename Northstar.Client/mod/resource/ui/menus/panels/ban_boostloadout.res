"resource/ui/menus/panels/ban_boostloadout.res"
{
    BoostName
	{
        ControlName				RuiPanel
        InheritProperties       RuiLoadoutLabel
        ypos                    78
	}

	ButtonAmpedWeapons
    {
		ControlName				RuiButton
		InheritProperties		SuitButton
        classname				BoostLoadoutPanelButtonClass
        scriptID				"amped_weapons"
        tabPosition				1

        navUp					RenameEditBox
        navDown					ButtonPrimary
        navLeft                 ButtonGender
        navRight                ButtonOrdnance

        pin_to_sibling			BoostName
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ButtonTick
    {
		ControlName				RuiButton
		InheritProperties		SuitButton
        classname				BoostLoadoutPanelButtonClass
        scriptID				"ticks"
        xpos					-235

        navUp					RenameEditBox
        navDown					ButtonPrimary
        navLeft                 ButtonGender
        navRight                ButtonOrdnance

        pin_to_sibling			BoostName
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ButtonSentry
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonLarge
        classname				BoostLoadoutPanelButtonClass
        scriptID				"antipersonnel_sentry"
        ypos					10

        navUp					ButtonSuit
        navDown					ButtonSecondary
        navLeft 				ButtonPrimarySkin
        navRight 				ButtonPrimaryMod1

        pin_to_sibling			ButtonAmpedWeapons
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ButtonMapHack
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonLarge
        classname				BoostLoadoutPanelButtonClass
        scriptID				"map_hack"
        ypos					10

        navUp					ButtonSuit
        navDown					ButtonSecondary
        navLeft 				ButtonPrimarySkin
        navRight 				ButtonPrimaryMod1

        pin_to_sibling			ButtonTick
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ButtonBattery
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonLarge
        classname				BoostLoadoutPanelButtonClass
        scriptID				"battery"
        ypos					10

        navUp					ButtonPrimary
        navDown					ButtonWeapon3
        navLeft                 ButtonSecondarySkin
        navRight                ButtonSecondaryMod1

        pin_to_sibling			ButtonSentry
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ButtonRadarJammer
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonLarge
        classname				BoostLoadoutPanelButtonClass
        scriptID				"radar_jammer"
        ypos					10

        navUp					ButtonPrimary
        navDown					ButtonWeapon3
        navLeft                 ButtonSecondarySkin
        navRight                ButtonSecondaryMod1

        pin_to_sibling			ButtonMapHack
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ButtonTitanSentry
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonLarge
        classname				BoostLoadoutPanelButtonClass
        scriptID				"antititan_sentry"
        ypos					10

        navUp					ButtonSecondary
        navDown					ButtonKit1
        navLeft                 ButtonWeapon3Skin
        navRight                ButtonWeapon3Mod1

        pin_to_sibling			ButtonBattery
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ButtonTitanSmartPistol
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonLarge
        classname				BoostLoadoutPanelButtonClass
        scriptID				"smart_pistol"
        ypos					10

        navUp					ButtonSecondary
        navDown					ButtonKit1
        navLeft                 ButtonWeapon3Skin
        navRight                ButtonWeapon3Mod1

        pin_to_sibling			ButtonRadarJammer
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ButtonPhaseRewind
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonLarge
        classname				BoostLoadoutPanelButtonClass
        scriptID				"phase_rewind"
        ypos					10

        navUp					ButtonSecondary
        navDown					ButtonKit1
        navLeft                 ButtonWeapon3Skin
        navRight                ButtonWeapon3Mod1

        pin_to_sibling			ButtonTitanSentry
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ButtonHardCover
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonLarge
        classname				BoostLoadoutPanelButtonClass
        scriptID				"shield"
        ypos					10

        navUp					ButtonSecondary
        navDown					ButtonKit1
        navLeft                 ButtonWeapon3Skin
        navRight                ButtonWeapon3Mod1

        pin_to_sibling			ButtonTitanSmartPistol
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ButtonHoloPilotNova
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonLarge
        classname				BoostLoadoutPanelButtonClass
        scriptID				"holo_pilots"
        ypos					10

        navUp					ButtonSecondary
        navDown					ButtonKit1
        navLeft                 ButtonWeapon3Skin
        navRight                ButtonWeapon3Mod1

        pin_to_sibling			ButtonPhaseRewind
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ButtonDiceRole
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonLarge
        classname				BoostLoadoutPanelButtonClass
        scriptID				"random"
        ypos					11

        navUp					ButtonSecondary
        navDown					ButtonKit1
        navLeft                 ButtonWeapon3Skin
        navRight                ButtonWeapon3Mod1

        pin_to_sibling			ButtonHardCover
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    BoostDetails
    {
        ControlName				RuiPanel
        InheritProperties		ItemDetails
	    xpos					600
    	ypos                    700
		zpos					10
    }
}