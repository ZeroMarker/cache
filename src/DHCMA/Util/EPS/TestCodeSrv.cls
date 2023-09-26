/// 名称: DHCMA.Util.EPS.TestCodeSrv
/// 描述: 检验项目 服务类
/// 编写者：zhufei
/// 编写日期: 2019-01-17
Class DHCMA.Util.EPS.TestCodeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-01-24
/// Description:  查询检验项目
/// Table：       DHCMA.Util.EPx.TestCode
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.EPS.TestCodeSrv","QryTestCode","白细胞")
Query QryTestCode(aAlias As %String = "", aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,OID:%String,BTCode:%String,BTDesc:%String,RstFormat:%String,AbFlagS:%String,ClDiagnos:%String,RefRanges:%String,WCode:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,UserID:%String,UserCode:%String,UserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryTestCodeExecute(ByRef qHandle As %Binary, aAlias As %String = "", aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCMA.Util.EPx.TestCodeD(xID))
		Quit:xID=""
		
		Set objTest = ##class(DHCMA.Util.EPx.TestCode).GetObjById(xID)
		Continue:'$Isobject(objTest)
		Set IsActive  = objTest.BTIsActive
		Continue:(aIsActive'="")&&(aIsActive'=IsActive)
		Set IsActDesc=$s(IsActive=1:"是",1:"否")  
		Set OID       = objTest.OID
		Set Code      = objTest.BTCode
		Set Desc      = objTest.BTDesc
		Continue:(aAlias'="")&&((Code'[aAlias)&&(Desc'[aAlias))
	    Set RstFormat = objTest.BTRstFormat
	    Set AbFlagS   = objTest.BTAbFlagS
		Set ClDiagnos = objTest.BTClDiagnos
	    Set RefRanges = objTest.BTRefRanges
	    Set WCode     = objTest.BTWCode
	    Set ActDate   = objTest.BTActDate 
	    Set:ActDate'="" ActDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	    Set ActTime  = objTest.BTActTime  
	    Set:ActTime'="" ActTime=$zt(ActTime)   
	    Set ActUserID = objTest.BTActUserID  
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

ClassMethod QryTestCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestCodeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTestCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestCodeExecute ]
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
