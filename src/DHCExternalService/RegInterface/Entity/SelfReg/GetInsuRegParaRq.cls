Class DHCExternalService.RegInterface.Entity.SelfReg.GetInsuRegParaRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 操作员代码
Property ExtUserID As %String(TRUNCATE = 1);

/// 卡类型
Property CardType As %String(TRUNCATE = 1);

/// 卡号
Property CardNo As %String(TRUNCATE = 1);

/// 病人唯一号
Property PatientID As %String(TRUNCATE = 1);

/// 门诊排班项代码
Property ScheduleItemCode As %String(TRUNCATE = 1);

/// 医保卡数据
Property InsuCardData As %String(TRUNCATE = 1);

/// 院区Code
Property HospitalId As %String(TRUNCATE = 1);

/// 支付方式代码
Property PayModeCode As %String(TRUNCATE = 1);

/// 费别ID
Property BillTypeID As %String(TRUNCATE = 1);

}
