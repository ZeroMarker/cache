/// 名称: DHCHAI.IRS.CCRuleDefSrv
/// 描述: 感染诊断标准定义相关服务
/// 编写者：zhufei
/// 编写日期: 2017-03-20
Class DHCHAI.IRS.CCRuleDefSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-05-02
/// Description:  查询感染诊断标准
/// Table：       DHCHAI.IR.CRuleDef
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCRuleDefSrv","QryCRuleDef")
Query QryCRuleDef(aActive As %String = "") As %Query(ROWSPEC = "ID:%String,InfPosID:%String,InfPosCode:%String,InfPosDesc:%String,Title:%String,Note:%String,IndNo:%String,IsActive:%String,IsActDesc:%String,MaxAge:%String,MinAge:%String") [ SqlProc ]
{
}

ClassMethod QryCRuleDefExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.CRuleDefD(xID))
		Quit:xID=""
		
		Set objDef = ##class(DHCHAI.IR.CRuleDef).GetObjById(xID)
		Continue:'$Isobject(objDef)
		
		Set InfPosDr = objDef.BTInfPosDr
		Set InfPosID="",InfPosCode="",InfPosDesc=""
		If $IsObject(objDef.BTInfPosDr) {
			Set InfPosID	= objDef.BTInfPosDr.%Id()
			Set InfPosCode	= objDef.BTInfPosDr.BTCode
			Set InfPosDesc	= objDef.BTInfPosDr.BTDesc	
		}   	
		Set Title    = objDef.BTTitle
		Set Note     = objDef.BTNote
		Set IndNo    = objDef.BTIndNo
		Set IsActive = objDef.BTIsActive
		Continue:(aActive'="")&&(IsActive'=aActive)
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set MaxAge   = objDef.BTMaxAge
		Set MinAge   = objDef.BTMinAge
				
		Set Data = $lb(xID,InfPosID,InfPosCode,InfPosDesc,Title,Note,IndNo,IsActive,IsActDesc,MaxAge,MinAge)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryCRuleDefClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCRuleDefExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCRuleDefFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCRuleDefExecute ]
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
/// CreatDate：   2017-05-02
/// Description:  查询医院感染诊断定义
/// Table：       DHCHAI.IR.CRuleDefExt
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCRuleDefSrv","QryCRuleDefExt","1")
Query QryCRuleDefExt(aRuleDefID As %String) As %Query(ROWSPEC = "ID:%String,RuleDefID:%String,Title:%String,Note:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String,IndNo:%String,IsActive:%String,IsActDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCRuleDefExtExecute(ByRef qHandle As %Binary, aRuleDefID As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

    Quit:(aRuleDefID="") $$$OK
	Set xExtID = ""
	For {
		Set xExtID = $o(^DHCHAI.IR.CRuleDefD(aRuleDefID,"ITM",xExtID))
		Quit:xExtID=""
		Set xID=aRuleDefID_"||"_xExtID
		Set objDefExt = ##class(DHCHAI.IR.CRuleDefExt).GetObjById(xID)
		Continue:'$Isobject(objDefExt)
		
		Set Title    = objDefExt.BTTitle
		Set Note     = objDefExt.BTNote
		Set TypeDr   = objDefExt.BTTypeDr
		Set TypeID="",TypeCode="",TypeDesc=""
		If $IsObject(objDefExt.BTTypeDr) {
			Set TypeID	    = objDefExt.BTTypeDr.%Id()
			Set TypeCode	= objDefExt.BTTypeDr.BTCode
			Set TypeDesc	= objDefExt.BTTypeDr.BTDesc	
		}   	
		Set IndNo    = objDefExt.BTIndNo
		Set IsActive = objDefExt.BTIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		
		Set Data = $lb(xID,RuleDefID,Title,Note,TypeID,TypeCode,TypeDesc,IndNo,IsActive,IsActDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryCRuleDefExtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCRuleDefExtExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCRuleDefExtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCRuleDefExtExecute ]
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
