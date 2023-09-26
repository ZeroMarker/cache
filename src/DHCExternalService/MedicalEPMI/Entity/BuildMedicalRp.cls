Class DHCExternalService.MedicalEPMI.Entity.BuildMedicalRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易结果：0：成功 非0：错误
Property ResultCode As %String(TRUNCATE = 1);

/// 对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// 外部机构建病历，存储到HIS病历信息暂存表(来院后建病历界面：自动带出暂存信息 供建病历使用)
/// 此唯一标识为此病历信息暂存表的RowId
Property UniqueID As %String(TRUNCATE = 1);

}
