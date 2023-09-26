Class BILL.EINV.DTO.AXNHTA.SendBackInvRecordhead Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property binvkind As BILL.EINV.DTO.AXNHTA.OPInvoiceKind;

Property binvcode As %String(CAPTION = "发票代码");

Property binvnr As %String(CAPTION = "发票号码");

/// binvdate
Property binvdate As %String(CAPTION = "发票日期");

// 

Property bmachinenr As %String(CAPTION = "发票日期");

Property bcancelled As %String(CAPTION = "发票日期");

Property invkind As BILL.EINV.DTO.AXNHTA.OPInvoiceKind;

Property doctype As BILL.EINV.DTO.AXNHTA.OPInvoiceDocType;

Property docnr As %String(CAPTION = "发票日期");

Property docdate As %String(CAPTION = "发票日期");

Property custnr As %String(CAPTION = "发票日期");

Property custname As %String(CAPTION = "发票日期");

Property custtaxnr As %String(CAPTION = "发票日期");

Property custaddrtel As %String(CAPTION = "发票日期");

Property custbankacct As %String(CAPTION = "发票日期");

Property memo As %String(CAPTION = "发票日期");

Property memo2 As %String(CAPTION = "发票日期");

Property consignerName As %String(CAPTION = "发票日期");

Property consignerTaxNr As %String(CAPTION = "发票日期");

Property shipperName As %String(CAPTION = "发票日期");

Property shipperTaxNr As %String(CAPTION = "发票日期");

Property originViaArrivalPlace As %String(CAPTION = "发票日期");

Property vehicleKindNo As %String(CAPTION = "发票日期");

Property vehicleTonnage As %String(CAPTION = "发票日期");

Property freightMemo As %String(CAPTION = "发票日期");

Property refinvcode As %String(CAPTION = "发票日期");

Property refinvnr As %String(CAPTION = "发票日期");

Property rednoticenr As %String(CAPTION = "发票日期");

Property issuer As %String(CAPTION = "发票日期");

Property checker As %String(CAPTION = "发票日期");

Property payee As %String(CAPTION = "发票日期");

Property sellerbankacct As %String(CAPTION = "发票日期");

Property selleraddresstel As %String(CAPTION = "发票日期");

Property totalamount As %String(CAPTION = "发票日期");

Property totaltax As %String(CAPTION = "发票日期");

Property isList As %String(CAPTION = "发票日期");

Property taxDeduction As %String(CAPTION = "发票日期");

Property invStock As %String(CAPTION = "发票日期");

Property includeTax As %String(CAPTION = "发票日期");

Property printCount As %String(CAPTION = "打印次数");

Property uploadstate As %String(CAPTION = "更新状态");

Property uploaderrmsg As %String(CAPTION = "发票日期");

Property checkcode As %String(CAPTION = "发票日期");

Property cipher As %String(CAPTION = "发票日期");

Property sign As %String(CAPTION = "签名");

Property emails As %String(CAPTION = "邮箱");

}
