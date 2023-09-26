Class DHCMA.CPW.SDS.PCEntitySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     xuwenjie
/// CreatDate：   2018-08-29
/// Description:  查询付费病种信息
/// Table：       DHCMA.CPW.SD.PCEntity      
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.PCEntitySrv","QryPCEntity")
Query QryPCEntity() As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTIsActive:%String,BTIndNo:%Integer,BTDiagnos:%String,BTICD10:%String,BTOperation:%String,BTICD9CM:%String,BTReferCost:%Integer,BTWarningCost:%Integer,BTHospitalDays:%Integer,BTIntervalDays:%Integer")
{
}

ClassMethod QryPCEntityExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
 	Set xRowID=0
 	For
 	{
	 	Set xRowID        = $o(^DHCMA.CPW.SD.PCEntityD(xRowID))
	 	Quit:xRowID=""
	 	Set ObjEntity        = ##class(DHCMA.CPW.SD.PCEntity).GetObjById(xRowID)
	 	Set Code                     = ObjEntity.BTCode
	 	Set Desc                     = ObjEntity.BTDesc  
		Set IsActive                 = ObjEntity.BTIsActive
		Set IsActive = $s(IsActive=1:"是",1:"否")
		Set IndNo                    = ObjEntity.BTIndNo
		Set Diagnos                  = ObjEntity.BTDiagnos
		Set ICD10                    = ObjEntity.BTICD10
		Set Operation                = ObjEntity.BTOperation
		Set ICD9CM                   = ObjEntity.BTICD9CM
		Set ReferCost                = ObjEntity.BTReferCost
		Set WarningCost              = ObjEntity.BTWarningCost
		Set HospitalDays             = ObjEntity.BTHospitalDays
		Set IntervalDays             = ObjEntity.BTIntervalDays
		Set:Desc'="" Desc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.CPW.SD.PCEntity","BTDesc",Languages,Desc)
		Set:IsActive'="" IsActive=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.Util.BT.Dictionary","BTDesc",Languages,IsActive)
		Set Data=$lb(xRowID,Code,Desc,IsActive,IndNo,Diagnos,ICD10,Operation,ICD9CM,ReferCost,WarningCost,HospitalDays,IntervalDays)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPCEntityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPCEntityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPCEntityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPCEntityExecute ]
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

}
