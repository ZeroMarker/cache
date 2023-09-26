/// 名称: DHCMA.CPW.BTS.PathFormItemSrv
/// 描述: 路径项目服务类
/// 编写者：yankai
/// 编写日期: 2021-01-08
Class DHCMA.CPW.BTS.PathFormItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:		yankai
/// CreatDate:		2023-03-01
/// Description:	获取某项目下所含医嘱项类型（西药类医嘱项:W，草药类医嘱项：C）
/// Table:        	DHCMA.CPW.BT.PathFormOrd
/// Input:        	含西药医嘱项返回“W”；含草药医嘱项返回“C”,都有则都返回
/// w ##class(DHCMA.CPW.BTS.PathFormItemSrv).GetLinkOrdType("1||1||7",2)
ClassMethod GetLinkOrdType(aFormItemID As %String, aHospID As %String = "") As %String
{
	New (aFormItemID, aHospID, %session)
	Set return = ""
	Quit:(aFormItemID="") return
	
	Set:(aHospID="")&&($d(%session)) aHospID=$g(%session.Data("LOGON.HOSPID"))
	Quit:aHospID="" return
	
	Set FormID = $p(aFormItemID,"||",1)
	Set SubEpID = $p(aFormItemID,"||",2)
	Set SubItemID = $p(aFormItemID,"||",3)	
	
	Set xSubOrdID = ""
	For {
		Set xSubOrdID=$o(^DHCMA.CPW.BT.PathFormD(FormID,"EP",SubEpID,"ITM",SubItemID,"ORD",xSubOrdID))
		Quit:xSubOrdID=""
		
		Set FormOrdID=FormID_"||"_SubEpID_"||"_SubItemID_"||"_xSubOrdID
		Set objOrd = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(FormOrdID)
		Continue:'$IsObject(objOrd)
		Set OrdMastID=objOrd.OrdMastID
		Continue:(OrdMastID="")||(OrdMastID'["||")
		Set OrdCatVal=##class(DHCMA.CPW.IO.FromDoc).IsCPWCNMedItem(OrdMastID,aHospID)
		Set OrdCatCode=$s(OrdCatVal=0:"W",1:"C")
		Set:return'[OrdCatCode return = return_","_OrdCatCode	
	}
	Set:return'="" return = $e(return, 2, $l(return))
	Quit return
}

}
