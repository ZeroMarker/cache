/// DHCBILL.SelfPay.SOAP.SelfPaySoap
Class DHCBILL.SelfPay.SOAP.SelfPaySoap Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "SelfPaySOAP";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "https://127.0.0.1/imedical/webservice/";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "https://www.dhcc.com.cn/DHCBILL/SelfPay";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// 计费自助服务对外接口
ClassMethod DHCSelfPay(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	set TradeCode=##class(DHCBILL.SelfPay.Common.BaseMethod).getTradeCode(Input)
	set ReturnValue=##class(%GlobalCharacterStream).%New() 
	if (TradeCode="4902"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetAdmByCardNo(Input)
		quit ReturnValue
	}
	if (TradeCode="4904"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetChargeOrder(Input)
		quit ReturnValue
	}
	if (TradeCode="4905"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).PreBillCharge(Input)
		quit ReturnValue
	}
	if (TradeCode="4906"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).CompleteCharge(Input)
		quit ReturnValue
	}
	if (TradeCode="4907"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetPaidRecord(Input)
		quit ReturnValue
	}
	if (TradeCode="4908"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetPaidRecordDetails(Input)
		quit ReturnValue
	}
	if (TradeCode="4909"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).CheckCharge(Input)
		quit ReturnValue
	}
	if (TradeCode="4910"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).CancelCharge(Input)
		quit ReturnValue
	}
	if (TradeCode="4920"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetRefListInfoByPatient(Input)
		quit ReturnValue
	}
	if (TradeCode="4921"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).SendSelfRefundMsgToHis(Input)
		quit ReturnValue
	}
	if (TradeCode="4922"){
		set ReturnValue="" ;;;走医保线上退费接口
		quit ReturnValue
	}
	if (TradeCode="4923"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).CommitInsuInfoComputeRefAmt(Input)
		quit ReturnValue
	}
	if (TradeCode="4924"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).SaveSelfRefundInfo(Input)
		quit ReturnValue
	}
	if (TradeCode="4925"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).AuditForAPP(Input)
		quit ReturnValue
	}
	if (TradeCode="4801"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetOPPatAccInfo(Input)
		quit ReturnValue
	}
	if (TradeCode="4802"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).AddOPDeposit(Input)
		quit ReturnValue
	}
	if (TradeCode="4803"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).RefundOPDeposit(Input)
		quit ReturnValue
	}
	if (TradeCode="4804"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetOPPatAccDetail(Input)
		quit ReturnValue
	}
	if (TradeCode="4805"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetOPPatCanRefAccDetail(Input)
		quit ReturnValue
	}
	if (TradeCode="4806"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).CommitRefundOPDeposit(Input)
		quit ReturnValue
	}
	if (TradeCode="5001"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayExp).GetIPAdmInfo(Input)
		quit ReturnValue
	}
	if (TradeCode="5002"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayExp).AddIPDeposit(Input)
		quit ReturnValue
	}
	if (TradeCode="5003"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayExp).GetIPDepRecord(Input)
		quit ReturnValue
	}
	if (TradeCode="5005"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayExp).GetIPRegInfo(Input)
		quit ReturnValue
	}
	if (TradeCode="5006"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayExp).IPRegister(Input)
		quit ReturnValue
	}
	if (TradeCode="5009"){
		set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetIPTotalCost(Input)
		quit ReturnValue
	}
	if (TradeCode="5010"){
		set ReturnValue=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetIPDetailCost(Input)
		quit ReturnValue
	}
	if (TradeCode="5013"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).CheckFee(Input)
		quit ReturnValue
	}
	
	if (TradeCode="4701"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetInvPayList(Input)
		quit ReturnValue
	}
	if (TradeCode="4702"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).PrintInvoice(Input)
		quit ReturnValue
	}
	if (TradeCode="4703"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).CheckInvoiceNo(Input)
		quit ReturnValue
	}
	if (TradeCode="4704"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).ResultInvoiceNo(Input)
		quit ReturnValue
	}
	if (TradeCode="4705"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).VoidInvoiceNo(Input)
		quit ReturnValue
	}
	if (TradeCode="6001"){
		set ReturnValue=##class(DHCBILL.SelfPay.BLL.DHCBillQryServiceExp).GetBills(Input)
		quit ReturnValue
	}
	
	do ReturnValue.Write("无效的交易代码")
	quit ReturnValue
}

}
