/// Created from: http://172.22.26.178/csp/huaxi/Huaxi.PACS.BS.PACSService.cls?WSDL
Class web.DHCService.CI.Client.CSPCHD Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLNAME = "CSPCHD";

Parameter XMLSEQUENCE = 1;

Property id As %String(TRUNCATE = 1, XMLNAME = "id") [ Required ];

}
