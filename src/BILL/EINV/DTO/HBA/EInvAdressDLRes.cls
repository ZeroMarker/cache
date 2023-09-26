/// 电子发票地址下载返回值
Class BILL.EINV.DTO.HBA.EInvAdressDLRes Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Property class As %String(XMLPROJECTION = "ATTRIBUTE");

Property PDFURL As %String(CAPTION = "发票下载地址", XMLNAME = "PDFURL");

}
