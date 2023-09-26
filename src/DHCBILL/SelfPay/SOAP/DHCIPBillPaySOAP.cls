/// DHCBILL.SelfPay.SOAP.DHCIPBillPaySOAP
Class DHCBILL.SelfPay.SOAP.DHCIPBillPaySOAP Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "DHCIPBillPaySOAP";

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
/// Debug:w ##class(DHCBILL.SelfPay.SOAP.DHCIPBillPaySOAP).DHCNetTest("")
ClassMethod DHCNetTest(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).DHCNetTest(Input)
	
	Quit ReturnValue
}

/// Creator:wangjian
/// CreatDate:2018-03-20
/// Desc: 根据卡号及日期查询就诊记录
/// Debug:w ##class(DHCBILL.SelfPay.SOAP.DHCOPBillPaySOAP).GetIPAdmInfo("")
ClassMethod GetIPAdmInfo(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayExp).GetIPAdmInfo(Input)
	
	Quit ReturnValue
}

/// Creator:wangjian
/// CreatDate:2018-03-20
/// Desc: 住院押金充值
/// Debug:w ##class(DHCBILL.SelfPay.SOAP.DHCOPBillPaySOAP).AddIPDeposit("")
ClassMethod AddIPDeposit(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayExp).AddIPDeposit(Input)
	
	Quit ReturnValue
}

/// Creator:wangjian
/// CreatDate:2018-03-20
/// Desc: 押金记录查询
/// Debug:w ##class(DHCBILL.SelfPay.SOAP.DHCOPBillPaySOAP).GetIPDepositRecord("")
ClassMethod GetIPDepRecord(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayExp).GetIPDepRecord(Input)
	
	Quit ReturnValue
}

}
