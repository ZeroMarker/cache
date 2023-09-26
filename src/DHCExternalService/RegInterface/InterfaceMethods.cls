Class DHCExternalService.RegInterface.InterfaceMethods Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// 同步号源信息服务类名
Parameter ScheduleServiceClassNmae = "SynVisistSchedule.SynVisistScheduleSoap";

/// 通过集成平台同步号源的服务类名
Parameter ScheduleServiceToENSClassNmae = "DHCENS.REG.SOAP.ScheduleInfoSoap";

/// 挂号退费通知服务类名
Parameter RegfeeRefundServiceClassNmae = "Cardpayment.CardpaymentSoap";

/// 同步排班信息
ClassMethod SynVisitSchedule(InputObj As DHCExternalService.RegInterface.Entity.SynVisitSchedule) As %String
{
	n (InputObj)
	s rtn=InputObj.XMLExportToString(.XML,"Request")
	i ($system.Status.IsError(rtn)) {
		q "-1^序列化同步排班对象失败"
	}
	set ^TMP("Reg")=XML
	
	s RtnXml=""
	/*
	s ClsObj=$ZOBJCLASSMETHOD(..#ScheduleServiceToENSClassNmae,"%New")   // 通过集成平台同步号源的服务类名
	s RtnXml=ClsObj.ScheduleInfo(XML)    // 通过集成平台同步号源的服务类名
	*/
	s RtnObj=##class(DHCExternalService.RegInterface.Entity.ReturnInfo).%New()
	;b ;RtnXml
	d RtnObj.XMLNodeDeserialize(.RtnObj, "Response", RtnXml)
	q RtnObj.Result_"^"_RtnObj.ErrorMsg
}

/// 同步预约总数
ClassMethod SynRegCount(InputObj As DHCExternalService.RegInterface.Entity.SynVisitSchedule) As %String
{
	n (InputObj)
	s rtn=InputObj.XMLExportToString(.XML,"Request")
	i ($system.Status.IsError(rtn)) {
		q "-1^序列化同步预约总数对象失败"
	}
	s RtnXml=""
	s ClsObj=$ZOBJCLASSMETHOD(..#ScheduleServiceClassNmae,"%New")
	//s RtnXml=ClsObj.SynRegCount(XML)
	s RtnObj=##class(DHCExternalService.RegInterface.Entity.ReturnInfo).%New()
	d RtnObj.XMLNodeDeserialize(.RtnObj, "Response", RtnXml)
	q RtnObj.ResultCode_"^"_RtnObj.ErrorMsg
}

/// 停诊
ClassMethod SynStopVisitSchedule(InputObj As DHCExternalService.RegInterface.Entity.SynVisitSchedule) As %String
{
	n (InputObj)
	s rtn=InputObj.XMLExportToString(.XML,"Request")
	i ($system.Status.IsError(rtn)) {
		q "-1^序列化停诊对象失败"
	}
	s ClsObj=$ZOBJCLASSMETHOD(..#ScheduleServiceClassNmae,"%New")
	b ;XML
	//s RtnXml=ClsObj.SynStopVisitSchedule(XML)
	b ;RtnXml
	s RtnObj=##class(DHCExternalService.RegInterface.Entity.ReturnInfo).%New()
	d RtnObj.XMLNodeDeserialize(.RtnObj, "Response", RtnXml)
	q RtnObj.Result_"^"_RtnObj.ErrorMsg
}

/// 替诊
ClassMethod SynReplaceVisitSchedule(InputObj As DHCExternalService.RegInterface.Entity.SynVisitSchedule) As %String
{
	n (InputObj)
	s rtn=InputObj.XMLExportToString(.XML,"Request")
	i ($system.Status.IsError(rtn)) {
		q "-1^序列化替诊对象失败"
	}
	s ClsObj=$ZOBJCLASSMETHOD(..#ScheduleServiceClassNmae,"%New")
	b ;XML
	;s RtnXml=$ZOBJCLASSMETHOD(..#ServiceClassNmae,"SynReplaceVisitSchedule",XML)
	;s RtnXml=ClsObj.SynReplaceVisitSchedule(XML)
	b ;RtnXml
	s RtnObj=##class(DHCExternalService.RegInterface.Entity.ReturnInfo).%New()
	d RtnObj.XMLNodeDeserialize(.RtnObj, "Response", RtnXml)
	q RtnObj.Result_"^"_RtnObj.ErrorMsg
}

/// 挂号退费通知
ClassMethod RegfeeRefund(InputObj As DHCExternalService.RegInterface.Entity.RegfeeRefund) As %String
{
	n (InputObj)
	s rtn=InputObj.XMLExportToString(.XML,"Request")
	i ($system.Status.IsError(rtn)) {
		q "-1^序列化替诊对象失败"
	}
	s ClsObj=$ZOBJCLASSMETHOD(..#RegfeeRefundServiceClassNmae,"%New")
	b ;XML
	;s RtnXml=$ZOBJCLASSMETHOD(..#ServiceClassNmae,"SynReplaceVisitSchedule",XML)
	s RtnXml=ClsObj.RegfeeRefund(XML)
	b ;RtnXml
	s RtnObj=##class(DHCExternalService.RegInterface.Entity.ReturnInfo).%New()
	d RtnObj.XMLNodeDeserialize(.RtnObj, "Response", RtnXml)
	q RtnObj.ResultCode_"^"_RtnObj.ResultContent
}

}
