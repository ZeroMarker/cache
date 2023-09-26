Class DHCExternalService.RegInterface.Entity.SelfReg.List.PatCard Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 登记号
Property PatientID As %String(TRUNCATE = 1);

/// 卡号
Property CardNo As %String(TRUNCATE = 1);

/// 卡类型
Property CardType As %String(TRUNCATE = 1);

/// 卡类型代码
Property CardTypeCode As %String(TRUNCATE = 1);

/// 病人类型
Property PatType As %String(TRUNCATE = 1);

/// 病人姓名
Property PatientName As %String(TRUNCATE = 1);

}
