Class web.DHCMedLoadMenus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

/// w ##class(web.DHCMedLoadMenus).DownLoadMenus("DHCWMR","d:\menus.txt")
ClassMethod DownLoadMenus(nameprefix As %String, filename)
{
	set rset = ##class(%ResultSet).%New()
	;set sql="select sequence ,* from websys.menu where Name like '"_nameprefix_"%'"_" order by sequence"
	set sql="select * from websys.menu where Name like '"_nameprefix_"%'"
 	Do rset.Prepare(sql)
 	Do rset.Execute()
 	
 	set MenuNames=""
 	
 	set count=1
 	set file=##class(%File).%New(filename)
	Do file.Open("WSN")
	
	While (rset.Next(.sc)) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 		{
 		    set MenuName=rset.Data("Name") // perform busines logic
 		    
 		    Do file.WriteLine(MenuName)
 		    set parmenu=..BakMenu(MenuName)
 		    w MenuName,!
 		}
 		Else // if there was an error, break out of the While loop
 		{
	        w "   err"
	        Do file.Close()
 		    Quit
 		}
	 	set count=count+1
 	}
 	If $SYSTEM.Status.IsError(sc) // if there was an error, process that
 	{
 	    Kill ^DHCMedMenu(MenuName)
 	}
 	Do file.Close()
	Quit "OK"
}

ClassMethod BakMenu(menuname As %String)
{
	&SQL(SELECT SubMenuOf->Name,LinkComponent->Name,
	            Chart->Name,ChartBook->Description,WorkFlow->Name,Worklist->Name
	        INTO :submenuname,:linkcompname,:linkChart,:linkChartBook,:WorkFlow,:WorkList
	        FROM websys.menu
			WHERE Name=:menuname)
	If SQLCODE Quit 1
	Kill ^DHCMenu(menuname)
	KILL PLIST
	&SQL(SELECT * INTO :PLIST() FROM websys.menu Where Name=:menuname)
	m ^DHCMedMenu(menuname,"Menu")=PLIST
	Set ^DHCMedMenu(menuname,"ParName")=submenuname
	Set ^DHCMedMenu(menuname,"ComponentName")=linkcompname
	Set ^DHCMedMenu(menuname,"Chart")=linkChart
	Set ^DHCMedMenu(menuname,"ChartBook")=linkChartBook
	Set ^DHCMedMenu(menuname,"WorkFlow")=WorkFlow
	Set ^DHCMedMenu(menuname,"WorkList")=WorkList
	q submenuname
}

/// w ##class(web.DHCMedLoadMenus).UpLoadMenus("d:\menus.txt","P5","P5")
ClassMethod UpLoadMenus(filename As %String, VFrom As %String, VTo As %String)
{
	If '##class(%File).Exists(filename) q
	set (line,parid,errs)=""
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=filename
	While 'stream.AtEnd {
		Set menuname=stream.ReadLine()
		w menuname,!
		set:(VFrom="P5")&&(VTo="P5") Ret=..RestoreMenuP5P5(menuname)
		set:(VFrom="P5")&&(VTo="P7") Ret=..RestoreMenuP5P7(menuname)
		set:(VFrom="P7")&&(VTo="P5") Ret=..RestoreMenuP7P5(menuname)
		set:(VFrom="P7")&&(VTo="P7") Ret=..RestoreMenuP7P7(menuname)
		w "    Ret="_Ret
	}
   Quit "OK"
}

ClassMethod RestoreMenuP5P5(menuname As %String)
{
	New (menuname)
	set parid=""
	
	set SubMenu=^DHCMedMenu(menuname,"ParName")
	Set LinkChart=^DHCMedMenu(menuname,"Chart")
	Set LinkChartBook=^DHCMedMenu(menuname,"ChartBook")
	set CompName=^DHCMedMenu(menuname,"ComponentName")
	set WorkFlow=^DHCMedMenu(menuname,"WorkFlow")
	Set WorkList=^DHCMedMenu(menuname,"WorkList")
	
	KILL PLIST
	m PLIST=^DHCMedMenu(menuname,"Menu")
	KILL PLIST(1)
	KILL PLIST(3)
	KILL PLIST(4)
	KILL PLIST(8)
	KILL PLIST(17)
	KILL PLIST(24)
	KILL PLIST(25)
	
	If (LinkChart'=""){
		set ChartId=""
		&SQL(select id into :ChartId from epr.chart where Name =:LinkChart)
		set PLIST(3)=ChartId
	}
	If (LinkChartBook'=""){
		set ChartBookId=""
		&SQL(select id into :ChartBookId from epr.chartbook where Description =:LinkChartBook)
		set PLIST(4)=ChartBookId
	}	
	if (CompName'=""){
		set CompNameId=""		
		&SQL(select id into :CompNameId from websys.component where name = :CompName)
		set PLIST(8)=CompNameId
	}
	
	if (WorkFlow'=""){
		set WorkFlowId=""
		&SQL(select id into :WorkFlowId from websys.WorkFlow where name = :WorkFlow)
		set PLIST(24)=WorkFlowId
	}
	
	if (WorkList'=""){
		set WorkListId=""
		&SQL(select id into :WorkListId from epr.Worklist where name = :WorkList)
		set PLIST(25)=WorkListId
	}
	
	set SubMenuId=""
	&SQL(SELECT id into :SubMenuId FROM websys.Menu WHERE Name=:SubMenu)
	if (SubMenuId'="")	set PLIST(17)=SubMenuId
	
	set myid=""
	&SQL(SELECT id into :myid FROM websys.Menu WHERE Name=:menuname)
	If (myid'=""){
		&SQL(UPDATE websys.menu VALUES :PLIST() WHERE ID=:myid)
	}else{
		&SQL(INSERT INTO websys.menu VALUES :PLIST())
	}
	
	If SQLCODE Quit SQLCODE
	Quit $g(%ROWID)
}

ClassMethod RestoreMenuP5P7(menuname As %String)
{
	New (menuname)
	set parid=""
	
	set SubMenu=^DHCMedMenu(menuname,"ParName")
	Set LinkChart=^DHCMedMenu(menuname,"Chart")
	Set LinkChartBook=^DHCMedMenu(menuname,"ChartBook")
	set CompName=^DHCMedMenu(menuname,"ComponentName")
	set WorkFlow=^DHCMedMenu(menuname,"WorkFlow")
	Set WorkList=^DHCMedMenu(menuname,"WorkList")
	
	KILL PLIST
	For MM=1:1:6 Do
	.Set PLIST(MM)=$g(^DHCMedMenu(menuname,"Menu",MM))
	Set PLIST(7)=""
	For MM=7:1:12 Do
	.Set PLIST(MM+1)=$g(^DHCMedMenu(menuname,"Menu",MM))
	Set PLIST(14)=""
	For MM=13:1:25 Do
	.Set PLIST(MM+2)=$g(^DHCMedMenu(menuname,"Menu",MM))
	
	KILL PLIST(1)
	KILL PLIST(3)
	KILL PLIST(4)
	KILL PLIST(13)
	KILL PLIST(19)
	KILL PLIST(26)
	KILL PLIST(27)
	
	If (LinkChart'=""){
		set ChartId=""
		&SQL(select id into :ChartId from epr.chart where Name =:LinkChart)
		set PLIST(3)=ChartId
	}
	If (LinkChartBook'=""){
		set ChartBookId=""
		&SQL(select id into :ChartBookId from epr.chartbook where Description =:LinkChartBook)
		set PLIST(4)=ChartBookId
	}	
	if (CompName'=""){
		set CompNameId=""		
		&SQL(select id into :CompNameId from websys.component where name = :CompName)
		set PLIST(13)=CompNameId
	}
	
	if (WorkFlow'=""){
		set WorkFlowId=""
		&SQL(select id into :WorkFlowId from websys.WorkFlow where name = :WorkFlow)
		set PLIST(26)=WorkFlowId
	}
	
	if (WorkList'=""){
		set WorkListId=""
		&SQL(select id into :WorkListId from epr.Worklist where name = :WorkList)
		set PLIST(27)=WorkListId
	}
	
	set SubMenuId=""
	&SQL(SELECT id into :SubMenuId FROM websys.Menu WHERE Name=:SubMenu)
	if (SubMenuId'="")	set PLIST(19)=SubMenuId
	
	set myid=""
	&SQL(SELECT id into :myid FROM websys.Menu WHERE Name=:menuname)
	If (myid'=""){
		&SQL(UPDATE websys.menu VALUES :PLIST() WHERE ID=:myid)
	}else{
		&SQL(INSERT INTO websys.menu VALUES :PLIST())
	}
	
	If SQLCODE Quit SQLCODE
	Quit $g(%ROWID)
}

ClassMethod Test()
{
	For MM=27:-1:20 Do
	.w !,MM
	q
}

/// w ##Class(web.DHCMedLoadMenus).RestoreMenuP7P7("DHCMedEpdReport")
ClassMethod RestoreMenuP7P7(menuname As %String)
{
	New (menuname)
	set parid=""
	
	set SubMenu=^DHCMedMenu(menuname,"ParName")
	Set LinkChart=^DHCMedMenu(menuname,"Chart")
	Set LinkChartBook=^DHCMedMenu(menuname,"ChartBook")
	set CompName=^DHCMedMenu(menuname,"ComponentName")
	set WorkFlow=^DHCMedMenu(menuname,"WorkFlow")
	Set WorkList=^DHCMedMenu(menuname,"WorkList")
	
	KILL PLIST
	m PLIST=^DHCMedMenu(menuname,"Menu")
	KILL PLIST(1)
	KILL PLIST(3)
	KILL PLIST(4)
	KILL PLIST(13)
	KILL PLIST(19)
	KILL PLIST(26)
	KILL PLIST(27)
	
	If (LinkChart'=""){
		set ChartId=""
		&SQL(select id into :ChartId from epr.chart where Name =:LinkChart)
		set PLIST(3)=ChartId
	}
	If (LinkChartBook'=""){
		set ChartBookId=""
		&SQL(select id into :ChartBookId from epr.chartbook where Description =:LinkChartBook)
		set PLIST(4)=ChartBookId
	}	
	if (CompName'=""){
		set CompNameId=""		
		&SQL(select id into :CompNameId from websys.component where name = :CompName)
		set PLIST(13)=CompNameId
	}
	
	if (WorkFlow'=""){
		set WorkFlowId=""
		&SQL(select id into :WorkFlowId from websys.WorkFlow where name = :WorkFlow)
		set PLIST(26)=WorkFlowId
	}
	
	if (WorkList'=""){
		set WorkListId=""
		&SQL(select id into :WorkListId from epr.Worklist where name = :WorkList)
		set PLIST(27)=WorkListId
	}
	
	set SubMenuId=""
	&SQL(SELECT id into :SubMenuId FROM websys.Menu WHERE Name=:SubMenu)
	if (SubMenuId'="")	set PLIST(19)=SubMenuId
	
	set myid=""
	&SQL(SELECT id into :myid FROM websys.Menu WHERE Name=:menuname)
	If (myid'=""){
		&SQL(UPDATE websys.menu VALUES :PLIST() WHERE ID=:myid)
	}else{
		&SQL(INSERT INTO websys.menu VALUES :PLIST())
	}
	
	If SQLCODE Quit SQLCODE
	Quit $g(%ROWID)
}

/// w ##Class(web.DHCMedLoadMenus).RestoreMenuP7P5("DHCMedEpdReport")
ClassMethod RestoreMenuP7P5(menuname As %String)
{
	New (menuname)
	set parid=""
	
	set SubMenu=^DHCMedMenu(menuname,"ParName")
	Set LinkChart=^DHCMedMenu(menuname,"Chart")
	Set LinkChartBook=^DHCMedMenu(menuname,"ChartBook")
	set CompName=^DHCMedMenu(menuname,"ComponentName")
	set WorkFlow=^DHCMedMenu(menuname,"WorkFlow")
	Set WorkList=^DHCMedMenu(menuname,"WorkList")
	
	KILL PLIST
	For MM=1:1:6 Do
	.Set PLIST(MM)=$g(^DHCMedMenu(menuname,"Menu",MM))
	For MM=8:1:13 Do
	.Set PLIST(MM-1)=$g(^DHCMedMenu(menuname,"Menu",MM))
	For MM=15:1:27 Do
	.Set PLIST(MM-2)=$g(^DHCMedMenu(menuname,"Menu",MM))
	
	KILL PLIST(1)
	KILL PLIST(3)
	KILL PLIST(4)
	KILL PLIST(8)
	KILL PLIST(17)
	KILL PLIST(24)
	KILL PLIST(25)
	
	If (LinkChart'=""){
		set ChartId=""
		&SQL(select id into :ChartId from epr.chart where Name =:LinkChart)
		set PLIST(3)=ChartId
	}
	If (LinkChartBook'=""){
		set ChartBookId=""
		&SQL(select id into :ChartBookId from epr.chartbook where Description =:LinkChartBook)
		set PLIST(4)=ChartBookId
	}	
	if (CompName'=""){
		set CompNameId=""		
		&SQL(select id into :CompNameId from websys.component where name = :CompName)
		set PLIST(8)=CompNameId
	}
	
	if (WorkFlow'=""){
		set WorkFlowId=""
		&SQL(select id into :WorkFlowId from websys.WorkFlow where name = :WorkFlow)
		set PLIST(24)=WorkFlowId
	}
	
	if (WorkList'=""){
		set WorkListId=""
		&SQL(select id into :WorkListId from epr.Worklist where name = :WorkList)
		set PLIST(25)=WorkListId
	}
	
	set SubMenuId=""
	&SQL(SELECT id into :SubMenuId FROM websys.Menu WHERE Name=:SubMenu)
	if (SubMenuId'="")	set PLIST(17)=SubMenuId
	
	set myid=""
	&SQL(SELECT id into :myid FROM websys.Menu WHERE Name=:menuname)
	If (myid'=""){
		&SQL(UPDATE websys.menu VALUES :PLIST() WHERE ID=:myid)
	}else{
		&SQL(INSERT INTO websys.menu VALUES :PLIST())
	}
	
	If SQLCODE Quit SQLCODE
	Quit $g(%ROWID)
}

}
