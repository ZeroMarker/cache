/// 名称: DHCMA.Util.EPS.AppPartSrv
/// 描述: 检查部位 服务类
/// 编写者：zhufei
/// 编写日期: 2020-03-06
Class DHCMA.Util.EPS.AppPartSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2020-03-06
/// Description:  查询检查部位
/// Table：       DHCMA.Util.EPx.AppPart
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.EPS.AppPartSrv","QryAppPart","")
Query QryAppPart(aAlias As %String = "", aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,OID:%String,Code:%String,Desc:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,UserID:%String,UserCode:%String,UserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryAppPartExecute(ByRef qHandle As %Binary, aAlias As %String = "", aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCMA.Util.EPx.AppPartD(xID))
		Quit:xID=""
		
		Set objAppPart = ##class(DHCMA.Util.EPx.AppPart).GetObjById(xID)
		Continue:'$Isobject(objAppPart)
		Set IsActive  = objAppPart.BTIsActive
		Continue:(aIsActive'="")&&(aIsActive'=IsActive)
		Set IsActDesc=$s(IsActive=1:"是",1:"否")  
		Set OID       = objAppPart.OID
		Set Code      = objAppPart.BTCode
		Set Desc      = objAppPart.BTDesc
		Continue:(aAlias'="")&&((Code'[aAlias)&&(Desc'[aAlias))
	    Set ActDate   = objAppPart.BTActDate 
	    Set:ActDate'="" ActDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	    Set ActTime  = objAppPart.BTActTime  
	    Set:ActTime'="" ActTime=$zt(ActTime)   
	    Set ActUserID = objAppPart.BTActUserID  
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

ClassMethod QryAppPartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAppPartExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAppPartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAppPartExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2020-03-06
/// Description:  根据检查医嘱查询检查部位
/// Table：       DHCMA.Util.EPx.AppArcLink、DHCMA.Util.EPx.OrdMast、DHCMA.Util.EPx.AppPart
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.EPS.AppPartSrv","QryAppPartByArcim","","")
Query QryAppPartByArcim(aArcim As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,OID:%String,Code:%String,Desc:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,UserID:%String,UserCode:%String,UserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryAppPartByArcimExecute(ByRef qHandle As %Binary, aArcim As %String = "", aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aArcim="")&&($l(aAlias)<2) $$$OK
	Set aAlias=$zcvt(aAlias,"U")
	
	Set xID=""
	For {
		Set xID=$o(^DHCMA.Util.EPx.AppPartD(xID))
		Quit:xID=""
		
		If aArcim'="" {
			//过滤检查项目对应部位
			Continue:'$d(^DHCMA.Util.EPx.AppArcLinkI("IdxOfALArcPart",aArcim,xID))
		}
		
		Set objAppPart=##class(DHCMA.Util.EPx.AppPart).GetObjById(xID)
		Continue:'$Isobject(objAppPart)
		Set OID       = objAppPart.OID
		Set Code      = objAppPart.BTCode
		Set Desc      = objAppPart.BTDesc
		
		Continue:(aAlias'="")&&(($zcvt(Code,"U")'[aAlias)&&($zcvt(Desc,"U")'[aAlias))
	    Set ActDate   = objAppPart.BTActDate 
	    Set IsActive  = objAppPart.BTIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")  
		
	    Set:ActDate'="" ActDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	    Set ActTime  = objAppPart.BTActTime  
	    Set:ActTime'="" ActTime=$zt(ActTime)   
	    Set ActUserID = objAppPart.BTActUserID  
	    Set (UserCode,UserDesc)=""
	    Set objActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
		If $IsObject(objActUser){
		    Set UserCode = objActUser.BTCode
		    Set UserDesc = objActUser.BTDesc
	    }
		Set Data = $lb(xID,OID,Code,Desc,IsActive,IsActDesc,ActDate,ActTime,ActUserID,UserCode,UserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryAppPartByArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAppPartByArcimExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAppPartByArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAppPartByArcimExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2020-03-06
/// Description:  根据检查部位查询检查医嘱
/// Table：       DHCMA.Util.EPx.OrdMast
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.EPS.AppPartSrv","QryArcimByAppPart","","")
Query QryArcimByAppPart(aAPID As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,OID:%String,BTCode:%String,BTDesc:%String,CatDesc:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,UserID:%String,UserCode:%String,UserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryArcimByAppPartExecute(ByRef qHandle As %Binary, aAPID As %String = "", aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAlias=$zcvt(aAlias,"U")
	
	Set xSysDr=0
	For {
		Set xSysDr=$o(^DHCMA.Util.EPx.OrdMastI("IdxOfType",xSysDr))
		Quit:xSysDr=""
		
		Set xID=""
		For {
			Set xID=$o(^DHCMA.Util.EPx.OrdMastI("IdxOfType",xSysDr," X",xID))
			Quit:xID=""
			
			If aAPID'="" {
				//过滤检验项目对应医嘱
				Continue:'$d(^DHCMA.Util.EPx.AppArcLinkI("IdxOfALPartArc",xID,aAPID))
			}
			
			Set objOrdMast = ##class(DHCMA.Util.EPx.OrdMast).GetObjById(xID)
			Continue:'$Isobject(objOrdMast)
			
			Set IsActive  = objOrdMast.BTIsActive
			Set IsActDesc=$s(IsActive=1:"是",1:"否")  
			Set OID       = objOrdMast.OID
			Set Code      = objOrdMast.BTCode
			Set Desc      = objOrdMast.BTDesc
			Continue:(aAlias'="")&&(($zcvt(Code,"U")'[aAlias)&&($zcvt(Desc,"U")'[aAlias))
			Set CatDesc   = objOrdMast.BTCatDesc
		    Set ActDate   = objOrdMast.BTActDate 
		    Set:ActDate'="" ActDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		    Set ActTime  = objOrdMast.BTActTime  
		    Set:ActTime'="" ActTime=$zt(ActTime)   
		    Set ActUserID = objOrdMast.BTActUserID  
		    Set (UserCode,UserDesc)=""
		    Set objActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
			If $IsObject(objActUser){
			    Set UserCode = objActUser.BTCode
			    Set UserDesc = objActUser.BTDesc
		    }
			Set Data = $lb(xID,OID,Code,Desc,CatDesc,IsActive,IsActDesc,ActDate,ActTime,UserID,UserCode,UserDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryArcimByAppPartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryArcimByAppPartExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryArcimByAppPartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryArcimByAppPartExecute ]
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
