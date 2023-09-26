/// 电子发票配置对象
Class BILL.EINV.DTO.COM.InvConfigCom Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Property AdmReasonInfo As %String(CAPTION = "费别");

Property AdmTypeInfo As %String(CAPTION = "就诊类型");

Property HospitalInfo As %String(CAPTION = "院区");

Property UserGrpInfo As %String(CAPTION = "用户登录安全组");

Property UserInfo As %String(CAPTION = "用户");

Property DepartMent As %String(CAPTION = "科室");

Property PaymodeInfo As %String(CAPTION = "支付方式");

}
