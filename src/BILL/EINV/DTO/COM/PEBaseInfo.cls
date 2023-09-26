Class BILL.EINV.DTO.COM.PEBaseInfo Extends %RegisteredObject
{

///  发票名称
Property PrintName As %String(CAPTION = "发票名称");

/// 纳税人识别号
Property TaxpayerNum As %String(CAPTION = "纳税人识别号");

///  费用类型  I个人  G单位
Property InvType As %String(CAPTION = "费用类型");

}
