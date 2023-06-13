//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : update_constants
// Database: 4D_Doc
// ID[17B494E8E77D403E8D2F6A2969A148DD]
// Created #20-6-2018 by Vincent de Lachaux
// ----------------------------------------------------
var $intl; $name : Text
var $indx : Integer
var $ds_; $es; $group; $o; $value : Object
var $constants; $groups; $themes; $values : Collection

// ----------------------------------------------------
$constants:=New collection:C1472

$intl:=Get 4D folder:C485(-1)+"en.lproj"+Folder separator:K24:12+"4D_ConstantsEN.xlf"

// ----------------------------------------------------
If (Asserted:C1132(Test path name:C476($intl)=Is a document:K24:1; "file not found"))
	
	$o:=xml_fileToObject($intl)
	
	If ($o.success)
		
		$groups:=$o.value.xliff.file.body.group
		
		$themes:=$groups[0]["trans-unit"].extract("id"; "id"; "target.$"; "name")
		
		For each ($group; $groups; 1)
			
			// Get the theme label
			$indx:=$themes.extract("id").indexOf($group["d4:groupID"])
			
			If ($indx#-1)
				
				$name:=$themes[$indx].name
				
			End if 
			
			// Get the constants
			$values:=$group["trans-unit"].extract("target.$"; "name"; "d4:value"; "value"; "id"; "ID")
			
			For each ($value; $values)
				
				If ($value.name=Null:C1517)
					
					// Deleted / Obfuscated constant
					$es:=ds:C1482.constants.query("ID = :1"; $value.ID)
					
					If ($es.length>0)
						
						$es.drop()
						
					End if 
					
				Else 
					
					$constants.push(New object:C1471(\
						"ID"; $value.ID; \
						"theme"; $name; \
						"name"; $value.name; \
						"value"; $value.value; \
						"obsolete"; Position:C15("_o_"; String:C10($value.name))=1))
					
				End if 
				
			End for each 
		End for each 
		
		$ds_:=ds:C1482.constants.fromCollection($constants)
		
	End if 
End if 