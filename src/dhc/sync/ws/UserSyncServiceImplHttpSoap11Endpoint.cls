Class dhc.sync.ws.UserSyncServiceImplHttpSoap11Endpoint Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// Non-default attributeFormQualified for types XML namespace.
Parameter ATTRIBUTEQUALIFIED = 1;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.19.19.2/Common_C92_WebService/services/UserSyncServiceImpl.UserSyncServiceImplHttpSoap11Endpoint/";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://service.sync.user.common.dhcc.com";

/// This is the name of the Service
Parameter SERVICENAME = "UserSyncServiceImpl";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method saveData(source As %String, data As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("saveData").Invoke($this,"urn:saveData",.source,.data)
}

XData parameters
{
<parameters xmlns="http://www.intersystems.com/configuration" xmlns:cfg="http://www.intersystems.com/configuration">
  <method name="saveData">
    <request>
      <Action>urn:saveData</Action>
    </request>
    <response>
      <Action>urn:saveDataResponse</Action>
    </response>
  </method>
</parameters>
}

}
