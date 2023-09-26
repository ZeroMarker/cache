/// 医嘱关联对照服务类
Class DHCMA.CPW.SD.StandSrv.OrderLinkSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 通过标准字典ID获取关联医嘱内容
/// w ##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr("76||236")
ClassMethod GetDicOrderStr(aDicID As %String = "") As %String
{
	new (aDicID)
	Set return="",OrdStr="",DicIdx=""
	If (aDicID'="") {
		Set DicIdx="IdxDic"
	 	Set:aDicID["||" DicIdx="IdxDicSub"
	 	Set xRowID = $o(^DHCMA.CPW.SD.Stand.OrderLinkI(DicIdx,aDicID,0))
	 	If (xRowID'=""){
		 	Set obj        = ##class(DHCMA.CPW.SD.Stand.OrderLink).GetObjById(xRowID)
		 	Set OrdStr     = obj.OrdMastID
	 	}	
	 	
	}else{
		Set xRowID=""
		For {
			Set xRowID = $o(^DHCMA.CPW.SD.Stand.OrderLinkD(xRowID))
		 	Quit:xRowID=""
		 	Set obj        = ##class(DHCMA.CPW.SD.Stand.OrderLink).GetObjById(xRowID)
		 	Set OrdStr     = OrdStr_"^"_obj.OrdMastID	
		}	
	}
	//如果通过字典项获取不到值，继续获取其字典子项的绑定医嘱
 	If (DicIdx="IdxDic")&&(OrdStr="") {
		Set xSubID=""
	 	For{
		 	Set xSubID	= $o(^DHCMA.CPW.SD.Stand.DicsubD(aDicID,xSubID))
		 	Quit:xSubID=""
		 	Set xSubRowID=aDicID_"||"_xSubID
		 	Set xSubLinkID = $o(^DHCMA.CPW.SD.Stand.OrderLinkI("IdxDicSub",xSubRowID,0))
		 	Continue:xSubLinkID=""
		 	Set obj        = ##class(DHCMA.CPW.SD.Stand.OrderLink).GetObjById(xSubLinkID)
		 	Continue:obj.OrdMastID=""
 			Set OrdStr     = OrdStr_"^"_obj.OrdMastID
	 	}
 	}	
 	Quit OrdStr
}

/// w ##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).LinkDicOrder("84||288","954^955^1279^")
ClassMethod LinkDicOrder(aDicID As %String, aOrderStr As %String) As %String
{
	New (aDicID,aOrderStr)
	Set return=""
	Quit:(aDicID="") ret
	Set ^tmpzgz49=$lb(aDicID,aOrderStr)
	Set DicIdx="IdxDic"
 	Set:aDicID["||" DicIdx="IdxDicSub"
 	Set RowID="", xDicID="",xDicSubID=""
	If $d(^DHCMA.CPW.SD.Stand.OrderLinkI(DicIdx,aDicID)) {
		Set RowID=$o(^DHCMA.CPW.SD.Stand.OrderLinkI(DicIdx,aDicID,0))
	}

	Set:aDicID["||" xDicID="",xDicSubID=aDicID
	Set:aDicID'["||" xDicID=aDicID,xDicSubID=""
	Set InputStr=RowID_$c(1)_xDicID_$c(1)_xDicSubID_$c(1,1)_aOrderStr
	Set ret=##class(DHCMA.CPW.SD.Stand.OrderLink).Update(InputStr,$c(1))
	Quit ret
}

/// w ##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).AutoLinkOrder(1,"119")
ClassMethod AutoLinkOrder(aSYSDr As %String = "1", aDicID As %String) As %String
{
	New (aSYSDr,aDicID)
	Set return=""
 	If (aDicID["||"){
	 	Set Obj=##class(DHCMA.CPW.SD.Stand.Dicsub).%OpenId(aDicID)
	 	Set objSource=Obj.Parref.SourceDr
	 	Set Desc=Obj.DicDesc
	}else{
		Set Obj=##class(DHCMA.CPW.SD.Stand.Dic).%OpenId(aDicID)
		Set objSource=Obj.SourceDr
		Set Desc=Obj.DicCatDesc
	}	
 	Set SourceDec=objSource.BTDesc
 	Set OrderType=$S(SourceDec["药":"R",SourceDec["检验":"L",SourceDec["检查":"X",SourceDec["处置":"N",1:"")
 	Quit:OrderType="" return
 	Set xRowID=0,Count=0,LinkOrder=""
 	For
 	{
	 	Set xRowID    = $o(^DHCMA.Util.EPx.OrdMastI("IdxOfType",aSYSDr,OrderType,xRowID))
	 	Quit:xRowID=""
	 	Set obj       = ##class(DHCMA.Util.EPx.OrdMast).GetObjById(xRowID)
	 	Set:obj.BTDesc[Desc LinkOrder=LinkOrder_"^"_xRowID,Count=Count+1
 	}
 	If (LinkOrder'="") {
	 	Set LinkOrder=$e(LinkOrder,2,$l(LinkOrder))
	 	d ..LinkDicOrder(aDicID,LinkOrder)
	 }
 	Quit Count
}

ClassMethod ClearHistoryLink(aDicID As %String) As %String
{
	n (aDicID)
	Set ret=""
	Quit:aDicID="" ret
	IF (aDicID["||") {
		Set RowID=$o(^DHCMA.CPW.SD.Stand.OrderLinkI("IdxDicSub",aDicID,0))	
	}else{
		Set RowID=$o(^DHCMA.CPW.SD.Stand.OrderLinkI("IdxDic",aDicID,0))	
	}
	Quit:RowID="" ret
	Set ret=##class(DHCMA.CPW.SD.Stand.OrderLink).DeleteById(RowID)
	Quit ret
}

}
