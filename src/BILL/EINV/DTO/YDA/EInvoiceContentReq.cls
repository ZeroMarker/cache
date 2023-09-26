Class BILL.EINV.DTO.YDA.EInvoiceContentReq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

Property InfoMaster As BILL.EINV.DTO.YDA.EInvoiceContentInfoMasterReq(XMLITEMNAME = "InfoMasters");

Property InfoDetails As list Of BILL.EINV.DTO.YDA.EInvoiceContentInfoDetailsReq(XMLITEMNAME = "InfoDetail");

}
