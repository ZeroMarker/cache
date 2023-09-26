/// 名称: 医嘱大类
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-31
Class web.Entity.CT.OECOrderCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.OECOrderCategory";

/// RowId号
Property ORCATRowId As %String;

/// 代码
Property ORCATCode As %String;

/// 描述
Property ORCATDesc As %String;

/// 重复医嘱 Y/N
Property ORCATRepeatInOrder As %String;

/// 医嘱类组 指向OEC_OrderCategoryGroup
Property ORCATOCGroupDR As %String;

}
