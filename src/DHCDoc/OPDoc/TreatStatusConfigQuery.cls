Class DHCDoc.OPDoc.TreatStatusConfigQuery Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.TreatStatusConfigQuery","TreatStatusConfigMain","")
Query TreatStatusConfigMain(HospId As %String = "") As %Query(ROWSPEC = "RowId:%String, CSPname:%String, DefiDesc:%String, IsActive:%String") [ SqlProc ]
{
}

ClassMethod TreatStatusConfigMainExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	set sqlStr ="SELECT TreatStatusConfigMainID AS RowId, CSPname, DefiDesc, IsActive FROM SQLUser.DocCFTreatStatusMainInfo "
	_"where HospDr='"_HospId_"'"
	s resultStr=##class(%Library.ResultSet).%New()
	d resultStr.Prepare(sqlStr)
	d resultStr.Execute()
	While(resultStr.Next()){
		s RowId    = resultStr.Data("RowId")
		s CSPname  = resultStr.Data("CSPname")
		s DefiDesc = resultStr.Data("DefiDesc")
		s IsActive = resultStr.Data("IsActive")
		d OutputRow1
	}
	
	quit $$$OK
	
OutputRow1	
	set Data=$lb(RowId, CSPname, DefiDesc, IsActive)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod TreatStatusConfigMainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TreatStatusConfigMainExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod TreatStatusConfigMainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TreatStatusConfigMainExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.TreatStatusConfigQuery","TreatStatusConfig","opdoc.outpatientlist.csp","1",2) 
Query TreatStatusConfig(CSPMain As %String, ActiveOrNo As %String, HospId As %String = "") As %Query(ROWSPEC = "RowId:%String,MainID:%String,CSPname:%String,DefiDesc:%String,MainActive:%String,toolId:%String,name:%String,DisplayNum:%Integer,IsVisible:%String,IsActive:%String,iconStyle:%String,iconRoute:%String,customStyle:%String,URLconfig:%String,statusChangeHandler:%String,clickHandler:%String,herSplitLine:%String,verSplitLine:%String,activeStatus:%String,disableStatus:%String,tooltip,shortcut,express") [ SqlProc ]
{
}

ClassMethod TreatStatusConfigExecute(ByRef qHandle As %Binary, CSPMain As %String, ActiveOrNo As %String = "", HospId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
    s sqlStr="select TreatStatusConfigMainID->CSPname,TreatStatusConfigMainID->DefiDesc,  "
     		_"TreatStatusConfigMainID->IsActive AS MainActive,*  "
    		_"from SQLUser.DocCFTreatStatusInfo "
    		_"where TreatStatusConfigMainID->CSPname='"_CSPMain_"' "
    		_"and TreatStatusConfigMainID->HospDr='"_HospId_"' "
    if ActiveOrNo="" {
	    s sqlStr=sqlStr_"AND (IsActive='1' OR IsActive='0') "
    }else{
	    s sqlStr=sqlStr_"AND (IsActive = '"_ActiveOrNo_"') "
    }
	s sqlStr=sqlStr_"ORDER BY DisplayNum "
	s resultStr=##class(%Library.ResultSet).%New()
	d resultStr.Prepare(sqlStr)
	d resultStr.Execute()
	While(resultStr.Next()){
		s RowId  = resultStr.Data("TreatStatusConfigID")
		s MainID = resultStr.Data("TreatStatusConfigMainID")
		s CSPname= resultStr.Data("CSPname")
		s DefiDesc= resultStr.Data("DefiDesc")
		s MainActive = resultStr.Data("MainActive")
		s toolId = resultStr.Data("toolId")
        s name   = resultStr.Data("name")
		s DisplayNum  = resultStr.Data("DisplayNum")
		s IsVisible   = resultStr.Data("IsVisible")
		s IsActive    = resultStr.Data("IsActive")
		s iconStyle   = resultStr.Data("iconStyle") 
		s iconRoute   = resultStr.Data("iconRoute")
		s customStyle = resultStr.Data("customStyle")
		s URLconfig   = resultStr.Data("URLconfig")
        s statusChangeHandler = resultStr.Data("statusChangeHandler")
		s clickHandler = resultStr.Data("clickHandler")
		s herSplitLine = resultStr.Data("herSplitLine")
		s verSplitLine = resultStr.Data("verSplitLine")
		s activeStatus = resultStr.Data("activeStatus")
		s disableStatus = resultStr.Data("disableStatus")
		s tooltip = resultStr.Data("tooltip")
		s shortcut = resultStr.Data("shortcut")
		s express = resultStr.Data("express")
		d OutputRow2
	}
	
	quit $$$OK  
	
OutputRow2
	set Data=$lb(RowId,MainID,CSPname,DefiDesc,MainActive,toolId,name,DisplayNum,IsVisible,IsActive,iconStyle,iconRoute,customStyle,URLconfig,statusChangeHandler,clickHandler,herSplitLine,verSplitLine,activeStatus,disableStatus,tooltip,shortcut,express)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod TreatStatusConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TreatStatusConfigExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod TreatStatusConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TreatStatusConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
