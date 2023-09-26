Class CIS.AN.BL.ArcimRule Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2019-01-04
/// Description： 	查询自动生成医嘱规则
/// Table：        	CF_AN.ArcimRule
/// Input:			filterDesc:筛选字符串
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ArcimRule","FindArcimRules")
Query FindArcimRules(filterDesc As %String, hospId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   Code,
	   Description,
	   Alias,
	   DataAttribution,
	   %ODBCOUT(EndDate) As EndDate
	   from CF_AN.ArcimRule
	   where ((UPPER(Description) [ UPPER(:filterDesc)) or (UPPER(Alias) [ UPPER(:filterDesc)) or (:filterDesc is null))
	   and ((:hospId is null) or (DataAttribution is null) or (DataAttribution->HospitalID=:hospId))
}

/// Creator：      	陈长青
/// CreatDate：    	2019-01-05
/// Description： 	查询麻醉方法关联的医嘱项
/// Table：        	CF_AN.AnaMethodArcim
/// Input:			arcimRuleID:自动生成医嘱规则ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ArcimRule","FindAnaMethodArcim","1")
Query FindAnaMethodArcim(arcimRuleID As %String, anaMethodId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   AnaMethod,
	   CIS_AN_COM.String_GetDescByID('User.ORCAnaestMethod','ANMETDesc',AnaMethod) As AnaMethodDesc, 
	   MethodArcimID,
	   CIS_AN_COM.String_GetDescByID('User.ARCItmMast','ARCIMDesc',MethodArcimID) As MethodArcimDesc,
	   TimeOutHours,
	   TimeOutArcimID,
	   CIS_AN_COM.String_GetDescByID('User.ARCItmMast','ARCIMDesc',TimeOutArcimID) As TimeOutArcimDesc,
	   OrderSet,
	   CIS_AN_COM.String_GetDescByID('User.ARCOrdSets','ARCOSDesc',OrderSet) As OrderSetDesc,
	   Rule,
	   PackQty,
	   PackUom,
	   CIS_AN_COM.String_GetDescByID('User.CTUOM','CTUOMDesc',PackUom) As PackUomDesc,
	   DoseQty,
	   DoseUom,
	   CIS_AN_COM.String_GetDescByID('User.CTUOM','CTUOMDesc',DoseUom) As DoseUomDesc,
	   Instruction,
	   CIS_AN_COM.String_GetDescByID('User.PHCInstruc','PHCINDesc1',Instruction) As InstrDesc,
	   RecvLoc,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',RecvLoc) As RecvLocDesc
	   from CF_AN.AnaMethodArcim
	   where Rule=:arcimRuleID
	   and (AnaMethod=:anaMethodId or :anaMethodId is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2019-01-05
/// Description： 	查询麻醉导管关联的医嘱项
/// Table：        	CF_AN.CatheterArcim
/// Input:			arcimRuleID:自动生成医嘱规则ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ArcimRule","FindCatheterArcim")
Query FindCatheterArcim(arcimRuleID As %String, catheterId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   Catheter,
	   Catheter->Description As CatheterDesc,
	   CatheterType,
	   CatheterType->Description As CatheterTypeDesc,
	   PosMethod,
	   PosMethod->Description As PosMethodDesc,
	   ArcimID,
	   CIS_AN_COM.String_GetDescByID('User.ARCItmMast','ARCIMDesc',ArcimID) As ArcimDesc,
	   OrderSet,
	   CIS_AN_COM.String_GetDescByID('User.ARCOrdSets','ARCOSDesc',OrderSet) As OrderSetDesc,
	   Rule,
	   PackQty,
	   PackUom,
	   CIS_AN_COM.String_GetDescByID('User.CTUOM','CTUOMDesc',PackUom) As PackUomDesc,
	   DoseQty,
	   DoseUom,
	   CIS_AN_COM.String_GetDescByID('User.CTUOM','CTUOMDesc',DoseUom) As DoseUomDesc,
	   Instruction,
	   CIS_AN_COM.String_GetDescByID('User.PHCInstruc','PHCINDesc1',Instruction) As InstrDesc,
	   RecvLoc,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',RecvLoc) As RecvLocDesc
	   from CF_AN.CatheterArcim
	   where Rule=:arcimRuleID
	   and (Catheter=:catheterId or :catheterId is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2019-01-05
/// Description： 	查询事件数据项关联的医嘱项
/// Table：        	CF_AN.EventArcim
/// Input:			arcimRuleID:自动生成医嘱规则ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ArcimRule","FindEventArcim","1")
Query FindEventArcim(arcimRuleID As %String, eventItemId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   EventItem,
	   EventItem->Description As EventItemDesc,
	   DetailItem,
	   DetailItem->Description As DetailItemDesc,
	   EventValueRule,
	   DetailValueRule,
	   ArcimID,
	   CIS_AN_COM.String_GetDescByID('User.ARCItmMast','ARCIMDesc',ArcimID) As ArcimDesc,
	   OrderSet,
	   CIS_AN_COM.String_GetDescByID('User.ARCOrdSets','ARCOSDesc',OrderSet) As OrderSetDesc,
	   Rule,
	   PackQty,
	   PackUom,
	   CIS_AN_COM.String_GetDescByID('User.CTUOM','CTUOMDesc',PackUom) As PackUomDesc,
	   DoseQty,
	   DoseUom,
	   CIS_AN_COM.String_GetDescByID('User.CTUOM','CTUOMDesc',DoseUom) As DoseUomDesc,
	   Instruction,
	   CIS_AN_COM.String_GetDescByID('User.PHCInstruc','PHCINDesc1',Instruction) As InstrDesc,
	   RecvLoc,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',RecvLoc) As RecvLocDesc,
	   AlertQty
	   from CF_AN.EventArcim
	   where Rule=:arcimRuleID
	   and (EventItem=:eventItemId or :eventItemId is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2019-01-05
/// Description： 	查询药品数据项关联的医嘱项
/// Table：        	CF_AN.DrugArcim
/// Input:			arcimRuleID:自动生成医嘱规则ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ArcimRule","FindDrugArcim")
Query FindDrugArcim(arcimRuleID As %String, drugItemId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   DrugItem,
	   DrugItem->Description As DrugItemDesc,
	   ArcimID,
	   CIS_AN_COM.String_GetDescByID('User.ARCItmMast','ARCIMDesc',ArcimID) As ArcimDesc,
	   Rule,
	   PackQty,
	   PackUom,
	   CIS_AN_COM.String_GetDescByID('User.CTUOM','CTUOMDesc',PackUom) As PackUomDesc,
	   DoseQty,
	   DoseUom,
	   CIS_AN_COM.String_GetDescByID('User.CTUOM','CTUOMDesc',DoseUom) As DoseUomDesc,
	   Instruction,
	   CIS_AN_COM.String_GetDescByID('User.PHCInstruc','PHCINDesc1',Instruction) As InstrDesc,
	   RecvLoc,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',RecvLoc) As RecvLocDesc,
	   AlertQty
	   from CF_AN.DrugArcim
	   where Rule=:arcimRuleID
	   and (DrugItem=:drugItemId or :drugItemId is null)
}

/// Creator：      	雍阳
/// CreatDate：    	2019-10-31
/// Description： 	查询药品数据项对照医嘱项的关联数据ID
/// Table：        	DHCAN_Config.DrugArcim
/// Input:			arcimRuleID:自动生成医嘱规则ID
/// Return：       	ResultSet
/// w ##class(CIS.AN.BL.ArcimRule).GetDrugArcim("11","1136||1")
ClassMethod GetDrugArcim(dataItemId As %String, arcimId As %String) As %String
{
	quit:dataItemId="" ""
	quit:arcimId="" ""
	
	set drugArcimId="",foundRowId=""
	for
	{
		set drugArcimId=$o(^CF.AN.DrugArcimI("IDrugItem",dataItemId,drugArcimId))
		quit:drugArcimId=""
		
		set drugArcim=##class(CF.AN.DrugArcim).%OpenId(drugArcimId)
		continue:drugArcim.Rule=""
		set ruleEnddate=""
		set Rule=##class(CF.AN.ArcimRule).%OpenId(drugArcim.Rule.%Id())
		if (Rule.EndDate'="") set ruleEnddate=Rule.EndDate
		
		continue:(ruleEnddate'="")&&(ruleEnddate<+$h)
		if drugArcim.ArcimID=arcimId 
		{
			set foundRowId=drugArcimId
			quit
		}
	}
	
	quit foundRowId
}

}
