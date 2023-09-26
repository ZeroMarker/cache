/// DHCBILL.SelfPay.SOAP.DHCOPBillPaySOAP
Class DHCBILL.SelfPay.SOAP.DHCOPBillPaySOAP Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "DHCOPBillPaySOAP";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "https://10.1.62.10/imedical/webservice/";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "https://www.dhcc.com.cn/DHCBILL/SelfPay";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// Creator:Lid
/// CreatDate:2018-03-20
/// Desc:网络测试接口
ClassMethod DHCNetTest(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).DHCNetTest(Input)
	
	Quit ReturnValue
}

/// Creator:wangjian
/// CreatDate:2018-03-15
/// Desc: 根据卡号及日期查询就诊记录
/// w ##class(DHCBILL.SelfPay.SOAP.DHCOPBillPaySOAP).GetAdmByCardNo("<Request><TradeCode>4092</TradeCode><HospitalID>01</HospitalID><CardNo>0000000262</CardNo><CardType></CardType><SecrityNo></SecrityNo><PatientID>0000000262</PatientID><UserCode>sf01</UserCode><TerminalID>ZZJ001</TerminalID><StartDate>2018-03-10</StartDate><EndDate>2018-03-27</EndDate><ExpStr></ExpStr></Request>")
ClassMethod GetAdmByCardNo(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetAdmByCardNo(Input)
	
	Quit ReturnValue
}

/// Creator:wangjian
/// CreatDate:2018-03-15
/// Desc: 获取结算单
ClassMethod GetChargeOrder(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetChargeOrder(Input)
	
	Quit ReturnValue
}

/// Creator:wangjian
/// CreatDate:2018-03-16
/// Desc: 预结算
ClassMethod PreBillCharge(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).PreBillCharge(Input)
	
	Quit ReturnValue
}

/// Creator:wangjian
/// CreatDate:2018-03-17
/// Desc: 确认收费完成
ClassMethod CompleteCharge(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).CompleteCharge(Input)
	
	Quit ReturnValue
}

/// Creator:wangjian
/// CreatDate:2018-03-17
/// Desc: 取消预结算
ClassMethod CancelCharge(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).CancelCharge(Input)
	
	Quit ReturnValue
}

/// Creator:wangjian
/// CreatDate:2018-03-18
/// Desc: 查询已缴费记录
ClassMethod GetPaidRecord(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetPaidRecord(Input)
	
	Quit ReturnValue
}

/// Creator:wangjian
/// CreatDate:2018-03-18
/// Desc: 查询已缴费记录明细
ClassMethod GetPaidRecordDetails(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetPaidRecordDetails(Input)
	
	Quit ReturnValue
}

/// Creator:wangjian
/// CreatDate:2018-03-18
/// Desc: 结算单查证
ClassMethod CheckCharge(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).CheckCharge(Input)
	
	Quit ReturnValue
}

/// Creator:zfb
/// CreatDate:2018-03-18
/// Desc: 未打印发票查询
ClassMethod GetInvPayList(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetInvPayList(input)
	
	Quit ReturnValue
}

/// Creator:zfb
/// CreatDate:2018-03-18
/// Desc: 发票打印
ClassMethod PrintInvoice(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).PrintInvoice(input)
	
	Quit ReturnValue
}

/// Creator:wangjian
/// CreatDate:2018-03-23
/// Desc:获取患者基本信息及账户信息
ClassMethod GetOPPatAccInfo(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetOPPatAccInfo(Input)
	
	Quit ReturnValue
}

/// Creator:wangjian
/// CreatDate:2018-03-23
/// Desc:门诊院内账户预交金充值
ClassMethod AddOPDeposit(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).AddOPDeposit(Input)
	
	Quit ReturnValue
}

}
