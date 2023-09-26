/// 名称: 病人回家原因
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-29
Class web.Entity.CT.PACReasonforLeave Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACReasonforLeave";

/// RowId
Property RFLRowId As %String;

/// 代码
Property RFLCode As %String;

/// 描述
Property RFLDesc As %String;

}
