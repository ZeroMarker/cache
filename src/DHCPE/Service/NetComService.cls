/// 体检网上公用接口
Class DHCPE.Service.NetComService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "DHCPEService";

/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://webservice.dhcpe.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:添加自变量和实施.
/// Test
Method Test() As %String [ WebMethod ]
{
	Quit "Test"
}

/// Descript:统一入口 ，返回%String
/// Input:
/// 				RequestCode:业务代码
/// 				RequestXML:业务代码对应对的参数
/// Return:
/// Creater:wangguoying
ClassMethod RequestSubmit(RequestCode As %String = "", RequestXML As %String = "") As %String [ WebMethod ]
{
	Set $ZTrap = "MessageCatch"
	q:RequestCode="" ""
	Set RetStr=##Class(DHCPE.Service.NetComMethod).RunRequestMethod(RequestCode,RequestXML)
	d ##class(User.DHCPESrvLog).Log(RequestCode,"","",RequestXML,RetStr)
	Quit RetStr
MessageCatch
	Set $ZTrap = ""
	s ResultCode=-100
	s ResultDesc=$ZError
	s ResultDesc=$TR(ResultDesc,"<"," ")
	s ResultDesc=$TR(ResultDesc,">"," ")
	s RetXML="<Response><ResultCode>"_ResultCode_"</ResultCode><ResultDesc>"_ResultDesc_"</ResultDesc></Response>"
	d ##class(User.DHCPESrvLog).Log(RequestCode,"","0",RequestXML,RetXML)
  	Quit RetXML
}

/// Descript:统一入口 ，返回%GlobalCharacterStream
/// Input:
/// 				RequestCode:业务代码
/// 				RequestXML:业务代码对应对的参数
/// Return:
/// Creater:wangguoying
ClassMethod RequestSubmitNew(RequestCode As %String = "", RequestXML As %String = "") As %GlobalCharacterStream [ WebMethod ]
{
	s Stream=##class(%GlobalCharacterStream).%New()	
	Set $ZTrap = "MessageCatch"
	
	i RequestCode=""  d Stream.Write("-1^参数不能为空") q Stream
	
	Set RetStr=##Class(DHCPE.Service.NetComMethod).RunRequestMethodNew(RequestCode,RequestXML)
	d ##class(User.DHCPESrvLog).Log(RequestCode,"","",RequestXML,RetStr)
	q RetStr
MessageCatch
	Set $ZTrap = ""
	s ResultCode=-100
	s ResultDesc=$ZError
	s ResultDesc=$TR(ResultDesc,"<"," ")
	s ResultDesc=$TR(ResultDesc,">"," ")
	s RetXML="<Response><ResultCode>"_ResultCode_"</ResultCode><ResultDesc>"_ResultDesc_"</ResultDesc></Response>"
  	d ##class(User.DHCPESrvLog).Log(RequestCode,"","0",RequestXML,RetXML)
  	d Stream.Write(RetXML)
  	Quit Stream
}

}
