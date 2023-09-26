/// Lid
/// 2011-03-17
/// 东华数字医疗-门诊自助缴费服务
Class web.DHCOPBillAutoPaySOAP Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCOPBillAutoPaySOAP";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://172.23.6.6/dthealth/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/DHC/OPBILL/AutoPay";

/// Lid
/// 2011-12-21
/// 根据卡号检索签约状态和病人基本信息
/// w ##class(web.DHCOPBillAutoPaySOAP).GetPatientInfo(^Lid("Input"))
ClassMethod GetPatientInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	
	New (input)
	;<Request><CardNo>6228480258000002471</CardNo><SecrityNo></SecrityNo><Userid>CWL1100</Userid><StartDate></StartDate><EndDate></EndDate><AdmInfo></AdmInfo><PatAmt></PatAmt><BankTradeInfo></BankTradeInfo><ExpStr>ABC</ExpStr></Request>

	Set ReturnValue=##class(web.DHCOPBillAutoPayExp).GetPatientInfo(input)	
	Set Response=##class(%GlobalCharacterStream).%New()
	Set sc=Response.Write(ReturnValue)
    Quit Response
}

/// Lid
/// 2011-03-07
/// 根据卡号，就诊日期获取病人就诊信息
/// w ##class(web.DHCOPBillAutoPaySOAP).GetAdmByCardNo(^Lid("Input"))
ClassMethod GetAdmByCardNo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;<Request><CardNo>6228480258000002471</CardNo><SecrityNo></SecrityNo><Userid>CWL1100</Userid><StartDate></StartDate><EndDate></EndDate><AdmInfo></AdmInfo><PatAmt></PatAmt><BankTradeInfo></BankTradeInfo><ExpStr>ABC</ExpStr></Request>
	
	New (input)
	Set ReturnValue=##class(web.DHCOPBillAutoPayExp).GetAdmByCardNo(input)
	Set Response=##class(%GlobalCharacterStream).%New()
	Set sc=Response.Write(ReturnValue)
    Quit Response	
	//q returnValue
}

/// 2011-03-29
/// description  将病人当天当前科室就诊的医嘱信息对应的费用按门诊大类统计输出
/// w ##class(web.DHCOPBillAutoPaySOAP).GetBillInfo(^Lid("GetBillInfo","Input","2013-03-28","14:45:00"))
ClassMethod GetBillInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;<Request><CardNo>63010400002</CardNo><SecrityNo>6282650741</SecrityNo><Userid>w10000</Userid><StartDate></StartDate><EndDate></EndDate><AdmInfo></AdmInfo><PatAmt></PatAmt><BankTradeInfo></BankTradeInfo><ExpStr>03</ExpStr></Request>
	;<Request><CardNo>6227002342341213566</CardNo><SecrityNo></SecrityNo><Userid>CWL1100</Userid><StartDate></StartDate><EndDate></EndDate><AdmInfo></AdmInfo><PatAmt>90</PatAmt><BankTradeInfo></BankTradeInfo><ExpStr>CBC</ExpStr></Request>

	New (input)
	Set ReturnValue=##class(web.DHCOPBillAutoPayExp).GetBillInfo(input)
	Set Response=##class(%GlobalCharacterStream).%New()
	Set sc=Response.Write(ReturnValue)	
	Quit Response
}

ClassMethod GetBillDetailByAdm(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	/*
	n (input)
	;<Request><CardNo>001100000023750</CardNo><SecrityNo></SecrityNo><Userid>MZSF001</Userid><StartDate></StartDate><EndDate></EndDate><AdmInfo></AdmInfo><PatAmt></PatAmt><BankTradeInfo></BankTradeInfo><ExpStr></ExpStr></Request>

	s returnValue=##class(web.DHCOPBillAutoPayExp).GetBillDetailByAdm(input)	
	q returnValue
	*/
}

/// Lid
/// 2011-03-30
/// 自助机结算
ClassMethod AutoOPBillCharge(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	New (input)
	;<Request><CardNo>6222021602013440567</CardNo><SecrityNo></SecrityNo><Userid>W10000</Userid><StartDate></StartDate><EndDate></EndDate><AdmInfo></AdmInfo><PatAmt>84.2</PatAmt><BankTradeInfo></BankTradeInfo><ExpStr>ICBC</ExpStr></Request>

	
	;w ##class(web.DHCOPBillAutoPaySOAP).AutoOPBillCharge(^Lid("AutoOPBillCharge","Input","2013-03-28","14:59:28"))
	Set ReturnValue=##class(web.DHCOPBillAutoPayExp).AutoOPBillCharge(input)	
	Set Response=##class(%GlobalCharacterStream).%New()
	Set sc=Response.Write(ReturnValue)
	Quit Response
}

ClassMethod InsertBankTradeInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	New (input)
	;"01!10001^00^交易成功^02^9999990100026855^000000000100^000296^^000000000868^^290009510001007^290009510001^^1234567890^^0225^195725^1202^^"
	;<Request><CardNo></CardNo><SecrityNo></SecrityNo><Userid>MZSF001</Userid><StartDate></StartDate><EndDate></EndDate><AdmInfo></AdmInfo><PatAmt></PatAmt><BankTradeInfo>01!10001^00^交易成功^02^9999990100026855^000000000100^000296^^000000000868^^290009510001007^290009510001^^1234567890^^0225^195725^1202^^</BankTradeInfo><ExpStr></ExpStr></Request>

	;w ##class(web.DHCOPBillAutoPaySOAP).InsertBankTradeInfo(^Lid("Input"))
	Set ReturnValue=##class(web.DHCOPBillAutoPayExp).InserBankTradeInfo(input)	
	Set Response=##class(%GlobalCharacterStream).%New()
	Set sc=Response.Write(ReturnValue)	
	Quit Response
}

/// Lid
/// 2011-03-07
/// 字节流测试
ClassMethod TestStream() As %GlobalCharacterStream [ WebMethod ]
{
	;w ##class(web.DHCOPBillAutoPaySOAP).TestStream()
	;%Library.CharacterStream
	;%GlobalCharacterStream
	;%Library.GlobalBinaryStream
	Set newstream=##class(%GlobalCharacterStream).%New()
	s tmp=""
	f i=1:1:2000 d
	.;s tmp=tmp_"a"
	.Set tmp="测试数据流^测试数据流2^测试数据流4^测试数据流5sh9ik^lajdsflakjdf^al0.12ge[12*4]"
	.d newstream.Write(tmp)
	
	/*i 'newstream.AtEnd dt
	.w newstream.Read()
	.w !  051385107561
	*/
	q newstream
}

}
