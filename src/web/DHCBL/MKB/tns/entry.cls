/// 创建自: http://58.56.200.232:8082/drg/ws/mrDataExport?wsdl
Class web.DHCBL.MKB.tns.entry Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "MrDataExportService";

Parameter XMLNAME = "entry";

Parameter XMLSEQUENCE = 1;

Property key As %String(MAXLEN = "", XMLNAME = "key");

Property value As %String(MAXLEN = "", XMLNAME = "value");

}
