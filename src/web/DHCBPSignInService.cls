/// web.DHCBPSignInService
Class web.DHCBPSignInService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCBPSignInService";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://10.160.16.91/dthealth/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// TODO: add arguments and implementation.
/// InsertSignInInfo
Method InsertSignInInfo(PatientInfo As %String = "") As %String [ WebMethod ]
{
	s fromDate=$o(^DHCBPSignInTest("")) //清空前几天的临时数据
	i (fromDate'="")&&(fromDate'=+$h) k ^DHCBPSignInTest(fromDate)
	s Index=$I(^DHCBPSignInTest(+$H,"InsertSignInInfo"))
	s ^DHCBPSignInTest(+$H,"InsertSignInInfo",Index)=PatientInfo
	s Ret=##Class(web.DHCBPSignIn).InsertSignInInfo(PatientInfo)
	//s ^dhcbpmfc("2020")=Ret
	q Ret
}

}
