/// web.DHCEkg.Remote.EKGService
Class web.DHCEkg.Remote.EKGService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "EKGService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

ClassMethod SetEKGNameSpace()
{
	zn "DHC-EKG"
}

/// TODO:添加自变量和实施.
/// SentExamInfo
/// creator:		yangyali
/// createTime:		2018-5-11
/// modify:		
/// modifyTime:		
/// desc:			提供给远程会诊系统，接收医嘱信息，保存到数据库
/// input:			xml结构的流，医嘱信息、科室信息、病人信息
/// output:			保存结果
/// w ##class(web.DHCEkg.Remote.EKGService).SentExamInfo(objStream)
ClassMethod SentExamInfo(inputStream As %GlobalCharacterStream) As %String [ WebMethod ]
{
	new $NAMESPACE
	s CurSpace=$ZNSPACE
	do ..SetEKGNameSpace()
	s rtnSent=##class(Interface.Remote.BLL.EKGService).SentExamInfo(inputStream)
	zn CurSpace
	q rtnSent
}

/// TODO:添加自变量和实施.
/// SentExamInfo
/// creator:		yangyali
/// createTime:		2018-6-8
/// modify:		
/// modifyTime:		
/// desc:			调用远程会诊接口改变申请单状态
/// input:			xml结构的流，
/// 					<Request><appid>申请单号</appid><appState>申请单状态</appState></Request>
/// output:			调用结果
/// w ##class(web.DHCEkg.Remote.EKGService).ChangeReqStatus("172018060700000002","2")
ClassMethod ChangeReqStatus(barcode As %String, status As %String) As %String [ WebMethod ]
{
	s rtn=""
	s inputObj=##class(web.DHCEkg.Remote.Dict.Request).%New()
	s inputObj.appid=barcode
	s inputObj.appState=status
	s Status=inputObj.XMLExportToString(.input)
	s obj=##class(web.DHCEkg.Remote.AppStateWServiceHttpSoap12Endpoint).%New()
	s rtn=obj.appState(input)
	q rtn
}

/// 提供给会诊平台调用，更改心电系统的检查状态
/// w ##class(web.DHCEkg.Remote.EKGService).updateEkgAppState("<Request><appNo>938||BXDT002</appNo><appState>100</appState><orgCode>哈拉哈达</orgCode><orgName>哈拉哈达</orgName></Request>")
ClassMethod updateEkgAppState(XMLInfo As %String) As %String [ WebMethod ]
{
	new $NAMESPACE
	s CurSpace=$ZNSPACE
	do ..SetEKGNameSpace()
	s rtnSent= ##class(Interface.Remote.BLL.EKGService).updateEkgAppState(XMLInfo)
	zn CurSpace
	q rtnSent
}

/// TODO:添加自变量和实施.
/// GetDHCEKGReport
/// creator:		yangyali
/// createTime:		2018-5-14
/// modify:		
/// modifyTime:		
/// desc:			根据[申请单号/医嘱号]获取报告信息
/// input:			string类型，申请单号/医嘱号
/// output:			报告结论，报告路径
/// w ##class(web.DHCEkg.Remote.EKGService).GetDHCEKGReport("172018060800000001")
ClassMethod GetDHCEKGReport(RequestID As %String) As %String [ WebMethod ]
{
	new $NAMESPACE
	s CurSpace=$ZNSPACE
	do ..SetEKGNameSpace()
	s rtnSent=##class(Interface.Remote.BLL.EKGService).GetRptInfo(RequestID)
	zn CurSpace
	q rtnSent
}

}
