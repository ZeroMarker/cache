Class DHCEPRFS.ThirdParty.WebService.GE.XieHeGEWebServicePort Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.104.16.153:80/services/XDSDocument";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://med.ge.com/xds/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "XDSDocumentServiceImpl";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method QueryDocument(ID As %String, IDType As %String) As DHCEPRFS.ThirdParty.WebService.GE.XieHeGEWebServiceResult [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("QueryDocument").Invoke($this,"",.ID,.IDType)
}

/// debug: w ##class(DHCEPRFS.ThirdParty.WebService.GE.XieHeGEWebServicePort).Test()
ClassMethod Test()
{
	s service = ##class(DHCEPRFS.ThirdParty.WebService.GE.XieHeGEWebServicePort).%New()
	//w service
	s ret = service.QueryDocument("14556903","ENCOUNTER")
	q ret.TotalPdfPageNumber
}

}
