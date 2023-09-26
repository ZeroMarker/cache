/// Creator:Lid
/// CreatDate:2013-05-31
/// Description:住院收费结算退费请求消息实体类
Class web.DHCEntity.PCA.DHCIPRefundRequest Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter XMLNAME = "Request";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property RefundAmount As %String(MAXLEN = "", XMLNAME = "RefundAmount");

Property RefundList As list Of web.DHCEntity.PCA.RefundInfo(XMLNAME = "RefundList");

}
