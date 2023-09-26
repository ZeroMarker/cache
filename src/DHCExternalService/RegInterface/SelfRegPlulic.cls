Class DHCExternalService.RegInterface.SelfRegPlulic [ Abstract, Not ProcedureBlock ]
{

Parameter SelfRegSerialPackageName = "DHCExternalService.RegInterface.Entity.SelfReg";

Parameter SelfApptSerialPackageName = "DHCExternalService.RegInterface.Entity.SelfAppt";

Parameter SelfEntityPackageName = "DHCExternalService.RegInterface.Entity";

/// 得到入参对象
ClassMethod GetInputObj(TradeCode, XMLRequest) As %RegisteredObject
{
	n (TradeCode,XMLRequest)
	
	s:TradeCode="3300" ClassName=..#SelfRegSerialPackageName_".GetPatInfoRq"
	s:TradeCode="3301" ClassName=..#SelfRegSerialPackageName_".QueryPatCardRq"
	s:TradeCode="3302" ClassName=..#SelfRegSerialPackageName_".GetPatBillTypeRq"
	s:TradeCode="1014" ClassName=..#SelfRegSerialPackageName_".QueryDepDocRq"
	s:TradeCode="1012" ClassName=..#SelfRegSerialPackageName_".QueryDepDocRq"
	s:TradeCode="1013" ClassName=..#SelfRegSerialPackageName_".QueryDepDocRq"
	s:TradeCode="1004" ClassName=..#SelfRegSerialPackageName_".QueryAdmScheduleRq"
	s:TradeCode="1101" ClassName=..#SelfRegSerialPackageName_".OPRegisterRq"
	s:TradeCode="1111" ClassName=..#SelfRegSerialPackageName_".OPRapidRegistRq"
	s:TradeCode="1112" ClassName=..#SelfRegSerialPackageName_".GetOPRapidRegistASRq"
	s:TradeCode="1104" ClassName=..#SelfRegSerialPackageName_".QueryAdmOPRegRq"
	s:TradeCode="1105" ClassName=..#SelfRegSerialPackageName_".GetInsuRegParaRq"
	s:TradeCode="1003" ClassName=..#SelfRegSerialPackageName_".OPRegReturnRq"
	s:TradeCode="1108" ClassName=..#SelfRegSerialPackageName_".QueryRegStatusRq"
	s:TradeCode="1109" ClassName=..#SelfRegSerialPackageName_".QueryPatListRq"
	s:TradeCode="10041" ClassName=..#SelfRegSerialPackageName_".QueryScheduleTimeInfoRq"
	s:TradeCode="1005" ClassName=..#SelfApptSerialPackageName_".QueryOPAppArriveListRq"
	s:TradeCode="2001" ClassName=..#SelfApptSerialPackageName_".OPAppArriveRq"
	s:TradeCode="1000" ClassName=..#SelfApptSerialPackageName_".BookServiceRq"
	s:TradeCode="1107" ClassName=..#SelfRegSerialPackageName_".QueryStopDoctorRq"
	
	s:TradeCode="10015" ClassName=..#SelfRegSerialPackageName_".LockOrderRt"
	s:TradeCode="10017" ClassName=..#SelfRegSerialPackageName_".QueryLockOrderRt"
	s InputObj=$ZOBJCLASSMETHOD(ClassName,"%New")
	d InputObj.XMLNodeDeserialize(.InputObj,"Request",XMLRequest)
	q InputObj
}

/// 得到出参对象
ClassMethod GetOutputObj(TradeCode) As %RegisteredObject
{
	n (TradeCode)
	
	s:TradeCode="3300" ClassName=..#SelfRegSerialPackageName_".GetPatInfoRp"
	s:TradeCode="3301" ClassName=..#SelfRegSerialPackageName_".QueryPatCardRp"
	s:TradeCode="3302" ClassName=..#SelfRegSerialPackageName_".GetPatBillTypeRp"
	s:TradeCode="1014" ClassName=..#SelfRegSerialPackageName_".QueryDepRp"
	s:TradeCode="1012" ClassName=..#SelfRegSerialPackageName_".QueryDepRp"
	s:TradeCode="1013" ClassName=..#SelfRegSerialPackageName_".QueryDocRp"
	s:TradeCode="1004" ClassName=..#SelfRegSerialPackageName_".QueryAdmScheduleRp"
	s:TradeCode="1101" ClassName=..#SelfRegSerialPackageName_".OPRegisterRp"
	s:TradeCode="1112" ClassName=..#SelfRegSerialPackageName_".GetOPRapidRegistASRp"
	s:TradeCode="1104" ClassName=..#SelfRegSerialPackageName_".QueryAdmOPRegRp"
	s:TradeCode="1105" ClassName=..#SelfRegSerialPackageName_".GetInsuRegParaRp"
	s:TradeCode="1003" ClassName=..#SelfRegSerialPackageName_".OPRegReturnRp"
	s:TradeCode="1107" ClassName=..#SelfRegSerialPackageName_".QueryStopDoctorRp"
	s:TradeCode="1108" ClassName=..#SelfRegSerialPackageName_".QueryRegStatusRp"
	s:TradeCode="1109" ClassName=..#SelfRegSerialPackageName_".QueryPatListRp"
	s:TradeCode="10041" ClassName=..#SelfRegSerialPackageName_".QueryScheduleTimeInfoRp"
	
	s:TradeCode="1005" ClassName=..#SelfApptSerialPackageName_".QueryOPAppArriveListRp"
	s:TradeCode="2001" ClassName=..#SelfApptSerialPackageName_".OPAppArriveRp"
	s:TradeCode="1000" ClassName=..#SelfApptSerialPackageName_".BookServiceRp"
	
	s:TradeCode="10015" ClassName=..#SelfRegSerialPackageName_".LockOrderRp"
	s:TradeCode="10017" ClassName=..#SelfRegSerialPackageName_".QueryLockOrderRp"
	
	s OutputObj=$ZOBJCLASSMETHOD(ClassName,"%New")
	q OutputObj
}

/// 赋值出参标识
ClassMethod SetOutputCode(ByRef object As %ObjectHandle, ResultCode As %String, ResultContent As %String)
{
	s object.ResultCode=ResultCode
	
	if ($d(^oddCOM(object.%ClassName(1),"a","ResultContent"))){
		s object.ResultContent=ResultContent
	}elseif ($d(^oddCOM(object.%ClassName(1),"a","ErrorMsg"))){
		s object.ErrorMsg=ResultContent
	}
}

/// 赋值出参标识
ClassMethod GetOutputStream(ByRef object As %ObjectHandle, ResultCode As %String, ResultContent As %String) As %Stream.GlobalCharacter
{
	s OutputStream=##class(%Stream.GlobalCharacter).%New() 
	s object.ResultCode=ResultCode
	;s object.ErrorMsg=ErrorMsg
	if ($d(^oddCOM(object.%ClassName(1),"a","ResultContent"))){
		s object.ResultContent=ResultContent
	}elseif ($d(^oddCOM(object.%ClassName(1),"a","ErrorMsg"))){
		s object.ErrorMsg=ResultContent
	}
	d object.XMLExportToStream(.OutputStream)
	;do OutputStream.OutputToDevice()
	q OutputStream
}

/// 得到预约数量
ClassMethod GetAppQty(RBASID)
{
	n (RBASID)
	s AppLoad=+$P($G(^RBAS(+RBASID,$P(RBASID,"||",2))),"^",2)
	s VIPAppQty=+##class(web.DHCRBApptScheduleAppQty).GetAPPMethodQty(RBASID, "VIP")
	s RegCount=AppLoad-VIPAppQty
	q RegCount //总的预约数量-本院VIP预约
}

/// 根据时段代码得到号源平台需要的时段代码
ClassMethod GetOuterTimeRangeCode(TimeRangeID, BankCode As %String = "")
{
	;w ##class(DHCExternalService.RegInterface.GetRelate).GetOuterTimeRangeCode(1)
	;s ^DHCRegInterfaceCodeRelate("TimeRange","Outer","1")="S" 上午 X  Y
	q:TimeRangeID="" ""
	if BankCode="Out"{
		s TimeRangeID=##class(web.DHCDocTextDicDataCtl).GetCompareData("TimeRangeOut", TimeRangeID,"N")
		Q TimeRangeID
	}
	q $G(^DHCRegInterfaceCodeRelate("TimeRange",BankCode,TimeRangeID))
}

/// 根据号源平台需要的时段代码得到His时段代码
ClassMethod GetOuterTimeRangeCodeAnti(TimeRangeCode)
{
	;w ##class(DHCExternalService.RegInterface.SelfRegPlulic).GetOuterTimeRangeCodeAnti("02")
	;s ^DHCRegInterfaceCodeRelate("TimeRange","Outer","1")="S" 上午
	;s ^DHCRegInterfaceCodeRelate("TimeRange","Outer","2")="X" 下午
	;s ^DHCRegInterfaceCodeRelate("TimeRange","Outer","3")="Z" 中午
	q:TimeRangeCode="" ""
	s myTimeRangeID=""
	s TimeRangeID=0
	for {
		s TimeRangeID=$O(^DHCRegInterfaceCodeRelate("TimeRange","Outer",TimeRangeID))
		q:TimeRangeID=""
		i $g(^DHCRegInterfaceCodeRelate("TimeRange","Outer",TimeRangeID))=TimeRangeCode {
			s myTimeRangeID=TimeRangeID
			Quit
		}
	}
	q myTimeRangeID
}

}
