//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : update_constants
// Database: 4D-Doc
// ID[17B494E8E77D403E8D2F6A2969A148DD]
// Created #20-6-2018 by Vincent de Lachaux
// ----------------------------------------------------
var $theme : Text
var $group; $k : Object
var $constants; $themes : Collection
var $es; $sel : 4D:C1709.EntitySelection
var $fileConstants; $fileThemes : 4D:C1709.Folder

$constants:=[]

$es:=ds:C1482.constants.all()

$fileConstants:=Folder:C1567(Get 4D folder:C485(-1); fk platform path:K87:2).file("en.lproj/4D_ConstantsEN.xlf")
$fileThemes:=Folder:C1567(Get 4D folder:C485(-1); fk platform path:K87:2).file("en.lproj/4D_ConstantsThemesEN.xlf")

$themes:=xml_fileToObject($fileThemes.platformPath).value.xliff.file.body.group["trans-unit"]

For each ($group; xml_fileToObject($fileConstants.platformPath).value.xliff.file.body.group; 1)
	
	// Get the theme label
	$theme:=$themes.query("resname = :1"; $group["d4:groupName"]).pop().source.$
	
	// Get the constants
	For each ($k; $group["trans-unit"].extract("source.$"; "name"; "d4:value"; "value"; "id"; "id"))
		
		If ($k.name=Null:C1517)
			
			// Deleted / Obfuscated
			$sel:=$es.query("ID = :1"; $k.id)
			
			If ($sel.length>0)
				
				$sel.drop()
				
			End if 
			
		Else 
			
			$constants.push({\
				ID: $k.id; \
				name: $k.name; \
				theme: $theme; \
				value: $k.value; \
				obsolete: Position:C15("_o_"; String:C10($k.name))=1\
				})
			
		End if 
	End for each 
End for each 

ds:C1482.constants.fromCollection($constants)