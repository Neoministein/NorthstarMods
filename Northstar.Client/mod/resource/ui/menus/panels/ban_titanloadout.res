"resource/ui/menus/panels/ban_titanloadout.res"
{
	TitanName
	{
        ControlName				RuiPanel
        InheritProperties       RuiLoadoutLabel
        ypos                    78
	}

    TitanIon
	{
		ControlName				CNestedPanel
		classname 				titanDisplay
		xpos					0
    	ypos                    0
		zpos					10
		wide					500
		tall					225
        scriptID				0

		enabled                 0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
		controlSettingsFile		"resource/ui/menus/panels/ban_weaponloadout.res"

		ButtonFrame
		{
			ControlName				RuiPanel
			ypos                    107
			wide					223
			tall					108
			rui                     "ui/basic_image.rpak"
			visible					1

			pin_to_sibling			TitanIon
			pin_corner_to_sibling	TOP_LEFT
        	pin_to_sibling_corner	TOP_LEFT
		}
	}

    TitanSorch
	{
		ControlName				CNestedPanel
		classname 				titanDisplay
		xpos					0
    	ypos                    -75
		zpos					10
		wide					500
		tall					225
		scriptID				1

        
		enabled                 0
        pin_to_sibling			TitanIon
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
		controlSettingsFile		"resource/ui/menus/panels/ban_weaponloadout.res"

		ButtonFrame
		{
			ControlName				RuiPanel
			ypos                    107
			wide					223
			tall					108
			rui                     "ui/basic_image.rpak"
			visible					1

			pin_to_sibling			TitanIon
			pin_corner_to_sibling	TOP_LEFT
        	pin_to_sibling_corner	TOP_LEFT
		}
	}

    TitanNorthstar
	{
		ControlName				CNestedPanel
		classname 				titanDisplay
		xpos					0
    	ypos                    -75
		zpos					10
		wide					500
		tall					225
		scriptID				2

        
		enabled                 0
        pin_to_sibling			TitanSorch
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
		controlSettingsFile		"resource/ui/menus/panels/ban_weaponloadout.res"

		ButtonFrame
		{
			ControlName				RuiPanel
			ypos                    107
			wide					223
			tall					108
			rui                     "ui/basic_image.rpak"
			visible					1

			pin_to_sibling			TitanIon
			pin_corner_to_sibling	TOP_LEFT
        	pin_to_sibling_corner	TOP_LEFT
		}
	}

    TitanRonin
	{
		ControlName				CNestedPanel
		classname 				titanDisplay
		xpos					650
    	ypos                    0
		zpos					10
		wide					500
		tall					225
		scriptID				3

		enabled                 0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
		controlSettingsFile		"resource/ui/menus/panels/ban_weaponloadout.res"

		ButtonFrame
		{
			ControlName				RuiPanel
			ypos                    107
			wide					223
			tall					108
			rui                     "ui/basic_image.rpak"
			visible					1

			pin_to_sibling			TitanIon
			pin_corner_to_sibling	TOP_LEFT
        	pin_to_sibling_corner	TOP_LEFT
		}
	}

    TitanTone
	{
		ControlName				CNestedPanel
		classname 				titanDisplay
		xpos					0
    	ypos                    -75
		zpos					10
		wide					500
		tall					225
		scriptID				4

        
		enabled                 0
        pin_to_sibling			TitanRonin
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
		controlSettingsFile		"resource/ui/menus/panels/ban_weaponloadout.res"

		ButtonFrame
		{
			ControlName				RuiPanel
			ypos                    107
			wide					223
			tall					108
			rui                     "ui/basic_image.rpak"
			visible					1

			pin_to_sibling			TitanIon
			pin_corner_to_sibling	TOP_LEFT
        	pin_to_sibling_corner	TOP_LEFT
		}
	} 

    TitanLegion
	{
		ControlName				CNestedPanel
		classname 				titanDisplay
		xpos					0
    	ypos                    -75
		zpos					10
		wide					500
		tall					225
		scriptID				5

        
		enabled                 0
        pin_to_sibling			TitanTone
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
		controlSettingsFile		"resource/ui/menus/panels/ban_weaponloadout.res"

		ButtonFrame
		{
			ControlName				RuiPanel
			ypos                    107
			wide					223
			tall					108
			rui                     "ui/basic_image.rpak"
			visible					1

			pin_to_sibling			TitanIon
			pin_corner_to_sibling	TOP_LEFT
        	pin_to_sibling_corner	TOP_LEFT
		}
	} 

    TitanMonarch
	{
		ControlName				CNestedPanel
		classname 				titanDisplay
		xpos					0
    	ypos                    -75
		zpos					10
		wide					500
		tall					225
		scriptID				6

        
		enabled                 0
        pin_to_sibling			TitanNorthstar
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
		controlSettingsFile		"resource/ui/menus/panels/ban_weaponloadout.res"

		ButtonFrame
		{
			ControlName				RuiPanel
			ypos                    107
			wide					223
			tall					108
			rui                     "ui/basic_image.rpak"
			visible					1

			pin_to_sibling			TitanIon
			pin_corner_to_sibling	TOP_LEFT
        	pin_to_sibling_corner	TOP_LEFT
		}
	}

    TitanMonarch
	{
		ControlName				CNestedPanel
		classname 				titanDisplay
		xpos					0
    	ypos                    -75
		zpos					10
		wide					500
		tall					225
		scriptID				6

        
		enabled                 0
        pin_to_sibling			TitanNorthstar
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
		controlSettingsFile		"resource/ui/menus/panels/ban_weaponloadout.res"

		ButtonFrame
		{
			ControlName				RuiPanel
			ypos                    107
			wide					223
			tall					108
			rui                     "ui/basic_image.rpak"
			visible					1

			pin_to_sibling			TitanIon
			pin_corner_to_sibling	TOP_LEFT
        	pin_to_sibling_corner	TOP_LEFT
		}
	}

	TitanMonarchCores
	{
		ControlName				CNestedPanel
		xpos					0
    	ypos                    -225
		zpos					10
		wide					500
		tall					225
		scriptID				7

        visible					1
		enabled                 1
        pin_to_sibling			TitanMonarch

		CoreOne
		{
			ControlName				RuiButton
			InheritProperties		RuiSmallButton
			classname				MonarchCoreButton
			scriptID				0
			ypos					0
			wide					225
			tabPosition				1
			visible					1
			
			pin_corner_to_sibling	TOP_LEFT
			pin_to_sibling_corner	BOTTOM_LEFT
		}

		CoreTwo
		{
			ControlName				RuiButton
			InheritProperties		RuiSmallButton
			classname				MonarchCoreButton
			scriptID				1
			ypos					40
			wide					225

			tabPosition				1
			visible					1
			
			pin_corner_to_sibling	TOP_LEFT
			pin_to_sibling_corner	BOTTOM_LEFT
		}

		CoreThree
		{
			ControlName				RuiButton
			InheritProperties		RuiSmallButton
			classname				MonarchCoreButton
			scriptID				2
			ypos					80
			wide					225

			tabPosition				1
			visible					1
			
			pin_corner_to_sibling	TOP_LEFT
			pin_to_sibling_corner	BOTTOM_LEFT
		}
	}


	TitanDetails
    {
        ControlName				RuiPanel
        InheritProperties		ItemDetails
	    xpos					600
    	ypos                    700
		zpos					10
    }
}