/// Created from: http://10.104.16.153:80/services/XDSDocument?xsd=1
Class DHCEPRFS.ThirdParty.WebService.GE.XieHeGEWebServiceResult Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://med.ge.com/xds/";

Parameter XMLNAME = "queryDocumentResult";

Parameter XMLSEQUENCE = 1;

Property DocumentUniqueIds As list Of %String(MAXLEN = "", XMLITEMNAME = "DocumentUniqueId", XMLNAME = "DocumentUniqueIds", XMLPROJECTION = "COLLECTION");

Property TotalPdfPageNumber As %xsd.int(XMLNAME = "TotalPdfPageNumber") [ Required ];

}
