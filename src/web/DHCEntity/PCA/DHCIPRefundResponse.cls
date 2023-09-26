/// 
Class web.DHCEntity.PCA.DHCIPRefundResponse Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter XMLNAME = "Response";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property ResponseCode As %String(MAXLEN = "", XMLNAME = "ResponseCode");

Property ResponseMsg As %String(MAXLEN = "", XMLNAME = "ResponseMsg");

Property ResultList As list Of web.DHCEntity.PCA.ResultInfo(XMLNAME = "ResultList");

/// Property ResultList As web.DHCEntity.PCA.ResultInfo(XMLNAME = "ResultList", XMLPROJECTION = "WRAPPED");
/// w ##class(web.DHCEntity.PCA.DHCIPRefundResponse).D()
ClassMethod D()
{
	Set obj=##class(web.DHCEntity.PCA.DHCIPRefundResponse).%New()
	Set obj2=##class(web.DHCEntity.PCA.ResultInfo).%New()
	d obj.ResultList.Insert(obj2)
	s sss=""
	d obj.XMLExportToString(.sss)
	b ;111
	d
}

}
