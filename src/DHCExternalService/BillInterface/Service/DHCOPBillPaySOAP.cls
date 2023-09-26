/// Lid
/// 2011-03-17
/// 东华数字医疗-门诊自助缴费服务
Class DHCExternalService.BillInterface.Service.DHCOPBillPaySOAP Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCOPBillPaySOAP";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://10.10.100.6/dthealth/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/DHC/OPBILL/AutoPay";

/// zhho
/// 2016-03-19
/// 根据卡号，就诊日期获取病人就诊信息
/// w ##class(web.DHCOPBillAutoPaySOAP).GetAdmByCardNo(^Lid("Input"))
ClassMethod GetAdmByCardNo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;<Request><CardNo>6228480258000002471</CardNo><SecrityNo></SecrityNo><Userid>CWL1100</Userid><StartDate></StartDate><EndDate></EndDate><AdmInfo></AdmInfo><PatAmt></PatAmt><BankTradeInfo></BankTradeInfo><ExpStr>ABC</ExpStr></Request>
	set ^Lid("Input")=input
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetAdmByCardNo(input)
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)
    quit Response	
	//quit returnValue
}

ClassMethod operationCheck(input As %String) As %String [ WebMethod ]
{
	;<Request><CardNo>6228480258000002471</CardNo><SecrityNo></SecrityNo><Userid>CWL1100</Userid><StartDate></StartDate><EndDate></EndDate><AdmInfo></AdmInfo><PatAmt></PatAmt><BankTradeInfo></BankTradeInfo><ExpStr>ABC</ExpStr></Request>
	set ^Lid("Input")=input
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).operationCheck(input)
	quit ReturnValue
}

/// 2011-03-29
/// description  将病人当天当前科室就诊的医嘱信息对应的费用按门诊大类统计输出
/// w ##class(web.DHCOPBillAutoPaySOAP).GetBillInfo(^Lid("GetBillInfo","Input","2013-03-28","14:45:00"))
ClassMethod GetBillInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;<Request><CardNo>63010400002</CardNo><SecrityNo>6282650741</SecrityNo><Userid>w10000</Userid><StartDate></StartDate><EndDate></EndDate><AdmInfo></AdmInfo><PatAmt></PatAmt><BankTradeInfo></BankTradeInfo><ExpStr>03</ExpStr></Request>
	;<Request><CardNo>6227002342341213566</CardNo><SecrityNo></SecrityNo><Userid>CWL1100</Userid><StartDate></StartDate><EndDate></EndDate><AdmInfo></AdmInfo><PatAmt>90</PatAmt><BankTradeInfo></BankTradeInfo><ExpStr>CBC</ExpStr></Request>
	set ^Lid("GetBillInfo","Input",$zd(+$h,3),$zt($p($h,",",2),1))=input
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetBillInfo(input)
	set Response=##class(%GlobalCharacterStream).%New()
	set ^Lid("GetBillInfo","Output",$zd(+$h,3),$zt($p($h,",",2),1))=ReturnValue
	set sc=Response.Write(ReturnValue)	
	quit Response
}

/// Lid
/// 2011-03-30
/// 预结算结算接口
ClassMethod AutoOPBillCharge(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	;<Request><CardNo>6222021602013440567</CardNo><SecrityNo></SecrityNo><Userid>W10000</Userid><StartDate></StartDate><EndDate></EndDate><AdmInfo></AdmInfo><PatAmt>84.2</PatAmt><BankTradeInfo></BankTradeInfo><ExpStr>ICBC</ExpStr></Request>
	set ^Lid("AutoOPBillCharge","Input",$zd(+$h,3),$zt($p($h,",",2),1))=input	
	;w ##class(web.DHCOPBillAutoPaySOAP).AutoOPBillCharge(^Lid("AutoOPBillCharge","Input","2013-03-28","14:59:28"))
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).AutoOPBillCharge(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)
	set ^Lid("AutoOPBillCharge","Output",$zd(+$h,3),$zt($p($h,",",2),1))=ReturnValue
	quit Response
}

/// 收费查证
ClassMethod CheckOPBillCharge(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).CheckOPBillCharge(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)	
	quit Response
}

/// 获取已缴费发票记录
ClassMethod GetCompletedPayInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetCompletedPayInfo(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)	
	quit Response
}

/// 获取已缴费发票明细
ClassMethod GetCompletedPayDetailInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetCompletedPayDetailInfo(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)	
	quit Response
}

/// 获取已缴费发票信息及明细
ClassMethod GetCompletedPayWithDetail(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetCompletedPayWithDetail(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)	
	quit Response
}

/// 获取病人住院就诊信息
ClassMethod GetIPPatAdmInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetIPPatAdmInfo(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)	
	quit Response
}

/// 住院押金充值  没有传adm默认当前在院adm
ClassMethod AddIPDeposit(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).AddIPDeposit(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)	
	quit Response
}

/// 住院押金充值查证
ClassMethod CheckIPDeposit(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).CheckIPDeposit(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)	
	quit Response
}

/// 住院押金充值查询
ClassMethod GetDepPayRecord(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetDepPayRecord(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)	
	quit Response
}

/// 住院日清单
ClassMethod GetIPDailyBill(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetIPDailyBill(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)	
	quit Response
}

/// 住院费用汇总查询
ClassMethod GetIPTotalCost(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetIPTotalCost(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)	
	quit Response
}

/// 住院费用分类明细
ClassMethod GetIPDetailCost(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetIPDetailCost(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	;set sc=Response.Write(ReturnValue)	
	quit ReturnValue
}

/// 获取his对账总账信息
ClassMethod GetBillTotalInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetBillTotalInfo(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)	
	quit Response
}

/// 获取his对账明细信息
ClassMethod GetBillDetails(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetBillDetails(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)	
	quit Response
}

/// 退费回调
ClassMethod InserBankTradeInfoSingle(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).InserBankTradeInfoSingle(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)	
	quit Response
}

ClassMethod PrintDirect(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).PrintDirect(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)	
	quit Response
}

ClassMethod GetCheckInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	new (input)
	set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetCheckInfo(input)	
	set Response=##class(%GlobalCharacterStream).%New()
	set sc=Response.Write(ReturnValue)	
	quit Response
}

}
