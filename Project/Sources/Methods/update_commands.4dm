//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : update_commands
// Database: 4D_Doc
// ID[C4526B45B7DE4A2A96151F094F159E52]
// Created #20-6-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Retrieve the list of command names
// ----------------------------------------------------
var $4dINTL; $t; $theme; $wpINTL : Text
var $cmd; $indx; $info : Integer
var $ds_; $es; $o; $syntaxINTL : Object
var $c; $commands; $obsoletes; $resnames : Collection

$commands:=New collection:C1472
$obsoletes:=New collection:C1472
$4dINTL:=Get 4D folder:C485(-1)+"en.lproj"+Folder separator:K24:12+"4DSyntaxEN.xlf"
$wpINTL:=Get 4D folder:C485(-1)+"en.lproj"+Folder separator:K24:12+"4DSyntaxWPEN.xlf"

Repeat 
	
	$cmd+=1
	
	$o:=New object:C1471(\
		"ID"; $cmd; \
		"name"; "")
	
	$o.name:=Command name:C538($o.ID; $info; $theme)
	$o.theme:=$theme
	$o.threadsafe:=$info ?? 0
	
	Case of 
			
			//______________________________________________________
		: (OK=0)
			
			// There is no more command
			
			//______________________________________________________
		: (Length:C16($o.name)=0)  // Deleted / Obfuscated command
			
			// NOTHING MORE TO DO
			
			//______________________________________________________
		: (Position:C15("_4D"; $o.name)=1)  // Private command
			
			// NOTHING MORE TO DO
			
			//______________________________________________________
		: (Position:C15("_O_"; $o.name)=1)  // Obsolete commmand
			
			$obsoletes.push($o)
			
			// Delete from cmnd if any
			$es:=ds:C1482.commands.query("ID = :1"; $o.ID)
			
			If ($es.length>0)
				
				$es.drop()
				
			End if 
			
			//______________________________________________________
		Else 
			
			If (ds:C1482.commands.query("ID = :1"; $o.ID).length=0)
				
				// New command
				$o.version:=Application version:C493
				
			End if 
			
			$commands.push($o)
			
			//______________________________________________________
	End case 
Until (OK=0)

// Add syntax and description
If (Asserted:C1132(Test path name:C476($4dINTL)=Is a document:K24:1; "file not found"))
	
	// Get INTL 4D Syntax
	$syntaxINTL:=xml_fileToObject($4dINTL)
	
	If ($syntaxINTL.success)
		
		$c:=$syntaxINTL.value.xliff.file.body.group["trans-unit"]
		
		If (Test path name:C476($wpINTL)=Is a document:K24:1)
			
			// Get INTL Write Pro Syntax
			$syntaxINTL:=xml_fileToObject($wpINTL)
			
			If ($syntaxINTL.success)
				
				$c:=$c.combine($syntaxINTL.value.xliff.file.body.group["trans-unit"])
				
			End if 
		End if 
		
		$resnames:=$c.extract("resname")
		
		For each ($o; $commands)
			
			$indx:=$resnames.indexOf("cmd"+String:C10($o.ID))
			
			If ($indx#-1)
				
				$o.syntax:=$c[$indx].target.$
				
				$indx:=$resnames.indexOf("desc"+String:C10($o.ID))
				
				If ($indx#-1)
					
					$o.description:=$c[$indx].target.$
					
					// Some corrections
					$o.description:=str_trim($o.description)
					$o.description:=Replace string:C233($o.description; "  "; " ")
					$o.description:=Replace string:C233($o.description; "<em>"; "")
					$o.description:=Replace string:C233($o.description; "</em>"; "")
					$o.description[[1]]:=Uppercase:C13($o.description[[1]])
					
				End if 
			End if 
			
			If (Bool:C1537($o.threadsafe))
				
				$o.comment:="Thread safe"
				
			Else 
				
				$o.comment:=""
				
			End if 
		End for each 
		
		$ds_:=ds:C1482.commands.fromCollection($commands)
		
		For each ($o; $obsoletes)
			
			$indx:=$resnames.indexOf("cmd"+String:C10($o.ID))
			
			If ($indx#-1)
				
				$o.syntax:=$c[$indx].target.$
				
				$indx:=$resnames.indexOf("desc"+String:C10($o.ID))
				
				If ($indx#-1)
					
					$o.description:=$c[$indx].target.$
					
					// Some corrections
					$o.description:=str_trim($o.description)
					$o.description:=Replace string:C233($o.description; "  "; " ")
					$o.description:=Replace string:C233($o.description; "<em>"; "")
					$o.description:=Replace string:C233($o.description; "</em>"; "")
					$o.description[[1]]:=Uppercase:C13($o.description[[1]])
					
				End if 
			End if 
		End for each 
		
		$ds_:=ds:C1482.obsoletes.fromCollection($obsoletes)
		
	End if 
End if 