/// 名称:库存-单位转换实体类
/// 编写者:基础平台-陈莹
/// 编写日期: 2012-8-30
Class web.Entity.CT.CTConFac Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTConFac";

//单位RowId

Property CTCFRowId As %String;

//从单位

Property CTCFFrUOMDR As %String;

//到单位

Property CTCFToUOMDR As %String;

//转换系数

Property CTCFFactor As %String;

//激活标识

Property CTCFActiveFlag As %String;

}
