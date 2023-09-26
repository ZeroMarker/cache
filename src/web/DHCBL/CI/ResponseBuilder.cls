/// 对于内外接口消息的处理
Class web.DHCBL.CI.ResponseBuilder Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod EnsembleMsgResponse(RespObj As web.DHCEntity.CI.Response) As %String
{
	;对于Ensemble返回消息的处理
	;d ##class(web.DHCBL.CI.ResponseBuilder).EnsembleMsgResponse()
	q:('$IsObject(RespObj)) ""
	s myrtn=0
	
	;写入试管数量
	s myTubAmountObj=RespObj.TubeAmount
	i ($IsObject(myTubAmountObj)){
		;value("386623","2907||1^1^556^22.000000^^1","2","258","","")
		;OrdItemStr=1,4,11,3,,17
		;OPOrdItemRowID,OPOrdQty,OPOrdItemRecLocRID,OPOrdPrice,,OPOrdInsRowId
		;(Adm, OrdItemStr, User, Loc, DocUserId, OSRID)
		;s ^TMPBLCIService($j,"AdmListInfo")=CDefine.AdmListInfo
		;s ^TMPBLCIService($j,"Instype")=CDefine.Instype
		;s ^TMPBLCIService($j,"UnBillOrdStr")=CDefine.UnBillOrdStr
		;s ^TMPBLCIService($j,"GroupDR")=CDefine.GroupDR
		;s ^TMPBLCIService($j,"UserDR")=CDefine.UserDR
		
		s myAdm=$p(^OEORD(+myTubAmountObj.ORIRowID),"^",1)
		q:(myAdm="")
		s myArcItmRowID=""
		s myRecLocRID=""
		s myOrdPrice=""
		s myInsRowID=$g(^TMPBLCIService($j,"Instype"))
		s myOrdItemStr=myArcItmRowID_"^"_myTubAmountObj.Amount_"^"_myRecLocRID_"^"_myOrdPrice_"^^"_myInsRowID
		s myUser=$g(^TMPBLCIService($j,"UserDR"))
		s myLoc=$p($g(^PAADM(myAdm)),"^",4)
		s myDocUserID=$p($g(^PAADM(myAdm)),"^",9)
		s myOSRID=""
		s ^TMPCICIResponseBuilder=$lb(myAdm, myOrdItemStr, myUser, myLoc, myDocUserID, myOSRID)
		;d ##class(web.DHCOPCashier).CashierInsertOrdItem(myAdm, myOrdItemStr, myUser, myLoc, myDocUserID, myOSRID)
	}
	q myrtn
}

ClassMethod InFunMsgResponse(RespObj As web.DHCEntity.CI.Response) As %String
{
	; 对于内部接口返回消息的处理
	q:('$IsObject(RespObj)) ""
	s myrtn=0
	
	q myrtn
}

}
