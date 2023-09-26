/// 卡类型定义配置, 可变的
Class web.DHCEntity.PCA.CardTypeConfig Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property AccManageFLag As %String(TRUNCATE = 1);

Property CardAccountRelation As %String(TRUNCATE = 1);

/// 费用金额
Property CardFareCost As %String(TRUNCATE = 1);

Property CardRefFlag As %String(TRUNCATE = 1);

/// 费用类型
Property FareType As %String(TRUNCATE = 1);

/// 集团，
/// 个人
/// 注册标志
Property GroupRegFlag As %String(TRUNCATE = 1);

/// 信息来源标志
/// HIS
/// WebService
Property InfoSource As %String(TRUNCATE = 1);

Property PANoCardRefFlag As %String(TRUNCATE = 1);

Property PatMasFlag As %String(TRUNCATE = 1);

Property PreCardFlag As %String(TRUNCATE = 1);

/// 检索Mas信息
Property SearchMasFlag As %String(TRUNCATE = 1);

Property SecurityNoFlag As %String(TRUNCATE = 1);

Property StChangeValidateFlag As %String(TRUNCATE = 1);

/// 用户发票类型
Property UseINVType As %String(TRUNCATE = 1);

}
