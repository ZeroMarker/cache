Class BILL.EINV.DTO.HBA.EInvdataDescription Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property zipCode As %String(CAPTION = "是否进行压缩", XMLNAME = "zipCode");

Property encryptCode As %String(CAPTION = "数据描述", XMLNAME = "encryptCode");

Property codeType As %String(CAPTION = "三种加密方式代码，正式使用时通讯用CA", XMLNAME = "codeType");

}
