/// 服务接口对象
Class BILL.EINV.DTO.BSA.ENSReq Extends %RegisteredObject
{

Property appid As %String(CAPTION = "应用帐号", TRUNCATE = 1);

Property data As %String(CAPTION = "请求业务参数", TRUNCATE = 1);

Property noise As %String(CAPTION = "请求随机标识", TRUNCATE = 1);

Property version As %String(CAPTION = "版本号", TRUNCATE = 1);

Property sign As %String(CAPTION = "签名", TRUNCATE = 1);

}
