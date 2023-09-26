/// DHCENS.ENSService
Class DHCENS.ENSService Extends (%SOAP.WebService, %XML.Adaptor) [ Inheritance = right, ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "ENSService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

Parameter LOCATION = "http://114.255.135.209/dthealth/web";

ClassMethod DhcService(className As %String, funName As %String, input As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	s objStream=##class(%GlobalCharacterStream).%New()
	
	if (className="LIS")&&(funName="GetDictInfo")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).GetDictInfo(input)
	}
	
	if (className="LIS")&&(funName="GetPatInfo")
	{	
		s objStream=##Class(DHCENS.LIS.Method.Interface).GetPatInfo(input)
	}
	
	if (className = "LIS")&&(funName="GetLabOrder")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).GetLabOrder(input)
	}
	if (className="LIS")&&(funName="GetLabOrderList")
	{
		s objStream=##Class(DHCENS.LIS.Method.Interface).GetLabOrderList(input)
	}
	
	if (className="LIS")&&(funName="ModifyStatus")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).ModifyStatus(input)
	}
	
	if (className="LIS")&&(funName="GetOrderStatus")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).GetOrderStatus(input)
	}
	if (className="LIS")&&(funName="CancelFeeApp")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).CancelFeeApp(input)
	}
	
    if (className="LIS")&&(funName="CheckUp")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).CheckUp(input)
	}

    if (className="LIS")&&(funName="Refuse")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).Refuse(input)
	}
	
    if (className="LIS")&&(funName="ReportMsg")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).ReportMsg(input)
	}

	if (className="LIS")&&(funName="AddOrderItem")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).AddOrderItem(input)
	}

	if (className="LIS")&&(funName="GetAmountOfTube")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).GetAmountOfTube(input)
	}

	if (className="BC")&&(funName="GetDictInfo")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).GetDictInfo(input)
	}

	if (className="BC")&&(funName="GetPatList")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).GetPatList(input)
	}
    
	if (className="BC")&&(funName="GetPatInfo")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).GetPatInfo(input)	
	}
	
	if (className="BC")&&(funName="BookedInfo")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).BookedInfo(input)
	}
	if (className="BC")&&(funName="CancelBookedInfo")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).CancelBookedInfo(input)
	}
	if (className="BC")&&(funName="RegInfo")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).RegInfo(input)
	}
	if (className="BC")&&(funName="AddOrderItem")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).AddOrderItem(input)
	}
	if (className="BC")&&(funName="ReturnReports")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).ReturnReports(input)
	}
	if (className="BC")&&(funName="ModifyStatus")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).ModifyStatus(input)
	}
	if (className="BC")&&(funName="CancelFeeApp")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).CancelFeeApp(input)
	}
	
	if (className="BC")&&(funName="CancelReport")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).CancelReport(input)
	}
	
	if (className="BC")&&(funName="GetAppForm")
	{
		s objStream=##class(DHCENS.BC.Method.Interface).GetAppForm(input)
	}
    d ##class(DHCENS.BaseCode.DhcEnsLog).InsertDhcEns("LIS",funName,input,objStream)

	q objStream
}

}
