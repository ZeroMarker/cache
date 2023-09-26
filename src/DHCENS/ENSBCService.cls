Class DHCENS.ENSBCService Extends (%SOAP.WebService, %XML.Adaptor) [ Inheritance = right, ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "ENSBCService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

Parameter LOCATION = "http://192.168.1.70/dthealth/web";

ClassMethod DhcService(funName As %String, input As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	s objStream=##class(%GlobalCharacterStream).%New()

	if (funName="GetDictInfo")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).GetDictInfo(input)
	}

	if (funName="GetPatList")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).GetPatList(input)
	}
    
	if (funName="GetPatInfo")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).GetPatInfo(input)	
	}
	
	if (funName="BookedInfo")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).BookedInfo(input)
	}
	if (funName="CancelBookedInfo")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).CancelBookedInfo(input)
	}
	if (funName="RegInfo")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).RegInfo(input)
	}
	if (funName="AddOrderItem")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).AddOrderItem(input)
	}
	if (funName="ReturnReports")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).ReturnReports(input)
	}
	if (funName="ModifyStatus")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).ModifyStatus(input)
	}
	if (funName="CancelFeeApp")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).CancelFeeApp(input)
	}
	
	if (funName="CancelReport")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).CancelReport(input)
	}
	
	if (funName="GetAppForm")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).GetAppForm(input)
	}
    d ##class(DHCENS.BaseCode.DhcEnsLog).InsertDhcEns("BC",funName,input,objStream)

	q objStream
}

}
