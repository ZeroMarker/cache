/// 远得开票信息参数组织
Class BILL.EINV.DTO.YDA.EInvoiceReq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

Parameter XMLNAME = "RetData";

Property Command As %String(TRUNCATE = 1);

Property Content As BILL.EINV.DTO.YDA.EInvoiceContentReq(XMLITEMNAME = "Contents");

}
