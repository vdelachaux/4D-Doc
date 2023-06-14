//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : update_commands
// Database: 4D-Doc
// ID[C4526B45B7DE4A2A96151F094F159E52]
// Created #20-6-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Retrieve the list of command names
// ----------------------------------------------------
var $theme : Text
var $cmd; $count; $indx; $info : Integer
var $o; $syntax : Object
var $c; $commands; $obsoletes; $resnames : Collection
var $es; $sel : 4D:C1709.EntitySelection

$commands:=[]
$obsoletes:=[]

$es:=ds:C1482.commands.all()

$count:=$es.length

// Mark:-Get commands
Repeat 
	
	$cmd+=1
	
	$o:={\
		ID: $cmd; \
		name: ""; \
		theme: ""; \
		threadsafe: False:C215\
		}
	
	$o.name:=Command name:C538($o.ID; $info; $theme)
	$o.theme:=$theme
	$o.threadsafe:=$info ?? 0
	
	Case of 
			
			//______________________________________________________
		: (OK=0)
			
			// There is no more command
			
			//______________________________________________________
		: (Length:C16($o.name)=0)  // Deleted / Obfuscated 
			
			// NOTHING MORE TO DO
			
			//______________________________________________________
		: (Position:C15("_4D"; $o.name)=1)  // Private 
			
			// NOTHING MORE TO DO
			
			//______________________________________________________
		: (Position:C15("_O_"; $o.name)=1)  // Obsolete 
			
			$obsoletes.push($o)
			
			// Delete from cmnd if any
			$sel:=$es.query("ID = :1"; $o.ID)
			
			If ($sel.length>0)
				
				$sel.drop()
				
			End if 
			
			//______________________________________________________
		Else 
			
			If ($es.query("ID = :1"; $o.ID).length=0)
				
				// New command
				$o.version:=Application version:C493
				
			End if 
			
			$commands.push($o)
			
			//______________________________________________________
	End case 
Until (OK=0)

// Mark:-Delete commands that no longer exist
For each ($o; $es)
	
	If ($commands.query("ID = :1"; $o.ID).pop()=Null:C1517)
		
		$es.query("ID = :1"; $o.ID).drop()
		
	End if 
End for each 

// Mark:-Add syntax and description

// Get INTL 4D Syntax
$syntax:=xml_fileToObject(Folder:C1567(Get 4D folder:C485(-1); fk platform path:K87:2).file("en.lproj/4DSyntaxEN.xlf").platformPath)

If ($syntax.success)
	
	$c:=$syntax.value.xliff.file.body.group["trans-unit"]
	
	// Get INTL Write Pro Syntax
	$syntax:=xml_fileToObject(Folder:C1567(Get 4D folder:C485(-1); fk platform path:K87:2).file("en.lproj/4DSyntaxWPEN.xlf").platformPath)
	
	If ($syntax.success)
		
		$c:=$c.combine($syntax.value.xliff.file.body.group["trans-unit"])
		
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
				
				//%W-533.1
				$o.description[[1]]:=Uppercase:C13($o.description[[1]])
				//%W+533.1
				
			End if 
		End if 
		
		If (Bool:C1537($o.threadsafe))
			
			$o.comment:="Thread safe"
			
		Else 
			
			$o.comment:=""
			
		End if 
	End for each 
	
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
				
				//%W-533.1
				$o.description[[1]]:=Uppercase:C13($o.description[[1]])
				//%W+533.1
				
			End if 
		End if 
	End for each 
End if 

// Mark:-Update data
ds:C1482.commands.fromCollection($commands)
ds:C1482.obsoletes.fromCollection($obsoletes)

If (ds:C1482.commands.all().length#$count)
	
	var $file : 4D:C1709.File
	var $t : Text
	$file:=File:C1566("/PACKAGE/commands "+Replace string:C233(String:C10(Current date:C33; Internal date short:K1:7); "/"; "-")+".txt")
	
	If ($file.exists)
		
		$file.delete()
		
	End if 
	
	$t:=File:C1566("/RESOURCES/export_commands.4si").getText()
	EXPORT DATA:C666($file.platformPath; $t)
	
End if 