/// 名称: DHCMA.Util.EPS.TestSetSrv
/// 描述: 检验医嘱 服务类
/// 编写者：zhufei
/// 编写日期: 2019-01-17
Class DHCMA.Util.EPS.TestSetSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-01-24
/// Description:  查询检验医嘱
/// Table：       DHCMA.Util.EPx.TestSet
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.EPS.TestSetSrv","QryTestSet","")
Query QryTestSet(aAlias As %String = "", aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,OID:%String,BTCode:%String,BTDesc:%String,BTCode2:%String,BTDesc2:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,UserID:%String,UserCode:%String,UserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryTestSetExecute(ByRef qHandle As %Binary, aAlias As %String = "", aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCMA.Util.EPx.TestSetD(xID))
		Quit:xID=""
		
		Set objOrd = ##class(DHCMA.Util.EPx.TestSet).GetObjById(xID)
		Continue:'$Isobject(objOrd)
		Set IsActive  = objOrd.BTIsActive
		Continue:(aIsActive'="")&&(aIsActive'=IsActive)
		Set IsActDesc=$s(IsActive=1:"是",1:"否")  
		Set OID       = objOrd.OID
		Set Code      = objOrd.BTCode
		Set Desc      = objOrd.BTDesc
		Continue:(aAlias'="")&&((Code'[aAlias)&&(Desc'[aAlias))
		Set Code2     = objOrd.BTCode2
		Set Desc2     = objOrd.BTDesc2
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
		Set Data = $lb(xID,OID,Code,Desc,Code2,Desc2,IsActive,IsActDesc,ActDate,ActTime,UserID,UserCode,UserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryTestSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestSetExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTestSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestSetExecute ]
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

/// Creator：     pylian
/// CreatDate：   2019-01-24
/// Description:  根据检验医嘱查询检验项目
/// Table：       DHCMA.Util.EPx.TestSetTC、DHCMA.Util.EPx.TestSet、DHCMA.Util.EPx.TestCode
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.EPS.TestSetSrv","QryTestCodeByTS","","T0460")
Query QryTestCodeByTS(aTSID As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,OID:%String,BTCode:%String,BTDesc:%String,RstFormat:%String,AbFlagS:%String,ClDiagnos:%String,RefRanges:%String,WCode:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,UserID:%String,UserCode:%String,UserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryTestCodeByTSExecute(ByRef qHandle As %Binary, aTSID As %String = "", aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aTSID="")&&($l(aAlias)<2) $$$OK
	Set aAlias=$zcvt(aAlias,"U")
	
	Set xID=""
	For {
		Set xID=$o(^DHCMA.Util.EPx.TestCodeD(xID))
		Quit:xID=""
		
		If aTSID'="" {
			//过滤检验项目对应医嘱
			Continue:'$d(^DHCMA.Util.EPx.TestSetTCI("IdxOfTestSetTC",aTSID,xID))
		}
		
		Set objTC=##class(DHCMA.Util.EPx.TestCode).GetObjById(xID)
		Continue:'$Isobject(objTC)
		Set OID       = objTC.OID
		Set Code      = objTC.BTCode
		Set Desc      = objTC.BTDesc
		
		Continue:(aAlias'="")&&(($zcvt(Code,"U")'[aAlias)&&($zcvt(Desc,"U")'[aAlias))
	    Set RstFormat = objTC.BTRstFormat
	    Set AbFlagS   = objTC.BTAbFlagS
		Set ClDiagnos = objTC.BTClDiagnos
	    Set RefRanges = objTC.BTRefRanges
	    Set WCode     = objTC.BTWCode
	    Set ActDate   = objTC.BTActDate 
	    Set IsActive  = objTC.BTIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")  
		
	    Set:ActDate'="" ActDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	    Set ActTime  = objTC.BTActTime  
	    Set:ActTime'="" ActTime=$zt(ActTime)   
	    Set ActUserID = objTC.BTActUserID  
	    Set (UserCode,UserDesc)=""
	    Set objActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
		If $IsObject(objActUser){
		    Set UserCode = objActUser.BTCode
		    Set UserDesc = objActUser.BTDesc
	    }
		Set Data = $lb(xID,OID,Code,Desc,RstFormat,AbFlagS,ClDiagnos,RefRanges,WCode,IsActive,IsActDesc,ActDate,ActTime,ActUserID,UserCode,UserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryTestCodeByTSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestCodeByTSExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTestCodeByTSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestCodeByTSExecute ]
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

/// Creator：     pylian
/// CreatDate：   2019-01-24
/// Description:  根据检验项目查询检验医嘱
/// Table：       DHCMA.Util.EPx.TestSet
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.EPS.TestSetSrv","QryTestSetByTC","","艾滋")
Query QryTestSetByTC(aTCID As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,OID:%String,BTCode:%String,BTDesc:%String,BTCode2:%String,BTDesc2:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,UserID:%String,UserCode:%String,UserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryTestSetByTCExecute(ByRef qHandle As %Binary, aTCID As %String = "", aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAlias=$zcvt(aAlias,"U")
	
	Set xID=""
	For {
		Set xID=$o(^DHCMA.Util.EPx.TestSetD(xID))
		Quit:xID=""
		
		If aTCID'="" {
			//过滤检验项目对应医嘱
			Continue:'$d(^DHCMA.Util.EPx.TestSetTCI("IdxOfTestSetTC",xID,aTCID))
		}
		
		Set objOrd = ##class(DHCMA.Util.EPx.TestSet).GetObjById(xID)
		Continue:'$Isobject(objOrd)
		
		Set IsActive  = objOrd.BTIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")  
		Set OID       = objOrd.OID
		Set Code      = objOrd.BTCode
		Set Desc      = objOrd.BTDesc
		
		Continue:(aAlias'="")&&(($zcvt(Code,"U")'[aAlias)&&($zcvt(Desc,"U")'[aAlias))
		Set Code2     = objOrd.BTCode2
		Set Desc2     = objOrd.BTDesc2
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
		Set Data = $lb(xID,OID,Code,Desc,Code2,Desc2,IsActive,IsActDesc,ActDate,ActTime,UserID,UserCode,UserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryTestSetByTCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestSetByTCExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTestSetByTCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestSetByTCExecute ]
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
