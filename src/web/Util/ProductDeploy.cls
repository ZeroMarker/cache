Class web.Util.ProductDeploy Extends %RegisteredObject
{

/// d ##class(web.Util.ProductDeploy).ExportClassOBJ("websys.Menu","d:\temp\")
ClassMethod ExportClassOBJ(ClassName As %String, Path As %String) As %String [ Final ]
{
	s count=0

	if Path="" Quit
 	Set rs = ##class(%ResultSet).%New("%Library.Routine:RoutineList")
 	Set Spec=ClassName_".*.OBJ"
	Set sc=rs.Execute(Spec,1,1,"DHC-APP")
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
 	While (rs.Next()) {
	 	s count=count+1
     	s OBJName=rs.GetData(1)
     	;s filename=Path_OBJName_".xml"
     	;d $System.OBJ.Export(OBJName,filename,.errorlog,"Unicode")
     	s items(OBJName)=""
 	}
 	s filename=Path_ClassName_".xml"
 	if count>0 d $System.OBJ.Export(.items,filename,.errorlog,"Unicode")
 	w "export class "_ClassName_" to "_filename,!
}

}
