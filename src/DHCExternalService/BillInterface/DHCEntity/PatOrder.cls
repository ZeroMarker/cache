/// Creator:Lid
/// CreatDate:2012-02-07
/// Description:病人医嘱信息类
Class DHCExternalService.BillInterface.DHCEntity.PatOrder Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ResultCode
Property ResultCode As %String(TRUNCATE = 1);

/// ErrorMsg
Property ResultContent As %String(TRUNCATE = 1);

/// 卡号
Property CardNO As %String(TRUNCATE = 1);

/// 登记号
Property PatientID As %String(TRUNCATE = 1);

/// 姓名
Property PatName As %String(TRUNCATE = 1);

/// 年龄
Property PatAge As %String(TRUNCATE = 1);

/// 性别
Property PatSex As %String(TRUNCATE = 1);

/// InsuTypeDesc	医嘱费别描述
Property InsuTypeDesc As %String(TRUNCATE = 1);

/// InsuTypeDR	医嘱费别指针
Property InsuTypeDR As %String(TRUNCATE = 1);

/// YBUploadData	医嘱费别指针
Property YBUploadData As %String(TRUNCATE = 1);

Property AdmReasonCount As %String(TRUNCATE = 1);

/// 门诊分类集合
Property AdmReasons As list Of DHCExternalService.BillInterface.DHCEntity.AdmReason;

}
