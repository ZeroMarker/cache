/// Creator:李欣
/// CreatDate:20180510
/// Description：医用知识库评分表注册字段实体类
/// Table：CT.WDT.Access.AssBaseField
Class web.CDSSEntity.Access.AssBaseField Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Access.AssBaseField";

Property MKBABFParRef As %String;

Property MKBABFRowId As %String;

/// 代码
Property MKBABFCode As %String;

/// 展示名
Property MKBABFDesc As %String;

/// 字段类型
Property MKBABFType As %String;

/// 字段配置项
Property MKBABFConfig As %String;

/// 顺序
Property MKBABFSequence As %String;

/// 互斥项
Property MKBABFExclusion As %String;

/// 跳转项
Property MKBABFJumpOption As %String;

}
