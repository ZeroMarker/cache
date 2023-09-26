Class DHCMA.CPW.SDS.QCEntityVersionSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2020-10-22
/// Description:  查询质控病种版本信息
/// Table：       DHCMA.CPW.SD.QCEntityVersion      
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCEntityVersionSrv","QryQCEntityVer","33")
Query QryQCEntityVer(aQCID As %String = "", aVersion As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,SDate:%String,EDate:%String")
{
}

ClassMethod QryQCEntityVerExecute(ByRef qHandle As %Binary, aQCID As %String = "", aVersion As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	For
 	{
	 	Set xRowID      = $o(^DHCMA.CPW.SD.QCEntityVersionD(xRowID))
	 	Quit:xRowID=""
	 	If (aQCID'="") {
		 	Set ObjQC	= ##class(DHCMA.CPW.SD.QCEntity).GetObjById(aQCID)
		 	Set CurVerID= ObjQC.BTVersion.%Id()
		 	//查询表单历史版本，高版本过滤
			Continue:(aVersion'="")&&(xRowID>=aVersion)
	 	}
	 	Set objVer        = ##class(DHCMA.CPW.SD.QCEntityVersion).GetObjById(xRowID)
	 	Set Code          = objVer.VerCode
	 	Set Desc          = objVer.VerDesc  
	 	Set SDate         = objVer.VerSDate
	 	Set EDate         = objVer.VerEDate
	 	Set:SDate'="" SDate=$zd(SDate,3) 
	 	Set:EDate'="" EDate=$zd(EDate,3) 
		Set Data=$lb(xRowID,Code,Desc,SDate,EDate)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryQCEntityVerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCEntityVerExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCEntityVerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCEntityVerExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取病种当前版本
ClassMethod GetQCVerID(aQCID As %String) As %String
{
	new (aQCID)
	Set ret=""
	Set ObjQC	= ##class(DHCMA.CPW.SD.QCEntity).GetObjById(aQCID)
	Quit:'$IsObject(ObjQC) ret
	Set ret= ObjQC.BTVersion.%Id()
	Quit ret
}

}
