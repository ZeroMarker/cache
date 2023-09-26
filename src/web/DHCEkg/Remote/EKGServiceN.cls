/// web.DHCEkg.Remote.EKGServiceN
Class web.DHCEkg.Remote.EKGServiceN Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "EKGServiceN";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:添加自变量和实施.
/// Test
/// w ##class(web.DHCEkg.Remote.EKGServiceN).Test()
ClassMethod Test() As %String [ WebMethod ]
{
	s obj=##class(%GlobalCharacterStream).%New()
	s str="<RequestInfo><Dept><ekgName>家庭签约科</ekgName><ekgCode>20170315</ekgCode><ekgSpell></ekgSpell><ekgExtend></ekgExtend></Dept><ExamItem><ekgName>null</ekgName><ekgCode>WL0007</ekgCode><ekgSpell></ekgSpell><ekgCharge></ekgCharge></ExamItem><Patient><ekgBirthday>1986-02-20T00:00:00Z</ekgBirthday><ekgGender>m</ekgGender><ekgInpatientCode></ekgInpatientCode><ekgName>李春荣</ekgName><ekgPatientCode>612429201900026</ekgPatientCode></Patient><Request><ekgExecDeptCode>20170315</ekgExecDeptCode><ekgAppointNo></ekgAppointNo><ekgBarcode>612429201900026</ekgBarcode><ekgBedCode></ekgBedCode><ekgClinDiag>连串</ekgClinDiag><ekgExtend>wangcui316</ekgExtend><ekgPatSourceCode>null</ekgPatSourceCode><ekgRequestTime>2019-07-29T16:53:15Z</ekgRequestTime><ekgZone></ekgZone><ekgOrganizationCode>612429</ekgOrganizationCode><ekgOrganizationName>西安市中心医院</ekgOrganizationName><ekgAppOrgCode>612429</ekgAppOrgCode><ekgReqCode>123456</ekgReqCode></Request></RequestInfo>"
	d obj.WriteLine(str)
	s rtn=..SendInfoToEKG(obj)
	Quit rtn
}

ClassMethod SetEKGNameSpace()
{
	zn "DHC-EKG-CL"
}

/// 乡镇卫生院系统发送申请到会诊平台
ClassMethod SendInfoToEKG(inputStream As %GlobalCharacterStream) As %String [ WebMethod ]
{
	
	new $NAMESPACE
	s CurSpace=$ZNSPACE
	do ..SetEKGNameSpace()
	
	s rtnSent=##class(Interface.Remote.BLL.EKGService).SentExamInfo(inputStream)
	zn CurSpace
	q rtnSent
}

/// 基层医疗机构发起会诊时，会诊平台调用该接口更改检查状态
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

/// 调用远程会诊接口改变申请单状态
ClassMethod ChangeReqStatus(barcode As %String, status As %String) As %String
{
	
	s rtn=""
	s inputObj=##class(web.DHCEkg.Remote.Dict.Request).%New()
	s inputObj.appid=barcode
	s inputObj.appState=status
	s Status=inputObj.XMLExportToString(.input)
	
	s obj=##class(web.DHCEkg.Remote.AppStateWServiceHttpSoap12Endpoint).%New()
	s rtn=obj.updateAppState(input)
	
	q rtn
}

/// 通过申请单号获取pdf报告ftp地址
/// w ##class(web.DHCEkg.Remote.EKGServiceN).GetDHCEKGReport("612429201900026")
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
