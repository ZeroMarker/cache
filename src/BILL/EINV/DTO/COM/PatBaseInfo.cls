/// 患者基本信息对象
Class BILL.EINV.DTO.COM.PatBaseInfo Extends %RegisteredObject
{

///  患者唯一ID(患者在业务系统中的唯一标识ID，类似身份证号码。)
Property PAPMINO As %String(CAPTION = "患者唯一ID");

///  患者姓名
Property PatName As %String(CAPTION = "患者姓名");

///  性别
Property Sex As %String(CAPTION = "性别");

///  年龄
Property Age As %String(CAPTION = "年龄");

///  患者身份证号码
Property PatID As %String(CAPTION = "患者身份证号码");

///  患者手机号码
Property Mobphone As %String(CAPTION = "患者手机号码");

///  患者邮箱地址
Property PatEmail As %String(CAPTION = "患者邮箱地址");

///  卡类型
Property CardType As %String(CAPTION = "卡类型");

///  卡号
Property CardNo As %String(CAPTION = "卡号");

///  地址
Property Address As %String(CAPTION = "地址");

}
