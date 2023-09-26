Class BILL.EINV.DTO.XAA.EInvComReq Extends %RegisteredObject
{

Property appid As %String(CAPTION = "应用账号");

Property nonce As %String(CAPTION = "唯一流水号");

Property timestamp As %String(CAPTION = "时间戳");

Property signature As %String(CAPTION = "防伪码");

}
