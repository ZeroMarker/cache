Class BILL.EINV.DTO.YDA.EInvQueryRes Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

Parameter XMLNAME = "RetData";

/// RetCode	返回代码
Property RetCode As %String(TRUNCATE = 1);

/// RetMsg	提示信息
Property RetMsg As %String(TRUNCATE = 1);

/// 查询返回开票信息
Property Invoice As BILL.EINV.DTO.YDA.EInvQueryInvoiceRes;

}
