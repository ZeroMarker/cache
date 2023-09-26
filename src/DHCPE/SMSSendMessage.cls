/// DHCPE.SMSSendMessage
Class DHCPE.SMSSendMessage Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "SMS";

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

ClassMethod UpdateMessage(ID, Status, UserID) As %String [ WebMethod ]
{
 //更新
	s ret=##class(web.DHCPE.Message.Main).UpdateMessage(ID,Status,UserID)
	q ret
}

//

ClassMethod FindMessage(QueryName, StartDate = "", EndDate = "", Type, NoSend As %Library.String = "", AutoSend As %Library.String = "") As %XML.DataSet [ WebMethod ]
{
    s ^TMP("sms",1)=$LB(QueryName, StartDate, EndDate,Type,NoSend , AutoSend)
    s LocID=$P(QueryName,"^",2)
    s QueryName=$P(QueryName,"^",1)
    if QueryName="" s QueryName="web.DHCPE.SendMessage.FindMessage"
    if StartDate=$C(0) s StartDate=""
    if EndDate=$C(0) s EndDate=""
    if Type=$C(0) s Type=""
    if NoSend=$C(0) s NoSend=""
    if AutoSend=$C(0) s AutoSend=""
    i +StartDate>"40" d
    .s StartDate=##class(web.DHCPE.ReportGetInfor).Replace(StartDate,"/","-")
    i +EndDate>"40" d
    .s EndDate=##class(web.DHCPE.ReportGetInfor).Replace(EndDate,"/","-")
    s:StartDate[("-") StartDate=$ZDH(StartDate,3)
    s:EndDate[("-") EndDate=$ZDH(EndDate,3)
    s:StartDate[("/") StartDate=$ZDH(StartDate,4)
    s:EndDate[("/") EndDate=$ZDH(EndDate,4)
   Set result=##class(%XML.DataSet).%New(QueryName)
   b ;Start
   d result.SetArgs(StartDate,EndDate,Type,NoSend,AutoSend,"","",LocID)
 
  Quit result
}

}
