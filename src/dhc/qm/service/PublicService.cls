/// dhc.qm.service.PublicService
Class dhc.qm.service.PublicService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "PublicService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// TODO: add arguments and implementation.
/// Test
Method Test() As %String [ WebMethod ]
{
	Quit "Test"
}

ClassMethod RequestMethod(RequestCode As %String = "", RequestXML As %String = "") As %String [ WebMethod ]
{

	q:RequestCode="" ""
	//Set RetStr=##Class(MHC.PublicMedthod).RunMethod(RequestCode,RequestXML)
	s RetStr=""
	i (RequestCode="10101")||(RequestCode="10102") d
	.s RetStr=##class(dhc.qm.udata.uPlan).GetPlanInfo(RequestXML)
	i (RequestCode="10103") d
	.s RetStr=##class(dhc.qm.udata.uPlan).submit(RequestXML)  
	i (RequestCode="20101") d
	.s RetStr=##class(dhc.qm.udata.uComm).GetDepartmentGroup(RequestXML) //作废
	i (RequestCode="20102") d
	.s RetStr=##class(dhc.qm.udata.uComm).GetWard(RequestXML) //作废
	i (RequestCode="20103") d
	.s RetStr=##class(dhc.qm.udata.uComm).GetQMSchem(RequestXML)
	i (RequestCode="30101") d
	.s RetStr=##class(dhc.qm.udata.uPatInfo).GetOperPatList(RequestXML)
	i (RequestCode="30102") d
	.s RetStr=##class(dhc.qm.udata.uPatInfo).InsertInfo(RequestXML)
	i (RequestCode="30103")||(RequestCode="30104") d
	.s RetStr=##class(dhc.qm.udata.uOPerInfo).GetOperInfo(RequestXML)
	i (RequestCode="30105") d
	.s RetStr=##class(dhc.qm.udata.uOPerInfo).GetCheckInfo(RequestXML)
	i (RequestCode="30106") d
	.s RetStr=##class(dhc.qm.udata.uPatInfo).InserChecktInfo(RequestXML)
	i (RequestCode="30201") d
	.s RetStr=##class(dhc.qm.udata.uPatInfo).GetOperList(RequestXML)
	i (RequestCode="30203")||(RequestCode="30204") d
	.s RetStr=##class(dhc.qm.udata.uOPerInfo).GetOper(RequestXML)
	i (RequestCode="30501") d
	.s RetStr=##class(dhc.qm.udata.uPatInfo).GetDifficult(RequestXML)
	i (RequestCode="30401") d
	.s RetStr=##class(dhc.qm.udata.uPatInfo).GetConsult(RequestXML)
	i (RequestCode="30303")||(RequestCode="30304") d
	.s RetStr=##class(dhc.qm.udata.uConsult).GetConsultInfo(RequestXML)
	i (RequestCode="30403")||(RequestCode="30404") d
	.s RetStr=##class(dhc.qm.udata.uDead).GetDeadInfo(RequestXML)
	i (RequestCode="40101") d
	.s RetStr=##class(dhc.qm.udata.uComm).GetSSUser(RequestXML)
	i (RequestCode="40102") d
	.s RetStr=##class(dhc.qm.udata.uComm).GetWardInfoForSelect(RequestXML) //获取病区
	i (RequestCode="40103") d
	.s RetStr=##class(dhc.qm.udata.uOPerInfo).DeleteImageURL(RequestXML)
	i (RequestCode="40104") d
	.s RetStr=##class(dhc.qm.udata.uOPerInfo).GetImageURL(RequestXML)
	i (RequestCode="50101") d
	.s RetStr=##class(dhc.qm.udata.uPatInfo).DeleteInfoFromCheck(RequestXML)
	i (RequestCode="50102") d
	.s RetStr=##class(dhc.qm.udata.uPatInfo).GetDifficultNumList(RequestXML)
	
	Quit RetStr
}

}
