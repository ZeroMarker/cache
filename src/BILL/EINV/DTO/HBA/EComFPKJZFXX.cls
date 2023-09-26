/// 支付信息
Class BILL.EINV.DTO.HBA.EComFPKJZFXX Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property class As %String(XMLPROJECTION = "ATTRIBUTE");

Property ZFFS As %String(CAPTION = "支付方式", XMLNAME = "ZFFS");

Property ZFLSH As %String(CAPTION = "支付流水号", XMLNAME = "ZFLSH");

Property ZFPT As %String(CAPTION = "字符平台", XMLNAME = "ZFPT");

}
