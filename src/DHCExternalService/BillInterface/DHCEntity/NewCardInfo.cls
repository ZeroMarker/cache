Class DHCExternalService.BillInterface.DHCEntity.NewCardInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 卡类型
Property CardTypeRowID As %String(TRUNCATE = 1);

/// 卡号
Property CardNo As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 性别 
Property Sex As %String(TRUNCATE = 1);

/// 出生日期
Property Birth As %String(TRUNCATE = 1);

/// 联系电话
Property TelHome As %String(TRUNCATE = 1);

/// 住址
Property Address As %String(TRUNCATE = 1);

/// 身份证号码
Property IDCardNo As %String(TRUNCATE = 1);

/// 病人类型
Property PatType As %String(TRUNCATE = 1);

/// 需要绑定其他卡标记
Property BindFlag As %String(TRUNCATE = 1);

/// 绑定的病人ID
Property PAPMIRowID As %String(TRUNCATE = 1);

/// 操作用户UserDR
Property UserDR As %String(TRUNCATE = 1);

}
