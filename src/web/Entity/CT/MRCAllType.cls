/// 名称: 过敏原分类
/// 描述: 实体类
/// 编写者：基础数据平台组-孙凤超
/// 编写日期: 2013-09-03
Class web.Entity.CT.MRCAllType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.MRCAllType";

/// MRCATRowId	MRCATCode	MRCATDesc MRCATTagDescription MRCATDateFrom	MRCATDateTo
Property MRCATRowId As %String;

Property MRCATCode As %String;

/// 代码
Property MRCATDesc As %String;

/// 描述
Property MRCATTagDescription As %String;

/// TagDescription
Property MRCATDateFrom As %String;

/// 开始日期
Property MRCATDateTo As %String;

///  结束日期

}
