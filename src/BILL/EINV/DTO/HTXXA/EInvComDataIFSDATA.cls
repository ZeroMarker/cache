/// 电子票据数据
Class BILL.EINV.DTO.HTXXA.EInvComDataIFSDATA Extends (%RegisteredObject, %XML.Adaptor)
{

Property ZipCode As %String(CAPTION = "压缩方式", XMLPROJECTION = "ELEMENT");

Property EncryptCode As %String(CAPTION = "加密方式", XMLPROJECTION = "ELEMENT");

Property CACode As %String(CAPTION = "Ca类型", XMLPROJECTION = "ELEMENT");

Property FormatCode As %String(CAPTION = "票据类型", XMLPROJECTION = "ELEMENT");

Property Content As %String(CAPTION = "业务报文内容", XMLPROJECTION = "ELEMENT");

}
