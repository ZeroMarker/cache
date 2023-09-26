/// 名称:	EMR.OP.DTO.PatchPrintData
/// 描述:	门诊补打对象
/// 编写者：yejian
/// 编写日期: 2023-3-15
/// 产品组：电子病历产品组
Class EMR.OP.DTO.PatchPrintData Extends %RegisteredObject
{

/// 登记号
Property PapmiNo As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 就诊卡号
Property CardID As %String(TRUNCATE = 1);

/// 开始日期
Property StartDate As %Date;

/// 结束日期
Property EndDate As %Date;

/// 产品标识
Property Product As %String(TRUNCATE = 1);

/// 返回分页开始页号
Property StartPage As %String(TRUNCATE = 1);

/// 返回分页结束页号
Property EndPage As %String(TRUNCATE = 1);

/// 身份证号
Property IDCardNo As %String(TRUNCATE = 1);

/// 文档ID
Property DocumentID As %String(TRUNCATE = 1);

}
