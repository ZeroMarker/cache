Class DHCWL.VerManagement.DefaultInOutService Extends %RegisteredObject [ Not ProcedureBlock ]
{

///  pl
///  2016-02-02
///  获取当前版本数据
///  DHCWL.VerManagement.VerData
///  js:formload.js
/// -------------------------------------------------------------------------------------------------------------------------------------------------------------///
Query GetVersion() As %Query(ROWSPEC = "vmDr:%Integer,vmdName:%String,vmdCode:%String,vmdTSName:%String,vmdUpDate:%String,vmdInstallDate:%String,vmdInstallTime:%String,vmdRemarks:%String") [ SqlProc ]
{
}

/*d ##class(%ResultSet).RunQuery("DHCWL.VerManagement.DefaultInOutService","GetVersion")  */
/// 为页面提供当前版本query
ClassMethod GetVersionExecute(ByRef qHandle As %Binary) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 k ^||TMPDHCWL($j)
 s vmDr="" f  s vmDr=$o(^DHCWL.VerManagement.VerDataD(vmDr),-1) q:vmDr=""  d
 .s vmdName=$listget(^DHCWL.VerManagement.VerDataD(vmDr),2,"")
 .q:$d(^||TMPDHCWL($j,vmdName))
 .s ^||TMPDHCWL($j,vmdName)=""
 .s vmdCode=$listget(^DHCWL.VerManagement.VerDataD(vmDr),3,"")
 .s vmdTSName=$listget(^DHCWL.VerManagement.VerDataD(vmDr),4,"")
 .s vmdUpDate=$listget(^DHCWL.VerManagement.VerDataD(vmDr),5,"")
 .s vmdUpDate=##class(websys.Conversions).DateHtmlToLogical(vmdUpDate)
 .s vmdUpDate=##class(websys.Conversions).DateLogicalToHtml(vmdUpDate)
 .s vmdRemarks=$listget(^DHCWL.VerManagement.VerDataD(vmDr),6,"")
 .s vmdInstallDate=$listget(^DHCWL.VerManagement.VerDataD(vmDr),7,"")
 .s vmdInstallDate=##class(websys.Conversions).DateHtmlToLogical(vmdInstallDate)
 .s vmdInstallDate=##class(websys.Conversions).DateLogicalToHtml(vmdInstallDate)
 .s vmdInstallTime=$listget(^DHCWL.VerManagement.VerDataD(vmDr),8,"")
 .d OutputRow
 k ^||TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
	
	
OutputRow
	set Data=$lb(vmDr,vmdName,vmdCode,vmdTSName,vmdUpDate,vmdInstallDate,vmdInstallTime,vmdRemarks)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetVersionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NewQuery1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetVersionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NewQuery1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// -----------------------------------------------------------------------------------------------------------------------------------------///
Query GetHisByRowID(rowid) As %Query(ROWSPEC = "hisID:%String,hisName:%String,hisCode:%String,hisTSName:%String,hisUpDate:%String,hisInstallDate:%String,hisInstallTime:%String,hisRemarks:%String") [ SqlProc ]
{
}

///  pl
///  2016-02-02
///  获取所有版本数据
///  DHCWL.VerManagement.VerData
///  js:showvminfo.js
///  d ##class(%ResultSet).RunQuery("DHCWL.VerManagement.DefaultInOutService","GetHisByRowID","1")  
/// 为页面提历史数据query
ClassMethod GetHisByRowIDExecute(ByRef qHandle As %Binary, rowid As %String) As %Status
{
 ;s rowid=4
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:rowid="" $$$OK
 b
 q:'$d(^DHCWL.VerManagement.VerDataD(rowid)) $$$OK
 s name=$listget(^DHCWL.VerManagement.VerDataD(rowid),2,"")
 ;s hisID="" f  s hisID=$o(^DHCWL.VerManagement.VerDataI("Name"," "_name,hisID),-1) q:hisID=""  d
 ;modify by wz.2017-6-1
 s hisID="" f  s hisID=$o(^DHCWL.VerManagement.VerDataI("Name"," "_$SYSTEM.SQL.ALPHAUP(name),hisID),-1) q:hisID=""  d
 .s hisName=$listget(^DHCWL.VerManagement.VerDataD(hisID),2,"")
 .s hisCode=$listget(^DHCWL.VerManagement.VerDataD(hisID),3,"")
 .s hisTSName=$listget(^DHCWL.VerManagement.VerDataD(hisID),4,"")
 .s hisUpDate=$listget(^DHCWL.VerManagement.VerDataD(hisID),5,"")
 .s hisUpDate=##class(websys.Conversions).DateHtmlToLogical(hisUpDate)
 .s hisUpDate=##class(websys.Conversions).DateLogicalToHtml(hisUpDate) 
 .s hisRemarks=$listget(^DHCWL.VerManagement.VerDataD(hisID),6,"")
 .s hisInstallDate=$listget(^DHCWL.VerManagement.VerDataD(hisID),7,"")
 .s hisInstallDate=##class(websys.Conversions).DateHtmlToLogical(hisInstallDate)
 .s hisInstallDate=##class(websys.Conversions).DateLogicalToHtml(hisInstallDate) 
 .s hisInstallTime=$listget(^DHCWL.VerManagement.VerDataD(hisID),8,"")

 .d OutputHis
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
	
	
OutputHis
	set Data=$lb(hisID,hisName,hisCode,hisTSName,hisUpDate,hisInstallDate,hisInstallTime,hisRemarks)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetHisByRowIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHisByRowID ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHisByRowIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NewQuery1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
