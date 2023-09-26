Class dhc.pa.udata.uBottomTest Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.pa.udata.uBottomTest).BakMenus(7,"main.pa","d:\menu.txt")
ClassMethod BakMenus(FromVersion, nameprefix, filename) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sql="select * from websys.menu where sequence like '"_nameprefix_"%'"
 	d result.Prepare(sql)
 	d result.Execute()
 	s MenuNames=""
 	
 	s file=##class(%File).%New(filename)
	d file.Open("WSN")
	
	
	While (result.Next(.sc)){ // go to the next row of the result set
 	
 		i $SYSTEM.Status.IsOK(sc) d // check if this succeeded without errors
 		.s MenuName=result.Data("Name") // perform busines logic
 		.w MenuName,!
 		.d file.WriteLine(MenuName)
 		.//set parmenu=..BakMenu(FromVersion,MenuName) 		
	 	.w parmenu,!
 		.s MenuNames=MenuNames_MenuName_"_"_parmenu_","
 		e  d // if there was an error, break out of the While loop
	    .w "err"
	    .d file.Close()
 		.q
 	}
 	
 	i $SYSTEM.Status.IsError(sc) d // if there was an error, process that
 	.k ^DHCPAMenu(MenuName)
 	
 	d file.Close()
	q MenuNames
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uBottomTestS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
