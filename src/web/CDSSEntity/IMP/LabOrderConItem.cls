/// 名称：his检验医嘱和his检验项目（检验小项）关联表
/// 描述：实体类
/// 编写者：基础数据平台组_Xuwenhu
/// 编写日期：2021-07-28
Class web.CDSSEntity.IMP.LabOrderConItem Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.IMP.LabOrderConItem";

Property ID As %String;

/// 检验小项代码
Property LabItemCode As %String;

/// 检验小项描述
Property LabItemDesc As %String;

/// 检验医嘱代码
Property LabOrderCode As %String;

/// 检验医嘱描述
Property LabOrderDesc As %String;

/// 医嘱开始日期
Property LabOrderStartDate As %Date;

/// 医嘱结束日期
Property LabOrderEndDate As %Date;

/// 对照开始日期
Property ConStartDate As %Date;

/// 对照结束日期
Property ConEndDate As %Date;

/// 所属医院
Property DictHosp As %String;

}
