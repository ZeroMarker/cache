Class web.DHCENS.STBLL.BOOKREG.SOAP.SaveDictServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://192.168.128.134/csp/oep/DHC.OEP.BS.SaveDictInfo.SaveDictInfo.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "SaveDictService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method SaveDeptDict(Input As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SaveDeptDict").Invoke($this,"http://tempuri.org/DHC.OEP.BS.SaveDictInfo.SaveDictInfo.SaveDeptDict",.Input)
}

Method SaveDoctorDict(Input As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SaveDoctorDict").Invoke($this,"http://tempuri.org/DHC.OEP.BS.SaveDictInfo.SaveDictInfo.SaveDoctorDict",.Input)
}

Method SaveHospitalInfo(Input As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SaveHospitalInfo").Invoke($this,"http://tempuri.org/DHC.OEP.BS.SaveDictInfo.SaveDictInfo.SaveHospitalInfo",.Input)
}

Method SaveRBApptScheduleInfo(Input As %GlobalCharacterStream) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SaveRBApptScheduleInfo").Invoke($this,"http://tempuri.org/DHC.OEP.BS.SaveDictInfo.SaveDictInfo.SaveRBApptScheduleInfo",.Input)
}

}
