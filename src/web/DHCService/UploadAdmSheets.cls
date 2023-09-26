Include (%occInclude, %soap)

Class web.DHCService.UploadAdmSheets Extends %SOAP.MsgDescriptor [ ClassType = "", Not ProcedureBlock ]
{

Parameter NAMESPACE = "http://tempuri.org";

Parameter SOAPBINDINGSTYLE = "document";

Parameter SOAPBODYUSE = "literal";

Parameter TYPENAMESPACE = "http://tempuri.org";

Parameter XMLDEFAULTREFERENCE = "complete";

Parameter XMLRESULTNAME = "%Result";

Property %Result As %GlobalCharacterStream(CLASSNAME = 1, XMLIO = "OUT", XMLNAME = "UploadAdmSheetsResult");

Property EpisodeID As %Library.String(TRUNCATE = 1, XMLIO = "IN");

Property ReqDate As %Library.String(TRUNCATE = 1, XMLIO = "IN");

}
