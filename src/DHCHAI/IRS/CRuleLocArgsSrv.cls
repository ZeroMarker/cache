/// 名称: DHCHAI.IRS.CRuleLocArgsSrv
/// 描述: 科室参数设置
/// 编写者：zhufei
/// 编写日期: 2017-09-02
Class DHCHAI.IRS.CRuleLocArgsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-05-05
/// Description:  根据科室取参数设置
/// Table：       DHCHAI.IR.CRuleLocArgs
/// Input：       aLocDr : 科室ID
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CRuleLocArgsSrv).GetArgsByLocDr(9)
ClassMethod GetArgsByLocDr(aLocDr As %String) As %String
{
	New (aLocDr)
	Set return=""
	Quit:aLocDr="" return
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocDr)
	Quit:'$IsObject(objLoc) return
	Quit:'$IsObject(objLoc.BTHospDr) return
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) return
	Set LocDr=objLoc.%Id()
	Set HospDr=objLoc.BTHospDr.%Id()
	Set HospGrpDr=objLoc.BTHospDr.BTGroupDr.%Id()
	
	If $d(^DHCHAI.IR.CRuleLocArgsI("IndexTypeLocDr",3,LocDr)) {
		Set ID=$o(^DHCHAI.IR.CRuleLocArgsI("IndexTypeLocDr",3,LocDr,0))
		Set objArgs=##class(DHCHAI.IR.CRuleLocArgs).GetObjById(ID)
		If $IsObject(objArgs) {
			Set:$p(return,"^",1)="" $p(return,"^",1)=objArgs.BTFeverMax
			Set:$p(return,"^",2)="" $p(return,"^",2)=objArgs.BTFeverMin
			Set:$p(return,"^",3)="" $p(return,"^",3)=objArgs.BTDiarrMin
			Set:$p(return,"^",4)="" $p(return,"^",4)=objArgs.BTDiarrMin2
		}
	}
	
	If $d(^DHCHAI.IR.CRuleLocArgsI("IndexTypeHospDr",2,HospDr)) {
		Set ID=$o(^DHCHAI.IR.CRuleLocArgsI("IndexTypeHospDr",2,HospDr,0))
		Set objArgs=##class(DHCHAI.IR.CRuleLocArgs).GetObjById(ID)
		If $IsObject(objArgs) {
			Set:$p(return,"^",1)="" $p(return,"^",1)=objArgs.BTFeverMax
			Set:$p(return,"^",2)="" $p(return,"^",2)=objArgs.BTFeverMin
			Set:$p(return,"^",3)="" $p(return,"^",3)=objArgs.BTDiarrMin
			Set:$p(return,"^",4)="" $p(return,"^",4)=objArgs.BTDiarrMin2
		}
	}
	
	If $d(^DHCHAI.IR.CRuleLocArgsI("IndexTypeHospGrpDr",1,HospGrpDr)) {
		Set ID=$o(^DHCHAI.IR.CRuleLocArgsI("IndexTypeHospGrpDr",1,HospGrpDr,0))
		Set objArgs=##class(DHCHAI.IR.CRuleLocArgs).GetObjById(ID)
		If $IsObject(objArgs) {
			Set:$p(return,"^",1)="" $p(return,"^",1)=objArgs.BTFeverMax
			Set:$p(return,"^",2)="" $p(return,"^",2)=objArgs.BTFeverMin
			Set:$p(return,"^",3)="" $p(return,"^",3)=objArgs.BTDiarrMin
			Set:$p(return,"^",4)="" $p(return,"^",4)=objArgs.BTDiarrMin2
		}
	}
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-09-04
/// Description:  取科室参数设置信息
/// Table：       DHCHAI.IR.CRuleLocArgs
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleLocArgsSrv","QryCRuleLocArgs")
Query QryCRuleLocArgs() As %Query(ROWSPEC = "ID:%String,Type:%String,GrpID:%String,GrpDesc:%String,HospID:%String,HospDesc:%String,LocID:%String,LocDesc:%String,FeverMax:%String,FeverMin:%String,DiarrMin:%String,DiarrMin2:%String,ActDate:%String,ActTime:%String,UserID:%String,UserName:%String")
{
}

ClassMethod QryCRuleLocArgsExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.IR.CRuleLocArgsD(xID))
		Quit:xID=""
		
		Set objLoc=##class(DHCHAI.IR.CRuleLocArgs).GetObjById(xID)
		Continue:'$isobject(objLoc)
		
		Set Type = objLoc.BTType
		If $IsObject(objLoc.BTHospGrpDr) {
			Set GrpID   = objLoc.BTHospGrpDr.%Id()  
			Set GrpCode = objLoc.BTHospGrpDr.BTCode
			Set GrpDesc = objLoc.BTHospGrpDr.BTDesc
	    }Else {
			Set (GrpID,GrpCode,GrpDesc)=""   
		}
		If $IsObject(objLoc.BTHospDr) {
			Set HospID   = objLoc.BTHospDr.%Id()  
			Set HospCode = objLoc.BTHospDr.BTCode
			Set HospDesc = objLoc.BTHospDr.BTDesc
	    }Else {
			Set (HospID,HospCode,HospDesc)=""   
		}
		If $IsObject(objLoc.BTLocDr) {
			Set LocID   = objLoc.BTLocDr.%Id()  
			Set LocCode = objLoc.BTLocDr.BTCode
			Set LocDesc = objLoc.BTLocDr.BTDesc
			Set LocDesc2 = objLoc.BTLocDr.BTDesc2
			Set:LocDesc2'="" LocDesc=LocDesc2
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	    }Else {
			Set (LocID,LocCode,LocDesc)=""   
		}
		Set FeverMax = objLoc.BTFeverMax
		Set FeverMin = objLoc.BTFeverMin
		Set DiarrMin = objLoc.BTDiarrMin
		Set DiarrMin2 = objLoc.BTDiarrMin2
		
		Set ActDate = objLoc.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime = objLoc.BTActTime
		Set:ActTime'="" ActTime = $zt(ActTime,1)
		If $IsObject(objLoc.BTActUser) {
			Set UserID   = objLoc.BTActUser.%Id()
			Set UserName = objLoc.BTActUser.BTDesc
	    }Else {
			Set (UserID,UserName)=""   
		}
		
		Set Data = $lb(xID,Type,GrpID,GrpDesc,HospID,HospDesc,LocID,LocDesc,FeverMax,FeverMin,DiarrMin,DiarrMin2,ActDate,ActTime,UserID,UserName)
		Set ^CacheTemp(repid,ind) = Data
		Set ind = ind+1
	}
	Quit $$$OK
}

ClassMethod QryCRuleLocArgsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCRuleLocArgsExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCRuleLocArgsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCRuleLocArgsExecute ]
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
