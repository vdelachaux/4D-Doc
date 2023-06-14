//%attributes = {"shared":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Project method: UPDATE_DATA
// Database: 4D-Doc
// ID[F3C769EED76D446F879FC095D217859F]
// Created #9-7-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
// Declarations
#DECLARE($entryPoint : Text)

If (False:C215)
	C_TEXT:C284(4D DOC UPDATE DATA; $1)
End if 

Case of 
		
		//___________________________________________________________
	: (Length:C16($entryPoint)=0)
		
		Case of 
				
				//……………………………………………………………………
			: (Method called on error:C704=Current method name:C684)
				
				// Error handling manager
				
				//……………………………………………………………………
				//: (Method called on event=$Txt_methodName)
				
				// Event manager - disabled for a component method
				
				//……………………………………………………………………
			Else 
				
				// This method must be executed in a unique new process
				BRING TO FRONT:C326(New process:C317(Current method name:C684; 0; "4D Doc"; "_run"; *))
				
				//……………………………………………………………………
		End case 
		
		//___________________________________________________________
	: ($entryPoint="_run")
		
		// First launch of this method executed in a new process
		4D DOC UPDATE DATA("_declarations")
		4D DOC UPDATE DATA("_init")
		
		update_commands
		update_constants
		
		4D DOC UPDATE DATA("_deinit")
		
		//___________________________________________________________
	: ($entryPoint="_declarations")
		
		//
		
		//___________________________________________________________
	: ($entryPoint="_init")
		
		var $bar; $edit : Text
		$bar:=Create menu:C408
		$edit:=Create menu:C408
		
		APPEND MENU ITEM:C411($edit; ":xliff:CommonMenuItemUndo")
		SET MENU ITEM PROPERTY:C973($edit; -1; Associated standard action name:K28:8; ak undo:K76:51)
		SET MENU ITEM SHORTCUT:C423($edit; -1; "Z"; Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($edit; ":xliff:CommonMenuRedo")
		SET MENU ITEM PROPERTY:C973($edit; -1; Associated standard action name:K28:8; ak redo:K76:52)
		SET MENU ITEM SHORTCUT:C423($edit; -1; "Z"; Shift key mask:K16:3)
		
		APPEND MENU ITEM:C411($edit; "-")
		
		APPEND MENU ITEM:C411($edit; ":xliff:CommonMenuItemCut")
		SET MENU ITEM PROPERTY:C973($edit; -1; Associated standard action name:K28:8; ak cut:K76:53)
		SET MENU ITEM SHORTCUT:C423($edit; -1; "X"; Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($edit; ":xliff:CommonMenuItemCopy")
		SET MENU ITEM PROPERTY:C973($edit; -1; Associated standard action name:K28:8; ak copy:K76:54)
		SET MENU ITEM SHORTCUT:C423($edit; -1; "C"; Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($edit; ":xliff:CommonMenuItemPaste")
		SET MENU ITEM PROPERTY:C973($edit; -1; Associated standard action name:K28:8; ak paste:K76:55)
		SET MENU ITEM SHORTCUT:C423($edit; -1; "V"; Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($edit; ":xliff:CommonMenuItemClear")
		SET MENU ITEM PROPERTY:C973($edit; -1; Associated standard action name:K28:8; ak clear:K76:56)
		
		APPEND MENU ITEM:C411($edit; ":xliff:CommonMenuItemSelectAll")
		SET MENU ITEM PROPERTY:C973($edit; -1; Associated standard action name:K28:8; ak select all:K76:57)
		SET MENU ITEM SHORTCUT:C423($edit; -1; "A"; Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($edit; "(-")
		
		APPEND MENU ITEM:C411($edit; ":xliff:CommonMenuItemShowClipboard")
		SET MENU ITEM PROPERTY:C973($edit; -1; Associated standard action name:K28:8; ak show clipboard:K76:58)
		
		APPEND MENU ITEM:C411($bar; ":xliff:CommonMenuEdit"; $edit)
		RELEASE MENU:C978($edit)
		
		SET MENU BAR:C67($bar)
		
		MESSAGE:C88("Update data…")
		
		//___________________________________________________________
	: ($entryPoint="_deinit")
		
		RELEASE MENU:C978(Get menu bar reference:C979)
		
		//___________________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point ("+$entryPoint+")")
		
		//___________________________________________________________
End case 