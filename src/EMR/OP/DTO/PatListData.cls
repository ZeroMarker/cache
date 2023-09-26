/// 名称:	EMR.OP.DTO.PatListData
/// 描述:	患者信息
/// 编写者：yejian
/// 编写日期: 2022-6-8
/// 产品组：电子病历产品组
Class EMR.OP.DTO.PatListData Extends EMR.OP.COM.ActionBase
{

/// 登记号
Property PapmiNo As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 就诊卡号
Property CardID As %String(TRUNCATE = 1);

/// 科室ID
Property ExpectedLocId As %String(TRUNCATE = 1);

/// 开始日期
Property StartDate As %Date;

/// 结束日期
Property EndDate As %Date;

/// 审核状态(全部/未审核/已审核/拒绝/作废)
Property CheckStatus As %String(TRUNCATE = 1);

/// 文档类型（ALL/doccode)
Property DocType As %String(TRUNCATE = 1);

/// 产品标识
Property Product As %String(TRUNCATE = 1);

/// 返回分页开始页号
Property StartPage As %String(TRUNCATE = 1);

/// 返回分页结束页号
Property EndPage As %String(TRUNCATE = 1);

/// 病案号
Property MedNo As %String(TRUNCATE = 1);

/// 身份证号
Property IDCardNo As %String(TRUNCATE = 1);

/// 登录科室ID
Property UserLocID As %String(TRUNCATE = 1);

/// 文档ID
Property DocumentID As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 审核者ID
Property AuditUserID As %String(TRUNCATE = 1);

/// 审核状态[checked:审核通过，refused:审核未通过]
Property Status As %String(TRUNCATE = 1);

/// 操作IP
Property OperateMachineIP As %String(TRUNCATE = 1);

/// 语言ID
Property LangID As %String(TRUNCATE = 1);

}
