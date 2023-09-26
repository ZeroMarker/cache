Class DHCWeChatPay.DHCEntity.PCA.RefundList Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ResultCode
Property ResultCode As %String(TRUNCATE = 1);

/// ErrorMsg
Property ErrorMsg As %String(TRUNCATE = 1);

/// RefList
Property RefLists As list Of DHCWeChatPay.DHCEntity.PCA.RefList;

}
