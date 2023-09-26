/// 发票库存信息查询返回值
Class BILL.EINV.DTO.HBA.EInvKCQueryRes Extends %RegisteredObject
{

Property class As %String(XMLPROJECTION = "ATTRIBUTE");

Property SYFPFS As %String(CAPTION = "剩余发票数", XMLNAME = "SYFPFS");

Property RETURNCODE As %String(CAPTION = "返回状态码", XMLNAME = "RETURNCODE");

Property RETURNMSG As %String(CAPTION = "返回信息说明", XMLNAME = "RETURNMSG");

}
