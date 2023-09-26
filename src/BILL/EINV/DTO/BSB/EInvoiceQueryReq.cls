Class BILL.EINV.DTO.BSB.EInvoiceQueryReq Extends %RegisteredObject
{

/// busNo	流水号	String	32	是	单位内唯一
Property busNo As %String(CAPTION = "业务流水号");

/// agencyId	单位识别码	String	32	是	由票据云分配，唯一
Property agencyId As %String(CAPTION = "单位识别码");

}
