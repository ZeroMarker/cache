/// 名称: DHCMA.Util.EPS.OrdMastSrv
/// 描述: 医嘱项 服务类
/// 编写者：zhufei
/// 编写日期: 2019-01-17
Class DHCMA.Util.EPS.OrdMastSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-01-24
/// Description:  查询医嘱项
/// Table：       DHCMA.Util.EPx.OrdMast
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.EPS.OrdMastSrv","QryOrdMast","","")
Query QryOrdMast(aAlias As %String = "", aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,OID:%String,BTCode:%String,BTDesc:%String,CatDesc:%String,Type:%String,TypeDesc:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,UserID:%String,UserCode:%String,UserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOrdMastExecute(ByRef qHandle As %Binary, aAlias As %String = "", aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCMA.Util.EPx.OrdMastD(xID))
		Quit:xID=""
		
		Set objOrd = ##class(DHCMA.Util.EPx.OrdMast).GetObjById(xID)
		Continue:'$Isobject(objOrd)
		Set IsActive  = objOrd.BTIsActive
		Continue:(aIsActive'="")&&(aIsActive'=IsActive)
		Set IsActDesc=$s(IsActive=1:"是",1:"否")  
		Set OID       = objOrd.OID
		Set Code      = objOrd.BTCode
		Set Desc      = objOrd.BTDesc
		Continue:(aAlias'="")&&((Code'[aAlias)&&(Desc'[aAlias))
		Set CatDesc   = objOrd.BTCatDesc
		Set Type      = objOrd.BTType
		Set TypeDesc =""	
		Set TypeDesc=$s(Type="R":"药品",Type="L":"药品",Type="X":"检查",1:"其他")  
	    Set ActDate   = objOrd.BTActDate 
	    Set:ActDate'="" ActDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	    Set ActTime  = objOrd.BTActTime  
	    Set:ActTime'="" ActTime=$zt(ActTime)   
	    Set ActUserID = objOrd.BTActUserID  
	    Set (UserCode,UserDesc)=""
	    Set objActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
		If $IsObject(objActUser){
		    Set UserCode = objActUser.BTCode
		    Set UserDesc = objActUser.BTDesc
	    }
		Set Data = $lb(xID,OID,Code,Desc,CatDesc,Type,TypeDesc,IsActive,IsActDesc,ActDate,ActTime,UserID,UserCode,UserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryOrdMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOrdMastExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOrdMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOrdMastExecute ]
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
