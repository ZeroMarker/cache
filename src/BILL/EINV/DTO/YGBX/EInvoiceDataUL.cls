/// 数据采集接口
Class BILL.EINV.DTO.YGBX.EInvoiceDataUL Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "PACKET";

Property Head As BILL.EINV.DTO.YGBX.EInvoiceDataHeadUL(XMLNAME = "Head", XMLPROJECTION = "ELEMENT");

Property Body As BILL.EINV.DTO.YGBX.EInvoiceDataBodyUL(XMLNAME = "Body", XMLPROJECTION = "ELEMENT");

}
