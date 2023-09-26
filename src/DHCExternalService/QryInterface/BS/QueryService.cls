/// DHCExternalService.QryInterface.BS.QueryService
Class DHCExternalService.QryInterface.BS.QueryService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "QueryService";

Parameter LOCATION = "http://192.168.1.139/dthealth/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// 根据发票号获取导诊单信息
ClassMethod GetDirectListByPrtRowid(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;set xmlstr="<Request><InvoiceNO>12345</InvoiceNO></Request>"
	;w ##class(DHCExternalService.QryInterface.BL.DirectInfo).GetDirectListByPrtRowid("")
	s returnValue=##class(DHCExternalService.QryInterface.BL.DirectInfo).GetDirectListByPrtRowid(input)	
	q returnValue
}

/// 获取处方列表
ClassMethod GetPHPrescList(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;set xmlstr="<Request><CardTypeCode></CardTypeCode><CardNo>6217220200900001607</CardNo><PatientID></PatientID><StartDate>2012-07-01</StartDate><EndDate>2012-09-01</EndDate><PrintFlag></PrintFlag></Request>"
	;w ##class(DHCExternalService.QryInterface.BL.PHPrescInfo).GetPHPrescList(xmlstr)
	s returnValue=##class(DHCExternalService.QryInterface.BL.PHPrescInfo).GetPHPrescList(input)	
	q returnValue
}

/// 获取处方详细信息
ClassMethod GetPHPrescInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	
	;set xmlstr="<Request><PrescNo>O12070900324</PrescNo><InvoiceID>1473</InvoiceID></Request>"
	;w ##class(DHCExternalService.QryInterface.BL.PHPrescInfo)GetPHPrescInfo(xmlstr)
	s returnValue=##class(DHCExternalService.QryInterface.BL.PHPrescInfo).GetPHPrescInfo(input)	
	q returnValue
}

/// 设置处方打印标记
ClassMethod SetPHPrescPrintFlag(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;
	;w ##class(DHCExternalService.QryInterface.BL.PHPrescInfo)SetPHPrescPrintFlag("")
	s returnValue=##class(DHCExternalService.QryInterface.BL.PHPrescInfo).SetPHPrescPrintFlag(input)	
	q returnValue
}

/// 根据卡号取病人信息
/// w ##class(DHCExternalService.QryInterface.BS.QueryService).GetPatInfo("<Request><TradeCode>3000</TradeCode><CardTypeCode></CardTypeCode><CardNo>000000000002</CardNo></Request>")
/// w ##class(DHCExternalService.QryInterface.BS.QueryService).GetPatInfo("<Request><TradeCode>90001</TradeCode><CardTypeCode></CardTypeCode><CardNo>100000013589</CardNo></Request>")
ClassMethod GetPatInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;
	s returnValue=##class(DHCExternalService.QryInterface.BL.InvFeeInfo).GetPatInfo(input)	
	q returnValue
}

/// 取门诊费用发票信息
/// w ##class(DHCExternalService.QryInterface.BS.QueryService).GetOutPatInvInfo("<Request><TradeCode>3000</TradeCode><PatientID>2</PatientID></Request>")
ClassMethod GetOutPatInvInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;
	s returnValue=##class(DHCExternalService.QryInterface.BL.InvFeeInfo).GetOutPatInvInfo(input)	
	q returnValue
}

/// 取门诊费用发票分类金额
/// w ##class(DHCExternalService.QryInterface.BS.QueryService).GetOutPatCateFeeInfo("<Request><TradeCode>3000</TradeCode><InvID>192005</InvID></Request>")
ClassMethod GetOutPatCateFeeInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;
	s returnValue=##class(DHCExternalService.QryInterface.BL.InvFeeInfo).GetOutPatCateFeeInfo(input)	
	q returnValue
}

/// 取门诊发票费用分类明细信息
/// w ##class(DHCExternalService.QryInterface.BS.QueryService).GetOutPatCateFeeDetail("<Request><TradeCode>3000</TradeCode><InvID>192005</InvID></Request>")
ClassMethod GetOutPatCateFeeDetail(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;
	s returnValue=##class(DHCExternalService.QryInterface.BL.InvFeeInfo).GetOutPatCateFeeDetail(input)	
	q returnValue
}

/// 取住院费用发票信息
/// w ##class(DHCExternalService.QryInterface.BS.QueryService).GetInPatInvInfo("<Request><TradeCode>3000</TradeCode><PatientID>0000000002</PatientID></Request>")
ClassMethod GetInPatInvInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;
	s returnValue=##class(DHCExternalService.QryInterface.BL.InvFeeInfo).GetInPatInvInfo(input)	
	q returnValue
}

/// 取住院费用发票分类金额
/// w ##class(DHCExternalService.QryInterface.BS.QueryService).GetInPatCateFeeInfo("<Request><TradeCode>3000</TradeCode><BillNo>218380</BillNo></Request>")
ClassMethod GetInPatCateFeeInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;
	s returnValue=##class(DHCExternalService.QryInterface.BL.InvFeeInfo).GetInPatCateFeeInfo(input)	
	q returnValue
}

/// 取住院发票费用分类明细信息
/// w ##class(DHCExternalService.QryInterface.BS.QueryService).GetInPatCateFeeDetail("<Request><TradeCode>3000</TradeCode><BillNo>218380</BillNo><BillDate></BillDate></Request>")
ClassMethod GetInPatCateFeeDetail(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;
	s returnValue=##class(DHCExternalService.QryInterface.BL.InvFeeInfo).GetInPatCateFeeDetail(input)	
	q returnValue
}

/// 查询药品价格
/// w ##class(DHCExternalService.QryInterface.BS.QueryService).GetMedPrice("<Request><TradeCode>3000</TradeCode><Alias>ASPL</Alias></Request>")
ClassMethod GetMedPrice(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;
	s returnValue=##class(DHCExternalService.QryInterface.BL.InvFeeInfo).GetMedPrice(input)	
	q returnValue
}

/// 查询非药品收费项目价格
/// w ##class(DHCExternalService.QryInterface.BS.QueryService).GetTarItemPrice("<Request><TradeCode>3000</TradeCode><Alias>CT</Alias></Request>")
ClassMethod GetTarItemPrice(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;
	s returnValue=##class(DHCExternalService.QryInterface.BL.InvFeeInfo).GetTarItemPrice(input)	
	q returnValue
}

/// 查询门诊病人患者账户明细
/// w ##class(DHCExternalService.QryInterface.BS.QueryService).GetPatAccList("<Request><TradeCode>3000</TradeCode><CardTypeCode></CardTypeCode><CardNo>000000000002</CardNo><SecrityNo>1</SecrityNo></Request>")
ClassMethod GetPatAccList(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;
	s returnValue=##class(DHCExternalService.QryInterface.BL.PatientAccList).GetPatAccList(input)	
	q returnValue
}

/// 查询住院病人日清明细(建议每次只查询一天的明细)
/// w ##class(DHCExternalService.QryInterface.BS.QueryService).GetIPDailyDetails("<Request><CardTypeCode></CardTypeCode><CardNo>000000000002</CardNo><SecrityNo>3</SecrityNo><StartDate></StartDate><EndDate></EndDate></Request>")
ClassMethod GetIPDailyDetails(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;
	s returnValue=##class(DHCExternalService.QryInterface.BL.IPDailyDetails).GetIPDailyDetails(input)
	q returnValue
}

/// 设置住院病人日清打印标志
ClassMethod SetIPDailyPrintFlag(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s returnValue=##class(DHCExternalService.QryInterface.BL.IPDailyDetails).SetIPDailyPrintFlag(input)
	q returnValue
}

}
