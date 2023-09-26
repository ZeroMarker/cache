/// 名称: DHCMA.Util.EPS.SpecimenSrv
/// 描述: 送检标本 服务类
/// 编写者：zhufei
/// 编写日期: 2019-01-17
Class DHCMA.Util.EPS.SpecimenSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-01-24
/// Description:  查询送检标本
/// Table：       DHCMA.Util.EPx.Specimen
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.EPS.SpecimenSrv","QrySpecimen","")
Query QrySpecimen(aAlias As %String = "", aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,OID:%String,BTCode:%String,BTDesc:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,UserID:%String,UserCode:%String,UserDesc:%String") [ SqlProc ]
{
}

ClassMethod QrySpecimenExecute(ByRef qHandle As %Binary, aAlias As %String = "", aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCMA.Util.EPx.SpecimenD(xID))
		Quit:xID=""
		
		Set objSpec = ##class(DHCMA.Util.EPx.Specimen).GetObjById(xID)
		Continue:'$Isobject(objSpec)
		Set IsActive  = objSpec.BTIsActive
		Continue:(aIsActive'="")&&(aIsActive'=IsActive)
		Set IsActDesc=$s(IsActive=1:"是",1:"否")  
		Set OID       = objSpec.OID
		Set Code      = objSpec.BTCode
		Set Desc      = objSpec.BTDesc
		Continue:(aAlias'="")&&((Code'[aAlias)&&(Desc'[aAlias))
	    Set ActDate   = objSpec.BTActDate 
	    Set:ActDate'="" ActDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	    Set ActTime  = objSpec.BTActTime  
	    Set:ActTime'="" ActTime=$zt(ActTime)   
	    Set ActUserID = objSpec.BTActUserID  
	    Set (UserCode,UserDesc)=""
	    Set objActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
		If $IsObject(objActUser){
		    Set UserCode = objActUser.BTCode
		    Set UserDesc = objActUser.BTDesc
	    }
		Set Data = $lb(xID,OID,Code,Desc,IsActive,IsActDesc,ActDate,ActTime,UserID,UserCode,UserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QrySpecimenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySpecimenExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySpecimenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySpecimenExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
